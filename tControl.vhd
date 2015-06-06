--------------------------------------------------------------------------------
--
-- Test Bench for LAB #5 - Control Entity
--
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY tControl_vhd IS
END tControl_vhd;

ARCHITECTURE behavior OF tControl_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT Control
	PORT(
		opcode : IN std_logic_vector(5 downto 0);
		clk : IN std_logic;          
		RegDst : OUT std_logic;
		Branch : OUT std_logic;
		MemRead : OUT std_logic;
		MemtoReg : OUT std_logic;
		ALUOp : OUT std_logic_vector(1 downto 0);
		MemWrite : OUT std_logic;
		ALUSrc : OUT std_logic;
		RegWrite : OUT std_logic
		);
	END COMPONENT;

	--Inputs
	SIGNAL clock :  std_logic := '0';
	SIGNAL opcode :  std_logic_vector(5 downto 0) := (others=>'0');

	--Outputs
	SIGNAL RegDst :  std_logic;
	SIGNAL Branch :  std_logic;
	SIGNAL MemRead :  std_logic;
	SIGNAL MemtoReg :  std_logic;
	SIGNAL ALUOp :  std_logic_vector(1 downto 0);
	SIGNAL MemWrite :  std_logic;
	SIGNAL ALUSrc :  std_logic;
	SIGNAL RegWrite :  std_logic;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: Control PORT MAP(
		opcode => opcode,
		clk => clock,
		RegDst => RegDst,
		Branch => Branch,
		MemRead => MemRead,
		MemtoReg => MemtoReg,
		ALUOp => ALUOp,
		MemWrite => MemWrite,
		ALUSrc => ALUSrc,
		RegWrite => RegWrite
	);

	tb : PROCESS
	BEGIN

		-- Wait 100 ns for global reset to finish
		wait for 100 ns;

		clock <= '1';
		opcode <= B"000000";	-- R-type instruction
		wait for 5 ns;
		clock <= '0';
		wait for 5 ns;
		clock <= '1';
		opcode <= B"001000";	-- addi
		wait for 5 ns;
		clock <= '0';
		wait for 5 ns;
		clock <= '1';
		opcode <= B"100011";	-- lw
		wait for 5 ns;
		clock <= '0';
		wait for 5 ns;
		clock <= '1';
		opcode <= B"101011";	-- sw
		wait for 5 ns;
		clock <= '0';
		wait for 5 ns;
		clock <= '1';

		wait; -- will wait forever
	END PROCESS;

END;
