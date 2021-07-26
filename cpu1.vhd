LIBRARY ieee;
USE ieee.std_logic_1164.ALL; 
USE ieee.std_logic_arith.ALL; 
USE ieee.std_logic_unsigned.ALL;

ENTITY cpu1 is
PORT
	(
		-- Input ports
		clk		: in	std_logic;
		mem_clk	: in	std_logic;
		rst		: in	std_logic;
		dataIn	: in	std_logic_vector(31 downto 0);
		-- Output ports
		dataOut		: out	std_logic_vector(31 downto 0);
		addrOut		: out	std_logic_vector(31 downto 0);
		wEn 			: out	std_logic;
		-- Debug data.
		dOutA, dOutB	: out	std_logic_vector(31 downto 0);
		dOutC, dOutZ	: out	std_logic;
		dOutIR			: out	std_logic_vector(31 downto 0);
		dOutPC			: out	std_logic_vector(31 downto 0);
		outT				: out	std_logic_vector(2 downto 0);
		wen_mem, en_mem : out std_logic		
	);
END cpu1;
	
ARCHITECTURE behavior OF cpu1 IS
				
	COMPONENT Reset_Circuit
	PORT
		(
			Reset : IN STD_LOGIC;
			Clk : IN STD_LOGIC;
			Enable_PD : OUT STD_LOGIC;
			Clr_PC : OUT STD_LOGIC
		);
	END COMPONENT;
	
	COMPONENT lab5
	PORT (
		Clk, MClk 		  : IN STD_LOGIC;
		enable 			  : IN STD_LOGIC;
		statusC, statusZ : IN STD_LOGIC;
		INST 				  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		A_Mux, B_Mux 	  : OUT STD_LOGIC;
		IM_MUX1, REG_Mux : OUT STD_LOGIC;
		IM_MUX2, DATA_Mux: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		ALU_Op           : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		Inc_PC, Ld_PC    : OUT STD_LOGIC;
		Clr_IR           : OUT STD_LOGIC;
		Ld_IR            : OUT STD_LOGIC;
		Clr_A, Clr_B, Clr_C, Clr_Z : OUT STD_LOGIC;
		Ld_A, Ld_B, Ld_C, Ld_Z     : OUT STD_LOGIC;
		T                : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		wen, en          : OUT STD_LOGIC
	);
	END COMPONENT;
	
	COMPONENT lab4b 
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
				DATA_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				MEM_ADDR :  OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
   
				-- Various MUX controls. 
				DATA_Mux:     IN STD_LOGIC_VECTOR(1 DOWNTO 0);
				REG_Mux :     IN STD_LOGIC;
				A_MUX, B_MUX :IN STD_LOGIC;
				IM_MUX1 :     IN STD_LOGIC;
				IM_MUX2 :     IN STD_LOGIC_VECTOR(1 DOWNTO 0);
 
				-- ALU Operations.
				ALU_Op : IN STD_LOGIC_VECTOR(2 DOWNTO 0));
	END COMPONENT;
	
		-- Internal signals--------
		signal	enable_wire									 : STD_LOGIC;
		signal 	wen_wire, en_wire							 : STD_LOGIC;
		signal 	Clr_A_wire , Ld_A_wire					 : STD_LOGIC;
		signal 	Clr_B_wire , Ld_B_wire 					 : STD_LOGIC;
		signal 	Clr_C_wire , Ld_C_wire 					 : STD_LOGIC;
		signal	Clr_Z_wire , Ld_Z_wire					 : STD_LOGIC;
		signal 	Clr_PC_wire , Ld_PC_wire				 : STD_LOGIC;
		signal   Inc_PC_wire									 : STD_LOGIC;
		signal 	Clr_IR_wire , Ld_IR_wire 				 : STD_LOGIC;
		signal	A_Mux_wire,B_Mux_wire					 : STD_LOGIC;
		signal	IM_MUX1_wire, REG_Mux_wire				 : STD_LOGIC;
		signal	IM_MUX2_wire, DATA_Mux_wire			 : STD_LOGIC_VECTOR(1 DOWNTO 0);
		signal	ALU_Op_wire									 : STD_LOGIC_VECTOR(2 DOWNTO 0);
		signal   Out_C_wire,Out_Z_wire					 : STD_LOGIC;
		signal	mem_out_wire,mem_in_wire,Out_IR_wire : STD_LOGIC_VECTOR(31 DOWNTO 0); 
		signal	mem_addr_wire								 : STD_LOGIC_VECTOR(7 DOWNTO 0);

	Begin
		
	Datapath_Unit: lab4b
	PORT MAP
		( 	
			clk, mem_clk,
			
			wen_wire, en_wire,
			
			Clr_A_wire, Ld_A_wire,
			Clr_B_wire, Ld_B_wire,
			Clr_C_wire, Ld_C_wire,
			Clr_Z_wire, Ld_Z_wire,
			Clr_PC_wire, Ld_PC_wire,
			Clr_IR_wire, Ld_IR_wire,
			
			dOutA,
			dOutB,
			Out_C_wire,
			Out_Z_wire,
			dOutPC,
			Out_IR_wire,
			
			Inc_PC_wire,
			
			addrOut,
		   dataIn, 
			dataOut,
			mem_addr_wire,
			
			DATA_Mux_wire, 
			REG_Mux_wire,
			A_Mux_wire,
			B_Mux_wire, 
			IM_MUX1_wire, 
			IM_MUX2_wire,
			
			ALU_Op_wire
		);	
		
	Control_Unit: lab5
	PORT MAP
		(		
		clk, mem_clk,	  
		enable_wire, 			  
		Out_C_wire, Out_Z_wire,
		Out_IR_wire,		  
		A_Mux_wire, B_Mux_wire,  
		IM_MUX1_wire, REG_Mux_wire,
		IM_MUX2_wire, DATA_Mux_wire,
		ALU_Op_wire,        
		Inc_PC_wire, Ld_PC_wire, 
		Clr_IR_wire,           
		Ld_IR_wire,         
		Clr_A_wire, Clr_B_wire, Clr_C_wire, Clr_Z_wire, 
		Ld_A_wire, Ld_B_wire, Ld_C_wire, Ld_Z_wire,    
		outT,             
		wen_wire, en_wire         
		);
		
	Reset_Unit:Reset_Circuit
	PORT MAP	
		(
			rst,
			clk,
			enable_wire,
			Clr_PC_wire
		);
		
		wen_mem<=wen_wire; 
		en_mem<=en_wire; 
		doutC<=Out_C_wire;
		doutZ<=Out_Z_wire;
		doutIR<=Out_IR_wire;
		wEn<='0';
		
END behavior;