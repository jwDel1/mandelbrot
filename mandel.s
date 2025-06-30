.text
.global _start

_start:
  
  la t1, gradient    # load the base address of buffer 
  li t0, 0
  li t3, 0
  li t4, 0
  la a3, one 
  fld f6, 0(a3) 
  la a3, negtwo
  fld f7, 0(a3)

iterateMan:	

  li t0, 0 
  li t2, 0 
  la a3, zip
  fld f0, 0(a3) 
	fld f1, 0(a3)     # Initializes all values to 0 in Loop
	fld f2, 0(a3) 	
	fld f3, 0(a3) 
	fld f4, 0(a3) 
	j outputLoop
	
imIterate: 

    la a3, negtwo
    fld f7, 0(a3)
    la a3, imIncr
    fld f8, 0(a3) 
    fadd.d f6, f6, f8
    j iterateMan 

 rlIterate: 

    la a3, rlIncr
    fld f8, 0(a3) 
    fadd.d f7, f7, f8
    
    # check if the im value is even negative one yet, if not just go back to iterating 

    la a3, two 
    fld f8, 0(a3)
    flt.s a3, f8, f7 
    la a4, negone
    fld f8, 0(a4)
    feq.s a4, f6, f8
    li a5, 1
    bne a4, a5, iterateMan
    la t4, gradient
    li t5, 0
    beq a4, a3, printMandel 
    li t6, x0
    j iterateMan
outputLoop:
    la a3, zip
    fld f8, 0(a3)    
    fld f2, 0(a3) 
    fld f3, 0(a3) 
    fld f4, 0(a3) 
    la a3, two
    fld f8, 0(a3) 
    fge.d a3, f4, f8 
    bne a3, x0, placeNone
    li a3, 20 
    bgt t0, a3, placeStar 
	
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
    li a0, t4 

    ecall

    addi t4, t4, 1 
    addi t5, t5, 1

    blq t6, 81, printMandel

    li t5, 0
    li a7, 4
    li a0, newLine

    ecall
    
    addi t6, t6, 1 

    blq t6, 41, printMandel
   
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
