# 1 "src/supervisorTrap.S"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "src/supervisorTrap.S"
.extern _ZN5Riscv20handleSupervisorTrapEv

.align 4
.global _ZN5Riscv14supervisorTrapEv
.type _ZN5Riscv14supervisorTrapEv, @function
_ZN5Riscv14supervisorTrapEv:
    # push all registers to stack
    addi sp, sp, -256 #alokacija prostora na steku
    csrw sscratch, sp #sp u pomocni registar - umesto ovoga se moze koristiti i vec dati s0 registar
    .irp index, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    sd x\index, \index * 8(sp)
    .endr

    call _ZN5Riscv20handleSupervisorTrapEv # da ne pisemo obradu prekida u asembleru, vec u C ILI C++

    # pop all registers from stack
    .irp index, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    ld x\index, \index * 8(sp)
    .endr
    addi sp, sp, 256

    sret #supervisor ret (menja se u prethodni rezim privilegije - pise u sstatus registru, a PC u sepc, a ne u ra)
