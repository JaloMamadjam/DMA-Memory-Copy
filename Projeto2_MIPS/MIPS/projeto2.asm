# ==============================================================================
# PROJECT 2: STRCPY IMPLEMENTATION (MIPS ASSEMBLY)
# ==============================================================================
# Description: 
#   This program performs a memory-to-memory string copy operation.
#   Phase 1: Loads external file content into a specific source memory region.
#   Phase 2: Implements a custom 'strcpy' routine to transfer data to a
#            destination buffer byte-by-byte.
# ==============================================================================

.data
    # --------------------------------------------------------------------------
    # DATA SEGMENT CONFIGURATION
    # --------------------------------------------------------------------------
    
    # Input Filename Definition
    filename: .asciiz "Romeo&Juliet_Act1-Scene5.txt"

    # DESTINATION BUFFER - Base Address approx: 0x10010030
    dest_text_addr: .word 0
    .space 7500             # Allocation: ~8KB for destination storage
    after_dest: .word 0     # Boundary marker for debugging

    # MEMORY ALIGNMENT PADDING
    # Offsets the source buffer to start exactly at address 0x10012000
    # required by the hardware specification (Project 4 compatibility).
    .space 650              

    # SOURCE BUFFER - Target Address: 0x10012000
    source_text_addr: .word 0
    .space 7500             # Allocation: Space for file content load
    after_source: .word 0   

.text
.globl main

main:
    # ==========================================================================
    # PHASE 1: FILE I/O OPERATIONS (DISK TO MEMORY LOAD)
    # ==========================================================================

    # 1. Open File (Syscall 13)
    li   $v0, 13           # Service 13: Open File
    la   $a0, filename     # Argument 0: File path pointer
    li   $a1, 0            # Argument 1: Flags (0 = Read-Only)
    li   $a2, 0            # Argument 2: Mode (Ignored)
    syscall
    
    # FILE DESCRIPTOR HANDLING:
    # The file descriptor is returned in $v0. 
    # Negative values indicate an error condition.
    move $s6, $v0          # Backup File Descriptor to safe register $s6

    # 2. Read Content (Syscall 14)
    li   $v0, 14               # Service 14: Read from File
    move $a0, $s6              # Argument 0: File Descriptor
    la   $a1, source_text_addr # Argument 1: Buffer Address (0x10012000)
    li   $a2, 7500             # Argument 2: Max characters to read
    syscall

    # 3. Close File (Syscall 16)
    li   $v0, 16           # Service 16: Close File
    move $a0, $s6          # Argument 0: File Descriptor
    syscall

    # ==========================================================================
    # PHASE 2: STRCPY ROUTINE (SOURCE -> DESTINATION TRANSFER)
    # ==========================================================================

    # Pointer Initialization
    la   $t0, source_text_addr  # Load Source Pointer (Read Address 0x10012000)
    la   $t1, dest_text_addr    # Load Destination Pointer (Write Address)

loop_copia:
    # 1. Fetch Byte (Load)
    lb   $t2, 0($t0)        # Load byte from Source address into temp register

    # 2. Null Terminator Check (Control Flow)
    beqz $t2, fim           # Branch if Zero (End of String detected)

    # 3. Store Byte (Write)
    sb   $t2, 0($t1)        # Store byte to Destination address

    # 4. Pointer Arithmetic (Increment)
    addiu $t0, $t0, 1       # Increment Source Pointer (+1 byte)
    addiu $t1, $t1, 1       # Increment Destination Pointer (+1 byte)

    # 5. Iterate
    j    loop_copia         # Unconditional jump to loop start

fim:
    # Program Termination
    li $v0, 10              # Service 10: Exit
    syscall