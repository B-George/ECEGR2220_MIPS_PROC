-- Benjamin George
-- ECEGR 2220
-- Lab#4-- 5.13.2015


------------------------------------------------------

Library ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY ALU IS

	GENERIC(n: INTEGER := 32); -- number of bits

	PORT(DataIn1:	IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	     DataIn2:	IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	     Control:	IN STD_LOGIC_VECTOR(4 DOWNTO 0);
	     Zero:	OUT STD_LOGIC;
	     ALUResult:	OUT STD_LOGIC_VECTOR(31 DOWNTO 0));

END ENTITY ALU;

ARCHITECTURE behavior OF ALU IS	

	SIGNAL ct, shift_amt:		STD_LOGIC_VECTOR(4 DOWNTO 0);

	-- had to make the size of the array static for case statement on line
	-- 173-175
	SIGNAL addin_a, addin_b, shift_in, 
		addout, shiftout, carry, alu_res,
		and_out, or_out, z_res:	STD_LOGIC_VECTOR(31 DOWNTO 0);

	SIGNAL sub, direction, co, 
			    z1, z2:	STD_LOGIC;

	SIGNAL result:			STD_LOGIC_VECTOR(n DOWNTO 0);

	-- signals used for typecasting and manipulation of shift register
	SIGNAL shamtInt: 	INTEGER RANGE 0 TO 31;
	SIGNAL shamtUS: 	IEEE.NUMERIC_STD.UNSIGNED(4 DOWNTO 0);
	SIGNAL datainsig: 	IEEE.NUMERIC_STD.UNSIGNED(31 DOWNTO 0);
	SIGNAL dataoutsig: 	IEEE.NUMERIC_STD.UNSIGNED(31 DOWNTO 0);

BEGIN
	shift_in <= DataIn1;
	addin_a <= DataIn1;
	addin_b <= DataIn2;
	sub <= Control(2);
	shift_amt <= DataIn2(10 DOWNTO 6);
	direction <= Control(0);

		-- typecast input to signals for shift register
	shamtUS <= IEEE.NUMERIC_STD.UNSIGNED(shift_amt);
	shamtInt <= TO_INTEGER(shamtUS);
	datainsig <= IEEE.NUMERIC_STD.UNSIGNED(shift_in);
	
-- shift process

	WITH direction SELECT dataoutsig <=
		datainsig SRL (shamtInt) WHEN '1',
		datainsig SLL (shamtInt) WHEN '0',
		"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" WHEN OTHERS;

-- add/sub process
	PROCESS(sub, addin_a, addin_b)
 	BEGIN
 		IF (sub = '0') THEN -- addition
 			-- the two operands are zero extended one extra bit before adding
 			-- the & is for string concatination
 			result <= ('0' & addin_a) + ('0' & addin_b);
 			carry <= ('0' & addin_a(30 DOWNTO 0)) + ('0' & addin_b(30 DOWNTO 0));		
		ELSE -- subtraction
		 	-- the two operands are zero extended one extra bit before subtracting
 			-- the & is for string concatination
 			result <= ('0' & addin_a) - ('0' & addin_b);
 			carry <= ('0' & addin_a(30 DOWNTO 0)) - ('0' & addin_b(30 DOWNTO 0));
 		END IF;
	END PROCESS;

	

-- AND/OR result
	and_out <= DataIn1 AND DataIn2;
	or_out  <= DataIn1 OR DataIn2;

--add/sub result
	addout <= result(n-1 DOWNTO 0); -- extract the n-bit result
 	co <= result(n) XOR carry(n-1); -- get signed overflow bit
			
--shift result
	shiftout <= STD_LOGIC_VECTOR(dataoutsig);
	
	WITH Control SELECT alu_res <=
		addout 	 WHEN "10000",
		addout 	 WHEN "10100",
		shiftout WHEN "01000",
		shiftout WHEN "01001",
		and_out  WHEN "00000",
		or_out 	 WHEN "00001",
		"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" WHEN OTHERS;	

	WITH alu_res SELECT Zero <=
		'1' WHEN "00000000000000000000000000000000",
		'0' WHEN OTHERS;

	ALUresult <= alu_res;
	
END ARCHITECTURE behavior;		