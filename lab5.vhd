LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY lab5 IS
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
END lab5;
ARCHITECTURE description OF lab5 IS

	TYPE STATETYPE IS (state_0, state_1, state_2);
	SIGNAL present_state : STATETYPE;
	
BEGIN
	-------- OPERATION DECODER ---------
	PROCESS (present_state, INST, statusC, statusZ, enable)
	BEGIN
		-------- YOU FILL IN WHAT GOES IN HERE (DON'T FORGET TO CHECK FOR ENABLE)
		IF(enable = '1') THEN
			CASE present_state IS
		
			--state_0 is when the instruction is loaded into the register
			WHEN state_0 =>
				Ld_PC <= '0'; Inc_PC <= '0'; Clr_A <= '0'; Ld_A <= '0';
				Clr_B <= '0'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '0';
				Clr_Z <= '0'; Ld_Z <= '0'; Clr_IR <= '0'; Ld_IR <= '1';
				ALU_Op <= "XXX"; A_Mux <= 'X'; B_Mux <= 'X'; REG_Mux <= 'X';
				DATA_Mux <= "00"; IM_MUX1 <= 'X'; IM_MUX2 <= "XX";
		
			--PC = PC + 4
			WHEN state_1 => 
				CASE INST(31 DOWNTO 28) IS
			
					--STA
					WHEN "0010" =>
						Ld_PC <= '1'; Inc_PC <= '1'; Clr_A <= '0'; Ld_A <= '0';
						Clr_B <= '0'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '0';
						Clr_Z <= '0'; Ld_Z <= '0'; Clr_IR <= '0'; Ld_IR <= '0';
						ALU_Op <= "XXX"; A_Mux <= 'X'; B_Mux <= 'X'; REG_Mux <= '0'; 
						DATA_Mux <= "XX"; IM_MUX1 <= 'X'; IM_MUX2 <= "XX";
		
					--STB
					WHEN "0011" => 
						Ld_PC <= '1'; Inc_PC <= '1'; Clr_A <= '0'; Ld_A <= '0';
						Clr_B <= '0'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '0';
						Clr_Z <= '0'; Ld_Z <= '0'; Clr_IR <= '0'; Ld_IR <= '0';
						ALU_Op <= "XXX"; A_Mux <= 'X'; B_Mux <= 'X'; REG_Mux <= '1';
						DATA_Mux <= "XX"; IM_MUX1 <= 'X'; IM_MUX2 <= "XX";
	
					--LDA
					WHEN "1001" => 
						Ld_PC <= '1'; Inc_PC <= '1'; Clr_A <= '0'; Ld_A <= '1';
						Clr_B <= '0'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '0';
						Clr_Z <= '0'; Ld_Z <= '0'; Clr_IR <= '0'; Ld_IR <= '0';
						ALU_Op <= "XXX"; A_Mux <= '0'; B_Mux <= 'X'; REG_Mux <= 'X';
						DATA_Mux <= "00"; IM_MUX1 <= 'X'; IM_MUX2 <= "XX";
						
					--LDB
					WHEN "1010" =>
						Ld_PC <= '1'; Inc_PC <= '1'; Clr_A <= '0'; Ld_A <= '0';
						Clr_B <= '0'; Ld_B <= '1'; Clr_C <= '0'; Ld_C <= '0';
						Clr_Z <= '0'; Ld_Z <= '0'; Clr_IR <= '0'; Ld_IR <= '0';
						ALU_Op <= "XXX"; A_Mux <= 'X'; B_Mux <= '0'; REG_Mux <= 'X';
						DATA_Mux <= "00"; IM_MUX1 <= 'X'; IM_MUX2 <= "XX";

					--BEQ by SUB
					WHEN "0110" =>
						Ld_PC <= '0'; Inc_PC <= '0'; Clr_A <= '0'; Ld_A <= '1';
						Clr_B <= '0'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '1';
						Clr_Z <= '0'; Ld_Z <= '1'; Clr_IR <= '0'; Ld_IR <= '0';
						ALU_Op <= "110"; A_Mux <= '0'; B_Mux <= 'X'; REG_Mux <= 'X';
						DATA_Mux <= "10"; IM_MUX1 <= '0'; IM_MUX2 <= "00";
						
					--BNE by SUB	
					WHEN "1000" =>
						Ld_PC <= '0'; Inc_PC <= '0'; Clr_A <= '0'; Ld_A <= '1';
						Clr_B <= '0'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '1';
						Clr_Z <= '0'; Ld_Z <= '1'; Clr_IR <= '0'; Ld_IR <= '0';
						ALU_Op <= "110"; A_Mux <= '0'; B_Mux <= 'X'; REG_Mux <= 'X';
						DATA_Mux <= "10"; IM_MUX1 <= '0'; IM_MUX2 <= "00";
				
						
					WHEN OTHERS =>
						Ld_PC <= '1'; Inc_PC <= '1'; Clr_A <= '0'; Ld_A <= '0';
						Clr_B <= '0'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '0';
						Clr_Z <= '0'; Ld_Z <= '0'; Clr_IR <= '0'; Ld_IR <= '0';
						ALU_Op <= "XXX"; A_Mux <= 'X'; B_Mux <= 'X'; REG_Mux <= 'X';
						DATA_Mux <= "XX"; IM_MUX1 <= 'X'; IM_MUX2 <= "XX";
					END CASE;

			WHEN state_2 =>
				CASE INST(31 DOWNTO 28) IS

				
					--LDAI
					WHEN "0000" =>
						Ld_PC <= '0'; Inc_PC <= '0'; Clr_A <= '0'; Ld_A <= '1';
						Clr_B <= '0'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '0';
						Clr_Z <= '0'; Ld_Z <= '0'; Clr_IR <= '0'; Ld_IR <= '0';
						ALU_Op <= "XXX"; A_Mux <= '1'; B_Mux <= 'X'; REG_Mux <= 'X';
						DATA_Mux <= "XX"; IM_MUX1 <= 'X'; IM_MUX2 <= "XX";
				
					--LDBI
					WHEN "0001" =>
						Ld_PC <= '0'; Inc_PC <= '0'; Clr_A <= '0'; Ld_A <= '0';
						Clr_B <= '0'; Ld_B <= '1'; Clr_C <= '0'; Ld_C <= '0';
						Clr_Z <= '0'; Ld_Z <= '0'; Clr_IR <= '0'; Ld_IR <= '0';
						ALU_Op <= "XXX"; A_Mux <= 'X'; B_Mux <= '1'; REG_Mux <= 'X';
						DATA_Mux <= "XX"; IM_MUX1 <= 'X'; IM_MUX2 <= "XX";
				
					--LDA
					WHEN "1001" =>
						Ld_PC <= '0'; Inc_PC <= '0'; Clr_A <= '0'; Ld_A <= '1';
						Clr_B <= '0'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '0';
						Clr_Z <= '0'; Ld_Z <= '0'; Clr_IR <= '0'; Ld_IR <= '0';
						ALU_Op <= "XXX"; A_Mux <= '0'; B_Mux <= 'X'; REG_Mux <= 'X';
						DATA_Mux <= "01"; IM_MUX1 <= 'X'; IM_MUX2 <= "XX";

					--LDB
					WHEN "1010" =>
						Ld_PC <= '0'; Inc_PC <= '0'; Clr_A <= '0'; Ld_A <= '0';
						Clr_B <= '0'; Ld_B <= '1'; Clr_C <= '0'; Ld_C <= '0';
						Clr_Z <= '0'; Ld_Z <= '0'; Clr_IR <= '0'; Ld_IR <= '0';
						ALU_Op <= "XXX"; A_Mux <= 'X'; B_Mux <= '0'; REG_Mux <= 'X';
						DATA_Mux <= "01"; IM_MUX1 <= 'X'; IM_MUX2 <= "XX";

					--LUI
					WHEN "0100" =>
						Ld_PC <= '0'; Inc_PC <= '0'; Clr_A <= '0'; Ld_A <= '1';
						Clr_B <= '1'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '0';
						Clr_Z <= '0'; Ld_Z <= '0'; Clr_IR <= '0'; Ld_IR <= '0';
						ALU_Op <= "001"; A_Mux <= '0';B_Mux <= 'X'; REG_Mux <= 'X';
						DATA_Mux <= "10"; IM_MUX1 <= '1'; IM_MUX2 <= "XX";

					--JMP
					WHEN "0101" =>
						Ld_PC <= '1'; Inc_PC <= '0'; Clr_A <= '0'; Ld_A <= '0';
						Clr_B <= '0'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '0';
						Clr_Z <= '0'; Ld_Z <= '0'; Clr_IR <= '0'; Ld_IR <= '0';
						ALU_Op <= "XXX"; A_Mux <= 'X'; B_Mux <= 'X'; REG_Mux <= 'X';
						DATA_Mux <= "XX"; IM_MUX1 <= 'X'; IM_MUX2 <= "XX";

					--BEQ
					WHEN "0110" =>
						IF(statusZ = '1') THEN
								Ld_PC <= '1'; Inc_PC <= '0'; Clr_A <= '0'; Ld_A <= '0';
								Clr_B <= '0'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '0';
								Clr_Z <= '0'; Ld_Z <= '0'; Clr_IR <= '0'; Ld_IR <= '0';
								ALU_Op <= "XXX"; A_Mux <= 'X'; B_Mux <= 'X'; REG_Mux <= 'X';
								DATA_Mux <= "XX"; IM_MUX1 <= 'X'; IM_MUX2 <= "XX";
						ELSE
								Ld_PC <= '0'; Inc_PC <= '0'; Clr_A <= '0'; Ld_A <= '0';
								Clr_B <= '0'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '0';
								Clr_Z <= '0'; Ld_Z <= '0'; Clr_IR <= '0'; Ld_IR <= '0';
								ALU_Op <= "XXX"; A_Mux <= 'X'; B_Mux <= 'X'; REG_Mux <= 'X';
								DATA_Mux <= "XX"; IM_MUX1 <= 'X'; IM_MUX2 <= "XX";
						END IF;

					--BNE
					WHEN "1000" =>
						IF(statusZ = '1') THEN
								Ld_PC <= '0'; Inc_PC <= '0'; Clr_A <= '0'; Ld_A <= '0';
								Clr_B <= '0'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '0';
								Clr_Z <= '0'; Ld_Z <= '0'; Clr_IR <= '0'; Ld_IR <= '0';
								ALU_Op <= "XXX"; A_Mux <= 'X'; B_Mux <= 'X'; REG_Mux <= 'X';
								DATA_Mux <= "XX"; IM_MUX1 <= 'X'; IM_MUX2 <= "XX";	
						ELSE
								Ld_PC <= '1'; Inc_PC <= '0'; Clr_A <= '0'; Ld_A <= '0';
								Clr_B <= '0'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '0';
								Clr_Z <= '0'; Ld_Z <= '0'; Clr_IR <= '0'; Ld_IR <= '0';
								ALU_Op <= "XXX"; A_Mux <= 'X'; B_Mux <= 'X'; REG_Mux <= 'X';
								DATA_Mux <= "XX"; IM_MUX1 <= 'X'; IM_MUX2 <= "XX";
						END IF;
		
					WHEN "0111" =>
						CASE INST(27 DOWNTO 24) IS
							--ADD
							WHEN "0000" =>
								Ld_PC <= '0'; Inc_PC <= '0'; Clr_A <= '0'; Ld_A <= '1';
								Clr_B <= '0'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '1';
								Clr_Z <= '0'; Ld_Z <= '1'; Clr_IR <= '0'; Ld_IR <= '0';
								ALU_Op <= "010"; A_Mux <= '0'; B_Mux <= 'X'; REG_Mux <= 'X';
								DATA_Mux <= "10"; IM_MUX1 <= '0'; IM_MUX2 <= "00";

							--ADDI
							WHEN "0001" =>
								Ld_PC <= '0'; Inc_PC <= '0'; Clr_A <= '0'; Ld_A <= '1';
								Clr_B <= '0'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '1';
								Clr_Z <= '0'; Ld_Z <= '1'; Clr_IR <= '0'; Ld_IR <= '0';
								ALU_Op <= "010"; A_Mux <= '0'; B_Mux <= 'X'; REG_Mux <= 'X';
								DATA_Mux <= "10"; IM_MUX1 <= '0'; IM_MUX2 <= "01";

							--SUB
							WHEN "0010" =>
								Ld_PC <= '0'; Inc_PC <= '0'; Clr_A <= '0'; Ld_A <= '1';
								Clr_B <= '0'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '1';
								Clr_Z <= '0'; Ld_Z <= '1'; Clr_IR <= '0'; Ld_IR <= '0';
								ALU_Op <= "110"; A_Mux <= '0'; B_Mux <= 'X'; REG_Mux <= 'X';
								DATA_Mux <= "10"; IM_MUX1 <= '0'; IM_MUX2 <= "00";
	
							--INCA
							WHEN "0011" =>
								Ld_PC <= '0'; Inc_PC <= '0'; Clr_A <= '0'; Ld_A <= '1';
								Clr_B <= '0'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '1';
								Clr_Z <= '0'; Ld_Z <= '1';Clr_IR <= '0'; Ld_IR <= '0';
								ALU_Op <= "010"; A_Mux <= '0'; B_Mux <= 'X'; REG_Mux <= 'X';
								DATA_Mux <= "10"; IM_MUX1 <= '0'; IM_MUX2 <= "10";

							--ROL
							WHEN "0100" =>
								Ld_PC <= '0'; Inc_PC <= '0'; Clr_A <= '0'; Ld_A <= '1';
								Clr_B <= '0'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '1';
								Clr_Z <= '0'; Ld_Z <= '1'; Clr_IR <= '0'; Ld_IR <= '0';
								ALU_Op <= "100"; A_Mux <= '0'; B_Mux <= 'X'; REG_Mux <= 'X';
								DATA_Mux <= "10"; IM_MUX1 <= '0'; IM_MUX2 <= "XX";

							--CLRA
							WHEN "0101" =>
								Ld_PC <= '0'; Inc_PC <= '0'; Clr_A <= '1'; Ld_A <= '0';
								Clr_B <= '0'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '0';
								Clr_Z <= '0'; Ld_Z <= '0'; Clr_IR <= '0'; Ld_IR <= '0';
								ALU_Op <= "XXX"; A_Mux <= 'X'; B_Mux <= 'X'; REG_Mux <= 'X';
								DATA_Mux <= "XX"; IM_MUX1 <= 'X'; IM_MUX2 <= "XX";

							--CLRB
							WHEN "0110" =>
								Ld_PC <= '0'; Inc_PC <= '0'; Clr_A <= '0'; Ld_A <= '0'; 
								Clr_B <= '1'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '0';
								Clr_Z <= '0'; Ld_Z <= '0'; Clr_IR <= '0'; Ld_IR <= '0';
								ALU_Op <= "XXX"; A_Mux <= 'X'; B_Mux <= 'X'; REG_Mux <= 'X';
								DATA_Mux <= "XX"; IM_MUX1 <= 'X'; IM_MUX2 <= "XX";

							--CLRC
							WHEN "0111" => 
								Ld_PC <= '0'; Inc_PC <= '0'; Clr_A <= '0'; Ld_A <= '0';
								Clr_B <= '0'; Ld_B <= '0'; Clr_C <= '1'; Ld_C <= '0';
								Clr_Z <= '0'; Ld_Z <= '0'; Clr_IR <= '0'; Ld_IR <= '0';
								ALU_Op <= "XXX"; A_Mux <= 'X'; B_Mux <= 'X'; REG_Mux <= 'X';
								DATA_Mux <= "XX"; IM_MUX1 <= 'X'; IM_MUX2 <= "XX";

							--CLRZ
							WHEN "1000" =>
								Ld_PC <= '0'; Inc_PC <= '0'; Clr_A <= '0'; Ld_A <= '0';
								Clr_B <= '0'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '0';
								Clr_Z <= '1'; Ld_Z <= '0'; Clr_IR <= '0'; Ld_IR <= '0';
								ALU_Op <= "XXX"; A_Mux <= 'X'; B_Mux <= 'X'; REG_Mux <= 'X';
								DATA_Mux <= "XX"; IM_MUX1 <= 'X'; IM_MUX2 <= "XX";
		
							--ANDI
							WHEN "1001" =>
								Ld_PC <= '0'; Inc_PC <= '0'; Clr_A <= '0'; Ld_A <= '1';
								Clr_B <= '0'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '1';
								Clr_Z <= '0'; Ld_Z <= '1'; Clr_IR <= '0'; Ld_IR <= '0';
								ALU_Op <= "000"; A_Mux <= '0'; B_Mux <= 'X'; REG_Mux <= 'X';
								DATA_Mux <= "10"; IM_MUX1 <= '0'; IM_MUX2 <= "01";

								
							--TSTZ
							WHEN "1010" =>
								IF(statusZ = '1') THEN
									Ld_PC <= '0'; Inc_PC <= '1'; Clr_A <= '0'; Ld_A <= '0';
									Clr_B <= '0'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '0';
									Clr_Z <= '0'; Ld_Z <= '0'; Clr_IR <= '0'; Ld_IR <= '0';
									ALU_Op <= "XXX"; A_Mux <= 'X'; B_Mux <= 'X'; REG_Mux <= 'X';
									DATA_Mux <= "XX"; IM_MUX1 <= 'X'; IM_MUX2 <= "XX";
								ELSE
									Ld_PC <= '0'; Inc_PC <= '0'; Clr_A <= '0'; Ld_A <= '0';
									Clr_B <= '0'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '0';
									Clr_Z <= '0'; Ld_Z <= '0'; Clr_IR <= '0'; Ld_IR <= '0';
									ALU_Op <= "XXX"; A_Mux <= 'X'; B_Mux <= 'X'; REG_Mux <= 'X';
									DATA_Mux <= "XX"; IM_MUX1 <= 'X'; IM_MUX2 <= "XX";
								END IF;
								
							--AND
							WHEN "1011" =>
								Ld_PC <= '0'; Inc_PC <= '0'; Clr_A <= '0'; Ld_A <= '1';
								Clr_B <= '0'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '1';
								Clr_Z <= '0'; Ld_Z <= '1'; Clr_IR <= '0'; Ld_IR <= '0';
								ALU_Op <= "000"; A_Mux <= '0'; B_Mux <= 'X'; REG_Mux <= 'X';
								DATA_Mux <= "10"; IM_MUX1 <= '0'; IM_MUX2 <= "00";

								
							--TSTC 	
							WHEN "1100" =>
								IF (statusC = '1') THEN
									Ld_PC <= '0'; Inc_PC <= '1'; Clr_A <= '0'; Ld_A <= '0';
									Clr_B <= '0'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '0';
									Clr_Z <= '0'; Ld_Z <= '0'; Clr_IR <= '0'; Ld_IR <= '0';
									ALU_Op <= "XXX"; A_Mux <= 'X'; B_Mux <= 'X'; REG_Mux <= 'X';
									DATA_Mux <= "XX"; IM_MUX1 <= 'X'; IM_MUX2 <= "XX";
								ELSE
									Ld_PC <= '0'; Inc_PC <= '0'; Clr_A <= '0'; Ld_A <= '0';
									Clr_B <= '0'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '0';
									Clr_Z <= '0'; Ld_Z <= '0'; Clr_IR <= '0'; Ld_IR <= '0';
									ALU_Op <= "XXX"; A_Mux <= 'X'; B_Mux <= 'X'; REG_Mux <= 'X';
									DATA_Mux <= "XX"; IM_MUX1 <= 'X'; IM_MUX2 <= "XX";
								END IF;	
			
							--ORI
							WHEN "1101" =>
								Ld_PC <= '0'; Inc_PC <= '0'; Clr_A <= '0'; Ld_A <= '1';
								Clr_B <= '0'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '0';
								Clr_Z <= '0'; Ld_Z <= '1'; Clr_IR <= '0'; Ld_IR <= '0';
								ALU_Op <= "001"; A_Mux <= 'X'; B_Mux <= 'X'; REG_Mux <= 'X';
								DATA_Mux <= "10"; IM_MUX1 <= '0'; IM_MUX2 <= "01";

							--DECA
							WHEN "1110" =>
								Ld_PC <= '0'; Inc_PC <= '0'; Clr_A <= '0'; Ld_A <= '1';
								Clr_B <= '0'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '1';
								Clr_Z <= '0'; Ld_Z <= '1'; Clr_IR <= '0'; Ld_IR <= '0';
								ALU_Op <= "110"; A_Mux <= '0'; B_Mux <= 'X'; REG_Mux <= 'X';
								DATA_Mux <= "10"; IM_MUX1 <= '0'; IM_MUX2 <= "10";

							--ROR
							WHEN "1111" =>
								Ld_PC <= '0'; Inc_PC <= '0'; Clr_A <= '0'; Ld_A <= '1';
								Clr_B <= '0'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '1';
								Clr_Z <= '0'; Ld_Z <= '1'; Clr_IR <= '0'; Ld_IR <= '0';
								ALU_Op <= "101"; A_Mux <= '0'; B_Mux <= 'X'; REG_Mux <= 'X';
								DATA_Mux <= "10"; IM_MUX1 <= '0'; IM_MUX2 <= "XX";

							WHEN OTHERS =>
								Ld_PC <= '0'; Inc_PC <= '0'; Clr_A <= '0'; Ld_A <= '0';
								Clr_B <= '0'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '0';
								Clr_Z <= '0'; Ld_Z <= '0'; Clr_IR <= '0'; Ld_IR <= '0';
								ALU_Op <= "XXX"; A_Mux <= 'X'; B_Mux <= 'X'; REG_Mux <= 'X';
								DATA_Mux <= "XX"; IM_MUX1 <= 'X'; IM_MUX2 <= "XX";
						END CASE;
		
					WHEN OTHERS =>
						Ld_PC <= '0'; Inc_PC <= '0'; Clr_A <= '0'; Ld_A <= '0';
						Clr_B <= '0'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '0';
						Clr_Z <= '0'; Ld_Z <= '0'; Clr_IR <= '0'; Ld_IR <= '0';
						ALU_Op <= "XXX"; A_Mux <= 'X'; B_Mux <= 'X'; REG_Mux <= 'X';
						DATA_Mux <= "XX"; IM_MUX1 <= 'X'; IM_MUX2 <= "XX";
					END CASE;
		
				WHEN OTHERS =>
					Ld_PC <= '0'; Inc_PC <= '0'; Clr_A <= '0'; Ld_A <= '0';
					Clr_B <= '0'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '0';
					Clr_Z <= '0'; Ld_Z <= '0'; Clr_IR <= '0'; Ld_IR <= '0';
					ALU_Op <= "XXX"; A_Mux <= 'X'; B_Mux <= 'X'; REG_Mux <= 'X';
					DATA_Mux <= "XX"; IM_MUX1 <= 'X'; IM_MUX2 <= "XX";
				END CASE;
		
		ELSIF(enable = '0') THEN
				Ld_PC <= '0'; Inc_PC <= '0'; Clr_A <= '0'; Ld_A <= '0';
				Clr_B <= '0'; Ld_B <= '0'; Clr_C <= '0'; Ld_C <= '0';
				Clr_Z <= '0'; Ld_Z <= '0'; Clr_IR <= '0'; Ld_IR <= '0';
				ALU_Op <= "XXX"; A_Mux <= 'X'; B_Mux <= 'X'; REG_Mux <= 'X';
				DATA_Mux <= "00"; IM_MUX1 <= 'X';IM_MUX2 <= "XX";
		END IF;		
		
	END PROCESS;
	
	-------- STATE MACHINE ---------
	PROCESS (Clk, enable)
	BEGIN
	-------- YOU FILL IN WHAT GOES IN HERE 
		CASE enable IS
			WHEN '1' =>
				IF(rising_edge(Clk)) THEN
					CASE present_state IS
					WHEN state_2 => present_state <= state_0;
					  T <= "001";
					WHEN state_1 => present_state <= state_2;
					  T <= "100";
					WHEN state_0 => present_state <= state_1;
					  T <= "010";
					END CASE;
				END IF;
			WHEN '0' => present_state <= state_0;
			  T <= "001";
		END CASE;  
	END PROCESS;

	-------- DATA MEMORY INSTRUCTIONS ---------
	PROCESS (MClk, Clk, INST)
	BEGIN
		IF (MClk'EVENT and MClk = '0') THEN
			IF (present_state = state_1 AND Clk = '0') THEN
					CASE INST(31 DOWNTO 28) IS
						--STA and STB Signals
						WHEN "0010" => --STA
							en <= '1';
							wen <= '1';
						WHEN "0011" => --STB
							en <= '1';
							wen <= '1';
					
						--LDA and LDB Signals		
						WHEN "1001" => --LDA
							en <= '1';
							wen <= '0';
						WHEN "1010" => --LDB
							en <= '1';
							wen <= '0';
			
						--DEFAULT CASE Signals
						WHEN OTHERS =>
							en <= '0';
							wen <= '0';
					END CASE;
					
			ELSIF (present_state = state_2 AND Clk = '1') THEN
					CASE INST(31 DOWNTO 28) IS					
						--STA and STB Signals
						WHEN "0010" => --STA
							en <= '0';
							wen <= '0';
						WHEN "0011" => --STB
							en <= '0';
							wen <= '0';
							
						--LDA and LDB Signals
						WHEN "1001" => --LDA
							en <= '1';
							wen <= '0';
						WHEN "1010" => --LDB
							en <= '1';
							wen <= '0';
							
						--DEFAULT CASE
						WHEN OTHERS =>
							en <= '0';
							wen <= '0';
					END CASE;
			ELSE --(present_state = state_1) THEN
			--OR alternatively just an ELSE statement
			--fill IN
				en <= '0';
				wen <= '0';
			END IF;
		END IF;
	END PROCESS;
END description;