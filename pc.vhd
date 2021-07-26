LIBRARY            ieee;            
USE ieee.std_logic_1164.ALL;  
USE ieee.std_logic_arith.ALL;  
USE ieee.std_logic_unsigned.ALL;            
ENTITY pc IS 
	port( 
				clr : IN STD_LOGIC;  
				clk : IN STD_LOGIC;  
				ld  : IN STD_LOGIC;  
				inc : IN STD_LOGIC;  
				d   : IN STD_LOGIC_VECTOR(31 DOWNTO 0);  
				q   : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0)
			 ); 
END pc;            

ARCHITECTURE description OF pc IS  
BEGIN
process(clk, clr)
begin
        if clr = '1' then
            q <= x"00000000";
elsif rising_edge(clk) then
            if ld = '1' and inc = '0' then
                q <= d;
elsif ld = '1' and inc = '1' then
q <= q+1;
         end if;
        end if;
    end process;           
END            description;