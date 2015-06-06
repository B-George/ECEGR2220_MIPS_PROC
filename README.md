# ECEGR2220_MIPS_PROC
Lab #5
Creating the Single Cycle Processor
Due: June 8, 2015

Purpose:
In this lab you will write VHDL code to implement Figure 4.17 of the text minus the Instruction Memory block and the Data Memory block. They will be simulated with the test bench. You will build upon the components you created in Labs #3 and #4. The registers need some modification as described below. You will be able to demonstrate that they work correctly by use of a testbench file, also in VHDL. In the figure below, Figure 4.17 has been modified by identifying input and output signals from Processor.vhd in red. This should help your work.
 
figure 4.17 ---> http://i.imgur.com/FxxRowV.png

Preparation:
	You will complete the single cycle MIPS 32 bit processor leveraging the VHDL code for register, shift register, and ALU from the previous two labs.
	The discussion of this design in section 4.4 of the text should be useful in undertaking the task. The starting files titled ‘Processor.vhd’ and ‘ProcElements.vhd’. There is also a file called ‘tProcessor.vhd’ which will serve as a testbench for testing your design, and ‘tControl.vhd’, which lets you test the Control module alone.
The registers designed in the Lab #3 were intended to be used in a multi-cycle processor with a single unified bus. For the single cycle processor as described in the text, you will use the register32 entity from Lab #3 but always enable the 32 bit output. The starter file Processor.vhd gives you the entity for the overall design and the components for the Processor architecture ‘holistic’. 

You are to design the following objects:

1.	A register file with $s0-$s7 and $zero registers in it. The entity is given in ProcElements.vhd  It is not more complicated to implement all 32 registers, just more time consuming, so you are not required to do them all.
2.	The Control and ALU Control blocks to direct data and operations for each instruction. Remember, it is intended that all these objects are combinational, not sequential circuits.
3.	A multiplexer (mux) to select one of two 32-bit busses to the output. This is used in 3 places in Fig. 4.17
4.	The Processor implementation that ties all the parts together and executes the “program” of the test bench.


Your processor needs to support the following instruction set:

	add
	sub
	addi
  and
  or
  ori
  sll
  srl
	lw
	sw

Procedure:
1.	Add all the VHDL files from Canvas for this lab to your project. You can use the instructions from Lab #1 to build a new project and add files to it.
2.	Use as a testbench the tprocessor.vhd file. This includes an Instruction Memory and Data Memory and will exercise the processor under simulation.
3.	Add your ALU and register32 from earlier labs as a part of this project
4.	Complete the full implementation of the MIPS single cycle processor by implementing the architecture bodies of all the components. The “Add your code here” comments indicate where you need to finish the implementation.
5.	Simulate your design using the test bench and verify that all the instructions are operational.  
6.	You may want to extend the test “program” to exercise more instructions. You may also implement a SPIM program to compare your simulation results against the QtSpim simulation.  This step is not required for the lab, but I would recommend it to make sure your design works well.
7.	You do not need to implement the Program Counter (PC), the PC incrementing logic, instruction memory or data memory.  Those are all simulated by the tProcessor test bench code.
 

Extra Credit:

For those that want an extra challenge, you can implement any of the following items for extra credit:

1.	Shift register that can support the full 5 bits for the shamt value (0 to 32)
2.	Implement the PC register and update it as the test bench program executes. Assume a starting address of 0x00400000. Note that the test bench doesn’t support instructions read from memory, so the PC is just a “fake” one.
3.	Add support for the j (Jump Immediate) instruction
4.	Add support for the jr (Jump Register) instruction
5.	Add support for the comparison instructions: slt, slti, sltiu, sltu
6.	Add support for the branch instructions: beq, bne
7.	Add an overflow indicator signal from the ALU that outputs 1 when add, addi or sub causes an overflow condition.
8.	Any other MIPS operation not described above
9.	Anything else that sounds cool to do (but pass the idea by me first for approval)

You will need to modify the test bench code to prove that changes actually function correctly.  Note that items 3 and 4 require item 2 to be functional.

Adding support for additional instructions may require you to change the number of control bits for your ALUOp and ALUControl lines.

To get credit, you must indicate in your lab report what you implemented, how you changed the design to support the functionality, what you added to the test bench to test the implementation, and how you know it works (in other words, explain your test cases and how they provide adequate test coverage).


Lab Report
You will submit a Word document containing your report and file(s) containing your final, working VHDL source code and submit it to Canvas. Your report will have the following sections.
a.	Cover Page with lab title and your name.
b.	A brief description of the design
c.	Truth table(s) for control logic
d.	A description of how you tested your CPU design and how you made sure it works
e.	Explain how you would improve the design of the test bench.  What is it lacking in your opinion?
f.	Extra credit implementation write-ups

Files to be submitted:
Lab report
VHDL source code for all your components
Any MIPS assembly code you may have written to expand the testing of the Processor

