

# SECOND AND MOST UPDATED VERSION OF PROJECT


.text
.global _start

_start:

li s0, 0                  # cntr for rL axis 
li s1, 0                  # cntr for Im axis 
li s2, 0                  # cntr for z iterations in math segment 

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

beq x1, x2, storeBlank    # if the bool stored in x1 from the compare isn't one we know that our magnitude exceeds two and therfor the set diverges (excluded) for this c value 

li x1, 19                 # load 19 into x1 to compare to z counter

beq s2, x1, placeStar     # branch to inclusion in set if max iterations are reached 

addi s2, s2, 1            # Increment the count of z iterations

j math                    # If no branch repeat

storeStar:

li x1, s2               # load our buffer address into x1 
add x1, s2, s0          # add the Rl value counter to our buffer address serving as an offset
lb star, 0(x1)          # store a star in register address s2 + s0 or s2 + 1n 

li x1, x0               #  

li x1, WIDTH            #
beq s0, x1, printRow    # Check if s0 is at 81

addi s0, s0, 1          # Increment Rl value counter

j nextRl                # jump to our increment 

storeBlank:

li x1, s2               # load our buffer address into x1 
add x1, s2, s0          # add the Rl value counter to our buffer address serving as an offset
lb empty, 0(x1)          # store a star in register address s2 + s0 or s2 + 1n 

li x1, x0               #  

li x1, WIDTH            #
beq s0, x1, printRow    # Check if s0 is at 81

addi s0, s0, 1          # Increment Rl value counter

j nextRl                # jump to our increment 

nextRl:



printRow:



nextRow:



exit:

 

.data
  
  .align 1

    buffer:

      .eqv WIDTH, 81
      .eqv HEIGHT, 41 
      .space WIDTH 
    
    minRl: .double -2.0

    minIm: .double -1.0 

    decrement: .double -0.05

    zip: .double 0.0              # Big shoutout to Paul G. Hewitt

    increment: .double .05

    maxIm: .double 1.0

    maxRl: .double 2.0     

    star: .string "*"

    empty: .string " "















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
