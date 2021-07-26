library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;

entity mux8to1 is
	port(
		in0,in1,in2,in3,in4,in5,in6,in7 :in std_logic_vector(31 downto 0);
		sel    :in std_logic_vector(2 downto 0);
		y      :out std_logic_vector(31 downto 0)
	);
end mux8to1;

architecture description of mux8to1 is
begin
	process(sel,in0,in1,in2,in3,in4,in5,in6,in7)
	begin
		case sel is
			when "000" => y <= in0;
			when "001" => y <= in1;
			when "010" => y <= in2;
			when "011" => y <= in3;
			when "100" => y <= in4;
			when "101" => y <= in5;
			when "110" => y <= in6;
			when "111" => y <= in7;
			when others => y <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
		end case;
	end process;
end description;