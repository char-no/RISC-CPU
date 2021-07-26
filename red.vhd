LIBRARY ieee; 
USE ieee.std_logic_1164.ALL; 
USE ieee.std_logic_arith.ALL; 
USE ieee.std_logic_unsigned.ALL; 

ENTITY RED IS
	PORT(
			input 		:IN STD_logic_vector(31 downto 0);
			output		:out STD_logic_vector(7 downto 0));
END RED;

architecture description of RED is
begin
		output <= input(7 downto 0);
end description;