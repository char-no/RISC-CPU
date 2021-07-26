LIBRARY ieee; 
USE ieee.std_logic_1164.ALL; 
USE ieee.std_logic_arith.ALL; 
USE ieee.std_logic_unsigned.ALL; 

ENTITY LZE IS
	PORT(
			input 		:IN STD_logic_vector(31 downto 0);
			output		:out STD_logic_vector(31 downto 0));
END LZE;

architecture description of LZE is
begin
		output(31 downto 16) <= "0000000000000000";
		output(15 downto 0) <= input(31 downto 16);
end description;