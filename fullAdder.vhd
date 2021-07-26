library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;

entity fullAdder is
	port(
		a     :in  std_logic;
		b     :in  std_logic;
		cin   :in  std_logic;
		sum   :out std_logic;
		cout  :out std_logic
	);
end fullAdder;

architecture description of fullAdder is 
begin
	sum <= (a xor b) xor cin;
	cout <= (a and b) or ((a xor b) and cin);
end description;
