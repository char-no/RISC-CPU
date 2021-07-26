LIBRARY ieee;
USE ieee.std_logic_1164.ALL; 
USE ieee.std_logic_arith.ALL; 
USE ieee.std_logic_unsigned.ALL;

ENTITY lab4b IS
		PORT( 
				-- clock Signal
				Clk, mClk : IN STD_LOGIC; 
				
				--Memory Signals
				WEN, EN : IN STD_LOGIC;   

				-- Register Control Signals (CLR and LD).
				Clr_A , Ld_A : 	IN STD_LOGIC; 
				Clr_B , Ld_B :    IN STD_LOGIC; 
				Clr_C , Ld_C :    IN STD_LOGIC; 
				Clr_Z , Ld_Z :    IN STD_LOGIC;
				Clr_PC , Ld_PC :  IN STD_LOGIC;
				Clr_IR , Ld_IR :  IN STD_LOGIC;
				
				-- Register outputs (Some needed to feed back to control unit. Others pulled out for testing.
				Out_A :  OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				Out_B :  OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				Out_C :  OUT STD_LOGIC;
				Out_Z :  OUT STD_LOGIC;
				Out_PC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				Out_IR : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				
				-- Special inputs to PC. 
				Inc_PC : IN STD_LOGIC;
  
				-- Address and Data Bus signals for debugging.
				ADDR_OUT :  OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				DATA_IN :   IN STD_LOGIC_VECTOR(31 DOWNTO 0);
				DATA_OUT, MEM_OUT, MEM_IN : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				MEM_ADDR :  OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
   
				-- Various MUX controls. 
				DATA_Mux:     IN STD_LOGIC_VECTOR(1 DOWNTO 0);
				REG_Mux :     IN STD_LOGIC;
				A_MUX, B_MUX :IN STD_LOGIC;
				IM_MUX1 :     IN STD_LOGIC;
				IM_MUX2 :     IN STD_LOGIC_VECTOR(1 DOWNTO 0);
 
				-- ALU Operations.
				ALU_Op : IN STD_LOGIC_VECTOR(2 DOWNTO 0));
END lab4b;
ARCHITECTURE description OF lab4b IS
-- Component instantiations -- you figure this out
-- Internal signals -- you decide what you need
	Component compoundALU
		port( 
		a        :in   std_logic_vector(31 downto 0);
		b        :in   std_logic_vector(31 downto 0);
		op       :in   std_logic_vector(2 downto 0);
		result   :inout std_logic_vector(31 downto 0);
		carry    :out   std_logic;
		zero     :out   std_logic
	);
	End Component;
	
	Component pc
		port( 
				clr : IN STD_LOGIC;  
				clk : IN STD_LOGIC;  
				ld  : IN STD_LOGIC;  
				inc : IN STD_LOGIC;  
				d   : IN STD_LOGIC_VECTOR(31 DOWNTO 0);  
				q   : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0)
			 ); 
	End Component;
	
	Component register1
		port(            
				d: IN STD_LOGIC;  -- input.  
				ld:IN STD_LOGIC;  -- load/enable.  
				clr:IN STD_LOGIC; -- async. clear.  
				clk:IN STD_LOGIC;	-- clock. 
				Q:OUT STD_LOGIC   -- output.
			);							 
	End Component;
	
	Component register32
		port(
				d   : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
				ld  : IN STD_LOGIC; -- load/enable.
				clr : IN STD_LOGIC; -- async. clear.
				clk : IN STD_LOGIC; -- clock.
				Q   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) -- output
			 );
	End Component;
	
	Component data_mem
		port( 
				clk: 		 IN STD_LOGIC; 
				addr: 	 IN STD_LOGIC_VECTOR(7 DOWNTO 0);  
				data_in:  IN STD_LOGIC_VECTOR(31 DOWNTO 0);  
				wen: 		 IN STD_LOGIC; 
				en: 		 IN STD_LOGIC; 
				data_out: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
			 ); 
	End Component;
	
	Component mux2to1
		port(
			in0,in1 :in std_logic_vector(31 downto 0);																														
			sel     :in std_logic;
			y       :out std_logic_vector(31 downto 0)
			);
	End Component;													
	
	Component mux3to1
		port(
		in0,in1,in2 :in std_logic_vector(31 downto 0);
		sel     :in std_logic_vector(1 downto 0);
		y       :out std_logic_vector(31 downto 0)
		);
	End Component;
	
	Component uze
		PORT(
			input 		:IN STD_logic_vector(31 downto 0);
			output		:out STD_logic_vector(31 downto 0));
	End Component;
	
	Component lze
		PORT(
			input 		:IN STD_logic_vector(31 downto 0);
			output		:out STD_logic_vector(31 downto 0));
	End Component;

	Component red
		PORT(
			input 		:IN STD_logic_vector(31 downto 0);
			output		:out STD_logic_vector(7 downto 0));
	End Component;
	
	signal Amux_output_wire : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal Bmux_output_wire : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal mux1_output_wire : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal mux2_output_wire : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal RED_output_wire	: STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal LZE_output_wire	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal UZE_output_wire	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal ALU_output_wire 	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal DATA_BUS_wire	   : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal Out_IR_wire 	   : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal A_output_wire 	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal B_output_wire 	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal MEM_IN_wire	   : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal MEM_OUT_wire	   : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal DATA_OUT_wire	   : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal Out_PC_wire 	   : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal Out_C_wire			: STD_LOGIC;
	signal Out_Z_wire			: STD_LOGIC;
BEGIN
-- you fill in the details

	IR_Block: register32
			port map (DATA_BUS_wire, Ld_IR, Clr_IR, Clk, Out_IR_wire);
			
	A_Multiplexer: mux2to1 
			port map (DATA_BUS_wire, LZE_output_wire, A_MUX, Amux_output_wire);
			
	B_Multiplexer: mux2to1 
			port map (DATA_BUS_wire, LZE_output_wire, B_MUX, Bmux_output_wire);
			
	Reducer: red 
			port map (Out_IR_wire, RED_output_wire);
			
	Lower_Zero_Extender: lze 
			port map (Out_IR_wire, LZE_output_wire);
			
	Upper_Zero_Extender: uze 
			port map (Out_IR_wire, UZE_output_wire);
			
	Block_A: register32 
			port map (Amux_output_wire, Ld_A, Clr_A, CLK, A_output_wire );
			
	Block_B: register32
			port map (Bmux_output_wire, Ld_B, Clr_B, CLK, B_output_wire );
	
	RegMux_Block: mux2to1 
			port map (A_output_wire, B_output_wire, REG_Mux, MEM_IN_wire);
			
	Date_Memory: data_mem 
			port map (Clk, RED_output_wire,MEM_IN_wire, WEN, EN, MEM_OUT_wire);
			
	InstMem_MUX1: mux2to1 
			port map (A_output_wire, UZE_output_wire, IM_MUX1, mux1_output_wire);
			
	InstMem_MUX2: mux3to1 
			port map (B_output_wire, LZE_output_wire, x"00000001", IM_MUX2, mux2_output_wire);
			
	ALU_Block: compoundALU
			port map (mux1_output_wire, mux2_output_wire, ALU_Op, ALU_output_wire, Out_C_wire, Out_Z_wire);
			
	Data_Multiplexer: mux3to1 
			port map (DATA_IN, MEM_OUT_wire, ALU_output_wire, DATA_Mux, DATA_BUS_wire);
				
	Program_Counter: pc 
			port map (Clr_PC, Clk, Ld_PC, Inc_PC, LZE_output_wire, Out_PC_wire);
			
	Status_C: register1
			port map (Out_C_wire, Ld_C, Clr_C, Clk, Out_C);
			
	Status_Z: register1
			port map (Out_Z_wire, Ld_Z, Clr_Z, Clk, Out_Z);
			
	DATA_OUT<= DATA_BUS_wire;
	MEM_IN <= MEM_IN_wire;
	MEM_ADDR <= RED_output_wire;
	MEM_OUT<= MEM_OUT_wire;
	Out_A <= A_output_wire;
	Out_B <= B_output_wire;
	ADDR_OUT <= Out_PC_wire;
	Out_PC <= Out_PC_wire;
	Out_IR <= Out_IR_wire;


END description;

