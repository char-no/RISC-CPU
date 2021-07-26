library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;

entity mux2to1 is
	port(
		in0,in1 :in std_logic_vector(31 downto 0);
		sel     :in std_logic;
		y       :out std_logic_vector(31 downto 0)
	);
end mux2to1;

architecture description of mux2to1 is
begin
	process(sel, in0,in1)
	begin
		case sel is
			when '0' => y <= in0;
			when '1' => y <= in1;
			when others => y <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
		end case;
	end process;
end description;