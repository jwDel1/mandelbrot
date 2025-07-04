

# SECOND AND MOST UPDATED VERSION OF PROJECT


.text
.global _start

_start:


.data
  
  .align 1

    gradient:
      .eqv WIDTH, 81
      .eqv HEIGHT, 41
      .eqv BUFFER_SIZE, 3321
      .space BUFFER_SIZE
    
    minRl: .double -2.0

    minIm: .double -1.0 

    zip: .double 0.0              # Big shoutout to Paul G. Hewitt

    increment: .double .05

    maxIm: .double 1.0

    maxRl: .double 2.0     

















# REGISTERS

# GNRL PURPOSE INT
# x1: holds the memory address of the buffer

# FLOAT PT
# f0: 
