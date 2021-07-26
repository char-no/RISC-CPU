library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;

entity compoundALU is
	port( 
		a        :in   std_logic_vector(31 downto 0);
		b        :in   std_logic_vector(31 downto 0);
		op       :in   std_logic_vector(2 downto 0);
		result   :inout std_logic_vector(31 downto 0);
		carry    :out   std_logic;
		zero     :out   std_logic
	);
end compoundALU;

architecture description of compoundALU is
	
	component adder32 is
		port(
			a_in   :in  std_logic_vector(31 downto 0);
			b_in   :in  std_logic_vector(31 downto 0);
			c_in   :in  std_logic;
			result :out std_logic_vector(31 downto 0);
			c_out  :out std_logic
		);
	end component;
	component and32 is
		port(
			a_in  :in std_logic_vector(31 downto 0);
			b_in  :in std_logic_vector(31 downto 0);
			result :out std_logic_vector(31 downto 0)
		);
	end component;
	component or32 is
		port(
			a_in  :in std_logic_vector(31 downto 0);
			b_in  :in std_logic_vector(31 downto 0);
			result :out std_logic_vector(31 downto 0)
		);
	end component;
	component rightShift32 is
		port(
			a_in   :in std_logic_vector(31 downto 0);
			result :out std_logic_vector(31 downto 0)
		);
	end component;
	component leftShift32 is
		port(
			a_in   :in std_logic_vector(31 downto 0);
			result :out std_logic_vector(31 downto 0)
		);
	end component;
	component mux8to1 is
		port(
			in0,in1,in2,in3,in4,in5,in6,in7 :in std_logic_vector(31 downto 0);
			sel    :in std_logic_vector(2 downto 0);
			y      :out std_logic_vector(31 downto 0)
		);
	end component;
	component mux2to1 is
		port(
			in0,in1 :in std_logic_vector(31 downto 0);
			sel     :in std_logic;
			y       :out std_logic_vector(31 downto 0)
		);
	end component;
	component not32 is
		port(
			x :in  std_logic_vector(31 downto 0);
			y :out std_logic_vector(31 downto 0)
		);
	end component;
	
	signal andResult   :std_logic_vector(31 downto 0);
	signal orResult    :std_logic_vector(31 downto 0);
	signal adderResult :std_logic_vector(31 downto 0);
	signal lslResult   :std_logic_vector(31 downto 0);
	signal lsrResult   :std_logic_vector(31 downto 0);
	signal bNegorNot   :std_logic_vector(31 downto 0);
	signal bNot        :std_logic_vector(31 downto 0);
	
begin
	mux1:    mux8to1 port map(in0 => andResult,
									  in1 => orResult,
									  in2 => adderResult,
									  in3 => "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ",
									  in4 => lslResult,
									  in5 => lsrResult,
									  in6 => adderResult,
									  in7 => "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ",
									  sel => op,
									  y   => result);
									  
	adder1:  adder32 port map(a_in  => a,
									  b_in  => bNegorNot,
									  c_in  => op(2),
									  result => adderResult,
									  c_out => carry);
	and1:    and32   port map(a,b,andResult);
   or1:     or32    port map(a,b,orResult);
   lsr1:    rightShift32 port map(a,lsrResult);
   lsl1:    leftShift32  port map(a,lslResult);
   negMux:  mux2to1      port map(in0 => b,
											 in1 => bNot,
											 sel => op(2),
											 y   => bNegorNot);
	notber:  not32        port map(b,bNot);
	
end description;