.macro rti
custom0 0,0,0,0
.endm

.macro rtt
custom0 0,0,0,8
.endm

.macro gtret rd
custom0 \rd,0,0,9
.endm


.text
# reset vector at 0x0
.= 0x0
	j main

# interrupt service routine at 0x8
.= 0x8
	j isr

# software trap handler at 0x10
.=0x10

trap:
	gtret x1
	li t1,0x10000000
	li t5,0x4
	sb t5,0(t1)

	# delay return from trap a bit so LED is visible
	li t2,99999
loop_trap_delay:
	addi t2,t2,-1
	bne t2,zero,loop_trap_delay

	# return from trap
	rtt



isr: 	li t1,0x10000000
	li t5,0x2
	sb t5,0(t1)
	rti

# we should only end up here if rti fails
fail:
	li t5,0x8
	sb t5,0(t1)
	j fail

# main program: flicker one board LED
main:
	li t1,0x10000000
	li t0,0x1
	sb t0,0(t1)

	li t2,99999
loop1:
	addi t2,t2,-1
	bne t2,zero,loop1


	# this will trigger a software trap!
	ecall

	# trap will return to here
	li t0,0
	sb t0,0(t1)

	li t2,99999
loop2:
	addi t2,t2,-1
	bne t2,zero,loop2

	j main

.size	main, .-main

