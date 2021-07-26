LIBRARY ieee;  
USE ieee.std_logic_1164.ALL;  
USE ieee.std_logic_arith.ALL;  
USE ieee.std_logic_unsigned.ALL; 
ENTITY reset_circuit IS 
		PORT ( 
		Reset : IN STD_LOGIC; 
		Clk :  IN STD_LOGIC;  
		Enable_PD :   OUT STD_LOGIC;  
		Clr_PC :     OUT STD_LOGIC ); 
		END reset_circuit; 

ARCHITECTURE description OF reset_circuit IS  

signal bcount: integer range 0 to 3;
BEGIN
 Process(Clk)
	begin
		if (rising_edge(Clk)) then
			if (Reset ='1') then
				Clr_PC <= '1';
				Enable_PD <= '0';
				bcount <= 3;
			elsif bcount>0 then
				bcount <= bcount - 1;
			elsif bcount=0 then
				Clr_PC <= '0';
				Enable_PD <= '1';
			end if;
		end if;
	END Process;
END description; 