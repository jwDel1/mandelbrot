.text
.global _start

_start:

  la t1, gradient    # load the base address of buffer 
  li t0, 0
  li t3, 0
  li t4, 0
  la x1, one 
  fld f6, 0(x1) 
  la a3, negtwo
  fld f7, 0(x1)

iterateMan:	
 
  li t0, 0 
  li t2, 0 
  la x1, zip
  fld f0, 0(x1) 
	fld f1, 0(x1)     # Initializes all values to 0 in Loop
	fld f2, 0(x1) 	
	fld f3, 0(x1) 
	fld f4, 0(x1) 

	j outputLoop
	
imIterate: 

    la x1, negtwo
    fld f7, 0(x1)
    la x1, imIncr
    fld f8, 0(x1) 
    fadd.d f6, f6, f8

    j iterateMan 

 rlIterate: 

    la x1, rlIncr
    fld f8, 0(x1) 
    fadd.d f7, f7, f8
    
    # check if the im value is even negative one yet, if not just go back to iterating 

    la x1, two 
    fld f8, 0(x1)

    flt.s x1, f8, f7 

    la x2, negone
    fld f8, 0(x2)

    feq.s x2, f6, f8

    li x3, 1

    bne x2, x3, iterateMan

    la x1, gradient
    li x2, 0
    li x3, 81
    li x4, 41 
    beq a4, a3, printMandel 

    mv t6, x0 

    j iterateMan
outputLoop:
    la a3, zip
    fld f2, 0(a3) 
    fld f3, 0(a3)  
    la a3, two              # load the memory address for our 2.0 constant into register a3 
    fld f8, 0(a3)           # load from memory address of the 2.0 constant into register 

    fge.d a3, f4, f8        # float compare ~ f4 >= f8 ~ stores bool in a3
                            # comparing magnitude of z to 2, and if it exceeds
                            # it will (likely) diverge

    bne a3, x0, placeNone   # if  a3 != 0 -> branch placeNone  

    li a3, 20               # max iteration cnt before assuming convergence 
                            # can change later for accuracy

    bgt t0, a3, placeStar   # check if iteration cnt exceeds max iterations 
                            	
    # (f0 + f1)(f0 + f1) = f1^2 + 2(f1)(f0) + f0^2
    # STEP 2: calculating the z^2

    fmul.d f3, f1, f1 # f1^2 -> f3 // a^2
    fmul.d f2, f0, f0 # f0^2 -> f2 // bi^2
    fmul.d f5, f0, f1 # (f1)(f0) -> f5 // (a)(bi)
    la a3, two
    fld f8, 0(a3) 
    fmul.d f5, f5, f8  # 2(f5) -> f5 // 2(abi) 
    fadd.d f2, f2, f5 # f2 + f5 -> f2 // 2abi + bi^2

    # Now our Rl part of z is stored in register f3 and Im in f2
    # STEP 3: adding c to z^2 

    fadd.d f0, f2, f7  # f2 + f7 -> f2 // adding bi_(c) to our Im part of z 
    fadd.d f1, f3, f6  # f1 + f6 -> f1 // adding a_(c) to our Rl part of z

    # the magnitude of z

    fmul.d f3, f1, f1 # f1^2 -> f3
    fmul.d f2, f0, f0 # f0^2 -> f2
    fadd.d f4, f3, f2  # f3 + f2 -> f4
    fsqrt.d f4, f4 

		# increment memory address and put corresponding value or no value 	
		# Once 20 iterations are up we have to reset Re and Im values
    
		addi t0, t0 , 1 # Increment iteration cntr by one
		j outputLoop # "Jump" to "outputLoop" tag when we reach the end
	
	
placeStar:

    la a3, star
    lb t2, 0(a3) 
    add t3, t1, t4 
    sb t2, 0(t3)
    mv t0, x0
    addi t4, t4, 1
    la a3, negtwo 
    fld f8, 0(a3) 

    feq.s a3, f0, f8 

    bne a3, x0, imIterate 

    j rlIterate

placeNone:
     
    la a3, blank
    lb t2, 0(a3) 
    add t3, t1, t4
    sb t2, 0(t3)    
    mv t0, x0
    addi t4, t4, 1
    la a3, negtwo 
    fld f8, 0(a3) 

    feq.s a3, f0, f8 

    bne a3, x0, imIterate 

    j rlIterate 

printMandel: 

    li a7, 4        # 4 is syscall for print in RARS
    mv a0, x1 
 
    ecall

    addi x1, x1, 1 
    addi x2, x2, 1

    ble t6, x3, printMandel

    li x2, 0
    li a7, 4
    la a0, newLine 

    ecall
    
    addi x2, x2, 1 
    
    ble x2, x4, printMandel
   
    li a7, 93 
    ecall

    .data	

      .align 1 # Alligns data to multiples of half-word
               # (4 bytes) the number specifies the power (2^1=2)

	      gradient:  

         	.eqv BUFFER_SIZE, 3321 #WIDTH*HEIGHT 81*41	
        	.space BUFFER_SIZE # Initializes all 3321 positons to ' ' 

        negtwo: .double -2.0 
         
        negone: .double -1.0 

        imIncr: .double -0.05
          
        zip: .double 0.0 
          
        rlIncr: .double 0.05
               
        one: .double 1.0 
          
        two: .double 2.0 
          
        newLine: .string "\n" 
           
        star: .string "*"

        blank: .string " " 
    
# a0 = file descriptor for print
# a1 = gradient adress
# a2 = message length
# a3 = general purpose temp address storing register
# a7 = syscall register
# t0 = iteration cnt (STARTS AT 0)
# t1 = Address of mem 
# t2 = Output Char 
# t3 = Displacement Address  
# t4 = Increment for displacement address 
# t5 = iteration ct for x axis 
# t6 = iteration ct for y axis  
# f0 = z_Img (STARTING AT 0.0)
# f1 = z_Rl (STARTING AT 0.0) 
# f2 = Im
# f3 = Rl
# f4 = magn_Z
# f5 = Temp var for the 2(a)(bi) 
# f6 = temp_img 
# f7 = temp_rl 
# f8 = general purpose temp var float register for immediate adds and mults
