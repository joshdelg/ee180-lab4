/*
 * File         : sobel_control.v
 * Project      : EE180 Sobel accelerator lab
 * Creator(s)   : Samuel Grossman
 *
 * Standards/Formatting:
 *   4 soft tab, wide column.
 *
 * Description:
 *  Controls the flow of the Sobel accelerator core so that
 *  it processes the entire contents of an input buffer and
 *  fills an output buffer with the results of the computation.
 */

`include "common_defines.v"

module sobel_control
#(
    parameter   IOBUF_ADDR_WIDTH                = 32,                               // input and output buffer address width
    parameter   IMAGE_DIM_WIDTH                 = 10,                               // image size control register width
    parameter   STATUS_REG_WIDTH                = 32                                // status register width
)
(
    // Clock and reset ports
    input                                       clk,
    input                                       reset,
    
    // System-wide control signals
    input                                       go,
    
    // Interface: Sobel Control -> Memory (input and output buffers)
    output  [IOBUF_ADDR_WIDTH-1:0]              sctl2srt_read_addr,                 // input buffer read address
    output  [IOBUF_ADDR_WIDTH-1:0]              sctl2swt_write_addr,                // output buffer write address
    output  [`NUM_SOBEL_ACCELERATORS-1:0]       sctl2swt_write_en,                  // output buffer write enable, per output pixel
    
    // Interface: Sobel Control -> Sobel Image Row Registers
    output  [`SOBEL_ROW_OP_WIDTH-1:0]           sctl2srow_row_op,                   // Sobel row register command
    
    // External command register signals
    input   [IMAGE_DIM_WIDTH-1:0]               stop2sctl_image_n_rows,             // number of rows in the input image data
    input   [IMAGE_DIM_WIDTH-1:0]               stop2sctl_image_n_cols,             // number of columns in the input image data
    
    // External status register signals
    output  [STATUS_REG_WIDTH-1:0]              sctl2stop_status                    // status indicator, contains "done" bit, "error" bit, and accelerator's state
);

// State definitions
localparam  STATE_WIDTH                         = 4;                                // not a state, just says "state signals shall be 4 bits wide"
localparam  STATE_WAIT                          = 'h0;                              // waiting for the host system to send an external command to start the accelerator
localparam  STATE_LOADING_1                     = 'h1;                              // reading in the first row of a new column strip (no calculations yet)
localparam  STATE_LOADING_2                     = 'h2;                              // reading in the second row of a new column strip (no calculations yet)
localparam  STATE_LOADING_3                     = 'h3;                              // reading in the third row of a new column strip (no calculations yet)
localparam  STATE_PROCESSING_CALC               = 'h4;                              // calculating the Sobel convolution and producing an output
localparam  STATE_PROCESSING_LOADSS             = 'h5;                              // loading in the next row in the current column strip
localparam  STATE_PROCESSING_CALC_LAST          = 'h6;                              // calculating the Sobel convolution and producing an output for the last row in the current column strip
localparam  STATE_PROCESSING_LOADSS_LAST        = 'h7;                              // loading in the last row in the current column strip
localparam  STATE_PROCESSING_DONE               = 'h8;                              // completed processing the entire image buffer, waiting for action from the host system
localparam  STATE_ERROR                         = 'hf;                              // an error occurred (should never get here)

// Internal signals
wire        [STATE_WIDTH-1:0]                   state;                          // state signal, driven by register
reg         [STATE_WIDTH-1:0]                   state_next;                     // next state signal, drives register
wire        [IMAGE_DIM_WIDTH-1:0]               control_n_rows;                 // number of rows, from control register
wire        [IMAGE_DIM_WIDTH-1:0]               control_n_cols;                 // number of columns, from control register
wire        [IMAGE_DIM_WIDTH-1:0]               row_counter;                    // row counter signal, driven by register
reg         [IMAGE_DIM_WIDTH-1:0]               row_counter_next;               // next row counter signal, drives register
wire        [IMAGE_DIM_WIDTH-1:0]               col_strip;                      // column strip signal, driven by register
reg         [IMAGE_DIM_WIDTH-1:0]               col_strip_next;                 // next column strip signal, drives register
wire        [IOBUF_ADDR_WIDTH-1:0]              buf_read_offset;                // read offset from the input buffer, driven by register
reg         [IOBUF_ADDR_WIDTH-1:0]              buf_read_offset_next;           // read offset from the input buffer, drives register
wire        [IOBUF_ADDR_WIDTH-1:0]              buf_write_offset;               // write offset to the output buffer, driven by register
reg         [IOBUF_ADDR_WIDTH-1:0]              buf_write_offset_next;          // write offset to the output buffer, drives register
reg                                             buf_write_en;                   // write enable signal, driven combinationally
wire        [IMAGE_DIM_WIDTH-1:0]               buf_write_row_incr;             // specifies the row increment for output, equals input width minus 2, driven combinationally
wire        [IMAGE_DIM_WIDTH-1:0]               next_col_strip;                 // specifies the next column strip to process, equals current column strip + number of accelerators

                                                                                // @joshdelg This mad confusing... but Ed says this is actually the INDEX OF THE LAST COL
                                                                                // we will be processing in the final column strip
wire        [IMAGE_DIM_WIDTH-1:0]               max_col_strip;                  // specifies the highest column strip to process before being done, equals the number of columns - number of accelerators
reg         [`SOBEL_ROW_OP_WIDTH-1:0]           row_op;                         // specifies the command to send to the Sobel image row registers
wire        [`NUM_SOBEL_ACCELERATORS-1:0]       pixel_write_en;                 // per-pixel write enable signal
genvar                                          i;

// Output generation
assign      sctl2srt_read_addr                  = buf_read_offset;
assign      sctl2swt_write_addr                 = buf_write_offset;
assign      sctl2srow_row_op                    = row_op;
assign      sctl2stop_status                    = {{STATUS_REG_WIDTH-STATE_WIDTH-2{1'b0}}, state, (state == STATE_ERROR), (state == STATE_PROCESSING_DONE)};
assign      sctl2swt_write_en                   = go ? pixel_write_en : 'h0;

// Registers
dffr #(STATE_WIDTH)                     state_r (                               // main state register
    .clk                                        (clk),
    .r                                          (reset),
    .d                                          (state_next),
    .q                                          (state)
);

dffre #(IMAGE_DIM_WIDTH)                control_n_rows_r (                      // control register: number of rows in input image data
    .clk                                        (clk),
    .r                                          (reset),
    .en                                         (state == STATE_WAIT),
    .d                                          (stop2sctl_image_n_rows),
    .q                                          (control_n_rows)
);

dffre #(IMAGE_DIM_WIDTH)                control_n_cols_r (                      // control register: number of columns in input image data
    .clk                                        (clk),
    .r                                          (reset),
    .en                                         (state == STATE_WAIT),
    .d                                          (stop2sctl_image_n_cols),
    .q                                          (control_n_cols)
);

dffre #(IMAGE_DIM_WIDTH)                row_counter_r (                         // row counter register
    .clk                                        (clk),
    .r                                          (reset),
    .en                                         (go),
    .d                                          (row_counter_next),
    .q                                          (row_counter)
);

dffre #(IMAGE_DIM_WIDTH)                col_strip_r (                           // column strip register
    .clk                                        (clk),
    .r                                          (reset),
    .en                                         (go),
    .d                                          (col_strip_next),
    .q                                          (col_strip)
);

dffre #(IOBUF_ADDR_WIDTH)               buf_read_offset_r (                     // read offset register
    .clk                                        (clk),
    .r                                          (reset),
    .en                                         (go),
    .d                                          (buf_read_offset_next),
    .q                                          (buf_read_offset)
);

dffre #(IOBUF_ADDR_WIDTH)               buf_write_offset_r (                    // write offset register
    .clk                                        (clk),
    .r                                          (reset),
    .en                                         (go),
    .d                                          (buf_write_offset_next),
    .q                                          (buf_write_offset)
);


/* *** *** *** YOUR CODE GOES BELOW THIS LINE *** *** *** */


// *** Row address increment ***
// The value of this signal specifies the width of an output row.

// @joshdelg Spec says each output row has input_cols - 2, since 1 pixel = 1 byte, this is control_n_cols - 2
assign      buf_write_row_incr                  = control_n_cols - 2;

// *** Column strip increment ***
// The value of this signal specifies the start column of the next column strip.

// @joshdelg Should equal current col strip + number of accelerators
assign      next_col_strip                      = col_strip + `NUM_SOBEL_ACCELERATORS;

// *** Column strip maximum ***
// The value of this signal is the termination condition.
// What is the highest possible value of col_strip that indicates there are still more input pixels to process?

// @joshdelg This is the value col_strip_next will take on when we are on out last col_strip
assign      max_col_strip                       = control_n_cols - `NUM_SOBEL_ACCELERATORS;

generate
for (i = 0; i < `NUM_SOBEL_ACCELERATORS; i = i + 1) begin: sobel_write_en

// *** Write enable ***
// If pixel_write_en[i] is set to 1, this tells the memory system that the current pixel at index i from the Sobel accelerator contains valid data to be written.
// Make sure to only set it to 1 when the Sobel accelerator is producing valid data at that pixel position.

// @joshdelg We should write data when we're in either calculation state
// @joshdelg though this is probably just for turning off processors, since we only have 2
// @joshdelg and images are even, we could probably make this always on
assign      pixel_write_en[i]                   = (state == STATE_PROCESSING_CALC || state == STATE_PROCESSING_CALC_LAST);

end
endgenerate

// *** State transitions (combinational circuitry) ***
// Insert your state transition code where indicated.
// You should only write to the "state_next" signal in this block, no others.
always @ (*) begin
    // Default behavior is to maintain the current state.
    state_next                                  = state;
    
    case (state)
        STATE_WAIT: begin
            if (go) begin
                // *** Wait state ***
                // Once the host sends the "go" command, the accelerator starts.
                // This state's implementation is complete and provided as an example.
                state_next                      = STATE_LOADING_1;
            end
            
            // Note that here is no need to specify "else" here because the default behavior is to hold current state.
            // You only need to specify the conditions that warrant a state change.
        end
        
        STATE_LOADING_1: begin
            if (go) begin
                // *** Row 1 loading state ***
                // @joshdelg Updated state
                state_next                      = STATE_LOADING_2;
            end
        end
        
        STATE_LOADING_2: begin
            if (go) begin
                // *** Row 2 loading state ***
                // @joshdelg Updated state
                state_next                      = STATE_LOADING_3;
            end
        end
        
        STATE_LOADING_3: begin
            if (go) begin
                // *** Row 3 loading state ***
                // @joshdelg Updated state
                state_next                      = STATE_PROCESSING_CALC;
            end
        end
        
        STATE_PROCESSING_CALC: begin
            if (go) begin
                // *** Calculation state ***
                // @joshdelg If not 2nd to last row -> STATE_PROC_LOADSS
                // @joshdelg If 2nd to last row -> STATE_PROC_LOADSS_LAST
                // @joshdelg Inside CALC, the row counter will always be the row index relative to the INPUT image
                state_next                      = (row_counter == control_n_rows - 3) ? STATE_PROCESSING_LOADSS_LAST : STATE_PROCESSING_LOADSS;
            end
        end
        
        STATE_PROCESSING_LOADSS: begin
            if (go) begin
                // *** Next row loading state ***
                // Insert your state transition code here.
                // @joshdelg Udpated state
                state_next                      = STATE_PROCESSING_CALC;
            end
        end
        
        STATE_PROCESSING_CALC_LAST: begin
            if (go) begin
                // *** Last-row-in-column-strip calculation state ***
                // @joshdelg If doing last column -> STATE_PROC_DONE
                // @joshdelg If NOT doing last cols -> STATE_LOADING_1

                // @joshdelg Inside CALC_LAST the col_strip will not be updated yet
                state_next                      = (next_col_strip == max_col_strip) ? STATE_PROCESSING_DONE : STATE_LOADING_1;
            end
        end
        
        STATE_PROCESSING_LOADSS_LAST: begin
            if (go) begin
                // *** Last-row-in-column loading state ***
                // @joshdelg Updated state
                state_next                      = STATE_PROCESSING_CALC_LAST;
            end
        end
        
        STATE_PROCESSING_DONE: begin
            if (~go) begin
                // *** Processing completed state ***
                // In this state, the accelerator is waiting for action from the host system.
                // Its implementation is complete as given.
                state_next                      = STATE_WAIT;
            end
        end
        
        STATE_ERROR: begin
            if (go) begin
                // *** Error state ***
                // The accelerator should never get to this state.
                // However, once it is here, it will never leave.
                state_next                      = STATE_ERROR;
            end
        end
        
        default: begin
            if (go) begin
                // *** Catch-all default ***
                // In case of anything unpredicted, will cause an error.
                state_next                      = STATE_ERROR;
            end
        end
    endcase
end

// *** Row register command generation (combinational circuitry) ***
// The job of this block is to send commands to the row register, based on the current state.
// The commands are defined as macros in "sobel_defines.v"; look there to see what the valid commands are.
// When using macros, remember to add the ` character before the name, such as `SOBEL_ROW_OP_HOLD (just SOBEL_ROW_OP_HOLD won't work).
// You should only write to the "row_op" signal in this block, no others.
// Insert your code where indicated.

// @joshdelg -- This part is instantaneous! Not flip-flopped.
always @ (*) begin
    // What is the correct default behavior? Place your command here.
    // row_op                                      = 'h0;

    // @joshdelg Default behavior is to hold
    row_op                                      = `SOBEL_ROW_OP_HOLD;
    
    case (state)
        STATE_WAIT: begin
            // @joshdelg Should hold while waiting
            row_op                              = `SOBEL_ROW_OP_HOLD;
        end
        
        STATE_LOADING_1: begin
            // @joshdelg Should shift if loading
            row_op                              = `SOBEL_ROW_OP_SHIFT_ROW;
        end
        
        STATE_LOADING_2: begin
            // @joshdelg Should shift if loading
            row_op                              = `SOBEL_ROW_OP_SHIFT_ROW;
        end
        
        STATE_LOADING_3: begin
            // @joshdelg Should shift if loading
            row_op                              = `SOBEL_ROW_OP_SHIFT_ROW;
        end
        
        STATE_PROCESSING_CALC: begin
            // @joshdelg If calculating, should hold
            row_op                              = `SOBEL_ROW_OP_HOLD;
        end
        
        STATE_PROCESSING_LOADSS: begin
            // @joshdelg If loading, should shift register once to get 1 new row
            row_op                              = `SOBEL_ROW_OP_SHIFT_ROW;
        end
        
        STATE_PROCESSING_CALC_LAST: begin
            // @joshdelf If calculating, should hold
            row_op                              = `SOBEL_ROW_OP_HOLD;
        end
        
        STATE_PROCESSING_LOADSS_LAST: begin
            // @joshdelg If loading, should shift register once to get 1 new row
            row_op                              = `SOBEL_ROW_OP_SHIFT_ROW;
        end
        
        STATE_PROCESSING_DONE: begin
            // TODO: @joshdelg If done, should hold
            row_op                              = `SOBEL_ROW_OP_HOLD;
        end
        
        STATE_ERROR: begin
            // @johdelg In error, should hold
            row_op                              = `SOBEL_ROW_OP_HOLD;
        end
        
        default: begin
            // @joshdelg IN default case let's just hold
            row_op                              = `SOBEL_ROW_OP_HOLD;
        end
    endcase
end

// *** Row counter (combinational circuitry) ***
// The job of this block is to keep track of the row number the accelerator is currently processing.
// How the row counter changes is related to the current state of the accelerator's state machine.
// You should only write to the "row_counter_next" signal in this block, no others.
// Insert your code where indicated.


// @joshdelg Row Incrementation Scheme
// row_counter = index of current calculation relative to INPUT (or, 1 + index relative to OUTPUT)
// row_counter incremented on LOADS
always @ (*) begin
    // Default behavior is to maintain the current row number.
    row_counter_next                            = row_counter;
    
    case (state)
        STATE_WAIT: begin
            row_counter_next                    = 'h0;
        end
        
        STATE_LOADING_1: begin
            row_counter_next                    = 'h0;
        end
        
        STATE_LOADING_2: begin
            row_counter_next                    = 'h0;
        end
        
        STATE_LOADING_3: begin
            row_counter_next                    = row_counter + 1;
        end
        
        STATE_PROCESSING_CALC: begin
            row_counter_next                    = row_counter;
        end
        
        STATE_PROCESSING_LOADSS: begin
            row_counter_next                    = row_counter + 1;
        end
        
        STATE_PROCESSING_CALC_LAST: begin
            // @joshdelg Must reset row back to 0 when starting new col strip
            row_counter_next                    = 'h0;
        end
        
        STATE_PROCESSING_LOADSS_LAST: begin
            row_counter_next                    = row_counter + 1;
        end
        
        STATE_PROCESSING_DONE: begin
            row_counter_next                    = 'h0;
        end
        
        STATE_ERROR: begin
            row_counter_next                    = 'h0;
        end
        
        default: begin
            row_counter_next                    = 'h0;
        end
    endcase
end

// *** Column strip counter (combinational circuitry) ***
// The job of this block is to keep track of the column strip number the accelerator is currently processing.
// Note that "column strip" refers to the starting pixel, within a given row, that goes to the accelerator's input.
// For example, with 2 accelerators accepting 4 bytes of input, if column strip is 2, then the accelerators expect columns 2, 3, 4, and 5 as input for each row.
// You should only write to the "col_strip_next" signal in this block, no others.
// Insert your code where indicated.

// @joshdelg Col Strip Strategy
// - Col Strip should be reset to 0 when done or while waiting
// - Col Strip should only be incremented (by cores=2) on CALC_LAST
// - Otherwise, Col Strip should be maintained

always @ (*) begin
    // Default behavior is to maintain the current column strip.
    col_strip_next                              = col_strip;
    
    case (state)
        STATE_WAIT: begin
            col_strip_next                      = 'h0;
        end
        
        STATE_LOADING_1: begin
            col_strip_next                      = col_strip;
        end
        
        STATE_LOADING_2: begin
            col_strip_next                      = col_strip;
        end
        
        STATE_LOADING_3: begin
            col_strip_next                      = col_strip;
        end
        
        STATE_PROCESSING_CALC: begin
            col_strip_next                      = col_strip;
        end
        
        STATE_PROCESSING_LOADSS: begin
            col_strip_next                      = col_strip;
        end
        
        STATE_PROCESSING_CALC_LAST: begin
            col_strip_next                      = next_col_strip;
        end
        
        STATE_PROCESSING_LOADSS_LAST: begin
            col_strip_next                      = col_strip;
        end
        
        STATE_PROCESSING_DONE: begin
            col_strip_next                      = 'h0;
        end
        
        STATE_ERROR: begin
            col_strip_next                      = 'h0;
        end
        
        default: begin
            col_strip_next                      = 'h0;
        end
    endcase
end

// *** Read address/offset calculation (combinational circuitry) ***
// The job of this block is to calculate the correct read address to send to memory.
// The read address currently being sent to memory is "buf_read_offset", so here we calculate what should be next.
// Recall that the read address equals the pixel offset from the beginning of the image.
// Since images are stored in row-major order, the read address would be equal to (row number * row width) + (column number).
// You should only write to the "buf_read_offset_next" signal in this block, no others.
// Insert your code where indicated.

// @joshdelg Strategy
// !! DATA IS AVAILABLE IN SHIFT REG 2 CYCLES AFTER REQUESTED
// Thus, we issue requests in LOADSS/LOADSS_LAST for what the subsequent LOADSS/LOADSS_LAST will need
// Since reads take 2 cycles, we should initiate a read of Row 1 as soon as "go" is high
//      - (A read of Row 0 is sorta initiated by default since the address is 0 while WAITing)
// LOADING_1 should kick off the load for Row 2
// LOADING_2 just maintains because loads for the first 3 rows have already been initiated
// LOADING_3 should kick off the load for Row 3 the first one requires by LOADSS
// LOADSS_LAST should initiate the load for Row 0 of the next column strip
// CALC_LAST should initiate the load for Row 1 of the next column strip

always @ (*) begin
    // What is the correct default behavior? Place your code here.
    buf_read_offset_next                        = 'h0;
    
    case (state)
        STATE_WAIT: begin
            if (go) begin
                // Once the control signal is asserted, does something need to happen?
                // Think about what the next state is going to be and what data the accelerator expects to get.

                buf_read_offset_next            = buf_read_offset + control_n_cols;
            end else begin
                // If there is no control signal, just read from the beginning of the image.
                // This part is provided for you.
                buf_read_offset_next            = 'h0;
            end
        end
        
        STATE_LOADING_1: begin
            buf_read_offset_next                =  buf_read_offset + control_n_cols;
        end
        
        STATE_LOADING_2: begin
            buf_read_offset_next                = buf_read_offset;
        end
        
        STATE_LOADING_3: begin
            buf_read_offset_next                = buf_read_offset + control_n_cols;
        end
        
        STATE_PROCESSING_CALC: begin
            buf_read_offset_next                = buf_read_offset;
        end
        
        STATE_PROCESSING_LOADSS: begin
            buf_read_offset_next                = buf_read_offset + control_n_cols;
        end
        
        STATE_PROCESSING_CALC_LAST: begin
            buf_read_offset_next                = buf_read_offset + control_n_cols;
        end
        
        STATE_PROCESSING_LOADSS_LAST: begin
            buf_read_offset_next                = next_col_strip;
        end
        
        STATE_PROCESSING_DONE: begin
            buf_read_offset_next                = 'h0;
        end
        
        STATE_ERROR: begin
            buf_read_offset_next                = 'h0;
        end
        
        default: begin
            buf_read_offset_next                = 'h0;
        end
    endcase
end

// *** Write address/offset calculation (combinational circuitry) ***
// The job of this block is to calculate the correct write address to send to memory.
// The write address currently being sent to memory is "buf_write_offset", so here we calculate what should be next.
// Recall that the write address equals the pixel offset from the beginning of the image.
// Also, the size of the output image is different from the size of the input image!
// You should only write to the "buf_write_offset_next" signal in this block, no others.
// Insert your code where indicated.

// @joshdelg Strategy
// Unlike reads, writes will happen immediately with their given address
// So, we need addressed to be vaild in CALC stages, so we set next in LOADSS stages
// by incrementing by a row of the OUTPUT image
// In CALC_LAST, we need to set the next right address to the new column offset at row 0

always @ (*) begin
    buf_write_offset_next                       =  'h0;
    
    case (state)
        STATE_WAIT: begin
            buf_write_offset_next               = 'h0;
        end
        
        STATE_LOADING_1: begin
            buf_write_offset_next               = buf_write_offset;
        end
        
        STATE_LOADING_2: begin
            buf_write_offset_next               = buf_write_offset;
        end
        
        STATE_LOADING_3: begin
            buf_write_offset_next               = buf_write_offset;
        end
        
        STATE_PROCESSING_CALC: begin
            buf_write_offset_next               = buf_write_offset;
        end
        
        STATE_PROCESSING_LOADSS: begin
            buf_write_offset_next               = buf_write_offset + buf_write_row_incr;
        end
        
        STATE_PROCESSING_CALC_LAST: begin
            buf_write_offset_next               = next_col_strip;
        end
        
        STATE_PROCESSING_LOADSS_LAST: begin
            buf_write_offset_next               = buf_write_offset + buf_write_row_incr;
        end
        
        STATE_PROCESSING_DONE: begin
            buf_write_offset_next               = 'h0;
        end
        
        STATE_ERROR: begin
            buf_write_offset_next               = 'h0;
        end
        
        default: begin
            buf_write_offset_next               = 'h0;
        end
    endcase
end

// *** Write enable generation (combinational circuitry) ***
// The job of this block is to determine whether the data currently being sent to memory is valid.
// The validity of output data depends on the current state; the accelerator cores are always producing data, but it is sometimes garbage and sometimes valid.
// Unless this signal is set to 1, the output buffer will ignore any attempts to write to it.
// This signal is an overall validity signal that does not take into account individual pixels; for that, look up at the sctl2swt_write_en[] signal family.
// Note that, unlike for read and write addresses, this signal corresponds to the state of affairs in the current cycle when it is assigned.
// So if it is set to 1, it means that the address supplied by "buf_write_offset" is immediately valid in its current form.
// You should only write to the "buf_write_en" signal in this block, no others.
// Insert your code where indicated.

// @joshdelg no flip flop, so should be on in calculation stages
always @ (*) begin
    buf_write_en                                = 1'b0;
    
    case (state)
        STATE_WAIT: begin
            buf_write_en                        = 1'b0;
        end
        
        STATE_LOADING_1: begin
            buf_write_en                        = 1'b0;
        end
        
        STATE_LOADING_2: begin
            buf_write_en                        = 1'b0;
        end
        
        STATE_LOADING_3: begin
            buf_write_en                        = 1'b0;
        end
        
        STATE_PROCESSING_CALC: begin
            buf_write_en                        = 1'b1;
        end
        
        STATE_PROCESSING_LOADSS: begin
            buf_write_en                        = 1'b0;
        end
        
        STATE_PROCESSING_CALC_LAST: begin
            buf_write_en                        = 1'b1;
        end
        
        STATE_PROCESSING_LOADSS_LAST: begin
            buf_write_en                        = 1'b0;
        end
        
        STATE_PROCESSING_DONE: begin
            buf_write_en                        = 1'b0;
        end
        
        STATE_ERROR: begin
            buf_write_en                        = 1'b0;
        end
        
        default: begin
            buf_write_en                        = 1'b0;
        end
    endcase
end

endmodule
