# COL215 Lab Assignments

### Authors  : 

   
    Divyanshu Agarwal (2020CS10343)

    Tanish Gupta (2020CS10397)


### Logistics


  1. Hardware description language used   - VHDL
  2. Tool used for simulation             - [EdaPlayground](https://www.edaplayground.com/)
  3. Software used for synthesis          - Xilinx's Vivado 2019.1

  Vivado was used for synthesis, implementation (placing, optimising and routing the design), and generating bitsream.
  
  The constraint file has been written for the Digilent's Basys 3 board. It utilises an Artix-7 35T FPGA.  This board is a complete, ready-to-use digital circuit development platform based on the latest Artix®-7 Field Programmable Gate Array (FPGA) from Xilinx®. With its high-capacity FPGA (Xilinx part number **XC7A35T1CPG236C**). Documentation for the board can be found [here](https://digilent.com/reference/programmable-logic/basys-3/reference-manual). 

### About Repository

The repository contains various projects named as the assignment number. Each assignment contains an additional file named Assignmentx_Report.pdf, where x is the assignment number. This report is a description of the strategies used to do the assignment and accomplish the required task. 

Each assignment also contains a file named Assignment-x.pdf, where x is the assignment number. This file contains the problem statement for each assignment.

PS: Assignment-1 was non-graded and was only for practice. Hence, it hasn't been included in the repository.

### Running the projects

To run the projects on Vivado, open the .xpr file of the project in Vivado, this will automatically open and load the project in vivado . 

Alternatively if you want to access the separate files then they can be found in the corresponding Assignment folder at the following relative paths : 

**VHDL Source File(s)**  **:** ``` <Assignment-name>.srcs/sources_1/new/```

**Constraint File  :**    	 ```<Assignment-name>.srcs/constrs_1/new/```

**Bitstream (.bit) :** 	    ```<Assignment-name>.runs/impl_1/```



