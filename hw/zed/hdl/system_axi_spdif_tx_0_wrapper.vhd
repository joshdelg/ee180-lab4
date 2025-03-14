-------------------------------------------------------------------------------
-- system_axi_spdif_tx_0_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library axi_spdif_tx_v1_00_a;
use axi_spdif_tx_v1_00_a.all;

entity system_axi_spdif_tx_0_wrapper is
  port (
    S_AXI_ACLK : in std_logic;
    S_AXI_ARESETN : in std_logic;
    S_AXI_AWADDR : in std_logic_vector(31 downto 0);
    S_AXI_AWVALID : in std_logic;
    S_AXI_WDATA : in std_logic_vector(31 downto 0);
    S_AXI_WSTRB : in std_logic_vector(3 downto 0);
    S_AXI_WVALID : in std_logic;
    S_AXI_BREADY : in std_logic;
    S_AXI_ARADDR : in std_logic_vector(31 downto 0);
    S_AXI_ARVALID : in std_logic;
    S_AXI_RREADY : in std_logic;
    S_AXI_ARREADY : out std_logic;
    S_AXI_RDATA : out std_logic_vector(31 downto 0);
    S_AXI_RRESP : out std_logic_vector(1 downto 0);
    S_AXI_RVALID : out std_logic;
    S_AXI_WREADY : out std_logic;
    S_AXI_BRESP : out std_logic_vector(1 downto 0);
    S_AXI_BVALID : out std_logic;
    S_AXI_AWREADY : out std_logic;
    S_AXIS_ACLK : in std_logic;
    S_AXIS_ARESETN : in std_logic;
    S_AXIS_TREADY : out std_logic;
    S_AXIS_TDATA : in std_logic_vector(31 downto 0);
    S_AXIS_TLAST : in std_logic;
    S_AXIS_TVALID : in std_logic;
    DMA_REQ_ACLK : in std_logic;
    DMA_REQ_RSTN : in std_logic;
    DMA_REQ_DAVALID : in std_logic;
    DMA_REQ_DATYPE : in std_logic_vector(1 downto 0);
    DMA_REQ_DRREADY : in std_logic;
    DMA_REQ_DRVALID : out std_logic;
    DMA_REQ_DRTYPE : out std_logic_vector(1 downto 0);
    DMA_REQ_DRLAST : out std_logic;
    DMA_REQ_DAREADY : out std_logic;
    spdif_data_clk : in std_logic;
    spdif_tx_o : out std_logic
  );
end system_axi_spdif_tx_0_wrapper;

architecture STRUCTURE of system_axi_spdif_tx_0_wrapper is

  component axi_spdif_tx is
    generic (
      C_S_AXI_DATA_WIDTH : INTEGER;
      C_S_AXI_ADDR_WIDTH : INTEGER;
      C_S_AXI_MIN_SIZE : std_logic_vector;
      C_BASEADDR : std_logic_vector;
      C_HIGHADDR : std_logic_vector;
      C_FAMILY : STRING;
      C_DMA_TYPE : INTEGER
    );
    port (
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector((C_S_AXI_ADDR_WIDTH-1) downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_WDATA : in std_logic_vector((C_S_AXI_DATA_WIDTH-1) downto 0);
      S_AXI_WSTRB : in std_logic_vector(((C_S_AXI_DATA_WIDTH/8)-1) downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector((C_S_AXI_ADDR_WIDTH-1) downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_RREADY : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector((C_S_AXI_DATA_WIDTH-1) downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXIS_ACLK : in std_logic;
      S_AXIS_ARESETN : in std_logic;
      S_AXIS_TREADY : out std_logic;
      S_AXIS_TDATA : in std_logic_vector(31 downto 0);
      S_AXIS_TLAST : in std_logic;
      S_AXIS_TVALID : in std_logic;
      DMA_REQ_ACLK : in std_logic;
      DMA_REQ_RSTN : in std_logic;
      DMA_REQ_DAVALID : in std_logic;
      DMA_REQ_DATYPE : in std_logic_vector(1 downto 0);
      DMA_REQ_DRREADY : in std_logic;
      DMA_REQ_DRVALID : out std_logic;
      DMA_REQ_DRTYPE : out std_logic_vector(1 downto 0);
      DMA_REQ_DRLAST : out std_logic;
      DMA_REQ_DAREADY : out std_logic;
      spdif_data_clk : in std_logic;
      spdif_tx_o : out std_logic
    );
  end component;

begin

  axi_spdif_tx_0 : axi_spdif_tx
    generic map (
      C_S_AXI_DATA_WIDTH => 32,
      C_S_AXI_ADDR_WIDTH => 32,
      C_S_AXI_MIN_SIZE => X"000001ff",
      C_BASEADDR => X"75c00000",
      C_HIGHADDR => X"75c0ffff",
      C_FAMILY => "zynq",
      C_DMA_TYPE => 1
    )
    port map (
      S_AXI_ACLK => S_AXI_ACLK,
      S_AXI_ARESETN => S_AXI_ARESETN,
      S_AXI_AWADDR => S_AXI_AWADDR,
      S_AXI_AWVALID => S_AXI_AWVALID,
      S_AXI_WDATA => S_AXI_WDATA,
      S_AXI_WSTRB => S_AXI_WSTRB,
      S_AXI_WVALID => S_AXI_WVALID,
      S_AXI_BREADY => S_AXI_BREADY,
      S_AXI_ARADDR => S_AXI_ARADDR,
      S_AXI_ARVALID => S_AXI_ARVALID,
      S_AXI_RREADY => S_AXI_RREADY,
      S_AXI_ARREADY => S_AXI_ARREADY,
      S_AXI_RDATA => S_AXI_RDATA,
      S_AXI_RRESP => S_AXI_RRESP,
      S_AXI_RVALID => S_AXI_RVALID,
      S_AXI_WREADY => S_AXI_WREADY,
      S_AXI_BRESP => S_AXI_BRESP,
      S_AXI_BVALID => S_AXI_BVALID,
      S_AXI_AWREADY => S_AXI_AWREADY,
      S_AXIS_ACLK => S_AXIS_ACLK,
      S_AXIS_ARESETN => S_AXIS_ARESETN,
      S_AXIS_TREADY => S_AXIS_TREADY,
      S_AXIS_TDATA => S_AXIS_TDATA,
      S_AXIS_TLAST => S_AXIS_TLAST,
      S_AXIS_TVALID => S_AXIS_TVALID,
      DMA_REQ_ACLK => DMA_REQ_ACLK,
      DMA_REQ_RSTN => DMA_REQ_RSTN,
      DMA_REQ_DAVALID => DMA_REQ_DAVALID,
      DMA_REQ_DATYPE => DMA_REQ_DATYPE,
      DMA_REQ_DRREADY => DMA_REQ_DRREADY,
      DMA_REQ_DRVALID => DMA_REQ_DRVALID,
      DMA_REQ_DRTYPE => DMA_REQ_DRTYPE,
      DMA_REQ_DRLAST => DMA_REQ_DRLAST,
      DMA_REQ_DAREADY => DMA_REQ_DAREADY,
      spdif_data_clk => spdif_data_clk,
      spdif_tx_o => spdif_tx_o
    );

end architecture STRUCTURE;

