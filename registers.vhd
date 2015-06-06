--------------------------------------------------------------------------------
-- Benjamin George
-- ECEGR_2220
-- LAB #3
-- 5.1.2015
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Single Bit Storage -- unmodified, included in given project files
--------------------------------------------------------------------------------
Library ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY bitstorage IS
	PORT(bitin: IN STD_LOGIC;
	     enout: IN STD_LOGIC;
	     writein: IN STD_LOGIC;
	     bitout: OUT STD_LOGIC);
END ENTITY bitstorage;

ARCHITECTURE memlike OF bitstorage IS
	SIGNAL q: STD_LOGIC;
BEGIN
	process(writein) IS
	BEGIN
		IF (rising_edge(writein)) THEN
			q <= bitin;
		END IF;
	END process;
	
	-- Note that data is output only when enout = 0	
	bitout <= q WHEN enout = '0' ELSE 'Z';
END ARCHITECTURE memlike;
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- fulladder -- unmodified -- included in given project files
--------------------------------------------------------------------------------
Library ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY fulladder IS

    PORT (a : IN STD_LOGIC;
          b : IN STD_LOGIC;
          cin : IN STD_LOGIC;
          sum : OUT STD_LOGIC;
          carry : OUT STD_LOGIC
         );

END fulladder;

ARCHITECTURE addlike OF fulladder IS

BEGIN

  sum   <= a XOR b XOR cin; 
  carry <= (a AND b) OR (a AND cin) OR (b AND cin); 

END ARCHITECTURE addlike;
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- register8 -- assembles 8 individual bitstorage components into 1 Byte register
--------------------------------------------------------------------------------

Library ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY register8 IS

	PORT(datain: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	     enout:  IN STD_LOGIC;
	     writein: IN STD_LOGIC;
	     dataout: OUT STD_LOGIC_VECTOR(7 DOWNTO 0));

END ENTITY register8;

ARCHITECTURE memmy OF register8 IS

	COMPONENT bitstorage -- individual bit component, used below
		PORT(bitin: IN STD_LOGIC;
      	 	     enout: IN STD_LOGIC;
	 	     writein: IN STD_LOGIC;
	 	     bitout: OUT STD_LOGIC);
	END COMPONENT bitstorage;

BEGIN
	-- instantiate each bit, populate with incoming data
	reg0: bitstorage PORT MAP(datain(0), enout, writein, dataout(0));
	reg1: bitstorage PORT MAP(datain(1), enout, writein, dataout(1));
	reg2: bitstorage PORT MAP(datain(2), enout, writein, dataout(2));
	reg3: bitstorage PORT MAP(datain(3), enout, writein, dataout(3));
	reg4: bitstorage PORT MAP(datain(4), enout, writein, dataout(4));
	reg5: bitstorage PORT MAP(datain(5), enout, writein, dataout(5));
	reg6: bitstorage PORT MAP(datain(6), enout, writein, dataout(6));
	reg7: bitstorage PORT MAP(datain(7), enout, writein, dataout(7));
	
END ARCHITECTURE memmy;
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- register32 -- assembles 4 register8 components to create 1-4 Byte register
--------------------------------------------------------------------------------

Library ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY register32 IS
	PORT(datain: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
       	     enout32,enout16,enout8: IN STD_LOGIC;
	     writein32, writein16, writein8: IN STD_LOGIC;
	     dataout: OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END ENTITY register32;

ARCHITECTURE biggermem OF register32 IS

	COMPONENT register8 IS -- each component is 1 Byte
		PORT(datain: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		     enout:  IN STD_LOGIC;
		     writein: IN STD_LOGIC;
		     dataout: OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
	END COMPONENT register8;
	
	-- signals used to determine number of Bytes used
	SIGNAL out8, out16, out32, win8, win16, win32 : STD_LOGIC; 

BEGIN
	-- assign values to signals
	win8 <= writein8 OR writein16 OR writein32;
	win16 <= writein16 OR writein32;
	win32 <= writein32;

	out8 <= (enout8 AND enout16 AND enout32);
	out16 <= (enout16 AND enout32);
	out32 <= (enout32);

	-- instantiate each individual Byte
	reg4: register8 PORT MAP(datain(31 DOWNTO 24), out32, win32, dataout(31 DOWNTO 24));
	reg3: register8 PORT MAP(datain(23 DOWNTO 16), out32, win32, dataout(23 DOWNTO 16));
	reg2: register8 PORT MAP(datain(15 DOWNTO 8), out16, win16, dataout(15 DOWNTO 8));
	reg1: register8 PORT MAP(datain(7 DOWNTO 0), out8, win8, dataout(7 DOWNTO 0));

END ARCHITECTURE biggermem;
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- adder_subtractor -- in: 2 X n bit signed binary
--                     out: 1 X n bit signed binary
--------------------------------------------------------------------------------

Library ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY adder_subtracter IS

	--GENERIC(n: INTEGER := 32); --default number of bits = 32

	PORT(	datain_a: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		datain_b: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		add_sub: IN STD_LOGIC;  -- subtraction select signal
		dataout: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		co: OUT STD_LOGIC); --carry out bit

END ENTITY adder_subtracter;

ARCHITECTURE calc OF adder_subtracter IS

 	-- temporary result for extracting the unsigned overflow bit
 	SIGNAL result: STD_LOGIC_VECTOR(32 DOWNTO 0);
 	-- temporary result for extracting the carry bit
 	SIGNAL carryBits: STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

 	PROCESS(add_sub, datain_a, datain_b)
 	BEGIN
 		IF (add_sub = '0') THEN -- addition
 			-- the two operands are zero extended one extra bit before adding
 			-- the & is for string concatination
 			result <= ('0' & datain_a) + ('0' & datain_b);
 			carryBits <= ('0' & datain_a(30 DOWNTO 0)) + ('0' & datain_b(30 DOWNTO 0));		
		ELSE -- subtraction
		 	-- the two operands are zero extended one extra bit before subtracting
 			-- the & is for string concatination
 			result <= ('0' & datain_a) - ('0' & datain_b);
 			carryBits <= ('0' & datain_a(30 DOWNTO 0)) - ('0' & datain_b(30 DOWNTO 0));
 		END IF;
	END PROCESS;
			dataout <= result(31 DOWNTO 0); -- extract the n-bit result
 			co <= result(n) XOR carryBits(n-1); -- get signed overflow bit
END ARCHITECTURE calc;

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- shift_register -- in: n bit binary string, shift left/right bit, 5 bit shift amount
--                   out: shifted n bit binary string
--------------------------------------------------------------------------------

Library ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY shift_register IS

	GENERIC(n: INTEGER := 32); --default number of bits = 32

	PORT(	datain: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	   	dir: IN STD_LOGIC;
		shamt:	IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		dataout: OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END ENTITY shift_register;

ARCHITECTURE shifter OF shift_register IS

	-- signals used for typecasting and manipulation
	SIGNAL shamtInt: INTEGER RANGE 0 TO 31;
	SIGNAL shamtUS: IEEE.NUMERIC_STD.UNSIGNED(4 DOWNTO 0);
	SIGNAL datainsig: IEEE.NUMERIC_STD.UNSIGNED(31 DOWNTO 0);
	SIGNAL dataoutsig: IEEE.NUMERIC_STD.UNSIGNED(31 DOWNTO 0);
	

BEGIN
	-- typecast input to signals
	shamtUS <= IEEE.NUMERIC_STD.UNSIGNED(shamt);
	shamtInt <= to_integer(shamtUS);
	datainsig <= IEEE.NUMERIC_STD.UNSIGNED(datain);
	
PROCESS (dir, shamt) 
	BEGIN
		-- shift operation, uses internal shift functions
		IF (dir = '0') THEN
			dataoutsig <= datainsig SRL (shamtInt);
		ELSE
			dataoutsig <= datainsig SLL (shamtInt);
		END IF;
	
	END PROCESS;
	
	-- send shifted 32 bit string to output
	dataout <= STD_LOGIC_VECTOR(dataoutsig);

END ARCHITECTURE shifter;
