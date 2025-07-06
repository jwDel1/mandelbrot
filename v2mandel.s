

# SECOND AND MOST UPDATED VERSION OF PROJECT


.text
.global _start

_start:

li s0, 1          #  
li s1, 1          #   
la s2, buffer     #  
la x1, minRl      # load address of minRL into x1 
fld fs0, 0(x1)    # load into fs0 from address stored in  x1
la x1, minIm      # load address of minRL into x2 
fld fs1, 0(x1)    # load into fs1 from address stored in  x2 
la x1, zip        #
fld fs2, 0(x1)    #
fld fs2, 0(x1)    #

math: 

la x1, zip        #
fld f0, 0(x1)     #
fld f1, 0(x1)     #
fld f2, 0(x1)     # 
fld f3, 0(x1)     # Initialize temp registers to 0

# 
rowIterate:

# Are saved registers necesary? Yes for the row number not for the column number 

storeStar:



storeBlank:



nextRow:

# Branch to store Star and Store blank
# 

printingLoop:

# Compare number of rows to 41 and if equal branch to a system exit
# Print each row one at a time 
#  
exitProgram:

 

.data
  
  .align 1

    buffer:

      .eqv WIDTH, 81
      .eqv HEIGHT, 41 
      .space WIDTH 
    
    minRl: .double -2.0

    minIm: .double -1.0 

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

# x1:

# FLOAT PT

# fs0: current rl
# fs1: current Im 
# fs2: magnitude of z 
