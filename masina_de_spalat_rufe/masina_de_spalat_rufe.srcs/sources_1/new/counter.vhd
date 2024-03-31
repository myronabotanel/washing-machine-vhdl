--------------------------------------------------------------------------------
-- Project :
-- File    :
-- Autor   :
-- Date    :
--
--------------------------------------------------------------------------------
-- Description :
--
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

ENTITY COUNTER IS
  PORT (
 CLK1S: in std_logic;
         T30,T40,T60,T90: in std_logic;
         PR,CS: in std_logic;
         EN: in std_logic;
         PRESP, H , SP_P, CLAT_P, CLAT_S, CEN, DO: out std_logic;
         TIMP: out std_logic_vector(8 downto 0);
         INIT: out std_logic_vector(8 downto 0)
         
    );
END COUNTER;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE TypeArchitecture OF COUNTER IS

signal 
COUNT: std_logic_vector(8 downto 0):=(others=>'0');
signal INITIAL_VALUE: std_logic_vector(8 downto 0):=(others=>'0');
signal THPR,TPR,THSP, TCS: integer:=0;
signal TSP: integer:=20;
signal TCP, TC: integer:=10;



signal temperatura: std_logic_vector(4 downto 0);


BEGIN
INIT<=INITIAL_VALUE;
temperatura<=PR & T90 & T60 & T40 & T30;


with temperatura select THPR<=1 when "10100",
                              2 when "11000",
                              0 when others;

with temperatura(3 downto 0) select THSP<=1 when "0100",
                                          2 when "1000",
                                          0 when others;
                                       
TPR<=10 when PR='1';
TCS<=10 when CS='1';

--COUNT<=std_logic_vector(to_unsigned(THPR+TPR+THSP+TSP+TCP+TCS+TC,9)) when EN_INT='1';




process(CLK1S,EN)
begin
if EN='1' then
COUNT<=std_logic_vector(to_unsigned(THPR+TPR+THSP+TSP+TCP+TCS+TC,9));
INITIAL_VALUE<=COUNT;
elsif rising_edge(CLK1S) and  COUNT/="000000000" then 
COUNT<=COUNT-1;
end if;
end process;

process(COUNT)
begin
if COUNT>0 then
if conv_integer(COUNT)>conv_integer(INITIAL_VALUE)-THPR then
PRESP<='0'; H<='1'; SP_P<='0'; CLAT_P<='0'; CLAT_S<='0'; CEN<='0'; 
elsif conv_integer(COUNT)>conv_integer(INITIAL_VALUE)-THPR-TPR then
PRESP<='1'; H<='0'; SP_P<='0'; CLAT_P<='0'; CLAT_S<='0'; CEN<='0'; 
elsif  conv_integer(COUNT)>conv_integer(INITIAL_VALUE)-THPR-TPR-THSP then
PRESP<='0'; H<='1'; SP_P<='0'; CLAT_P<='0'; CLAT_S<='0'; CEN<='0'; 
elsif  conv_integer(COUNT)>conv_integer(INITIAL_VALUE)-THPR-TPR-THSP-TSP then
PRESP<='0'; H<='0'; SP_P<='1'; CLAT_P<='0'; CLAT_S<='0'; CEN<='0'; 
elsif  conv_integer(COUNT)>conv_integer(INITIAL_VALUE)-THPR-TPR-THSP-TSP-TCP then
PRESP<='0'; H<='0'; SP_P<='0'; CLAT_P<='1'; CLAT_S<='0'; CEN<='0'; 
elsif  conv_integer(COUNT)>conv_integer(INITIAL_VALUE)-THPR-TPR-THSP-TSP-TCP-TCS then
PRESP<='0'; H<='0'; SP_P<='0'; CLAT_P<='0'; CLAT_S<='1'; CEN<='0'; DO<='0';
elsif  conv_integer(COUNT)>conv_integer(INITIAL_VALUE)-THPR-TPR-THSP-TSP-TCP-TCS-TC then
PRESP<='0'; H<='0'; SP_P<='0'; CLAT_P<='0'; CLAT_S<='0'; CEN<='1'; 
end if;
else
PRESP<='0'; H<='0'; SP_P<='0'; CLAT_P<='0'; CLAT_S<='0'; CEN<='0';
end if;
end process;

DO<='1' when conv_integer(COUNT)=0 else '0';

TIMP<=COUNT;

END TypeArchitecture;
