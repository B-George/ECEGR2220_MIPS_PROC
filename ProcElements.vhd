--------------------------------------------------------------------------------
--
-- LAB #5 - Processor Elements
--
--------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY SmallBusMux2to1 IS
	PORT(selector: IN STD_LOGIC;
	     In0, In1: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
	     Result:   OUT STD_LOGIC_VECTOR(4 DOWNTO 0) );
END ENTITY SmallBusMux2to1;

ARCHITECTURE switching OF SmallBusMux2to1 IS
BEGIN
    WITH selector SELECT
	Result <= In0 WHEN '0',
		  In1 WHEN OTHERS;
END ARCHITECTURE switching;

--------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY BusMux2to1 IS
	PORT(	selector: 	IN STD_LOGIC;
		In0, In1: 	IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		Result: 	OUT STD_LOGIC_VECTOR(31 DOWNTO 0) );
END ENTITY BusMux2to1;

ARCHITECTURE selection OF BusMux2to1 IS
BEGIN
	WITH selector SELECT
		Result <= In0 WHEN '0',
			  In1 WHEN OTHERS;
END ARCHITECTURE selection;

--------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Control IS
    PORT ( opcode : 	IN  STD_LOGIC_VECTOR (5 DOWNTO 0);
           clk : 	IN  STD_LOGIC;
           RegDst : 	OUT  STD_LOGIC;
           Branch : 	OUT  STD_LOGIC;
           MemRead :	OUT  STD_LOGIC;
           MemtoReg : 	OUT  STD_LOGIC;
           ALUOp : 	OUT  STD_LOGIC_VECTOR(1 DOWNTO 0);
           MemWrite : 	OUT  STD_LOGIC;
           ALUSrc : 	OUT  STD_LOGIC;
           RegWrite : 	OUT  STD_LOGIC);
END Control;

ARCHITECTURE Boss OF Control IS

	--SIGNAL clock: STD_LOGIC;
	
BEGIN
	PROCESS(clk)
	BEGIN
		IF(rising_edge(clk)) THEN

		RegDst <= NOT opcode(5); ------------------------- set Register destination
	 	ALUSrc <= opcode(5); ----------------------------- set ALU source 
		MemtoReg <= opcode(5); --------------------------- select memory to write to register
		RegWrite <= NOT(opcode(3) OR opcode(2)); --------- write to register
		MemRead <= opcode(5) AND NOT opcode(3); ---------- place contents of address in read data output
		MemWrite <= opcode(3); --------------------------- place contents of address in write data input
		Branch <= opcode(2); ----------------------------- branch instruction?
		ALUOp(1) <= NOT(opcode(5) OR opcode(2)); --------- set first ALUOp bit for R-format instruction
		ALUOp(0) <= opcode(2); --------------------------- set second ALUOp bit for branch instruction
		
		END IF;
	END PROCESS; 
END Boss;

--------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY ALUControl IS
	PORT(op: 	IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	     funct: 	IN STD_LOGIC_VECTOR(5 DOWNTO 0);
	     aluctrl: 	OUT STD_LOGIC_VECTOR(4 DOWNTO 0) );
END ENTITY ALUControl;

ARCHITECTURE bossy OF ALUControl IS

BEGIN
	aluctrl(4) <= NOT op(1) OR (funct(5) AND NOT funct(2));
	aluctrl(3) <= op(1) AND NOT funct(5);
	aluctrl(2) <= (NOT op(1) AND op(0)) OR (funct(5) AND funct(1));
	aluctrl(1) <= '0';
	aluctrl(0) <= op(1) AND (op(0) OR (NOT funct(5) AND funct(1)) OR
		       (funct(5) AND funct(0)));

END ARCHITECTURE bossy;

----------------------------------------------------------------------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Registers IS
    PORT(ReadReg1: 	IN STD_LOGIC_VECTOR(4 DOWNTO 0); 
         ReadReg2: 	IN STD_LOGIC_VECTOR(4 DOWNTO 0); 
         WriteReg: 	IN STD_LOGIC_VECTOR(4 DOWNTO 0);
	 WriteData: 	IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	 WriteCmd: 	IN STD_LOGIC;
	 ReadData1: 	OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	 ReadData2: 	OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END ENTITY Registers;

ARCHITECTURE remember OF Registers IS

	COMPONENT register32
  	    PORT(datain: 				IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 enout32, enout16, enout8: 		IN STD_LOGIC;
		 writein32, writein16, writein8: 	IN STD_LOGIC;
		 dataout: 				OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
	END COMPONENT;

	SIGNAL 	zeroVal: 
			STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000000000000000000000000";
	
	SIGNAL 	s0out, s1out, 
		s2out, s3out, 
		s4out, s5out, 
		s6out, s7out: 
			STD_LOGIC_VECTOR(31 DOWNTO 0);
	
BEGIN
	zero: 	register32 PORT MAP(zeroVal, '0', '0', '0', '0', '1', '1', zeroVal);
	s0: 	register32 PORT MAP(WriteData(31 DOWNTO 0), '0', '0', '0', WriteCmd, '1', '1', s0out);
	s1: 	register32 PORT MAP(WriteData(31 DOWNTO 0), '0', '0', '0', WriteCmd, '1', '1', s1out);
	s2: 	register32 PORT MAP(WriteData(31 DOWNTO 0), '0', '0', '0', WriteCmd, '1', '1', s2out);
	s3: 	register32 PORT MAP(WriteData(31 DOWNTO 0), '0', '0', '0', WriteCmd, '1', '1', s3out);
	s4: 	register32 PORT MAP(WriteData(31 DOWNTO 0), '0', '0', '0', WriteCmd, '1', '1', s4out);
	s5: 	register32 PORT MAP(WriteData(31 DOWNTO 0), '0', '0', '0', WriteCmd, '1', '1', s5out);
	s6: 	register32 PORT MAP(WriteData(31 DOWNTO 0), '0', '0', '0', WriteCmd, '1', '1', s6out);
	s7: 	register32 PORT MAP(WriteData(31 DOWNTO 0), '0', '0', '0', WriteCmd, '1', '1', s7out);
	
	WITH ReadReg1 SELECT ReadData1(31 DOWNTO 0) <=
		s0out WHEN "10000",
		s1out WHEN "10001",
		s2out WHEN "10010",
		s3out WHEN "10011",
		s4out WHEN "10100",
		s5out WHEN "10101",
		s6out WHEN "10110",
		s7out WHEN "10111",
		zeroVal WHEN OTHERS; 
		 
	WITH ReadReg2 SELECT ReadData2(31 DOWNTO 0) <=
		s0out WHEN "10000",
		s1out WHEN "10001",
		s2out WHEN "10010",
		s3out WHEN "10011",
		s4out WHEN "10100",
		s5out WHEN "10101",
		s6out WHEN "10110",
		s7out WHEN "10111",
		zeroVal WHEN OTHERS; 
		 
END remember;

------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY SignExtender IS
	PORT(datain: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	     dataout: OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END ENTITY SignExtender;

ARCHITECTURE behavior OF SignExtender IS
BEGIN
	dataout(15 DOWNTO 0) <= datain(15 DOWNTO 0);

	WITH datain(15) SELECT dataout(31 DOWNTO 16) <=
	"0000000000000000" WHEN '0',
	"1111111111111111" WHEN OTHERS;

END behavior;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
