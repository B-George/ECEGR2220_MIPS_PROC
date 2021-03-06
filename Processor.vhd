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

-----------Signals
	SIGNAL 	alu_In1, 
		alu_In2, 
		alu_Res, 
		reg_Write_Dat, 
		reg_Dat1, 
		reg_Dat2, 
		imm_Result: 
			STD_LOGIC_VECTOR(31 DOWNTO 0);

	SIGNAL  ctrl_Op, 
		alu_Func: 
			STD_LOGIC_VECTOR(5 DOWNTO 0);

	SIGNAL  read_Reg1,
		read_Reg2, 
		write_Reg, 
		alu_Ctrl: 
			STD_LOGIC_VECTOR(4 DOWNTO 0);
 
	SIGNAL  alu_Op: 
			STD_LOGIC_VECTOR(1 DOWNTO 0);

	SIGNAL  ck, 
		reg_Dst, 
		br, 
		mem_Read,
		mem_to_Reg, 
		mem_Write, 
		alu_Src, 
		reg_Write, 
		zed, 
		write_Com, 
		inst_Mux_Sel, 
		alu_Mux_Sel, 
		out_Mux_Sel: 
			STD_LOGIC;

	SIGNAL alu_Op_Code: 
			STD_LOGIC_VECTOR(1 DOWNTO 0);

BEGIN
	-- Signal Assignment
	ck <= clock;

	-- Registers
	mainReg: Registers	PORT MAP(instruction(25 DOWNTO 21),
					 instruction(20 DOWNTO 16),
					 write_Reg(4 DOWNTO 0),
					 reg_Write_Dat(31 DOWNTO 0),
					 write_Com,
					 reg_Dat1(31 DOWNTO 0),
					 reg_Dat2(31 DOWNTO 0));
		 
	-- Instantiate Mux components
	instMUX:SmallBusMux2to1 PORT MAP(inst_Mux_Sel,
					 instruction(20 DOWNTO 16), 
					 instruction(15 DOWNTO 11), 
					 write_Reg(4 DOWNTO 0));

	aluMUX: BusMux2to1 	PORT MAP(alu_Mux_Sel,
					 reg_Dat2(31 DOWNTO 0), 
					 imm_Result(31 DOWNTO 0), 
					 alu_In2(31 DOWNTO 0)); 

	outMUX: BusMux2to1	PORT MAP(mem_to_Reg,
					 DataMemDatain(31 DOWNTO 0),
					 alu_Res(31 DOWNTO 0), 
					 reg_Write_Dat(31 DOWNTO 0));
	
	-- Instantiate master control
	ctrl: Control		PORT MAP(instruction(31 DOWNTO 26), 
					 clock, 
					 reg_Dst,
					 br,
					 mem_Read,
					 mem_to_Reg,
					 alu_Op_Code(1 DOWNTO 0),
				 	 mem_Write,
					 alu_Src,
					 reg_Write);
					   
	-- ALU control unit
	alu_Control: ALUControl	PORT MAP(alu_Op_Code(1 DOWNTO 0), 
					 instruction(5 DOWNTO 0), 
					 alu_Ctrl(4 DOWNTO 0));

	-- Main ALU
	alu1: ALU		PORT MAP(reg_Dat1(31 DOWNTO 0), 
					 alu_In2(31 DOWNTO 0), 
					 alu_Ctrl(4 DOWNTO 0), 
					 zed, 
					 alu_Res(31 DOWNTO 0));
		   
	-- Sign extender
	se: SignExtender	PORT MAP(instruction(15 DOWNTO 0),
					 imm_Result);

	DataMemRead <= mem_Read;
	DataMemWrite <= mem_Write;
	DataMemDataout(31 DOWNTO 0) <= reg_Dat2(31 DOWNTO 0);
	DataMemAddr(31 DOWNTO 0) <= alu_Res(31 DOWNTO 0);
		
	 
				 
END holistic;

