library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;

entity or32 is
	port(
		a_in  :in std_logic_vector(31 downto 0);
		b_in  :in std_logic_vector(31 downto 0);
		result :out std_logic_vector(31 downto 0)
	);
end or32;

architecture description of or32 is
begin
	result <= a_in or b_in;
end description;
