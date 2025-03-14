//-----------------------------------------------------------------------------
// system_stub.v
//-----------------------------------------------------------------------------

module system_stub
  (
    processing_system7_0_MIO,
    processing_system7_0_PS_SRSTB,
    processing_system7_0_PS_CLK,
    processing_system7_0_PS_PORB,
    processing_system7_0_DDR_Clk,
    processing_system7_0_DDR_Clk_n,
    processing_system7_0_DDR_CKE,
    processing_system7_0_DDR_CS_n,
    processing_system7_0_DDR_RAS_n,
    processing_system7_0_DDR_CAS_n,
    processing_system7_0_DDR_WEB_pin,
    processing_system7_0_DDR_BankAddr,
    processing_system7_0_DDR_Addr,
    processing_system7_0_DDR_ODT,
    processing_system7_0_DDR_DRSTB,
    processing_system7_0_DDR_DQ,
    processing_system7_0_DDR_DM,
    processing_system7_0_DDR_DQS,
    processing_system7_0_DDR_DQS_n,
    processing_system7_0_DDR_VRN,
    processing_system7_0_DDR_VRP,
    hdmi_spdif,
    hdmi_int,
    otg_reset,
    otg_vbusoc,
    util_vector_logic_0_Op1_pin,
    axi_i2s_adi_0_BCLK_O_pin,
    axi_i2s_adi_0_LRCLK_O_pin,
    axi_i2s_adi_0_SDATA_I_pin,
    axi_i2s_adi_0_SDATA_O_pin,
    axi_i2s_adi_0_MCLK_pin,
    util_i2c_mixer_0_downstream_scl_pin,
    util_i2c_mixer_0_downstream_sda_pin,
    processing_system7_0_GPIO_pin,
    axi_iic_1_Sda_pin,
    axi_iic_1_Scl_pin,
    int_1_pin,
    int_2_pin,
    int_3_pin,
    int_4_pin,
    processing_system7_0_SPI0_SCLK_O_pin,
    processing_system7_0_SPI0_MOSI_O_pin,
    processing_system7_0_SPI0_MISO_I_pin,
    processing_system7_0_SPI0_SS_O_pin,
    processing_system7_0_SPI1_SCLK_O_pin,
    processing_system7_0_SPI1_MOSI_O_pin,
    processing_system7_0_SPI1_MISO_I_pin,
    processing_system7_0_SPI1_SS_O_pin
  );
  inout [53:0] processing_system7_0_MIO;
  input processing_system7_0_PS_SRSTB;
  input processing_system7_0_PS_CLK;
  input processing_system7_0_PS_PORB;
  inout processing_system7_0_DDR_Clk;
  inout processing_system7_0_DDR_Clk_n;
  inout processing_system7_0_DDR_CKE;
  inout processing_system7_0_DDR_CS_n;
  inout processing_system7_0_DDR_RAS_n;
  inout processing_system7_0_DDR_CAS_n;
  output processing_system7_0_DDR_WEB_pin;
  inout [2:0] processing_system7_0_DDR_BankAddr;
  inout [14:0] processing_system7_0_DDR_Addr;
  inout processing_system7_0_DDR_ODT;
  inout processing_system7_0_DDR_DRSTB;
  inout [31:0] processing_system7_0_DDR_DQ;
  inout [3:0] processing_system7_0_DDR_DM;
  inout [3:0] processing_system7_0_DDR_DQS;
  inout [3:0] processing_system7_0_DDR_DQS_n;
  inout processing_system7_0_DDR_VRN;
  inout processing_system7_0_DDR_VRP;
  output hdmi_spdif;
  input hdmi_int;
  output otg_reset;
  input otg_vbusoc;
  input [0:0] util_vector_logic_0_Op1_pin;
  output axi_i2s_adi_0_BCLK_O_pin;
  output axi_i2s_adi_0_LRCLK_O_pin;
  input axi_i2s_adi_0_SDATA_I_pin;
  output axi_i2s_adi_0_SDATA_O_pin;
  output axi_i2s_adi_0_MCLK_pin;
  inout [1:0] util_i2c_mixer_0_downstream_scl_pin;
  inout [1:0] util_i2c_mixer_0_downstream_sda_pin;
  inout [30:0] processing_system7_0_GPIO_pin;
  inout axi_iic_1_Sda_pin;
  inout axi_iic_1_Scl_pin;
  input int_1_pin;
  input int_2_pin;
  input int_3_pin;
  input int_4_pin;
  output processing_system7_0_SPI0_SCLK_O_pin;
  output processing_system7_0_SPI0_MOSI_O_pin;
  input processing_system7_0_SPI0_MISO_I_pin;
  output processing_system7_0_SPI0_SS_O_pin;
  output processing_system7_0_SPI1_SCLK_O_pin;
  output processing_system7_0_SPI1_MOSI_O_pin;
  input processing_system7_0_SPI1_MISO_I_pin;
  output processing_system7_0_SPI1_SS_O_pin;

  (* BOX_TYPE = "user_black_box" *)
  system
    system_i (
      .processing_system7_0_MIO ( processing_system7_0_MIO ),
      .processing_system7_0_PS_SRSTB ( processing_system7_0_PS_SRSTB ),
      .processing_system7_0_PS_CLK ( processing_system7_0_PS_CLK ),
      .processing_system7_0_PS_PORB ( processing_system7_0_PS_PORB ),
      .processing_system7_0_DDR_Clk ( processing_system7_0_DDR_Clk ),
      .processing_system7_0_DDR_Clk_n ( processing_system7_0_DDR_Clk_n ),
      .processing_system7_0_DDR_CKE ( processing_system7_0_DDR_CKE ),
      .processing_system7_0_DDR_CS_n ( processing_system7_0_DDR_CS_n ),
      .processing_system7_0_DDR_RAS_n ( processing_system7_0_DDR_RAS_n ),
      .processing_system7_0_DDR_CAS_n ( processing_system7_0_DDR_CAS_n ),
      .processing_system7_0_DDR_WEB_pin ( processing_system7_0_DDR_WEB_pin ),
      .processing_system7_0_DDR_BankAddr ( processing_system7_0_DDR_BankAddr ),
      .processing_system7_0_DDR_Addr ( processing_system7_0_DDR_Addr ),
      .processing_system7_0_DDR_ODT ( processing_system7_0_DDR_ODT ),
      .processing_system7_0_DDR_DRSTB ( processing_system7_0_DDR_DRSTB ),
      .processing_system7_0_DDR_DQ ( processing_system7_0_DDR_DQ ),
      .processing_system7_0_DDR_DM ( processing_system7_0_DDR_DM ),
      .processing_system7_0_DDR_DQS ( processing_system7_0_DDR_DQS ),
      .processing_system7_0_DDR_DQS_n ( processing_system7_0_DDR_DQS_n ),
      .processing_system7_0_DDR_VRN ( processing_system7_0_DDR_VRN ),
      .processing_system7_0_DDR_VRP ( processing_system7_0_DDR_VRP ),
      .hdmi_spdif ( hdmi_spdif ),
      .hdmi_int ( hdmi_int ),
      .otg_reset ( otg_reset ),
      .otg_vbusoc ( otg_vbusoc ),
      .util_vector_logic_0_Op1_pin ( util_vector_logic_0_Op1_pin[0:0] ),
      .axi_i2s_adi_0_BCLK_O_pin ( axi_i2s_adi_0_BCLK_O_pin ),
      .axi_i2s_adi_0_LRCLK_O_pin ( axi_i2s_adi_0_LRCLK_O_pin ),
      .axi_i2s_adi_0_SDATA_I_pin ( axi_i2s_adi_0_SDATA_I_pin ),
      .axi_i2s_adi_0_SDATA_O_pin ( axi_i2s_adi_0_SDATA_O_pin ),
      .axi_i2s_adi_0_MCLK_pin ( axi_i2s_adi_0_MCLK_pin ),
      .util_i2c_mixer_0_downstream_scl_pin ( util_i2c_mixer_0_downstream_scl_pin ),
      .util_i2c_mixer_0_downstream_sda_pin ( util_i2c_mixer_0_downstream_sda_pin ),
      .processing_system7_0_GPIO_pin ( processing_system7_0_GPIO_pin ),
      .axi_iic_1_Sda_pin ( axi_iic_1_Sda_pin ),
      .axi_iic_1_Scl_pin ( axi_iic_1_Scl_pin ),
      .int_1_pin ( int_1_pin ),
      .int_2_pin ( int_2_pin ),
      .int_3_pin ( int_3_pin ),
      .int_4_pin ( int_4_pin ),
      .processing_system7_0_SPI0_SCLK_O_pin ( processing_system7_0_SPI0_SCLK_O_pin ),
      .processing_system7_0_SPI0_MOSI_O_pin ( processing_system7_0_SPI0_MOSI_O_pin ),
      .processing_system7_0_SPI0_MISO_I_pin ( processing_system7_0_SPI0_MISO_I_pin ),
      .processing_system7_0_SPI0_SS_O_pin ( processing_system7_0_SPI0_SS_O_pin ),
      .processing_system7_0_SPI1_SCLK_O_pin ( processing_system7_0_SPI1_SCLK_O_pin ),
      .processing_system7_0_SPI1_MOSI_O_pin ( processing_system7_0_SPI1_MOSI_O_pin ),
      .processing_system7_0_SPI1_MISO_I_pin ( processing_system7_0_SPI1_MISO_I_pin ),
      .processing_system7_0_SPI1_SS_O_pin ( processing_system7_0_SPI1_SS_O_pin )
    );

endmodule

module system
  (
    processing_system7_0_MIO,
    processing_system7_0_PS_SRSTB,
    processing_system7_0_PS_CLK,
    processing_system7_0_PS_PORB,
    processing_system7_0_DDR_Clk,
    processing_system7_0_DDR_Clk_n,
    processing_system7_0_DDR_CKE,
    processing_system7_0_DDR_CS_n,
    processing_system7_0_DDR_RAS_n,
    processing_system7_0_DDR_CAS_n,
    processing_system7_0_DDR_WEB_pin,
    processing_system7_0_DDR_BankAddr,
    processing_system7_0_DDR_Addr,
    processing_system7_0_DDR_ODT,
    processing_system7_0_DDR_DRSTB,
    processing_system7_0_DDR_DQ,
    processing_system7_0_DDR_DM,
    processing_system7_0_DDR_DQS,
    processing_system7_0_DDR_DQS_n,
    processing_system7_0_DDR_VRN,
    processing_system7_0_DDR_VRP,
    hdmi_spdif,
    hdmi_int,
    otg_reset,
    otg_vbusoc,
    util_vector_logic_0_Op1_pin,
    axi_i2s_adi_0_BCLK_O_pin,
    axi_i2s_adi_0_LRCLK_O_pin,
    axi_i2s_adi_0_SDATA_I_pin,
    axi_i2s_adi_0_SDATA_O_pin,
    axi_i2s_adi_0_MCLK_pin,
    util_i2c_mixer_0_downstream_scl_pin,
    util_i2c_mixer_0_downstream_sda_pin,
    processing_system7_0_GPIO_pin,
    axi_iic_1_Sda_pin,
    axi_iic_1_Scl_pin,
    int_1_pin,
    int_2_pin,
    int_3_pin,
    int_4_pin,
    processing_system7_0_SPI0_SCLK_O_pin,
    processing_system7_0_SPI0_MOSI_O_pin,
    processing_system7_0_SPI0_MISO_I_pin,
    processing_system7_0_SPI0_SS_O_pin,
    processing_system7_0_SPI1_SCLK_O_pin,
    processing_system7_0_SPI1_MOSI_O_pin,
    processing_system7_0_SPI1_MISO_I_pin,
    processing_system7_0_SPI1_SS_O_pin
  );
  inout [53:0] processing_system7_0_MIO;
  input processing_system7_0_PS_SRSTB;
  input processing_system7_0_PS_CLK;
  input processing_system7_0_PS_PORB;
  inout processing_system7_0_DDR_Clk;
  inout processing_system7_0_DDR_Clk_n;
  inout processing_system7_0_DDR_CKE;
  inout processing_system7_0_DDR_CS_n;
  inout processing_system7_0_DDR_RAS_n;
  inout processing_system7_0_DDR_CAS_n;
  output processing_system7_0_DDR_WEB_pin;
  inout [2:0] processing_system7_0_DDR_BankAddr;
  inout [14:0] processing_system7_0_DDR_Addr;
  inout processing_system7_0_DDR_ODT;
  inout processing_system7_0_DDR_DRSTB;
  inout [31:0] processing_system7_0_DDR_DQ;
  inout [3:0] processing_system7_0_DDR_DM;
  inout [3:0] processing_system7_0_DDR_DQS;
  inout [3:0] processing_system7_0_DDR_DQS_n;
  inout processing_system7_0_DDR_VRN;
  inout processing_system7_0_DDR_VRP;
  output hdmi_spdif;
  input hdmi_int;
  output otg_reset;
  input otg_vbusoc;
  input [0:0] util_vector_logic_0_Op1_pin;
  output axi_i2s_adi_0_BCLK_O_pin;
  output axi_i2s_adi_0_LRCLK_O_pin;
  input axi_i2s_adi_0_SDATA_I_pin;
  output axi_i2s_adi_0_SDATA_O_pin;
  output axi_i2s_adi_0_MCLK_pin;
  inout [1:0] util_i2c_mixer_0_downstream_scl_pin;
  inout [1:0] util_i2c_mixer_0_downstream_sda_pin;
  inout [30:0] processing_system7_0_GPIO_pin;
  inout axi_iic_1_Sda_pin;
  inout axi_iic_1_Scl_pin;
  input int_1_pin;
  input int_2_pin;
  input int_3_pin;
  input int_4_pin;
  output processing_system7_0_SPI0_SCLK_O_pin;
  output processing_system7_0_SPI0_MOSI_O_pin;
  input processing_system7_0_SPI0_MISO_I_pin;
  output processing_system7_0_SPI0_SS_O_pin;
  output processing_system7_0_SPI1_SCLK_O_pin;
  output processing_system7_0_SPI1_MOSI_O_pin;
  input processing_system7_0_SPI1_MISO_I_pin;
  output processing_system7_0_SPI1_SS_O_pin;
endmodule

