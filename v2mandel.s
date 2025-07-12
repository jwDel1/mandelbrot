

# CURRENT VERSION


.text
.global _start

_start:

  mv s0, x0                 # cntr for rL axis 
  mv s1, x0                 # cntr for Im axis 
  mv s2, x0                 # cntr for z iterations in math segment 
  mv x1, x0                 # initialize x1 
  mv x2, x0                 #

  la s3, buffer             #  

  la x1, minRl              # load address of minRL into x1 
  fld fs0, 0(x1)            # load into fs0 from address stored in  x1
  la x1, maxIm              # load address of minRL into x2 
  fld fs1, 0(x1)            # load into fs1 from address stored in  x2 

  la x1, zip                # for storing 
  fld fs2, 0(x1)            # magnitude of z iteration
  fld fs3, 0(x1)            #

  la x1, increment          #
  fld fs4, 0(x1)            #

  la x1, decrement          #
  fld fs5, 0(x1)            #

math: 

  la x1, zip                #
  fld f2, 0(x1)             # Initialize temp registers to 0 
  fld f3, 0(x1)             #

  fmul.d f2, f0, f1         # 
  la x1, two                # 
  fld f31, 0(x1)            #
  fmul.d f2, f2, f31        # store the middle term in a+bi binomial expansion (2(a)(bi))

  fmul.d f1, f1, f1         # square the bi term in binomial expansion
  fadd.d f1, f1, f3         # add the squared term to our middle term -> register f1 for new bi term

  fmul.d f0, f0, f0         # square our real term in binomial expansion

  fadd.d f0, f0, fs0        # add the real part of c to our real part of z 
  fadd.d f1, f1, fs1        # add the Im part of c to Im part of z

  fmul.d f2, f0, f0         # 
  fmul.d f3, f1, f1         #
  fadd.d f2, f2, f3         #
  fsqrt.d fs2, f2           #

  la x1, two                #
  fld f31, 0(x1)            # load 2.0 into register f31
  fge.d x1, fs2, f31        # compare our magnitude to f31

  li x2, 1                  # 

  beq x1, x2, storeBlank    # if the bool stored in x1 from the compare isn't one we know that our 
                            # magnitude exceeds two and therfor the set diverges (excluded) for this c value   

  li x1, 19                 # load 19 into x1 to compare to z counter

  beq s2, x1, storeStar     # branch to inclusion in set if max iterations are reached 

  addi s2, s2, 1            # Increment the count of z iterations

  j math                    # If no branch repeat

storeStar:
 
  add x1, s3, s0          # add the Rl value counter to our buffer address serving as an offset
  la x2, star             #
  sb x2, 0(x1)            # store a star in register address s2 + s0 or s2 + 1n 

  mv x1, x0               #  

  li x1, 80               # 
  beq s0, x1, printRow    # Check if s0 is at 81

  addi s0, s0, 1          # Increment Rl value counter

  j nextRl                # jump to our increment 

storeBlank:
  
  add x1, s3, s0          # add the Rl value counter to our buffer address serving as an offset
  la x2, empty             #
  sb x2, 0(x1)            # store a star in register address s2 + s0 or s2 + 1n 

  mv x2, x0               #

  li x1, 80               #
  beq s0, x1, printRow    # Check if s0 is at 81

  addi s0, s0, 1          # Increment Rl value counter

  j nextRl                # jump to our increment 

nextRl:

  la x1, increment        #
  fld f31, 0(x1)          #
  fadd.d fs0, fs0, f31    #

  j math                  #

printRow:

  li x1, s3               # load buffer address into x1 

  li a7, 4                # syscall for print
  mv a0, x1               # mem address for buffer into a0 

  ecall                   #  

  addi x2, x2, 1          #
  add x1, x1, x2          #

  li x1, 80               #

  beq x2, x1, nextRow     #

  j printRow              #

nextRow:
  
  li x1, 40               #
  beq s1, x1, exit        # compare if number of rows is at max and then branch to program exit if so 

  li s0, 0                # reset rl value counter

  la x1, decrement        #
  fld f31, 0(x1)          #
  fadd.d fs1, fs1, f31    # decrement fs1

  la x1, minRl            # reset fs0 to minRl
  fld fs0, 0(x1)          # 
 
  addi s1, s1, 1          # increment s1 Im counter

  li a7, 4                # 4 syscall for print string
  la a0, newLine          # 
  ecall                   # switch to newline for next print

  j math                  #

exit:

  li a7, 93
  ecall
 
.data
  
  .align 1
 
    buffer:

      .space 81 
    
    minRl: .double -2.0

    minIm: .double -1.0 

    decrement: .double -0.05

    zip: .double 0.0              # Big shoutout to Paul G. Hewitt

    increment: .double .05

    maxIm: .double 1.0

    maxRl: .double 2.0     

    star: .string "*"

    empty: .string " "

    newLine: .string "\n"













# REGISTERS

# s0: counts the number of rows 
# s1: counts the number of columns
# s2: holds our buffer address

# GNRL PURPOSE INT

# x1: temp var mostly used for loading addresses to fld instruction 

# FLOAT PT

# f0: Rl value for the iteration
# f1: Im value for the iteration 
# f2: stores the middle term of binomial expansion (temporarily)
# f3
# f4
# f5

# f31: general purpose temp var

# fs0: current rl
# fs1: current Im 
# fs2: magnitude of z 
