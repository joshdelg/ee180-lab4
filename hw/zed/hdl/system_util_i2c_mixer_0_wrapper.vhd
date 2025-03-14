-------------------------------------------------------------------------------
-- system_util_i2c_mixer_0_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library util_i2c_mixer_v1_00_a;
use util_i2c_mixer_v1_00_a.all;

entity system_util_i2c_mixer_0_wrapper is
  port (
    upstream_scl_T : in std_logic;
    upstream_sda_T : in std_logic;
    upstream_scl_I : in std_logic;
    upstream_sda_I : in std_logic;
    upstream_scl_O : out std_logic;
    upstream_sda_O : out std_logic;
    downstream_scl_I : in std_logic_vector(1 downto 0);
    downstream_scl_O : out std_logic_vector(1 downto 0);
    downstream_scl_T : out std_logic;
    downstream_sda_I : in std_logic_vector(1 downto 0);
    downstream_sda_O : out std_logic_vector(1 downto 0);
    downstream_sda_T : out std_logic
  );
end system_util_i2c_mixer_0_wrapper;

architecture STRUCTURE of system_util_i2c_mixer_0_wrapper is

  component util_i2c_mixer is
    generic (
      C_WIDTH : integer
    );
    port (
      upstream_scl_T : in std_logic;
      upstream_sda_T : in std_logic;
      upstream_scl_I : in std_logic;
      upstream_sda_I : in std_logic;
      upstream_scl_O : out std_logic;
      upstream_sda_O : out std_logic;
      downstream_scl_I : in std_logic_vector(C_WIDTH-1 downto 0);
      downstream_scl_O : out std_logic_vector(C_WIDTH-1 downto 0);
      downstream_scl_T : out std_logic;
      downstream_sda_I : in std_logic_vector(C_WIDTH-1 downto 0);
      downstream_sda_O : out std_logic_vector(C_WIDTH-1 downto 0);
      downstream_sda_T : out std_logic
    );
  end component;

begin

  util_i2c_mixer_0 : util_i2c_mixer
    generic map (
      C_WIDTH => 2
    )
    port map (
      upstream_scl_T => upstream_scl_T,
      upstream_sda_T => upstream_sda_T,
      upstream_scl_I => upstream_scl_I,
      upstream_sda_I => upstream_sda_I,
      upstream_scl_O => upstream_scl_O,
      upstream_sda_O => upstream_sda_O,
      downstream_scl_I => downstream_scl_I,
      downstream_scl_O => downstream_scl_O,
      downstream_scl_T => downstream_scl_T,
      downstream_sda_I => downstream_sda_I,
      downstream_sda_O => downstream_sda_O,
      downstream_sda_T => downstream_sda_T
    );

end architecture STRUCTURE;

