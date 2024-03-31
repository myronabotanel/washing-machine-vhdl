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

ENTITY CU IS
  PORT (
clk: in std_logic;
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
        stare: out std_logic_vector(8 downto 0)
        
    );
END CU;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE TypeArchitecture OF CU IS


type program_t is (PU,PSR,PCAM,PCI,PRM,PAA);
signal PROGRAM: program_t:=PU;

type state is (idle,a,c,j,o,q,p,n);
signal current_state, next_state: state:=idle;

type temperatura_t is (tU,t30,t40,t60,t90);
signal TEMP: temperatura_t:=tU;

type viteza_t is (vU,v800,v1000,v1200);
signal VIT: viteza_t:=vU;

signal AUT_MAN: std_logic:='0';                 --0 automat, 1 manual

signal PRESP: std_logic:='0';
signal CLSUP: std_logic:='0';

signal EN_DOOR: std_logic:='0';

signal temperatura: std_logic_vector(3 downto 0);
signal viteza: std_logic_vector(2 downto 0);
signal programe: std_logic_vector(4 downto 0);




BEGIN

--------------------------------------------- mux for temperatura
temperatura<=t_90 & t_60 & t_40 & t_30;
---------------------------------------------  mux for viteza
viteza<=v_1200 & v_1000 & v_800;
--------------------------------------------- mux for programe
programe<=AA & RM & CI & CAM & SR;
---------------------------------------------transition process

transition:process (clk)
begin
if rising_edge(clk) then
current_state<=next_state;
end if;
end process;

---------------------------------------------next state process / inputs
stare_urmatoare: process (temperatura, viteza, programe, ok, PR,CS,am,current_state)
begin
case current_state is
---------------------------------------------- state idle
when idle => 
       PROGRAM<=PU;
       TEMP<=tU;
        VIT<=vU;
        PRESP<='0';
        CLSUP<='0';
        EN_DOOR<='0';
          if ok='1' then 
            if am='1' then
                AUT_MAN<='1';
                next_state<=a;
             else
               next_state<=q;
                end if;
            else
                next_state<=idle;
            end if;
----------------------------------------------- state a
 when a =>
 case temperatura is
 ----------------------------------------------- temp 30
    when "0001" =>
        if ok='1' then
           TEMP<=t30;
           next_state<=c;
         else
            next_state<=a;
        end if;
------------------------------------------------ temp 40
    when "0010" =>
         if ok='1' then
             TEMP<=t40;
             next_state<=c;
         else
             next_state<=a;
          end if;
---------------------------------------------- temp 60
    when "0100" =>
         if ok='1' then
             TEMP<=t60;
             next_state<=c;
         else
             next_state<=a;
          end if;
---------------------------------------------- temp 90
        when "1000" => 
          if ok='1' then
             TEMP<=t90;
             next_state<=c;
         else
             next_state<=a;
          end if;
        when others => next_state<=a;
end case;
------------------------------------------------ stare c
     when c=>
     case viteza is
----------------------------------------------- vit 800
        when "001" =>
           if ok='1' then
           VIT<=v800;
           next_state<=j;
           else
              next_state<=c;
         end if;
------------------------------------------------ vit 1000
        when "010" => 
           if ok='1'  then
              VIT<=v1000;
               next_state<=j;
           else
               next_state<=c;
           end if;
------------------------------------------------- vit 1200
           when "100" =>
             if ok='1' then
               VIT<=v1200;
                next_state<=j;
             else
               next_state<=c;
              end if;
              
 when others=> next_state<=c;
 end case;
--------------------------------------------------- stare j
when j => 
if ok='1'  then 
 if PR='0' then    
     next_state<=n;
 else
     PRESP<='1';
     next_state<=n;
  end if;
 else 
    next_state<=j;
end if;
---------------------------------------------------- stare n
when n => 
if ok='1'  then 
 if CS='0' then    
     next_state<=o;
 else
     CLSUP<='1';
     next_state<=o;
  end if;
 else 
    next_state<=n;
end if;
---------------------------------------------------- stare q
when q => 
case programe is
-------------------------------------------------------spalare rapida 
when "00001" => 
        if ok='1'  then
          PROGRAM<=PSR;
          TEMP<=t30;
          VIT<=v1200;
           next_state<=o;
         else
          next_state<=q;
         end if;
----------------------------------------------------- camasi
when "00010" => 
      if ok='1'   then          
           PROGRAM<=PCAM;
           TEMP<=t40;
           VIT<=v800;
           next_state<=o;
        else
            next_state<=q;
        end if;
---------------------------------------------------- culori inchise
when "00100" => 
       if ok='1'   then          
           PROGRAM<=PCI;
           TEMP<=t40;
           VIT<=v1000;
           CLSUP<='1';
           next_state<=o;
        else
            next_state<=q;
        end if;
-------------------------------------------------------- rufe murdare
when "01000" => 
      if ok='1'   then          
           PROGRAM<=PRM;
           TEMP<=t40;
           VIT<=v1000;
           PRESP<='1';
           CLSUP<='1';
           next_state<=o;
        else
            next_state<=q;
        end if;
------------------------------------------------------ anti alergice
when "10000" => 
      if ok='1'   then          
           PROGRAM<=PAA;
           TEMP<=t90;
           VIT<=v1200;
           CLSUP<='1';
           next_state<=o;
        else
            next_state<=q;
        end if;
when others=> next_state<=q;
end case;
------------------------------------------------------ stare o
when o =>
  if start ='0' then
       if reset='1'then
            next_state<=idle;
       end if;
       else
       if ok='1' then
            next_state<=p;
        end if;
   end if;
---------------------------------------------------- stare p
when p =>  EN_DOOR<='1';

end case;
end process;


ouptuts: process (current_state)
begin
stare<="000000000";
case current_state is
when idle=> stare(8)<='1';
 led_am<='0'; led_30<='0';led_40<='0';led_60<='0';led_90<='0';led_800<='0';led_1000<='0';led_1200<='0';led_PR<='0';led_CS<='0';led_doorlock<='0';
when a=> stare(7)<='1';
         led_am<='1';
         
when c=> stare(6)<='1';
         case TEMP is
         when t30=> led_30<='1';
         when t40=> led_40<='1';
         when t60=> led_60<='1';
         when t90=> led_90<='1';
         when others=> 
         end case;
         
when j=> stare(5)<='1';
          case VIT is
         when v800=> led_800<='1';
         when v1000=> led_1000<='1';
         when v1200=> led_1200<='1';
         when others=>
         end case;
         
when n=> stare(4)<='1';
         if PRESP='1' then 
            led_PR<='1'; 
         end if;
         
when q=> stare(3)<='1';
         if CLSUP='1' then 
            led_CS<='1'; 
         end if;
         
when o=>stare(3)<='1';
         if CLSUP='1' then 
            led_CS<='1'; 
         end if;
        stare(2)<='1';
        case PROGRAM is 
         when PSR =>
         led_30<='1';
         led_1200<='1';
         when PCAM =>
         led_60<='1';
         led_800<='1';
         when PCI=>
         led_40<='1';
         led_1000<='1';
         led_CS<='1';
         when PRM=>
         led_40<='1';
         led_1000<='1';
         led_PR<='1';
         when PAA=>
         led_90<='1';
         led_1200<='1';
         led_CS<='1';
         when others=>
         end case;
when p=> stare(1)<='1';
led_doorlock<='1';
end case;
end process;

END TypeArchitecture;
