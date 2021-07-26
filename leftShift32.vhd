library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;

entity leftShift32 is
	port(
		a_in   :in std_logic_vector(31 downto 0);
		result :out std_logic_vector(31 downto 0)
	);
end leftShift32;

architecture description of leftShift32 is
begin 
	result(31 downto 1) <= a_in(30 downto 0);
	result(0) <= '0';
end description;