LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity data_mem is
port(
	clk      :in std_logic;
	addr     :in unsigned(7 downto 0);
	data_in  :in std_logic_vector(31 downto 0);
	wen      :in std_logic;
	en       :in std_logic;
	data_out :out std_logic_vector(31 downto 0));
end data_mem;

architecture description of data_mem is 
	type myarrayvectors is array(255 downto 0) of std_logic_vector(31 downto 0);
	signal mem : myarrayvectors:= (others=> (others => '0'));
	
BEGIN 
	process(clk)
	begin
	if falling_edge(clk) then
	
		if en = '0' then
			data_out <= "00000000000000000000000000000000";
		elsif ((en and wen) = '0') then
			data_out <= mem(to_integer(addr));
		elsif ((en and wen) = '1') then
			mem(to_integer(addr)) <= data_in;
		end if;
	end if;
	end process;
	
	
end description;