LIBRARY ieee; 
USE ieee.std_logic_1164.ALL; 
USE ieee.std_logic_arith.ALL; 
USE ieee.std_logic_unsigned.ALL; 

ENTITY UZE IS
	PORT(
			input 		:IN STD_logic_vector(31 downto 0);
			output		:out STD_logic_vector(31 downto 0));
END UZE;

architecture description of UZE is
begin
		output(31 downto 16) <= input(15 downto 0);
		output(15 downto 0) <= "0000000000000000";
end description;