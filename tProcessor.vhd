
--------------------------------------------------------------------------------
--
-- Test Bench for LAB #5
--
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY tProcessor_vhd IS
END tProcessor_vhd;

ARCHITECTURE behavior OF tProcessor_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT Processor
	PORT(
		instruction : IN std_logic_vector(31 downto 0);
		DataMemdatain : IN std_logic_vector(31 downto 0);
		clock : IN std_logic;          
		DataMemdataout : OUT std_logic_vector(31 downto 0);
		InstMemAddr : OUT std_logic_vector(31 downto 0);
		DataMemAddr : OUT std_logic_vector(31 downto 0);
		DataMemRead : OUT std_logic;
		DataMemWrite : OUT std_logic
		);
	END COMPONENT;

	--Inputs
	SIGNAL clock :          std_logic := '0';
	SIGNAL instruction :    std_logic_vector(31 downto 0) := (others=>'0');
	SIGNAL DataMemdatain :  std_logic_vector(31 downto 0) := (others=>'0');

	--Outputs
	SIGNAL DataMemdataout : std_logic_vector(31 downto 0);
	SIGNAL InstMemAddr :    std_logic_vector(31 downto 0);
	SIGNAL DataMemAddr :    std_logic_vector(31 downto 0);
	SIGNAL DataMemRead :    std_logic;
	SIGNAL DataMemWrite :   std_logic;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: Processor PORT MAP(
		instruction => instruction,
		DataMemdatain => DataMemdatain,
		DataMemdataout => DataMemdataout,
		InstMemAddr => InstMemAddr,
		DataMemAddr => DataMemAddr,
		DataMemRead => DataMemRead,
		DataMemWrite => DataMemWrite,
		clock => clock
	);

	tb : PROCESS
	BEGIN

		-- Wait 100 ns for global reset to finish
		wait for 100 ns;

		clock <= '1';
		wait for 1 ns;
		instruction <= B"000000_00000_00000_10000_00000_100000";	-- add $s0, $zero, $zero
		wait for 4 ns;							
		clock <= '0';
		wait for 5 ns;							-- $s0 = 0 (Datamemdataout = 0)
		clock <= '1';
		wait for 1 ns;
		instruction <= B"001000_00000_10001_0000000000001010";		-- addi $s1, $zero, 10
		wait for 4 ns;							
		clock <= '0';
		wait for 5 ns;							-- $s1 = 0x0000000A (Datamemdataout = 0x0000000A)
		clock <= '1';
		wait for 1 ns;
		instruction <= B"100011_10001_10010_0000000000000000";		-- lw $s2,0($s1)
		wait for 4 ns;							-- as if we are loading from location 0A
		clock <= '0';
		DataMemdatain <= X"AAAAAAAA";	-- simulation of the data being read with the lw instruction
		wait for 5 ns;							-- $s2 = 0xAAAAAAAA (DataMemAddr = 0x0000000A)
		clock <= '1';
		wait for 1 ns;
		instruction <= B"000000_00000_10010_10010_00011_000010";	-- srl $s2,$s2,3
		wait for 4 ns;															
		clock <= '0';
		DataMemdatain <= X"00000000";	
		wait for 5 ns;							-- $s2 = 0x15555555
		clock <= '1';
		wait for 1 ns;
		instruction <= B"101011_10001_10010_0000000000000000";		-- sw	$s2,0($s1) (DataMemAddr = 0x0000000A)
		wait for 4 ns;							-- 		    DataMemdataout = 0x15555555
		clock <= '0';
		wait for 5 ns;
		clock <= '1';
		wait for 1 ns;
		instruction <= B"000000_00000_10010_10011_00001_000000";	-- sll $s3,$s2,1
		wait for 4 ns;															
		clock <= '0';
		wait for 5 ns;							-- $s3 = 0x2AAAAAAA
		clock <= '1';
		wait for 1 ns;
		instruction <= B"000000_10011_10010_10100_00000_100010";	-- sub $s4,$s3,$s2
		wait for 4 ns;															
		clock <= '0';
		wait for 5 ns;							-- $s4 = 0x15555555
		clock <= '1';
		wait for 1 ns;
		instruction <= B"101011_10001_10100_0000000000000000";		-- sw $s4,0($s1)
		wait for 4 ns;							-- DataMemAddr = 0x0000000A, DataMemdataout = 0x15555555
		clock <= '0';

		-- Feel free to add more instruction testing

		wait; -- will wait forever
	END PROCESS;

END;
