library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;

entity rightShift32 is
	port(
		a_in   :in std_logic_vector(31 downto 0);
		result :out std_logic_vector(31 downto 0)
	);
end rightShift32;

architecture description of rightShift32 is
begin 
	result(30 downto 0) <= a_in(31 downto 1);
	result(31) <= '0';
end description;