----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/27/2023 04:11:54 AM
-- Design Name: 
-- Module Name: main - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY main IS
  PORT (clk: in std_logic;
        ok: in std_logic;
        am: in std_logic;    ---0 automat, 1 manual
        t_30,t_40,t_60,t_90: in std_logic;
        v_800,v_1000,v_1200: in std_logic;
        PR: in std_logic;           
        CS: in std_logic;
        SR,CAM,CI,RM,AA: in std_logic;
        start: in std_logic;
        reset: in std_logic;
        led_am, led_30,led_40,led_60,led_90,led_800,led_1000,led_1200,led_PR,led_CS,led_doorlock: out std_logic;
       -- stare: out std_logic_vector(8 downto 0)
        PRESP, H , SP_P, CLAT_P, CLAT_S, CEN: out std_logic
    );
END main;
architecture Behavioral of main is
component CU IS
  PORT (clk: in std_logic;
        ok: in std_logic;
        am: in std_logic;    ---0 automat, 1 manual
        t_30,t_40,t_60,t_90: in std_logic;
        v_800,v_1000,v_1200: in std_logic;
        PR: in std_logic;           
        CS: in std_logic;
        SR,CAM,CI,RM,AA: in std_logic;
        start: in std_logic;
        reset: in std_logic;
        led_am, led_30,led_40,led_60,led_90,led_800,led_1000,led_1200,led_PR,led_CS,led_doorlock: out std_logic
       -- stare: out std_logic_vector(8 downto 0)
        
    );
END component CU;

component COUNTER IS
  PORT (
 CLK1S: in std_logic;
         T30,T40,T60,T90: in std_logic;
         PR,CS: in std_logic;
         EN: in std_logic;
         PRESP, H , SP_P, CLAT_P, CLAT_S, CEN: out std_logic;
         TIMP: out std_logic_vector(8 downto 0);
         INIT: out std_logic_vector(8 downto 0)
         
    );
END component COUNTER;
begin


end Behavioral;