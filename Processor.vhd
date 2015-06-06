--------------------------------------------------------------------------------
--
-- LAB #5 - Processor 
--
--------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Processor IS
    PORT ( instruction :    IN  STD_LOGIC_VECTOR (31 DOWNTO 0); 
           DataMemdatain :  IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
           DataMemdataout : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
           InstMemAddr :    OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
           DataMemAddr :    OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	   DataMemRead :    OUT STD_LOGIC;
	   DataMemWrite :   OUT STD_LOGIC;
           clock :          IN  STD_LOGIC);
END Processor;

ARCHITECTURE holistic OF Processor IS
	COMPONENT Control
   	     PORT(opcode :	IN  STD_LOGIC_VECTOR (5 DOWNTO 0);
	           clk : 	IN  STD_LOGIC;
	           RegDst : 	OUT  STD_LOGIC;
	           Branch : 	OUT  STD_LOGIC;
	           MemRead : 	OUT  STD_LOGIC;
	           MemtoReg : 	OUT  STD_LOGIC;
	           ALUOp : 	OUT  STD_LOGIC_VECTOR(1 DOWNTO 0);
	           MemWrite : 	OUT  STD_LOGIC;
	           ALUSrc : 	OUT  STD_LOGIC;
	           RegWrite : 	OUT  STD_LOGIC);
	END COMPONENT;

	COMPONENT ALUControl
	     PORT(op: 		IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    	          funct: 	IN STD_LOGIC_VECTOR(5 DOWNTO 0);
	          aluctrl: 	OUT STD_LOGIC_VECTOR(4 DOWNTO 0) );
	END COMPONENT;

	COMPONENT ALU
		PORT(DataIn1: 	IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		     DataIn2: 	IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		     Control: 	IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		     Zero: 	OUT STD_LOGIC;
		     ALUResult: OUT STD_LOGIC_VECTOR(31 DOWNTO 0) );
	END COMPONENT;
	
	COMPONENT Registers
	    PORT(ReadReg1: 	IN STD_LOGIC_VECTOR(4 DOWNTO 0); 
                 ReadReg2: 	IN STD_LOGIC_VECTOR(4 DOWNTO 0); 
                 WriteReg: 	IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 WriteData:	IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 WriteCmd: 	IN STD_LOGIC;
		 ReadData1: 	OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 ReadData2: 	OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT BusMux2to1
		PORT(selector: 	IN STD_LOGIC;
		     In0, In1: 	IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		     Result: 	OUT STD_LOGIC_VECTOR(31 DOWNTO 0) );
	END COMPONENT;
	
	COMPONENT SmallBusMux2to1
		PORT(selector: 	IN STD_LOGIC;
		     In0, In1: 	IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		     Result: 	OUT STD_LOGIC_VECTOR(4 DOWNTO 0) );
	END COMPONENT SmallBusMux2to1;

	COMPONENT SignExtender 
		PORT(datain: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		     dataout: OUT STD_LOGIC_VECTOR(31 DOWNTO 0) );
	END COMPONENT SignExtender; 	
BEGIN
	
END holistic;
