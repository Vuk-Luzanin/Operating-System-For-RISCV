
kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000c117          	auipc	sp,0xc
    80000004:	92013103          	ld	sp,-1760(sp) # 8000b920 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	00001537          	lui	a0,0x1
    8000000c:	f14025f3          	csrr	a1,mhartid
    80000010:	00158593          	addi	a1,a1,1
    80000014:	02b50533          	mul	a0,a0,a1
    80000018:	00a10133          	add	sp,sp,a0
    8000001c:	48d060ef          	jal	ra,80006ca8 <start>

0000000080000020 <spin>:
    80000020:	0000006f          	j	80000020 <spin>
	...

0000000080001000 <copy_and_swap>:
# a1 holds expected value
# a2 holds desired value
# a0 holds return value, 0 if successful, !0 otherwise
.global copy_and_swap
copy_and_swap:
    lr.w t0, (a0)          # Load original value.
    80001000:	100522af          	lr.w	t0,(a0)
    bne t0, a1, fail       # Doesn’t match, so fail.
    80001004:	00b29a63          	bne	t0,a1,80001018 <fail>
    sc.w t0, a2, (a0)      # Try to update.
    80001008:	18c522af          	sc.w	t0,a2,(a0)
    bnez t0, copy_and_swap # Retry if store-conditional failed.
    8000100c:	fe029ae3          	bnez	t0,80001000 <copy_and_swap>
    li a0, 0               # Set return to success.
    80001010:	00000513          	li	a0,0
    jr ra                  # Return.
    80001014:	00008067          	ret

0000000080001018 <fail>:
    fail:
    li a0, 1               # Set return to failure.
    80001018:	00100513          	li	a0,1
    8000101c:	00008067          	ret

0000000080001020 <_ZN5Riscv14supervisorTrapEv>:
.align 4
.global _ZN5Riscv14supervisorTrapEv
.type _ZN5Riscv14supervisorTrapEv, @function
_ZN5Riscv14supervisorTrapEv:     // potrebno prijaviti masini da ovu rutinu poziva prilikom obrade izuzetaka- u supervisor vector registar(stvec)
    # push all registers to stack
    addi sp, sp, -256                   #alokacija prostora na steku
    80001020:	f0010113          	addi	sp,sp,-256
    csrw sscratch, sp                   #sp u pomocni registar - umesto ovoga se moze koristiti i vec dati s0 registar
    80001024:	14011073          	csrw	sscratch,sp
    .irp index, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    sd x\index, \index * 8(sp)
    .endr
    80001028:	00013023          	sd	zero,0(sp)
    8000102c:	00113423          	sd	ra,8(sp)
    80001030:	00213823          	sd	sp,16(sp)
    80001034:	00313c23          	sd	gp,24(sp)
    80001038:	02413023          	sd	tp,32(sp)
    8000103c:	02513423          	sd	t0,40(sp)
    80001040:	02613823          	sd	t1,48(sp)
    80001044:	02713c23          	sd	t2,56(sp)
    80001048:	04813023          	sd	s0,64(sp)
    8000104c:	04913423          	sd	s1,72(sp)
    80001050:	04a13823          	sd	a0,80(sp)
    80001054:	04b13c23          	sd	a1,88(sp)
    80001058:	06c13023          	sd	a2,96(sp)
    8000105c:	06d13423          	sd	a3,104(sp)
    80001060:	06e13823          	sd	a4,112(sp)
    80001064:	06f13c23          	sd	a5,120(sp)
    80001068:	09013023          	sd	a6,128(sp)
    8000106c:	09113423          	sd	a7,136(sp)
    80001070:	09213823          	sd	s2,144(sp)
    80001074:	09313c23          	sd	s3,152(sp)
    80001078:	0b413023          	sd	s4,160(sp)
    8000107c:	0b513423          	sd	s5,168(sp)
    80001080:	0b613823          	sd	s6,176(sp)
    80001084:	0b713c23          	sd	s7,184(sp)
    80001088:	0d813023          	sd	s8,192(sp)
    8000108c:	0d913423          	sd	s9,200(sp)
    80001090:	0da13823          	sd	s10,208(sp)
    80001094:	0db13c23          	sd	s11,216(sp)
    80001098:	0fc13023          	sd	t3,224(sp)
    8000109c:	0fd13423          	sd	t4,232(sp)
    800010a0:	0fe13823          	sd	t5,240(sp)
    800010a4:	0ff13c23          	sd	t6,248(sp)

    call _ZN5Riscv20handleSupervisorTrapEv          # da ne pisemo obradu prekida u asembleru, vec u C ILI C++
    800010a8:	2dc040ef          	jal	ra,80005384 <_ZN5Riscv20handleSupervisorTrapEv>

    # pop all registers from stack
    .irp index, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    ld x\index, \index * 8(sp)
    .endr
    800010ac:	00013003          	ld	zero,0(sp)
    800010b0:	00813083          	ld	ra,8(sp)
    800010b4:	01013103          	ld	sp,16(sp)
    800010b8:	01813183          	ld	gp,24(sp)
    800010bc:	02013203          	ld	tp,32(sp)
    800010c0:	02813283          	ld	t0,40(sp)
    800010c4:	03013303          	ld	t1,48(sp)
    800010c8:	03813383          	ld	t2,56(sp)
    800010cc:	04013403          	ld	s0,64(sp)
    800010d0:	04813483          	ld	s1,72(sp)
    800010d4:	05013503          	ld	a0,80(sp)
    800010d8:	05813583          	ld	a1,88(sp)
    800010dc:	06013603          	ld	a2,96(sp)
    800010e0:	06813683          	ld	a3,104(sp)
    800010e4:	07013703          	ld	a4,112(sp)
    800010e8:	07813783          	ld	a5,120(sp)
    800010ec:	08013803          	ld	a6,128(sp)
    800010f0:	08813883          	ld	a7,136(sp)
    800010f4:	09013903          	ld	s2,144(sp)
    800010f8:	09813983          	ld	s3,152(sp)
    800010fc:	0a013a03          	ld	s4,160(sp)
    80001100:	0a813a83          	ld	s5,168(sp)
    80001104:	0b013b03          	ld	s6,176(sp)
    80001108:	0b813b83          	ld	s7,184(sp)
    8000110c:	0c013c03          	ld	s8,192(sp)
    80001110:	0c813c83          	ld	s9,200(sp)
    80001114:	0d013d03          	ld	s10,208(sp)
    80001118:	0d813d83          	ld	s11,216(sp)
    8000111c:	0e013e03          	ld	t3,224(sp)
    80001120:	0e813e83          	ld	t4,232(sp)
    80001124:	0f013f03          	ld	t5,240(sp)
    80001128:	0f813f83          	ld	t6,248(sp)
    addi sp, sp, 256
    8000112c:	10010113          	addi	sp,sp,256

    sret            #supervisor ret (menja se u prethodni rezim privilegije - pise u sstatus registru, a PC u sepc, a ne u ra)
    80001130:	10200073          	sret
	...

0000000080001140 <_ZN3TCB13contextSwitchEPNS_7ContextES1_>:
.global _ZN3TCB13contextSwitchEPNS_7ContextES1_
.type _ZN3TCB13contextSwitchEPNS_7ContextES1_, @function
_ZN3TCB13contextSwitchEPNS_7ContextES1_:
    sd ra, 0 * 8(a0)
    80001140:	00153023          	sd	ra,0(a0) # 1000 <_entry-0x7ffff000>
    sd sp, 1 * 8(a0)
    80001144:	00253423          	sd	sp,8(a0)

    ld ra, 0 * 8(a1)
    80001148:	0005b083          	ld	ra,0(a1)
    ld sp, 1 * 8(a1)
    8000114c:	0085b103          	ld	sp,8(a1)

    80001150:	00008067          	ret

0000000080001154 <_ZN5Riscv13pushRegistersEv>:
.global _ZN5Riscv13pushRegistersEv
.type _ZN5Riscv13pushRegistersEv, @function
_ZN5Riscv13pushRegistersEv:
    addi sp, sp, -256
    80001154:	f0010113          	addi	sp,sp,-256
    // https://sourceware.org/binutils/docs/as/Irp.html
    .irp index, 3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    sd x\index, \index * 8(sp)
    .endr
    80001158:	00313c23          	sd	gp,24(sp)
    8000115c:	02413023          	sd	tp,32(sp)
    80001160:	02513423          	sd	t0,40(sp)
    80001164:	02613823          	sd	t1,48(sp)
    80001168:	02713c23          	sd	t2,56(sp)
    8000116c:	04813023          	sd	s0,64(sp)
    80001170:	04913423          	sd	s1,72(sp)
    80001174:	04a13823          	sd	a0,80(sp)
    80001178:	04b13c23          	sd	a1,88(sp)
    8000117c:	06c13023          	sd	a2,96(sp)
    80001180:	06d13423          	sd	a3,104(sp)
    80001184:	06e13823          	sd	a4,112(sp)
    80001188:	06f13c23          	sd	a5,120(sp)
    8000118c:	09013023          	sd	a6,128(sp)
    80001190:	09113423          	sd	a7,136(sp)
    80001194:	09213823          	sd	s2,144(sp)
    80001198:	09313c23          	sd	s3,152(sp)
    8000119c:	0b413023          	sd	s4,160(sp)
    800011a0:	0b513423          	sd	s5,168(sp)
    800011a4:	0b613823          	sd	s6,176(sp)
    800011a8:	0b713c23          	sd	s7,184(sp)
    800011ac:	0d813023          	sd	s8,192(sp)
    800011b0:	0d913423          	sd	s9,200(sp)
    800011b4:	0da13823          	sd	s10,208(sp)
    800011b8:	0db13c23          	sd	s11,216(sp)
    800011bc:	0fc13023          	sd	t3,224(sp)
    800011c0:	0fd13423          	sd	t4,232(sp)
    800011c4:	0fe13823          	sd	t5,240(sp)
    800011c8:	0ff13c23          	sd	t6,248(sp)
    ret
    800011cc:	00008067          	ret

00000000800011d0 <_ZN5Riscv12popRegistersEv>:
.type _ZN5Riscv12popRegistersEv, @function
_ZN5Riscv12popRegistersEv:
    // https://sourceware.org/binutils/docs/as/Irp.html
    .irp index, 3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    ld x\index, \index * 8(sp)
    .endr
    800011d0:	01813183          	ld	gp,24(sp)
    800011d4:	02013203          	ld	tp,32(sp)
    800011d8:	02813283          	ld	t0,40(sp)
    800011dc:	03013303          	ld	t1,48(sp)
    800011e0:	03813383          	ld	t2,56(sp)
    800011e4:	04013403          	ld	s0,64(sp)
    800011e8:	04813483          	ld	s1,72(sp)
    800011ec:	05013503          	ld	a0,80(sp)
    800011f0:	05813583          	ld	a1,88(sp)
    800011f4:	06013603          	ld	a2,96(sp)
    800011f8:	06813683          	ld	a3,104(sp)
    800011fc:	07013703          	ld	a4,112(sp)
    80001200:	07813783          	ld	a5,120(sp)
    80001204:	08013803          	ld	a6,128(sp)
    80001208:	08813883          	ld	a7,136(sp)
    8000120c:	09013903          	ld	s2,144(sp)
    80001210:	09813983          	ld	s3,152(sp)
    80001214:	0a013a03          	ld	s4,160(sp)
    80001218:	0a813a83          	ld	s5,168(sp)
    8000121c:	0b013b03          	ld	s6,176(sp)
    80001220:	0b813b83          	ld	s7,184(sp)
    80001224:	0c013c03          	ld	s8,192(sp)
    80001228:	0c813c83          	ld	s9,200(sp)
    8000122c:	0d013d03          	ld	s10,208(sp)
    80001230:	0d813d83          	ld	s11,216(sp)
    80001234:	0e013e03          	ld	t3,224(sp)
    80001238:	0e813e83          	ld	t4,232(sp)
    8000123c:	0f013f03          	ld	t5,240(sp)
    80001240:	0f813f83          	ld	t6,248(sp)
    addi sp, sp, 256
    80001244:	10010113          	addi	sp,sp,256
    ret
    80001248:	00008067          	ret

000000008000124c <_ZN16ProducerKeyboard16producerKeyboardEPv>:
    void run() override {
        producerKeyboard(td);
    }
};

void ProducerKeyboard::producerKeyboard(void *arg) {
    8000124c:	fd010113          	addi	sp,sp,-48
    80001250:	02113423          	sd	ra,40(sp)
    80001254:	02813023          	sd	s0,32(sp)
    80001258:	00913c23          	sd	s1,24(sp)
    8000125c:	01213823          	sd	s2,16(sp)
    80001260:	01313423          	sd	s3,8(sp)
    80001264:	03010413          	addi	s0,sp,48
    80001268:	00050993          	mv	s3,a0
    8000126c:	00058493          	mv	s1,a1
    struct thread_data *data = (struct thread_data *) arg;

    int key;
    int i = 0;
    80001270:	00000913          	li	s2,0
    80001274:	00c0006f          	j	80001280 <_ZN16ProducerKeyboard16producerKeyboardEPv+0x34>
    while ((key = getc()) != 0x1b) {
        data->buffer->put(key);
        i++;

        if (i % (10 * data->id) == 0) {
            Thread::dispatch();
    80001278:	00005097          	auipc	ra,0x5
    8000127c:	f98080e7          	jalr	-104(ra) # 80006210 <_ZN6Thread8dispatchEv>
    while ((key = getc()) != 0x1b) {
    80001280:	00004097          	auipc	ra,0x4
    80001284:	e7c080e7          	jalr	-388(ra) # 800050fc <_Z4getcv>
    80001288:	0005059b          	sext.w	a1,a0
    8000128c:	01b00793          	li	a5,27
    80001290:	02f58a63          	beq	a1,a5,800012c4 <_ZN16ProducerKeyboard16producerKeyboardEPv+0x78>
        data->buffer->put(key);
    80001294:	0084b503          	ld	a0,8(s1)
    80001298:	00001097          	auipc	ra,0x1
    8000129c:	238080e7          	jalr	568(ra) # 800024d0 <_ZN9BufferCPP3putEi>
        i++;
    800012a0:	0019071b          	addiw	a4,s2,1
    800012a4:	0007091b          	sext.w	s2,a4
        if (i % (10 * data->id) == 0) {
    800012a8:	0004a683          	lw	a3,0(s1)
    800012ac:	0026979b          	slliw	a5,a3,0x2
    800012b0:	00d787bb          	addw	a5,a5,a3
    800012b4:	0017979b          	slliw	a5,a5,0x1
    800012b8:	02f767bb          	remw	a5,a4,a5
    800012bc:	fc0792e3          	bnez	a5,80001280 <_ZN16ProducerKeyboard16producerKeyboardEPv+0x34>
    800012c0:	fb9ff06f          	j	80001278 <_ZN16ProducerKeyboard16producerKeyboardEPv+0x2c>
        }
    }

    threadEnd = 1;
    800012c4:	00100793          	li	a5,1
    800012c8:	0000b717          	auipc	a4,0xb
    800012cc:	98f72c23          	sw	a5,-1640(a4) # 8000bc60 <_ZL9threadEnd>
    td->buffer->put('!');
    800012d0:	0209b783          	ld	a5,32(s3)
    800012d4:	02100593          	li	a1,33
    800012d8:	0087b503          	ld	a0,8(a5)
    800012dc:	00001097          	auipc	ra,0x1
    800012e0:	1f4080e7          	jalr	500(ra) # 800024d0 <_ZN9BufferCPP3putEi>

    data->wait->signal();
    800012e4:	0104b503          	ld	a0,16(s1)
    800012e8:	00005097          	auipc	ra,0x5
    800012ec:	070080e7          	jalr	112(ra) # 80006358 <_ZN9Semaphore6signalEv>
}
    800012f0:	02813083          	ld	ra,40(sp)
    800012f4:	02013403          	ld	s0,32(sp)
    800012f8:	01813483          	ld	s1,24(sp)
    800012fc:	01013903          	ld	s2,16(sp)
    80001300:	00813983          	ld	s3,8(sp)
    80001304:	03010113          	addi	sp,sp,48
    80001308:	00008067          	ret

000000008000130c <_ZN12ProducerSync8producerEPv>:
    void run() override {
        producer(td);
    }
};

void ProducerSync::producer(void *arg) {
    8000130c:	fe010113          	addi	sp,sp,-32
    80001310:	00113c23          	sd	ra,24(sp)
    80001314:	00813823          	sd	s0,16(sp)
    80001318:	00913423          	sd	s1,8(sp)
    8000131c:	01213023          	sd	s2,0(sp)
    80001320:	02010413          	addi	s0,sp,32
    80001324:	00058493          	mv	s1,a1
    struct thread_data *data = (struct thread_data *) arg;

    int i = 0;
    80001328:	00000913          	li	s2,0
    8000132c:	00c0006f          	j	80001338 <_ZN12ProducerSync8producerEPv+0x2c>
    while (!threadEnd) {
        data->buffer->put(data->id + '0');
        i++;

        if (i % (10 * data->id) == 0) {
            Thread::dispatch();
    80001330:	00005097          	auipc	ra,0x5
    80001334:	ee0080e7          	jalr	-288(ra) # 80006210 <_ZN6Thread8dispatchEv>
    while (!threadEnd) {
    80001338:	0000b797          	auipc	a5,0xb
    8000133c:	9287a783          	lw	a5,-1752(a5) # 8000bc60 <_ZL9threadEnd>
    80001340:	02079e63          	bnez	a5,8000137c <_ZN12ProducerSync8producerEPv+0x70>
        data->buffer->put(data->id + '0');
    80001344:	0004a583          	lw	a1,0(s1)
    80001348:	0305859b          	addiw	a1,a1,48
    8000134c:	0084b503          	ld	a0,8(s1)
    80001350:	00001097          	auipc	ra,0x1
    80001354:	180080e7          	jalr	384(ra) # 800024d0 <_ZN9BufferCPP3putEi>
        i++;
    80001358:	0019071b          	addiw	a4,s2,1
    8000135c:	0007091b          	sext.w	s2,a4
        if (i % (10 * data->id) == 0) {
    80001360:	0004a683          	lw	a3,0(s1)
    80001364:	0026979b          	slliw	a5,a3,0x2
    80001368:	00d787bb          	addw	a5,a5,a3
    8000136c:	0017979b          	slliw	a5,a5,0x1
    80001370:	02f767bb          	remw	a5,a4,a5
    80001374:	fc0792e3          	bnez	a5,80001338 <_ZN12ProducerSync8producerEPv+0x2c>
    80001378:	fb9ff06f          	j	80001330 <_ZN12ProducerSync8producerEPv+0x24>
        }
    }

    data->wait->signal();
    8000137c:	0104b503          	ld	a0,16(s1)
    80001380:	00005097          	auipc	ra,0x5
    80001384:	fd8080e7          	jalr	-40(ra) # 80006358 <_ZN9Semaphore6signalEv>
}
    80001388:	01813083          	ld	ra,24(sp)
    8000138c:	01013403          	ld	s0,16(sp)
    80001390:	00813483          	ld	s1,8(sp)
    80001394:	00013903          	ld	s2,0(sp)
    80001398:	02010113          	addi	sp,sp,32
    8000139c:	00008067          	ret

00000000800013a0 <_ZN12ConsumerSync8consumerEPv>:
    void run() override {
        consumer(td);
    }
};

void ConsumerSync::consumer(void *arg) {
    800013a0:	fd010113          	addi	sp,sp,-48
    800013a4:	02113423          	sd	ra,40(sp)
    800013a8:	02813023          	sd	s0,32(sp)
    800013ac:	00913c23          	sd	s1,24(sp)
    800013b0:	01213823          	sd	s2,16(sp)
    800013b4:	01313423          	sd	s3,8(sp)
    800013b8:	01413023          	sd	s4,0(sp)
    800013bc:	03010413          	addi	s0,sp,48
    800013c0:	00050993          	mv	s3,a0
    800013c4:	00058913          	mv	s2,a1
    struct thread_data *data = (struct thread_data *) arg;

    int i = 0;
    800013c8:	00000a13          	li	s4,0
    800013cc:	01c0006f          	j	800013e8 <_ZN12ConsumerSync8consumerEPv+0x48>
        i++;

        putc(key);

        if (i % (5 * data->id) == 0) {
            Thread::dispatch();
    800013d0:	00005097          	auipc	ra,0x5
    800013d4:	e40080e7          	jalr	-448(ra) # 80006210 <_ZN6Thread8dispatchEv>
    800013d8:	0500006f          	j	80001428 <_ZN12ConsumerSync8consumerEPv+0x88>
        }

        if (i % 80 == 0) {
            putc('\n');
    800013dc:	00a00513          	li	a0,10
    800013e0:	00004097          	auipc	ra,0x4
    800013e4:	d50080e7          	jalr	-688(ra) # 80005130 <_Z4putcc>
    while (!threadEnd) {
    800013e8:	0000b797          	auipc	a5,0xb
    800013ec:	8787a783          	lw	a5,-1928(a5) # 8000bc60 <_ZL9threadEnd>
    800013f0:	06079263          	bnez	a5,80001454 <_ZN12ConsumerSync8consumerEPv+0xb4>
        int key = data->buffer->get();
    800013f4:	00893503          	ld	a0,8(s2)
    800013f8:	00001097          	auipc	ra,0x1
    800013fc:	168080e7          	jalr	360(ra) # 80002560 <_ZN9BufferCPP3getEv>
        i++;
    80001400:	001a049b          	addiw	s1,s4,1
    80001404:	00048a1b          	sext.w	s4,s1
        putc(key);
    80001408:	0ff57513          	andi	a0,a0,255
    8000140c:	00004097          	auipc	ra,0x4
    80001410:	d24080e7          	jalr	-732(ra) # 80005130 <_Z4putcc>
        if (i % (5 * data->id) == 0) {
    80001414:	00092703          	lw	a4,0(s2)
    80001418:	0027179b          	slliw	a5,a4,0x2
    8000141c:	00e787bb          	addw	a5,a5,a4
    80001420:	02f4e7bb          	remw	a5,s1,a5
    80001424:	fa0786e3          	beqz	a5,800013d0 <_ZN12ConsumerSync8consumerEPv+0x30>
        if (i % 80 == 0) {
    80001428:	05000793          	li	a5,80
    8000142c:	02f4e4bb          	remw	s1,s1,a5
    80001430:	fa049ce3          	bnez	s1,800013e8 <_ZN12ConsumerSync8consumerEPv+0x48>
    80001434:	fa9ff06f          	j	800013dc <_ZN12ConsumerSync8consumerEPv+0x3c>
        }
    }


    while (td->buffer->getCnt() > 0) {
        int key = td->buffer->get();
    80001438:	0209b783          	ld	a5,32(s3)
    8000143c:	0087b503          	ld	a0,8(a5)
    80001440:	00001097          	auipc	ra,0x1
    80001444:	120080e7          	jalr	288(ra) # 80002560 <_ZN9BufferCPP3getEv>
        Console::putc(key);
    80001448:	0ff57513          	andi	a0,a0,255
    8000144c:	00005097          	auipc	ra,0x5
    80001450:	050080e7          	jalr	80(ra) # 8000649c <_ZN7Console4putcEc>
    while (td->buffer->getCnt() > 0) {
    80001454:	0209b783          	ld	a5,32(s3)
    80001458:	0087b503          	ld	a0,8(a5)
    8000145c:	00001097          	auipc	ra,0x1
    80001460:	190080e7          	jalr	400(ra) # 800025ec <_ZN9BufferCPP6getCntEv>
    80001464:	fca04ae3          	bgtz	a0,80001438 <_ZN12ConsumerSync8consumerEPv+0x98>
    }

    data->wait->signal();
    80001468:	01093503          	ld	a0,16(s2)
    8000146c:	00005097          	auipc	ra,0x5
    80001470:	eec080e7          	jalr	-276(ra) # 80006358 <_ZN9Semaphore6signalEv>
}
    80001474:	02813083          	ld	ra,40(sp)
    80001478:	02013403          	ld	s0,32(sp)
    8000147c:	01813483          	ld	s1,24(sp)
    80001480:	01013903          	ld	s2,16(sp)
    80001484:	00813983          	ld	s3,8(sp)
    80001488:	00013a03          	ld	s4,0(sp)
    8000148c:	03010113          	addi	sp,sp,48
    80001490:	00008067          	ret

0000000080001494 <_Z29producerConsumer_CPP_Sync_APIv>:

void producerConsumer_CPP_Sync_API() {
    80001494:	f8010113          	addi	sp,sp,-128
    80001498:	06113c23          	sd	ra,120(sp)
    8000149c:	06813823          	sd	s0,112(sp)
    800014a0:	06913423          	sd	s1,104(sp)
    800014a4:	07213023          	sd	s2,96(sp)
    800014a8:	05313c23          	sd	s3,88(sp)
    800014ac:	05413823          	sd	s4,80(sp)
    800014b0:	05513423          	sd	s5,72(sp)
    800014b4:	05613023          	sd	s6,64(sp)
    800014b8:	03713c23          	sd	s7,56(sp)
    800014bc:	03813823          	sd	s8,48(sp)
    800014c0:	03913423          	sd	s9,40(sp)
    800014c4:	08010413          	addi	s0,sp,128
    for (int i = 0; i < threadNum; i++) {
        delete threads[i];
    }
    delete consumerThread;
    delete waitForAll;
    delete buffer;
    800014c8:	00010b93          	mv	s7,sp
    printString("Unesite broj proizvodjaca?\n");
    800014cc:	00008517          	auipc	a0,0x8
    800014d0:	b5450513          	addi	a0,a0,-1196 # 80009020 <CONSOLE_STATUS+0x10>
    800014d4:	00001097          	auipc	ra,0x1
    800014d8:	bd8080e7          	jalr	-1064(ra) # 800020ac <_Z11printStringPKc>
    getString(input, 30);
    800014dc:	01e00593          	li	a1,30
    800014e0:	f8040513          	addi	a0,s0,-128
    800014e4:	00001097          	auipc	ra,0x1
    800014e8:	c50080e7          	jalr	-944(ra) # 80002134 <_Z9getStringPci>
    threadNum = stringToInt(input);
    800014ec:	f8040513          	addi	a0,s0,-128
    800014f0:	00001097          	auipc	ra,0x1
    800014f4:	d1c080e7          	jalr	-740(ra) # 8000220c <_Z11stringToIntPKc>
    800014f8:	00050913          	mv	s2,a0
    printString("Unesite velicinu bafera?\n");
    800014fc:	00008517          	auipc	a0,0x8
    80001500:	b4450513          	addi	a0,a0,-1212 # 80009040 <CONSOLE_STATUS+0x30>
    80001504:	00001097          	auipc	ra,0x1
    80001508:	ba8080e7          	jalr	-1112(ra) # 800020ac <_Z11printStringPKc>
    getString(input, 30);
    8000150c:	01e00593          	li	a1,30
    80001510:	f8040513          	addi	a0,s0,-128
    80001514:	00001097          	auipc	ra,0x1
    80001518:	c20080e7          	jalr	-992(ra) # 80002134 <_Z9getStringPci>
    n = stringToInt(input);
    8000151c:	f8040513          	addi	a0,s0,-128
    80001520:	00001097          	auipc	ra,0x1
    80001524:	cec080e7          	jalr	-788(ra) # 8000220c <_Z11stringToIntPKc>
    80001528:	00050493          	mv	s1,a0
    printString("Broj proizvodjaca "); printInt(threadNum);
    8000152c:	00008517          	auipc	a0,0x8
    80001530:	b3450513          	addi	a0,a0,-1228 # 80009060 <CONSOLE_STATUS+0x50>
    80001534:	00001097          	auipc	ra,0x1
    80001538:	b78080e7          	jalr	-1160(ra) # 800020ac <_Z11printStringPKc>
    8000153c:	00000613          	li	a2,0
    80001540:	00a00593          	li	a1,10
    80001544:	00090513          	mv	a0,s2
    80001548:	00001097          	auipc	ra,0x1
    8000154c:	d14080e7          	jalr	-748(ra) # 8000225c <_Z8printIntiii>
    printString(" i velicina bafera "); printInt(n);
    80001550:	00008517          	auipc	a0,0x8
    80001554:	b2850513          	addi	a0,a0,-1240 # 80009078 <CONSOLE_STATUS+0x68>
    80001558:	00001097          	auipc	ra,0x1
    8000155c:	b54080e7          	jalr	-1196(ra) # 800020ac <_Z11printStringPKc>
    80001560:	00000613          	li	a2,0
    80001564:	00a00593          	li	a1,10
    80001568:	00048513          	mv	a0,s1
    8000156c:	00001097          	auipc	ra,0x1
    80001570:	cf0080e7          	jalr	-784(ra) # 8000225c <_Z8printIntiii>
    printString(".\n");
    80001574:	00008517          	auipc	a0,0x8
    80001578:	b1c50513          	addi	a0,a0,-1252 # 80009090 <CONSOLE_STATUS+0x80>
    8000157c:	00001097          	auipc	ra,0x1
    80001580:	b30080e7          	jalr	-1232(ra) # 800020ac <_Z11printStringPKc>
    if(threadNum > n) {
    80001584:	0324c463          	blt	s1,s2,800015ac <_Z29producerConsumer_CPP_Sync_APIv+0x118>
    } else if (threadNum < 1) {
    80001588:	03205c63          	blez	s2,800015c0 <_Z29producerConsumer_CPP_Sync_APIv+0x12c>
    BufferCPP *buffer = new BufferCPP(n);
    8000158c:	03800513          	li	a0,56
    80001590:	00005097          	auipc	ra,0x5
    80001594:	a88080e7          	jalr	-1400(ra) # 80006018 <_Znwm>
    80001598:	00050a93          	mv	s5,a0
    8000159c:	00048593          	mv	a1,s1
    800015a0:	00001097          	auipc	ra,0x1
    800015a4:	ddc080e7          	jalr	-548(ra) # 8000237c <_ZN9BufferCPPC1Ei>
    800015a8:	0300006f          	j	800015d8 <_Z29producerConsumer_CPP_Sync_APIv+0x144>
        printString("Broj proizvodjaca ne sme biti manji od velicine bafera!\n");
    800015ac:	00008517          	auipc	a0,0x8
    800015b0:	aec50513          	addi	a0,a0,-1300 # 80009098 <CONSOLE_STATUS+0x88>
    800015b4:	00001097          	auipc	ra,0x1
    800015b8:	af8080e7          	jalr	-1288(ra) # 800020ac <_Z11printStringPKc>
        return;
    800015bc:	0140006f          	j	800015d0 <_Z29producerConsumer_CPP_Sync_APIv+0x13c>
        printString("Broj proizvodjaca mora biti veci od nula!\n");
    800015c0:	00008517          	auipc	a0,0x8
    800015c4:	b1850513          	addi	a0,a0,-1256 # 800090d8 <CONSOLE_STATUS+0xc8>
    800015c8:	00001097          	auipc	ra,0x1
    800015cc:	ae4080e7          	jalr	-1308(ra) # 800020ac <_Z11printStringPKc>
        return;
    800015d0:	000b8113          	mv	sp,s7
    800015d4:	2380006f          	j	8000180c <_Z29producerConsumer_CPP_Sync_APIv+0x378>
    waitForAll = new Semaphore(0);
    800015d8:	01000513          	li	a0,16
    800015dc:	00005097          	auipc	ra,0x5
    800015e0:	a3c080e7          	jalr	-1476(ra) # 80006018 <_Znwm>
    800015e4:	00050493          	mv	s1,a0
    800015e8:	00000593          	li	a1,0
    800015ec:	00005097          	auipc	ra,0x5
    800015f0:	d08080e7          	jalr	-760(ra) # 800062f4 <_ZN9SemaphoreC1Ej>
    800015f4:	0000a797          	auipc	a5,0xa
    800015f8:	6697ba23          	sd	s1,1652(a5) # 8000bc68 <_ZL10waitForAll>
    Thread* threads[threadNum];
    800015fc:	00391793          	slli	a5,s2,0x3
    80001600:	00f78793          	addi	a5,a5,15
    80001604:	ff07f793          	andi	a5,a5,-16
    80001608:	40f10133          	sub	sp,sp,a5
    8000160c:	00010993          	mv	s3,sp
    struct thread_data data[threadNum + 1];
    80001610:	0019071b          	addiw	a4,s2,1
    80001614:	00171793          	slli	a5,a4,0x1
    80001618:	00e787b3          	add	a5,a5,a4
    8000161c:	00379793          	slli	a5,a5,0x3
    80001620:	00f78793          	addi	a5,a5,15
    80001624:	ff07f793          	andi	a5,a5,-16
    80001628:	40f10133          	sub	sp,sp,a5
    8000162c:	00010a13          	mv	s4,sp
    data[threadNum].id = threadNum;
    80001630:	00191c13          	slli	s8,s2,0x1
    80001634:	012c07b3          	add	a5,s8,s2
    80001638:	00379793          	slli	a5,a5,0x3
    8000163c:	00fa07b3          	add	a5,s4,a5
    80001640:	0127a023          	sw	s2,0(a5)
    data[threadNum].buffer = buffer;
    80001644:	0157b423          	sd	s5,8(a5)
    data[threadNum].wait = waitForAll;
    80001648:	0097b823          	sd	s1,16(a5)
    consumerThread = new ConsumerSync(data+threadNum);
    8000164c:	02800513          	li	a0,40
    80001650:	00005097          	auipc	ra,0x5
    80001654:	9c8080e7          	jalr	-1592(ra) # 80006018 <_Znwm>
    80001658:	00050b13          	mv	s6,a0
    8000165c:	012c0c33          	add	s8,s8,s2
    80001660:	003c1c13          	slli	s8,s8,0x3
    80001664:	018a0c33          	add	s8,s4,s8
    ConsumerSync(thread_data* _td):Thread(), td(_td) {}
    80001668:	00005097          	auipc	ra,0x5
    8000166c:	c60080e7          	jalr	-928(ra) # 800062c8 <_ZN6ThreadC1Ev>
    80001670:	00008797          	auipc	a5,0x8
    80001674:	af878793          	addi	a5,a5,-1288 # 80009168 <_ZTV12ConsumerSync+0x10>
    80001678:	00fb3023          	sd	a5,0(s6)
    8000167c:	038b3023          	sd	s8,32(s6)
    consumerThread->start();
    80001680:	000b0513          	mv	a0,s6
    80001684:	00005097          	auipc	ra,0x5
    80001688:	b38080e7          	jalr	-1224(ra) # 800061bc <_ZN6Thread5startEv>
    for (int i = 0; i < threadNum; i++) {
    8000168c:	00000493          	li	s1,0
    80001690:	0380006f          	j	800016c8 <_Z29producerConsumer_CPP_Sync_APIv+0x234>
    ProducerSync(thread_data* _td):Thread(), td(_td) {}
    80001694:	00008797          	auipc	a5,0x8
    80001698:	aac78793          	addi	a5,a5,-1364 # 80009140 <_ZTV12ProducerSync+0x10>
    8000169c:	00fcb023          	sd	a5,0(s9)
    800016a0:	038cb023          	sd	s8,32(s9)
            threads[i] = new ProducerSync(data+i);
    800016a4:	00349793          	slli	a5,s1,0x3
    800016a8:	00f987b3          	add	a5,s3,a5
    800016ac:	0197b023          	sd	s9,0(a5)
        threads[i]->start();
    800016b0:	00349793          	slli	a5,s1,0x3
    800016b4:	00f987b3          	add	a5,s3,a5
    800016b8:	0007b503          	ld	a0,0(a5)
    800016bc:	00005097          	auipc	ra,0x5
    800016c0:	b00080e7          	jalr	-1280(ra) # 800061bc <_ZN6Thread5startEv>
    for (int i = 0; i < threadNum; i++) {
    800016c4:	0014849b          	addiw	s1,s1,1
    800016c8:	0b24d063          	bge	s1,s2,80001768 <_Z29producerConsumer_CPP_Sync_APIv+0x2d4>
        data[i].id = i;
    800016cc:	00149793          	slli	a5,s1,0x1
    800016d0:	009787b3          	add	a5,a5,s1
    800016d4:	00379793          	slli	a5,a5,0x3
    800016d8:	00fa07b3          	add	a5,s4,a5
    800016dc:	0097a023          	sw	s1,0(a5)
        data[i].buffer = buffer;
    800016e0:	0157b423          	sd	s5,8(a5)
        data[i].wait = waitForAll;
    800016e4:	0000a717          	auipc	a4,0xa
    800016e8:	58473703          	ld	a4,1412(a4) # 8000bc68 <_ZL10waitForAll>
    800016ec:	00e7b823          	sd	a4,16(a5)
        if(i>0) {
    800016f0:	02905863          	blez	s1,80001720 <_Z29producerConsumer_CPP_Sync_APIv+0x28c>
            threads[i] = new ProducerSync(data+i);
    800016f4:	02800513          	li	a0,40
    800016f8:	00005097          	auipc	ra,0x5
    800016fc:	920080e7          	jalr	-1760(ra) # 80006018 <_Znwm>
    80001700:	00050c93          	mv	s9,a0
    80001704:	00149c13          	slli	s8,s1,0x1
    80001708:	009c0c33          	add	s8,s8,s1
    8000170c:	003c1c13          	slli	s8,s8,0x3
    80001710:	018a0c33          	add	s8,s4,s8
    ProducerSync(thread_data* _td):Thread(), td(_td) {}
    80001714:	00005097          	auipc	ra,0x5
    80001718:	bb4080e7          	jalr	-1100(ra) # 800062c8 <_ZN6ThreadC1Ev>
    8000171c:	f79ff06f          	j	80001694 <_Z29producerConsumer_CPP_Sync_APIv+0x200>
            threads[i] = new ProducerKeyboard(data+i);
    80001720:	02800513          	li	a0,40
    80001724:	00005097          	auipc	ra,0x5
    80001728:	8f4080e7          	jalr	-1804(ra) # 80006018 <_Znwm>
    8000172c:	00050c93          	mv	s9,a0
    80001730:	00149c13          	slli	s8,s1,0x1
    80001734:	009c0c33          	add	s8,s8,s1
    80001738:	003c1c13          	slli	s8,s8,0x3
    8000173c:	018a0c33          	add	s8,s4,s8
    ProducerKeyboard(thread_data* _td):Thread(), td(_td) {}
    80001740:	00005097          	auipc	ra,0x5
    80001744:	b88080e7          	jalr	-1144(ra) # 800062c8 <_ZN6ThreadC1Ev>
    80001748:	00008797          	auipc	a5,0x8
    8000174c:	9d078793          	addi	a5,a5,-1584 # 80009118 <_ZTV16ProducerKeyboard+0x10>
    80001750:	00fcb023          	sd	a5,0(s9)
    80001754:	038cb023          	sd	s8,32(s9)
            threads[i] = new ProducerKeyboard(data+i);
    80001758:	00349793          	slli	a5,s1,0x3
    8000175c:	00f987b3          	add	a5,s3,a5
    80001760:	0197b023          	sd	s9,0(a5)
    80001764:	f4dff06f          	j	800016b0 <_Z29producerConsumer_CPP_Sync_APIv+0x21c>
    Thread::dispatch();
    80001768:	00005097          	auipc	ra,0x5
    8000176c:	aa8080e7          	jalr	-1368(ra) # 80006210 <_ZN6Thread8dispatchEv>
    for (int i = 0; i <= threadNum; i++) {
    80001770:	00000493          	li	s1,0
    80001774:	00994e63          	blt	s2,s1,80001790 <_Z29producerConsumer_CPP_Sync_APIv+0x2fc>
        waitForAll->wait();
    80001778:	0000a517          	auipc	a0,0xa
    8000177c:	4f053503          	ld	a0,1264(a0) # 8000bc68 <_ZL10waitForAll>
    80001780:	00005097          	auipc	ra,0x5
    80001784:	bac080e7          	jalr	-1108(ra) # 8000632c <_ZN9Semaphore4waitEv>
    for (int i = 0; i <= threadNum; i++) {
    80001788:	0014849b          	addiw	s1,s1,1
    8000178c:	fe9ff06f          	j	80001774 <_Z29producerConsumer_CPP_Sync_APIv+0x2e0>
    for (int i = 0; i < threadNum; i++) {
    80001790:	00000493          	li	s1,0
    80001794:	0080006f          	j	8000179c <_Z29producerConsumer_CPP_Sync_APIv+0x308>
    80001798:	0014849b          	addiw	s1,s1,1
    8000179c:	0324d263          	bge	s1,s2,800017c0 <_Z29producerConsumer_CPP_Sync_APIv+0x32c>
        delete threads[i];
    800017a0:	00349793          	slli	a5,s1,0x3
    800017a4:	00f987b3          	add	a5,s3,a5
    800017a8:	0007b503          	ld	a0,0(a5)
    800017ac:	fe0506e3          	beqz	a0,80001798 <_Z29producerConsumer_CPP_Sync_APIv+0x304>
    800017b0:	00053783          	ld	a5,0(a0)
    800017b4:	0087b783          	ld	a5,8(a5)
    800017b8:	000780e7          	jalr	a5
    800017bc:	fddff06f          	j	80001798 <_Z29producerConsumer_CPP_Sync_APIv+0x304>
    delete consumerThread;
    800017c0:	000b0a63          	beqz	s6,800017d4 <_Z29producerConsumer_CPP_Sync_APIv+0x340>
    800017c4:	000b3783          	ld	a5,0(s6)
    800017c8:	0087b783          	ld	a5,8(a5)
    800017cc:	000b0513          	mv	a0,s6
    800017d0:	000780e7          	jalr	a5
    delete waitForAll;
    800017d4:	0000a517          	auipc	a0,0xa
    800017d8:	49453503          	ld	a0,1172(a0) # 8000bc68 <_ZL10waitForAll>
    800017dc:	00050863          	beqz	a0,800017ec <_Z29producerConsumer_CPP_Sync_APIv+0x358>
    800017e0:	00053783          	ld	a5,0(a0)
    800017e4:	0087b783          	ld	a5,8(a5)
    800017e8:	000780e7          	jalr	a5
    delete buffer;
    800017ec:	000a8e63          	beqz	s5,80001808 <_Z29producerConsumer_CPP_Sync_APIv+0x374>
    800017f0:	000a8513          	mv	a0,s5
    800017f4:	00001097          	auipc	ra,0x1
    800017f8:	e80080e7          	jalr	-384(ra) # 80002674 <_ZN9BufferCPPD1Ev>
    800017fc:	000a8513          	mv	a0,s5
    80001800:	00005097          	auipc	ra,0x5
    80001804:	868080e7          	jalr	-1944(ra) # 80006068 <_ZdlPv>
    80001808:	000b8113          	mv	sp,s7

}
    8000180c:	f8040113          	addi	sp,s0,-128
    80001810:	07813083          	ld	ra,120(sp)
    80001814:	07013403          	ld	s0,112(sp)
    80001818:	06813483          	ld	s1,104(sp)
    8000181c:	06013903          	ld	s2,96(sp)
    80001820:	05813983          	ld	s3,88(sp)
    80001824:	05013a03          	ld	s4,80(sp)
    80001828:	04813a83          	ld	s5,72(sp)
    8000182c:	04013b03          	ld	s6,64(sp)
    80001830:	03813b83          	ld	s7,56(sp)
    80001834:	03013c03          	ld	s8,48(sp)
    80001838:	02813c83          	ld	s9,40(sp)
    8000183c:	08010113          	addi	sp,sp,128
    80001840:	00008067          	ret
    80001844:	00050493          	mv	s1,a0
    BufferCPP *buffer = new BufferCPP(n);
    80001848:	000a8513          	mv	a0,s5
    8000184c:	00005097          	auipc	ra,0x5
    80001850:	81c080e7          	jalr	-2020(ra) # 80006068 <_ZdlPv>
    80001854:	00048513          	mv	a0,s1
    80001858:	0000c097          	auipc	ra,0xc
    8000185c:	e00080e7          	jalr	-512(ra) # 8000d658 <_Unwind_Resume>
    80001860:	00050913          	mv	s2,a0
    waitForAll = new Semaphore(0);
    80001864:	00048513          	mv	a0,s1
    80001868:	00005097          	auipc	ra,0x5
    8000186c:	800080e7          	jalr	-2048(ra) # 80006068 <_ZdlPv>
    80001870:	00090513          	mv	a0,s2
    80001874:	0000c097          	auipc	ra,0xc
    80001878:	de4080e7          	jalr	-540(ra) # 8000d658 <_Unwind_Resume>
    8000187c:	00050493          	mv	s1,a0
    consumerThread = new ConsumerSync(data+threadNum);
    80001880:	000b0513          	mv	a0,s6
    80001884:	00004097          	auipc	ra,0x4
    80001888:	7e4080e7          	jalr	2020(ra) # 80006068 <_ZdlPv>
    8000188c:	00048513          	mv	a0,s1
    80001890:	0000c097          	auipc	ra,0xc
    80001894:	dc8080e7          	jalr	-568(ra) # 8000d658 <_Unwind_Resume>
    80001898:	00050493          	mv	s1,a0
            threads[i] = new ProducerSync(data+i);
    8000189c:	000c8513          	mv	a0,s9
    800018a0:	00004097          	auipc	ra,0x4
    800018a4:	7c8080e7          	jalr	1992(ra) # 80006068 <_ZdlPv>
    800018a8:	00048513          	mv	a0,s1
    800018ac:	0000c097          	auipc	ra,0xc
    800018b0:	dac080e7          	jalr	-596(ra) # 8000d658 <_Unwind_Resume>
    800018b4:	00050493          	mv	s1,a0
            threads[i] = new ProducerKeyboard(data+i);
    800018b8:	000c8513          	mv	a0,s9
    800018bc:	00004097          	auipc	ra,0x4
    800018c0:	7ac080e7          	jalr	1964(ra) # 80006068 <_ZdlPv>
    800018c4:	00048513          	mv	a0,s1
    800018c8:	0000c097          	auipc	ra,0xc
    800018cc:	d90080e7          	jalr	-624(ra) # 8000d658 <_Unwind_Resume>

00000000800018d0 <_ZN12ConsumerSyncD1Ev>:
class ConsumerSync:public Thread {
    800018d0:	ff010113          	addi	sp,sp,-16
    800018d4:	00113423          	sd	ra,8(sp)
    800018d8:	00813023          	sd	s0,0(sp)
    800018dc:	01010413          	addi	s0,sp,16
    800018e0:	00008797          	auipc	a5,0x8
    800018e4:	88878793          	addi	a5,a5,-1912 # 80009168 <_ZTV12ConsumerSync+0x10>
    800018e8:	00f53023          	sd	a5,0(a0)
    800018ec:	00005097          	auipc	ra,0x5
    800018f0:	80c080e7          	jalr	-2036(ra) # 800060f8 <_ZN6ThreadD1Ev>
    800018f4:	00813083          	ld	ra,8(sp)
    800018f8:	00013403          	ld	s0,0(sp)
    800018fc:	01010113          	addi	sp,sp,16
    80001900:	00008067          	ret

0000000080001904 <_ZN12ConsumerSyncD0Ev>:
    80001904:	fe010113          	addi	sp,sp,-32
    80001908:	00113c23          	sd	ra,24(sp)
    8000190c:	00813823          	sd	s0,16(sp)
    80001910:	00913423          	sd	s1,8(sp)
    80001914:	02010413          	addi	s0,sp,32
    80001918:	00050493          	mv	s1,a0
    8000191c:	00008797          	auipc	a5,0x8
    80001920:	84c78793          	addi	a5,a5,-1972 # 80009168 <_ZTV12ConsumerSync+0x10>
    80001924:	00f53023          	sd	a5,0(a0)
    80001928:	00004097          	auipc	ra,0x4
    8000192c:	7d0080e7          	jalr	2000(ra) # 800060f8 <_ZN6ThreadD1Ev>
    80001930:	00048513          	mv	a0,s1
    80001934:	00004097          	auipc	ra,0x4
    80001938:	734080e7          	jalr	1844(ra) # 80006068 <_ZdlPv>
    8000193c:	01813083          	ld	ra,24(sp)
    80001940:	01013403          	ld	s0,16(sp)
    80001944:	00813483          	ld	s1,8(sp)
    80001948:	02010113          	addi	sp,sp,32
    8000194c:	00008067          	ret

0000000080001950 <_ZN12ProducerSyncD1Ev>:
class ProducerSync:public Thread {
    80001950:	ff010113          	addi	sp,sp,-16
    80001954:	00113423          	sd	ra,8(sp)
    80001958:	00813023          	sd	s0,0(sp)
    8000195c:	01010413          	addi	s0,sp,16
    80001960:	00007797          	auipc	a5,0x7
    80001964:	7e078793          	addi	a5,a5,2016 # 80009140 <_ZTV12ProducerSync+0x10>
    80001968:	00f53023          	sd	a5,0(a0)
    8000196c:	00004097          	auipc	ra,0x4
    80001970:	78c080e7          	jalr	1932(ra) # 800060f8 <_ZN6ThreadD1Ev>
    80001974:	00813083          	ld	ra,8(sp)
    80001978:	00013403          	ld	s0,0(sp)
    8000197c:	01010113          	addi	sp,sp,16
    80001980:	00008067          	ret

0000000080001984 <_ZN12ProducerSyncD0Ev>:
    80001984:	fe010113          	addi	sp,sp,-32
    80001988:	00113c23          	sd	ra,24(sp)
    8000198c:	00813823          	sd	s0,16(sp)
    80001990:	00913423          	sd	s1,8(sp)
    80001994:	02010413          	addi	s0,sp,32
    80001998:	00050493          	mv	s1,a0
    8000199c:	00007797          	auipc	a5,0x7
    800019a0:	7a478793          	addi	a5,a5,1956 # 80009140 <_ZTV12ProducerSync+0x10>
    800019a4:	00f53023          	sd	a5,0(a0)
    800019a8:	00004097          	auipc	ra,0x4
    800019ac:	750080e7          	jalr	1872(ra) # 800060f8 <_ZN6ThreadD1Ev>
    800019b0:	00048513          	mv	a0,s1
    800019b4:	00004097          	auipc	ra,0x4
    800019b8:	6b4080e7          	jalr	1716(ra) # 80006068 <_ZdlPv>
    800019bc:	01813083          	ld	ra,24(sp)
    800019c0:	01013403          	ld	s0,16(sp)
    800019c4:	00813483          	ld	s1,8(sp)
    800019c8:	02010113          	addi	sp,sp,32
    800019cc:	00008067          	ret

00000000800019d0 <_ZN16ProducerKeyboardD1Ev>:
class ProducerKeyboard:public Thread {
    800019d0:	ff010113          	addi	sp,sp,-16
    800019d4:	00113423          	sd	ra,8(sp)
    800019d8:	00813023          	sd	s0,0(sp)
    800019dc:	01010413          	addi	s0,sp,16
    800019e0:	00007797          	auipc	a5,0x7
    800019e4:	73878793          	addi	a5,a5,1848 # 80009118 <_ZTV16ProducerKeyboard+0x10>
    800019e8:	00f53023          	sd	a5,0(a0)
    800019ec:	00004097          	auipc	ra,0x4
    800019f0:	70c080e7          	jalr	1804(ra) # 800060f8 <_ZN6ThreadD1Ev>
    800019f4:	00813083          	ld	ra,8(sp)
    800019f8:	00013403          	ld	s0,0(sp)
    800019fc:	01010113          	addi	sp,sp,16
    80001a00:	00008067          	ret

0000000080001a04 <_ZN16ProducerKeyboardD0Ev>:
    80001a04:	fe010113          	addi	sp,sp,-32
    80001a08:	00113c23          	sd	ra,24(sp)
    80001a0c:	00813823          	sd	s0,16(sp)
    80001a10:	00913423          	sd	s1,8(sp)
    80001a14:	02010413          	addi	s0,sp,32
    80001a18:	00050493          	mv	s1,a0
    80001a1c:	00007797          	auipc	a5,0x7
    80001a20:	6fc78793          	addi	a5,a5,1788 # 80009118 <_ZTV16ProducerKeyboard+0x10>
    80001a24:	00f53023          	sd	a5,0(a0)
    80001a28:	00004097          	auipc	ra,0x4
    80001a2c:	6d0080e7          	jalr	1744(ra) # 800060f8 <_ZN6ThreadD1Ev>
    80001a30:	00048513          	mv	a0,s1
    80001a34:	00004097          	auipc	ra,0x4
    80001a38:	634080e7          	jalr	1588(ra) # 80006068 <_ZdlPv>
    80001a3c:	01813083          	ld	ra,24(sp)
    80001a40:	01013403          	ld	s0,16(sp)
    80001a44:	00813483          	ld	s1,8(sp)
    80001a48:	02010113          	addi	sp,sp,32
    80001a4c:	00008067          	ret

0000000080001a50 <_ZN16ProducerKeyboard3runEv>:
    void run() override {
    80001a50:	ff010113          	addi	sp,sp,-16
    80001a54:	00113423          	sd	ra,8(sp)
    80001a58:	00813023          	sd	s0,0(sp)
    80001a5c:	01010413          	addi	s0,sp,16
        producerKeyboard(td);
    80001a60:	02053583          	ld	a1,32(a0)
    80001a64:	fffff097          	auipc	ra,0xfffff
    80001a68:	7e8080e7          	jalr	2024(ra) # 8000124c <_ZN16ProducerKeyboard16producerKeyboardEPv>
    }
    80001a6c:	00813083          	ld	ra,8(sp)
    80001a70:	00013403          	ld	s0,0(sp)
    80001a74:	01010113          	addi	sp,sp,16
    80001a78:	00008067          	ret

0000000080001a7c <_ZN12ProducerSync3runEv>:
    void run() override {
    80001a7c:	ff010113          	addi	sp,sp,-16
    80001a80:	00113423          	sd	ra,8(sp)
    80001a84:	00813023          	sd	s0,0(sp)
    80001a88:	01010413          	addi	s0,sp,16
        producer(td);
    80001a8c:	02053583          	ld	a1,32(a0)
    80001a90:	00000097          	auipc	ra,0x0
    80001a94:	87c080e7          	jalr	-1924(ra) # 8000130c <_ZN12ProducerSync8producerEPv>
    }
    80001a98:	00813083          	ld	ra,8(sp)
    80001a9c:	00013403          	ld	s0,0(sp)
    80001aa0:	01010113          	addi	sp,sp,16
    80001aa4:	00008067          	ret

0000000080001aa8 <_ZN12ConsumerSync3runEv>:
    void run() override {
    80001aa8:	ff010113          	addi	sp,sp,-16
    80001aac:	00113423          	sd	ra,8(sp)
    80001ab0:	00813023          	sd	s0,0(sp)
    80001ab4:	01010413          	addi	s0,sp,16
        consumer(td);
    80001ab8:	02053583          	ld	a1,32(a0)
    80001abc:	00000097          	auipc	ra,0x0
    80001ac0:	8e4080e7          	jalr	-1820(ra) # 800013a0 <_ZN12ConsumerSync8consumerEPv>
    }
    80001ac4:	00813083          	ld	ra,8(sp)
    80001ac8:	00013403          	ld	s0,0(sp)
    80001acc:	01010113          	addi	sp,sp,16
    80001ad0:	00008067          	ret

0000000080001ad4 <_ZL9fibonaccim>:
static volatile bool finishedA = false;
static volatile bool finishedB = false;
static volatile bool finishedC = false;
static volatile bool finishedD = false;

static uint64 fibonacci(uint64 n) {
    80001ad4:	fe010113          	addi	sp,sp,-32
    80001ad8:	00113c23          	sd	ra,24(sp)
    80001adc:	00813823          	sd	s0,16(sp)
    80001ae0:	00913423          	sd	s1,8(sp)
    80001ae4:	01213023          	sd	s2,0(sp)
    80001ae8:	02010413          	addi	s0,sp,32
    80001aec:	00050493          	mv	s1,a0
    if (n == 0 || n == 1) { return n; }
    80001af0:	00100793          	li	a5,1
    80001af4:	02a7f863          	bgeu	a5,a0,80001b24 <_ZL9fibonaccim+0x50>
    if (n % 10 == 0) { thread_dispatch(); }
    80001af8:	00a00793          	li	a5,10
    80001afc:	02f577b3          	remu	a5,a0,a5
    80001b00:	02078e63          	beqz	a5,80001b3c <_ZL9fibonaccim+0x68>
    return fibonacci(n - 1) + fibonacci(n - 2);
    80001b04:	fff48513          	addi	a0,s1,-1
    80001b08:	00000097          	auipc	ra,0x0
    80001b0c:	fcc080e7          	jalr	-52(ra) # 80001ad4 <_ZL9fibonaccim>
    80001b10:	00050913          	mv	s2,a0
    80001b14:	ffe48513          	addi	a0,s1,-2
    80001b18:	00000097          	auipc	ra,0x0
    80001b1c:	fbc080e7          	jalr	-68(ra) # 80001ad4 <_ZL9fibonaccim>
    80001b20:	00a90533          	add	a0,s2,a0
}
    80001b24:	01813083          	ld	ra,24(sp)
    80001b28:	01013403          	ld	s0,16(sp)
    80001b2c:	00813483          	ld	s1,8(sp)
    80001b30:	00013903          	ld	s2,0(sp)
    80001b34:	02010113          	addi	sp,sp,32
    80001b38:	00008067          	ret
    if (n % 10 == 0) { thread_dispatch(); }
    80001b3c:	00003097          	auipc	ra,0x3
    80001b40:	3f4080e7          	jalr	1012(ra) # 80004f30 <_Z15thread_dispatchv>
    80001b44:	fc1ff06f          	j	80001b04 <_ZL9fibonaccim+0x30>

0000000080001b48 <_ZL11workerBodyDPv>:
    printString("A finished!\n");
    finishedC = true;
    thread_dispatch();
}

static void workerBodyD(void* arg) {
    80001b48:	fe010113          	addi	sp,sp,-32
    80001b4c:	00113c23          	sd	ra,24(sp)
    80001b50:	00813823          	sd	s0,16(sp)
    80001b54:	00913423          	sd	s1,8(sp)
    80001b58:	01213023          	sd	s2,0(sp)
    80001b5c:	02010413          	addi	s0,sp,32
    uint8 i = 10;
    80001b60:	00a00493          	li	s1,10
    80001b64:	0400006f          	j	80001ba4 <_ZL11workerBodyDPv+0x5c>
    for (; i < 13; i++) {
        printString("D: i="); printInt(i); printString("\n");
    80001b68:	00007517          	auipc	a0,0x7
    80001b6c:	61850513          	addi	a0,a0,1560 # 80009180 <_ZTV12ConsumerSync+0x28>
    80001b70:	00000097          	auipc	ra,0x0
    80001b74:	53c080e7          	jalr	1340(ra) # 800020ac <_Z11printStringPKc>
    80001b78:	00000613          	li	a2,0
    80001b7c:	00a00593          	li	a1,10
    80001b80:	00048513          	mv	a0,s1
    80001b84:	00000097          	auipc	ra,0x0
    80001b88:	6d8080e7          	jalr	1752(ra) # 8000225c <_Z8printIntiii>
    80001b8c:	00008517          	auipc	a0,0x8
    80001b90:	84450513          	addi	a0,a0,-1980 # 800093d0 <_ZTV12ConsumerSync+0x278>
    80001b94:	00000097          	auipc	ra,0x0
    80001b98:	518080e7          	jalr	1304(ra) # 800020ac <_Z11printStringPKc>
    for (; i < 13; i++) {
    80001b9c:	0014849b          	addiw	s1,s1,1
    80001ba0:	0ff4f493          	andi	s1,s1,255
    80001ba4:	00c00793          	li	a5,12
    80001ba8:	fc97f0e3          	bgeu	a5,s1,80001b68 <_ZL11workerBodyDPv+0x20>
    }

    printString("D: dispatch\n");
    80001bac:	00007517          	auipc	a0,0x7
    80001bb0:	5dc50513          	addi	a0,a0,1500 # 80009188 <_ZTV12ConsumerSync+0x30>
    80001bb4:	00000097          	auipc	ra,0x0
    80001bb8:	4f8080e7          	jalr	1272(ra) # 800020ac <_Z11printStringPKc>
    __asm__ ("li t1, 5");
    80001bbc:	00500313          	li	t1,5
    thread_dispatch();
    80001bc0:	00003097          	auipc	ra,0x3
    80001bc4:	370080e7          	jalr	880(ra) # 80004f30 <_Z15thread_dispatchv>

    uint64 result = fibonacci(16);
    80001bc8:	01000513          	li	a0,16
    80001bcc:	00000097          	auipc	ra,0x0
    80001bd0:	f08080e7          	jalr	-248(ra) # 80001ad4 <_ZL9fibonaccim>
    80001bd4:	00050913          	mv	s2,a0
    printString("D: fibonaci="); printInt(result); printString("\n");
    80001bd8:	00007517          	auipc	a0,0x7
    80001bdc:	5c050513          	addi	a0,a0,1472 # 80009198 <_ZTV12ConsumerSync+0x40>
    80001be0:	00000097          	auipc	ra,0x0
    80001be4:	4cc080e7          	jalr	1228(ra) # 800020ac <_Z11printStringPKc>
    80001be8:	00000613          	li	a2,0
    80001bec:	00a00593          	li	a1,10
    80001bf0:	0009051b          	sext.w	a0,s2
    80001bf4:	00000097          	auipc	ra,0x0
    80001bf8:	668080e7          	jalr	1640(ra) # 8000225c <_Z8printIntiii>
    80001bfc:	00007517          	auipc	a0,0x7
    80001c00:	7d450513          	addi	a0,a0,2004 # 800093d0 <_ZTV12ConsumerSync+0x278>
    80001c04:	00000097          	auipc	ra,0x0
    80001c08:	4a8080e7          	jalr	1192(ra) # 800020ac <_Z11printStringPKc>
    80001c0c:	0400006f          	j	80001c4c <_ZL11workerBodyDPv+0x104>

    for (; i < 16; i++) {
        printString("D: i="); printInt(i); printString("\n");
    80001c10:	00007517          	auipc	a0,0x7
    80001c14:	57050513          	addi	a0,a0,1392 # 80009180 <_ZTV12ConsumerSync+0x28>
    80001c18:	00000097          	auipc	ra,0x0
    80001c1c:	494080e7          	jalr	1172(ra) # 800020ac <_Z11printStringPKc>
    80001c20:	00000613          	li	a2,0
    80001c24:	00a00593          	li	a1,10
    80001c28:	00048513          	mv	a0,s1
    80001c2c:	00000097          	auipc	ra,0x0
    80001c30:	630080e7          	jalr	1584(ra) # 8000225c <_Z8printIntiii>
    80001c34:	00007517          	auipc	a0,0x7
    80001c38:	79c50513          	addi	a0,a0,1948 # 800093d0 <_ZTV12ConsumerSync+0x278>
    80001c3c:	00000097          	auipc	ra,0x0
    80001c40:	470080e7          	jalr	1136(ra) # 800020ac <_Z11printStringPKc>
    for (; i < 16; i++) {
    80001c44:	0014849b          	addiw	s1,s1,1
    80001c48:	0ff4f493          	andi	s1,s1,255
    80001c4c:	00f00793          	li	a5,15
    80001c50:	fc97f0e3          	bgeu	a5,s1,80001c10 <_ZL11workerBodyDPv+0xc8>
    }

    printString("D finished!\n");
    80001c54:	00007517          	auipc	a0,0x7
    80001c58:	55450513          	addi	a0,a0,1364 # 800091a8 <_ZTV12ConsumerSync+0x50>
    80001c5c:	00000097          	auipc	ra,0x0
    80001c60:	450080e7          	jalr	1104(ra) # 800020ac <_Z11printStringPKc>
    finishedD = true;
    80001c64:	00100793          	li	a5,1
    80001c68:	0000a717          	auipc	a4,0xa
    80001c6c:	00f70423          	sb	a5,8(a4) # 8000bc70 <_ZL9finishedD>
    thread_dispatch();
    80001c70:	00003097          	auipc	ra,0x3
    80001c74:	2c0080e7          	jalr	704(ra) # 80004f30 <_Z15thread_dispatchv>
}
    80001c78:	01813083          	ld	ra,24(sp)
    80001c7c:	01013403          	ld	s0,16(sp)
    80001c80:	00813483          	ld	s1,8(sp)
    80001c84:	00013903          	ld	s2,0(sp)
    80001c88:	02010113          	addi	sp,sp,32
    80001c8c:	00008067          	ret

0000000080001c90 <_ZL11workerBodyCPv>:
static void workerBodyC(void* arg) {
    80001c90:	fe010113          	addi	sp,sp,-32
    80001c94:	00113c23          	sd	ra,24(sp)
    80001c98:	00813823          	sd	s0,16(sp)
    80001c9c:	00913423          	sd	s1,8(sp)
    80001ca0:	01213023          	sd	s2,0(sp)
    80001ca4:	02010413          	addi	s0,sp,32
    uint8 i = 0;
    80001ca8:	00000493          	li	s1,0
    80001cac:	0400006f          	j	80001cec <_ZL11workerBodyCPv+0x5c>
        printString("C: i="); printInt(i); printString("\n");
    80001cb0:	00007517          	auipc	a0,0x7
    80001cb4:	50850513          	addi	a0,a0,1288 # 800091b8 <_ZTV12ConsumerSync+0x60>
    80001cb8:	00000097          	auipc	ra,0x0
    80001cbc:	3f4080e7          	jalr	1012(ra) # 800020ac <_Z11printStringPKc>
    80001cc0:	00000613          	li	a2,0
    80001cc4:	00a00593          	li	a1,10
    80001cc8:	00048513          	mv	a0,s1
    80001ccc:	00000097          	auipc	ra,0x0
    80001cd0:	590080e7          	jalr	1424(ra) # 8000225c <_Z8printIntiii>
    80001cd4:	00007517          	auipc	a0,0x7
    80001cd8:	6fc50513          	addi	a0,a0,1788 # 800093d0 <_ZTV12ConsumerSync+0x278>
    80001cdc:	00000097          	auipc	ra,0x0
    80001ce0:	3d0080e7          	jalr	976(ra) # 800020ac <_Z11printStringPKc>
    for (; i < 3; i++) {
    80001ce4:	0014849b          	addiw	s1,s1,1
    80001ce8:	0ff4f493          	andi	s1,s1,255
    80001cec:	00200793          	li	a5,2
    80001cf0:	fc97f0e3          	bgeu	a5,s1,80001cb0 <_ZL11workerBodyCPv+0x20>
    printString("C: dispatch\n");
    80001cf4:	00007517          	auipc	a0,0x7
    80001cf8:	4cc50513          	addi	a0,a0,1228 # 800091c0 <_ZTV12ConsumerSync+0x68>
    80001cfc:	00000097          	auipc	ra,0x0
    80001d00:	3b0080e7          	jalr	944(ra) # 800020ac <_Z11printStringPKc>
    __asm__ ("li t1, 7");
    80001d04:	00700313          	li	t1,7
    thread_dispatch();
    80001d08:	00003097          	auipc	ra,0x3
    80001d0c:	228080e7          	jalr	552(ra) # 80004f30 <_Z15thread_dispatchv>
    __asm__ ("mv %[t1], t1" : [t1] "=r"(t1));
    80001d10:	00030913          	mv	s2,t1
    printString("C: t1="); printInt(t1); printString("\n");
    80001d14:	00007517          	auipc	a0,0x7
    80001d18:	4bc50513          	addi	a0,a0,1212 # 800091d0 <_ZTV12ConsumerSync+0x78>
    80001d1c:	00000097          	auipc	ra,0x0
    80001d20:	390080e7          	jalr	912(ra) # 800020ac <_Z11printStringPKc>
    80001d24:	00000613          	li	a2,0
    80001d28:	00a00593          	li	a1,10
    80001d2c:	0009051b          	sext.w	a0,s2
    80001d30:	00000097          	auipc	ra,0x0
    80001d34:	52c080e7          	jalr	1324(ra) # 8000225c <_Z8printIntiii>
    80001d38:	00007517          	auipc	a0,0x7
    80001d3c:	69850513          	addi	a0,a0,1688 # 800093d0 <_ZTV12ConsumerSync+0x278>
    80001d40:	00000097          	auipc	ra,0x0
    80001d44:	36c080e7          	jalr	876(ra) # 800020ac <_Z11printStringPKc>
    uint64 result = fibonacci(12);
    80001d48:	00c00513          	li	a0,12
    80001d4c:	00000097          	auipc	ra,0x0
    80001d50:	d88080e7          	jalr	-632(ra) # 80001ad4 <_ZL9fibonaccim>
    80001d54:	00050913          	mv	s2,a0
    printString("C: fibonaci="); printInt(result); printString("\n");
    80001d58:	00007517          	auipc	a0,0x7
    80001d5c:	48050513          	addi	a0,a0,1152 # 800091d8 <_ZTV12ConsumerSync+0x80>
    80001d60:	00000097          	auipc	ra,0x0
    80001d64:	34c080e7          	jalr	844(ra) # 800020ac <_Z11printStringPKc>
    80001d68:	00000613          	li	a2,0
    80001d6c:	00a00593          	li	a1,10
    80001d70:	0009051b          	sext.w	a0,s2
    80001d74:	00000097          	auipc	ra,0x0
    80001d78:	4e8080e7          	jalr	1256(ra) # 8000225c <_Z8printIntiii>
    80001d7c:	00007517          	auipc	a0,0x7
    80001d80:	65450513          	addi	a0,a0,1620 # 800093d0 <_ZTV12ConsumerSync+0x278>
    80001d84:	00000097          	auipc	ra,0x0
    80001d88:	328080e7          	jalr	808(ra) # 800020ac <_Z11printStringPKc>
    80001d8c:	0400006f          	j	80001dcc <_ZL11workerBodyCPv+0x13c>
        printString("C: i="); printInt(i); printString("\n");
    80001d90:	00007517          	auipc	a0,0x7
    80001d94:	42850513          	addi	a0,a0,1064 # 800091b8 <_ZTV12ConsumerSync+0x60>
    80001d98:	00000097          	auipc	ra,0x0
    80001d9c:	314080e7          	jalr	788(ra) # 800020ac <_Z11printStringPKc>
    80001da0:	00000613          	li	a2,0
    80001da4:	00a00593          	li	a1,10
    80001da8:	00048513          	mv	a0,s1
    80001dac:	00000097          	auipc	ra,0x0
    80001db0:	4b0080e7          	jalr	1200(ra) # 8000225c <_Z8printIntiii>
    80001db4:	00007517          	auipc	a0,0x7
    80001db8:	61c50513          	addi	a0,a0,1564 # 800093d0 <_ZTV12ConsumerSync+0x278>
    80001dbc:	00000097          	auipc	ra,0x0
    80001dc0:	2f0080e7          	jalr	752(ra) # 800020ac <_Z11printStringPKc>
    for (; i < 6; i++) {
    80001dc4:	0014849b          	addiw	s1,s1,1
    80001dc8:	0ff4f493          	andi	s1,s1,255
    80001dcc:	00500793          	li	a5,5
    80001dd0:	fc97f0e3          	bgeu	a5,s1,80001d90 <_ZL11workerBodyCPv+0x100>
    printString("A finished!\n");
    80001dd4:	00007517          	auipc	a0,0x7
    80001dd8:	41450513          	addi	a0,a0,1044 # 800091e8 <_ZTV12ConsumerSync+0x90>
    80001ddc:	00000097          	auipc	ra,0x0
    80001de0:	2d0080e7          	jalr	720(ra) # 800020ac <_Z11printStringPKc>
    finishedC = true;
    80001de4:	00100793          	li	a5,1
    80001de8:	0000a717          	auipc	a4,0xa
    80001dec:	e8f704a3          	sb	a5,-375(a4) # 8000bc71 <_ZL9finishedC>
    thread_dispatch();
    80001df0:	00003097          	auipc	ra,0x3
    80001df4:	140080e7          	jalr	320(ra) # 80004f30 <_Z15thread_dispatchv>
}
    80001df8:	01813083          	ld	ra,24(sp)
    80001dfc:	01013403          	ld	s0,16(sp)
    80001e00:	00813483          	ld	s1,8(sp)
    80001e04:	00013903          	ld	s2,0(sp)
    80001e08:	02010113          	addi	sp,sp,32
    80001e0c:	00008067          	ret

0000000080001e10 <_ZL11workerBodyBPv>:
static void workerBodyB(void* arg) {
    80001e10:	fe010113          	addi	sp,sp,-32
    80001e14:	00113c23          	sd	ra,24(sp)
    80001e18:	00813823          	sd	s0,16(sp)
    80001e1c:	00913423          	sd	s1,8(sp)
    80001e20:	01213023          	sd	s2,0(sp)
    80001e24:	02010413          	addi	s0,sp,32
    for (uint64 i = 0; i < 16; i++) {
    80001e28:	00000913          	li	s2,0
    80001e2c:	0380006f          	j	80001e64 <_ZL11workerBodyBPv+0x54>
            thread_dispatch();
    80001e30:	00003097          	auipc	ra,0x3
    80001e34:	100080e7          	jalr	256(ra) # 80004f30 <_Z15thread_dispatchv>
        for (uint64 j = 0; j < 10000; j++) {
    80001e38:	00148493          	addi	s1,s1,1
    80001e3c:	000027b7          	lui	a5,0x2
    80001e40:	70f78793          	addi	a5,a5,1807 # 270f <_entry-0x7fffd8f1>
    80001e44:	0097ee63          	bltu	a5,s1,80001e60 <_ZL11workerBodyBPv+0x50>
            for (uint64 k = 0; k < 30000; k++) { /* busy wait */ }
    80001e48:	00000713          	li	a4,0
    80001e4c:	000077b7          	lui	a5,0x7
    80001e50:	52f78793          	addi	a5,a5,1327 # 752f <_entry-0x7fff8ad1>
    80001e54:	fce7eee3          	bltu	a5,a4,80001e30 <_ZL11workerBodyBPv+0x20>
    80001e58:	00170713          	addi	a4,a4,1
    80001e5c:	ff1ff06f          	j	80001e4c <_ZL11workerBodyBPv+0x3c>
    for (uint64 i = 0; i < 16; i++) {
    80001e60:	00190913          	addi	s2,s2,1
    80001e64:	00f00793          	li	a5,15
    80001e68:	0527e063          	bltu	a5,s2,80001ea8 <_ZL11workerBodyBPv+0x98>
        printString("B: i="); printInt(i); printString("\n");
    80001e6c:	00007517          	auipc	a0,0x7
    80001e70:	38c50513          	addi	a0,a0,908 # 800091f8 <_ZTV12ConsumerSync+0xa0>
    80001e74:	00000097          	auipc	ra,0x0
    80001e78:	238080e7          	jalr	568(ra) # 800020ac <_Z11printStringPKc>
    80001e7c:	00000613          	li	a2,0
    80001e80:	00a00593          	li	a1,10
    80001e84:	0009051b          	sext.w	a0,s2
    80001e88:	00000097          	auipc	ra,0x0
    80001e8c:	3d4080e7          	jalr	980(ra) # 8000225c <_Z8printIntiii>
    80001e90:	00007517          	auipc	a0,0x7
    80001e94:	54050513          	addi	a0,a0,1344 # 800093d0 <_ZTV12ConsumerSync+0x278>
    80001e98:	00000097          	auipc	ra,0x0
    80001e9c:	214080e7          	jalr	532(ra) # 800020ac <_Z11printStringPKc>
        for (uint64 j = 0; j < 10000; j++) {
    80001ea0:	00000493          	li	s1,0
    80001ea4:	f99ff06f          	j	80001e3c <_ZL11workerBodyBPv+0x2c>
    printString("B finished!\n");
    80001ea8:	00007517          	auipc	a0,0x7
    80001eac:	35850513          	addi	a0,a0,856 # 80009200 <_ZTV12ConsumerSync+0xa8>
    80001eb0:	00000097          	auipc	ra,0x0
    80001eb4:	1fc080e7          	jalr	508(ra) # 800020ac <_Z11printStringPKc>
    finishedB = true;
    80001eb8:	00100793          	li	a5,1
    80001ebc:	0000a717          	auipc	a4,0xa
    80001ec0:	daf70b23          	sb	a5,-586(a4) # 8000bc72 <_ZL9finishedB>
    thread_dispatch();
    80001ec4:	00003097          	auipc	ra,0x3
    80001ec8:	06c080e7          	jalr	108(ra) # 80004f30 <_Z15thread_dispatchv>
}
    80001ecc:	01813083          	ld	ra,24(sp)
    80001ed0:	01013403          	ld	s0,16(sp)
    80001ed4:	00813483          	ld	s1,8(sp)
    80001ed8:	00013903          	ld	s2,0(sp)
    80001edc:	02010113          	addi	sp,sp,32
    80001ee0:	00008067          	ret

0000000080001ee4 <_ZL11workerBodyAPv>:
static void workerBodyA(void* arg) {
    80001ee4:	fe010113          	addi	sp,sp,-32
    80001ee8:	00113c23          	sd	ra,24(sp)
    80001eec:	00813823          	sd	s0,16(sp)
    80001ef0:	00913423          	sd	s1,8(sp)
    80001ef4:	01213023          	sd	s2,0(sp)
    80001ef8:	02010413          	addi	s0,sp,32
    for (uint64 i = 0; i < 10; i++) {
    80001efc:	00000913          	li	s2,0
    80001f00:	0380006f          	j	80001f38 <_ZL11workerBodyAPv+0x54>
            thread_dispatch();
    80001f04:	00003097          	auipc	ra,0x3
    80001f08:	02c080e7          	jalr	44(ra) # 80004f30 <_Z15thread_dispatchv>
        for (uint64 j = 0; j < 10000; j++) {
    80001f0c:	00148493          	addi	s1,s1,1
    80001f10:	000027b7          	lui	a5,0x2
    80001f14:	70f78793          	addi	a5,a5,1807 # 270f <_entry-0x7fffd8f1>
    80001f18:	0097ee63          	bltu	a5,s1,80001f34 <_ZL11workerBodyAPv+0x50>
            for (uint64 k = 0; k < 30000; k++) { /* busy wait */ }
    80001f1c:	00000713          	li	a4,0
    80001f20:	000077b7          	lui	a5,0x7
    80001f24:	52f78793          	addi	a5,a5,1327 # 752f <_entry-0x7fff8ad1>
    80001f28:	fce7eee3          	bltu	a5,a4,80001f04 <_ZL11workerBodyAPv+0x20>
    80001f2c:	00170713          	addi	a4,a4,1
    80001f30:	ff1ff06f          	j	80001f20 <_ZL11workerBodyAPv+0x3c>
    for (uint64 i = 0; i < 10; i++) {
    80001f34:	00190913          	addi	s2,s2,1
    80001f38:	00900793          	li	a5,9
    80001f3c:	0527e063          	bltu	a5,s2,80001f7c <_ZL11workerBodyAPv+0x98>
        printString("A: i="); printInt(i); printString("\n");
    80001f40:	00007517          	auipc	a0,0x7
    80001f44:	2d050513          	addi	a0,a0,720 # 80009210 <_ZTV12ConsumerSync+0xb8>
    80001f48:	00000097          	auipc	ra,0x0
    80001f4c:	164080e7          	jalr	356(ra) # 800020ac <_Z11printStringPKc>
    80001f50:	00000613          	li	a2,0
    80001f54:	00a00593          	li	a1,10
    80001f58:	0009051b          	sext.w	a0,s2
    80001f5c:	00000097          	auipc	ra,0x0
    80001f60:	300080e7          	jalr	768(ra) # 8000225c <_Z8printIntiii>
    80001f64:	00007517          	auipc	a0,0x7
    80001f68:	46c50513          	addi	a0,a0,1132 # 800093d0 <_ZTV12ConsumerSync+0x278>
    80001f6c:	00000097          	auipc	ra,0x0
    80001f70:	140080e7          	jalr	320(ra) # 800020ac <_Z11printStringPKc>
        for (uint64 j = 0; j < 10000; j++) {
    80001f74:	00000493          	li	s1,0
    80001f78:	f99ff06f          	j	80001f10 <_ZL11workerBodyAPv+0x2c>
    printString("A finished!\n");
    80001f7c:	00007517          	auipc	a0,0x7
    80001f80:	26c50513          	addi	a0,a0,620 # 800091e8 <_ZTV12ConsumerSync+0x90>
    80001f84:	00000097          	auipc	ra,0x0
    80001f88:	128080e7          	jalr	296(ra) # 800020ac <_Z11printStringPKc>
    finishedA = true;
    80001f8c:	00100793          	li	a5,1
    80001f90:	0000a717          	auipc	a4,0xa
    80001f94:	cef701a3          	sb	a5,-797(a4) # 8000bc73 <_ZL9finishedA>
}
    80001f98:	01813083          	ld	ra,24(sp)
    80001f9c:	01013403          	ld	s0,16(sp)
    80001fa0:	00813483          	ld	s1,8(sp)
    80001fa4:	00013903          	ld	s2,0(sp)
    80001fa8:	02010113          	addi	sp,sp,32
    80001fac:	00008067          	ret

0000000080001fb0 <_Z18Threads_C_API_testv>:


void Threads_C_API_test() {
    80001fb0:	fd010113          	addi	sp,sp,-48
    80001fb4:	02113423          	sd	ra,40(sp)
    80001fb8:	02813023          	sd	s0,32(sp)
    80001fbc:	03010413          	addi	s0,sp,48
    thread_t threads[4];
    thread_create(&threads[0], workerBodyA, nullptr);
    80001fc0:	00000613          	li	a2,0
    80001fc4:	00000597          	auipc	a1,0x0
    80001fc8:	f2058593          	addi	a1,a1,-224 # 80001ee4 <_ZL11workerBodyAPv>
    80001fcc:	fd040513          	addi	a0,s0,-48
    80001fd0:	00003097          	auipc	ra,0x3
    80001fd4:	e98080e7          	jalr	-360(ra) # 80004e68 <_Z13thread_createPP3TCBPFvPvES2_>
    printString("ThreadA created\n");
    80001fd8:	00007517          	auipc	a0,0x7
    80001fdc:	24050513          	addi	a0,a0,576 # 80009218 <_ZTV12ConsumerSync+0xc0>
    80001fe0:	00000097          	auipc	ra,0x0
    80001fe4:	0cc080e7          	jalr	204(ra) # 800020ac <_Z11printStringPKc>

    thread_create(&threads[1], workerBodyB, nullptr);
    80001fe8:	00000613          	li	a2,0
    80001fec:	00000597          	auipc	a1,0x0
    80001ff0:	e2458593          	addi	a1,a1,-476 # 80001e10 <_ZL11workerBodyBPv>
    80001ff4:	fd840513          	addi	a0,s0,-40
    80001ff8:	00003097          	auipc	ra,0x3
    80001ffc:	e70080e7          	jalr	-400(ra) # 80004e68 <_Z13thread_createPP3TCBPFvPvES2_>
    printString("ThreadB created\n");
    80002000:	00007517          	auipc	a0,0x7
    80002004:	23050513          	addi	a0,a0,560 # 80009230 <_ZTV12ConsumerSync+0xd8>
    80002008:	00000097          	auipc	ra,0x0
    8000200c:	0a4080e7          	jalr	164(ra) # 800020ac <_Z11printStringPKc>

    thread_create(&threads[2], workerBodyC, nullptr);
    80002010:	00000613          	li	a2,0
    80002014:	00000597          	auipc	a1,0x0
    80002018:	c7c58593          	addi	a1,a1,-900 # 80001c90 <_ZL11workerBodyCPv>
    8000201c:	fe040513          	addi	a0,s0,-32
    80002020:	00003097          	auipc	ra,0x3
    80002024:	e48080e7          	jalr	-440(ra) # 80004e68 <_Z13thread_createPP3TCBPFvPvES2_>
    printString("ThreadC created\n");
    80002028:	00007517          	auipc	a0,0x7
    8000202c:	22050513          	addi	a0,a0,544 # 80009248 <_ZTV12ConsumerSync+0xf0>
    80002030:	00000097          	auipc	ra,0x0
    80002034:	07c080e7          	jalr	124(ra) # 800020ac <_Z11printStringPKc>

    thread_create(&threads[3], workerBodyD, nullptr);
    80002038:	00000613          	li	a2,0
    8000203c:	00000597          	auipc	a1,0x0
    80002040:	b0c58593          	addi	a1,a1,-1268 # 80001b48 <_ZL11workerBodyDPv>
    80002044:	fe840513          	addi	a0,s0,-24
    80002048:	00003097          	auipc	ra,0x3
    8000204c:	e20080e7          	jalr	-480(ra) # 80004e68 <_Z13thread_createPP3TCBPFvPvES2_>
    printString("ThreadD created\n");
    80002050:	00007517          	auipc	a0,0x7
    80002054:	21050513          	addi	a0,a0,528 # 80009260 <_ZTV12ConsumerSync+0x108>
    80002058:	00000097          	auipc	ra,0x0
    8000205c:	054080e7          	jalr	84(ra) # 800020ac <_Z11printStringPKc>
    80002060:	00c0006f          	j	8000206c <_Z18Threads_C_API_testv+0xbc>

    while (!(finishedA && finishedB && finishedC && finishedD)) {
        thread_dispatch();
    80002064:	00003097          	auipc	ra,0x3
    80002068:	ecc080e7          	jalr	-308(ra) # 80004f30 <_Z15thread_dispatchv>
    while (!(finishedA && finishedB && finishedC && finishedD)) {
    8000206c:	0000a797          	auipc	a5,0xa
    80002070:	c077c783          	lbu	a5,-1017(a5) # 8000bc73 <_ZL9finishedA>
    80002074:	fe0788e3          	beqz	a5,80002064 <_Z18Threads_C_API_testv+0xb4>
    80002078:	0000a797          	auipc	a5,0xa
    8000207c:	bfa7c783          	lbu	a5,-1030(a5) # 8000bc72 <_ZL9finishedB>
    80002080:	fe0782e3          	beqz	a5,80002064 <_Z18Threads_C_API_testv+0xb4>
    80002084:	0000a797          	auipc	a5,0xa
    80002088:	bed7c783          	lbu	a5,-1043(a5) # 8000bc71 <_ZL9finishedC>
    8000208c:	fc078ce3          	beqz	a5,80002064 <_Z18Threads_C_API_testv+0xb4>
    80002090:	0000a797          	auipc	a5,0xa
    80002094:	be07c783          	lbu	a5,-1056(a5) # 8000bc70 <_ZL9finishedD>
    80002098:	fc0786e3          	beqz	a5,80002064 <_Z18Threads_C_API_testv+0xb4>
    }

}
    8000209c:	02813083          	ld	ra,40(sp)
    800020a0:	02013403          	ld	s0,32(sp)
    800020a4:	03010113          	addi	sp,sp,48
    800020a8:	00008067          	ret

00000000800020ac <_Z11printStringPKc>:

#define LOCK() while(copy_and_swap(lockPrint, 0, 1)) thread_dispatch()
#define UNLOCK() while(copy_and_swap(lockPrint, 1, 0))

void printString(char const *string)
{
    800020ac:	fe010113          	addi	sp,sp,-32
    800020b0:	00113c23          	sd	ra,24(sp)
    800020b4:	00813823          	sd	s0,16(sp)
    800020b8:	00913423          	sd	s1,8(sp)
    800020bc:	02010413          	addi	s0,sp,32
    800020c0:	00050493          	mv	s1,a0
    LOCK();
    800020c4:	00100613          	li	a2,1
    800020c8:	00000593          	li	a1,0
    800020cc:	0000a517          	auipc	a0,0xa
    800020d0:	bac50513          	addi	a0,a0,-1108 # 8000bc78 <lockPrint>
    800020d4:	fffff097          	auipc	ra,0xfffff
    800020d8:	f2c080e7          	jalr	-212(ra) # 80001000 <copy_and_swap>
    800020dc:	00050863          	beqz	a0,800020ec <_Z11printStringPKc+0x40>
    800020e0:	00003097          	auipc	ra,0x3
    800020e4:	e50080e7          	jalr	-432(ra) # 80004f30 <_Z15thread_dispatchv>
    800020e8:	fddff06f          	j	800020c4 <_Z11printStringPKc+0x18>
    while (*string != '\0')
    800020ec:	0004c503          	lbu	a0,0(s1)
    800020f0:	00050a63          	beqz	a0,80002104 <_Z11printStringPKc+0x58>
    {
        putc(*string);
    800020f4:	00003097          	auipc	ra,0x3
    800020f8:	03c080e7          	jalr	60(ra) # 80005130 <_Z4putcc>
        string++;
    800020fc:	00148493          	addi	s1,s1,1
    while (*string != '\0')
    80002100:	fedff06f          	j	800020ec <_Z11printStringPKc+0x40>
    }
    UNLOCK();
    80002104:	00000613          	li	a2,0
    80002108:	00100593          	li	a1,1
    8000210c:	0000a517          	auipc	a0,0xa
    80002110:	b6c50513          	addi	a0,a0,-1172 # 8000bc78 <lockPrint>
    80002114:	fffff097          	auipc	ra,0xfffff
    80002118:	eec080e7          	jalr	-276(ra) # 80001000 <copy_and_swap>
    8000211c:	fe0514e3          	bnez	a0,80002104 <_Z11printStringPKc+0x58>
}
    80002120:	01813083          	ld	ra,24(sp)
    80002124:	01013403          	ld	s0,16(sp)
    80002128:	00813483          	ld	s1,8(sp)
    8000212c:	02010113          	addi	sp,sp,32
    80002130:	00008067          	ret

0000000080002134 <_Z9getStringPci>:

char* getString(char *buf, int max) {
    80002134:	fd010113          	addi	sp,sp,-48
    80002138:	02113423          	sd	ra,40(sp)
    8000213c:	02813023          	sd	s0,32(sp)
    80002140:	00913c23          	sd	s1,24(sp)
    80002144:	01213823          	sd	s2,16(sp)
    80002148:	01313423          	sd	s3,8(sp)
    8000214c:	01413023          	sd	s4,0(sp)
    80002150:	03010413          	addi	s0,sp,48
    80002154:	00050993          	mv	s3,a0
    80002158:	00058a13          	mv	s4,a1
    LOCK();
    8000215c:	00100613          	li	a2,1
    80002160:	00000593          	li	a1,0
    80002164:	0000a517          	auipc	a0,0xa
    80002168:	b1450513          	addi	a0,a0,-1260 # 8000bc78 <lockPrint>
    8000216c:	fffff097          	auipc	ra,0xfffff
    80002170:	e94080e7          	jalr	-364(ra) # 80001000 <copy_and_swap>
    80002174:	00050863          	beqz	a0,80002184 <_Z9getStringPci+0x50>
    80002178:	00003097          	auipc	ra,0x3
    8000217c:	db8080e7          	jalr	-584(ra) # 80004f30 <_Z15thread_dispatchv>
    80002180:	fddff06f          	j	8000215c <_Z9getStringPci+0x28>
    int i, cc;
    char c;

    for(i=0; i+1 < max; ){
    80002184:	00000913          	li	s2,0
    80002188:	00090493          	mv	s1,s2
    8000218c:	0019091b          	addiw	s2,s2,1
    80002190:	03495a63          	bge	s2,s4,800021c4 <_Z9getStringPci+0x90>
        cc = getc();
    80002194:	00003097          	auipc	ra,0x3
    80002198:	f68080e7          	jalr	-152(ra) # 800050fc <_Z4getcv>
        if(cc < 1)
    8000219c:	02050463          	beqz	a0,800021c4 <_Z9getStringPci+0x90>
            break;
        c = cc;
        buf[i++] = c;
    800021a0:	009984b3          	add	s1,s3,s1
    800021a4:	00a48023          	sb	a0,0(s1)
        if(c == '\n' || c == '\r')
    800021a8:	00a00793          	li	a5,10
    800021ac:	00f50a63          	beq	a0,a5,800021c0 <_Z9getStringPci+0x8c>
    800021b0:	00d00793          	li	a5,13
    800021b4:	fcf51ae3          	bne	a0,a5,80002188 <_Z9getStringPci+0x54>
        buf[i++] = c;
    800021b8:	00090493          	mv	s1,s2
    800021bc:	0080006f          	j	800021c4 <_Z9getStringPci+0x90>
    800021c0:	00090493          	mv	s1,s2
            break;
    }
    buf[i] = '\0';
    800021c4:	009984b3          	add	s1,s3,s1
    800021c8:	00048023          	sb	zero,0(s1)

    UNLOCK();
    800021cc:	00000613          	li	a2,0
    800021d0:	00100593          	li	a1,1
    800021d4:	0000a517          	auipc	a0,0xa
    800021d8:	aa450513          	addi	a0,a0,-1372 # 8000bc78 <lockPrint>
    800021dc:	fffff097          	auipc	ra,0xfffff
    800021e0:	e24080e7          	jalr	-476(ra) # 80001000 <copy_and_swap>
    800021e4:	fe0514e3          	bnez	a0,800021cc <_Z9getStringPci+0x98>
    return buf;
}
    800021e8:	00098513          	mv	a0,s3
    800021ec:	02813083          	ld	ra,40(sp)
    800021f0:	02013403          	ld	s0,32(sp)
    800021f4:	01813483          	ld	s1,24(sp)
    800021f8:	01013903          	ld	s2,16(sp)
    800021fc:	00813983          	ld	s3,8(sp)
    80002200:	00013a03          	ld	s4,0(sp)
    80002204:	03010113          	addi	sp,sp,48
    80002208:	00008067          	ret

000000008000220c <_Z11stringToIntPKc>:

int stringToInt(const char *s) {
    8000220c:	ff010113          	addi	sp,sp,-16
    80002210:	00813423          	sd	s0,8(sp)
    80002214:	01010413          	addi	s0,sp,16
    80002218:	00050693          	mv	a3,a0
    int n;

    n = 0;
    8000221c:	00000513          	li	a0,0
    while ('0' <= *s && *s <= '9')
    80002220:	0006c603          	lbu	a2,0(a3)
    80002224:	fd06071b          	addiw	a4,a2,-48
    80002228:	0ff77713          	andi	a4,a4,255
    8000222c:	00900793          	li	a5,9
    80002230:	02e7e063          	bltu	a5,a4,80002250 <_Z11stringToIntPKc+0x44>
        n = n * 10 + *s++ - '0';
    80002234:	0025179b          	slliw	a5,a0,0x2
    80002238:	00a787bb          	addw	a5,a5,a0
    8000223c:	0017979b          	slliw	a5,a5,0x1
    80002240:	00168693          	addi	a3,a3,1
    80002244:	00c787bb          	addw	a5,a5,a2
    80002248:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
    8000224c:	fd5ff06f          	j	80002220 <_Z11stringToIntPKc+0x14>
    return n;
}
    80002250:	00813403          	ld	s0,8(sp)
    80002254:	01010113          	addi	sp,sp,16
    80002258:	00008067          	ret

000000008000225c <_Z8printIntiii>:

char digits[] = "0123456789ABCDEF";

void printInt(int xx, int base, int sgn)
{
    8000225c:	fc010113          	addi	sp,sp,-64
    80002260:	02113c23          	sd	ra,56(sp)
    80002264:	02813823          	sd	s0,48(sp)
    80002268:	02913423          	sd	s1,40(sp)
    8000226c:	03213023          	sd	s2,32(sp)
    80002270:	01313c23          	sd	s3,24(sp)
    80002274:	04010413          	addi	s0,sp,64
    80002278:	00050493          	mv	s1,a0
    8000227c:	00058913          	mv	s2,a1
    80002280:	00060993          	mv	s3,a2
    LOCK();
    80002284:	00100613          	li	a2,1
    80002288:	00000593          	li	a1,0
    8000228c:	0000a517          	auipc	a0,0xa
    80002290:	9ec50513          	addi	a0,a0,-1556 # 8000bc78 <lockPrint>
    80002294:	fffff097          	auipc	ra,0xfffff
    80002298:	d6c080e7          	jalr	-660(ra) # 80001000 <copy_and_swap>
    8000229c:	00050863          	beqz	a0,800022ac <_Z8printIntiii+0x50>
    800022a0:	00003097          	auipc	ra,0x3
    800022a4:	c90080e7          	jalr	-880(ra) # 80004f30 <_Z15thread_dispatchv>
    800022a8:	fddff06f          	j	80002284 <_Z8printIntiii+0x28>
    char buf[16];
    int i, neg;
    uint x;

    neg = 0;
    if(sgn && xx < 0){
    800022ac:	00098463          	beqz	s3,800022b4 <_Z8printIntiii+0x58>
    800022b0:	0804c463          	bltz	s1,80002338 <_Z8printIntiii+0xdc>
        neg = 1;
        x = -xx;
    } else {
        x = xx;
    800022b4:	0004851b          	sext.w	a0,s1
    neg = 0;
    800022b8:	00000593          	li	a1,0
    }

    i = 0;
    800022bc:	00000493          	li	s1,0
    do{
        buf[i++] = digits[x % base];
    800022c0:	0009079b          	sext.w	a5,s2
    800022c4:	0325773b          	remuw	a4,a0,s2
    800022c8:	00048613          	mv	a2,s1
    800022cc:	0014849b          	addiw	s1,s1,1
    800022d0:	02071693          	slli	a3,a4,0x20
    800022d4:	0206d693          	srli	a3,a3,0x20
    800022d8:	00009717          	auipc	a4,0x9
    800022dc:	62870713          	addi	a4,a4,1576 # 8000b900 <digits>
    800022e0:	00d70733          	add	a4,a4,a3
    800022e4:	00074683          	lbu	a3,0(a4)
    800022e8:	fd040713          	addi	a4,s0,-48
    800022ec:	00c70733          	add	a4,a4,a2
    800022f0:	fed70823          	sb	a3,-16(a4)
    }while((x /= base) != 0);
    800022f4:	0005071b          	sext.w	a4,a0
    800022f8:	0325553b          	divuw	a0,a0,s2
    800022fc:	fcf772e3          	bgeu	a4,a5,800022c0 <_Z8printIntiii+0x64>
    if(neg)
    80002300:	00058c63          	beqz	a1,80002318 <_Z8printIntiii+0xbc>
        buf[i++] = '-';
    80002304:	fd040793          	addi	a5,s0,-48
    80002308:	009784b3          	add	s1,a5,s1
    8000230c:	02d00793          	li	a5,45
    80002310:	fef48823          	sb	a5,-16(s1)
    80002314:	0026049b          	addiw	s1,a2,2

    while(--i >= 0)
    80002318:	fff4849b          	addiw	s1,s1,-1
    8000231c:	0204c463          	bltz	s1,80002344 <_Z8printIntiii+0xe8>
        putc(buf[i]);
    80002320:	fd040793          	addi	a5,s0,-48
    80002324:	009787b3          	add	a5,a5,s1
    80002328:	ff07c503          	lbu	a0,-16(a5)
    8000232c:	00003097          	auipc	ra,0x3
    80002330:	e04080e7          	jalr	-508(ra) # 80005130 <_Z4putcc>
    80002334:	fe5ff06f          	j	80002318 <_Z8printIntiii+0xbc>
        x = -xx;
    80002338:	4090053b          	negw	a0,s1
        neg = 1;
    8000233c:	00100593          	li	a1,1
        x = -xx;
    80002340:	f7dff06f          	j	800022bc <_Z8printIntiii+0x60>

    UNLOCK();
    80002344:	00000613          	li	a2,0
    80002348:	00100593          	li	a1,1
    8000234c:	0000a517          	auipc	a0,0xa
    80002350:	92c50513          	addi	a0,a0,-1748 # 8000bc78 <lockPrint>
    80002354:	fffff097          	auipc	ra,0xfffff
    80002358:	cac080e7          	jalr	-852(ra) # 80001000 <copy_and_swap>
    8000235c:	fe0514e3          	bnez	a0,80002344 <_Z8printIntiii+0xe8>
    80002360:	03813083          	ld	ra,56(sp)
    80002364:	03013403          	ld	s0,48(sp)
    80002368:	02813483          	ld	s1,40(sp)
    8000236c:	02013903          	ld	s2,32(sp)
    80002370:	01813983          	ld	s3,24(sp)
    80002374:	04010113          	addi	sp,sp,64
    80002378:	00008067          	ret

000000008000237c <_ZN9BufferCPPC1Ei>:
#include "buffer_CPP_API.hpp"

BufferCPP::BufferCPP(int _cap) : cap(_cap + 1), head(0), tail(0) {
    8000237c:	fd010113          	addi	sp,sp,-48
    80002380:	02113423          	sd	ra,40(sp)
    80002384:	02813023          	sd	s0,32(sp)
    80002388:	00913c23          	sd	s1,24(sp)
    8000238c:	01213823          	sd	s2,16(sp)
    80002390:	01313423          	sd	s3,8(sp)
    80002394:	03010413          	addi	s0,sp,48
    80002398:	00050493          	mv	s1,a0
    8000239c:	00058913          	mv	s2,a1
    800023a0:	0015879b          	addiw	a5,a1,1
    800023a4:	0007851b          	sext.w	a0,a5
    800023a8:	00f4a023          	sw	a5,0(s1)
    800023ac:	0004a823          	sw	zero,16(s1)
    800023b0:	0004aa23          	sw	zero,20(s1)
    buffer = (int *)mem_alloc(sizeof(int) * cap);
    800023b4:	00251513          	slli	a0,a0,0x2
    800023b8:	00003097          	auipc	ra,0x3
    800023bc:	a24080e7          	jalr	-1500(ra) # 80004ddc <_Z9mem_allocm>
    800023c0:	00a4b423          	sd	a0,8(s1)
    itemAvailable = new Semaphore(0);
    800023c4:	01000513          	li	a0,16
    800023c8:	00004097          	auipc	ra,0x4
    800023cc:	c50080e7          	jalr	-944(ra) # 80006018 <_Znwm>
    800023d0:	00050993          	mv	s3,a0
    800023d4:	00000593          	li	a1,0
    800023d8:	00004097          	auipc	ra,0x4
    800023dc:	f1c080e7          	jalr	-228(ra) # 800062f4 <_ZN9SemaphoreC1Ej>
    800023e0:	0334b023          	sd	s3,32(s1)
    spaceAvailable = new Semaphore(_cap);
    800023e4:	01000513          	li	a0,16
    800023e8:	00004097          	auipc	ra,0x4
    800023ec:	c30080e7          	jalr	-976(ra) # 80006018 <_Znwm>
    800023f0:	00050993          	mv	s3,a0
    800023f4:	00090593          	mv	a1,s2
    800023f8:	00004097          	auipc	ra,0x4
    800023fc:	efc080e7          	jalr	-260(ra) # 800062f4 <_ZN9SemaphoreC1Ej>
    80002400:	0134bc23          	sd	s3,24(s1)
    mutexHead = new Semaphore(1);
    80002404:	01000513          	li	a0,16
    80002408:	00004097          	auipc	ra,0x4
    8000240c:	c10080e7          	jalr	-1008(ra) # 80006018 <_Znwm>
    80002410:	00050913          	mv	s2,a0
    80002414:	00100593          	li	a1,1
    80002418:	00004097          	auipc	ra,0x4
    8000241c:	edc080e7          	jalr	-292(ra) # 800062f4 <_ZN9SemaphoreC1Ej>
    80002420:	0324b423          	sd	s2,40(s1)
    mutexTail = new Semaphore(1);
    80002424:	01000513          	li	a0,16
    80002428:	00004097          	auipc	ra,0x4
    8000242c:	bf0080e7          	jalr	-1040(ra) # 80006018 <_Znwm>
    80002430:	00050913          	mv	s2,a0
    80002434:	00100593          	li	a1,1
    80002438:	00004097          	auipc	ra,0x4
    8000243c:	ebc080e7          	jalr	-324(ra) # 800062f4 <_ZN9SemaphoreC1Ej>
    80002440:	0324b823          	sd	s2,48(s1)
}
    80002444:	02813083          	ld	ra,40(sp)
    80002448:	02013403          	ld	s0,32(sp)
    8000244c:	01813483          	ld	s1,24(sp)
    80002450:	01013903          	ld	s2,16(sp)
    80002454:	00813983          	ld	s3,8(sp)
    80002458:	03010113          	addi	sp,sp,48
    8000245c:	00008067          	ret
    80002460:	00050493          	mv	s1,a0
    itemAvailable = new Semaphore(0);
    80002464:	00098513          	mv	a0,s3
    80002468:	00004097          	auipc	ra,0x4
    8000246c:	c00080e7          	jalr	-1024(ra) # 80006068 <_ZdlPv>
    80002470:	00048513          	mv	a0,s1
    80002474:	0000b097          	auipc	ra,0xb
    80002478:	1e4080e7          	jalr	484(ra) # 8000d658 <_Unwind_Resume>
    8000247c:	00050493          	mv	s1,a0
    spaceAvailable = new Semaphore(_cap);
    80002480:	00098513          	mv	a0,s3
    80002484:	00004097          	auipc	ra,0x4
    80002488:	be4080e7          	jalr	-1052(ra) # 80006068 <_ZdlPv>
    8000248c:	00048513          	mv	a0,s1
    80002490:	0000b097          	auipc	ra,0xb
    80002494:	1c8080e7          	jalr	456(ra) # 8000d658 <_Unwind_Resume>
    80002498:	00050493          	mv	s1,a0
    mutexHead = new Semaphore(1);
    8000249c:	00090513          	mv	a0,s2
    800024a0:	00004097          	auipc	ra,0x4
    800024a4:	bc8080e7          	jalr	-1080(ra) # 80006068 <_ZdlPv>
    800024a8:	00048513          	mv	a0,s1
    800024ac:	0000b097          	auipc	ra,0xb
    800024b0:	1ac080e7          	jalr	428(ra) # 8000d658 <_Unwind_Resume>
    800024b4:	00050493          	mv	s1,a0
    mutexTail = new Semaphore(1);
    800024b8:	00090513          	mv	a0,s2
    800024bc:	00004097          	auipc	ra,0x4
    800024c0:	bac080e7          	jalr	-1108(ra) # 80006068 <_ZdlPv>
    800024c4:	00048513          	mv	a0,s1
    800024c8:	0000b097          	auipc	ra,0xb
    800024cc:	190080e7          	jalr	400(ra) # 8000d658 <_Unwind_Resume>

00000000800024d0 <_ZN9BufferCPP3putEi>:
    delete mutexTail;
    delete mutexHead;

}

void BufferCPP::put(int val) {
    800024d0:	fe010113          	addi	sp,sp,-32
    800024d4:	00113c23          	sd	ra,24(sp)
    800024d8:	00813823          	sd	s0,16(sp)
    800024dc:	00913423          	sd	s1,8(sp)
    800024e0:	01213023          	sd	s2,0(sp)
    800024e4:	02010413          	addi	s0,sp,32
    800024e8:	00050493          	mv	s1,a0
    800024ec:	00058913          	mv	s2,a1
    spaceAvailable->wait();
    800024f0:	01853503          	ld	a0,24(a0)
    800024f4:	00004097          	auipc	ra,0x4
    800024f8:	e38080e7          	jalr	-456(ra) # 8000632c <_ZN9Semaphore4waitEv>

    mutexTail->wait();
    800024fc:	0304b503          	ld	a0,48(s1)
    80002500:	00004097          	auipc	ra,0x4
    80002504:	e2c080e7          	jalr	-468(ra) # 8000632c <_ZN9Semaphore4waitEv>
    buffer[tail] = val;
    80002508:	0084b783          	ld	a5,8(s1)
    8000250c:	0144a703          	lw	a4,20(s1)
    80002510:	00271713          	slli	a4,a4,0x2
    80002514:	00e787b3          	add	a5,a5,a4
    80002518:	0127a023          	sw	s2,0(a5)
    tail = (tail + 1) % cap;
    8000251c:	0144a783          	lw	a5,20(s1)
    80002520:	0017879b          	addiw	a5,a5,1
    80002524:	0004a703          	lw	a4,0(s1)
    80002528:	02e7e7bb          	remw	a5,a5,a4
    8000252c:	00f4aa23          	sw	a5,20(s1)
    mutexTail->signal();
    80002530:	0304b503          	ld	a0,48(s1)
    80002534:	00004097          	auipc	ra,0x4
    80002538:	e24080e7          	jalr	-476(ra) # 80006358 <_ZN9Semaphore6signalEv>

    itemAvailable->signal();
    8000253c:	0204b503          	ld	a0,32(s1)
    80002540:	00004097          	auipc	ra,0x4
    80002544:	e18080e7          	jalr	-488(ra) # 80006358 <_ZN9Semaphore6signalEv>

}
    80002548:	01813083          	ld	ra,24(sp)
    8000254c:	01013403          	ld	s0,16(sp)
    80002550:	00813483          	ld	s1,8(sp)
    80002554:	00013903          	ld	s2,0(sp)
    80002558:	02010113          	addi	sp,sp,32
    8000255c:	00008067          	ret

0000000080002560 <_ZN9BufferCPP3getEv>:

int BufferCPP::get() {
    80002560:	fe010113          	addi	sp,sp,-32
    80002564:	00113c23          	sd	ra,24(sp)
    80002568:	00813823          	sd	s0,16(sp)
    8000256c:	00913423          	sd	s1,8(sp)
    80002570:	01213023          	sd	s2,0(sp)
    80002574:	02010413          	addi	s0,sp,32
    80002578:	00050493          	mv	s1,a0
    itemAvailable->wait();
    8000257c:	02053503          	ld	a0,32(a0)
    80002580:	00004097          	auipc	ra,0x4
    80002584:	dac080e7          	jalr	-596(ra) # 8000632c <_ZN9Semaphore4waitEv>

    mutexHead->wait();
    80002588:	0284b503          	ld	a0,40(s1)
    8000258c:	00004097          	auipc	ra,0x4
    80002590:	da0080e7          	jalr	-608(ra) # 8000632c <_ZN9Semaphore4waitEv>

    int ret = buffer[head];
    80002594:	0084b703          	ld	a4,8(s1)
    80002598:	0104a783          	lw	a5,16(s1)
    8000259c:	00279693          	slli	a3,a5,0x2
    800025a0:	00d70733          	add	a4,a4,a3
    800025a4:	00072903          	lw	s2,0(a4)
    head = (head + 1) % cap;
    800025a8:	0017879b          	addiw	a5,a5,1
    800025ac:	0004a703          	lw	a4,0(s1)
    800025b0:	02e7e7bb          	remw	a5,a5,a4
    800025b4:	00f4a823          	sw	a5,16(s1)
    mutexHead->signal();
    800025b8:	0284b503          	ld	a0,40(s1)
    800025bc:	00004097          	auipc	ra,0x4
    800025c0:	d9c080e7          	jalr	-612(ra) # 80006358 <_ZN9Semaphore6signalEv>

    spaceAvailable->signal();
    800025c4:	0184b503          	ld	a0,24(s1)
    800025c8:	00004097          	auipc	ra,0x4
    800025cc:	d90080e7          	jalr	-624(ra) # 80006358 <_ZN9Semaphore6signalEv>

    return ret;
}
    800025d0:	00090513          	mv	a0,s2
    800025d4:	01813083          	ld	ra,24(sp)
    800025d8:	01013403          	ld	s0,16(sp)
    800025dc:	00813483          	ld	s1,8(sp)
    800025e0:	00013903          	ld	s2,0(sp)
    800025e4:	02010113          	addi	sp,sp,32
    800025e8:	00008067          	ret

00000000800025ec <_ZN9BufferCPP6getCntEv>:

int BufferCPP::getCnt() {
    800025ec:	fe010113          	addi	sp,sp,-32
    800025f0:	00113c23          	sd	ra,24(sp)
    800025f4:	00813823          	sd	s0,16(sp)
    800025f8:	00913423          	sd	s1,8(sp)
    800025fc:	01213023          	sd	s2,0(sp)
    80002600:	02010413          	addi	s0,sp,32
    80002604:	00050493          	mv	s1,a0
    int ret;

    mutexHead->wait();
    80002608:	02853503          	ld	a0,40(a0)
    8000260c:	00004097          	auipc	ra,0x4
    80002610:	d20080e7          	jalr	-736(ra) # 8000632c <_ZN9Semaphore4waitEv>
    mutexTail->wait();
    80002614:	0304b503          	ld	a0,48(s1)
    80002618:	00004097          	auipc	ra,0x4
    8000261c:	d14080e7          	jalr	-748(ra) # 8000632c <_ZN9Semaphore4waitEv>

    if (tail >= head) {
    80002620:	0144a783          	lw	a5,20(s1)
    80002624:	0104a903          	lw	s2,16(s1)
    80002628:	0327ce63          	blt	a5,s2,80002664 <_ZN9BufferCPP6getCntEv+0x78>
        ret = tail - head;
    8000262c:	4127893b          	subw	s2,a5,s2
    } else {
        ret = cap - head + tail;
    }

    mutexTail->signal();
    80002630:	0304b503          	ld	a0,48(s1)
    80002634:	00004097          	auipc	ra,0x4
    80002638:	d24080e7          	jalr	-732(ra) # 80006358 <_ZN9Semaphore6signalEv>
    mutexHead->signal();
    8000263c:	0284b503          	ld	a0,40(s1)
    80002640:	00004097          	auipc	ra,0x4
    80002644:	d18080e7          	jalr	-744(ra) # 80006358 <_ZN9Semaphore6signalEv>

    return ret;
}
    80002648:	00090513          	mv	a0,s2
    8000264c:	01813083          	ld	ra,24(sp)
    80002650:	01013403          	ld	s0,16(sp)
    80002654:	00813483          	ld	s1,8(sp)
    80002658:	00013903          	ld	s2,0(sp)
    8000265c:	02010113          	addi	sp,sp,32
    80002660:	00008067          	ret
        ret = cap - head + tail;
    80002664:	0004a703          	lw	a4,0(s1)
    80002668:	4127093b          	subw	s2,a4,s2
    8000266c:	00f9093b          	addw	s2,s2,a5
    80002670:	fc1ff06f          	j	80002630 <_ZN9BufferCPP6getCntEv+0x44>

0000000080002674 <_ZN9BufferCPPD1Ev>:
BufferCPP::~BufferCPP() {
    80002674:	fe010113          	addi	sp,sp,-32
    80002678:	00113c23          	sd	ra,24(sp)
    8000267c:	00813823          	sd	s0,16(sp)
    80002680:	00913423          	sd	s1,8(sp)
    80002684:	02010413          	addi	s0,sp,32
    80002688:	00050493          	mv	s1,a0
    Console::putc('\n');
    8000268c:	00a00513          	li	a0,10
    80002690:	00004097          	auipc	ra,0x4
    80002694:	e0c080e7          	jalr	-500(ra) # 8000649c <_ZN7Console4putcEc>
    printString("Buffer deleted!\n");
    80002698:	00007517          	auipc	a0,0x7
    8000269c:	be050513          	addi	a0,a0,-1056 # 80009278 <_ZTV12ConsumerSync+0x120>
    800026a0:	00000097          	auipc	ra,0x0
    800026a4:	a0c080e7          	jalr	-1524(ra) # 800020ac <_Z11printStringPKc>
    while (getCnt()) {
    800026a8:	00048513          	mv	a0,s1
    800026ac:	00000097          	auipc	ra,0x0
    800026b0:	f40080e7          	jalr	-192(ra) # 800025ec <_ZN9BufferCPP6getCntEv>
    800026b4:	02050c63          	beqz	a0,800026ec <_ZN9BufferCPPD1Ev+0x78>
        char ch = buffer[head];
    800026b8:	0084b783          	ld	a5,8(s1)
    800026bc:	0104a703          	lw	a4,16(s1)
    800026c0:	00271713          	slli	a4,a4,0x2
    800026c4:	00e787b3          	add	a5,a5,a4
        Console::putc(ch);
    800026c8:	0007c503          	lbu	a0,0(a5)
    800026cc:	00004097          	auipc	ra,0x4
    800026d0:	dd0080e7          	jalr	-560(ra) # 8000649c <_ZN7Console4putcEc>
        head = (head + 1) % cap;
    800026d4:	0104a783          	lw	a5,16(s1)
    800026d8:	0017879b          	addiw	a5,a5,1
    800026dc:	0004a703          	lw	a4,0(s1)
    800026e0:	02e7e7bb          	remw	a5,a5,a4
    800026e4:	00f4a823          	sw	a5,16(s1)
    while (getCnt()) {
    800026e8:	fc1ff06f          	j	800026a8 <_ZN9BufferCPPD1Ev+0x34>
    Console::putc('!');
    800026ec:	02100513          	li	a0,33
    800026f0:	00004097          	auipc	ra,0x4
    800026f4:	dac080e7          	jalr	-596(ra) # 8000649c <_ZN7Console4putcEc>
    Console::putc('\n');
    800026f8:	00a00513          	li	a0,10
    800026fc:	00004097          	auipc	ra,0x4
    80002700:	da0080e7          	jalr	-608(ra) # 8000649c <_ZN7Console4putcEc>
    mem_free(buffer);
    80002704:	0084b503          	ld	a0,8(s1)
    80002708:	00002097          	auipc	ra,0x2
    8000270c:	71c080e7          	jalr	1820(ra) # 80004e24 <_Z8mem_freePv>
    delete itemAvailable;
    80002710:	0204b503          	ld	a0,32(s1)
    80002714:	00050863          	beqz	a0,80002724 <_ZN9BufferCPPD1Ev+0xb0>
    80002718:	00053783          	ld	a5,0(a0)
    8000271c:	0087b783          	ld	a5,8(a5)
    80002720:	000780e7          	jalr	a5
    delete spaceAvailable;
    80002724:	0184b503          	ld	a0,24(s1)
    80002728:	00050863          	beqz	a0,80002738 <_ZN9BufferCPPD1Ev+0xc4>
    8000272c:	00053783          	ld	a5,0(a0)
    80002730:	0087b783          	ld	a5,8(a5)
    80002734:	000780e7          	jalr	a5
    delete mutexTail;
    80002738:	0304b503          	ld	a0,48(s1)
    8000273c:	00050863          	beqz	a0,8000274c <_ZN9BufferCPPD1Ev+0xd8>
    80002740:	00053783          	ld	a5,0(a0)
    80002744:	0087b783          	ld	a5,8(a5)
    80002748:	000780e7          	jalr	a5
    delete mutexHead;
    8000274c:	0284b503          	ld	a0,40(s1)
    80002750:	00050863          	beqz	a0,80002760 <_ZN9BufferCPPD1Ev+0xec>
    80002754:	00053783          	ld	a5,0(a0)
    80002758:	0087b783          	ld	a5,8(a5)
    8000275c:	000780e7          	jalr	a5
}
    80002760:	01813083          	ld	ra,24(sp)
    80002764:	01013403          	ld	s0,16(sp)
    80002768:	00813483          	ld	s1,8(sp)
    8000276c:	02010113          	addi	sp,sp,32
    80002770:	00008067          	ret

0000000080002774 <_ZN6BufferC1Ei>:
#include "buffer.hpp"
#include "../h/syscall_c.hpp"

Buffer::Buffer(int _cap) : cap(_cap + 1), head(0), tail(0) {
    80002774:	fe010113          	addi	sp,sp,-32
    80002778:	00113c23          	sd	ra,24(sp)
    8000277c:	00813823          	sd	s0,16(sp)
    80002780:	00913423          	sd	s1,8(sp)
    80002784:	01213023          	sd	s2,0(sp)
    80002788:	02010413          	addi	s0,sp,32
    8000278c:	00050493          	mv	s1,a0
    80002790:	00058913          	mv	s2,a1
    80002794:	0015879b          	addiw	a5,a1,1
    80002798:	0007851b          	sext.w	a0,a5
    8000279c:	00f4a023          	sw	a5,0(s1)
    800027a0:	0004a823          	sw	zero,16(s1)
    800027a4:	0004aa23          	sw	zero,20(s1)
    buffer = (int *)mem_alloc(sizeof(int) * cap);
    800027a8:	00251513          	slli	a0,a0,0x2
    800027ac:	00002097          	auipc	ra,0x2
    800027b0:	630080e7          	jalr	1584(ra) # 80004ddc <_Z9mem_allocm>
    800027b4:	00a4b423          	sd	a0,8(s1)
    sem_open(&itemAvailable, 0);
    800027b8:	00000593          	li	a1,0
    800027bc:	02048513          	addi	a0,s1,32
    800027c0:	00002097          	auipc	ra,0x2
    800027c4:	798080e7          	jalr	1944(ra) # 80004f58 <_Z8sem_openPP11mySemaphorej>
    sem_open(&spaceAvailable, _cap);
    800027c8:	00090593          	mv	a1,s2
    800027cc:	01848513          	addi	a0,s1,24
    800027d0:	00002097          	auipc	ra,0x2
    800027d4:	788080e7          	jalr	1928(ra) # 80004f58 <_Z8sem_openPP11mySemaphorej>
    sem_open(&mutexHead, 1);
    800027d8:	00100593          	li	a1,1
    800027dc:	02848513          	addi	a0,s1,40
    800027e0:	00002097          	auipc	ra,0x2
    800027e4:	778080e7          	jalr	1912(ra) # 80004f58 <_Z8sem_openPP11mySemaphorej>
    sem_open(&mutexTail, 1);
    800027e8:	00100593          	li	a1,1
    800027ec:	03048513          	addi	a0,s1,48
    800027f0:	00002097          	auipc	ra,0x2
    800027f4:	768080e7          	jalr	1896(ra) # 80004f58 <_Z8sem_openPP11mySemaphorej>
}
    800027f8:	01813083          	ld	ra,24(sp)
    800027fc:	01013403          	ld	s0,16(sp)
    80002800:	00813483          	ld	s1,8(sp)
    80002804:	00013903          	ld	s2,0(sp)
    80002808:	02010113          	addi	sp,sp,32
    8000280c:	00008067          	ret

0000000080002810 <_ZN6Buffer3putEi>:
    sem_close(spaceAvailable);
    sem_close(mutexTail);
    sem_close(mutexHead);
}

void Buffer::put(int val) {
    80002810:	fe010113          	addi	sp,sp,-32
    80002814:	00113c23          	sd	ra,24(sp)
    80002818:	00813823          	sd	s0,16(sp)
    8000281c:	00913423          	sd	s1,8(sp)
    80002820:	01213023          	sd	s2,0(sp)
    80002824:	02010413          	addi	s0,sp,32
    80002828:	00050493          	mv	s1,a0
    8000282c:	00058913          	mv	s2,a1
    sem_wait(spaceAvailable);
    80002830:	01853503          	ld	a0,24(a0)
    80002834:	00002097          	auipc	ra,0x2
    80002838:	7a0080e7          	jalr	1952(ra) # 80004fd4 <_Z8sem_waitP11mySemaphore>

    sem_wait(mutexTail);
    8000283c:	0304b503          	ld	a0,48(s1)
    80002840:	00002097          	auipc	ra,0x2
    80002844:	794080e7          	jalr	1940(ra) # 80004fd4 <_Z8sem_waitP11mySemaphore>
    buffer[tail] = val;
    80002848:	0084b783          	ld	a5,8(s1)
    8000284c:	0144a703          	lw	a4,20(s1)
    80002850:	00271713          	slli	a4,a4,0x2
    80002854:	00e787b3          	add	a5,a5,a4
    80002858:	0127a023          	sw	s2,0(a5)
    tail = (tail + 1) % cap;
    8000285c:	0144a783          	lw	a5,20(s1)
    80002860:	0017879b          	addiw	a5,a5,1
    80002864:	0004a703          	lw	a4,0(s1)
    80002868:	02e7e7bb          	remw	a5,a5,a4
    8000286c:	00f4aa23          	sw	a5,20(s1)
    sem_signal(mutexTail);
    80002870:	0304b503          	ld	a0,48(s1)
    80002874:	00002097          	auipc	ra,0x2
    80002878:	798080e7          	jalr	1944(ra) # 8000500c <_Z10sem_signalP11mySemaphore>

    sem_signal(itemAvailable);
    8000287c:	0204b503          	ld	a0,32(s1)
    80002880:	00002097          	auipc	ra,0x2
    80002884:	78c080e7          	jalr	1932(ra) # 8000500c <_Z10sem_signalP11mySemaphore>

}
    80002888:	01813083          	ld	ra,24(sp)
    8000288c:	01013403          	ld	s0,16(sp)
    80002890:	00813483          	ld	s1,8(sp)
    80002894:	00013903          	ld	s2,0(sp)
    80002898:	02010113          	addi	sp,sp,32
    8000289c:	00008067          	ret

00000000800028a0 <_ZN6Buffer3getEv>:

int Buffer::get() {
    800028a0:	fe010113          	addi	sp,sp,-32
    800028a4:	00113c23          	sd	ra,24(sp)
    800028a8:	00813823          	sd	s0,16(sp)
    800028ac:	00913423          	sd	s1,8(sp)
    800028b0:	01213023          	sd	s2,0(sp)
    800028b4:	02010413          	addi	s0,sp,32
    800028b8:	00050493          	mv	s1,a0
    sem_wait(itemAvailable);
    800028bc:	02053503          	ld	a0,32(a0)
    800028c0:	00002097          	auipc	ra,0x2
    800028c4:	714080e7          	jalr	1812(ra) # 80004fd4 <_Z8sem_waitP11mySemaphore>

    sem_wait(mutexHead);
    800028c8:	0284b503          	ld	a0,40(s1)
    800028cc:	00002097          	auipc	ra,0x2
    800028d0:	708080e7          	jalr	1800(ra) # 80004fd4 <_Z8sem_waitP11mySemaphore>

    int ret = buffer[head];
    800028d4:	0084b703          	ld	a4,8(s1)
    800028d8:	0104a783          	lw	a5,16(s1)
    800028dc:	00279693          	slli	a3,a5,0x2
    800028e0:	00d70733          	add	a4,a4,a3
    800028e4:	00072903          	lw	s2,0(a4)
    head = (head + 1) % cap;
    800028e8:	0017879b          	addiw	a5,a5,1
    800028ec:	0004a703          	lw	a4,0(s1)
    800028f0:	02e7e7bb          	remw	a5,a5,a4
    800028f4:	00f4a823          	sw	a5,16(s1)
    sem_signal(mutexHead);
    800028f8:	0284b503          	ld	a0,40(s1)
    800028fc:	00002097          	auipc	ra,0x2
    80002900:	710080e7          	jalr	1808(ra) # 8000500c <_Z10sem_signalP11mySemaphore>

    sem_signal(spaceAvailable);
    80002904:	0184b503          	ld	a0,24(s1)
    80002908:	00002097          	auipc	ra,0x2
    8000290c:	704080e7          	jalr	1796(ra) # 8000500c <_Z10sem_signalP11mySemaphore>

    return ret;
}
    80002910:	00090513          	mv	a0,s2
    80002914:	01813083          	ld	ra,24(sp)
    80002918:	01013403          	ld	s0,16(sp)
    8000291c:	00813483          	ld	s1,8(sp)
    80002920:	00013903          	ld	s2,0(sp)
    80002924:	02010113          	addi	sp,sp,32
    80002928:	00008067          	ret

000000008000292c <_ZN6Buffer6getCntEv>:

int Buffer::getCnt() {
    8000292c:	fe010113          	addi	sp,sp,-32
    80002930:	00113c23          	sd	ra,24(sp)
    80002934:	00813823          	sd	s0,16(sp)
    80002938:	00913423          	sd	s1,8(sp)
    8000293c:	01213023          	sd	s2,0(sp)
    80002940:	02010413          	addi	s0,sp,32
    80002944:	00050493          	mv	s1,a0
    int ret;

    sem_wait(mutexHead);
    80002948:	02853503          	ld	a0,40(a0)
    8000294c:	00002097          	auipc	ra,0x2
    80002950:	688080e7          	jalr	1672(ra) # 80004fd4 <_Z8sem_waitP11mySemaphore>
    sem_wait(mutexTail);
    80002954:	0304b503          	ld	a0,48(s1)
    80002958:	00002097          	auipc	ra,0x2
    8000295c:	67c080e7          	jalr	1660(ra) # 80004fd4 <_Z8sem_waitP11mySemaphore>

    if (tail >= head) {
    80002960:	0144a783          	lw	a5,20(s1)
    80002964:	0104a903          	lw	s2,16(s1)
    80002968:	0327ce63          	blt	a5,s2,800029a4 <_ZN6Buffer6getCntEv+0x78>
        ret = tail - head;
    8000296c:	4127893b          	subw	s2,a5,s2
    } else {
        ret = cap - head + tail;
    }

    sem_signal(mutexTail);
    80002970:	0304b503          	ld	a0,48(s1)
    80002974:	00002097          	auipc	ra,0x2
    80002978:	698080e7          	jalr	1688(ra) # 8000500c <_Z10sem_signalP11mySemaphore>
    sem_signal(mutexHead);
    8000297c:	0284b503          	ld	a0,40(s1)
    80002980:	00002097          	auipc	ra,0x2
    80002984:	68c080e7          	jalr	1676(ra) # 8000500c <_Z10sem_signalP11mySemaphore>

    return ret;
}
    80002988:	00090513          	mv	a0,s2
    8000298c:	01813083          	ld	ra,24(sp)
    80002990:	01013403          	ld	s0,16(sp)
    80002994:	00813483          	ld	s1,8(sp)
    80002998:	00013903          	ld	s2,0(sp)
    8000299c:	02010113          	addi	sp,sp,32
    800029a0:	00008067          	ret
        ret = cap - head + tail;
    800029a4:	0004a703          	lw	a4,0(s1)
    800029a8:	4127093b          	subw	s2,a4,s2
    800029ac:	00f9093b          	addw	s2,s2,a5
    800029b0:	fc1ff06f          	j	80002970 <_ZN6Buffer6getCntEv+0x44>

00000000800029b4 <_ZN6BufferD1Ev>:
Buffer::~Buffer() {
    800029b4:	fe010113          	addi	sp,sp,-32
    800029b8:	00113c23          	sd	ra,24(sp)
    800029bc:	00813823          	sd	s0,16(sp)
    800029c0:	00913423          	sd	s1,8(sp)
    800029c4:	02010413          	addi	s0,sp,32
    800029c8:	00050493          	mv	s1,a0
    putc('\n');
    800029cc:	00a00513          	li	a0,10
    800029d0:	00002097          	auipc	ra,0x2
    800029d4:	760080e7          	jalr	1888(ra) # 80005130 <_Z4putcc>
    printString("Buffer deleted!\n");
    800029d8:	00007517          	auipc	a0,0x7
    800029dc:	8a050513          	addi	a0,a0,-1888 # 80009278 <_ZTV12ConsumerSync+0x120>
    800029e0:	fffff097          	auipc	ra,0xfffff
    800029e4:	6cc080e7          	jalr	1740(ra) # 800020ac <_Z11printStringPKc>
    while (getCnt() > 0) {
    800029e8:	00048513          	mv	a0,s1
    800029ec:	00000097          	auipc	ra,0x0
    800029f0:	f40080e7          	jalr	-192(ra) # 8000292c <_ZN6Buffer6getCntEv>
    800029f4:	02a05c63          	blez	a0,80002a2c <_ZN6BufferD1Ev+0x78>
        char ch = buffer[head];
    800029f8:	0084b783          	ld	a5,8(s1)
    800029fc:	0104a703          	lw	a4,16(s1)
    80002a00:	00271713          	slli	a4,a4,0x2
    80002a04:	00e787b3          	add	a5,a5,a4
        putc(ch);
    80002a08:	0007c503          	lbu	a0,0(a5)
    80002a0c:	00002097          	auipc	ra,0x2
    80002a10:	724080e7          	jalr	1828(ra) # 80005130 <_Z4putcc>
        head = (head + 1) % cap;
    80002a14:	0104a783          	lw	a5,16(s1)
    80002a18:	0017879b          	addiw	a5,a5,1
    80002a1c:	0004a703          	lw	a4,0(s1)
    80002a20:	02e7e7bb          	remw	a5,a5,a4
    80002a24:	00f4a823          	sw	a5,16(s1)
    while (getCnt() > 0) {
    80002a28:	fc1ff06f          	j	800029e8 <_ZN6BufferD1Ev+0x34>
    putc('!');
    80002a2c:	02100513          	li	a0,33
    80002a30:	00002097          	auipc	ra,0x2
    80002a34:	700080e7          	jalr	1792(ra) # 80005130 <_Z4putcc>
    putc('\n');
    80002a38:	00a00513          	li	a0,10
    80002a3c:	00002097          	auipc	ra,0x2
    80002a40:	6f4080e7          	jalr	1780(ra) # 80005130 <_Z4putcc>
    mem_free(buffer);
    80002a44:	0084b503          	ld	a0,8(s1)
    80002a48:	00002097          	auipc	ra,0x2
    80002a4c:	3dc080e7          	jalr	988(ra) # 80004e24 <_Z8mem_freePv>
    sem_close(itemAvailable);
    80002a50:	0204b503          	ld	a0,32(s1)
    80002a54:	00002097          	auipc	ra,0x2
    80002a58:	548080e7          	jalr	1352(ra) # 80004f9c <_Z9sem_closeP11mySemaphore>
    sem_close(spaceAvailable);
    80002a5c:	0184b503          	ld	a0,24(s1)
    80002a60:	00002097          	auipc	ra,0x2
    80002a64:	53c080e7          	jalr	1340(ra) # 80004f9c <_Z9sem_closeP11mySemaphore>
    sem_close(mutexTail);
    80002a68:	0304b503          	ld	a0,48(s1)
    80002a6c:	00002097          	auipc	ra,0x2
    80002a70:	530080e7          	jalr	1328(ra) # 80004f9c <_Z9sem_closeP11mySemaphore>
    sem_close(mutexHead);
    80002a74:	0284b503          	ld	a0,40(s1)
    80002a78:	00002097          	auipc	ra,0x2
    80002a7c:	524080e7          	jalr	1316(ra) # 80004f9c <_Z9sem_closeP11mySemaphore>
}
    80002a80:	01813083          	ld	ra,24(sp)
    80002a84:	01013403          	ld	s0,16(sp)
    80002a88:	00813483          	ld	s1,8(sp)
    80002a8c:	02010113          	addi	sp,sp,32
    80002a90:	00008067          	ret

0000000080002a94 <_Z8userMainv>:
#include "System_Mode_test.hpp"
#include "../h/syscall_c.hpp"

#endif

void userMain() {
    80002a94:	fe010113          	addi	sp,sp,-32
    80002a98:	00113c23          	sd	ra,24(sp)
    80002a9c:	00813823          	sd	s0,16(sp)
    80002aa0:	00913423          	sd	s1,8(sp)
    80002aa4:	02010413          	addi	s0,sp,32
    printString("Unesite broj testa? [1-7]\n");
    80002aa8:	00006517          	auipc	a0,0x6
    80002aac:	7e850513          	addi	a0,a0,2024 # 80009290 <_ZTV12ConsumerSync+0x138>
    80002ab0:	fffff097          	auipc	ra,0xfffff
    80002ab4:	5fc080e7          	jalr	1532(ra) # 800020ac <_Z11printStringPKc>
    int test = getc() - '0';
    80002ab8:	00002097          	auipc	ra,0x2
    80002abc:	644080e7          	jalr	1604(ra) # 800050fc <_Z4getcv>
    80002ac0:	fd05049b          	addiw	s1,a0,-48
    getc(); // Enter posle broja
    80002ac4:	00002097          	auipc	ra,0x2
    80002ac8:	638080e7          	jalr	1592(ra) # 800050fc <_Z4getcv>
        if (LEVEL_4_IMPLEMENTED == 0) {
            printString("Nije navedeno da je zadatak 4 implementiran\n");
            return;
        }
    }
    switch (test) {
    80002acc:	00700793          	li	a5,7
    80002ad0:	1097e263          	bltu	a5,s1,80002bd4 <_Z8userMainv+0x140>
    80002ad4:	00249493          	slli	s1,s1,0x2
    80002ad8:	00007717          	auipc	a4,0x7
    80002adc:	a1070713          	addi	a4,a4,-1520 # 800094e8 <_ZTV12ConsumerSync+0x390>
    80002ae0:	00e484b3          	add	s1,s1,a4
    80002ae4:	0004a783          	lw	a5,0(s1)
    80002ae8:	00e787b3          	add	a5,a5,a4
    80002aec:	00078067          	jr	a5
        case 1:
#if LEVEL_2_IMPLEMENTED == 1
            Threads_C_API_test();
    80002af0:	fffff097          	auipc	ra,0xfffff
    80002af4:	4c0080e7          	jalr	1216(ra) # 80001fb0 <_Z18Threads_C_API_testv>
            printString("TEST 1 (zadatak 2, niti C API i sinhrona promena konteksta)\n");
    80002af8:	00006517          	auipc	a0,0x6
    80002afc:	7b850513          	addi	a0,a0,1976 # 800092b0 <_ZTV12ConsumerSync+0x158>
    80002b00:	fffff097          	auipc	ra,0xfffff
    80002b04:	5ac080e7          	jalr	1452(ra) # 800020ac <_Z11printStringPKc>
#endif
            break;
        default:
            printString("Niste uneli odgovarajuci broj za test\n");
    }
    80002b08:	01813083          	ld	ra,24(sp)
    80002b0c:	01013403          	ld	s0,16(sp)
    80002b10:	00813483          	ld	s1,8(sp)
    80002b14:	02010113          	addi	sp,sp,32
    80002b18:	00008067          	ret
            Threads_CPP_API_test();
    80002b1c:	00002097          	auipc	ra,0x2
    80002b20:	92c080e7          	jalr	-1748(ra) # 80004448 <_Z20Threads_CPP_API_testv>
            printString("TEST 2 (zadatak 2., niti CPP API i sinhrona promena konteksta)\n");
    80002b24:	00006517          	auipc	a0,0x6
    80002b28:	7cc50513          	addi	a0,a0,1996 # 800092f0 <_ZTV12ConsumerSync+0x198>
    80002b2c:	fffff097          	auipc	ra,0xfffff
    80002b30:	580080e7          	jalr	1408(ra) # 800020ac <_Z11printStringPKc>
            break;
    80002b34:	fd5ff06f          	j	80002b08 <_Z8userMainv+0x74>
            producerConsumer_C_API();
    80002b38:	00000097          	auipc	ra,0x0
    80002b3c:	2d4080e7          	jalr	724(ra) # 80002e0c <_Z22producerConsumer_C_APIv>
            printString("TEST 3 (zadatak 3., kompletan C API sa semaforima, sinhrona promena konteksta)\n");
    80002b40:	00006517          	auipc	a0,0x6
    80002b44:	7f050513          	addi	a0,a0,2032 # 80009330 <_ZTV12ConsumerSync+0x1d8>
    80002b48:	fffff097          	auipc	ra,0xfffff
    80002b4c:	564080e7          	jalr	1380(ra) # 800020ac <_Z11printStringPKc>
            break;
    80002b50:	fb9ff06f          	j	80002b08 <_Z8userMainv+0x74>
            producerConsumer_CPP_Sync_API();
    80002b54:	fffff097          	auipc	ra,0xfffff
    80002b58:	940080e7          	jalr	-1728(ra) # 80001494 <_Z29producerConsumer_CPP_Sync_APIv>
            printString("TEST 4 (zadatak 3., kompletan CPP API sa semaforima, sinhrona promena konteksta)\n");
    80002b5c:	00007517          	auipc	a0,0x7
    80002b60:	82450513          	addi	a0,a0,-2012 # 80009380 <_ZTV12ConsumerSync+0x228>
    80002b64:	fffff097          	auipc	ra,0xfffff
    80002b68:	548080e7          	jalr	1352(ra) # 800020ac <_Z11printStringPKc>
            break;
    80002b6c:	f9dff06f          	j	80002b08 <_Z8userMainv+0x74>
            testSleeping();
    80002b70:	00000097          	auipc	ra,0x0
    80002b74:	60c080e7          	jalr	1548(ra) # 8000317c <_Z12testSleepingv>
            printString("TEST 5 (zadatak 4., thread_sleep test C API)\n");
    80002b78:	00007517          	auipc	a0,0x7
    80002b7c:	86050513          	addi	a0,a0,-1952 # 800093d8 <_ZTV12ConsumerSync+0x280>
    80002b80:	fffff097          	auipc	ra,0xfffff
    80002b84:	52c080e7          	jalr	1324(ra) # 800020ac <_Z11printStringPKc>
            break;
    80002b88:	f81ff06f          	j	80002b08 <_Z8userMainv+0x74>
            testConsumerProducer();
    80002b8c:	00000097          	auipc	ra,0x0
    80002b90:	678080e7          	jalr	1656(ra) # 80003204 <_Z20testConsumerProducerv>
            printString("TEST 6 (zadatak 4. CPP API i asinhrona promena konteksta)\n");
    80002b94:	00007517          	auipc	a0,0x7
    80002b98:	87450513          	addi	a0,a0,-1932 # 80009408 <_ZTV12ConsumerSync+0x2b0>
    80002b9c:	fffff097          	auipc	ra,0xfffff
    80002ba0:	510080e7          	jalr	1296(ra) # 800020ac <_Z11printStringPKc>
            break;
    80002ba4:	f65ff06f          	j	80002b08 <_Z8userMainv+0x74>
            System_Mode_test();
    80002ba8:	00001097          	auipc	ra,0x1
    80002bac:	2c8080e7          	jalr	712(ra) # 80003e70 <_Z16System_Mode_testv>
            printString("Test se nije uspesno zavrsio\n");
    80002bb0:	00007517          	auipc	a0,0x7
    80002bb4:	89850513          	addi	a0,a0,-1896 # 80009448 <_ZTV12ConsumerSync+0x2f0>
    80002bb8:	fffff097          	auipc	ra,0xfffff
    80002bbc:	4f4080e7          	jalr	1268(ra) # 800020ac <_Z11printStringPKc>
            printString("TEST 7 (zadatak 2., testiranje da li se korisnicki kod izvrsava u korisnickom rezimu)\n");
    80002bc0:	00007517          	auipc	a0,0x7
    80002bc4:	8a850513          	addi	a0,a0,-1880 # 80009468 <_ZTV12ConsumerSync+0x310>
    80002bc8:	fffff097          	auipc	ra,0xfffff
    80002bcc:	4e4080e7          	jalr	1252(ra) # 800020ac <_Z11printStringPKc>
            break;
    80002bd0:	f39ff06f          	j	80002b08 <_Z8userMainv+0x74>
            printString("Niste uneli odgovarajuci broj za test\n");
    80002bd4:	00007517          	auipc	a0,0x7
    80002bd8:	8ec50513          	addi	a0,a0,-1812 # 800094c0 <_ZTV12ConsumerSync+0x368>
    80002bdc:	fffff097          	auipc	ra,0xfffff
    80002be0:	4d0080e7          	jalr	1232(ra) # 800020ac <_Z11printStringPKc>
    80002be4:	f25ff06f          	j	80002b08 <_Z8userMainv+0x74>

0000000080002be8 <_ZL16producerKeyboardPv>:
    sem_t wait;
};

static volatile int threadEnd = 0;

static void producerKeyboard(void *arg) {
    80002be8:	fe010113          	addi	sp,sp,-32
    80002bec:	00113c23          	sd	ra,24(sp)
    80002bf0:	00813823          	sd	s0,16(sp)
    80002bf4:	00913423          	sd	s1,8(sp)
    80002bf8:	01213023          	sd	s2,0(sp)
    80002bfc:	02010413          	addi	s0,sp,32
    80002c00:	00050493          	mv	s1,a0
    struct thread_data *data = (struct thread_data *) arg;

    int key;
    int i = 0;
    80002c04:	00000913          	li	s2,0
    80002c08:	00c0006f          	j	80002c14 <_ZL16producerKeyboardPv+0x2c>
    while ((key = getc()) != 'w') {
        data->buffer->put(key);
        i++;

        if (i % (10 * data->id) == 0) {
            thread_dispatch();
    80002c0c:	00002097          	auipc	ra,0x2
    80002c10:	324080e7          	jalr	804(ra) # 80004f30 <_Z15thread_dispatchv>
    while ((key = getc()) != 'w') {
    80002c14:	00002097          	auipc	ra,0x2
    80002c18:	4e8080e7          	jalr	1256(ra) # 800050fc <_Z4getcv>
    80002c1c:	0005059b          	sext.w	a1,a0
    80002c20:	07700793          	li	a5,119
    80002c24:	02f58a63          	beq	a1,a5,80002c58 <_ZL16producerKeyboardPv+0x70>
        data->buffer->put(key);
    80002c28:	0084b503          	ld	a0,8(s1)
    80002c2c:	00000097          	auipc	ra,0x0
    80002c30:	be4080e7          	jalr	-1052(ra) # 80002810 <_ZN6Buffer3putEi>
        i++;
    80002c34:	0019071b          	addiw	a4,s2,1
    80002c38:	0007091b          	sext.w	s2,a4
        if (i % (10 * data->id) == 0) {
    80002c3c:	0004a683          	lw	a3,0(s1)
    80002c40:	0026979b          	slliw	a5,a3,0x2
    80002c44:	00d787bb          	addw	a5,a5,a3
    80002c48:	0017979b          	slliw	a5,a5,0x1
    80002c4c:	02f767bb          	remw	a5,a4,a5
    80002c50:	fc0792e3          	bnez	a5,80002c14 <_ZL16producerKeyboardPv+0x2c>
    80002c54:	fb9ff06f          	j	80002c0c <_ZL16producerKeyboardPv+0x24>
        }
    }

    threadEnd = 1;
    80002c58:	00100793          	li	a5,1
    80002c5c:	00009717          	auipc	a4,0x9
    80002c60:	02f72223          	sw	a5,36(a4) # 8000bc80 <_ZL9threadEnd>
    data->buffer->put('!');
    80002c64:	02100593          	li	a1,33
    80002c68:	0084b503          	ld	a0,8(s1)
    80002c6c:	00000097          	auipc	ra,0x0
    80002c70:	ba4080e7          	jalr	-1116(ra) # 80002810 <_ZN6Buffer3putEi>

    sem_signal(data->wait);
    80002c74:	0104b503          	ld	a0,16(s1)
    80002c78:	00002097          	auipc	ra,0x2
    80002c7c:	394080e7          	jalr	916(ra) # 8000500c <_Z10sem_signalP11mySemaphore>
}
    80002c80:	01813083          	ld	ra,24(sp)
    80002c84:	01013403          	ld	s0,16(sp)
    80002c88:	00813483          	ld	s1,8(sp)
    80002c8c:	00013903          	ld	s2,0(sp)
    80002c90:	02010113          	addi	sp,sp,32
    80002c94:	00008067          	ret

0000000080002c98 <_ZL8producerPv>:

static void producer(void *arg) {
    80002c98:	fe010113          	addi	sp,sp,-32
    80002c9c:	00113c23          	sd	ra,24(sp)
    80002ca0:	00813823          	sd	s0,16(sp)
    80002ca4:	00913423          	sd	s1,8(sp)
    80002ca8:	01213023          	sd	s2,0(sp)
    80002cac:	02010413          	addi	s0,sp,32
    80002cb0:	00050493          	mv	s1,a0
    struct thread_data *data = (struct thread_data *) arg;

    int i = 0;
    80002cb4:	00000913          	li	s2,0
    80002cb8:	00c0006f          	j	80002cc4 <_ZL8producerPv+0x2c>
    while (!threadEnd) {
        data->buffer->put(data->id + '0');
        i++;
        if (i % (10 * data->id) == 0) {
            thread_dispatch();
    80002cbc:	00002097          	auipc	ra,0x2
    80002cc0:	274080e7          	jalr	628(ra) # 80004f30 <_Z15thread_dispatchv>
    while (!threadEnd) {
    80002cc4:	00009797          	auipc	a5,0x9
    80002cc8:	fbc7a783          	lw	a5,-68(a5) # 8000bc80 <_ZL9threadEnd>
    80002ccc:	02079e63          	bnez	a5,80002d08 <_ZL8producerPv+0x70>
        data->buffer->put(data->id + '0');
    80002cd0:	0004a583          	lw	a1,0(s1)
    80002cd4:	0305859b          	addiw	a1,a1,48
    80002cd8:	0084b503          	ld	a0,8(s1)
    80002cdc:	00000097          	auipc	ra,0x0
    80002ce0:	b34080e7          	jalr	-1228(ra) # 80002810 <_ZN6Buffer3putEi>
        i++;
    80002ce4:	0019071b          	addiw	a4,s2,1
    80002ce8:	0007091b          	sext.w	s2,a4
        if (i % (10 * data->id) == 0) {
    80002cec:	0004a683          	lw	a3,0(s1)
    80002cf0:	0026979b          	slliw	a5,a3,0x2
    80002cf4:	00d787bb          	addw	a5,a5,a3
    80002cf8:	0017979b          	slliw	a5,a5,0x1
    80002cfc:	02f767bb          	remw	a5,a4,a5
    80002d00:	fc0792e3          	bnez	a5,80002cc4 <_ZL8producerPv+0x2c>
    80002d04:	fb9ff06f          	j	80002cbc <_ZL8producerPv+0x24>
        }
    }

    sem_signal(data->wait);
    80002d08:	0104b503          	ld	a0,16(s1)
    80002d0c:	00002097          	auipc	ra,0x2
    80002d10:	300080e7          	jalr	768(ra) # 8000500c <_Z10sem_signalP11mySemaphore>
}
    80002d14:	01813083          	ld	ra,24(sp)
    80002d18:	01013403          	ld	s0,16(sp)
    80002d1c:	00813483          	ld	s1,8(sp)
    80002d20:	00013903          	ld	s2,0(sp)
    80002d24:	02010113          	addi	sp,sp,32
    80002d28:	00008067          	ret

0000000080002d2c <_ZL8consumerPv>:

static void consumer(void *arg) {
    80002d2c:	fd010113          	addi	sp,sp,-48
    80002d30:	02113423          	sd	ra,40(sp)
    80002d34:	02813023          	sd	s0,32(sp)
    80002d38:	00913c23          	sd	s1,24(sp)
    80002d3c:	01213823          	sd	s2,16(sp)
    80002d40:	01313423          	sd	s3,8(sp)
    80002d44:	03010413          	addi	s0,sp,48
    80002d48:	00050913          	mv	s2,a0
    struct thread_data *data = (struct thread_data *) arg;

    int i = 0;
    80002d4c:	00000993          	li	s3,0
    80002d50:	01c0006f          	j	80002d6c <_ZL8consumerPv+0x40>
        i++;

        putc(key);

        if (i % (5 * data->id) == 0) {
            thread_dispatch();
    80002d54:	00002097          	auipc	ra,0x2
    80002d58:	1dc080e7          	jalr	476(ra) # 80004f30 <_Z15thread_dispatchv>
    80002d5c:	0500006f          	j	80002dac <_ZL8consumerPv+0x80>
        }

        if (i % 80 == 0) {
            putc('\n');
    80002d60:	00a00513          	li	a0,10
    80002d64:	00002097          	auipc	ra,0x2
    80002d68:	3cc080e7          	jalr	972(ra) # 80005130 <_Z4putcc>
    while (!threadEnd) {
    80002d6c:	00009797          	auipc	a5,0x9
    80002d70:	f147a783          	lw	a5,-236(a5) # 8000bc80 <_ZL9threadEnd>
    80002d74:	06079063          	bnez	a5,80002dd4 <_ZL8consumerPv+0xa8>
        int key = data->buffer->get();
    80002d78:	00893503          	ld	a0,8(s2)
    80002d7c:	00000097          	auipc	ra,0x0
    80002d80:	b24080e7          	jalr	-1244(ra) # 800028a0 <_ZN6Buffer3getEv>
        i++;
    80002d84:	0019849b          	addiw	s1,s3,1
    80002d88:	0004899b          	sext.w	s3,s1
        putc(key);
    80002d8c:	0ff57513          	andi	a0,a0,255
    80002d90:	00002097          	auipc	ra,0x2
    80002d94:	3a0080e7          	jalr	928(ra) # 80005130 <_Z4putcc>
        if (i % (5 * data->id) == 0) {
    80002d98:	00092703          	lw	a4,0(s2)
    80002d9c:	0027179b          	slliw	a5,a4,0x2
    80002da0:	00e787bb          	addw	a5,a5,a4
    80002da4:	02f4e7bb          	remw	a5,s1,a5
    80002da8:	fa0786e3          	beqz	a5,80002d54 <_ZL8consumerPv+0x28>
        if (i % 80 == 0) {
    80002dac:	05000793          	li	a5,80
    80002db0:	02f4e4bb          	remw	s1,s1,a5
    80002db4:	fa049ce3          	bnez	s1,80002d6c <_ZL8consumerPv+0x40>
    80002db8:	fa9ff06f          	j	80002d60 <_ZL8consumerPv+0x34>
        }
    }

    while (data->buffer->getCnt() > 0) {
        int key = data->buffer->get();
    80002dbc:	00893503          	ld	a0,8(s2)
    80002dc0:	00000097          	auipc	ra,0x0
    80002dc4:	ae0080e7          	jalr	-1312(ra) # 800028a0 <_ZN6Buffer3getEv>
        putc(key);
    80002dc8:	0ff57513          	andi	a0,a0,255
    80002dcc:	00002097          	auipc	ra,0x2
    80002dd0:	364080e7          	jalr	868(ra) # 80005130 <_Z4putcc>
    while (data->buffer->getCnt() > 0) {
    80002dd4:	00893503          	ld	a0,8(s2)
    80002dd8:	00000097          	auipc	ra,0x0
    80002ddc:	b54080e7          	jalr	-1196(ra) # 8000292c <_ZN6Buffer6getCntEv>
    80002de0:	fca04ee3          	bgtz	a0,80002dbc <_ZL8consumerPv+0x90>
    }

    sem_signal(data->wait);
    80002de4:	01093503          	ld	a0,16(s2)
    80002de8:	00002097          	auipc	ra,0x2
    80002dec:	224080e7          	jalr	548(ra) # 8000500c <_Z10sem_signalP11mySemaphore>
}
    80002df0:	02813083          	ld	ra,40(sp)
    80002df4:	02013403          	ld	s0,32(sp)
    80002df8:	01813483          	ld	s1,24(sp)
    80002dfc:	01013903          	ld	s2,16(sp)
    80002e00:	00813983          	ld	s3,8(sp)
    80002e04:	03010113          	addi	sp,sp,48
    80002e08:	00008067          	ret

0000000080002e0c <_Z22producerConsumer_C_APIv>:

void producerConsumer_C_API() {
    80002e0c:	f9010113          	addi	sp,sp,-112
    80002e10:	06113423          	sd	ra,104(sp)
    80002e14:	06813023          	sd	s0,96(sp)
    80002e18:	04913c23          	sd	s1,88(sp)
    80002e1c:	05213823          	sd	s2,80(sp)
    80002e20:	05313423          	sd	s3,72(sp)
    80002e24:	05413023          	sd	s4,64(sp)
    80002e28:	03513c23          	sd	s5,56(sp)
    80002e2c:	03613823          	sd	s6,48(sp)
    80002e30:	07010413          	addi	s0,sp,112
        sem_wait(waitForAll);
    }

    sem_close(waitForAll);

    delete buffer;
    80002e34:	00010b13          	mv	s6,sp
    printString("Unesite broj proizvodjaca?\n");
    80002e38:	00006517          	auipc	a0,0x6
    80002e3c:	1e850513          	addi	a0,a0,488 # 80009020 <CONSOLE_STATUS+0x10>
    80002e40:	fffff097          	auipc	ra,0xfffff
    80002e44:	26c080e7          	jalr	620(ra) # 800020ac <_Z11printStringPKc>
    getString(input, 30);
    80002e48:	01e00593          	li	a1,30
    80002e4c:	fa040513          	addi	a0,s0,-96
    80002e50:	fffff097          	auipc	ra,0xfffff
    80002e54:	2e4080e7          	jalr	740(ra) # 80002134 <_Z9getStringPci>
    threadNum = stringToInt(input);
    80002e58:	fa040513          	addi	a0,s0,-96
    80002e5c:	fffff097          	auipc	ra,0xfffff
    80002e60:	3b0080e7          	jalr	944(ra) # 8000220c <_Z11stringToIntPKc>
    80002e64:	00050913          	mv	s2,a0
    printString("Unesite velicinu bafera?\n");
    80002e68:	00006517          	auipc	a0,0x6
    80002e6c:	1d850513          	addi	a0,a0,472 # 80009040 <CONSOLE_STATUS+0x30>
    80002e70:	fffff097          	auipc	ra,0xfffff
    80002e74:	23c080e7          	jalr	572(ra) # 800020ac <_Z11printStringPKc>
    getString(input, 30);
    80002e78:	01e00593          	li	a1,30
    80002e7c:	fa040513          	addi	a0,s0,-96
    80002e80:	fffff097          	auipc	ra,0xfffff
    80002e84:	2b4080e7          	jalr	692(ra) # 80002134 <_Z9getStringPci>
    n = stringToInt(input);
    80002e88:	fa040513          	addi	a0,s0,-96
    80002e8c:	fffff097          	auipc	ra,0xfffff
    80002e90:	380080e7          	jalr	896(ra) # 8000220c <_Z11stringToIntPKc>
    80002e94:	00050493          	mv	s1,a0
    printString("Broj proizvodjaca "); printInt(threadNum);
    80002e98:	00006517          	auipc	a0,0x6
    80002e9c:	1c850513          	addi	a0,a0,456 # 80009060 <CONSOLE_STATUS+0x50>
    80002ea0:	fffff097          	auipc	ra,0xfffff
    80002ea4:	20c080e7          	jalr	524(ra) # 800020ac <_Z11printStringPKc>
    80002ea8:	00000613          	li	a2,0
    80002eac:	00a00593          	li	a1,10
    80002eb0:	00090513          	mv	a0,s2
    80002eb4:	fffff097          	auipc	ra,0xfffff
    80002eb8:	3a8080e7          	jalr	936(ra) # 8000225c <_Z8printIntiii>
    printString(" i velicina bafera "); printInt(n);
    80002ebc:	00006517          	auipc	a0,0x6
    80002ec0:	1bc50513          	addi	a0,a0,444 # 80009078 <CONSOLE_STATUS+0x68>
    80002ec4:	fffff097          	auipc	ra,0xfffff
    80002ec8:	1e8080e7          	jalr	488(ra) # 800020ac <_Z11printStringPKc>
    80002ecc:	00000613          	li	a2,0
    80002ed0:	00a00593          	li	a1,10
    80002ed4:	00048513          	mv	a0,s1
    80002ed8:	fffff097          	auipc	ra,0xfffff
    80002edc:	384080e7          	jalr	900(ra) # 8000225c <_Z8printIntiii>
    printString(".\n");
    80002ee0:	00006517          	auipc	a0,0x6
    80002ee4:	1b050513          	addi	a0,a0,432 # 80009090 <CONSOLE_STATUS+0x80>
    80002ee8:	fffff097          	auipc	ra,0xfffff
    80002eec:	1c4080e7          	jalr	452(ra) # 800020ac <_Z11printStringPKc>
    if(threadNum > n) {
    80002ef0:	0324c463          	blt	s1,s2,80002f18 <_Z22producerConsumer_C_APIv+0x10c>
    } else if (threadNum < 1) {
    80002ef4:	03205c63          	blez	s2,80002f2c <_Z22producerConsumer_C_APIv+0x120>
    Buffer *buffer = new Buffer(n);
    80002ef8:	03800513          	li	a0,56
    80002efc:	00003097          	auipc	ra,0x3
    80002f00:	11c080e7          	jalr	284(ra) # 80006018 <_Znwm>
    80002f04:	00050a13          	mv	s4,a0
    80002f08:	00048593          	mv	a1,s1
    80002f0c:	00000097          	auipc	ra,0x0
    80002f10:	868080e7          	jalr	-1944(ra) # 80002774 <_ZN6BufferC1Ei>
    80002f14:	0300006f          	j	80002f44 <_Z22producerConsumer_C_APIv+0x138>
        printString("Broj proizvodjaca ne sme biti manji od velicine bafera!\n");
    80002f18:	00006517          	auipc	a0,0x6
    80002f1c:	18050513          	addi	a0,a0,384 # 80009098 <CONSOLE_STATUS+0x88>
    80002f20:	fffff097          	auipc	ra,0xfffff
    80002f24:	18c080e7          	jalr	396(ra) # 800020ac <_Z11printStringPKc>
        return;
    80002f28:	0140006f          	j	80002f3c <_Z22producerConsumer_C_APIv+0x130>
        printString("Broj proizvodjaca mora biti veci od nula!\n");
    80002f2c:	00006517          	auipc	a0,0x6
    80002f30:	1ac50513          	addi	a0,a0,428 # 800090d8 <CONSOLE_STATUS+0xc8>
    80002f34:	fffff097          	auipc	ra,0xfffff
    80002f38:	178080e7          	jalr	376(ra) # 800020ac <_Z11printStringPKc>
        return;
    80002f3c:	000b0113          	mv	sp,s6
    80002f40:	1500006f          	j	80003090 <_Z22producerConsumer_C_APIv+0x284>
    sem_open(&waitForAll, 0);
    80002f44:	00000593          	li	a1,0
    80002f48:	00009517          	auipc	a0,0x9
    80002f4c:	d4050513          	addi	a0,a0,-704 # 8000bc88 <_ZL10waitForAll>
    80002f50:	00002097          	auipc	ra,0x2
    80002f54:	008080e7          	jalr	8(ra) # 80004f58 <_Z8sem_openPP11mySemaphorej>
    thread_t threads[threadNum];
    80002f58:	00391793          	slli	a5,s2,0x3
    80002f5c:	00f78793          	addi	a5,a5,15
    80002f60:	ff07f793          	andi	a5,a5,-16
    80002f64:	40f10133          	sub	sp,sp,a5
    80002f68:	00010a93          	mv	s5,sp
    struct thread_data data[threadNum + 1];
    80002f6c:	0019071b          	addiw	a4,s2,1
    80002f70:	00171793          	slli	a5,a4,0x1
    80002f74:	00e787b3          	add	a5,a5,a4
    80002f78:	00379793          	slli	a5,a5,0x3
    80002f7c:	00f78793          	addi	a5,a5,15
    80002f80:	ff07f793          	andi	a5,a5,-16
    80002f84:	40f10133          	sub	sp,sp,a5
    80002f88:	00010993          	mv	s3,sp
    data[threadNum].id = threadNum;
    80002f8c:	00191613          	slli	a2,s2,0x1
    80002f90:	012607b3          	add	a5,a2,s2
    80002f94:	00379793          	slli	a5,a5,0x3
    80002f98:	00f987b3          	add	a5,s3,a5
    80002f9c:	0127a023          	sw	s2,0(a5)
    data[threadNum].buffer = buffer;
    80002fa0:	0147b423          	sd	s4,8(a5)
    data[threadNum].wait = waitForAll;
    80002fa4:	00009717          	auipc	a4,0x9
    80002fa8:	ce473703          	ld	a4,-796(a4) # 8000bc88 <_ZL10waitForAll>
    80002fac:	00e7b823          	sd	a4,16(a5)
    thread_create(&consumerThread, consumer, data + threadNum);
    80002fb0:	00078613          	mv	a2,a5
    80002fb4:	00000597          	auipc	a1,0x0
    80002fb8:	d7858593          	addi	a1,a1,-648 # 80002d2c <_ZL8consumerPv>
    80002fbc:	f9840513          	addi	a0,s0,-104
    80002fc0:	00002097          	auipc	ra,0x2
    80002fc4:	ea8080e7          	jalr	-344(ra) # 80004e68 <_Z13thread_createPP3TCBPFvPvES2_>
    for (int i = 0; i < threadNum; i++) {
    80002fc8:	00000493          	li	s1,0
    80002fcc:	0280006f          	j	80002ff4 <_Z22producerConsumer_C_APIv+0x1e8>
        thread_create(threads + i,
    80002fd0:	00000597          	auipc	a1,0x0
    80002fd4:	c1858593          	addi	a1,a1,-1000 # 80002be8 <_ZL16producerKeyboardPv>
                      data + i);
    80002fd8:	00179613          	slli	a2,a5,0x1
    80002fdc:	00f60633          	add	a2,a2,a5
    80002fe0:	00361613          	slli	a2,a2,0x3
        thread_create(threads + i,
    80002fe4:	00c98633          	add	a2,s3,a2
    80002fe8:	00002097          	auipc	ra,0x2
    80002fec:	e80080e7          	jalr	-384(ra) # 80004e68 <_Z13thread_createPP3TCBPFvPvES2_>
    for (int i = 0; i < threadNum; i++) {
    80002ff0:	0014849b          	addiw	s1,s1,1
    80002ff4:	0524d263          	bge	s1,s2,80003038 <_Z22producerConsumer_C_APIv+0x22c>
        data[i].id = i;
    80002ff8:	00149793          	slli	a5,s1,0x1
    80002ffc:	009787b3          	add	a5,a5,s1
    80003000:	00379793          	slli	a5,a5,0x3
    80003004:	00f987b3          	add	a5,s3,a5
    80003008:	0097a023          	sw	s1,0(a5)
        data[i].buffer = buffer;
    8000300c:	0147b423          	sd	s4,8(a5)
        data[i].wait = waitForAll;
    80003010:	00009717          	auipc	a4,0x9
    80003014:	c7873703          	ld	a4,-904(a4) # 8000bc88 <_ZL10waitForAll>
    80003018:	00e7b823          	sd	a4,16(a5)
        thread_create(threads + i,
    8000301c:	00048793          	mv	a5,s1
    80003020:	00349513          	slli	a0,s1,0x3
    80003024:	00aa8533          	add	a0,s5,a0
    80003028:	fa9054e3          	blez	s1,80002fd0 <_Z22producerConsumer_C_APIv+0x1c4>
    8000302c:	00000597          	auipc	a1,0x0
    80003030:	c6c58593          	addi	a1,a1,-916 # 80002c98 <_ZL8producerPv>
    80003034:	fa5ff06f          	j	80002fd8 <_Z22producerConsumer_C_APIv+0x1cc>
    thread_dispatch();
    80003038:	00002097          	auipc	ra,0x2
    8000303c:	ef8080e7          	jalr	-264(ra) # 80004f30 <_Z15thread_dispatchv>
    for (int i = 0; i <= threadNum; i++) {
    80003040:	00000493          	li	s1,0
    80003044:	00994e63          	blt	s2,s1,80003060 <_Z22producerConsumer_C_APIv+0x254>
        sem_wait(waitForAll);
    80003048:	00009517          	auipc	a0,0x9
    8000304c:	c4053503          	ld	a0,-960(a0) # 8000bc88 <_ZL10waitForAll>
    80003050:	00002097          	auipc	ra,0x2
    80003054:	f84080e7          	jalr	-124(ra) # 80004fd4 <_Z8sem_waitP11mySemaphore>
    for (int i = 0; i <= threadNum; i++) {
    80003058:	0014849b          	addiw	s1,s1,1
    8000305c:	fe9ff06f          	j	80003044 <_Z22producerConsumer_C_APIv+0x238>
    sem_close(waitForAll);
    80003060:	00009517          	auipc	a0,0x9
    80003064:	c2853503          	ld	a0,-984(a0) # 8000bc88 <_ZL10waitForAll>
    80003068:	00002097          	auipc	ra,0x2
    8000306c:	f34080e7          	jalr	-204(ra) # 80004f9c <_Z9sem_closeP11mySemaphore>
    delete buffer;
    80003070:	000a0e63          	beqz	s4,8000308c <_Z22producerConsumer_C_APIv+0x280>
    80003074:	000a0513          	mv	a0,s4
    80003078:	00000097          	auipc	ra,0x0
    8000307c:	93c080e7          	jalr	-1732(ra) # 800029b4 <_ZN6BufferD1Ev>
    80003080:	000a0513          	mv	a0,s4
    80003084:	00003097          	auipc	ra,0x3
    80003088:	fe4080e7          	jalr	-28(ra) # 80006068 <_ZdlPv>
    8000308c:	000b0113          	mv	sp,s6

}
    80003090:	f9040113          	addi	sp,s0,-112
    80003094:	06813083          	ld	ra,104(sp)
    80003098:	06013403          	ld	s0,96(sp)
    8000309c:	05813483          	ld	s1,88(sp)
    800030a0:	05013903          	ld	s2,80(sp)
    800030a4:	04813983          	ld	s3,72(sp)
    800030a8:	04013a03          	ld	s4,64(sp)
    800030ac:	03813a83          	ld	s5,56(sp)
    800030b0:	03013b03          	ld	s6,48(sp)
    800030b4:	07010113          	addi	sp,sp,112
    800030b8:	00008067          	ret
    800030bc:	00050493          	mv	s1,a0
    Buffer *buffer = new Buffer(n);
    800030c0:	000a0513          	mv	a0,s4
    800030c4:	00003097          	auipc	ra,0x3
    800030c8:	fa4080e7          	jalr	-92(ra) # 80006068 <_ZdlPv>
    800030cc:	00048513          	mv	a0,s1
    800030d0:	0000a097          	auipc	ra,0xa
    800030d4:	588080e7          	jalr	1416(ra) # 8000d658 <_Unwind_Resume>

00000000800030d8 <_ZL9sleepyRunPv>:

#include "printing.hpp"

static volatile bool finished[2];

static void sleepyRun(void *arg) {
    800030d8:	fe010113          	addi	sp,sp,-32
    800030dc:	00113c23          	sd	ra,24(sp)
    800030e0:	00813823          	sd	s0,16(sp)
    800030e4:	00913423          	sd	s1,8(sp)
    800030e8:	01213023          	sd	s2,0(sp)
    800030ec:	02010413          	addi	s0,sp,32
    time_t sleep_time = *((time_t *) arg);
    800030f0:	00053903          	ld	s2,0(a0)
    int i = 6;
    800030f4:	00600493          	li	s1,6
    while (--i > 0) {
    800030f8:	fff4849b          	addiw	s1,s1,-1
    800030fc:	04905463          	blez	s1,80003144 <_ZL9sleepyRunPv+0x6c>

        printString("Hello ");
    80003100:	00006517          	auipc	a0,0x6
    80003104:	40850513          	addi	a0,a0,1032 # 80009508 <_ZTV12ConsumerSync+0x3b0>
    80003108:	fffff097          	auipc	ra,0xfffff
    8000310c:	fa4080e7          	jalr	-92(ra) # 800020ac <_Z11printStringPKc>
        printInt(sleep_time);
    80003110:	00000613          	li	a2,0
    80003114:	00a00593          	li	a1,10
    80003118:	0009051b          	sext.w	a0,s2
    8000311c:	fffff097          	auipc	ra,0xfffff
    80003120:	140080e7          	jalr	320(ra) # 8000225c <_Z8printIntiii>
        printString(" !\n");
    80003124:	00006517          	auipc	a0,0x6
    80003128:	3ec50513          	addi	a0,a0,1004 # 80009510 <_ZTV12ConsumerSync+0x3b8>
    8000312c:	fffff097          	auipc	ra,0xfffff
    80003130:	f80080e7          	jalr	-128(ra) # 800020ac <_Z11printStringPKc>
        time_sleep(sleep_time);
    80003134:	00090513          	mv	a0,s2
    80003138:	00002097          	auipc	ra,0x2
    8000313c:	f80080e7          	jalr	-128(ra) # 800050b8 <_Z10time_sleepm>
    while (--i > 0) {
    80003140:	fb9ff06f          	j	800030f8 <_ZL9sleepyRunPv+0x20>
    }
    finished[sleep_time/10-1] = true;
    80003144:	00a00793          	li	a5,10
    80003148:	02f95933          	divu	s2,s2,a5
    8000314c:	fff90913          	addi	s2,s2,-1
    80003150:	00009797          	auipc	a5,0x9
    80003154:	b4078793          	addi	a5,a5,-1216 # 8000bc90 <_ZL8finished>
    80003158:	01278933          	add	s2,a5,s2
    8000315c:	00100793          	li	a5,1
    80003160:	00f90023          	sb	a5,0(s2)
}
    80003164:	01813083          	ld	ra,24(sp)
    80003168:	01013403          	ld	s0,16(sp)
    8000316c:	00813483          	ld	s1,8(sp)
    80003170:	00013903          	ld	s2,0(sp)
    80003174:	02010113          	addi	sp,sp,32
    80003178:	00008067          	ret

000000008000317c <_Z12testSleepingv>:

void testSleeping() {
    8000317c:	fc010113          	addi	sp,sp,-64
    80003180:	02113c23          	sd	ra,56(sp)
    80003184:	02813823          	sd	s0,48(sp)
    80003188:	02913423          	sd	s1,40(sp)
    8000318c:	04010413          	addi	s0,sp,64
    const int sleepy_thread_count = 2;
    time_t sleep_times[sleepy_thread_count] = {10, 20};
    80003190:	00a00793          	li	a5,10
    80003194:	fcf43823          	sd	a5,-48(s0)
    80003198:	01400793          	li	a5,20
    8000319c:	fcf43c23          	sd	a5,-40(s0)
    thread_t sleepyThread[sleepy_thread_count];

    for (int i = 0; i < sleepy_thread_count; i++) {
    800031a0:	00000493          	li	s1,0
    800031a4:	02c0006f          	j	800031d0 <_Z12testSleepingv+0x54>
        thread_create(&sleepyThread[i], sleepyRun, sleep_times + i);
    800031a8:	00349513          	slli	a0,s1,0x3
    800031ac:	fd040793          	addi	a5,s0,-48
    800031b0:	00a78633          	add	a2,a5,a0
    800031b4:	00000597          	auipc	a1,0x0
    800031b8:	f2458593          	addi	a1,a1,-220 # 800030d8 <_ZL9sleepyRunPv>
    800031bc:	fc040793          	addi	a5,s0,-64
    800031c0:	00a78533          	add	a0,a5,a0
    800031c4:	00002097          	auipc	ra,0x2
    800031c8:	ca4080e7          	jalr	-860(ra) # 80004e68 <_Z13thread_createPP3TCBPFvPvES2_>
    for (int i = 0; i < sleepy_thread_count; i++) {
    800031cc:	0014849b          	addiw	s1,s1,1
    800031d0:	00100793          	li	a5,1
    800031d4:	fc97dae3          	bge	a5,s1,800031a8 <_Z12testSleepingv+0x2c>
    }

    while (!(finished[0] && finished[1])) {}
    800031d8:	00009797          	auipc	a5,0x9
    800031dc:	ab87c783          	lbu	a5,-1352(a5) # 8000bc90 <_ZL8finished>
    800031e0:	fe078ce3          	beqz	a5,800031d8 <_Z12testSleepingv+0x5c>
    800031e4:	00009797          	auipc	a5,0x9
    800031e8:	aad7c783          	lbu	a5,-1363(a5) # 8000bc91 <_ZL8finished+0x1>
    800031ec:	fe0786e3          	beqz	a5,800031d8 <_Z12testSleepingv+0x5c>
}
    800031f0:	03813083          	ld	ra,56(sp)
    800031f4:	03013403          	ld	s0,48(sp)
    800031f8:	02813483          	ld	s1,40(sp)
    800031fc:	04010113          	addi	sp,sp,64
    80003200:	00008067          	ret

0000000080003204 <_Z20testConsumerProducerv>:

        td->sem->signal();
    }
};

void testConsumerProducer() {
    80003204:	f8010113          	addi	sp,sp,-128
    80003208:	06113c23          	sd	ra,120(sp)
    8000320c:	06813823          	sd	s0,112(sp)
    80003210:	06913423          	sd	s1,104(sp)
    80003214:	07213023          	sd	s2,96(sp)
    80003218:	05313c23          	sd	s3,88(sp)
    8000321c:	05413823          	sd	s4,80(sp)
    80003220:	05513423          	sd	s5,72(sp)
    80003224:	05613023          	sd	s6,64(sp)
    80003228:	03713c23          	sd	s7,56(sp)
    8000322c:	03813823          	sd	s8,48(sp)
    80003230:	03913423          	sd	s9,40(sp)
    80003234:	08010413          	addi	s0,sp,128
    delete waitForAll;
    for (int i = 0; i < threadNum; i++) {
        delete producers[i];
    }
    delete consumer;
    delete buffer;
    80003238:	00010c13          	mv	s8,sp
    printString("Unesite broj proizvodjaca?\n");
    8000323c:	00006517          	auipc	a0,0x6
    80003240:	de450513          	addi	a0,a0,-540 # 80009020 <CONSOLE_STATUS+0x10>
    80003244:	fffff097          	auipc	ra,0xfffff
    80003248:	e68080e7          	jalr	-408(ra) # 800020ac <_Z11printStringPKc>
    getString(input, 30);
    8000324c:	01e00593          	li	a1,30
    80003250:	f8040513          	addi	a0,s0,-128
    80003254:	fffff097          	auipc	ra,0xfffff
    80003258:	ee0080e7          	jalr	-288(ra) # 80002134 <_Z9getStringPci>
    threadNum = stringToInt(input);
    8000325c:	f8040513          	addi	a0,s0,-128
    80003260:	fffff097          	auipc	ra,0xfffff
    80003264:	fac080e7          	jalr	-84(ra) # 8000220c <_Z11stringToIntPKc>
    80003268:	00050993          	mv	s3,a0
    printString("Unesite velicinu bafera?\n");
    8000326c:	00006517          	auipc	a0,0x6
    80003270:	dd450513          	addi	a0,a0,-556 # 80009040 <CONSOLE_STATUS+0x30>
    80003274:	fffff097          	auipc	ra,0xfffff
    80003278:	e38080e7          	jalr	-456(ra) # 800020ac <_Z11printStringPKc>
    getString(input, 30);
    8000327c:	01e00593          	li	a1,30
    80003280:	f8040513          	addi	a0,s0,-128
    80003284:	fffff097          	auipc	ra,0xfffff
    80003288:	eb0080e7          	jalr	-336(ra) # 80002134 <_Z9getStringPci>
    n = stringToInt(input);
    8000328c:	f8040513          	addi	a0,s0,-128
    80003290:	fffff097          	auipc	ra,0xfffff
    80003294:	f7c080e7          	jalr	-132(ra) # 8000220c <_Z11stringToIntPKc>
    80003298:	00050493          	mv	s1,a0
    printString("Broj proizvodjaca ");
    8000329c:	00006517          	auipc	a0,0x6
    800032a0:	dc450513          	addi	a0,a0,-572 # 80009060 <CONSOLE_STATUS+0x50>
    800032a4:	fffff097          	auipc	ra,0xfffff
    800032a8:	e08080e7          	jalr	-504(ra) # 800020ac <_Z11printStringPKc>
    printInt(threadNum);
    800032ac:	00000613          	li	a2,0
    800032b0:	00a00593          	li	a1,10
    800032b4:	00098513          	mv	a0,s3
    800032b8:	fffff097          	auipc	ra,0xfffff
    800032bc:	fa4080e7          	jalr	-92(ra) # 8000225c <_Z8printIntiii>
    printString(" i velicina bafera ");
    800032c0:	00006517          	auipc	a0,0x6
    800032c4:	db850513          	addi	a0,a0,-584 # 80009078 <CONSOLE_STATUS+0x68>
    800032c8:	fffff097          	auipc	ra,0xfffff
    800032cc:	de4080e7          	jalr	-540(ra) # 800020ac <_Z11printStringPKc>
    printInt(n);
    800032d0:	00000613          	li	a2,0
    800032d4:	00a00593          	li	a1,10
    800032d8:	00048513          	mv	a0,s1
    800032dc:	fffff097          	auipc	ra,0xfffff
    800032e0:	f80080e7          	jalr	-128(ra) # 8000225c <_Z8printIntiii>
    printString(".\n");
    800032e4:	00006517          	auipc	a0,0x6
    800032e8:	dac50513          	addi	a0,a0,-596 # 80009090 <CONSOLE_STATUS+0x80>
    800032ec:	fffff097          	auipc	ra,0xfffff
    800032f0:	dc0080e7          	jalr	-576(ra) # 800020ac <_Z11printStringPKc>
    if (threadNum > n) {
    800032f4:	0334c463          	blt	s1,s3,8000331c <_Z20testConsumerProducerv+0x118>
    } else if (threadNum < 1) {
    800032f8:	03305c63          	blez	s3,80003330 <_Z20testConsumerProducerv+0x12c>
    BufferCPP *buffer = new BufferCPP(n);
    800032fc:	03800513          	li	a0,56
    80003300:	00003097          	auipc	ra,0x3
    80003304:	d18080e7          	jalr	-744(ra) # 80006018 <_Znwm>
    80003308:	00050a93          	mv	s5,a0
    8000330c:	00048593          	mv	a1,s1
    80003310:	fffff097          	auipc	ra,0xfffff
    80003314:	06c080e7          	jalr	108(ra) # 8000237c <_ZN9BufferCPPC1Ei>
    80003318:	0300006f          	j	80003348 <_Z20testConsumerProducerv+0x144>
        printString("Broj proizvodjaca ne sme biti manji od velicine bafera!\n");
    8000331c:	00006517          	auipc	a0,0x6
    80003320:	d7c50513          	addi	a0,a0,-644 # 80009098 <CONSOLE_STATUS+0x88>
    80003324:	fffff097          	auipc	ra,0xfffff
    80003328:	d88080e7          	jalr	-632(ra) # 800020ac <_Z11printStringPKc>
        return;
    8000332c:	0140006f          	j	80003340 <_Z20testConsumerProducerv+0x13c>
        printString("Broj proizvodjaca mora biti veci od nula!\n");
    80003330:	00006517          	auipc	a0,0x6
    80003334:	da850513          	addi	a0,a0,-600 # 800090d8 <CONSOLE_STATUS+0xc8>
    80003338:	fffff097          	auipc	ra,0xfffff
    8000333c:	d74080e7          	jalr	-652(ra) # 800020ac <_Z11printStringPKc>
        return;
    80003340:	000c0113          	mv	sp,s8
    80003344:	2140006f          	j	80003558 <_Z20testConsumerProducerv+0x354>
    waitForAll = new Semaphore(0);
    80003348:	01000513          	li	a0,16
    8000334c:	00003097          	auipc	ra,0x3
    80003350:	ccc080e7          	jalr	-820(ra) # 80006018 <_Znwm>
    80003354:	00050913          	mv	s2,a0
    80003358:	00000593          	li	a1,0
    8000335c:	00003097          	auipc	ra,0x3
    80003360:	f98080e7          	jalr	-104(ra) # 800062f4 <_ZN9SemaphoreC1Ej>
    80003364:	00009797          	auipc	a5,0x9
    80003368:	9327be23          	sd	s2,-1732(a5) # 8000bca0 <_ZL10waitForAll>
    Thread *producers[threadNum];
    8000336c:	00399793          	slli	a5,s3,0x3
    80003370:	00f78793          	addi	a5,a5,15
    80003374:	ff07f793          	andi	a5,a5,-16
    80003378:	40f10133          	sub	sp,sp,a5
    8000337c:	00010a13          	mv	s4,sp
    thread_data threadData[threadNum + 1];
    80003380:	0019871b          	addiw	a4,s3,1
    80003384:	00171793          	slli	a5,a4,0x1
    80003388:	00e787b3          	add	a5,a5,a4
    8000338c:	00379793          	slli	a5,a5,0x3
    80003390:	00f78793          	addi	a5,a5,15
    80003394:	ff07f793          	andi	a5,a5,-16
    80003398:	40f10133          	sub	sp,sp,a5
    8000339c:	00010b13          	mv	s6,sp
    threadData[threadNum].id = threadNum;
    800033a0:	00199493          	slli	s1,s3,0x1
    800033a4:	013484b3          	add	s1,s1,s3
    800033a8:	00349493          	slli	s1,s1,0x3
    800033ac:	009b04b3          	add	s1,s6,s1
    800033b0:	0134a023          	sw	s3,0(s1)
    threadData[threadNum].buffer = buffer;
    800033b4:	0154b423          	sd	s5,8(s1)
    threadData[threadNum].sem = waitForAll;
    800033b8:	0124b823          	sd	s2,16(s1)
    Thread *consumer = new Consumer(&threadData[threadNum]);
    800033bc:	02800513          	li	a0,40
    800033c0:	00003097          	auipc	ra,0x3
    800033c4:	c58080e7          	jalr	-936(ra) # 80006018 <_Znwm>
    800033c8:	00050b93          	mv	s7,a0
    Consumer(thread_data *_td) : Thread(), td(_td) {}
    800033cc:	00003097          	auipc	ra,0x3
    800033d0:	efc080e7          	jalr	-260(ra) # 800062c8 <_ZN6ThreadC1Ev>
    800033d4:	00006797          	auipc	a5,0x6
    800033d8:	1a478793          	addi	a5,a5,420 # 80009578 <_ZTV8Consumer+0x10>
    800033dc:	00fbb023          	sd	a5,0(s7)
    800033e0:	029bb023          	sd	s1,32(s7)
    consumer->start();
    800033e4:	000b8513          	mv	a0,s7
    800033e8:	00003097          	auipc	ra,0x3
    800033ec:	dd4080e7          	jalr	-556(ra) # 800061bc <_ZN6Thread5startEv>
    threadData[0].id = 0;
    800033f0:	000b2023          	sw	zero,0(s6)
    threadData[0].buffer = buffer;
    800033f4:	015b3423          	sd	s5,8(s6)
    threadData[0].sem = waitForAll;
    800033f8:	00009797          	auipc	a5,0x9
    800033fc:	8a87b783          	ld	a5,-1880(a5) # 8000bca0 <_ZL10waitForAll>
    80003400:	00fb3823          	sd	a5,16(s6)
    producers[0] = new ProducerKeyborad(&threadData[0]);
    80003404:	02800513          	li	a0,40
    80003408:	00003097          	auipc	ra,0x3
    8000340c:	c10080e7          	jalr	-1008(ra) # 80006018 <_Znwm>
    80003410:	00050493          	mv	s1,a0
    ProducerKeyborad(thread_data *_td) : Thread(), td(_td) {}
    80003414:	00003097          	auipc	ra,0x3
    80003418:	eb4080e7          	jalr	-332(ra) # 800062c8 <_ZN6ThreadC1Ev>
    8000341c:	00006797          	auipc	a5,0x6
    80003420:	10c78793          	addi	a5,a5,268 # 80009528 <_ZTV16ProducerKeyborad+0x10>
    80003424:	00f4b023          	sd	a5,0(s1)
    80003428:	0364b023          	sd	s6,32(s1)
    producers[0] = new ProducerKeyborad(&threadData[0]);
    8000342c:	009a3023          	sd	s1,0(s4)
    producers[0]->start();
    80003430:	00048513          	mv	a0,s1
    80003434:	00003097          	auipc	ra,0x3
    80003438:	d88080e7          	jalr	-632(ra) # 800061bc <_ZN6Thread5startEv>
    for (int i = 1; i < threadNum; i++) {
    8000343c:	00100913          	li	s2,1
    80003440:	0300006f          	j	80003470 <_Z20testConsumerProducerv+0x26c>
    Producer(thread_data *_td) : Thread(), td(_td) {}
    80003444:	00006797          	auipc	a5,0x6
    80003448:	10c78793          	addi	a5,a5,268 # 80009550 <_ZTV8Producer+0x10>
    8000344c:	00fcb023          	sd	a5,0(s9)
    80003450:	029cb023          	sd	s1,32(s9)
        producers[i] = new Producer(&threadData[i]);
    80003454:	00391793          	slli	a5,s2,0x3
    80003458:	00fa07b3          	add	a5,s4,a5
    8000345c:	0197b023          	sd	s9,0(a5)
        producers[i]->start();
    80003460:	000c8513          	mv	a0,s9
    80003464:	00003097          	auipc	ra,0x3
    80003468:	d58080e7          	jalr	-680(ra) # 800061bc <_ZN6Thread5startEv>
    for (int i = 1; i < threadNum; i++) {
    8000346c:	0019091b          	addiw	s2,s2,1
    80003470:	05395263          	bge	s2,s3,800034b4 <_Z20testConsumerProducerv+0x2b0>
        threadData[i].id = i;
    80003474:	00191493          	slli	s1,s2,0x1
    80003478:	012484b3          	add	s1,s1,s2
    8000347c:	00349493          	slli	s1,s1,0x3
    80003480:	009b04b3          	add	s1,s6,s1
    80003484:	0124a023          	sw	s2,0(s1)
        threadData[i].buffer = buffer;
    80003488:	0154b423          	sd	s5,8(s1)
        threadData[i].sem = waitForAll;
    8000348c:	00009797          	auipc	a5,0x9
    80003490:	8147b783          	ld	a5,-2028(a5) # 8000bca0 <_ZL10waitForAll>
    80003494:	00f4b823          	sd	a5,16(s1)
        producers[i] = new Producer(&threadData[i]);
    80003498:	02800513          	li	a0,40
    8000349c:	00003097          	auipc	ra,0x3
    800034a0:	b7c080e7          	jalr	-1156(ra) # 80006018 <_Znwm>
    800034a4:	00050c93          	mv	s9,a0
    Producer(thread_data *_td) : Thread(), td(_td) {}
    800034a8:	00003097          	auipc	ra,0x3
    800034ac:	e20080e7          	jalr	-480(ra) # 800062c8 <_ZN6ThreadC1Ev>
    800034b0:	f95ff06f          	j	80003444 <_Z20testConsumerProducerv+0x240>
    Thread::dispatch();
    800034b4:	00003097          	auipc	ra,0x3
    800034b8:	d5c080e7          	jalr	-676(ra) # 80006210 <_ZN6Thread8dispatchEv>
    for (int i = 0; i <= threadNum; i++) {
    800034bc:	00000493          	li	s1,0
    800034c0:	0099ce63          	blt	s3,s1,800034dc <_Z20testConsumerProducerv+0x2d8>
        waitForAll->wait();
    800034c4:	00008517          	auipc	a0,0x8
    800034c8:	7dc53503          	ld	a0,2012(a0) # 8000bca0 <_ZL10waitForAll>
    800034cc:	00003097          	auipc	ra,0x3
    800034d0:	e60080e7          	jalr	-416(ra) # 8000632c <_ZN9Semaphore4waitEv>
    for (int i = 0; i <= threadNum; i++) {
    800034d4:	0014849b          	addiw	s1,s1,1
    800034d8:	fe9ff06f          	j	800034c0 <_Z20testConsumerProducerv+0x2bc>
    delete waitForAll;
    800034dc:	00008517          	auipc	a0,0x8
    800034e0:	7c453503          	ld	a0,1988(a0) # 8000bca0 <_ZL10waitForAll>
    800034e4:	00050863          	beqz	a0,800034f4 <_Z20testConsumerProducerv+0x2f0>
    800034e8:	00053783          	ld	a5,0(a0)
    800034ec:	0087b783          	ld	a5,8(a5)
    800034f0:	000780e7          	jalr	a5
    for (int i = 0; i <= threadNum; i++) {
    800034f4:	00000493          	li	s1,0
    800034f8:	0080006f          	j	80003500 <_Z20testConsumerProducerv+0x2fc>
    for (int i = 0; i < threadNum; i++) {
    800034fc:	0014849b          	addiw	s1,s1,1
    80003500:	0334d263          	bge	s1,s3,80003524 <_Z20testConsumerProducerv+0x320>
        delete producers[i];
    80003504:	00349793          	slli	a5,s1,0x3
    80003508:	00fa07b3          	add	a5,s4,a5
    8000350c:	0007b503          	ld	a0,0(a5)
    80003510:	fe0506e3          	beqz	a0,800034fc <_Z20testConsumerProducerv+0x2f8>
    80003514:	00053783          	ld	a5,0(a0)
    80003518:	0087b783          	ld	a5,8(a5)
    8000351c:	000780e7          	jalr	a5
    80003520:	fddff06f          	j	800034fc <_Z20testConsumerProducerv+0x2f8>
    delete consumer;
    80003524:	000b8a63          	beqz	s7,80003538 <_Z20testConsumerProducerv+0x334>
    80003528:	000bb783          	ld	a5,0(s7)
    8000352c:	0087b783          	ld	a5,8(a5)
    80003530:	000b8513          	mv	a0,s7
    80003534:	000780e7          	jalr	a5
    delete buffer;
    80003538:	000a8e63          	beqz	s5,80003554 <_Z20testConsumerProducerv+0x350>
    8000353c:	000a8513          	mv	a0,s5
    80003540:	fffff097          	auipc	ra,0xfffff
    80003544:	134080e7          	jalr	308(ra) # 80002674 <_ZN9BufferCPPD1Ev>
    80003548:	000a8513          	mv	a0,s5
    8000354c:	00003097          	auipc	ra,0x3
    80003550:	b1c080e7          	jalr	-1252(ra) # 80006068 <_ZdlPv>
    80003554:	000c0113          	mv	sp,s8
}
    80003558:	f8040113          	addi	sp,s0,-128
    8000355c:	07813083          	ld	ra,120(sp)
    80003560:	07013403          	ld	s0,112(sp)
    80003564:	06813483          	ld	s1,104(sp)
    80003568:	06013903          	ld	s2,96(sp)
    8000356c:	05813983          	ld	s3,88(sp)
    80003570:	05013a03          	ld	s4,80(sp)
    80003574:	04813a83          	ld	s5,72(sp)
    80003578:	04013b03          	ld	s6,64(sp)
    8000357c:	03813b83          	ld	s7,56(sp)
    80003580:	03013c03          	ld	s8,48(sp)
    80003584:	02813c83          	ld	s9,40(sp)
    80003588:	08010113          	addi	sp,sp,128
    8000358c:	00008067          	ret
    80003590:	00050493          	mv	s1,a0
    BufferCPP *buffer = new BufferCPP(n);
    80003594:	000a8513          	mv	a0,s5
    80003598:	00003097          	auipc	ra,0x3
    8000359c:	ad0080e7          	jalr	-1328(ra) # 80006068 <_ZdlPv>
    800035a0:	00048513          	mv	a0,s1
    800035a4:	0000a097          	auipc	ra,0xa
    800035a8:	0b4080e7          	jalr	180(ra) # 8000d658 <_Unwind_Resume>
    800035ac:	00050493          	mv	s1,a0
    waitForAll = new Semaphore(0);
    800035b0:	00090513          	mv	a0,s2
    800035b4:	00003097          	auipc	ra,0x3
    800035b8:	ab4080e7          	jalr	-1356(ra) # 80006068 <_ZdlPv>
    800035bc:	00048513          	mv	a0,s1
    800035c0:	0000a097          	auipc	ra,0xa
    800035c4:	098080e7          	jalr	152(ra) # 8000d658 <_Unwind_Resume>
    800035c8:	00050493          	mv	s1,a0
    Thread *consumer = new Consumer(&threadData[threadNum]);
    800035cc:	000b8513          	mv	a0,s7
    800035d0:	00003097          	auipc	ra,0x3
    800035d4:	a98080e7          	jalr	-1384(ra) # 80006068 <_ZdlPv>
    800035d8:	00048513          	mv	a0,s1
    800035dc:	0000a097          	auipc	ra,0xa
    800035e0:	07c080e7          	jalr	124(ra) # 8000d658 <_Unwind_Resume>
    800035e4:	00050913          	mv	s2,a0
    producers[0] = new ProducerKeyborad(&threadData[0]);
    800035e8:	00048513          	mv	a0,s1
    800035ec:	00003097          	auipc	ra,0x3
    800035f0:	a7c080e7          	jalr	-1412(ra) # 80006068 <_ZdlPv>
    800035f4:	00090513          	mv	a0,s2
    800035f8:	0000a097          	auipc	ra,0xa
    800035fc:	060080e7          	jalr	96(ra) # 8000d658 <_Unwind_Resume>
    80003600:	00050493          	mv	s1,a0
        producers[i] = new Producer(&threadData[i]);
    80003604:	000c8513          	mv	a0,s9
    80003608:	00003097          	auipc	ra,0x3
    8000360c:	a60080e7          	jalr	-1440(ra) # 80006068 <_ZdlPv>
    80003610:	00048513          	mv	a0,s1
    80003614:	0000a097          	auipc	ra,0xa
    80003618:	044080e7          	jalr	68(ra) # 8000d658 <_Unwind_Resume>

000000008000361c <_ZN8Consumer3runEv>:
    void run() override {
    8000361c:	fd010113          	addi	sp,sp,-48
    80003620:	02113423          	sd	ra,40(sp)
    80003624:	02813023          	sd	s0,32(sp)
    80003628:	00913c23          	sd	s1,24(sp)
    8000362c:	01213823          	sd	s2,16(sp)
    80003630:	01313423          	sd	s3,8(sp)
    80003634:	03010413          	addi	s0,sp,48
    80003638:	00050913          	mv	s2,a0
        int i = 0;
    8000363c:	00000993          	li	s3,0
    80003640:	0100006f          	j	80003650 <_ZN8Consumer3runEv+0x34>
                Console::putc('\n');
    80003644:	00a00513          	li	a0,10
    80003648:	00003097          	auipc	ra,0x3
    8000364c:	e54080e7          	jalr	-428(ra) # 8000649c <_ZN7Console4putcEc>
        while (!threadEnd) {
    80003650:	00008797          	auipc	a5,0x8
    80003654:	6487a783          	lw	a5,1608(a5) # 8000bc98 <_ZL9threadEnd>
    80003658:	04079a63          	bnez	a5,800036ac <_ZN8Consumer3runEv+0x90>
            int key = td->buffer->get();
    8000365c:	02093783          	ld	a5,32(s2)
    80003660:	0087b503          	ld	a0,8(a5)
    80003664:	fffff097          	auipc	ra,0xfffff
    80003668:	efc080e7          	jalr	-260(ra) # 80002560 <_ZN9BufferCPP3getEv>
            i++;
    8000366c:	0019849b          	addiw	s1,s3,1
    80003670:	0004899b          	sext.w	s3,s1
            Console::putc(key);
    80003674:	0ff57513          	andi	a0,a0,255
    80003678:	00003097          	auipc	ra,0x3
    8000367c:	e24080e7          	jalr	-476(ra) # 8000649c <_ZN7Console4putcEc>
            if (i % 80 == 0) {
    80003680:	05000793          	li	a5,80
    80003684:	02f4e4bb          	remw	s1,s1,a5
    80003688:	fc0494e3          	bnez	s1,80003650 <_ZN8Consumer3runEv+0x34>
    8000368c:	fb9ff06f          	j	80003644 <_ZN8Consumer3runEv+0x28>
            int key = td->buffer->get();
    80003690:	02093783          	ld	a5,32(s2)
    80003694:	0087b503          	ld	a0,8(a5)
    80003698:	fffff097          	auipc	ra,0xfffff
    8000369c:	ec8080e7          	jalr	-312(ra) # 80002560 <_ZN9BufferCPP3getEv>
            Console::putc(key);
    800036a0:	0ff57513          	andi	a0,a0,255
    800036a4:	00003097          	auipc	ra,0x3
    800036a8:	df8080e7          	jalr	-520(ra) # 8000649c <_ZN7Console4putcEc>
        while (td->buffer->getCnt() > 0) {
    800036ac:	02093783          	ld	a5,32(s2)
    800036b0:	0087b503          	ld	a0,8(a5)
    800036b4:	fffff097          	auipc	ra,0xfffff
    800036b8:	f38080e7          	jalr	-200(ra) # 800025ec <_ZN9BufferCPP6getCntEv>
    800036bc:	fca04ae3          	bgtz	a0,80003690 <_ZN8Consumer3runEv+0x74>
        td->sem->signal();
    800036c0:	02093783          	ld	a5,32(s2)
    800036c4:	0107b503          	ld	a0,16(a5)
    800036c8:	00003097          	auipc	ra,0x3
    800036cc:	c90080e7          	jalr	-880(ra) # 80006358 <_ZN9Semaphore6signalEv>
    }
    800036d0:	02813083          	ld	ra,40(sp)
    800036d4:	02013403          	ld	s0,32(sp)
    800036d8:	01813483          	ld	s1,24(sp)
    800036dc:	01013903          	ld	s2,16(sp)
    800036e0:	00813983          	ld	s3,8(sp)
    800036e4:	03010113          	addi	sp,sp,48
    800036e8:	00008067          	ret

00000000800036ec <_ZN8ConsumerD1Ev>:
class Consumer : public Thread {
    800036ec:	ff010113          	addi	sp,sp,-16
    800036f0:	00113423          	sd	ra,8(sp)
    800036f4:	00813023          	sd	s0,0(sp)
    800036f8:	01010413          	addi	s0,sp,16
    800036fc:	00006797          	auipc	a5,0x6
    80003700:	e7c78793          	addi	a5,a5,-388 # 80009578 <_ZTV8Consumer+0x10>
    80003704:	00f53023          	sd	a5,0(a0)
    80003708:	00003097          	auipc	ra,0x3
    8000370c:	9f0080e7          	jalr	-1552(ra) # 800060f8 <_ZN6ThreadD1Ev>
    80003710:	00813083          	ld	ra,8(sp)
    80003714:	00013403          	ld	s0,0(sp)
    80003718:	01010113          	addi	sp,sp,16
    8000371c:	00008067          	ret

0000000080003720 <_ZN8ConsumerD0Ev>:
    80003720:	fe010113          	addi	sp,sp,-32
    80003724:	00113c23          	sd	ra,24(sp)
    80003728:	00813823          	sd	s0,16(sp)
    8000372c:	00913423          	sd	s1,8(sp)
    80003730:	02010413          	addi	s0,sp,32
    80003734:	00050493          	mv	s1,a0
    80003738:	00006797          	auipc	a5,0x6
    8000373c:	e4078793          	addi	a5,a5,-448 # 80009578 <_ZTV8Consumer+0x10>
    80003740:	00f53023          	sd	a5,0(a0)
    80003744:	00003097          	auipc	ra,0x3
    80003748:	9b4080e7          	jalr	-1612(ra) # 800060f8 <_ZN6ThreadD1Ev>
    8000374c:	00048513          	mv	a0,s1
    80003750:	00003097          	auipc	ra,0x3
    80003754:	918080e7          	jalr	-1768(ra) # 80006068 <_ZdlPv>
    80003758:	01813083          	ld	ra,24(sp)
    8000375c:	01013403          	ld	s0,16(sp)
    80003760:	00813483          	ld	s1,8(sp)
    80003764:	02010113          	addi	sp,sp,32
    80003768:	00008067          	ret

000000008000376c <_ZN16ProducerKeyboradD1Ev>:
class ProducerKeyborad : public Thread {
    8000376c:	ff010113          	addi	sp,sp,-16
    80003770:	00113423          	sd	ra,8(sp)
    80003774:	00813023          	sd	s0,0(sp)
    80003778:	01010413          	addi	s0,sp,16
    8000377c:	00006797          	auipc	a5,0x6
    80003780:	dac78793          	addi	a5,a5,-596 # 80009528 <_ZTV16ProducerKeyborad+0x10>
    80003784:	00f53023          	sd	a5,0(a0)
    80003788:	00003097          	auipc	ra,0x3
    8000378c:	970080e7          	jalr	-1680(ra) # 800060f8 <_ZN6ThreadD1Ev>
    80003790:	00813083          	ld	ra,8(sp)
    80003794:	00013403          	ld	s0,0(sp)
    80003798:	01010113          	addi	sp,sp,16
    8000379c:	00008067          	ret

00000000800037a0 <_ZN16ProducerKeyboradD0Ev>:
    800037a0:	fe010113          	addi	sp,sp,-32
    800037a4:	00113c23          	sd	ra,24(sp)
    800037a8:	00813823          	sd	s0,16(sp)
    800037ac:	00913423          	sd	s1,8(sp)
    800037b0:	02010413          	addi	s0,sp,32
    800037b4:	00050493          	mv	s1,a0
    800037b8:	00006797          	auipc	a5,0x6
    800037bc:	d7078793          	addi	a5,a5,-656 # 80009528 <_ZTV16ProducerKeyborad+0x10>
    800037c0:	00f53023          	sd	a5,0(a0)
    800037c4:	00003097          	auipc	ra,0x3
    800037c8:	934080e7          	jalr	-1740(ra) # 800060f8 <_ZN6ThreadD1Ev>
    800037cc:	00048513          	mv	a0,s1
    800037d0:	00003097          	auipc	ra,0x3
    800037d4:	898080e7          	jalr	-1896(ra) # 80006068 <_ZdlPv>
    800037d8:	01813083          	ld	ra,24(sp)
    800037dc:	01013403          	ld	s0,16(sp)
    800037e0:	00813483          	ld	s1,8(sp)
    800037e4:	02010113          	addi	sp,sp,32
    800037e8:	00008067          	ret

00000000800037ec <_ZN8ProducerD1Ev>:
class Producer : public Thread {
    800037ec:	ff010113          	addi	sp,sp,-16
    800037f0:	00113423          	sd	ra,8(sp)
    800037f4:	00813023          	sd	s0,0(sp)
    800037f8:	01010413          	addi	s0,sp,16
    800037fc:	00006797          	auipc	a5,0x6
    80003800:	d5478793          	addi	a5,a5,-684 # 80009550 <_ZTV8Producer+0x10>
    80003804:	00f53023          	sd	a5,0(a0)
    80003808:	00003097          	auipc	ra,0x3
    8000380c:	8f0080e7          	jalr	-1808(ra) # 800060f8 <_ZN6ThreadD1Ev>
    80003810:	00813083          	ld	ra,8(sp)
    80003814:	00013403          	ld	s0,0(sp)
    80003818:	01010113          	addi	sp,sp,16
    8000381c:	00008067          	ret

0000000080003820 <_ZN8ProducerD0Ev>:
    80003820:	fe010113          	addi	sp,sp,-32
    80003824:	00113c23          	sd	ra,24(sp)
    80003828:	00813823          	sd	s0,16(sp)
    8000382c:	00913423          	sd	s1,8(sp)
    80003830:	02010413          	addi	s0,sp,32
    80003834:	00050493          	mv	s1,a0
    80003838:	00006797          	auipc	a5,0x6
    8000383c:	d1878793          	addi	a5,a5,-744 # 80009550 <_ZTV8Producer+0x10>
    80003840:	00f53023          	sd	a5,0(a0)
    80003844:	00003097          	auipc	ra,0x3
    80003848:	8b4080e7          	jalr	-1868(ra) # 800060f8 <_ZN6ThreadD1Ev>
    8000384c:	00048513          	mv	a0,s1
    80003850:	00003097          	auipc	ra,0x3
    80003854:	818080e7          	jalr	-2024(ra) # 80006068 <_ZdlPv>
    80003858:	01813083          	ld	ra,24(sp)
    8000385c:	01013403          	ld	s0,16(sp)
    80003860:	00813483          	ld	s1,8(sp)
    80003864:	02010113          	addi	sp,sp,32
    80003868:	00008067          	ret

000000008000386c <_ZN16ProducerKeyborad3runEv>:
    void run() override {
    8000386c:	fe010113          	addi	sp,sp,-32
    80003870:	00113c23          	sd	ra,24(sp)
    80003874:	00813823          	sd	s0,16(sp)
    80003878:	00913423          	sd	s1,8(sp)
    8000387c:	02010413          	addi	s0,sp,32
    80003880:	00050493          	mv	s1,a0
        while ((key = getc()) != 'w') {
    80003884:	00002097          	auipc	ra,0x2
    80003888:	878080e7          	jalr	-1928(ra) # 800050fc <_Z4getcv>
    8000388c:	0005059b          	sext.w	a1,a0
    80003890:	07700793          	li	a5,119
    80003894:	00f58c63          	beq	a1,a5,800038ac <_ZN16ProducerKeyborad3runEv+0x40>
            td->buffer->put(key);
    80003898:	0204b783          	ld	a5,32(s1)
    8000389c:	0087b503          	ld	a0,8(a5)
    800038a0:	fffff097          	auipc	ra,0xfffff
    800038a4:	c30080e7          	jalr	-976(ra) # 800024d0 <_ZN9BufferCPP3putEi>
        while ((key = getc()) != 'w') {
    800038a8:	fddff06f          	j	80003884 <_ZN16ProducerKeyborad3runEv+0x18>
        threadEnd = 1;
    800038ac:	00100793          	li	a5,1
    800038b0:	00008717          	auipc	a4,0x8
    800038b4:	3ef72423          	sw	a5,1000(a4) # 8000bc98 <_ZL9threadEnd>
        td->buffer->put('!');
    800038b8:	0204b783          	ld	a5,32(s1)
    800038bc:	02100593          	li	a1,33
    800038c0:	0087b503          	ld	a0,8(a5)
    800038c4:	fffff097          	auipc	ra,0xfffff
    800038c8:	c0c080e7          	jalr	-1012(ra) # 800024d0 <_ZN9BufferCPP3putEi>
        td->sem->signal();
    800038cc:	0204b783          	ld	a5,32(s1)
    800038d0:	0107b503          	ld	a0,16(a5)
    800038d4:	00003097          	auipc	ra,0x3
    800038d8:	a84080e7          	jalr	-1404(ra) # 80006358 <_ZN9Semaphore6signalEv>
    }
    800038dc:	01813083          	ld	ra,24(sp)
    800038e0:	01013403          	ld	s0,16(sp)
    800038e4:	00813483          	ld	s1,8(sp)
    800038e8:	02010113          	addi	sp,sp,32
    800038ec:	00008067          	ret

00000000800038f0 <_ZN8Producer3runEv>:
    void run() override {
    800038f0:	fe010113          	addi	sp,sp,-32
    800038f4:	00113c23          	sd	ra,24(sp)
    800038f8:	00813823          	sd	s0,16(sp)
    800038fc:	00913423          	sd	s1,8(sp)
    80003900:	01213023          	sd	s2,0(sp)
    80003904:	02010413          	addi	s0,sp,32
    80003908:	00050493          	mv	s1,a0
        int i = 0;
    8000390c:	00000913          	li	s2,0
        while (!threadEnd) {
    80003910:	00008797          	auipc	a5,0x8
    80003914:	3887a783          	lw	a5,904(a5) # 8000bc98 <_ZL9threadEnd>
    80003918:	04079263          	bnez	a5,8000395c <_ZN8Producer3runEv+0x6c>
            td->buffer->put(td->id + '0');
    8000391c:	0204b783          	ld	a5,32(s1)
    80003920:	0007a583          	lw	a1,0(a5)
    80003924:	0305859b          	addiw	a1,a1,48
    80003928:	0087b503          	ld	a0,8(a5)
    8000392c:	fffff097          	auipc	ra,0xfffff
    80003930:	ba4080e7          	jalr	-1116(ra) # 800024d0 <_ZN9BufferCPP3putEi>
            i++;
    80003934:	0019071b          	addiw	a4,s2,1
    80003938:	0007091b          	sext.w	s2,a4
            Thread::sleep((i + td->id) % 5);
    8000393c:	0204b783          	ld	a5,32(s1)
    80003940:	0007a783          	lw	a5,0(a5)
    80003944:	00e787bb          	addw	a5,a5,a4
    80003948:	00500513          	li	a0,5
    8000394c:	02a7e53b          	remw	a0,a5,a0
    80003950:	00003097          	auipc	ra,0x3
    80003954:	8e8080e7          	jalr	-1816(ra) # 80006238 <_ZN6Thread5sleepEm>
        while (!threadEnd) {
    80003958:	fb9ff06f          	j	80003910 <_ZN8Producer3runEv+0x20>
        td->sem->signal();
    8000395c:	0204b783          	ld	a5,32(s1)
    80003960:	0107b503          	ld	a0,16(a5)
    80003964:	00003097          	auipc	ra,0x3
    80003968:	9f4080e7          	jalr	-1548(ra) # 80006358 <_ZN9Semaphore6signalEv>
    }
    8000396c:	01813083          	ld	ra,24(sp)
    80003970:	01013403          	ld	s0,16(sp)
    80003974:	00813483          	ld	s1,8(sp)
    80003978:	00013903          	ld	s2,0(sp)
    8000397c:	02010113          	addi	sp,sp,32
    80003980:	00008067          	ret

0000000080003984 <_ZL9fibonaccim>:
static volatile bool finishedA = false;
static volatile bool finishedB = false;
static volatile bool finishedC = false;
static volatile bool finishedD = false;

static uint64 fibonacci(uint64 n) {
    80003984:	fe010113          	addi	sp,sp,-32
    80003988:	00113c23          	sd	ra,24(sp)
    8000398c:	00813823          	sd	s0,16(sp)
    80003990:	00913423          	sd	s1,8(sp)
    80003994:	01213023          	sd	s2,0(sp)
    80003998:	02010413          	addi	s0,sp,32
    8000399c:	00050493          	mv	s1,a0
    if (n == 0 || n == 1) { return n; }
    800039a0:	00100793          	li	a5,1
    800039a4:	02a7f863          	bgeu	a5,a0,800039d4 <_ZL9fibonaccim+0x50>
    if (n % 10 == 0) { thread_dispatch(); }
    800039a8:	00a00793          	li	a5,10
    800039ac:	02f577b3          	remu	a5,a0,a5
    800039b0:	02078e63          	beqz	a5,800039ec <_ZL9fibonaccim+0x68>
    return fibonacci(n - 1) + fibonacci(n - 2);
    800039b4:	fff48513          	addi	a0,s1,-1
    800039b8:	00000097          	auipc	ra,0x0
    800039bc:	fcc080e7          	jalr	-52(ra) # 80003984 <_ZL9fibonaccim>
    800039c0:	00050913          	mv	s2,a0
    800039c4:	ffe48513          	addi	a0,s1,-2
    800039c8:	00000097          	auipc	ra,0x0
    800039cc:	fbc080e7          	jalr	-68(ra) # 80003984 <_ZL9fibonaccim>
    800039d0:	00a90533          	add	a0,s2,a0
}
    800039d4:	01813083          	ld	ra,24(sp)
    800039d8:	01013403          	ld	s0,16(sp)
    800039dc:	00813483          	ld	s1,8(sp)
    800039e0:	00013903          	ld	s2,0(sp)
    800039e4:	02010113          	addi	sp,sp,32
    800039e8:	00008067          	ret
    if (n % 10 == 0) { thread_dispatch(); }
    800039ec:	00001097          	auipc	ra,0x1
    800039f0:	544080e7          	jalr	1348(ra) # 80004f30 <_Z15thread_dispatchv>
    800039f4:	fc1ff06f          	j	800039b4 <_ZL9fibonaccim+0x30>

00000000800039f8 <_ZL11workerBodyDPv>:
    printString("A finished!\n");
    finishedC = true;
    thread_dispatch();
}

static void workerBodyD(void* arg) {
    800039f8:	fe010113          	addi	sp,sp,-32
    800039fc:	00113c23          	sd	ra,24(sp)
    80003a00:	00813823          	sd	s0,16(sp)
    80003a04:	00913423          	sd	s1,8(sp)
    80003a08:	01213023          	sd	s2,0(sp)
    80003a0c:	02010413          	addi	s0,sp,32
    uint8 i = 10;
    80003a10:	00a00493          	li	s1,10
    80003a14:	0400006f          	j	80003a54 <_ZL11workerBodyDPv+0x5c>
    for (; i < 13; i++) {
        printString("D: i="); printInt(i); printString("\n");
    80003a18:	00005517          	auipc	a0,0x5
    80003a1c:	76850513          	addi	a0,a0,1896 # 80009180 <_ZTV12ConsumerSync+0x28>
    80003a20:	ffffe097          	auipc	ra,0xffffe
    80003a24:	68c080e7          	jalr	1676(ra) # 800020ac <_Z11printStringPKc>
    80003a28:	00000613          	li	a2,0
    80003a2c:	00a00593          	li	a1,10
    80003a30:	00048513          	mv	a0,s1
    80003a34:	fffff097          	auipc	ra,0xfffff
    80003a38:	828080e7          	jalr	-2008(ra) # 8000225c <_Z8printIntiii>
    80003a3c:	00006517          	auipc	a0,0x6
    80003a40:	99450513          	addi	a0,a0,-1644 # 800093d0 <_ZTV12ConsumerSync+0x278>
    80003a44:	ffffe097          	auipc	ra,0xffffe
    80003a48:	668080e7          	jalr	1640(ra) # 800020ac <_Z11printStringPKc>
    for (; i < 13; i++) {
    80003a4c:	0014849b          	addiw	s1,s1,1
    80003a50:	0ff4f493          	andi	s1,s1,255
    80003a54:	00c00793          	li	a5,12
    80003a58:	fc97f0e3          	bgeu	a5,s1,80003a18 <_ZL11workerBodyDPv+0x20>
    }

    printString("D: dispatch\n");
    80003a5c:	00005517          	auipc	a0,0x5
    80003a60:	72c50513          	addi	a0,a0,1836 # 80009188 <_ZTV12ConsumerSync+0x30>
    80003a64:	ffffe097          	auipc	ra,0xffffe
    80003a68:	648080e7          	jalr	1608(ra) # 800020ac <_Z11printStringPKc>
    __asm__ ("li t1, 5");
    80003a6c:	00500313          	li	t1,5
    thread_dispatch();
    80003a70:	00001097          	auipc	ra,0x1
    80003a74:	4c0080e7          	jalr	1216(ra) # 80004f30 <_Z15thread_dispatchv>

    uint64 result = fibonacci(16);
    80003a78:	01000513          	li	a0,16
    80003a7c:	00000097          	auipc	ra,0x0
    80003a80:	f08080e7          	jalr	-248(ra) # 80003984 <_ZL9fibonaccim>
    80003a84:	00050913          	mv	s2,a0
    printString("D: fibonaci="); printInt(result); printString("\n");
    80003a88:	00005517          	auipc	a0,0x5
    80003a8c:	71050513          	addi	a0,a0,1808 # 80009198 <_ZTV12ConsumerSync+0x40>
    80003a90:	ffffe097          	auipc	ra,0xffffe
    80003a94:	61c080e7          	jalr	1564(ra) # 800020ac <_Z11printStringPKc>
    80003a98:	00000613          	li	a2,0
    80003a9c:	00a00593          	li	a1,10
    80003aa0:	0009051b          	sext.w	a0,s2
    80003aa4:	ffffe097          	auipc	ra,0xffffe
    80003aa8:	7b8080e7          	jalr	1976(ra) # 8000225c <_Z8printIntiii>
    80003aac:	00006517          	auipc	a0,0x6
    80003ab0:	92450513          	addi	a0,a0,-1756 # 800093d0 <_ZTV12ConsumerSync+0x278>
    80003ab4:	ffffe097          	auipc	ra,0xffffe
    80003ab8:	5f8080e7          	jalr	1528(ra) # 800020ac <_Z11printStringPKc>
    80003abc:	0400006f          	j	80003afc <_ZL11workerBodyDPv+0x104>

    for (; i < 16; i++) {
        printString("D: i="); printInt(i); printString("\n");
    80003ac0:	00005517          	auipc	a0,0x5
    80003ac4:	6c050513          	addi	a0,a0,1728 # 80009180 <_ZTV12ConsumerSync+0x28>
    80003ac8:	ffffe097          	auipc	ra,0xffffe
    80003acc:	5e4080e7          	jalr	1508(ra) # 800020ac <_Z11printStringPKc>
    80003ad0:	00000613          	li	a2,0
    80003ad4:	00a00593          	li	a1,10
    80003ad8:	00048513          	mv	a0,s1
    80003adc:	ffffe097          	auipc	ra,0xffffe
    80003ae0:	780080e7          	jalr	1920(ra) # 8000225c <_Z8printIntiii>
    80003ae4:	00006517          	auipc	a0,0x6
    80003ae8:	8ec50513          	addi	a0,a0,-1812 # 800093d0 <_ZTV12ConsumerSync+0x278>
    80003aec:	ffffe097          	auipc	ra,0xffffe
    80003af0:	5c0080e7          	jalr	1472(ra) # 800020ac <_Z11printStringPKc>
    for (; i < 16; i++) {
    80003af4:	0014849b          	addiw	s1,s1,1
    80003af8:	0ff4f493          	andi	s1,s1,255
    80003afc:	00f00793          	li	a5,15
    80003b00:	fc97f0e3          	bgeu	a5,s1,80003ac0 <_ZL11workerBodyDPv+0xc8>
    }

    printString("D finished!\n");
    80003b04:	00005517          	auipc	a0,0x5
    80003b08:	6a450513          	addi	a0,a0,1700 # 800091a8 <_ZTV12ConsumerSync+0x50>
    80003b0c:	ffffe097          	auipc	ra,0xffffe
    80003b10:	5a0080e7          	jalr	1440(ra) # 800020ac <_Z11printStringPKc>
    finishedD = true;
    80003b14:	00100793          	li	a5,1
    80003b18:	00008717          	auipc	a4,0x8
    80003b1c:	18f70823          	sb	a5,400(a4) # 8000bca8 <_ZL9finishedD>
    thread_dispatch();
    80003b20:	00001097          	auipc	ra,0x1
    80003b24:	410080e7          	jalr	1040(ra) # 80004f30 <_Z15thread_dispatchv>
}
    80003b28:	01813083          	ld	ra,24(sp)
    80003b2c:	01013403          	ld	s0,16(sp)
    80003b30:	00813483          	ld	s1,8(sp)
    80003b34:	00013903          	ld	s2,0(sp)
    80003b38:	02010113          	addi	sp,sp,32
    80003b3c:	00008067          	ret

0000000080003b40 <_ZL11workerBodyCPv>:
static void workerBodyC(void* arg) {
    80003b40:	fe010113          	addi	sp,sp,-32
    80003b44:	00113c23          	sd	ra,24(sp)
    80003b48:	00813823          	sd	s0,16(sp)
    80003b4c:	00913423          	sd	s1,8(sp)
    80003b50:	01213023          	sd	s2,0(sp)
    80003b54:	02010413          	addi	s0,sp,32
    uint8 i = 0;
    80003b58:	00000493          	li	s1,0
    80003b5c:	0400006f          	j	80003b9c <_ZL11workerBodyCPv+0x5c>
        printString("C: i="); printInt(i); printString("\n");
    80003b60:	00005517          	auipc	a0,0x5
    80003b64:	65850513          	addi	a0,a0,1624 # 800091b8 <_ZTV12ConsumerSync+0x60>
    80003b68:	ffffe097          	auipc	ra,0xffffe
    80003b6c:	544080e7          	jalr	1348(ra) # 800020ac <_Z11printStringPKc>
    80003b70:	00000613          	li	a2,0
    80003b74:	00a00593          	li	a1,10
    80003b78:	00048513          	mv	a0,s1
    80003b7c:	ffffe097          	auipc	ra,0xffffe
    80003b80:	6e0080e7          	jalr	1760(ra) # 8000225c <_Z8printIntiii>
    80003b84:	00006517          	auipc	a0,0x6
    80003b88:	84c50513          	addi	a0,a0,-1972 # 800093d0 <_ZTV12ConsumerSync+0x278>
    80003b8c:	ffffe097          	auipc	ra,0xffffe
    80003b90:	520080e7          	jalr	1312(ra) # 800020ac <_Z11printStringPKc>
    for (; i < 3; i++) {
    80003b94:	0014849b          	addiw	s1,s1,1
    80003b98:	0ff4f493          	andi	s1,s1,255
    80003b9c:	00200793          	li	a5,2
    80003ba0:	fc97f0e3          	bgeu	a5,s1,80003b60 <_ZL11workerBodyCPv+0x20>
    printString("C: dispatch\n");
    80003ba4:	00005517          	auipc	a0,0x5
    80003ba8:	61c50513          	addi	a0,a0,1564 # 800091c0 <_ZTV12ConsumerSync+0x68>
    80003bac:	ffffe097          	auipc	ra,0xffffe
    80003bb0:	500080e7          	jalr	1280(ra) # 800020ac <_Z11printStringPKc>
    __asm__ ("li t1, 7");
    80003bb4:	00700313          	li	t1,7
    thread_dispatch();
    80003bb8:	00001097          	auipc	ra,0x1
    80003bbc:	378080e7          	jalr	888(ra) # 80004f30 <_Z15thread_dispatchv>
    __asm__ ("mv %[t1], t1" : [t1] "=r"(t1));
    80003bc0:	00030913          	mv	s2,t1
    printString("C: t1="); printInt(t1); printString("\n");
    80003bc4:	00005517          	auipc	a0,0x5
    80003bc8:	60c50513          	addi	a0,a0,1548 # 800091d0 <_ZTV12ConsumerSync+0x78>
    80003bcc:	ffffe097          	auipc	ra,0xffffe
    80003bd0:	4e0080e7          	jalr	1248(ra) # 800020ac <_Z11printStringPKc>
    80003bd4:	00000613          	li	a2,0
    80003bd8:	00a00593          	li	a1,10
    80003bdc:	0009051b          	sext.w	a0,s2
    80003be0:	ffffe097          	auipc	ra,0xffffe
    80003be4:	67c080e7          	jalr	1660(ra) # 8000225c <_Z8printIntiii>
    80003be8:	00005517          	auipc	a0,0x5
    80003bec:	7e850513          	addi	a0,a0,2024 # 800093d0 <_ZTV12ConsumerSync+0x278>
    80003bf0:	ffffe097          	auipc	ra,0xffffe
    80003bf4:	4bc080e7          	jalr	1212(ra) # 800020ac <_Z11printStringPKc>
    uint64 result = fibonacci(12);
    80003bf8:	00c00513          	li	a0,12
    80003bfc:	00000097          	auipc	ra,0x0
    80003c00:	d88080e7          	jalr	-632(ra) # 80003984 <_ZL9fibonaccim>
    80003c04:	00050913          	mv	s2,a0
    printString("C: fibonaci="); printInt(result); printString("\n");
    80003c08:	00005517          	auipc	a0,0x5
    80003c0c:	5d050513          	addi	a0,a0,1488 # 800091d8 <_ZTV12ConsumerSync+0x80>
    80003c10:	ffffe097          	auipc	ra,0xffffe
    80003c14:	49c080e7          	jalr	1180(ra) # 800020ac <_Z11printStringPKc>
    80003c18:	00000613          	li	a2,0
    80003c1c:	00a00593          	li	a1,10
    80003c20:	0009051b          	sext.w	a0,s2
    80003c24:	ffffe097          	auipc	ra,0xffffe
    80003c28:	638080e7          	jalr	1592(ra) # 8000225c <_Z8printIntiii>
    80003c2c:	00005517          	auipc	a0,0x5
    80003c30:	7a450513          	addi	a0,a0,1956 # 800093d0 <_ZTV12ConsumerSync+0x278>
    80003c34:	ffffe097          	auipc	ra,0xffffe
    80003c38:	478080e7          	jalr	1144(ra) # 800020ac <_Z11printStringPKc>
    80003c3c:	0400006f          	j	80003c7c <_ZL11workerBodyCPv+0x13c>
        printString("C: i="); printInt(i); printString("\n");
    80003c40:	00005517          	auipc	a0,0x5
    80003c44:	57850513          	addi	a0,a0,1400 # 800091b8 <_ZTV12ConsumerSync+0x60>
    80003c48:	ffffe097          	auipc	ra,0xffffe
    80003c4c:	464080e7          	jalr	1124(ra) # 800020ac <_Z11printStringPKc>
    80003c50:	00000613          	li	a2,0
    80003c54:	00a00593          	li	a1,10
    80003c58:	00048513          	mv	a0,s1
    80003c5c:	ffffe097          	auipc	ra,0xffffe
    80003c60:	600080e7          	jalr	1536(ra) # 8000225c <_Z8printIntiii>
    80003c64:	00005517          	auipc	a0,0x5
    80003c68:	76c50513          	addi	a0,a0,1900 # 800093d0 <_ZTV12ConsumerSync+0x278>
    80003c6c:	ffffe097          	auipc	ra,0xffffe
    80003c70:	440080e7          	jalr	1088(ra) # 800020ac <_Z11printStringPKc>
    for (; i < 6; i++) {
    80003c74:	0014849b          	addiw	s1,s1,1
    80003c78:	0ff4f493          	andi	s1,s1,255
    80003c7c:	00500793          	li	a5,5
    80003c80:	fc97f0e3          	bgeu	a5,s1,80003c40 <_ZL11workerBodyCPv+0x100>
    printString("A finished!\n");
    80003c84:	00005517          	auipc	a0,0x5
    80003c88:	56450513          	addi	a0,a0,1380 # 800091e8 <_ZTV12ConsumerSync+0x90>
    80003c8c:	ffffe097          	auipc	ra,0xffffe
    80003c90:	420080e7          	jalr	1056(ra) # 800020ac <_Z11printStringPKc>
    finishedC = true;
    80003c94:	00100793          	li	a5,1
    80003c98:	00008717          	auipc	a4,0x8
    80003c9c:	00f708a3          	sb	a5,17(a4) # 8000bca9 <_ZL9finishedC>
    thread_dispatch();
    80003ca0:	00001097          	auipc	ra,0x1
    80003ca4:	290080e7          	jalr	656(ra) # 80004f30 <_Z15thread_dispatchv>
}
    80003ca8:	01813083          	ld	ra,24(sp)
    80003cac:	01013403          	ld	s0,16(sp)
    80003cb0:	00813483          	ld	s1,8(sp)
    80003cb4:	00013903          	ld	s2,0(sp)
    80003cb8:	02010113          	addi	sp,sp,32
    80003cbc:	00008067          	ret

0000000080003cc0 <_ZL11workerBodyBPv>:
static void workerBodyB(void* arg) {
    80003cc0:	fe010113          	addi	sp,sp,-32
    80003cc4:	00113c23          	sd	ra,24(sp)
    80003cc8:	00813823          	sd	s0,16(sp)
    80003ccc:	00913423          	sd	s1,8(sp)
    80003cd0:	01213023          	sd	s2,0(sp)
    80003cd4:	02010413          	addi	s0,sp,32
    for (uint64 i = 0; i < 16; i++) {
    80003cd8:	00000913          	li	s2,0
    80003cdc:	0400006f          	j	80003d1c <_ZL11workerBodyBPv+0x5c>
            thread_dispatch();
    80003ce0:	00001097          	auipc	ra,0x1
    80003ce4:	250080e7          	jalr	592(ra) # 80004f30 <_Z15thread_dispatchv>
        for (uint64 j = 0; j < 10000; j++) {
    80003ce8:	00148493          	addi	s1,s1,1
    80003cec:	000027b7          	lui	a5,0x2
    80003cf0:	70f78793          	addi	a5,a5,1807 # 270f <_entry-0x7fffd8f1>
    80003cf4:	0097ee63          	bltu	a5,s1,80003d10 <_ZL11workerBodyBPv+0x50>
            for (uint64 k = 0; k < 30000; k++) { /* busy wait */ }
    80003cf8:	00000713          	li	a4,0
    80003cfc:	000077b7          	lui	a5,0x7
    80003d00:	52f78793          	addi	a5,a5,1327 # 752f <_entry-0x7fff8ad1>
    80003d04:	fce7eee3          	bltu	a5,a4,80003ce0 <_ZL11workerBodyBPv+0x20>
    80003d08:	00170713          	addi	a4,a4,1
    80003d0c:	ff1ff06f          	j	80003cfc <_ZL11workerBodyBPv+0x3c>
        if (i == 10) {
    80003d10:	00a00793          	li	a5,10
    80003d14:	04f90663          	beq	s2,a5,80003d60 <_ZL11workerBodyBPv+0xa0>
    for (uint64 i = 0; i < 16; i++) {
    80003d18:	00190913          	addi	s2,s2,1
    80003d1c:	00f00793          	li	a5,15
    80003d20:	0527e463          	bltu	a5,s2,80003d68 <_ZL11workerBodyBPv+0xa8>
        printString("B: i="); printInt(i); printString("\n");
    80003d24:	00005517          	auipc	a0,0x5
    80003d28:	4d450513          	addi	a0,a0,1236 # 800091f8 <_ZTV12ConsumerSync+0xa0>
    80003d2c:	ffffe097          	auipc	ra,0xffffe
    80003d30:	380080e7          	jalr	896(ra) # 800020ac <_Z11printStringPKc>
    80003d34:	00000613          	li	a2,0
    80003d38:	00a00593          	li	a1,10
    80003d3c:	0009051b          	sext.w	a0,s2
    80003d40:	ffffe097          	auipc	ra,0xffffe
    80003d44:	51c080e7          	jalr	1308(ra) # 8000225c <_Z8printIntiii>
    80003d48:	00005517          	auipc	a0,0x5
    80003d4c:	68850513          	addi	a0,a0,1672 # 800093d0 <_ZTV12ConsumerSync+0x278>
    80003d50:	ffffe097          	auipc	ra,0xffffe
    80003d54:	35c080e7          	jalr	860(ra) # 800020ac <_Z11printStringPKc>
        for (uint64 j = 0; j < 10000; j++) {
    80003d58:	00000493          	li	s1,0
    80003d5c:	f91ff06f          	j	80003cec <_ZL11workerBodyBPv+0x2c>
            asm volatile("csrr t6, sepc");
    80003d60:	14102ff3          	csrr	t6,sepc
    80003d64:	fb5ff06f          	j	80003d18 <_ZL11workerBodyBPv+0x58>
    printString("B finished!\n");
    80003d68:	00005517          	auipc	a0,0x5
    80003d6c:	49850513          	addi	a0,a0,1176 # 80009200 <_ZTV12ConsumerSync+0xa8>
    80003d70:	ffffe097          	auipc	ra,0xffffe
    80003d74:	33c080e7          	jalr	828(ra) # 800020ac <_Z11printStringPKc>
    finishedB = true;
    80003d78:	00100793          	li	a5,1
    80003d7c:	00008717          	auipc	a4,0x8
    80003d80:	f2f70723          	sb	a5,-210(a4) # 8000bcaa <_ZL9finishedB>
    thread_dispatch();
    80003d84:	00001097          	auipc	ra,0x1
    80003d88:	1ac080e7          	jalr	428(ra) # 80004f30 <_Z15thread_dispatchv>
}
    80003d8c:	01813083          	ld	ra,24(sp)
    80003d90:	01013403          	ld	s0,16(sp)
    80003d94:	00813483          	ld	s1,8(sp)
    80003d98:	00013903          	ld	s2,0(sp)
    80003d9c:	02010113          	addi	sp,sp,32
    80003da0:	00008067          	ret

0000000080003da4 <_ZL11workerBodyAPv>:
static void workerBodyA(void* arg) {
    80003da4:	fe010113          	addi	sp,sp,-32
    80003da8:	00113c23          	sd	ra,24(sp)
    80003dac:	00813823          	sd	s0,16(sp)
    80003db0:	00913423          	sd	s1,8(sp)
    80003db4:	01213023          	sd	s2,0(sp)
    80003db8:	02010413          	addi	s0,sp,32
    for (uint64 i = 0; i < 10; i++) {
    80003dbc:	00000913          	li	s2,0
    80003dc0:	0380006f          	j	80003df8 <_ZL11workerBodyAPv+0x54>
            thread_dispatch();
    80003dc4:	00001097          	auipc	ra,0x1
    80003dc8:	16c080e7          	jalr	364(ra) # 80004f30 <_Z15thread_dispatchv>
        for (uint64 j = 0; j < 10000; j++) {
    80003dcc:	00148493          	addi	s1,s1,1
    80003dd0:	000027b7          	lui	a5,0x2
    80003dd4:	70f78793          	addi	a5,a5,1807 # 270f <_entry-0x7fffd8f1>
    80003dd8:	0097ee63          	bltu	a5,s1,80003df4 <_ZL11workerBodyAPv+0x50>
            for (uint64 k = 0; k < 30000; k++) { /* busy wait */ }
    80003ddc:	00000713          	li	a4,0
    80003de0:	000077b7          	lui	a5,0x7
    80003de4:	52f78793          	addi	a5,a5,1327 # 752f <_entry-0x7fff8ad1>
    80003de8:	fce7eee3          	bltu	a5,a4,80003dc4 <_ZL11workerBodyAPv+0x20>
    80003dec:	00170713          	addi	a4,a4,1
    80003df0:	ff1ff06f          	j	80003de0 <_ZL11workerBodyAPv+0x3c>
    for (uint64 i = 0; i < 10; i++) {
    80003df4:	00190913          	addi	s2,s2,1
    80003df8:	00900793          	li	a5,9
    80003dfc:	0527e063          	bltu	a5,s2,80003e3c <_ZL11workerBodyAPv+0x98>
        printString("A: i="); printInt(i); printString("\n");
    80003e00:	00005517          	auipc	a0,0x5
    80003e04:	41050513          	addi	a0,a0,1040 # 80009210 <_ZTV12ConsumerSync+0xb8>
    80003e08:	ffffe097          	auipc	ra,0xffffe
    80003e0c:	2a4080e7          	jalr	676(ra) # 800020ac <_Z11printStringPKc>
    80003e10:	00000613          	li	a2,0
    80003e14:	00a00593          	li	a1,10
    80003e18:	0009051b          	sext.w	a0,s2
    80003e1c:	ffffe097          	auipc	ra,0xffffe
    80003e20:	440080e7          	jalr	1088(ra) # 8000225c <_Z8printIntiii>
    80003e24:	00005517          	auipc	a0,0x5
    80003e28:	5ac50513          	addi	a0,a0,1452 # 800093d0 <_ZTV12ConsumerSync+0x278>
    80003e2c:	ffffe097          	auipc	ra,0xffffe
    80003e30:	280080e7          	jalr	640(ra) # 800020ac <_Z11printStringPKc>
        for (uint64 j = 0; j < 10000; j++) {
    80003e34:	00000493          	li	s1,0
    80003e38:	f99ff06f          	j	80003dd0 <_ZL11workerBodyAPv+0x2c>
    printString("A finished!\n");
    80003e3c:	00005517          	auipc	a0,0x5
    80003e40:	3ac50513          	addi	a0,a0,940 # 800091e8 <_ZTV12ConsumerSync+0x90>
    80003e44:	ffffe097          	auipc	ra,0xffffe
    80003e48:	268080e7          	jalr	616(ra) # 800020ac <_Z11printStringPKc>
    finishedA = true;
    80003e4c:	00100793          	li	a5,1
    80003e50:	00008717          	auipc	a4,0x8
    80003e54:	e4f70da3          	sb	a5,-421(a4) # 8000bcab <_ZL9finishedA>
}
    80003e58:	01813083          	ld	ra,24(sp)
    80003e5c:	01013403          	ld	s0,16(sp)
    80003e60:	00813483          	ld	s1,8(sp)
    80003e64:	00013903          	ld	s2,0(sp)
    80003e68:	02010113          	addi	sp,sp,32
    80003e6c:	00008067          	ret

0000000080003e70 <_Z16System_Mode_testv>:


void System_Mode_test() {
    80003e70:	fd010113          	addi	sp,sp,-48
    80003e74:	02113423          	sd	ra,40(sp)
    80003e78:	02813023          	sd	s0,32(sp)
    80003e7c:	03010413          	addi	s0,sp,48
    thread_t threads[4];
    thread_create(&threads[0], workerBodyA, nullptr);
    80003e80:	00000613          	li	a2,0
    80003e84:	00000597          	auipc	a1,0x0
    80003e88:	f2058593          	addi	a1,a1,-224 # 80003da4 <_ZL11workerBodyAPv>
    80003e8c:	fd040513          	addi	a0,s0,-48
    80003e90:	00001097          	auipc	ra,0x1
    80003e94:	fd8080e7          	jalr	-40(ra) # 80004e68 <_Z13thread_createPP3TCBPFvPvES2_>
    printString("ThreadA created\n");
    80003e98:	00005517          	auipc	a0,0x5
    80003e9c:	38050513          	addi	a0,a0,896 # 80009218 <_ZTV12ConsumerSync+0xc0>
    80003ea0:	ffffe097          	auipc	ra,0xffffe
    80003ea4:	20c080e7          	jalr	524(ra) # 800020ac <_Z11printStringPKc>

    thread_create(&threads[1], workerBodyB, nullptr);
    80003ea8:	00000613          	li	a2,0
    80003eac:	00000597          	auipc	a1,0x0
    80003eb0:	e1458593          	addi	a1,a1,-492 # 80003cc0 <_ZL11workerBodyBPv>
    80003eb4:	fd840513          	addi	a0,s0,-40
    80003eb8:	00001097          	auipc	ra,0x1
    80003ebc:	fb0080e7          	jalr	-80(ra) # 80004e68 <_Z13thread_createPP3TCBPFvPvES2_>
    printString("ThreadB created\n");
    80003ec0:	00005517          	auipc	a0,0x5
    80003ec4:	37050513          	addi	a0,a0,880 # 80009230 <_ZTV12ConsumerSync+0xd8>
    80003ec8:	ffffe097          	auipc	ra,0xffffe
    80003ecc:	1e4080e7          	jalr	484(ra) # 800020ac <_Z11printStringPKc>

    thread_create(&threads[2], workerBodyC, nullptr);
    80003ed0:	00000613          	li	a2,0
    80003ed4:	00000597          	auipc	a1,0x0
    80003ed8:	c6c58593          	addi	a1,a1,-916 # 80003b40 <_ZL11workerBodyCPv>
    80003edc:	fe040513          	addi	a0,s0,-32
    80003ee0:	00001097          	auipc	ra,0x1
    80003ee4:	f88080e7          	jalr	-120(ra) # 80004e68 <_Z13thread_createPP3TCBPFvPvES2_>
    printString("ThreadC created\n");
    80003ee8:	00005517          	auipc	a0,0x5
    80003eec:	36050513          	addi	a0,a0,864 # 80009248 <_ZTV12ConsumerSync+0xf0>
    80003ef0:	ffffe097          	auipc	ra,0xffffe
    80003ef4:	1bc080e7          	jalr	444(ra) # 800020ac <_Z11printStringPKc>

    thread_create(&threads[3], workerBodyD, nullptr);
    80003ef8:	00000613          	li	a2,0
    80003efc:	00000597          	auipc	a1,0x0
    80003f00:	afc58593          	addi	a1,a1,-1284 # 800039f8 <_ZL11workerBodyDPv>
    80003f04:	fe840513          	addi	a0,s0,-24
    80003f08:	00001097          	auipc	ra,0x1
    80003f0c:	f60080e7          	jalr	-160(ra) # 80004e68 <_Z13thread_createPP3TCBPFvPvES2_>
    printString("ThreadD created\n");
    80003f10:	00005517          	auipc	a0,0x5
    80003f14:	35050513          	addi	a0,a0,848 # 80009260 <_ZTV12ConsumerSync+0x108>
    80003f18:	ffffe097          	auipc	ra,0xffffe
    80003f1c:	194080e7          	jalr	404(ra) # 800020ac <_Z11printStringPKc>
    80003f20:	00c0006f          	j	80003f2c <_Z16System_Mode_testv+0xbc>

    while (!(finishedA && finishedB && finishedC && finishedD)) {
        thread_dispatch();
    80003f24:	00001097          	auipc	ra,0x1
    80003f28:	00c080e7          	jalr	12(ra) # 80004f30 <_Z15thread_dispatchv>
    while (!(finishedA && finishedB && finishedC && finishedD)) {
    80003f2c:	00008797          	auipc	a5,0x8
    80003f30:	d7f7c783          	lbu	a5,-641(a5) # 8000bcab <_ZL9finishedA>
    80003f34:	fe0788e3          	beqz	a5,80003f24 <_Z16System_Mode_testv+0xb4>
    80003f38:	00008797          	auipc	a5,0x8
    80003f3c:	d727c783          	lbu	a5,-654(a5) # 8000bcaa <_ZL9finishedB>
    80003f40:	fe0782e3          	beqz	a5,80003f24 <_Z16System_Mode_testv+0xb4>
    80003f44:	00008797          	auipc	a5,0x8
    80003f48:	d657c783          	lbu	a5,-667(a5) # 8000bca9 <_ZL9finishedC>
    80003f4c:	fc078ce3          	beqz	a5,80003f24 <_Z16System_Mode_testv+0xb4>
    80003f50:	00008797          	auipc	a5,0x8
    80003f54:	d587c783          	lbu	a5,-680(a5) # 8000bca8 <_ZL9finishedD>
    80003f58:	fc0786e3          	beqz	a5,80003f24 <_Z16System_Mode_testv+0xb4>
    }

}
    80003f5c:	02813083          	ld	ra,40(sp)
    80003f60:	02013403          	ld	s0,32(sp)
    80003f64:	03010113          	addi	sp,sp,48
    80003f68:	00008067          	ret

0000000080003f6c <_ZL9fibonaccim>:
static volatile bool finishedA = false;
static volatile bool finishedB = false;
static volatile bool finishedC = false;
static volatile bool finishedD = false;

static uint64 fibonacci(uint64 n) {
    80003f6c:	fe010113          	addi	sp,sp,-32
    80003f70:	00113c23          	sd	ra,24(sp)
    80003f74:	00813823          	sd	s0,16(sp)
    80003f78:	00913423          	sd	s1,8(sp)
    80003f7c:	01213023          	sd	s2,0(sp)
    80003f80:	02010413          	addi	s0,sp,32
    80003f84:	00050493          	mv	s1,a0
    if (n == 0 || n == 1) { return n; }
    80003f88:	00100793          	li	a5,1
    80003f8c:	02a7f863          	bgeu	a5,a0,80003fbc <_ZL9fibonaccim+0x50>
    if (n % 10 == 0) { thread_dispatch(); }
    80003f90:	00a00793          	li	a5,10
    80003f94:	02f577b3          	remu	a5,a0,a5
    80003f98:	02078e63          	beqz	a5,80003fd4 <_ZL9fibonaccim+0x68>
    return fibonacci(n - 1) + fibonacci(n - 2);
    80003f9c:	fff48513          	addi	a0,s1,-1
    80003fa0:	00000097          	auipc	ra,0x0
    80003fa4:	fcc080e7          	jalr	-52(ra) # 80003f6c <_ZL9fibonaccim>
    80003fa8:	00050913          	mv	s2,a0
    80003fac:	ffe48513          	addi	a0,s1,-2
    80003fb0:	00000097          	auipc	ra,0x0
    80003fb4:	fbc080e7          	jalr	-68(ra) # 80003f6c <_ZL9fibonaccim>
    80003fb8:	00a90533          	add	a0,s2,a0
}
    80003fbc:	01813083          	ld	ra,24(sp)
    80003fc0:	01013403          	ld	s0,16(sp)
    80003fc4:	00813483          	ld	s1,8(sp)
    80003fc8:	00013903          	ld	s2,0(sp)
    80003fcc:	02010113          	addi	sp,sp,32
    80003fd0:	00008067          	ret
    if (n % 10 == 0) { thread_dispatch(); }
    80003fd4:	00001097          	auipc	ra,0x1
    80003fd8:	f5c080e7          	jalr	-164(ra) # 80004f30 <_Z15thread_dispatchv>
    80003fdc:	fc1ff06f          	j	80003f9c <_ZL9fibonaccim+0x30>

0000000080003fe0 <_ZN7WorkerA11workerBodyAEPv>:
    void run() override {
        workerBodyD(nullptr);
    }
};

void WorkerA::workerBodyA(void *arg) {
    80003fe0:	fe010113          	addi	sp,sp,-32
    80003fe4:	00113c23          	sd	ra,24(sp)
    80003fe8:	00813823          	sd	s0,16(sp)
    80003fec:	00913423          	sd	s1,8(sp)
    80003ff0:	01213023          	sd	s2,0(sp)
    80003ff4:	02010413          	addi	s0,sp,32
    for (uint64 i = 0; i < 10; i++) {
    80003ff8:	00000913          	li	s2,0
    80003ffc:	0380006f          	j	80004034 <_ZN7WorkerA11workerBodyAEPv+0x54>
        printString("A: i="); printInt(i); printString("\n");
        for (uint64 j = 0; j < 10000; j++) {
            for (uint64 k = 0; k < 30000; k++) { /* busy wait */ }
            thread_dispatch();
    80004000:	00001097          	auipc	ra,0x1
    80004004:	f30080e7          	jalr	-208(ra) # 80004f30 <_Z15thread_dispatchv>
        for (uint64 j = 0; j < 10000; j++) {
    80004008:	00148493          	addi	s1,s1,1
    8000400c:	000027b7          	lui	a5,0x2
    80004010:	70f78793          	addi	a5,a5,1807 # 270f <_entry-0x7fffd8f1>
    80004014:	0097ee63          	bltu	a5,s1,80004030 <_ZN7WorkerA11workerBodyAEPv+0x50>
            for (uint64 k = 0; k < 30000; k++) { /* busy wait */ }
    80004018:	00000713          	li	a4,0
    8000401c:	000077b7          	lui	a5,0x7
    80004020:	52f78793          	addi	a5,a5,1327 # 752f <_entry-0x7fff8ad1>
    80004024:	fce7eee3          	bltu	a5,a4,80004000 <_ZN7WorkerA11workerBodyAEPv+0x20>
    80004028:	00170713          	addi	a4,a4,1
    8000402c:	ff1ff06f          	j	8000401c <_ZN7WorkerA11workerBodyAEPv+0x3c>
    for (uint64 i = 0; i < 10; i++) {
    80004030:	00190913          	addi	s2,s2,1
    80004034:	00900793          	li	a5,9
    80004038:	0527e063          	bltu	a5,s2,80004078 <_ZN7WorkerA11workerBodyAEPv+0x98>
        printString("A: i="); printInt(i); printString("\n");
    8000403c:	00005517          	auipc	a0,0x5
    80004040:	1d450513          	addi	a0,a0,468 # 80009210 <_ZTV12ConsumerSync+0xb8>
    80004044:	ffffe097          	auipc	ra,0xffffe
    80004048:	068080e7          	jalr	104(ra) # 800020ac <_Z11printStringPKc>
    8000404c:	00000613          	li	a2,0
    80004050:	00a00593          	li	a1,10
    80004054:	0009051b          	sext.w	a0,s2
    80004058:	ffffe097          	auipc	ra,0xffffe
    8000405c:	204080e7          	jalr	516(ra) # 8000225c <_Z8printIntiii>
    80004060:	00005517          	auipc	a0,0x5
    80004064:	37050513          	addi	a0,a0,880 # 800093d0 <_ZTV12ConsumerSync+0x278>
    80004068:	ffffe097          	auipc	ra,0xffffe
    8000406c:	044080e7          	jalr	68(ra) # 800020ac <_Z11printStringPKc>
        for (uint64 j = 0; j < 10000; j++) {
    80004070:	00000493          	li	s1,0
    80004074:	f99ff06f          	j	8000400c <_ZN7WorkerA11workerBodyAEPv+0x2c>
        }
    }
    printString("A finished!\n");
    80004078:	00005517          	auipc	a0,0x5
    8000407c:	17050513          	addi	a0,a0,368 # 800091e8 <_ZTV12ConsumerSync+0x90>
    80004080:	ffffe097          	auipc	ra,0xffffe
    80004084:	02c080e7          	jalr	44(ra) # 800020ac <_Z11printStringPKc>
    finishedA = true;
    80004088:	00100793          	li	a5,1
    8000408c:	00008717          	auipc	a4,0x8
    80004090:	c2f701a3          	sb	a5,-989(a4) # 8000bcaf <_ZL9finishedA>
}
    80004094:	01813083          	ld	ra,24(sp)
    80004098:	01013403          	ld	s0,16(sp)
    8000409c:	00813483          	ld	s1,8(sp)
    800040a0:	00013903          	ld	s2,0(sp)
    800040a4:	02010113          	addi	sp,sp,32
    800040a8:	00008067          	ret

00000000800040ac <_ZN7WorkerB11workerBodyBEPv>:

void WorkerB::workerBodyB(void *arg) {
    800040ac:	fe010113          	addi	sp,sp,-32
    800040b0:	00113c23          	sd	ra,24(sp)
    800040b4:	00813823          	sd	s0,16(sp)
    800040b8:	00913423          	sd	s1,8(sp)
    800040bc:	01213023          	sd	s2,0(sp)
    800040c0:	02010413          	addi	s0,sp,32
    for (uint64 i = 0; i < 16; i++) {
    800040c4:	00000913          	li	s2,0
    800040c8:	0380006f          	j	80004100 <_ZN7WorkerB11workerBodyBEPv+0x54>
        printString("B: i="); printInt(i); printString("\n");
        for (uint64 j = 0; j < 10000; j++) {
            for (uint64 k = 0; k < 30000; k++) { /* busy wait */ }
            thread_dispatch();
    800040cc:	00001097          	auipc	ra,0x1
    800040d0:	e64080e7          	jalr	-412(ra) # 80004f30 <_Z15thread_dispatchv>
        for (uint64 j = 0; j < 10000; j++) {
    800040d4:	00148493          	addi	s1,s1,1
    800040d8:	000027b7          	lui	a5,0x2
    800040dc:	70f78793          	addi	a5,a5,1807 # 270f <_entry-0x7fffd8f1>
    800040e0:	0097ee63          	bltu	a5,s1,800040fc <_ZN7WorkerB11workerBodyBEPv+0x50>
            for (uint64 k = 0; k < 30000; k++) { /* busy wait */ }
    800040e4:	00000713          	li	a4,0
    800040e8:	000077b7          	lui	a5,0x7
    800040ec:	52f78793          	addi	a5,a5,1327 # 752f <_entry-0x7fff8ad1>
    800040f0:	fce7eee3          	bltu	a5,a4,800040cc <_ZN7WorkerB11workerBodyBEPv+0x20>
    800040f4:	00170713          	addi	a4,a4,1
    800040f8:	ff1ff06f          	j	800040e8 <_ZN7WorkerB11workerBodyBEPv+0x3c>
    for (uint64 i = 0; i < 16; i++) {
    800040fc:	00190913          	addi	s2,s2,1
    80004100:	00f00793          	li	a5,15
    80004104:	0527e063          	bltu	a5,s2,80004144 <_ZN7WorkerB11workerBodyBEPv+0x98>
        printString("B: i="); printInt(i); printString("\n");
    80004108:	00005517          	auipc	a0,0x5
    8000410c:	0f050513          	addi	a0,a0,240 # 800091f8 <_ZTV12ConsumerSync+0xa0>
    80004110:	ffffe097          	auipc	ra,0xffffe
    80004114:	f9c080e7          	jalr	-100(ra) # 800020ac <_Z11printStringPKc>
    80004118:	00000613          	li	a2,0
    8000411c:	00a00593          	li	a1,10
    80004120:	0009051b          	sext.w	a0,s2
    80004124:	ffffe097          	auipc	ra,0xffffe
    80004128:	138080e7          	jalr	312(ra) # 8000225c <_Z8printIntiii>
    8000412c:	00005517          	auipc	a0,0x5
    80004130:	2a450513          	addi	a0,a0,676 # 800093d0 <_ZTV12ConsumerSync+0x278>
    80004134:	ffffe097          	auipc	ra,0xffffe
    80004138:	f78080e7          	jalr	-136(ra) # 800020ac <_Z11printStringPKc>
        for (uint64 j = 0; j < 10000; j++) {
    8000413c:	00000493          	li	s1,0
    80004140:	f99ff06f          	j	800040d8 <_ZN7WorkerB11workerBodyBEPv+0x2c>
        }
    }
    printString("B finished!\n");
    80004144:	00005517          	auipc	a0,0x5
    80004148:	0bc50513          	addi	a0,a0,188 # 80009200 <_ZTV12ConsumerSync+0xa8>
    8000414c:	ffffe097          	auipc	ra,0xffffe
    80004150:	f60080e7          	jalr	-160(ra) # 800020ac <_Z11printStringPKc>
    finishedB = true;
    80004154:	00100793          	li	a5,1
    80004158:	00008717          	auipc	a4,0x8
    8000415c:	b4f70b23          	sb	a5,-1194(a4) # 8000bcae <_ZL9finishedB>
    thread_dispatch();
    80004160:	00001097          	auipc	ra,0x1
    80004164:	dd0080e7          	jalr	-560(ra) # 80004f30 <_Z15thread_dispatchv>
}
    80004168:	01813083          	ld	ra,24(sp)
    8000416c:	01013403          	ld	s0,16(sp)
    80004170:	00813483          	ld	s1,8(sp)
    80004174:	00013903          	ld	s2,0(sp)
    80004178:	02010113          	addi	sp,sp,32
    8000417c:	00008067          	ret

0000000080004180 <_ZN7WorkerC11workerBodyCEPv>:

void WorkerC::workerBodyC(void *arg) {
    80004180:	fe010113          	addi	sp,sp,-32
    80004184:	00113c23          	sd	ra,24(sp)
    80004188:	00813823          	sd	s0,16(sp)
    8000418c:	00913423          	sd	s1,8(sp)
    80004190:	01213023          	sd	s2,0(sp)
    80004194:	02010413          	addi	s0,sp,32
    uint8 i = 0;
    80004198:	00000493          	li	s1,0
    8000419c:	0400006f          	j	800041dc <_ZN7WorkerC11workerBodyCEPv+0x5c>
    for (; i < 3; i++) {
        printString("C: i="); printInt(i); printString("\n");
    800041a0:	00005517          	auipc	a0,0x5
    800041a4:	01850513          	addi	a0,a0,24 # 800091b8 <_ZTV12ConsumerSync+0x60>
    800041a8:	ffffe097          	auipc	ra,0xffffe
    800041ac:	f04080e7          	jalr	-252(ra) # 800020ac <_Z11printStringPKc>
    800041b0:	00000613          	li	a2,0
    800041b4:	00a00593          	li	a1,10
    800041b8:	00048513          	mv	a0,s1
    800041bc:	ffffe097          	auipc	ra,0xffffe
    800041c0:	0a0080e7          	jalr	160(ra) # 8000225c <_Z8printIntiii>
    800041c4:	00005517          	auipc	a0,0x5
    800041c8:	20c50513          	addi	a0,a0,524 # 800093d0 <_ZTV12ConsumerSync+0x278>
    800041cc:	ffffe097          	auipc	ra,0xffffe
    800041d0:	ee0080e7          	jalr	-288(ra) # 800020ac <_Z11printStringPKc>
    for (; i < 3; i++) {
    800041d4:	0014849b          	addiw	s1,s1,1
    800041d8:	0ff4f493          	andi	s1,s1,255
    800041dc:	00200793          	li	a5,2
    800041e0:	fc97f0e3          	bgeu	a5,s1,800041a0 <_ZN7WorkerC11workerBodyCEPv+0x20>
    }

    printString("C: dispatch\n");
    800041e4:	00005517          	auipc	a0,0x5
    800041e8:	fdc50513          	addi	a0,a0,-36 # 800091c0 <_ZTV12ConsumerSync+0x68>
    800041ec:	ffffe097          	auipc	ra,0xffffe
    800041f0:	ec0080e7          	jalr	-320(ra) # 800020ac <_Z11printStringPKc>
    __asm__ ("li t1, 7");
    800041f4:	00700313          	li	t1,7
    thread_dispatch();
    800041f8:	00001097          	auipc	ra,0x1
    800041fc:	d38080e7          	jalr	-712(ra) # 80004f30 <_Z15thread_dispatchv>

    uint64 t1 = 0;
    __asm__ ("mv %[t1], t1" : [t1] "=r"(t1));
    80004200:	00030913          	mv	s2,t1

    printString("C: t1="); printInt(t1); printString("\n");
    80004204:	00005517          	auipc	a0,0x5
    80004208:	fcc50513          	addi	a0,a0,-52 # 800091d0 <_ZTV12ConsumerSync+0x78>
    8000420c:	ffffe097          	auipc	ra,0xffffe
    80004210:	ea0080e7          	jalr	-352(ra) # 800020ac <_Z11printStringPKc>
    80004214:	00000613          	li	a2,0
    80004218:	00a00593          	li	a1,10
    8000421c:	0009051b          	sext.w	a0,s2
    80004220:	ffffe097          	auipc	ra,0xffffe
    80004224:	03c080e7          	jalr	60(ra) # 8000225c <_Z8printIntiii>
    80004228:	00005517          	auipc	a0,0x5
    8000422c:	1a850513          	addi	a0,a0,424 # 800093d0 <_ZTV12ConsumerSync+0x278>
    80004230:	ffffe097          	auipc	ra,0xffffe
    80004234:	e7c080e7          	jalr	-388(ra) # 800020ac <_Z11printStringPKc>

    uint64 result = fibonacci(12);
    80004238:	00c00513          	li	a0,12
    8000423c:	00000097          	auipc	ra,0x0
    80004240:	d30080e7          	jalr	-720(ra) # 80003f6c <_ZL9fibonaccim>
    80004244:	00050913          	mv	s2,a0
    printString("C: fibonaci="); printInt(result); printString("\n");
    80004248:	00005517          	auipc	a0,0x5
    8000424c:	f9050513          	addi	a0,a0,-112 # 800091d8 <_ZTV12ConsumerSync+0x80>
    80004250:	ffffe097          	auipc	ra,0xffffe
    80004254:	e5c080e7          	jalr	-420(ra) # 800020ac <_Z11printStringPKc>
    80004258:	00000613          	li	a2,0
    8000425c:	00a00593          	li	a1,10
    80004260:	0009051b          	sext.w	a0,s2
    80004264:	ffffe097          	auipc	ra,0xffffe
    80004268:	ff8080e7          	jalr	-8(ra) # 8000225c <_Z8printIntiii>
    8000426c:	00005517          	auipc	a0,0x5
    80004270:	16450513          	addi	a0,a0,356 # 800093d0 <_ZTV12ConsumerSync+0x278>
    80004274:	ffffe097          	auipc	ra,0xffffe
    80004278:	e38080e7          	jalr	-456(ra) # 800020ac <_Z11printStringPKc>
    8000427c:	0400006f          	j	800042bc <_ZN7WorkerC11workerBodyCEPv+0x13c>

    for (; i < 6; i++) {
        printString("C: i="); printInt(i); printString("\n");
    80004280:	00005517          	auipc	a0,0x5
    80004284:	f3850513          	addi	a0,a0,-200 # 800091b8 <_ZTV12ConsumerSync+0x60>
    80004288:	ffffe097          	auipc	ra,0xffffe
    8000428c:	e24080e7          	jalr	-476(ra) # 800020ac <_Z11printStringPKc>
    80004290:	00000613          	li	a2,0
    80004294:	00a00593          	li	a1,10
    80004298:	00048513          	mv	a0,s1
    8000429c:	ffffe097          	auipc	ra,0xffffe
    800042a0:	fc0080e7          	jalr	-64(ra) # 8000225c <_Z8printIntiii>
    800042a4:	00005517          	auipc	a0,0x5
    800042a8:	12c50513          	addi	a0,a0,300 # 800093d0 <_ZTV12ConsumerSync+0x278>
    800042ac:	ffffe097          	auipc	ra,0xffffe
    800042b0:	e00080e7          	jalr	-512(ra) # 800020ac <_Z11printStringPKc>
    for (; i < 6; i++) {
    800042b4:	0014849b          	addiw	s1,s1,1
    800042b8:	0ff4f493          	andi	s1,s1,255
    800042bc:	00500793          	li	a5,5
    800042c0:	fc97f0e3          	bgeu	a5,s1,80004280 <_ZN7WorkerC11workerBodyCEPv+0x100>
    }

    printString("A finished!\n");
    800042c4:	00005517          	auipc	a0,0x5
    800042c8:	f2450513          	addi	a0,a0,-220 # 800091e8 <_ZTV12ConsumerSync+0x90>
    800042cc:	ffffe097          	auipc	ra,0xffffe
    800042d0:	de0080e7          	jalr	-544(ra) # 800020ac <_Z11printStringPKc>
    finishedC = true;
    800042d4:	00100793          	li	a5,1
    800042d8:	00008717          	auipc	a4,0x8
    800042dc:	9cf70aa3          	sb	a5,-1579(a4) # 8000bcad <_ZL9finishedC>
    thread_dispatch();
    800042e0:	00001097          	auipc	ra,0x1
    800042e4:	c50080e7          	jalr	-944(ra) # 80004f30 <_Z15thread_dispatchv>
}
    800042e8:	01813083          	ld	ra,24(sp)
    800042ec:	01013403          	ld	s0,16(sp)
    800042f0:	00813483          	ld	s1,8(sp)
    800042f4:	00013903          	ld	s2,0(sp)
    800042f8:	02010113          	addi	sp,sp,32
    800042fc:	00008067          	ret

0000000080004300 <_ZN7WorkerD11workerBodyDEPv>:

void WorkerD::workerBodyD(void* arg) {
    80004300:	fe010113          	addi	sp,sp,-32
    80004304:	00113c23          	sd	ra,24(sp)
    80004308:	00813823          	sd	s0,16(sp)
    8000430c:	00913423          	sd	s1,8(sp)
    80004310:	01213023          	sd	s2,0(sp)
    80004314:	02010413          	addi	s0,sp,32
    uint8 i = 10;
    80004318:	00a00493          	li	s1,10
    8000431c:	0400006f          	j	8000435c <_ZN7WorkerD11workerBodyDEPv+0x5c>
    for (; i < 13; i++) {
        printString("D: i="); printInt(i); printString("\n");
    80004320:	00005517          	auipc	a0,0x5
    80004324:	e6050513          	addi	a0,a0,-416 # 80009180 <_ZTV12ConsumerSync+0x28>
    80004328:	ffffe097          	auipc	ra,0xffffe
    8000432c:	d84080e7          	jalr	-636(ra) # 800020ac <_Z11printStringPKc>
    80004330:	00000613          	li	a2,0
    80004334:	00a00593          	li	a1,10
    80004338:	00048513          	mv	a0,s1
    8000433c:	ffffe097          	auipc	ra,0xffffe
    80004340:	f20080e7          	jalr	-224(ra) # 8000225c <_Z8printIntiii>
    80004344:	00005517          	auipc	a0,0x5
    80004348:	08c50513          	addi	a0,a0,140 # 800093d0 <_ZTV12ConsumerSync+0x278>
    8000434c:	ffffe097          	auipc	ra,0xffffe
    80004350:	d60080e7          	jalr	-672(ra) # 800020ac <_Z11printStringPKc>
    for (; i < 13; i++) {
    80004354:	0014849b          	addiw	s1,s1,1
    80004358:	0ff4f493          	andi	s1,s1,255
    8000435c:	00c00793          	li	a5,12
    80004360:	fc97f0e3          	bgeu	a5,s1,80004320 <_ZN7WorkerD11workerBodyDEPv+0x20>
    }

    printString("D: dispatch\n");
    80004364:	00005517          	auipc	a0,0x5
    80004368:	e2450513          	addi	a0,a0,-476 # 80009188 <_ZTV12ConsumerSync+0x30>
    8000436c:	ffffe097          	auipc	ra,0xffffe
    80004370:	d40080e7          	jalr	-704(ra) # 800020ac <_Z11printStringPKc>
    __asm__ ("li t1, 5");
    80004374:	00500313          	li	t1,5
    thread_dispatch();
    80004378:	00001097          	auipc	ra,0x1
    8000437c:	bb8080e7          	jalr	-1096(ra) # 80004f30 <_Z15thread_dispatchv>

    uint64 result = fibonacci(16);
    80004380:	01000513          	li	a0,16
    80004384:	00000097          	auipc	ra,0x0
    80004388:	be8080e7          	jalr	-1048(ra) # 80003f6c <_ZL9fibonaccim>
    8000438c:	00050913          	mv	s2,a0
    printString("D: fibonaci="); printInt(result); printString("\n");
    80004390:	00005517          	auipc	a0,0x5
    80004394:	e0850513          	addi	a0,a0,-504 # 80009198 <_ZTV12ConsumerSync+0x40>
    80004398:	ffffe097          	auipc	ra,0xffffe
    8000439c:	d14080e7          	jalr	-748(ra) # 800020ac <_Z11printStringPKc>
    800043a0:	00000613          	li	a2,0
    800043a4:	00a00593          	li	a1,10
    800043a8:	0009051b          	sext.w	a0,s2
    800043ac:	ffffe097          	auipc	ra,0xffffe
    800043b0:	eb0080e7          	jalr	-336(ra) # 8000225c <_Z8printIntiii>
    800043b4:	00005517          	auipc	a0,0x5
    800043b8:	01c50513          	addi	a0,a0,28 # 800093d0 <_ZTV12ConsumerSync+0x278>
    800043bc:	ffffe097          	auipc	ra,0xffffe
    800043c0:	cf0080e7          	jalr	-784(ra) # 800020ac <_Z11printStringPKc>
    800043c4:	0400006f          	j	80004404 <_ZN7WorkerD11workerBodyDEPv+0x104>

    for (; i < 16; i++) {
        printString("D: i="); printInt(i); printString("\n");
    800043c8:	00005517          	auipc	a0,0x5
    800043cc:	db850513          	addi	a0,a0,-584 # 80009180 <_ZTV12ConsumerSync+0x28>
    800043d0:	ffffe097          	auipc	ra,0xffffe
    800043d4:	cdc080e7          	jalr	-804(ra) # 800020ac <_Z11printStringPKc>
    800043d8:	00000613          	li	a2,0
    800043dc:	00a00593          	li	a1,10
    800043e0:	00048513          	mv	a0,s1
    800043e4:	ffffe097          	auipc	ra,0xffffe
    800043e8:	e78080e7          	jalr	-392(ra) # 8000225c <_Z8printIntiii>
    800043ec:	00005517          	auipc	a0,0x5
    800043f0:	fe450513          	addi	a0,a0,-28 # 800093d0 <_ZTV12ConsumerSync+0x278>
    800043f4:	ffffe097          	auipc	ra,0xffffe
    800043f8:	cb8080e7          	jalr	-840(ra) # 800020ac <_Z11printStringPKc>
    for (; i < 16; i++) {
    800043fc:	0014849b          	addiw	s1,s1,1
    80004400:	0ff4f493          	andi	s1,s1,255
    80004404:	00f00793          	li	a5,15
    80004408:	fc97f0e3          	bgeu	a5,s1,800043c8 <_ZN7WorkerD11workerBodyDEPv+0xc8>
    }

    printString("D finished!\n");
    8000440c:	00005517          	auipc	a0,0x5
    80004410:	d9c50513          	addi	a0,a0,-612 # 800091a8 <_ZTV12ConsumerSync+0x50>
    80004414:	ffffe097          	auipc	ra,0xffffe
    80004418:	c98080e7          	jalr	-872(ra) # 800020ac <_Z11printStringPKc>
    finishedD = true;
    8000441c:	00100793          	li	a5,1
    80004420:	00008717          	auipc	a4,0x8
    80004424:	88f70623          	sb	a5,-1908(a4) # 8000bcac <_ZL9finishedD>
    thread_dispatch();
    80004428:	00001097          	auipc	ra,0x1
    8000442c:	b08080e7          	jalr	-1272(ra) # 80004f30 <_Z15thread_dispatchv>
}
    80004430:	01813083          	ld	ra,24(sp)
    80004434:	01013403          	ld	s0,16(sp)
    80004438:	00813483          	ld	s1,8(sp)
    8000443c:	00013903          	ld	s2,0(sp)
    80004440:	02010113          	addi	sp,sp,32
    80004444:	00008067          	ret

0000000080004448 <_Z20Threads_CPP_API_testv>:


void Threads_CPP_API_test() {
    80004448:	fc010113          	addi	sp,sp,-64
    8000444c:	02113c23          	sd	ra,56(sp)
    80004450:	02813823          	sd	s0,48(sp)
    80004454:	02913423          	sd	s1,40(sp)
    80004458:	03213023          	sd	s2,32(sp)
    8000445c:	04010413          	addi	s0,sp,64
    Thread* threads[4];

    threads[0] = new WorkerA();
    80004460:	02000513          	li	a0,32
    80004464:	00002097          	auipc	ra,0x2
    80004468:	bb4080e7          	jalr	-1100(ra) # 80006018 <_Znwm>
    8000446c:	00050493          	mv	s1,a0
    WorkerA():Thread() {}
    80004470:	00002097          	auipc	ra,0x2
    80004474:	e58080e7          	jalr	-424(ra) # 800062c8 <_ZN6ThreadC1Ev>
    80004478:	00005797          	auipc	a5,0x5
    8000447c:	12878793          	addi	a5,a5,296 # 800095a0 <_ZTV7WorkerA+0x10>
    80004480:	00f4b023          	sd	a5,0(s1)
    threads[0] = new WorkerA();
    80004484:	fc943023          	sd	s1,-64(s0)
    printString("ThreadA created\n");
    80004488:	00005517          	auipc	a0,0x5
    8000448c:	d9050513          	addi	a0,a0,-624 # 80009218 <_ZTV12ConsumerSync+0xc0>
    80004490:	ffffe097          	auipc	ra,0xffffe
    80004494:	c1c080e7          	jalr	-996(ra) # 800020ac <_Z11printStringPKc>

    threads[1] = new WorkerB();
    80004498:	02000513          	li	a0,32
    8000449c:	00002097          	auipc	ra,0x2
    800044a0:	b7c080e7          	jalr	-1156(ra) # 80006018 <_Znwm>
    800044a4:	00050493          	mv	s1,a0
    WorkerB():Thread() {}
    800044a8:	00002097          	auipc	ra,0x2
    800044ac:	e20080e7          	jalr	-480(ra) # 800062c8 <_ZN6ThreadC1Ev>
    800044b0:	00005797          	auipc	a5,0x5
    800044b4:	11878793          	addi	a5,a5,280 # 800095c8 <_ZTV7WorkerB+0x10>
    800044b8:	00f4b023          	sd	a5,0(s1)
    threads[1] = new WorkerB();
    800044bc:	fc943423          	sd	s1,-56(s0)
    printString("ThreadB created\n");
    800044c0:	00005517          	auipc	a0,0x5
    800044c4:	d7050513          	addi	a0,a0,-656 # 80009230 <_ZTV12ConsumerSync+0xd8>
    800044c8:	ffffe097          	auipc	ra,0xffffe
    800044cc:	be4080e7          	jalr	-1052(ra) # 800020ac <_Z11printStringPKc>

    threads[2] = new WorkerC();
    800044d0:	02000513          	li	a0,32
    800044d4:	00002097          	auipc	ra,0x2
    800044d8:	b44080e7          	jalr	-1212(ra) # 80006018 <_Znwm>
    800044dc:	00050493          	mv	s1,a0
    WorkerC():Thread() {}
    800044e0:	00002097          	auipc	ra,0x2
    800044e4:	de8080e7          	jalr	-536(ra) # 800062c8 <_ZN6ThreadC1Ev>
    800044e8:	00005797          	auipc	a5,0x5
    800044ec:	10878793          	addi	a5,a5,264 # 800095f0 <_ZTV7WorkerC+0x10>
    800044f0:	00f4b023          	sd	a5,0(s1)
    threads[2] = new WorkerC();
    800044f4:	fc943823          	sd	s1,-48(s0)
    printString("ThreadC created\n");
    800044f8:	00005517          	auipc	a0,0x5
    800044fc:	d5050513          	addi	a0,a0,-688 # 80009248 <_ZTV12ConsumerSync+0xf0>
    80004500:	ffffe097          	auipc	ra,0xffffe
    80004504:	bac080e7          	jalr	-1108(ra) # 800020ac <_Z11printStringPKc>

    threads[3] = new WorkerD();
    80004508:	02000513          	li	a0,32
    8000450c:	00002097          	auipc	ra,0x2
    80004510:	b0c080e7          	jalr	-1268(ra) # 80006018 <_Znwm>
    80004514:	00050493          	mv	s1,a0
    WorkerD():Thread() {}
    80004518:	00002097          	auipc	ra,0x2
    8000451c:	db0080e7          	jalr	-592(ra) # 800062c8 <_ZN6ThreadC1Ev>
    80004520:	00005797          	auipc	a5,0x5
    80004524:	0f878793          	addi	a5,a5,248 # 80009618 <_ZTV7WorkerD+0x10>
    80004528:	00f4b023          	sd	a5,0(s1)
    threads[3] = new WorkerD();
    8000452c:	fc943c23          	sd	s1,-40(s0)
    printString("ThreadD created\n");
    80004530:	00005517          	auipc	a0,0x5
    80004534:	d3050513          	addi	a0,a0,-720 # 80009260 <_ZTV12ConsumerSync+0x108>
    80004538:	ffffe097          	auipc	ra,0xffffe
    8000453c:	b74080e7          	jalr	-1164(ra) # 800020ac <_Z11printStringPKc>

    for(int i=0; i<4; i++) {
    80004540:	00000493          	li	s1,0
    80004544:	00300793          	li	a5,3
    80004548:	0297c663          	blt	a5,s1,80004574 <_Z20Threads_CPP_API_testv+0x12c>
        threads[i]->start();
    8000454c:	00349793          	slli	a5,s1,0x3
    80004550:	fe040713          	addi	a4,s0,-32
    80004554:	00f707b3          	add	a5,a4,a5
    80004558:	fe07b503          	ld	a0,-32(a5)
    8000455c:	00002097          	auipc	ra,0x2
    80004560:	c60080e7          	jalr	-928(ra) # 800061bc <_ZN6Thread5startEv>
    for(int i=0; i<4; i++) {
    80004564:	0014849b          	addiw	s1,s1,1
    80004568:	fddff06f          	j	80004544 <_Z20Threads_CPP_API_testv+0xfc>
    }

    while (!(finishedA && finishedB && finishedC && finishedD)) {
        Thread::dispatch();
    8000456c:	00002097          	auipc	ra,0x2
    80004570:	ca4080e7          	jalr	-860(ra) # 80006210 <_ZN6Thread8dispatchEv>
    while (!(finishedA && finishedB && finishedC && finishedD)) {
    80004574:	00007797          	auipc	a5,0x7
    80004578:	73b7c783          	lbu	a5,1851(a5) # 8000bcaf <_ZL9finishedA>
    8000457c:	fe0788e3          	beqz	a5,8000456c <_Z20Threads_CPP_API_testv+0x124>
    80004580:	00007797          	auipc	a5,0x7
    80004584:	72e7c783          	lbu	a5,1838(a5) # 8000bcae <_ZL9finishedB>
    80004588:	fe0782e3          	beqz	a5,8000456c <_Z20Threads_CPP_API_testv+0x124>
    8000458c:	00007797          	auipc	a5,0x7
    80004590:	7217c783          	lbu	a5,1825(a5) # 8000bcad <_ZL9finishedC>
    80004594:	fc078ce3          	beqz	a5,8000456c <_Z20Threads_CPP_API_testv+0x124>
    80004598:	00007797          	auipc	a5,0x7
    8000459c:	7147c783          	lbu	a5,1812(a5) # 8000bcac <_ZL9finishedD>
    800045a0:	fc0786e3          	beqz	a5,8000456c <_Z20Threads_CPP_API_testv+0x124>
    800045a4:	fc040493          	addi	s1,s0,-64
    800045a8:	0080006f          	j	800045b0 <_Z20Threads_CPP_API_testv+0x168>
    }

    for (auto thread: threads) { delete thread; }
    800045ac:	00848493          	addi	s1,s1,8
    800045b0:	fe040793          	addi	a5,s0,-32
    800045b4:	08f48663          	beq	s1,a5,80004640 <_Z20Threads_CPP_API_testv+0x1f8>
    800045b8:	0004b503          	ld	a0,0(s1)
    800045bc:	fe0508e3          	beqz	a0,800045ac <_Z20Threads_CPP_API_testv+0x164>
    800045c0:	00053783          	ld	a5,0(a0)
    800045c4:	0087b783          	ld	a5,8(a5)
    800045c8:	000780e7          	jalr	a5
    800045cc:	fe1ff06f          	j	800045ac <_Z20Threads_CPP_API_testv+0x164>
    800045d0:	00050913          	mv	s2,a0
    threads[0] = new WorkerA();
    800045d4:	00048513          	mv	a0,s1
    800045d8:	00002097          	auipc	ra,0x2
    800045dc:	a90080e7          	jalr	-1392(ra) # 80006068 <_ZdlPv>
    800045e0:	00090513          	mv	a0,s2
    800045e4:	00009097          	auipc	ra,0x9
    800045e8:	074080e7          	jalr	116(ra) # 8000d658 <_Unwind_Resume>
    800045ec:	00050913          	mv	s2,a0
    threads[1] = new WorkerB();
    800045f0:	00048513          	mv	a0,s1
    800045f4:	00002097          	auipc	ra,0x2
    800045f8:	a74080e7          	jalr	-1420(ra) # 80006068 <_ZdlPv>
    800045fc:	00090513          	mv	a0,s2
    80004600:	00009097          	auipc	ra,0x9
    80004604:	058080e7          	jalr	88(ra) # 8000d658 <_Unwind_Resume>
    80004608:	00050913          	mv	s2,a0
    threads[2] = new WorkerC();
    8000460c:	00048513          	mv	a0,s1
    80004610:	00002097          	auipc	ra,0x2
    80004614:	a58080e7          	jalr	-1448(ra) # 80006068 <_ZdlPv>
    80004618:	00090513          	mv	a0,s2
    8000461c:	00009097          	auipc	ra,0x9
    80004620:	03c080e7          	jalr	60(ra) # 8000d658 <_Unwind_Resume>
    80004624:	00050913          	mv	s2,a0
    threads[3] = new WorkerD();
    80004628:	00048513          	mv	a0,s1
    8000462c:	00002097          	auipc	ra,0x2
    80004630:	a3c080e7          	jalr	-1476(ra) # 80006068 <_ZdlPv>
    80004634:	00090513          	mv	a0,s2
    80004638:	00009097          	auipc	ra,0x9
    8000463c:	020080e7          	jalr	32(ra) # 8000d658 <_Unwind_Resume>
}
    80004640:	03813083          	ld	ra,56(sp)
    80004644:	03013403          	ld	s0,48(sp)
    80004648:	02813483          	ld	s1,40(sp)
    8000464c:	02013903          	ld	s2,32(sp)
    80004650:	04010113          	addi	sp,sp,64
    80004654:	00008067          	ret

0000000080004658 <_ZN7WorkerAD1Ev>:
class WorkerA: public Thread {
    80004658:	ff010113          	addi	sp,sp,-16
    8000465c:	00113423          	sd	ra,8(sp)
    80004660:	00813023          	sd	s0,0(sp)
    80004664:	01010413          	addi	s0,sp,16
    80004668:	00005797          	auipc	a5,0x5
    8000466c:	f3878793          	addi	a5,a5,-200 # 800095a0 <_ZTV7WorkerA+0x10>
    80004670:	00f53023          	sd	a5,0(a0)
    80004674:	00002097          	auipc	ra,0x2
    80004678:	a84080e7          	jalr	-1404(ra) # 800060f8 <_ZN6ThreadD1Ev>
    8000467c:	00813083          	ld	ra,8(sp)
    80004680:	00013403          	ld	s0,0(sp)
    80004684:	01010113          	addi	sp,sp,16
    80004688:	00008067          	ret

000000008000468c <_ZN7WorkerAD0Ev>:
    8000468c:	fe010113          	addi	sp,sp,-32
    80004690:	00113c23          	sd	ra,24(sp)
    80004694:	00813823          	sd	s0,16(sp)
    80004698:	00913423          	sd	s1,8(sp)
    8000469c:	02010413          	addi	s0,sp,32
    800046a0:	00050493          	mv	s1,a0
    800046a4:	00005797          	auipc	a5,0x5
    800046a8:	efc78793          	addi	a5,a5,-260 # 800095a0 <_ZTV7WorkerA+0x10>
    800046ac:	00f53023          	sd	a5,0(a0)
    800046b0:	00002097          	auipc	ra,0x2
    800046b4:	a48080e7          	jalr	-1464(ra) # 800060f8 <_ZN6ThreadD1Ev>
    800046b8:	00048513          	mv	a0,s1
    800046bc:	00002097          	auipc	ra,0x2
    800046c0:	9ac080e7          	jalr	-1620(ra) # 80006068 <_ZdlPv>
    800046c4:	01813083          	ld	ra,24(sp)
    800046c8:	01013403          	ld	s0,16(sp)
    800046cc:	00813483          	ld	s1,8(sp)
    800046d0:	02010113          	addi	sp,sp,32
    800046d4:	00008067          	ret

00000000800046d8 <_ZN7WorkerBD1Ev>:
class WorkerB: public Thread {
    800046d8:	ff010113          	addi	sp,sp,-16
    800046dc:	00113423          	sd	ra,8(sp)
    800046e0:	00813023          	sd	s0,0(sp)
    800046e4:	01010413          	addi	s0,sp,16
    800046e8:	00005797          	auipc	a5,0x5
    800046ec:	ee078793          	addi	a5,a5,-288 # 800095c8 <_ZTV7WorkerB+0x10>
    800046f0:	00f53023          	sd	a5,0(a0)
    800046f4:	00002097          	auipc	ra,0x2
    800046f8:	a04080e7          	jalr	-1532(ra) # 800060f8 <_ZN6ThreadD1Ev>
    800046fc:	00813083          	ld	ra,8(sp)
    80004700:	00013403          	ld	s0,0(sp)
    80004704:	01010113          	addi	sp,sp,16
    80004708:	00008067          	ret

000000008000470c <_ZN7WorkerBD0Ev>:
    8000470c:	fe010113          	addi	sp,sp,-32
    80004710:	00113c23          	sd	ra,24(sp)
    80004714:	00813823          	sd	s0,16(sp)
    80004718:	00913423          	sd	s1,8(sp)
    8000471c:	02010413          	addi	s0,sp,32
    80004720:	00050493          	mv	s1,a0
    80004724:	00005797          	auipc	a5,0x5
    80004728:	ea478793          	addi	a5,a5,-348 # 800095c8 <_ZTV7WorkerB+0x10>
    8000472c:	00f53023          	sd	a5,0(a0)
    80004730:	00002097          	auipc	ra,0x2
    80004734:	9c8080e7          	jalr	-1592(ra) # 800060f8 <_ZN6ThreadD1Ev>
    80004738:	00048513          	mv	a0,s1
    8000473c:	00002097          	auipc	ra,0x2
    80004740:	92c080e7          	jalr	-1748(ra) # 80006068 <_ZdlPv>
    80004744:	01813083          	ld	ra,24(sp)
    80004748:	01013403          	ld	s0,16(sp)
    8000474c:	00813483          	ld	s1,8(sp)
    80004750:	02010113          	addi	sp,sp,32
    80004754:	00008067          	ret

0000000080004758 <_ZN7WorkerCD1Ev>:
class WorkerC: public Thread {
    80004758:	ff010113          	addi	sp,sp,-16
    8000475c:	00113423          	sd	ra,8(sp)
    80004760:	00813023          	sd	s0,0(sp)
    80004764:	01010413          	addi	s0,sp,16
    80004768:	00005797          	auipc	a5,0x5
    8000476c:	e8878793          	addi	a5,a5,-376 # 800095f0 <_ZTV7WorkerC+0x10>
    80004770:	00f53023          	sd	a5,0(a0)
    80004774:	00002097          	auipc	ra,0x2
    80004778:	984080e7          	jalr	-1660(ra) # 800060f8 <_ZN6ThreadD1Ev>
    8000477c:	00813083          	ld	ra,8(sp)
    80004780:	00013403          	ld	s0,0(sp)
    80004784:	01010113          	addi	sp,sp,16
    80004788:	00008067          	ret

000000008000478c <_ZN7WorkerCD0Ev>:
    8000478c:	fe010113          	addi	sp,sp,-32
    80004790:	00113c23          	sd	ra,24(sp)
    80004794:	00813823          	sd	s0,16(sp)
    80004798:	00913423          	sd	s1,8(sp)
    8000479c:	02010413          	addi	s0,sp,32
    800047a0:	00050493          	mv	s1,a0
    800047a4:	00005797          	auipc	a5,0x5
    800047a8:	e4c78793          	addi	a5,a5,-436 # 800095f0 <_ZTV7WorkerC+0x10>
    800047ac:	00f53023          	sd	a5,0(a0)
    800047b0:	00002097          	auipc	ra,0x2
    800047b4:	948080e7          	jalr	-1720(ra) # 800060f8 <_ZN6ThreadD1Ev>
    800047b8:	00048513          	mv	a0,s1
    800047bc:	00002097          	auipc	ra,0x2
    800047c0:	8ac080e7          	jalr	-1876(ra) # 80006068 <_ZdlPv>
    800047c4:	01813083          	ld	ra,24(sp)
    800047c8:	01013403          	ld	s0,16(sp)
    800047cc:	00813483          	ld	s1,8(sp)
    800047d0:	02010113          	addi	sp,sp,32
    800047d4:	00008067          	ret

00000000800047d8 <_ZN7WorkerDD1Ev>:
class WorkerD: public Thread {
    800047d8:	ff010113          	addi	sp,sp,-16
    800047dc:	00113423          	sd	ra,8(sp)
    800047e0:	00813023          	sd	s0,0(sp)
    800047e4:	01010413          	addi	s0,sp,16
    800047e8:	00005797          	auipc	a5,0x5
    800047ec:	e3078793          	addi	a5,a5,-464 # 80009618 <_ZTV7WorkerD+0x10>
    800047f0:	00f53023          	sd	a5,0(a0)
    800047f4:	00002097          	auipc	ra,0x2
    800047f8:	904080e7          	jalr	-1788(ra) # 800060f8 <_ZN6ThreadD1Ev>
    800047fc:	00813083          	ld	ra,8(sp)
    80004800:	00013403          	ld	s0,0(sp)
    80004804:	01010113          	addi	sp,sp,16
    80004808:	00008067          	ret

000000008000480c <_ZN7WorkerDD0Ev>:
    8000480c:	fe010113          	addi	sp,sp,-32
    80004810:	00113c23          	sd	ra,24(sp)
    80004814:	00813823          	sd	s0,16(sp)
    80004818:	00913423          	sd	s1,8(sp)
    8000481c:	02010413          	addi	s0,sp,32
    80004820:	00050493          	mv	s1,a0
    80004824:	00005797          	auipc	a5,0x5
    80004828:	df478793          	addi	a5,a5,-524 # 80009618 <_ZTV7WorkerD+0x10>
    8000482c:	00f53023          	sd	a5,0(a0)
    80004830:	00002097          	auipc	ra,0x2
    80004834:	8c8080e7          	jalr	-1848(ra) # 800060f8 <_ZN6ThreadD1Ev>
    80004838:	00048513          	mv	a0,s1
    8000483c:	00002097          	auipc	ra,0x2
    80004840:	82c080e7          	jalr	-2004(ra) # 80006068 <_ZdlPv>
    80004844:	01813083          	ld	ra,24(sp)
    80004848:	01013403          	ld	s0,16(sp)
    8000484c:	00813483          	ld	s1,8(sp)
    80004850:	02010113          	addi	sp,sp,32
    80004854:	00008067          	ret

0000000080004858 <_ZN7WorkerA3runEv>:
    void run() override {
    80004858:	ff010113          	addi	sp,sp,-16
    8000485c:	00113423          	sd	ra,8(sp)
    80004860:	00813023          	sd	s0,0(sp)
    80004864:	01010413          	addi	s0,sp,16
        workerBodyA(nullptr);
    80004868:	00000593          	li	a1,0
    8000486c:	fffff097          	auipc	ra,0xfffff
    80004870:	774080e7          	jalr	1908(ra) # 80003fe0 <_ZN7WorkerA11workerBodyAEPv>
    }
    80004874:	00813083          	ld	ra,8(sp)
    80004878:	00013403          	ld	s0,0(sp)
    8000487c:	01010113          	addi	sp,sp,16
    80004880:	00008067          	ret

0000000080004884 <_ZN7WorkerB3runEv>:
    void run() override {
    80004884:	ff010113          	addi	sp,sp,-16
    80004888:	00113423          	sd	ra,8(sp)
    8000488c:	00813023          	sd	s0,0(sp)
    80004890:	01010413          	addi	s0,sp,16
        workerBodyB(nullptr);
    80004894:	00000593          	li	a1,0
    80004898:	00000097          	auipc	ra,0x0
    8000489c:	814080e7          	jalr	-2028(ra) # 800040ac <_ZN7WorkerB11workerBodyBEPv>
    }
    800048a0:	00813083          	ld	ra,8(sp)
    800048a4:	00013403          	ld	s0,0(sp)
    800048a8:	01010113          	addi	sp,sp,16
    800048ac:	00008067          	ret

00000000800048b0 <_ZN7WorkerC3runEv>:
    void run() override {
    800048b0:	ff010113          	addi	sp,sp,-16
    800048b4:	00113423          	sd	ra,8(sp)
    800048b8:	00813023          	sd	s0,0(sp)
    800048bc:	01010413          	addi	s0,sp,16
        workerBodyC(nullptr);
    800048c0:	00000593          	li	a1,0
    800048c4:	00000097          	auipc	ra,0x0
    800048c8:	8bc080e7          	jalr	-1860(ra) # 80004180 <_ZN7WorkerC11workerBodyCEPv>
    }
    800048cc:	00813083          	ld	ra,8(sp)
    800048d0:	00013403          	ld	s0,0(sp)
    800048d4:	01010113          	addi	sp,sp,16
    800048d8:	00008067          	ret

00000000800048dc <_ZN7WorkerD3runEv>:
    void run() override {
    800048dc:	ff010113          	addi	sp,sp,-16
    800048e0:	00113423          	sd	ra,8(sp)
    800048e4:	00813023          	sd	s0,0(sp)
    800048e8:	01010413          	addi	s0,sp,16
        workerBodyD(nullptr);
    800048ec:	00000593          	li	a1,0
    800048f0:	00000097          	auipc	ra,0x0
    800048f4:	a10080e7          	jalr	-1520(ra) # 80004300 <_ZN7WorkerD11workerBodyDEPv>
    }
    800048f8:	00813083          	ld	ra,8(sp)
    800048fc:	00013403          	ld	s0,0(sp)
    80004900:	01010113          	addi	sp,sp,16
    80004904:	00008067          	ret

0000000080004908 <_ZN3TCB13wraperUsrMainEPv>:

bool TCB::isFinished() {
    return status == FINISHED;
}

void TCB::wraperUsrMain(void *) {
    80004908:	ff010113          	addi	sp,sp,-16
    8000490c:	00113423          	sd	ra,8(sp)
    80004910:	00813023          	sd	s0,0(sp)
    80004914:	01010413          	addi	s0,sp,16
    userMain();
    80004918:	ffffe097          	auipc	ra,0xffffe
    8000491c:	17c080e7          	jalr	380(ra) # 80002a94 <_Z8userMainv>
}
    80004920:	00813083          	ld	ra,8(sp)
    80004924:	00013403          	ld	s0,0(sp)
    80004928:	01010113          	addi	sp,sp,16
    8000492c:	00008067          	ret

0000000080004930 <_ZN3TCB5yieldEv>:
void TCB::yield() {
    80004930:	ff010113          	addi	sp,sp,-16
    80004934:	00813423          	sd	s0,8(sp)
    80004938:	01010413          	addi	s0,sp,16
    __asm__ volatile("li a0, 0x13");            //opCode
    8000493c:	01300513          	li	a0,19
    __asm__ volatile("ecall");  // celokupni kontekst cuvamo u prekidnoj rutini koju sinhrono ovde zovemo
    80004940:	00000073          	ecall
}
    80004944:	00813403          	ld	s0,8(sp)
    80004948:	01010113          	addi	sp,sp,16
    8000494c:	00008067          	ret

0000000080004950 <_ZN3TCB13threadWrapperEv>:
void TCB::threadWrapper() {         //zove se iz prekidne rutine (iz koda prekidne rutine) -> i dalje su ONEMOGUCENI PREKIDI -> na ovom mestu bi bilo dobro promeniti rezim u korisnicki
    80004950:	fe010113          	addi	sp,sp,-32
    80004954:	00113c23          	sd	ra,24(sp)
    80004958:	00813823          	sd	s0,16(sp)
    8000495c:	00913423          	sd	s1,8(sp)
    80004960:	02010413          	addi	s0,sp,32
    Riscv::popSppSpie();            //zelimo da se izvrsi, da izadjemo iz privilegovanog rezima(iz prekidne rutine, ali da se program nastavi odmah ispod ovog poziva)
    80004964:	00001097          	auipc	ra,0x1
    80004968:	9b8080e7          	jalr	-1608(ra) # 8000531c <_ZN5Riscv10popSppSpieEv>
    running->body(running->arg);                //poziva body()
    8000496c:	00007497          	auipc	s1,0x7
    80004970:	36448493          	addi	s1,s1,868 # 8000bcd0 <_ZN3TCB7runningE>
    80004974:	0004b783          	ld	a5,0(s1)
    80004978:	0087b703          	ld	a4,8(a5)
    8000497c:	0107b503          	ld	a0,16(a5)
    80004980:	000700e7          	jalr	a4
    running->setStatus(FINISHED);     //kada zavrsi body -> finished = true
    80004984:	0004b783          	ld	a5,0(s1)
    ~TCB() { delete[] stack; }
    using Body = void (*) (void*);
    static TCB* createThread(Body body, void* arg, void* stack, uint64 timeSlice);

    Status getStatus() { return status; }
    void setStatus(Status s) { status = s; }
    80004988:	00300713          	li	a4,3
    8000498c:	02e7a823          	sw	a4,48(a5)
    TCB::yield();
    80004990:	00000097          	auipc	ra,0x0
    80004994:	fa0080e7          	jalr	-96(ra) # 80004930 <_ZN3TCB5yieldEv>
}
    80004998:	01813083          	ld	ra,24(sp)
    8000499c:	01013403          	ld	s0,16(sp)
    800049a0:	00813483          	ld	s1,8(sp)
    800049a4:	02010113          	addi	sp,sp,32
    800049a8:	00008067          	ret

00000000800049ac <_ZN3TCB8dispatchEv>:
void TCB::dispatch() {
    800049ac:	fe010113          	addi	sp,sp,-32
    800049b0:	00113c23          	sd	ra,24(sp)
    800049b4:	00813823          	sd	s0,16(sp)
    800049b8:	00913423          	sd	s1,8(sp)
    800049bc:	02010413          	addi	s0,sp,32
    TCB *old = running;
    800049c0:	00007497          	auipc	s1,0x7
    800049c4:	3104b483          	ld	s1,784(s1) # 8000bcd0 <_ZN3TCB7runningE>
    Status getStatus() { return status; }
    800049c8:	0304a783          	lw	a5,48(s1)
    if (old->getStatus() == RUNNING) { Scheduler::put(old); }
    800049cc:	02078e63          	beqz	a5,80004a08 <_ZN3TCB8dispatchEv+0x5c>
    running = Scheduler::get();
    800049d0:	00001097          	auipc	ra,0x1
    800049d4:	4d8080e7          	jalr	1240(ra) # 80005ea8 <_ZN9Scheduler3getEv>
    800049d8:	00007797          	auipc	a5,0x7
    800049dc:	2ea7bc23          	sd	a0,760(a5) # 8000bcd0 <_ZN3TCB7runningE>
    void setStatus(Status s) { status = s; }
    800049e0:	02052823          	sw	zero,48(a0)
    TCB::contextSwitch(&old->context, &running->context);
    800049e4:	02050593          	addi	a1,a0,32
    800049e8:	02048513          	addi	a0,s1,32
    800049ec:	ffffc097          	auipc	ra,0xffffc
    800049f0:	754080e7          	jalr	1876(ra) # 80001140 <_ZN3TCB13contextSwitchEPNS_7ContextES1_>
}
    800049f4:	01813083          	ld	ra,24(sp)
    800049f8:	01013403          	ld	s0,16(sp)
    800049fc:	00813483          	ld	s1,8(sp)
    80004a00:	02010113          	addi	sp,sp,32
    80004a04:	00008067          	ret
    if (old->getStatus() == RUNNING) { Scheduler::put(old); }
    80004a08:	00048513          	mv	a0,s1
    80004a0c:	00001097          	auipc	ra,0x1
    80004a10:	504080e7          	jalr	1284(ra) # 80005f10 <_ZN9Scheduler3putEP3TCB>
    80004a14:	fbdff06f          	j	800049d0 <_ZN3TCB8dispatchEv+0x24>

0000000080004a18 <_ZN3TCBnwEm>:
void *TCB::operator new(size_t size) {
    80004a18:	ff010113          	addi	sp,sp,-16
    80004a1c:	00113423          	sd	ra,8(sp)
    80004a20:	00813023          	sd	s0,0(sp)
    80004a24:	01010413          	addi	s0,sp,16
    size_t numofBlocks = (size + MemoryAllocator::HEADER_SIZE + MEM_BLOCK_SIZE - 1)/MEM_BLOCK_SIZE;
    80004a28:	04f50513          	addi	a0,a0,79
    return MemoryAllocator::my_mem_alloc(numofBlocks);
    80004a2c:	00655513          	srli	a0,a0,0x6
    80004a30:	00002097          	auipc	ra,0x2
    80004a34:	b9c080e7          	jalr	-1124(ra) # 800065cc <_ZN15MemoryAllocator12my_mem_allocEm>
}
    80004a38:	00813083          	ld	ra,8(sp)
    80004a3c:	00013403          	ld	s0,0(sp)
    80004a40:	01010113          	addi	sp,sp,16
    80004a44:	00008067          	ret

0000000080004a48 <_ZN3TCBdlEPv>:
void TCB::operator delete(void *p) {
    80004a48:	ff010113          	addi	sp,sp,-16
    80004a4c:	00113423          	sd	ra,8(sp)
    80004a50:	00813023          	sd	s0,0(sp)
    80004a54:	01010413          	addi	s0,sp,16
    MemoryAllocator::my_mem_free(p);
    80004a58:	00002097          	auipc	ra,0x2
    80004a5c:	c98080e7          	jalr	-872(ra) # 800066f0 <_ZN15MemoryAllocator11my_mem_freeEPKv>
}
    80004a60:	00813083          	ld	ra,8(sp)
    80004a64:	00013403          	ld	s0,0(sp)
    80004a68:	01010113          	addi	sp,sp,16
    80004a6c:	00008067          	ret

0000000080004a70 <_ZN3TCBC1EPFvPvES0_S0_m>:
        timeSlice(timeSlice)
    80004a70:	00b53423          	sd	a1,8(a0)
    80004a74:	00c53823          	sd	a2,16(a0)
    80004a78:	00d53c23          	sd	a3,24(a0)
    80004a7c:	00000797          	auipc	a5,0x0
    80004a80:	ed478793          	addi	a5,a5,-300 # 80004950 <_ZN3TCB13threadWrapperEv>
    80004a84:	02f53023          	sd	a5,32(a0)
            (uint64) &(this->stack[DEFAULT_STACK_SIZE])              //POKAZUJE IZNAD NAJVISE LOKACIJE
    80004a88:	000087b7          	lui	a5,0x8
    80004a8c:	00f686b3          	add	a3,a3,a5
        timeSlice(timeSlice)
    80004a90:	02d53423          	sd	a3,40(a0)
    80004a94:	02e53c23          	sd	a4,56(a0)
    if (body != nullptr) { Scheduler::put(this); }              //za main ce dispatch staviti, a ne konstruktor
    80004a98:	02058663          	beqz	a1,80004ac4 <_ZN3TCBC1EPFvPvES0_S0_m+0x54>
TCB::TCB(Body body, void* arg, void* stack, uint64 timeSlice) :
    80004a9c:	ff010113          	addi	sp,sp,-16
    80004aa0:	00113423          	sd	ra,8(sp)
    80004aa4:	00813023          	sd	s0,0(sp)
    80004aa8:	01010413          	addi	s0,sp,16
    if (body != nullptr) { Scheduler::put(this); }              //za main ce dispatch staviti, a ne konstruktor
    80004aac:	00001097          	auipc	ra,0x1
    80004ab0:	464080e7          	jalr	1124(ra) # 80005f10 <_ZN9Scheduler3putEP3TCB>
}
    80004ab4:	00813083          	ld	ra,8(sp)
    80004ab8:	00013403          	ld	s0,0(sp)
    80004abc:	01010113          	addi	sp,sp,16
    80004ac0:	00008067          	ret
    80004ac4:	00008067          	ret

0000000080004ac8 <_ZN3TCB12createThreadEPFvPvES0_S0_m>:
TCB *TCB::createThread(Body body, void* arg, void* stack, uint64 timeSlice) {
    80004ac8:	fc010113          	addi	sp,sp,-64
    80004acc:	02113c23          	sd	ra,56(sp)
    80004ad0:	02813823          	sd	s0,48(sp)
    80004ad4:	02913423          	sd	s1,40(sp)
    80004ad8:	03213023          	sd	s2,32(sp)
    80004adc:	01313c23          	sd	s3,24(sp)
    80004ae0:	01413823          	sd	s4,16(sp)
    80004ae4:	01513423          	sd	s5,8(sp)
    80004ae8:	04010413          	addi	s0,sp,64
    80004aec:	00050913          	mv	s2,a0
    80004af0:	00058993          	mv	s3,a1
    80004af4:	00060a13          	mv	s4,a2
    80004af8:	00068a93          	mv	s5,a3
    return new TCB(body, arg, stack, timeSlice);
    80004afc:	04000513          	li	a0,64
    80004b00:	00000097          	auipc	ra,0x0
    80004b04:	f18080e7          	jalr	-232(ra) # 80004a18 <_ZN3TCBnwEm>
    80004b08:	00050493          	mv	s1,a0
    80004b0c:	000a8713          	mv	a4,s5
    80004b10:	000a0693          	mv	a3,s4
    80004b14:	00098613          	mv	a2,s3
    80004b18:	00090593          	mv	a1,s2
    80004b1c:	00000097          	auipc	ra,0x0
    80004b20:	f54080e7          	jalr	-172(ra) # 80004a70 <_ZN3TCBC1EPFvPvES0_S0_m>
    80004b24:	0200006f          	j	80004b44 <_ZN3TCB12createThreadEPFvPvES0_S0_m+0x7c>
    80004b28:	00050913          	mv	s2,a0
    80004b2c:	00048513          	mv	a0,s1
    80004b30:	00000097          	auipc	ra,0x0
    80004b34:	f18080e7          	jalr	-232(ra) # 80004a48 <_ZN3TCBdlEPv>
    80004b38:	00090513          	mv	a0,s2
    80004b3c:	00009097          	auipc	ra,0x9
    80004b40:	b1c080e7          	jalr	-1252(ra) # 8000d658 <_Unwind_Resume>
}
    80004b44:	00048513          	mv	a0,s1
    80004b48:	03813083          	ld	ra,56(sp)
    80004b4c:	03013403          	ld	s0,48(sp)
    80004b50:	02813483          	ld	s1,40(sp)
    80004b54:	02013903          	ld	s2,32(sp)
    80004b58:	01813983          	ld	s3,24(sp)
    80004b5c:	01013a03          	ld	s4,16(sp)
    80004b60:	00813a83          	ld	s5,8(sp)
    80004b64:	04010113          	addi	sp,sp,64
    80004b68:	00008067          	ret

0000000080004b6c <_ZN3TCB7initTCBEv>:
void TCB::initTCB() {
    80004b6c:	fe010113          	addi	sp,sp,-32
    80004b70:	00113c23          	sd	ra,24(sp)
    80004b74:	00813823          	sd	s0,16(sp)
    80004b78:	00913423          	sd	s1,8(sp)
    80004b7c:	01213023          	sd	s2,0(sp)
    80004b80:	02010413          	addi	s0,sp,32
    TCB* mainThread = new TCB(nullptr, nullptr,nullptr,DEFAULT_TIME_SLICE);
    80004b84:	04000513          	li	a0,64
    80004b88:	00000097          	auipc	ra,0x0
    80004b8c:	e90080e7          	jalr	-368(ra) # 80004a18 <_ZN3TCBnwEm>
    80004b90:	00050493          	mv	s1,a0
    80004b94:	00200713          	li	a4,2
    80004b98:	00000693          	li	a3,0
    80004b9c:	00000613          	li	a2,0
    80004ba0:	00000593          	li	a1,0
    80004ba4:	00000097          	auipc	ra,0x0
    80004ba8:	ecc080e7          	jalr	-308(ra) # 80004a70 <_ZN3TCBC1EPFvPvES0_S0_m>
    running = mainThread;
    80004bac:	00007797          	auipc	a5,0x7
    80004bb0:	1297b223          	sd	s1,292(a5) # 8000bcd0 <_ZN3TCB7runningE>
    80004bb4:	0204a823          	sw	zero,48(s1)
    __asm__ volatile ("csrw sip, %[sip]" : : [sip] "r"(sip));
}

inline void Riscv::ms_sstatus(uint64 mask)
{
    __asm__ volatile ("csrs sstatus, %[mask]" : : [mask] "r"(mask));
    80004bb8:	00200793          	li	a5,2
    80004bbc:	1007a073          	csrs	sstatus,a5
    myConsole::console_init();
    80004bc0:	00002097          	auipc	ra,0x2
    80004bc4:	c5c080e7          	jalr	-932(ra) # 8000681c <_ZN9myConsole12console_initEv>
    thread_create(&TCB::console, myConsole::sendCharacterOut, nullptr);
    80004bc8:	00000613          	li	a2,0
    80004bcc:	00002597          	auipc	a1,0x2
    80004bd0:	ec458593          	addi	a1,a1,-316 # 80006a90 <_ZN9myConsole16sendCharacterOutEPv>
    80004bd4:	00007517          	auipc	a0,0x7
    80004bd8:	0f450513          	addi	a0,a0,244 # 8000bcc8 <_ZN3TCB7consoleE>
    80004bdc:	00000097          	auipc	ra,0x0
    80004be0:	28c080e7          	jalr	652(ra) # 80004e68 <_Z13thread_createPP3TCBPFvPvES2_>
    thread_dispatch();
    80004be4:	00000097          	auipc	ra,0x0
    80004be8:	34c080e7          	jalr	844(ra) # 80004f30 <_Z15thread_dispatchv>
    TCB::userMode = true;
    80004bec:	00100793          	li	a5,1
    80004bf0:	00007717          	auipc	a4,0x7
    80004bf4:	0cf704a3          	sb	a5,201(a4) # 8000bcb9 <_ZN3TCB8userModeE>
    thread_create(&TCB::usrMain, TCB::wraperUsrMain, nullptr);
    80004bf8:	00000613          	li	a2,0
    80004bfc:	00000597          	auipc	a1,0x0
    80004c00:	d0c58593          	addi	a1,a1,-756 # 80004908 <_ZN3TCB13wraperUsrMainEPv>
    80004c04:	00007517          	auipc	a0,0x7
    80004c08:	0bc50513          	addi	a0,a0,188 # 8000bcc0 <_ZN3TCB7usrMainE>
    80004c0c:	00000097          	auipc	ra,0x0
    80004c10:	25c080e7          	jalr	604(ra) # 80004e68 <_Z13thread_createPP3TCBPFvPvES2_>
}
    80004c14:	01813083          	ld	ra,24(sp)
    80004c18:	01013403          	ld	s0,16(sp)
    80004c1c:	00813483          	ld	s1,8(sp)
    80004c20:	00013903          	ld	s2,0(sp)
    80004c24:	02010113          	addi	sp,sp,32
    80004c28:	00008067          	ret
    80004c2c:	00050913          	mv	s2,a0
    TCB* mainThread = new TCB(nullptr, nullptr,nullptr,DEFAULT_TIME_SLICE);
    80004c30:	00048513          	mv	a0,s1
    80004c34:	00000097          	auipc	ra,0x0
    80004c38:	e14080e7          	jalr	-492(ra) # 80004a48 <_ZN3TCBdlEPv>
    80004c3c:	00090513          	mv	a0,s2
    80004c40:	00009097          	auipc	ra,0x9
    80004c44:	a18080e7          	jalr	-1512(ra) # 8000d658 <_Unwind_Resume>

0000000080004c48 <_ZN3TCB19prepareThreadCreateEPPS_PFvPvES2_S2_>:
void TCB::prepareThreadCreate(TCB **handle, Body start_routine, void* arg, void* stack_start) {
    80004c48:	fe010113          	addi	sp,sp,-32
    80004c4c:	00113c23          	sd	ra,24(sp)
    80004c50:	00813823          	sd	s0,16(sp)
    80004c54:	00913423          	sd	s1,8(sp)
    80004c58:	02010413          	addi	s0,sp,32
    80004c5c:	00050493          	mv	s1,a0
    80004c60:	00058513          	mv	a0,a1
    80004c64:	00060593          	mv	a1,a2
    80004c68:	00068613          	mv	a2,a3
    (*handle) = createThread((TCB::Body) start_routine, arg, stack_start, DEFAULT_TIME_SLICE);
    80004c6c:	00200693          	li	a3,2
    80004c70:	00000097          	auipc	ra,0x0
    80004c74:	e58080e7          	jalr	-424(ra) # 80004ac8 <_ZN3TCB12createThreadEPFvPvES0_S0_m>
    80004c78:	00a4b023          	sd	a0,0(s1)
   if (!(*handle)) {
    80004c7c:	02050263          	beqz	a0,80004ca0 <_ZN3TCB19prepareThreadCreateEPPS_PFvPvES2_S2_+0x58>
   __asm__ volatile("li a0, 0");
    80004c80:	00000513          	li	a0,0
    Riscv::setA0onStack();
    80004c84:	00000097          	auipc	ra,0x0
    80004c88:	6cc080e7          	jalr	1740(ra) # 80005350 <_ZN5Riscv12setA0onStackEv>
}
    80004c8c:	01813083          	ld	ra,24(sp)
    80004c90:	01013403          	ld	s0,16(sp)
    80004c94:	00813483          	ld	s1,8(sp)
    80004c98:	02010113          	addi	sp,sp,32
    80004c9c:	00008067          	ret
       __asm__ volatile("li a0, 0xffffffffffffffff");           //unsuccessful alloc ret = -1
    80004ca0:	fff00513          	li	a0,-1
    80004ca4:	fddff06f          	j	80004c80 <_ZN3TCB19prepareThreadCreateEPPS_PFvPvES2_S2_+0x38>

0000000080004ca8 <_ZN3TCB17prepareThreadExitEv>:
void TCB::prepareThreadExit() {
    80004ca8:	ff010113          	addi	sp,sp,-16
    80004cac:	00113423          	sd	ra,8(sp)
    80004cb0:	00813023          	sd	s0,0(sp)
    80004cb4:	01010413          	addi	s0,sp,16
    TCB::timeSliceCounter = 0;
    80004cb8:	00007797          	auipc	a5,0x7
    80004cbc:	fe07bc23          	sd	zero,-8(a5) # 8000bcb0 <_ZN3TCB16timeSliceCounterE>
    80004cc0:	00007797          	auipc	a5,0x7
    80004cc4:	0107b783          	ld	a5,16(a5) # 8000bcd0 <_ZN3TCB7runningE>
    80004cc8:	00300713          	li	a4,3
    80004ccc:	02e7a823          	sw	a4,48(a5)
    TCB::dispatch();
    80004cd0:	00000097          	auipc	ra,0x0
    80004cd4:	cdc080e7          	jalr	-804(ra) # 800049ac <_ZN3TCB8dispatchEv>
    __asm__ volatile("li a0, 0");
    80004cd8:	00000513          	li	a0,0
    Riscv::setA0onStack();
    80004cdc:	00000097          	auipc	ra,0x0
    80004ce0:	674080e7          	jalr	1652(ra) # 80005350 <_ZN5Riscv12setA0onStackEv>
}
    80004ce4:	00813083          	ld	ra,8(sp)
    80004ce8:	00013403          	ld	s0,0(sp)
    80004cec:	01010113          	addi	sp,sp,16
    80004cf0:	00008067          	ret

0000000080004cf4 <_ZN3TCB16prepareTimeSleepEm>:
void TCB::prepareTimeSleep(time_t ms) {
    80004cf4:	fe010113          	addi	sp,sp,-32
    80004cf8:	00113c23          	sd	ra,24(sp)
    80004cfc:	00813823          	sd	s0,16(sp)
    80004d00:	00913423          	sd	s1,8(sp)
    80004d04:	02010413          	addi	s0,sp,32
    TCB::timeSliceCounter = 0;
    80004d08:	00007797          	auipc	a5,0x7
    80004d0c:	fa07b423          	sd	zero,-88(a5) # 8000bcb0 <_ZN3TCB16timeSliceCounterE>
    int ret = SleepingQueue::setToSleep((time_t) ms);
    80004d10:	00000097          	auipc	ra,0x0
    80004d14:	4b0080e7          	jalr	1200(ra) # 800051c0 <_ZN13SleepingQueue10setToSleepEm>
    80004d18:	00050493          	mv	s1,a0
    TCB::dispatch();
    80004d1c:	00000097          	auipc	ra,0x0
    80004d20:	c90080e7          	jalr	-880(ra) # 800049ac <_ZN3TCB8dispatchEv>
    __asm__ volatile("mv a0, %0" : : "r"(ret));
    80004d24:	00048513          	mv	a0,s1
    Riscv::setA0onStack();
    80004d28:	00000097          	auipc	ra,0x0
    80004d2c:	628080e7          	jalr	1576(ra) # 80005350 <_ZN5Riscv12setA0onStackEv>
}
    80004d30:	01813083          	ld	ra,24(sp)
    80004d34:	01013403          	ld	s0,16(sp)
    80004d38:	00813483          	ld	s1,8(sp)
    80004d3c:	02010113          	addi	sp,sp,32
    80004d40:	00008067          	ret

0000000080004d44 <_ZN3TCB10isFinishedEv>:
bool TCB::isFinished() {
    80004d44:	ff010113          	addi	sp,sp,-16
    80004d48:	00813423          	sd	s0,8(sp)
    80004d4c:	01010413          	addi	s0,sp,16
    return status == FINISHED;
    80004d50:	03052503          	lw	a0,48(a0)
    80004d54:	ffd50513          	addi	a0,a0,-3
}
    80004d58:	00153513          	seqz	a0,a0
    80004d5c:	00813403          	ld	s0,8(sp)
    80004d60:	01010113          	addi	sp,sp,16
    80004d64:	00008067          	ret

0000000080004d68 <_ZN3TCB6endTCBEv>:
void TCB::endTCB() {
    80004d68:	ff010113          	addi	sp,sp,-16
    80004d6c:	00113423          	sd	ra,8(sp)
    80004d70:	00813023          	sd	s0,0(sp)
    80004d74:	01010413          	addi	s0,sp,16
    while (!TCB::usrMain->isFinished()) {
    80004d78:	00007517          	auipc	a0,0x7
    80004d7c:	f4853503          	ld	a0,-184(a0) # 8000bcc0 <_ZN3TCB7usrMainE>
    80004d80:	00000097          	auipc	ra,0x0
    80004d84:	fc4080e7          	jalr	-60(ra) # 80004d44 <_ZN3TCB10isFinishedEv>
    80004d88:	00051863          	bnez	a0,80004d98 <_ZN3TCB6endTCBEv+0x30>
        thread_dispatch();
    80004d8c:	00000097          	auipc	ra,0x0
    80004d90:	1a4080e7          	jalr	420(ra) # 80004f30 <_Z15thread_dispatchv>
    while (!TCB::usrMain->isFinished()) {
    80004d94:	fe5ff06f          	j	80004d78 <_ZN3TCB6endTCBEv+0x10>
    myConsole::numberOfCharToGet = 0;
    80004d98:	00007797          	auipc	a5,0x7
    80004d9c:	f607b423          	sd	zero,-152(a5) # 8000bd00 <_ZN9myConsole17numberOfCharToGetE>
    myConsole::stopConsole = true;
    80004da0:	00100793          	li	a5,1
    80004da4:	00007717          	auipc	a4,0x7
    80004da8:	f4f70a23          	sb	a5,-172(a4) # 8000bcf8 <_ZN9myConsole11stopConsoleE>
    while (!TCB::console->isFinished()) {
    80004dac:	00007517          	auipc	a0,0x7
    80004db0:	f1c53503          	ld	a0,-228(a0) # 8000bcc8 <_ZN3TCB7consoleE>
    80004db4:	00000097          	auipc	ra,0x0
    80004db8:	f90080e7          	jalr	-112(ra) # 80004d44 <_ZN3TCB10isFinishedEv>
    80004dbc:	00051863          	bnez	a0,80004dcc <_ZN3TCB6endTCBEv+0x64>
        thread_dispatch();
    80004dc0:	00000097          	auipc	ra,0x0
    80004dc4:	170080e7          	jalr	368(ra) # 80004f30 <_Z15thread_dispatchv>
    while (!TCB::console->isFinished()) {
    80004dc8:	fe5ff06f          	j	80004dac <_ZN3TCB6endTCBEv+0x44>
}
    80004dcc:	00813083          	ld	ra,8(sp)
    80004dd0:	00013403          	ld	s0,0(sp)
    80004dd4:	01010113          	addi	sp,sp,16
    80004dd8:	00008067          	ret

0000000080004ddc <_Z9mem_allocm>:
#include "../test/printing.hpp"
//#include "../lib/mem.h"


void *mem_alloc(size_t size) {              // size = number of bytes
    if (size == 0) return nullptr;
    80004ddc:	04050063          	beqz	a0,80004e1c <_Z9mem_allocm+0x40>
void *mem_alloc(size_t size) {              // size = number of bytes
    80004de0:	fe010113          	addi	sp,sp,-32
    80004de4:	00813c23          	sd	s0,24(sp)
    80004de8:	02010413          	addi	s0,sp,32

    //prepare for system call
    size_t numofBlocks = (size + MemoryAllocator::HEADER_SIZE + MEM_BLOCK_SIZE - 1)/MEM_BLOCK_SIZE;        //whole number of blocks
    80004dec:	04f50513          	addi	a0,a0,79
    80004df0:	00655513          	srli	a0,a0,0x6
    __asm__ volatile("mv a1, %0" : : "r"(numofBlocks));
    80004df4:	00050593          	mv	a1,a0
    __asm__ volatile("li a0, 0x1");                                           //opCode
    80004df8:	00100513          	li	a0,1

    __asm__ volatile("ecall");      //system call -> prelaz u sistemski rezim
    80004dfc:	00000073          	ecall

    //return value
    uint64 volatile ret = 0;
    80004e00:	fe043423          	sd	zero,-24(s0)
    __asm__ volatile("mv %0, a0" : "=r"(ret));
    80004e04:	00050793          	mv	a5,a0
    80004e08:	fef43423          	sd	a5,-24(s0)
    return (void*) ret;
    80004e0c:	fe843503          	ld	a0,-24(s0)
}
    80004e10:	01813403          	ld	s0,24(sp)
    80004e14:	02010113          	addi	sp,sp,32
    80004e18:	00008067          	ret
    if (size == 0) return nullptr;
    80004e1c:	00000513          	li	a0,0
}
    80004e20:	00008067          	ret

0000000080004e24 <_Z8mem_freePv>:

int mem_free(void *mem) {
    if (!mem) return -1;
    80004e24:	02050e63          	beqz	a0,80004e60 <_Z8mem_freePv+0x3c>
int mem_free(void *mem) {
    80004e28:	fe010113          	addi	sp,sp,-32
    80004e2c:	00813c23          	sd	s0,24(sp)
    80004e30:	02010413          	addi	s0,sp,32
    uint64 address = (uint64) mem;

    //prepare for system call
    __asm__ volatile("mv a1, %0" : : "r"(address));
    80004e34:	00050593          	mv	a1,a0
    __asm__ volatile("li a0, 2");                                           //opCode
    80004e38:	00200513          	li	a0,2

    __asm__ volatile("ecall");      //system call -> prelaz u sistemski rezim
    80004e3c:	00000073          	ecall

    //return value
    int volatile ret = 0;
    80004e40:	fe042623          	sw	zero,-20(s0)
    __asm__ volatile("mv %0, a0" : "=r"(ret));
    80004e44:	00050793          	mv	a5,a0
    80004e48:	fef42623          	sw	a5,-20(s0)
    return ret;
    80004e4c:	fec42503          	lw	a0,-20(s0)
    80004e50:	0005051b          	sext.w	a0,a0
}
    80004e54:	01813403          	ld	s0,24(sp)
    80004e58:	02010113          	addi	sp,sp,32
    80004e5c:	00008067          	ret
    if (!mem) return -1;
    80004e60:	fff00513          	li	a0,-1
}
    80004e64:	00008067          	ret

0000000080004e68 <_Z13thread_createPP3TCBPFvPvES2_>:

int thread_create(thread_t *handle, void(*start_routine)(void *), void *arg) {
    if (!handle) return -1;
    80004e68:	08050263          	beqz	a0,80004eec <_Z13thread_createPP3TCBPFvPvES2_+0x84>
int thread_create(thread_t *handle, void(*start_routine)(void *), void *arg) {
    80004e6c:	fc010113          	addi	sp,sp,-64
    80004e70:	02113c23          	sd	ra,56(sp)
    80004e74:	02813823          	sd	s0,48(sp)
    80004e78:	04010413          	addi	s0,sp,64
    uint64 volatile _handle = (uint64) handle;
    80004e7c:	fea43423          	sd	a0,-24(s0)
    uint64 volatile _start_routine = (uint64) start_routine;
    80004e80:	feb43023          	sd	a1,-32(s0)
    uint64 volatile _arg = (uint64) arg;
    80004e84:	fcc43c23          	sd	a2,-40(s0)

    //allocate stack
    uint64 volatile _stack_space = (uint64) (new uint64[DEFAULT_STACK_SIZE]);
    80004e88:	00008537          	lui	a0,0x8
    80004e8c:	00001097          	auipc	ra,0x1
    80004e90:	1b4080e7          	jalr	436(ra) # 80006040 <_Znam>
    80004e94:	fca43823          	sd	a0,-48(s0)
    if (_stack_space == 0) return -2;
    80004e98:	fd043783          	ld	a5,-48(s0)
    80004e9c:	04078c63          	beqz	a5,80004ef4 <_Z13thread_createPP3TCBPFvPvES2_+0x8c>

    //args
    __asm__ volatile("mv a1, %0" : : "r"(_handle));
    80004ea0:	fe843783          	ld	a5,-24(s0)
    80004ea4:	00078593          	mv	a1,a5
    __asm__ volatile("mv a2, %0" : : "r"(_start_routine));
    80004ea8:	fe043783          	ld	a5,-32(s0)
    80004eac:	00078613          	mv	a2,a5
    __asm__ volatile("mv a3, %0" : : "r"(_arg));
    80004eb0:	fd843783          	ld	a5,-40(s0)
    80004eb4:	00078693          	mv	a3,a5
    __asm__ volatile("mv a4, %0" : : "r"(_stack_space));
    80004eb8:	fd043783          	ld	a5,-48(s0)
    80004ebc:	00078713          	mv	a4,a5
    __asm__ volatile("li a0, 0x11");            //opCode
    80004ec0:	01100513          	li	a0,17

    __asm__ volatile("ecall");          //system call -> prelaz u sistemski rezim
    80004ec4:	00000073          	ecall

    //return value
    int volatile ret = 0;
    80004ec8:	fc042623          	sw	zero,-52(s0)
    __asm__ volatile("mv %0, a0" : "=r"(ret));
    80004ecc:	00050793          	mv	a5,a0
    80004ed0:	fcf42623          	sw	a5,-52(s0)
    return ret;
    80004ed4:	fcc42503          	lw	a0,-52(s0)
    80004ed8:	0005051b          	sext.w	a0,a0
}
    80004edc:	03813083          	ld	ra,56(sp)
    80004ee0:	03013403          	ld	s0,48(sp)
    80004ee4:	04010113          	addi	sp,sp,64
    80004ee8:	00008067          	ret
    if (!handle) return -1;
    80004eec:	fff00513          	li	a0,-1
}
    80004ef0:	00008067          	ret
    if (_stack_space == 0) return -2;
    80004ef4:	ffe00513          	li	a0,-2
    80004ef8:	fe5ff06f          	j	80004edc <_Z13thread_createPP3TCBPFvPvES2_+0x74>

0000000080004efc <_Z11thread_exitv>:

int thread_exit() {
    80004efc:	fe010113          	addi	sp,sp,-32
    80004f00:	00813c23          	sd	s0,24(sp)
    80004f04:	02010413          	addi	s0,sp,32
    __asm__ volatile("li a0, 0x12");            //opCode
    80004f08:	01200513          	li	a0,18

    __asm__ volatile("ecall");          //system call -> prelaz u sistemski rezim
    80004f0c:	00000073          	ecall

    //return value
    int volatile ret = 0;
    80004f10:	fe042623          	sw	zero,-20(s0)
    __asm__ volatile("mv %0, a0" : "=r"(ret));
    80004f14:	00050793          	mv	a5,a0
    80004f18:	fef42623          	sw	a5,-20(s0)
    return ret;
    80004f1c:	fec42503          	lw	a0,-20(s0)
}
    80004f20:	0005051b          	sext.w	a0,a0
    80004f24:	01813403          	ld	s0,24(sp)
    80004f28:	02010113          	addi	sp,sp,32
    80004f2c:	00008067          	ret

0000000080004f30 <_Z15thread_dispatchv>:

void thread_dispatch() {
    80004f30:	ff010113          	addi	sp,sp,-16
    80004f34:	00113423          	sd	ra,8(sp)
    80004f38:	00813023          	sd	s0,0(sp)
    80004f3c:	01010413          	addi	s0,sp,16
    TCB::yield();
    80004f40:	00000097          	auipc	ra,0x0
    80004f44:	9f0080e7          	jalr	-1552(ra) # 80004930 <_ZN3TCB5yieldEv>
}
    80004f48:	00813083          	ld	ra,8(sp)
    80004f4c:	00013403          	ld	s0,0(sp)
    80004f50:	01010113          	addi	sp,sp,16
    80004f54:	00008067          	ret

0000000080004f58 <_Z8sem_openPP11mySemaphorej>:

int sem_open(sem_t *handle, unsigned int init) {
    80004f58:	fe010113          	addi	sp,sp,-32
    80004f5c:	00813c23          	sd	s0,24(sp)
    80004f60:	02010413          	addi	s0,sp,32
    //args
    __asm__ volatile("mv a2, %0" : : "r"((uint64) init));       //ako se prvo stavi u a1, ne radi
    80004f64:	02059593          	slli	a1,a1,0x20
    80004f68:	0205d593          	srli	a1,a1,0x20
    80004f6c:	00058613          	mv	a2,a1
    __asm__ volatile("mv a1, %0" : : "r"((uint64) handle));
    80004f70:	00050593          	mv	a1,a0
    __asm__ volatile("li a0, 0x21");            //opCode
    80004f74:	02100513          	li	a0,33

    __asm__ volatile("ecall");          //system call -> prelaz u sistemski rezim
    80004f78:	00000073          	ecall

    //return value
    int volatile ret = 0;
    80004f7c:	fe042623          	sw	zero,-20(s0)
    __asm__ volatile("mv %0, a0" : "=r"(ret));
    80004f80:	00050793          	mv	a5,a0
    80004f84:	fef42623          	sw	a5,-20(s0)
    return ret;
    80004f88:	fec42503          	lw	a0,-20(s0)
}
    80004f8c:	0005051b          	sext.w	a0,a0
    80004f90:	01813403          	ld	s0,24(sp)
    80004f94:	02010113          	addi	sp,sp,32
    80004f98:	00008067          	ret

0000000080004f9c <_Z9sem_closeP11mySemaphore>:

int sem_close(sem_t handle) {
    80004f9c:	fe010113          	addi	sp,sp,-32
    80004fa0:	00813c23          	sd	s0,24(sp)
    80004fa4:	02010413          	addi	s0,sp,32
    //args
    __asm__ volatile("mv a1, %0" : : "r"((uint64) handle));
    80004fa8:	00050593          	mv	a1,a0
    __asm__ volatile("li a0, 0x22");            //opCode
    80004fac:	02200513          	li	a0,34

    __asm__ volatile("ecall");          //system call -> prelaz u sistemski rezim
    80004fb0:	00000073          	ecall

    //return value
    int volatile ret = 0;
    80004fb4:	fe042623          	sw	zero,-20(s0)
    __asm__ volatile("mv %0, a0" : "=r"(ret));
    80004fb8:	00050793          	mv	a5,a0
    80004fbc:	fef42623          	sw	a5,-20(s0)
    return ret;
    80004fc0:	fec42503          	lw	a0,-20(s0)
}
    80004fc4:	0005051b          	sext.w	a0,a0
    80004fc8:	01813403          	ld	s0,24(sp)
    80004fcc:	02010113          	addi	sp,sp,32
    80004fd0:	00008067          	ret

0000000080004fd4 <_Z8sem_waitP11mySemaphore>:

int sem_wait(sem_t id) {
    80004fd4:	fe010113          	addi	sp,sp,-32
    80004fd8:	00813c23          	sd	s0,24(sp)
    80004fdc:	02010413          	addi	s0,sp,32
    //args
    __asm__ volatile("mv a1, %0" : : "r"((uint64) id));
    80004fe0:	00050593          	mv	a1,a0
    __asm__ volatile("li a0, 0x23");            //opCode
    80004fe4:	02300513          	li	a0,35

    __asm__ volatile("ecall");          //system call -> prelaz u sistemski rezim
    80004fe8:	00000073          	ecall

    //return value
    int volatile ret = 0;
    80004fec:	fe042623          	sw	zero,-20(s0)
    __asm__ volatile("mv %0, a0" : "=r"(ret));
    80004ff0:	00050793          	mv	a5,a0
    80004ff4:	fef42623          	sw	a5,-20(s0)
    return ret;
    80004ff8:	fec42503          	lw	a0,-20(s0)
}
    80004ffc:	0005051b          	sext.w	a0,a0
    80005000:	01813403          	ld	s0,24(sp)
    80005004:	02010113          	addi	sp,sp,32
    80005008:	00008067          	ret

000000008000500c <_Z10sem_signalP11mySemaphore>:

int sem_signal(sem_t id) {
    8000500c:	fe010113          	addi	sp,sp,-32
    80005010:	00813c23          	sd	s0,24(sp)
    80005014:	02010413          	addi	s0,sp,32
    //args
    __asm__ volatile("mv a1, %0" : : "r"((uint64) id));
    80005018:	00050593          	mv	a1,a0
    __asm__ volatile("li a0, 0x24");            //opCode
    8000501c:	02400513          	li	a0,36

    __asm__ volatile("ecall");          //system call -> prelaz u sistemski rezim
    80005020:	00000073          	ecall

    //return value
    int volatile ret = 0;
    80005024:	fe042623          	sw	zero,-20(s0)
    __asm__ volatile("mv %0, a0" : "=r"(ret));
    80005028:	00050793          	mv	a5,a0
    8000502c:	fef42623          	sw	a5,-20(s0)
    return ret;
    80005030:	fec42503          	lw	a0,-20(s0)
}
    80005034:	0005051b          	sext.w	a0,a0
    80005038:	01813403          	ld	s0,24(sp)
    8000503c:	02010113          	addi	sp,sp,32
    80005040:	00008067          	ret

0000000080005044 <_Z13sem_timedwaitP11mySemaphorem>:

int sem_timedwait(sem_t id, time_t timeout) {
    80005044:	fe010113          	addi	sp,sp,-32
    80005048:	00813c23          	sd	s0,24(sp)
    8000504c:	02010413          	addi	s0,sp,32
    //args
    __asm__ volatile("mv a2, %0" : : "r"((uint64) timeout));
    80005050:	00058613          	mv	a2,a1
    __asm__ volatile("mv a1, %0" : : "r"((uint64) id));
    80005054:	00050593          	mv	a1,a0
    __asm__ volatile("li a0, 0x25");            //opCode
    80005058:	02500513          	li	a0,37

    __asm__ volatile("ecall");          //system call -> prelaz u sistemski rezim
    8000505c:	00000073          	ecall

    //return valueFFFFFFFE if timer ends
    int volatile ret = 0;
    80005060:	fe042623          	sw	zero,-20(s0)
    __asm__ volatile("mv %0, a0" : "=r"(ret));
    80005064:	00050793          	mv	a5,a0
    80005068:	fef42623          	sw	a5,-20(s0)
    return ret;
    8000506c:	fec42503          	lw	a0,-20(s0)
}
    80005070:	0005051b          	sext.w	a0,a0
    80005074:	01813403          	ld	s0,24(sp)
    80005078:	02010113          	addi	sp,sp,32
    8000507c:	00008067          	ret

0000000080005080 <_Z11sem_trywaitP11mySemaphore>:

int sem_trywait(sem_t id) {
    80005080:	fe010113          	addi	sp,sp,-32
    80005084:	00813c23          	sd	s0,24(sp)
    80005088:	02010413          	addi	s0,sp,32
    //args
    __asm__ volatile("mv a1, %0" : : "r"((uint64) id));
    8000508c:	00050593          	mv	a1,a0
    __asm__ volatile("li a0, 0x26");            //opCode
    80005090:	02600513          	li	a0,38

    __asm__ volatile("ecall");          //system call -> prelaz u sistemski rezim
    80005094:	00000073          	ecall

    //return value
    int volatile ret = 0;
    80005098:	fe042623          	sw	zero,-20(s0)
    __asm__ volatile("mv %0, a0" : "=r"(ret));
    8000509c:	00050793          	mv	a5,a0
    800050a0:	fef42623          	sw	a5,-20(s0)
    return ret;
    800050a4:	fec42503          	lw	a0,-20(s0)
}
    800050a8:	0005051b          	sext.w	a0,a0
    800050ac:	01813403          	ld	s0,24(sp)
    800050b0:	02010113          	addi	sp,sp,32
    800050b4:	00008067          	ret

00000000800050b8 <_Z10time_sleepm>:

int time_sleep(time_t ms) {
    if (ms == 0) {
    800050b8:	02050e63          	beqz	a0,800050f4 <_Z10time_sleepm+0x3c>
int time_sleep(time_t ms) {
    800050bc:	fe010113          	addi	sp,sp,-32
    800050c0:	00813c23          	sd	s0,24(sp)
    800050c4:	02010413          	addi	s0,sp,32
        return 0;
    }
    //args
    __asm__ volatile("mv a1, %0" : : "r"((uint64) ms));
    800050c8:	00050593          	mv	a1,a0
    __asm__ volatile("li a0, 0x31");            //opCode
    800050cc:	03100513          	li	a0,49

    __asm__ volatile("ecall");
    800050d0:	00000073          	ecall

    //return value
    int volatile ret = 0;
    800050d4:	fe042623          	sw	zero,-20(s0)
    __asm__ volatile("mv %0, a0" : "=r"(ret));
    800050d8:	00050793          	mv	a5,a0
    800050dc:	fef42623          	sw	a5,-20(s0)
    return ret;
    800050e0:	fec42503          	lw	a0,-20(s0)
    800050e4:	0005051b          	sext.w	a0,a0
}
    800050e8:	01813403          	ld	s0,24(sp)
    800050ec:	02010113          	addi	sp,sp,32
    800050f0:	00008067          	ret
        return 0;
    800050f4:	00000513          	li	a0,0
}
    800050f8:	00008067          	ret

00000000800050fc <_Z4getcv>:

char getc() {
    800050fc:	fe010113          	addi	sp,sp,-32
    80005100:	00813c23          	sd	s0,24(sp)
    80005104:	02010413          	addi	s0,sp,32
    __asm__ volatile("li a0, 0x41");            //opCode
    80005108:	04100513          	li	a0,65

    __asm__ volatile("ecall");
    8000510c:	00000073          	ecall

    //return value
    int volatile ret = 0;
    80005110:	fe042623          	sw	zero,-20(s0)
    __asm__ volatile("mv %0, a0" : "=r"(ret));
    80005114:	00050793          	mv	a5,a0
    80005118:	fef42623          	sw	a5,-20(s0)
    return ret;
    8000511c:	fec42503          	lw	a0,-20(s0)
}
    80005120:	0ff57513          	andi	a0,a0,255
    80005124:	01813403          	ld	s0,24(sp)
    80005128:	02010113          	addi	sp,sp,32
    8000512c:	00008067          	ret

0000000080005130 <_Z4putcc>:

void putc(char c) {
    80005130:	ff010113          	addi	sp,sp,-16
    80005134:	00813423          	sd	s0,8(sp)
    80005138:	01010413          	addi	s0,sp,16
    //args
    __asm__ volatile("mv a1, %0" : : "r"((uint64) c));
    8000513c:	00050593          	mv	a1,a0
    __asm__ volatile("li a0, 0x42");            //opCode
    80005140:	04200513          	li	a0,66

    __asm__ volatile("ecall");
    80005144:	00000073          	ecall
}
    80005148:	00813403          	ld	s0,8(sp)
    8000514c:	01010113          	addi	sp,sp,16
    80005150:	00008067          	ret

0000000080005154 <_Z10putcHelperv>:

char putcHelper() {
    80005154:	fe010113          	addi	sp,sp,-32
    80005158:	00813c23          	sd	s0,24(sp)
    8000515c:	02010413          	addi	s0,sp,32

    __asm__ volatile("li a0, 0x100");            //opCode
    80005160:	10000513          	li	a0,256

    __asm__ volatile("ecall");
    80005164:	00000073          	ecall

    //return value
    uint64 volatile ret = 0;
    80005168:	fe043423          	sd	zero,-24(s0)
    __asm__ volatile("mv %0, a0" : "=r"(ret));
    8000516c:	00050793          	mv	a5,a0
    80005170:	fef43423          	sd	a5,-24(s0)
    return (char)ret;
    80005174:	fe843503          	ld	a0,-24(s0)
}
    80005178:	0ff57513          	andi	a0,a0,255
    8000517c:	01813403          	ld	s0,24(sp)
    80005180:	02010113          	addi	sp,sp,32
    80005184:	00008067          	ret

0000000080005188 <_ZN13SleepingQueue14getTimeToSleepEP3TCB>:
#include "../h/SleepingQueue.hpp"

List<TCB>::Node *SleepingQueue::headSleepingTCBs = nullptr;

//not used
uint64 SleepingQueue::getTimeToSleep(TCB *id) {
    80005188:	ff010113          	addi	sp,sp,-16
    8000518c:	00813423          	sd	s0,8(sp)
    80005190:	01010413          	addi	s0,sp,16
    List<TCB>::Node* cur = SleepingQueue::headSleepingTCBs;
    80005194:	00007797          	auipc	a5,0x7
    80005198:	b447b783          	ld	a5,-1212(a5) # 8000bcd8 <_ZN13SleepingQueue16headSleepingTCBsE>
    while (cur) {
    8000519c:	00078a63          	beqz	a5,800051b0 <_ZN13SleepingQueue14getTimeToSleepEP3TCB+0x28>
        if (id == cur->data) {
    800051a0:	0007b703          	ld	a4,0(a5)
    800051a4:	fea71ce3          	bne	a4,a0,8000519c <_ZN13SleepingQueue14getTimeToSleepEP3TCB+0x14>
            return cur->timeBlockOrSleep;
    800051a8:	0107b503          	ld	a0,16(a5)
    800051ac:	0080006f          	j	800051b4 <_ZN13SleepingQueue14getTimeToSleepEP3TCB+0x2c>
        }
    }
    return 0;
    800051b0:	00000513          	li	a0,0
}
    800051b4:	00813403          	ld	s0,8(sp)
    800051b8:	01010113          	addi	sp,sp,16
    800051bc:	00008067          	ret

00000000800051c0 <_ZN13SleepingQueue10setToSleepEm>:

int SleepingQueue::setToSleep(time_t time) {
    if (time == 0) return 0;
    800051c0:	00051663          	bnez	a0,800051cc <_ZN13SleepingQueue10setToSleepEm+0xc>
        prev->next = node;
    } else {
        headSleepingTCBs = node;
    }
    return 0;
}
    800051c4:	00000513          	li	a0,0
    800051c8:	00008067          	ret
int SleepingQueue::setToSleep(time_t time) {
    800051cc:	fe010113          	addi	sp,sp,-32
    800051d0:	00113c23          	sd	ra,24(sp)
    800051d4:	00813823          	sd	s0,16(sp)
    800051d8:	00913423          	sd	s1,8(sp)
    800051dc:	01213023          	sd	s2,0(sp)
    800051e0:	02010413          	addi	s0,sp,32
    800051e4:	00050493          	mv	s1,a0
    TCB::running->setStatus(SLEEPING);
    800051e8:	00007917          	auipc	s2,0x7
    800051ec:	ae890913          	addi	s2,s2,-1304 # 8000bcd0 <_ZN3TCB7runningE>
    800051f0:	00093783          	ld	a5,0(s2)
    800051f4:	00200713          	li	a4,2
    800051f8:	02e7a823          	sw	a4,48(a5)
    List<TCB>::Node *node = (List<TCB>::Node*) MemoryAllocator::my_mem_alloc(1);
    800051fc:	00100513          	li	a0,1
    80005200:	00001097          	auipc	ra,0x1
    80005204:	3cc080e7          	jalr	972(ra) # 800065cc <_ZN15MemoryAllocator12my_mem_allocEm>
    80005208:	00050613          	mv	a2,a0
    node->data = TCB::running;
    8000520c:	00093783          	ld	a5,0(s2)
    80005210:	00f53023          	sd	a5,0(a0) # 8000 <_entry-0x7fff8000>
    node->timeBlockOrSleep = time;
    80005214:	00953823          	sd	s1,16(a0)
    node->next = nullptr;
    80005218:	00053423          	sd	zero,8(a0)
    List<TCB>::Node *cur = headSleepingTCBs;
    8000521c:	00007797          	auipc	a5,0x7
    80005220:	abc7b783          	ld	a5,-1348(a5) # 8000bcd8 <_ZN13SleepingQueue16headSleepingTCBsE>
    List<TCB>::Node *prev = nullptr;
    80005224:	00000593          	li	a1,0
    80005228:	0140006f          	j	8000523c <_ZN13SleepingQueue10setToSleepEm+0x7c>
            node->timeBlockOrSleep -= cur->timeBlockOrSleep;
    8000522c:	40d70733          	sub	a4,a4,a3
    80005230:	00e63823          	sd	a4,16(a2)
    for (; cur; prev = cur, cur = cur->next) {
    80005234:	00078593          	mv	a1,a5
    80005238:	0087b783          	ld	a5,8(a5)
    8000523c:	00078c63          	beqz	a5,80005254 <_ZN13SleepingQueue10setToSleepEm+0x94>
        if (node->timeBlockOrSleep < cur->timeBlockOrSleep) {
    80005240:	01063703          	ld	a4,16(a2)
    80005244:	0107b683          	ld	a3,16(a5)
    80005248:	fed772e3          	bgeu	a4,a3,8000522c <_ZN13SleepingQueue10setToSleepEm+0x6c>
            cur->timeBlockOrSleep -= node->timeBlockOrSleep;
    8000524c:	40e68733          	sub	a4,a3,a4
    80005250:	00e7b823          	sd	a4,16(a5)
    if (cur) {
    80005254:	00078463          	beqz	a5,8000525c <_ZN13SleepingQueue10setToSleepEm+0x9c>
        node->next = cur;
    80005258:	00f63423          	sd	a5,8(a2)
    if (prev) {
    8000525c:	02058263          	beqz	a1,80005280 <_ZN13SleepingQueue10setToSleepEm+0xc0>
        prev->next = node;
    80005260:	00c5b423          	sd	a2,8(a1)
}
    80005264:	00000513          	li	a0,0
    80005268:	01813083          	ld	ra,24(sp)
    8000526c:	01013403          	ld	s0,16(sp)
    80005270:	00813483          	ld	s1,8(sp)
    80005274:	00013903          	ld	s2,0(sp)
    80005278:	02010113          	addi	sp,sp,32
    8000527c:	00008067          	ret
        headSleepingTCBs = node;
    80005280:	00007797          	auipc	a5,0x7
    80005284:	a4c7bc23          	sd	a2,-1448(a5) # 8000bcd8 <_ZN13SleepingQueue16headSleepingTCBsE>
    80005288:	fddff06f          	j	80005264 <_ZN13SleepingQueue10setToSleepEm+0xa4>

000000008000528c <_ZN13SleepingQueue10wakeUpTCBsEv>:

void SleepingQueue::wakeUpTCBs() {
    8000528c:	fe010113          	addi	sp,sp,-32
    80005290:	00113c23          	sd	ra,24(sp)
    80005294:	00813823          	sd	s0,16(sp)
    80005298:	00913423          	sd	s1,8(sp)
    8000529c:	01213023          	sd	s2,0(sp)
    800052a0:	02010413          	addi	s0,sp,32
    if (!headSleepingTCBs) {
    800052a4:	00007497          	auipc	s1,0x7
    800052a8:	a344b483          	ld	s1,-1484(s1) # 8000bcd8 <_ZN13SleepingQueue16headSleepingTCBsE>
    800052ac:	00048c63          	beqz	s1,800052c4 <_ZN13SleepingQueue10wakeUpTCBsEv+0x38>
        return;
    }
    List<TCB>::Node* cur = headSleepingTCBs;
    if (cur->timeBlockOrSleep > 0 && (--cur->timeBlockOrSleep) == 0) {
    800052b0:	0104b783          	ld	a5,16(s1)
    800052b4:	00078863          	beqz	a5,800052c4 <_ZN13SleepingQueue10wakeUpTCBsEv+0x38>
    800052b8:	fff78793          	addi	a5,a5,-1
    800052bc:	00f4b823          	sd	a5,16(s1)
    800052c0:	02078063          	beqz	a5,800052e0 <_ZN13SleepingQueue10wakeUpTCBsEv+0x54>
            cur = cur->next;
            delete prev;
        }
        headSleepingTCBs = cur;
    }
}
    800052c4:	01813083          	ld	ra,24(sp)
    800052c8:	01013403          	ld	s0,16(sp)
    800052cc:	00813483          	ld	s1,8(sp)
    800052d0:	00013903          	ld	s2,0(sp)
    800052d4:	02010113          	addi	sp,sp,32
    800052d8:	00008067          	ret
void SleepingQueue::wakeUpTCBs() {
    800052dc:	00090493          	mv	s1,s2
        while (cur && cur->timeBlockOrSleep == 0) {
    800052e0:	02048863          	beqz	s1,80005310 <_ZN13SleepingQueue10wakeUpTCBsEv+0x84>
    800052e4:	0104b783          	ld	a5,16(s1)
    800052e8:	02079463          	bnez	a5,80005310 <_ZN13SleepingQueue10wakeUpTCBsEv+0x84>
            Scheduler::put(cur->data);
    800052ec:	0004b503          	ld	a0,0(s1)
    800052f0:	00001097          	auipc	ra,0x1
    800052f4:	c20080e7          	jalr	-992(ra) # 80005f10 <_ZN9Scheduler3putEP3TCB>
            cur = cur->next;
    800052f8:	0084b903          	ld	s2,8(s1)
            delete prev;
    800052fc:	fe0480e3          	beqz	s1,800052dc <_ZN13SleepingQueue10wakeUpTCBsEv+0x50>
        void* operator new(size_t size) {
            size_t numofBlocks = (size + MemoryAllocator::HEADER_SIZE + MEM_BLOCK_SIZE - 1)/MEM_BLOCK_SIZE;
            return MemoryAllocator::my_mem_alloc(numofBlocks);
        }
        void operator delete(void *p) {
            MemoryAllocator::my_mem_free(p);
    80005300:	00048513          	mv	a0,s1
    80005304:	00001097          	auipc	ra,0x1
    80005308:	3ec080e7          	jalr	1004(ra) # 800066f0 <_ZN15MemoryAllocator11my_mem_freeEPKv>
        }
    8000530c:	fd1ff06f          	j	800052dc <_ZN13SleepingQueue10wakeUpTCBsEv+0x50>
        headSleepingTCBs = cur;
    80005310:	00007797          	auipc	a5,0x7
    80005314:	9c97b423          	sd	s1,-1592(a5) # 8000bcd8 <_ZN13SleepingQueue16headSleepingTCBsE>
    80005318:	fadff06f          	j	800052c4 <_ZN13SleepingQueue10wakeUpTCBsEv+0x38>

000000008000531c <_ZN5Riscv10popSppSpieEv>:
#include "../h/syscall_c.hpp"

int Riscv::brojac = 0;

// iz ove funkcije zelimo da se vratimo tamo odakle je pozvana, a ne na sepc (po defaultu je tako, a to bi bilo na sacuvanu sepc old niti u handleSupervisorTrap funkciji)
void Riscv::popSppSpie() {
    8000531c:	ff010113          	addi	sp,sp,-16
    80005320:	00813423          	sd	s0,8(sp)
    80005324:	01010413          	addi	s0,sp,16
    if (TCB::userMode) {
    80005328:	00007797          	auipc	a5,0x7
    8000532c:	9917c783          	lbu	a5,-1647(a5) # 8000bcb9 <_ZN3TCB8userModeE>
    80005330:	00078663          	beqz	a5,8000533c <_ZN5Riscv10popSppSpieEv+0x20>
}

inline void Riscv::mc_sstatus(uint64 mask)
{
    __asm__ volatile ("csrc sstatus, %[mask]" : : [mask] "r"(mask));
    80005334:	10000793          	li	a5,256
    80005338:	1007b073          	csrc	sstatus,a5
        mc_sstatus(SSTATUS_SPP);
    }
    __asm__ volatile ("csrw sepc, ra");
    8000533c:	14109073          	csrw	sepc,ra
    __asm__ volatile ("sret");          //threadWrapper se poziva iz prekidne rutine, pa cem ona ovom mestu izaci iz nje
    80005340:	10200073          	sret
}
    80005344:	00813403          	ld	s0,8(sp)
    80005348:	01010113          	addi	sp,sp,16
    8000534c:	00008067          	ret

0000000080005350 <_ZN5Riscv12setA0onStackEv>:
            break;
        }
    }
}

void Riscv::setA0onStack() {        //podmetanje povratne vrednosti u stari kontekst
    80005350:	ff010113          	addi	sp,sp,-16
    80005354:	00813423          	sd	s0,8(sp)
    80005358:	01010413          	addi	s0,sp,16
//save a0 on old context stack
    uint64 save;
    __asm__ volatile("mv %0, a1" : "=r"(save));
    8000535c:	00058793          	mv	a5,a1
    __asm__ volatile("mv a1, %0" : : "r"(TCB::running->ecallSP));   //TCB::running->tsmp = sp
    80005360:	00007717          	auipc	a4,0x7
    80005364:	97073703          	ld	a4,-1680(a4) # 8000bcd0 <_ZN3TCB7runningE>
    80005368:	00073703          	ld	a4,0(a4)
    8000536c:	00070593          	mv	a1,a4
    __asm__ volatile("sd a0, 80(a1)");                          // x10 = a0 register -> podmece se nova savuvana vrednost povratka iz funkcije
    80005370:	04a5b823          	sd	a0,80(a1)
    __asm__ volatile("mv a1, %0" : : "r"(save));
    80005374:	00078593          	mv	a1,a5
}
    80005378:	00813403          	ld	s0,8(sp)
    8000537c:	01010113          	addi	sp,sp,16
    80005380:	00008067          	ret

0000000080005384 <_ZN5Riscv20handleSupervisorTrapEv>:
void Riscv::handleSupervisorTrap() {
    80005384:	f5010113          	addi	sp,sp,-176
    80005388:	0a113423          	sd	ra,168(sp)
    8000538c:	0a813023          	sd	s0,160(sp)
    80005390:	0b010413          	addi	s0,sp,176
    __asm__ volatile("mv %0, a1" : "=r"(arg1));
    80005394:	00058793          	mv	a5,a1
    80005398:	fef43423          	sd	a5,-24(s0)
    __asm__ volatile("mv %0, a2" : "=r"(arg2));
    8000539c:	00060793          	mv	a5,a2
    800053a0:	fef43023          	sd	a5,-32(s0)
    __asm__ volatile("mv %0, a3" : "=r"(arg3));
    800053a4:	00068793          	mv	a5,a3
    800053a8:	fcf43c23          	sd	a5,-40(s0)
    __asm__ volatile("mv %0, a4" : "=r"(arg4));
    800053ac:	00070793          	mv	a5,a4
    800053b0:	fcf43823          	sd	a5,-48(s0)
    __asm__ volatile("mv %0, a0" : "=r"(opCode));
    800053b4:	00050793          	mv	a5,a0
    800053b8:	fcf43423          	sd	a5,-56(s0)
    __asm__ volatile("csrr %0, sscratch" : "=r"(TCB::running->ecallSP));     // ssratch <= sp
    800053bc:	14002773          	csrr	a4,sscratch
    800053c0:	00007797          	auipc	a5,0x7
    800053c4:	9107b783          	ld	a5,-1776(a5) # 8000bcd0 <_ZN3TCB7runningE>
    800053c8:	00e7b023          	sd	a4,0(a5)
    __asm__ volatile ("csrr %[scause], scause" : [scause] "=r"(scause));
    800053cc:	142027f3          	csrr	a5,scause
    800053d0:	f8f43423          	sd	a5,-120(s0)
    return scause;
    800053d4:	f8843783          	ld	a5,-120(s0)
    uint64 volatile scause = Riscv::r_scause();         // read scause
    800053d8:	fcf43023          	sd	a5,-64(s0)
    switch (scause) {
    800053dc:	fc043783          	ld	a5,-64(s0)
    800053e0:	00900713          	li	a4,9
    800053e4:	02f76e63          	bltu	a4,a5,80005420 <_ZN5Riscv20handleSupervisorTrapEv+0x9c>
    800053e8:	00800713          	li	a4,8
    800053ec:	18e7fc63          	bgeu	a5,a4,80005584 <_ZN5Riscv20handleSupervisorTrapEv+0x200>
    800053f0:	00500713          	li	a4,5
    800053f4:	18e78263          	beq	a5,a4,80005578 <_ZN5Riscv20handleSupervisorTrapEv+0x1f4>
    800053f8:	00700713          	li	a4,7
    800053fc:	00e79863          	bne	a5,a4,8000540c <_ZN5Riscv20handleSupervisorTrapEv+0x88>
            TCB::prepareThreadExit();
    80005400:	00000097          	auipc	ra,0x0
    80005404:	8a8080e7          	jalr	-1880(ra) # 80004ca8 <_ZN3TCB17prepareThreadExitEv>
            break;
    80005408:	0f00006f          	j	800054f8 <_ZN5Riscv20handleSupervisorTrapEv+0x174>
    switch (scause) {
    8000540c:	00200713          	li	a4,2
    80005410:	0ee79463          	bne	a5,a4,800054f8 <_ZN5Riscv20handleSupervisorTrapEv+0x174>
            TCB::prepareThreadExit();
    80005414:	00000097          	auipc	ra,0x0
    80005418:	894080e7          	jalr	-1900(ra) # 80004ca8 <_ZN3TCB17prepareThreadExitEv>
            break;
    8000541c:	0dc0006f          	j	800054f8 <_ZN5Riscv20handleSupervisorTrapEv+0x174>
    switch (scause) {
    80005420:	fff00713          	li	a4,-1
    80005424:	03f71713          	slli	a4,a4,0x3f
    80005428:	00170713          	addi	a4,a4,1
    8000542c:	08e78263          	beq	a5,a4,800054b0 <_ZN5Riscv20handleSupervisorTrapEv+0x12c>
    80005430:	fff00713          	li	a4,-1
    80005434:	03f71713          	slli	a4,a4,0x3f
    80005438:	00970713          	addi	a4,a4,9
    8000543c:	0ae79e63          	bne	a5,a4,800054f8 <_ZN5Riscv20handleSupervisorTrapEv+0x174>
    __asm__ volatile ("csrr %[sepc], sepc" : [sepc] "=r"(sepc));
    80005440:	141027f3          	csrr	a5,sepc
    80005444:	faf43423          	sd	a5,-88(s0)
    return sepc;
    80005448:	fa843783          	ld	a5,-88(s0)
            uint64 volatile sepc = r_sepc();
    8000544c:	f6f43423          	sd	a5,-152(s0)
}

inline uint64 Riscv::r_sstatus()
{
    uint64 volatile sstatus;
    __asm__ volatile ("csrr %[sstatus], sstatus" : [sstatus] "=r"(sstatus));
    80005450:	100027f3          	csrr	a5,sstatus
    80005454:	faf43023          	sd	a5,-96(s0)
    return sstatus;
    80005458:	fa043783          	ld	a5,-96(s0)
            uint64 volatile sstatus = r_sstatus();
    8000545c:	f6f43823          	sd	a5,-144(s0)
            char console_status = *((char*) CONSOLE_STATUS);        //8 bits
    80005460:	00004797          	auipc	a5,0x4
    80005464:	bb07b783          	ld	a5,-1104(a5) # 80009010 <CONSOLE_STATUS>
    80005468:	0007c783          	lbu	a5,0(a5)
            if (console_status & CONSOLE_RX_STATUS_BIT) {           //can read
    8000546c:	0017f793          	andi	a5,a5,1
    80005470:	00078e63          	beqz	a5,8000548c <_ZN5Riscv20handleSupervisorTrapEv+0x108>
                char data = *((char *) CONSOLE_RX_DATA);
    80005474:	00004797          	auipc	a5,0x4
    80005478:	b8c7b783          	ld	a5,-1140(a5) # 80009000 <CONSOLE_RX_DATA>
    8000547c:	0007c503          	lbu	a0,0(a5)
                if (myConsole::numberOfCharToGet>0) {
    80005480:	00007797          	auipc	a5,0x7
    80005484:	8807b783          	ld	a5,-1920(a5) # 8000bd00 <_ZN9myConsole17numberOfCharToGetE>
    80005488:	0c079c63          	bnez	a5,80005560 <_ZN5Riscv20handleSupervisorTrapEv+0x1dc>
            plic_complete(plic_claim());                //done
    8000548c:	00002097          	auipc	ra,0x2
    80005490:	078080e7          	jalr	120(ra) # 80007504 <plic_claim>
    80005494:	00002097          	auipc	ra,0x2
    80005498:	0a8080e7          	jalr	168(ra) # 8000753c <plic_complete>
            w_sstatus(sstatus);
    8000549c:	f7043783          	ld	a5,-144(s0)
}

inline void Riscv::w_sstatus(uint64 sstatus)
{
    __asm__ volatile ("csrw sstatus, %[sstatus]" : : [sstatus] "r"(sstatus));
    800054a0:	10079073          	csrw	sstatus,a5
            w_sepc(sepc);
    800054a4:	f6843783          	ld	a5,-152(s0)
    __asm__ volatile ("csrw sepc, %[sepc]" : : [sepc] "r"(sepc));
    800054a8:	14179073          	csrw	sepc,a5
}
    800054ac:	04c0006f          	j	800054f8 <_ZN5Riscv20handleSupervisorTrapEv+0x174>
            brojac++;
    800054b0:	00007717          	auipc	a4,0x7
    800054b4:	83070713          	addi	a4,a4,-2000 # 8000bce0 <_ZN5Riscv6brojacE>
    800054b8:	00072783          	lw	a5,0(a4)
    800054bc:	0017879b          	addiw	a5,a5,1
    800054c0:	00f72023          	sw	a5,0(a4)
            if (brojac % 2 == 0) {
    800054c4:	0017f793          	andi	a5,a5,1
    800054c8:	04078063          	beqz	a5,80005508 <_ZN5Riscv20handleSupervisorTrapEv+0x184>
            TCB::timeSliceCounter++;
    800054cc:	00006717          	auipc	a4,0x6
    800054d0:	7e470713          	addi	a4,a4,2020 # 8000bcb0 <_ZN3TCB16timeSliceCounterE>
    800054d4:	00073783          	ld	a5,0(a4)
    800054d8:	00178793          	addi	a5,a5,1
    800054dc:	00f73023          	sd	a5,0(a4)
            if (TCB::timeSliceCounter >= TCB::running->getTimeSlice()) {
    800054e0:	00006717          	auipc	a4,0x6
    800054e4:	7f073703          	ld	a4,2032(a4) # 8000bcd0 <_ZN3TCB7runningE>
    static TCB* createThread(Body body, void* arg, void* stack, uint64 timeSlice);

    Status getStatus() { return status; }
    void setStatus(Status s) { status = s; }

    uint64 getTimeSlice() const { return timeSlice; }
    800054e8:	03873703          	ld	a4,56(a4)
    800054ec:	02e7f863          	bgeu	a5,a4,8000551c <_ZN5Riscv20handleSupervisorTrapEv+0x198>
    __asm__ volatile ("csrc sip, %[mask]" : : [mask] "r"(mask));
    800054f0:	00200793          	li	a5,2
    800054f4:	1447b073          	csrc	sip,a5
}
    800054f8:	0a813083          	ld	ra,168(sp)
    800054fc:	0a013403          	ld	s0,160(sp)
    80005500:	0b010113          	addi	sp,sp,176
    80005504:	00008067          	ret
                SleepingQueue::wakeUpTCBs();                      //try to wake up
    80005508:	00000097          	auipc	ra,0x0
    8000550c:	d84080e7          	jalr	-636(ra) # 8000528c <_ZN13SleepingQueue10wakeUpTCBsEv>
                mySemaphore::tryToUnblockTimer();                 //try to unblock
    80005510:	00000097          	auipc	ra,0x0
    80005514:	514080e7          	jalr	1300(ra) # 80005a24 <_ZN11mySemaphore17tryToUnblockTimerEv>
    80005518:	fb5ff06f          	j	800054cc <_ZN5Riscv20handleSupervisorTrapEv+0x148>
    __asm__ volatile ("csrr %[sepc], sepc" : [sepc] "=r"(sepc));
    8000551c:	141027f3          	csrr	a5,sepc
    80005520:	f8f43c23          	sd	a5,-104(s0)
    return sepc;
    80005524:	f9843783          	ld	a5,-104(s0)
                uint64 volatile sepc = r_sepc();
    80005528:	f4f43c23          	sd	a5,-168(s0)
    __asm__ volatile ("csrr %[sstatus], sstatus" : [sstatus] "=r"(sstatus));
    8000552c:	100027f3          	csrr	a5,sstatus
    80005530:	f8f43823          	sd	a5,-112(s0)
    return sstatus;
    80005534:	f9043783          	ld	a5,-112(s0)
                uint64 volatile sstatus = r_sstatus();
    80005538:	f6f43023          	sd	a5,-160(s0)
                TCB::timeSliceCounter = 0;
    8000553c:	00006797          	auipc	a5,0x6
    80005540:	7607ba23          	sd	zero,1908(a5) # 8000bcb0 <_ZN3TCB16timeSliceCounterE>
                TCB::dispatch();
    80005544:	fffff097          	auipc	ra,0xfffff
    80005548:	468080e7          	jalr	1128(ra) # 800049ac <_ZN3TCB8dispatchEv>
                w_sstatus(sstatus);
    8000554c:	f6043783          	ld	a5,-160(s0)
    __asm__ volatile ("csrw sstatus, %[sstatus]" : : [sstatus] "r"(sstatus));
    80005550:	10079073          	csrw	sstatus,a5
                w_sepc(sepc);
    80005554:	f5843783          	ld	a5,-168(s0)
    __asm__ volatile ("csrw sepc, %[sepc]" : : [sepc] "r"(sepc));
    80005558:	14179073          	csrw	sepc,a5
}
    8000555c:	f95ff06f          	j	800054f0 <_ZN5Riscv20handleSupervisorTrapEv+0x16c>
                    myConsole::numberOfCharToGet--;
    80005560:	fff78793          	addi	a5,a5,-1
    80005564:	00006717          	auipc	a4,0x6
    80005568:	78f73e23          	sd	a5,1948(a4) # 8000bd00 <_ZN9myConsole17numberOfCharToGetE>
                    myConsole::putCInBuff(data);
    8000556c:	00001097          	auipc	ra,0x1
    80005570:	44c080e7          	jalr	1100(ra) # 800069b8 <_ZN9myConsole10putCInBuffEc>
    80005574:	f19ff06f          	j	8000548c <_ZN5Riscv20handleSupervisorTrapEv+0x108>
            TCB::prepareThreadExit();
    80005578:	fffff097          	auipc	ra,0xfffff
    8000557c:	730080e7          	jalr	1840(ra) # 80004ca8 <_ZN3TCB17prepareThreadExitEv>
            break;
    80005580:	f79ff06f          	j	800054f8 <_ZN5Riscv20handleSupervisorTrapEv+0x174>
    __asm__ volatile ("csrr %[sepc], sepc" : [sepc] "=r"(sepc));
    80005584:	141027f3          	csrr	a5,sepc
    80005588:	faf43c23          	sd	a5,-72(s0)
    return sepc;
    8000558c:	fb843783          	ld	a5,-72(s0)
            uint64 volatile sepc = Riscv::r_sepc() + 4;       // - adresa nakon ecall -cuvamo na steku old - u lokalnoj promenljivoj sepc(od old), sepc nismo cuvali u dispatchu - lokalnu prom. cuvamo na steku old niti
    80005590:	00478793          	addi	a5,a5,4
    80005594:	f6f43c23          	sd	a5,-136(s0)
    __asm__ volatile ("csrr %[sstatus], sstatus" : [sstatus] "=r"(sstatus));
    80005598:	100027f3          	csrr	a5,sstatus
    8000559c:	faf43823          	sd	a5,-80(s0)
    return sstatus;
    800055a0:	fb043783          	ld	a5,-80(s0)
            uint64 volatile sstatus = Riscv::r_sstatus();
    800055a4:	f8f43023          	sd	a5,-128(s0)
            switch (opCode) {
    800055a8:	fc843783          	ld	a5,-56(s0)
    800055ac:	04200713          	li	a4,66
    800055b0:	02f76463          	bltu	a4,a5,800055d8 <_ZN5Riscv20handleSupervisorTrapEv+0x254>
    800055b4:	04078a63          	beqz	a5,80005608 <_ZN5Riscv20handleSupervisorTrapEv+0x284>
    800055b8:	04f76863          	bltu	a4,a5,80005608 <_ZN5Riscv20handleSupervisorTrapEv+0x284>
    800055bc:	00279793          	slli	a5,a5,0x2
    800055c0:	00004717          	auipc	a4,0x4
    800055c4:	07070713          	addi	a4,a4,112 # 80009630 <_ZTV7WorkerD+0x28>
    800055c8:	00e787b3          	add	a5,a5,a4
    800055cc:	0007a783          	lw	a5,0(a5)
    800055d0:	00e787b3          	add	a5,a5,a4
    800055d4:	00078067          	jr	a5
    800055d8:	10000713          	li	a4,256
    800055dc:	02e79663          	bne	a5,a4,80005608 <_ZN5Riscv20handleSupervisorTrapEv+0x284>
                    char res = myConsole::getCOutBuff();
    800055e0:	00001097          	auipc	ra,0x1
    800055e4:	440080e7          	jalr	1088(ra) # 80006a20 <_ZN9myConsole11getCOutBuffEv>
    800055e8:	0ff57793          	andi	a5,a0,255
                    __asm__ volatile("mv a0, %0" : :"r"((uint64)res));
    800055ec:	00078513          	mv	a0,a5
                    Riscv::setA0onStack();
    800055f0:	00000097          	auipc	ra,0x0
    800055f4:	d60080e7          	jalr	-672(ra) # 80005350 <_ZN5Riscv12setA0onStackEv>
                    break;
    800055f8:	0100006f          	j	80005608 <_ZN5Riscv20handleSupervisorTrapEv+0x284>
                    MemoryAllocator::prepareMemAlloc(arg1);
    800055fc:	fe843503          	ld	a0,-24(s0)
    80005600:	00001097          	auipc	ra,0x1
    80005604:	1b4080e7          	jalr	436(ra) # 800067b4 <_ZN15MemoryAllocator15prepareMemAllocEm>
            w_sstatus(sstatus);
    80005608:	f8043783          	ld	a5,-128(s0)
    __asm__ volatile ("csrw sstatus, %[sstatus]" : : [sstatus] "r"(sstatus));
    8000560c:	10079073          	csrw	sstatus,a5
            w_sepc(sepc);
    80005610:	f7843783          	ld	a5,-136(s0)
    __asm__ volatile ("csrw sepc, %[sepc]" : : [sepc] "r"(sepc));
    80005614:	14179073          	csrw	sepc,a5
}
    80005618:	ee1ff06f          	j	800054f8 <_ZN5Riscv20handleSupervisorTrapEv+0x174>
                    MemoryAllocator::prepareMemFree(arg1);
    8000561c:	fe843503          	ld	a0,-24(s0)
    80005620:	00001097          	auipc	ra,0x1
    80005624:	1c8080e7          	jalr	456(ra) # 800067e8 <_ZN15MemoryAllocator14prepareMemFreeEm>
                    break;
    80005628:	fe1ff06f          	j	80005608 <_ZN5Riscv20handleSupervisorTrapEv+0x284>
                    TCB::prepareThreadCreate((thread_t*) arg1, (TCB::Body) arg2, (void*) arg3, (void*) arg4);
    8000562c:	fe843503          	ld	a0,-24(s0)
    80005630:	fe043583          	ld	a1,-32(s0)
    80005634:	fd843603          	ld	a2,-40(s0)
    80005638:	fd043683          	ld	a3,-48(s0)
    8000563c:	fffff097          	auipc	ra,0xfffff
    80005640:	60c080e7          	jalr	1548(ra) # 80004c48 <_ZN3TCB19prepareThreadCreateEPPS_PFvPvES2_S2_>
                    break;
    80005644:	fc5ff06f          	j	80005608 <_ZN5Riscv20handleSupervisorTrapEv+0x284>
                    TCB::prepareThreadExit();
    80005648:	fffff097          	auipc	ra,0xfffff
    8000564c:	660080e7          	jalr	1632(ra) # 80004ca8 <_ZN3TCB17prepareThreadExitEv>
                    break;
    80005650:	fb9ff06f          	j	80005608 <_ZN5Riscv20handleSupervisorTrapEv+0x284>
                    TCB::dispatch();
    80005654:	fffff097          	auipc	ra,0xfffff
    80005658:	358080e7          	jalr	856(ra) # 800049ac <_ZN3TCB8dispatchEv>
                    break;
    8000565c:	fadff06f          	j	80005608 <_ZN5Riscv20handleSupervisorTrapEv+0x284>
                    mySemaphore::prepareSemOpen((sem_t*) arg1, (unsigned) arg2);
    80005660:	fe843503          	ld	a0,-24(s0)
    80005664:	fe043583          	ld	a1,-32(s0)
    80005668:	0005859b          	sext.w	a1,a1
    8000566c:	00000097          	auipc	ra,0x0
    80005670:	4a8080e7          	jalr	1192(ra) # 80005b14 <_ZN11mySemaphore14prepareSemOpenEPPS_j>
                    break;
    80005674:	f95ff06f          	j	80005608 <_ZN5Riscv20handleSupervisorTrapEv+0x284>
                    mySemaphore::prepareSemClose((sem_t) arg1);
    80005678:	fe843503          	ld	a0,-24(s0)
    8000567c:	00000097          	auipc	ra,0x0
    80005680:	558080e7          	jalr	1368(ra) # 80005bd4 <_ZN11mySemaphore15prepareSemCloseEPS_>
                    break;
    80005684:	f85ff06f          	j	80005608 <_ZN5Riscv20handleSupervisorTrapEv+0x284>
                    mySemaphore::prepareSemWait((sem_t) arg1);
    80005688:	fe843503          	ld	a0,-24(s0)
    8000568c:	00000097          	auipc	ra,0x0
    80005690:	650080e7          	jalr	1616(ra) # 80005cdc <_ZN11mySemaphore14prepareSemWaitEPS_>
                    break;
    80005694:	f75ff06f          	j	80005608 <_ZN5Riscv20handleSupervisorTrapEv+0x284>
                    mySemaphore::prepareSemSignal((sem_t) arg1);
    80005698:	fe843503          	ld	a0,-24(s0)
    8000569c:	00000097          	auipc	ra,0x0
    800056a0:	6b8080e7          	jalr	1720(ra) # 80005d54 <_ZN11mySemaphore16prepareSemSignalEPS_>
                    break;
    800056a4:	f65ff06f          	j	80005608 <_ZN5Riscv20handleSupervisorTrapEv+0x284>
                    mySemaphore::prepareSemTimedWait((sem_t) arg1, (time_t) arg2);
    800056a8:	fe843503          	ld	a0,-24(s0)
    800056ac:	fe043583          	ld	a1,-32(s0)
    800056b0:	00000097          	auipc	ra,0x0
    800056b4:	6e4080e7          	jalr	1764(ra) # 80005d94 <_ZN11mySemaphore19prepareSemTimedWaitEPS_m>
                    break;
    800056b8:	f51ff06f          	j	80005608 <_ZN5Riscv20handleSupervisorTrapEv+0x284>
                    mySemaphore::prepareSemTryWait((sem_t) arg1);
    800056bc:	fe843503          	ld	a0,-24(s0)
    800056c0:	00000097          	auipc	ra,0x0
    800056c4:	734080e7          	jalr	1844(ra) # 80005df4 <_ZN11mySemaphore17prepareSemTryWaitEPS_>
                    break;
    800056c8:	f41ff06f          	j	80005608 <_ZN5Riscv20handleSupervisorTrapEv+0x284>
                    TCB::prepareTimeSleep((time_t) arg1);
    800056cc:	fe843503          	ld	a0,-24(s0)
    800056d0:	fffff097          	auipc	ra,0xfffff
    800056d4:	624080e7          	jalr	1572(ra) # 80004cf4 <_ZN3TCB16prepareTimeSleepEm>
                    break;
    800056d8:	f31ff06f          	j	80005608 <_ZN5Riscv20handleSupervisorTrapEv+0x284>
                    myConsole::prepareGetC();
    800056dc:	00001097          	auipc	ra,0x1
    800056e0:	44c080e7          	jalr	1100(ra) # 80006b28 <_ZN9myConsole11prepareGetCEv>
                    break;
    800056e4:	f25ff06f          	j	80005608 <_ZN5Riscv20handleSupervisorTrapEv+0x284>
                    myConsole::preparePutC((char) arg1);
    800056e8:	fe843503          	ld	a0,-24(s0)
    800056ec:	0ff57513          	andi	a0,a0,255
    800056f0:	00001097          	auipc	ra,0x1
    800056f4:	4d0080e7          	jalr	1232(ra) # 80006bc0 <_ZN9myConsole11preparePutCEc>
                    break;
    800056f8:	f11ff06f          	j	80005608 <_ZN5Riscv20handleSupervisorTrapEv+0x284>

00000000800056fc <_ZN5Riscv14changePrivModeEv>:


void Riscv::changePrivMode() {
    800056fc:	ff010113          	addi	sp,sp,-16
    80005700:	00813423          	sd	s0,8(sp)
    80005704:	01010413          	addi	s0,sp,16
    if (TCB::userMode) {
    80005708:	00006797          	auipc	a5,0x6
    8000570c:	5b17c783          	lbu	a5,1457(a5) # 8000bcb9 <_ZN3TCB8userModeE>
    80005710:	00078663          	beqz	a5,8000571c <_ZN5Riscv14changePrivModeEv+0x20>
    __asm__ volatile ("csrc sstatus, %[mask]" : : [mask] "r"(mask));
    80005714:	10000793          	li	a5,256
    80005718:	1007b073          	csrc	sstatus,a5
        mc_sstatus(SSTATUS_SPP);
    }
}
    8000571c:	00813403          	ld	s0,8(sp)
    80005720:	01010113          	addi	sp,sp,16
    80005724:	00008067          	ret

0000000080005728 <_Z41__static_initialization_and_destruction_0ii>:
        __asm__ volatile("li a0, 0xffffffffffffffff");
    }

    //save a0 on old context stack
    Riscv::setA0onStack();
}
    80005728:	ff010113          	addi	sp,sp,-16
    8000572c:	00813423          	sd	s0,8(sp)
    80005730:	01010413          	addi	s0,sp,16
    80005734:	00100793          	li	a5,1
    80005738:	00f50863          	beq	a0,a5,80005748 <_Z41__static_initialization_and_destruction_0ii+0x20>
    8000573c:	00813403          	ld	s0,8(sp)
    80005740:	01010113          	addi	sp,sp,16
    80005744:	00008067          	ret
    80005748:	000107b7          	lui	a5,0x10
    8000574c:	fff78793          	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005750:	fef596e3          	bne	a1,a5,8000573c <_Z41__static_initialization_and_destruction_0ii+0x14>
        }
    };
    Node *head, *tail;

public:
    List() : head(0), tail(0) {}
    80005754:	00006797          	auipc	a5,0x6
    80005758:	61c78793          	addi	a5,a5,1564 # 8000bd70 <_ZN11mySemaphore13allSemaphoresE>
    8000575c:	0007b023          	sd	zero,0(a5)
    80005760:	0007b423          	sd	zero,8(a5)
    80005764:	fd9ff06f          	j	8000573c <_Z41__static_initialization_and_destruction_0ii+0x14>

0000000080005768 <_ZN11mySemaphorenwEm>:
void *mySemaphore::operator new(size_t size) {
    80005768:	ff010113          	addi	sp,sp,-16
    8000576c:	00113423          	sd	ra,8(sp)
    80005770:	00813023          	sd	s0,0(sp)
    80005774:	01010413          	addi	s0,sp,16
    size_t numofBlocks = (size + MemoryAllocator::HEADER_SIZE + MEM_BLOCK_SIZE - 1)/MEM_BLOCK_SIZE;
    80005778:	04f50513          	addi	a0,a0,79
    return MemoryAllocator::my_mem_alloc(numofBlocks);
    8000577c:	00655513          	srli	a0,a0,0x6
    80005780:	00001097          	auipc	ra,0x1
    80005784:	e4c080e7          	jalr	-436(ra) # 800065cc <_ZN15MemoryAllocator12my_mem_allocEm>
}
    80005788:	00813083          	ld	ra,8(sp)
    8000578c:	00013403          	ld	s0,0(sp)
    80005790:	01010113          	addi	sp,sp,16
    80005794:	00008067          	ret

0000000080005798 <_ZN11mySemaphoredlEPv>:
void mySemaphore::operator delete(void *p) {
    80005798:	ff010113          	addi	sp,sp,-16
    8000579c:	00113423          	sd	ra,8(sp)
    800057a0:	00813023          	sd	s0,0(sp)
    800057a4:	01010413          	addi	s0,sp,16
    MemoryAllocator::my_mem_free(p);
    800057a8:	00001097          	auipc	ra,0x1
    800057ac:	f48080e7          	jalr	-184(ra) # 800066f0 <_ZN15MemoryAllocator11my_mem_freeEPKv>
}
    800057b0:	00813083          	ld	ra,8(sp)
    800057b4:	00013403          	ld	s0,0(sp)
    800057b8:	01010113          	addi	sp,sp,16
    800057bc:	00008067          	ret

00000000800057c0 <_ZN11mySemaphoreC1Ei>:
mySemaphore::mySemaphore(int val) : value(val), startValue(val) {}
    800057c0:	ff010113          	addi	sp,sp,-16
    800057c4:	00813423          	sd	s0,8(sp)
    800057c8:	01010413          	addi	s0,sp,16
    800057cc:	00b52023          	sw	a1,0(a0)
    800057d0:	00b52223          	sw	a1,4(a0)
    800057d4:	00053423          	sd	zero,8(a0)
    800057d8:	00053823          	sd	zero,16(a0)
    800057dc:	00813403          	ld	s0,8(sp)
    800057e0:	01010113          	addi	sp,sp,16
    800057e4:	00008067          	ret

00000000800057e8 <_ZN11mySemaphoreD1Ev>:
mySemaphore::~mySemaphore() {
    800057e8:	fe010113          	addi	sp,sp,-32
    800057ec:	00113c23          	sd	ra,24(sp)
    800057f0:	00813823          	sd	s0,16(sp)
    800057f4:	00913423          	sd	s1,8(sp)
    800057f8:	01213023          	sd	s2,0(sp)
    800057fc:	02010413          	addi	s0,sp,32
    80005800:	00050493          	mv	s1,a0
    80005804:	0240006f          	j	80005828 <_ZN11mySemaphoreD1Ev+0x40>
    T *removeFirst() {
        if (!head) { return 0; }

        Node *elem = head;
        head = head->next;
        if (!head) { tail = 0; }
    80005808:	0004b823          	sd	zero,16(s1)
            MemoryAllocator::my_mem_free(p);
    8000580c:	00001097          	auipc	ra,0x1
    80005810:	ee4080e7          	jalr	-284(ra) # 800066f0 <_ZN15MemoryAllocator11my_mem_freeEPKv>
        tmp->returnedValFromWaits = SEMDEAD;
    80005814:	fff00793          	li	a5,-1
    80005818:	02f92a23          	sw	a5,52(s2)
        Scheduler::put(tmp);
    8000581c:	00090513          	mv	a0,s2
    80005820:	00000097          	auipc	ra,0x0
    80005824:	6f0080e7          	jalr	1776(ra) # 80005f10 <_ZN9Scheduler3putEP3TCB>
        delete elem;
        return ret;
    }

    T *peekFirst() {
        if (!head) { return 0; }
    80005828:	0084b783          	ld	a5,8(s1)
    8000582c:	02078263          	beqz	a5,80005850 <_ZN11mySemaphoreD1Ev+0x68>
        return head->data;
    80005830:	0007b903          	ld	s2,0(a5)
    while (suspendedTCBs.peekFirst() != nullptr) {
    80005834:	00090e63          	beqz	s2,80005850 <_ZN11mySemaphoreD1Ev+0x68>
        if (!head) { return 0; }
    80005838:	00078513          	mv	a0,a5
    8000583c:	fc078ce3          	beqz	a5,80005814 <_ZN11mySemaphoreD1Ev+0x2c>
        head = head->next;
    80005840:	0087b783          	ld	a5,8(a5)
    80005844:	00f4b423          	sd	a5,8(s1)
        if (!head) { tail = 0; }
    80005848:	fc0792e3          	bnez	a5,8000580c <_ZN11mySemaphoreD1Ev+0x24>
    8000584c:	fbdff06f          	j	80005808 <_ZN11mySemaphoreD1Ev+0x20>
}
    80005850:	01813083          	ld	ra,24(sp)
    80005854:	01013403          	ld	s0,16(sp)
    80005858:	00813483          	ld	s1,8(sp)
    8000585c:	00013903          	ld	s2,0(sp)
    80005860:	02010113          	addi	sp,sp,32
    80005864:	00008067          	ret

0000000080005868 <_ZN11mySemaphore7tryWaitEv>:
int mySemaphore::tryWait() {
    80005868:	ff010113          	addi	sp,sp,-16
    8000586c:	00813423          	sd	s0,8(sp)
    80005870:	01010413          	addi	s0,sp,16
    if (value > 0) {
    80005874:	00052783          	lw	a5,0(a0)
    80005878:	00f04a63          	bgtz	a5,8000588c <_ZN11mySemaphore7tryWaitEv+0x24>
    return 0;
    8000587c:	00000513          	li	a0,0
}
    80005880:	00813403          	ld	s0,8(sp)
    80005884:	01010113          	addi	sp,sp,16
    80005888:	00008067          	ret
        --value;
    8000588c:	fff7879b          	addiw	a5,a5,-1
    80005890:	00f52023          	sw	a5,0(a0)
        return 1;
    80005894:	00100513          	li	a0,1
    80005898:	fe9ff06f          	j	80005880 <_ZN11mySemaphore7tryWaitEv+0x18>

000000008000589c <_ZN11mySemaphore5blockEm>:
void mySemaphore::block(uint64 time) {
    8000589c:	fd010113          	addi	sp,sp,-48
    800058a0:	02113423          	sd	ra,40(sp)
    800058a4:	02813023          	sd	s0,32(sp)
    800058a8:	00913c23          	sd	s1,24(sp)
    800058ac:	01213823          	sd	s2,16(sp)
    800058b0:	01313423          	sd	s3,8(sp)
    800058b4:	03010413          	addi	s0,sp,48
    800058b8:	00050493          	mv	s1,a0
    800058bc:	00058913          	mv	s2,a1
    TCB::running->setStatus(SUSPENDED);
    800058c0:	00006997          	auipc	s3,0x6
    800058c4:	4109b983          	ld	s3,1040(s3) # 8000bcd0 <_ZN3TCB7runningE>
    void setStatus(Status s) { status = s; }
    800058c8:	00100793          	li	a5,1
    800058cc:	02f9a823          	sw	a5,48(s3)
            return MemoryAllocator::my_mem_alloc(numofBlocks);
    800058d0:	00100513          	li	a0,1
    800058d4:	00001097          	auipc	ra,0x1
    800058d8:	cf8080e7          	jalr	-776(ra) # 800065cc <_ZN15MemoryAllocator12my_mem_allocEm>
        Node(T *data, Node *next, uint64 time = 0) : data(data), next(next), timeBlockOrSleep(time) {}
    800058dc:	01353023          	sd	s3,0(a0)
    800058e0:	00053423          	sd	zero,8(a0)
    800058e4:	01253823          	sd	s2,16(a0)
        if (tail) {
    800058e8:	0104b783          	ld	a5,16(s1)
    800058ec:	02078863          	beqz	a5,8000591c <_ZN11mySemaphore5blockEm+0x80>
            tail->next = elem;
    800058f0:	00a7b423          	sd	a0,8(a5)
            tail = elem;
    800058f4:	00a4b823          	sd	a0,16(s1)
    TCB::dispatch();
    800058f8:	fffff097          	auipc	ra,0xfffff
    800058fc:	0b4080e7          	jalr	180(ra) # 800049ac <_ZN3TCB8dispatchEv>
}
    80005900:	02813083          	ld	ra,40(sp)
    80005904:	02013403          	ld	s0,32(sp)
    80005908:	01813483          	ld	s1,24(sp)
    8000590c:	01013903          	ld	s2,16(sp)
    80005910:	00813983          	ld	s3,8(sp)
    80005914:	03010113          	addi	sp,sp,48
    80005918:	00008067          	ret
            head = tail = elem;
    8000591c:	00a4b823          	sd	a0,16(s1)
    80005920:	00a4b423          	sd	a0,8(s1)
    80005924:	fd5ff06f          	j	800058f8 <_ZN11mySemaphore5blockEm+0x5c>

0000000080005928 <_ZN11mySemaphore4waitEm>:
    if (--value < 0) {
    80005928:	00052783          	lw	a5,0(a0)
    8000592c:	fff7879b          	addiw	a5,a5,-1
    80005930:	00f52023          	sw	a5,0(a0)
    80005934:	02079713          	slli	a4,a5,0x20
    80005938:	00074663          	bltz	a4,80005944 <_ZN11mySemaphore4waitEm+0x1c>
}
    8000593c:	00000513          	li	a0,0
    80005940:	00008067          	ret
int mySemaphore::wait(uint64 time) {
    80005944:	ff010113          	addi	sp,sp,-16
    80005948:	00113423          	sd	ra,8(sp)
    8000594c:	00813023          	sd	s0,0(sp)
    80005950:	01010413          	addi	s0,sp,16
        block(time);
    80005954:	00000097          	auipc	ra,0x0
    80005958:	f48080e7          	jalr	-184(ra) # 8000589c <_ZN11mySemaphore5blockEm>
}
    8000595c:	00000513          	li	a0,0
    80005960:	00813083          	ld	ra,8(sp)
    80005964:	00013403          	ld	s0,0(sp)
    80005968:	01010113          	addi	sp,sp,16
    8000596c:	00008067          	ret

0000000080005970 <_ZN11mySemaphore7unblockEv>:
void mySemaphore::unblock() {
    80005970:	fe010113          	addi	sp,sp,-32
    80005974:	00113c23          	sd	ra,24(sp)
    80005978:	00813823          	sd	s0,16(sp)
    8000597c:	00913423          	sd	s1,8(sp)
    80005980:	02010413          	addi	s0,sp,32
    80005984:	00050793          	mv	a5,a0
        if (!head) { return 0; }
    80005988:	00853483          	ld	s1,8(a0)
    8000598c:	00048463          	beqz	s1,80005994 <_ZN11mySemaphore7unblockEv+0x24>
        return head->data;
    80005990:	0004b483          	ld	s1,0(s1)
        if (!head) { return 0; }
    80005994:	0087b503          	ld	a0,8(a5)
    80005998:	00050c63          	beqz	a0,800059b0 <_ZN11mySemaphore7unblockEv+0x40>
        head = head->next;
    8000599c:	00853703          	ld	a4,8(a0)
    800059a0:	00e7b423          	sd	a4,8(a5)
        if (!head) { tail = 0; }
    800059a4:	02070863          	beqz	a4,800059d4 <_ZN11mySemaphore7unblockEv+0x64>
            MemoryAllocator::my_mem_free(p);
    800059a8:	00001097          	auipc	ra,0x1
    800059ac:	d48080e7          	jalr	-696(ra) # 800066f0 <_ZN15MemoryAllocator11my_mem_freeEPKv>
    if (tmp) {
    800059b0:	00048863          	beqz	s1,800059c0 <_ZN11mySemaphore7unblockEv+0x50>
        Scheduler::put(tmp);
    800059b4:	00048513          	mv	a0,s1
    800059b8:	00000097          	auipc	ra,0x0
    800059bc:	558080e7          	jalr	1368(ra) # 80005f10 <_ZN9Scheduler3putEP3TCB>
}
    800059c0:	01813083          	ld	ra,24(sp)
    800059c4:	01013403          	ld	s0,16(sp)
    800059c8:	00813483          	ld	s1,8(sp)
    800059cc:	02010113          	addi	sp,sp,32
    800059d0:	00008067          	ret
        if (!head) { tail = 0; }
    800059d4:	0007b823          	sd	zero,16(a5)
    800059d8:	fd1ff06f          	j	800059a8 <_ZN11mySemaphore7unblockEv+0x38>

00000000800059dc <_ZN11mySemaphore6signalEv>:
    if (++value <= 0) {
    800059dc:	00052783          	lw	a5,0(a0)
    800059e0:	0017879b          	addiw	a5,a5,1
    800059e4:	0007871b          	sext.w	a4,a5
    800059e8:	00f52023          	sw	a5,0(a0)
    800059ec:	00e05663          	blez	a4,800059f8 <_ZN11mySemaphore6signalEv+0x1c>
}
    800059f0:	00000513          	li	a0,0
    800059f4:	00008067          	ret
int mySemaphore::signal() {
    800059f8:	ff010113          	addi	sp,sp,-16
    800059fc:	00113423          	sd	ra,8(sp)
    80005a00:	00813023          	sd	s0,0(sp)
    80005a04:	01010413          	addi	s0,sp,16
        unblock();
    80005a08:	00000097          	auipc	ra,0x0
    80005a0c:	f68080e7          	jalr	-152(ra) # 80005970 <_ZN11mySemaphore7unblockEv>
}
    80005a10:	00000513          	li	a0,0
    80005a14:	00813083          	ld	ra,8(sp)
    80005a18:	00013403          	ld	s0,0(sp)
    80005a1c:	01010113          	addi	sp,sp,16
    80005a20:	00008067          	ret

0000000080005a24 <_ZN11mySemaphore17tryToUnblockTimerEv>:
void mySemaphore::tryToUnblockTimer() {                     //tail!? i povratna vrednost kad nije timed_wait
    80005a24:	fc010113          	addi	sp,sp,-64
    80005a28:	02113c23          	sd	ra,56(sp)
    80005a2c:	02813823          	sd	s0,48(sp)
    80005a30:	02913423          	sd	s1,40(sp)
    80005a34:	03213023          	sd	s2,32(sp)
    80005a38:	01313c23          	sd	s3,24(sp)
    80005a3c:	01413823          	sd	s4,16(sp)
    80005a40:	01513423          	sd	s5,8(sp)
    80005a44:	04010413          	addi	s0,sp,64
    List<mySemaphore>::Node *sem = allSemaphores.head;
    80005a48:	00006997          	auipc	s3,0x6
    80005a4c:	3289b983          	ld	s3,808(s3) # 8000bd70 <_ZN11mySemaphore13allSemaphoresE>
    80005a50:	08c0006f          	j	80005adc <_ZN11mySemaphore17tryToUnblockTimerEv+0xb8>
                prev = cur;
    80005a54:	00048913          	mv	s2,s1
                cur = cur->next;
    80005a58:	0084b483          	ld	s1,8(s1)
                continue;
    80005a5c:	0200006f          	j	80005a7c <_ZN11mySemaphore17tryToUnblockTimerEv+0x58>
                    curSem->suspendedTCBs.head = cur->next;
    80005a60:	0084b783          	ld	a5,8(s1)
    80005a64:	00fa3423          	sd	a5,8(s4)
    80005a68:	0500006f          	j	80005ab8 <_ZN11mySemaphore17tryToUnblockTimerEv+0x94>
                    curSem->suspendedTCBs.tail = prev;
    80005a6c:	012a3823          	sd	s2,16(s4)
    80005a70:	0500006f          	j	80005ac0 <_ZN11mySemaphore17tryToUnblockTimerEv+0x9c>
            prev = cur;
    80005a74:	00048913          	mv	s2,s1
            cur = cur->next;
    80005a78:	0084b483          	ld	s1,8(s1)
        while (cur) {
    80005a7c:	04048e63          	beqz	s1,80005ad8 <_ZN11mySemaphore17tryToUnblockTimerEv+0xb4>
            if (cur->timeBlockOrSleep == 0) {
    80005a80:	0104b783          	ld	a5,16(s1)
    80005a84:	fc0788e3          	beqz	a5,80005a54 <_ZN11mySemaphore17tryToUnblockTimerEv+0x30>
            if (--(cur->timeBlockOrSleep) == 0) {
    80005a88:	fff78793          	addi	a5,a5,-1
    80005a8c:	00f4b823          	sd	a5,16(s1)
    80005a90:	fe0792e3          	bnez	a5,80005a74 <_ZN11mySemaphore17tryToUnblockTimerEv+0x50>
                cur->data->returnedValFromWaits = TIMEOUT;          //TIMEOUT = -2
    80005a94:	0004b783          	ld	a5,0(s1)
    80005a98:	ffe00713          	li	a4,-2
    80005a9c:	02e7aa23          	sw	a4,52(a5)
                Scheduler::put(cur->data);
    80005aa0:	0004b503          	ld	a0,0(s1)
    80005aa4:	00000097          	auipc	ra,0x0
    80005aa8:	46c080e7          	jalr	1132(ra) # 80005f10 <_ZN9Scheduler3putEP3TCB>
                if (prev) {
    80005aac:	fa090ae3          	beqz	s2,80005a60 <_ZN11mySemaphore17tryToUnblockTimerEv+0x3c>
                    prev->next = cur->next;
    80005ab0:	0084b783          	ld	a5,8(s1)
    80005ab4:	00f93423          	sd	a5,8(s2)
                if (curSem->suspendedTCBs.tail == cur) {
    80005ab8:	010a3783          	ld	a5,16(s4)
    80005abc:	fa9788e3          	beq	a5,s1,80005a6c <_ZN11mySemaphore17tryToUnblockTimerEv+0x48>
                cur = cur->next;
    80005ac0:	0084ba83          	ld	s5,8(s1)
            MemoryAllocator::my_mem_free(p);
    80005ac4:	00048513          	mv	a0,s1
    80005ac8:	00001097          	auipc	ra,0x1
    80005acc:	c28080e7          	jalr	-984(ra) # 800066f0 <_ZN15MemoryAllocator11my_mem_freeEPKv>
    80005ad0:	000a8493          	mv	s1,s5
                continue;
    80005ad4:	fa9ff06f          	j	80005a7c <_ZN11mySemaphore17tryToUnblockTimerEv+0x58>
        sem = sem->next;
    80005ad8:	0089b983          	ld	s3,8(s3)
    while (sem) {
    80005adc:	00098a63          	beqz	s3,80005af0 <_ZN11mySemaphore17tryToUnblockTimerEv+0xcc>
        mySemaphore* curSem = sem->data;
    80005ae0:	0009ba03          	ld	s4,0(s3)
        List<TCB>::Node* cur = curSem->suspendedTCBs.head;
    80005ae4:	008a3483          	ld	s1,8(s4)
        List<TCB>::Node* prev = nullptr;
    80005ae8:	00000913          	li	s2,0
    80005aec:	f91ff06f          	j	80005a7c <_ZN11mySemaphore17tryToUnblockTimerEv+0x58>
}
    80005af0:	03813083          	ld	ra,56(sp)
    80005af4:	03013403          	ld	s0,48(sp)
    80005af8:	02813483          	ld	s1,40(sp)
    80005afc:	02013903          	ld	s2,32(sp)
    80005b00:	01813983          	ld	s3,24(sp)
    80005b04:	01013a03          	ld	s4,16(sp)
    80005b08:	00813a83          	ld	s5,8(sp)
    80005b0c:	04010113          	addi	sp,sp,64
    80005b10:	00008067          	ret

0000000080005b14 <_ZN11mySemaphore14prepareSemOpenEPPS_j>:
void mySemaphore::prepareSemOpen(mySemaphore **handle, unsigned int init) {
    80005b14:	fd010113          	addi	sp,sp,-48
    80005b18:	02113423          	sd	ra,40(sp)
    80005b1c:	02813023          	sd	s0,32(sp)
    80005b20:	00913c23          	sd	s1,24(sp)
    80005b24:	01213823          	sd	s2,16(sp)
    80005b28:	01313423          	sd	s3,8(sp)
    80005b2c:	03010413          	addi	s0,sp,48
    80005b30:	00050493          	mv	s1,a0
    80005b34:	00058993          	mv	s3,a1
    (*handle) = new mySemaphore(init);
    80005b38:	01800513          	li	a0,24
    80005b3c:	00000097          	auipc	ra,0x0
    80005b40:	c2c080e7          	jalr	-980(ra) # 80005768 <_ZN11mySemaphorenwEm>
    80005b44:	00050913          	mv	s2,a0
    80005b48:	00098593          	mv	a1,s3
    80005b4c:	00000097          	auipc	ra,0x0
    80005b50:	c74080e7          	jalr	-908(ra) # 800057c0 <_ZN11mySemaphoreC1Ei>
    80005b54:	0124b023          	sd	s2,0(s1)
            return MemoryAllocator::my_mem_alloc(numofBlocks);
    80005b58:	00100513          	li	a0,1
    80005b5c:	00001097          	auipc	ra,0x1
    80005b60:	a70080e7          	jalr	-1424(ra) # 800065cc <_ZN15MemoryAllocator12my_mem_allocEm>
        Node(T *data, Node *next, uint64 time = 0) : data(data), next(next), timeBlockOrSleep(time) {}
    80005b64:	01253023          	sd	s2,0(a0)
    80005b68:	00053423          	sd	zero,8(a0)
    80005b6c:	00053823          	sd	zero,16(a0)
        if (tail) {
    80005b70:	00006797          	auipc	a5,0x6
    80005b74:	2087b783          	ld	a5,520(a5) # 8000bd78 <_ZN11mySemaphore13allSemaphoresE+0x8>
    80005b78:	04078063          	beqz	a5,80005bb8 <_ZN11mySemaphore14prepareSemOpenEPPS_j+0xa4>
            tail->next = elem;
    80005b7c:	00a7b423          	sd	a0,8(a5)
            tail = elem;
    80005b80:	00006797          	auipc	a5,0x6
    80005b84:	1ea7bc23          	sd	a0,504(a5) # 8000bd78 <_ZN11mySemaphore13allSemaphoresE+0x8>
    if (!(*handle)) {
    80005b88:	0004b783          	ld	a5,0(s1)
    80005b8c:	04078063          	beqz	a5,80005bcc <_ZN11mySemaphore14prepareSemOpenEPPS_j+0xb8>
        __asm__ volatile("li a0, 0");
    80005b90:	00000513          	li	a0,0
    Riscv::setA0onStack();
    80005b94:	fffff097          	auipc	ra,0xfffff
    80005b98:	7bc080e7          	jalr	1980(ra) # 80005350 <_ZN5Riscv12setA0onStackEv>
}
    80005b9c:	02813083          	ld	ra,40(sp)
    80005ba0:	02013403          	ld	s0,32(sp)
    80005ba4:	01813483          	ld	s1,24(sp)
    80005ba8:	01013903          	ld	s2,16(sp)
    80005bac:	00813983          	ld	s3,8(sp)
    80005bb0:	03010113          	addi	sp,sp,48
    80005bb4:	00008067          	ret
            head = tail = elem;
    80005bb8:	00006797          	auipc	a5,0x6
    80005bbc:	1b878793          	addi	a5,a5,440 # 8000bd70 <_ZN11mySemaphore13allSemaphoresE>
    80005bc0:	00a7b423          	sd	a0,8(a5)
    80005bc4:	00a7b023          	sd	a0,0(a5)
    80005bc8:	fc1ff06f          	j	80005b88 <_ZN11mySemaphore14prepareSemOpenEPPS_j+0x74>
        __asm__ volatile("li a0, 0xffffffffffffffff");           //unsuccessful alloc ret = -1
    80005bcc:	fff00513          	li	a0,-1
    80005bd0:	fc5ff06f          	j	80005b94 <_ZN11mySemaphore14prepareSemOpenEPPS_j+0x80>

0000000080005bd4 <_ZN11mySemaphore15prepareSemCloseEPS_>:
void mySemaphore::prepareSemClose(mySemaphore *handle) {
    80005bd4:	fe010113          	addi	sp,sp,-32
    80005bd8:	00113c23          	sd	ra,24(sp)
    80005bdc:	00813823          	sd	s0,16(sp)
    80005be0:	00913423          	sd	s1,8(sp)
    80005be4:	01213023          	sd	s2,0(sp)
    80005be8:	02010413          	addi	s0,sp,32
    if (handle) {
    80005bec:	0e050463          	beqz	a0,80005cd4 <_ZN11mySemaphore15prepareSemCloseEPS_+0x100>
    80005bf0:	00050493          	mv	s1,a0
        List<mySemaphore>::Node *cur = allSemaphores.head;
    80005bf4:	00006797          	auipc	a5,0x6
    80005bf8:	17c7b783          	ld	a5,380(a5) # 8000bd70 <_ZN11mySemaphore13allSemaphoresE>
        List<mySemaphore>::Node *prev = nullptr;
    80005bfc:	00000693          	li	a3,0
    80005c00:	00c0006f          	j	80005c0c <_ZN11mySemaphore15prepareSemCloseEPS_+0x38>
            prev = cur;
    80005c04:	00078693          	mv	a3,a5
            cur = cur->next;
    80005c08:	0087b783          	ld	a5,8(a5)
        while (cur->data != handle) {
    80005c0c:	0007b703          	ld	a4,0(a5)
    80005c10:	fe971ae3          	bne	a4,s1,80005c04 <_ZN11mySemaphore15prepareSemCloseEPS_+0x30>
        if (!cur) {
    80005c14:	02078463          	beqz	a5,80005c3c <_ZN11mySemaphore15prepareSemCloseEPS_+0x68>
            if (prev) {
    80005c18:	02068663          	beqz	a3,80005c44 <_ZN11mySemaphore15prepareSemCloseEPS_+0x70>
                prev->next = cur->next;
    80005c1c:	0087b703          	ld	a4,8(a5)
    80005c20:	00e6b423          	sd	a4,8(a3)
            if (allSemaphores.tail == cur) {
    80005c24:	00006717          	auipc	a4,0x6
    80005c28:	15473703          	ld	a4,340(a4) # 8000bd78 <_ZN11mySemaphore13allSemaphoresE+0x8>
    80005c2c:	04f71663          	bne	a4,a5,80005c78 <_ZN11mySemaphore15prepareSemCloseEPS_+0xa4>
                allSemaphores.tail = prev;
    80005c30:	00006797          	auipc	a5,0x6
    80005c34:	14d7b423          	sd	a3,328(a5) # 8000bd78 <_ZN11mySemaphore13allSemaphoresE+0x8>
    80005c38:	0400006f          	j	80005c78 <_ZN11mySemaphore15prepareSemCloseEPS_+0xa4>
            __asm__ volatile("li a0, 0xffffffffffffffff");
    80005c3c:	fff00513          	li	a0,-1
    80005c40:	0740006f          	j	80005cb4 <_ZN11mySemaphore15prepareSemCloseEPS_+0xe0>
                allSemaphores.head = cur->next;
    80005c44:	0087b703          	ld	a4,8(a5)
    80005c48:	00006617          	auipc	a2,0x6
    80005c4c:	12e63423          	sd	a4,296(a2) # 8000bd70 <_ZN11mySemaphore13allSemaphoresE>
    80005c50:	fd5ff06f          	j	80005c24 <_ZN11mySemaphore15prepareSemCloseEPS_+0x50>
        if (!head) { tail = 0; }
    80005c54:	0004b823          	sd	zero,16(s1)
        T *ret = elem->data;
    80005c58:	00053903          	ld	s2,0(a0)
            MemoryAllocator::my_mem_free(p);
    80005c5c:	00001097          	auipc	ra,0x1
    80005c60:	a94080e7          	jalr	-1388(ra) # 800066f0 <_ZN15MemoryAllocator11my_mem_freeEPKv>
                curTCB->returnedValFromWaits = SEMDEAD;
    80005c64:	fff00793          	li	a5,-1
    80005c68:	02f92a23          	sw	a5,52(s2)
                Scheduler::put(curTCB);
    80005c6c:	00090513          	mv	a0,s2
    80005c70:	00000097          	auipc	ra,0x0
    80005c74:	2a0080e7          	jalr	672(ra) # 80005f10 <_ZN9Scheduler3putEP3TCB>
        if (!head) { return 0; }
    80005c78:	0084b503          	ld	a0,8(s1)
    80005c7c:	00050e63          	beqz	a0,80005c98 <_ZN11mySemaphore15prepareSemCloseEPS_+0xc4>
        return head->data;
    80005c80:	00053783          	ld	a5,0(a0)
            while (handle->suspendedTCBs.peekFirst()) {
    80005c84:	00078a63          	beqz	a5,80005c98 <_ZN11mySemaphore15prepareSemCloseEPS_+0xc4>
        head = head->next;
    80005c88:	00853783          	ld	a5,8(a0)
    80005c8c:	00f4b423          	sd	a5,8(s1)
        if (!head) { tail = 0; }
    80005c90:	fc0794e3          	bnez	a5,80005c58 <_ZN11mySemaphore15prepareSemCloseEPS_+0x84>
    80005c94:	fc1ff06f          	j	80005c54 <_ZN11mySemaphore15prepareSemCloseEPS_+0x80>
            delete handle;
    80005c98:	00048513          	mv	a0,s1
    80005c9c:	00000097          	auipc	ra,0x0
    80005ca0:	b4c080e7          	jalr	-1204(ra) # 800057e8 <_ZN11mySemaphoreD1Ev>
    80005ca4:	00048513          	mv	a0,s1
    80005ca8:	00000097          	auipc	ra,0x0
    80005cac:	af0080e7          	jalr	-1296(ra) # 80005798 <_ZN11mySemaphoredlEPv>
            __asm__ volatile("li a0, 0");
    80005cb0:	00000513          	li	a0,0
    Riscv::setA0onStack();
    80005cb4:	fffff097          	auipc	ra,0xfffff
    80005cb8:	69c080e7          	jalr	1692(ra) # 80005350 <_ZN5Riscv12setA0onStackEv>
}
    80005cbc:	01813083          	ld	ra,24(sp)
    80005cc0:	01013403          	ld	s0,16(sp)
    80005cc4:	00813483          	ld	s1,8(sp)
    80005cc8:	00013903          	ld	s2,0(sp)
    80005ccc:	02010113          	addi	sp,sp,32
    80005cd0:	00008067          	ret
        __asm__ volatile("li a0, 0xffffffffffffffff");
    80005cd4:	fff00513          	li	a0,-1
    80005cd8:	fddff06f          	j	80005cb4 <_ZN11mySemaphore15prepareSemCloseEPS_+0xe0>

0000000080005cdc <_ZN11mySemaphore14prepareSemWaitEPS_>:
void mySemaphore::prepareSemWait(mySemaphore *id) {
    80005cdc:	fe010113          	addi	sp,sp,-32
    80005ce0:	00113c23          	sd	ra,24(sp)
    80005ce4:	00813823          	sd	s0,16(sp)
    80005ce8:	00913423          	sd	s1,8(sp)
    80005cec:	02010413          	addi	s0,sp,32
    TCB::running->returnedValFromWaits = 0;
    80005cf0:	00006497          	auipc	s1,0x6
    80005cf4:	fe048493          	addi	s1,s1,-32 # 8000bcd0 <_ZN3TCB7runningE>
    80005cf8:	0004b783          	ld	a5,0(s1)
    80005cfc:	0207aa23          	sw	zero,52(a5)
    id->wait();
    80005d00:	00000593          	li	a1,0
    80005d04:	00000097          	auipc	ra,0x0
    80005d08:	c24080e7          	jalr	-988(ra) # 80005928 <_ZN11mySemaphore4waitEm>
    if (TCB::running->returnedValFromWaits == SEMDEAD) {
    80005d0c:	0004b783          	ld	a5,0(s1)
    80005d10:	0347a783          	lw	a5,52(a5)
    80005d14:	fff00713          	li	a4,-1
    80005d18:	02e78663          	beq	a5,a4,80005d44 <_ZN11mySemaphore14prepareSemWaitEPS_+0x68>
    } else if (TCB::running->returnedValFromWaits == TIMEOUT) {
    80005d1c:	ffe00713          	li	a4,-2
    80005d20:	02e78663          	beq	a5,a4,80005d4c <_ZN11mySemaphore14prepareSemWaitEPS_+0x70>
        __asm__ volatile("li a0, 0");
    80005d24:	00000513          	li	a0,0
    Riscv::setA0onStack();
    80005d28:	fffff097          	auipc	ra,0xfffff
    80005d2c:	628080e7          	jalr	1576(ra) # 80005350 <_ZN5Riscv12setA0onStackEv>
}
    80005d30:	01813083          	ld	ra,24(sp)
    80005d34:	01013403          	ld	s0,16(sp)
    80005d38:	00813483          	ld	s1,8(sp)
    80005d3c:	02010113          	addi	sp,sp,32
    80005d40:	00008067          	ret
        __asm__ volatile("li a0, 0xffffffffffffffff");
    80005d44:	fff00513          	li	a0,-1
    80005d48:	fe1ff06f          	j	80005d28 <_ZN11mySemaphore14prepareSemWaitEPS_+0x4c>
        __asm__ volatile("li a0, 0xfffffffffffffffe");
    80005d4c:	ffe00513          	li	a0,-2
    80005d50:	fd9ff06f          	j	80005d28 <_ZN11mySemaphore14prepareSemWaitEPS_+0x4c>

0000000080005d54 <_ZN11mySemaphore16prepareSemSignalEPS_>:
void mySemaphore::prepareSemSignal(mySemaphore *id) {
    80005d54:	ff010113          	addi	sp,sp,-16
    80005d58:	00113423          	sd	ra,8(sp)
    80005d5c:	00813023          	sd	s0,0(sp)
    80005d60:	01010413          	addi	s0,sp,16
    if (id) {
    80005d64:	02050463          	beqz	a0,80005d8c <_ZN11mySemaphore16prepareSemSignalEPS_+0x38>
        id->signal();
    80005d68:	00000097          	auipc	ra,0x0
    80005d6c:	c74080e7          	jalr	-908(ra) # 800059dc <_ZN11mySemaphore6signalEv>
        __asm__ volatile("li a0, 0");
    80005d70:	00000513          	li	a0,0
    Riscv::setA0onStack();
    80005d74:	fffff097          	auipc	ra,0xfffff
    80005d78:	5dc080e7          	jalr	1500(ra) # 80005350 <_ZN5Riscv12setA0onStackEv>
}
    80005d7c:	00813083          	ld	ra,8(sp)
    80005d80:	00013403          	ld	s0,0(sp)
    80005d84:	01010113          	addi	sp,sp,16
    80005d88:	00008067          	ret
        __asm__ volatile("li a0, 0xffffffffffffffff");
    80005d8c:	fff00513          	li	a0,-1
    80005d90:	fe5ff06f          	j	80005d74 <_ZN11mySemaphore16prepareSemSignalEPS_+0x20>

0000000080005d94 <_ZN11mySemaphore19prepareSemTimedWaitEPS_m>:
void mySemaphore::prepareSemTimedWait(mySemaphore *id, time_t timeout) {
    80005d94:	ff010113          	addi	sp,sp,-16
    80005d98:	00113423          	sd	ra,8(sp)
    80005d9c:	00813023          	sd	s0,0(sp)
    80005da0:	01010413          	addi	s0,sp,16
    id->wait(timeout);
    80005da4:	00000097          	auipc	ra,0x0
    80005da8:	b84080e7          	jalr	-1148(ra) # 80005928 <_ZN11mySemaphore4waitEm>
    if (TCB::running->returnedValFromWaits == SEMDEAD) {
    80005dac:	00006797          	auipc	a5,0x6
    80005db0:	f247b783          	ld	a5,-220(a5) # 8000bcd0 <_ZN3TCB7runningE>
    80005db4:	0347a783          	lw	a5,52(a5)
    80005db8:	fff00713          	li	a4,-1
    80005dbc:	02e78463          	beq	a5,a4,80005de4 <_ZN11mySemaphore19prepareSemTimedWaitEPS_m+0x50>
    } else if (TCB::running->returnedValFromWaits == TIMEOUT) {
    80005dc0:	ffe00713          	li	a4,-2
    80005dc4:	02e78463          	beq	a5,a4,80005dec <_ZN11mySemaphore19prepareSemTimedWaitEPS_m+0x58>
        __asm__ volatile("li a0, 0");
    80005dc8:	00000513          	li	a0,0
    Riscv::setA0onStack();
    80005dcc:	fffff097          	auipc	ra,0xfffff
    80005dd0:	584080e7          	jalr	1412(ra) # 80005350 <_ZN5Riscv12setA0onStackEv>
}
    80005dd4:	00813083          	ld	ra,8(sp)
    80005dd8:	00013403          	ld	s0,0(sp)
    80005ddc:	01010113          	addi	sp,sp,16
    80005de0:	00008067          	ret
        __asm__ volatile("li a0, 0xffffffffffffffff");
    80005de4:	fff00513          	li	a0,-1
    80005de8:	fe5ff06f          	j	80005dcc <_ZN11mySemaphore19prepareSemTimedWaitEPS_m+0x38>
        __asm__ volatile("li a0, 0xfffffffffffffffe");
    80005dec:	ffe00513          	li	a0,-2
    80005df0:	fddff06f          	j	80005dcc <_ZN11mySemaphore19prepareSemTimedWaitEPS_m+0x38>

0000000080005df4 <_ZN11mySemaphore17prepareSemTryWaitEPS_>:
void mySemaphore::prepareSemTryWait(mySemaphore *id) {
    80005df4:	ff010113          	addi	sp,sp,-16
    80005df8:	00113423          	sd	ra,8(sp)
    80005dfc:	00813023          	sd	s0,0(sp)
    80005e00:	01010413          	addi	s0,sp,16
    if (id) {
    80005e04:	02050463          	beqz	a0,80005e2c <_ZN11mySemaphore17prepareSemTryWaitEPS_+0x38>
        res = id->tryWait();
    80005e08:	00000097          	auipc	ra,0x0
    80005e0c:	a60080e7          	jalr	-1440(ra) # 80005868 <_ZN11mySemaphore7tryWaitEv>
        __asm__ volatile("mv a0, %0" : : "r"(res));
    80005e10:	00050513          	mv	a0,a0
    Riscv::setA0onStack();
    80005e14:	fffff097          	auipc	ra,0xfffff
    80005e18:	53c080e7          	jalr	1340(ra) # 80005350 <_ZN5Riscv12setA0onStackEv>
}
    80005e1c:	00813083          	ld	ra,8(sp)
    80005e20:	00013403          	ld	s0,0(sp)
    80005e24:	01010113          	addi	sp,sp,16
    80005e28:	00008067          	ret
        __asm__ volatile("li a0, 0xffffffffffffffff");
    80005e2c:	fff00513          	li	a0,-1
    80005e30:	fe5ff06f          	j	80005e14 <_ZN11mySemaphore17prepareSemTryWaitEPS_+0x20>

0000000080005e34 <_GLOBAL__sub_I__ZN11mySemaphore13allSemaphoresE>:
}
    80005e34:	ff010113          	addi	sp,sp,-16
    80005e38:	00113423          	sd	ra,8(sp)
    80005e3c:	00813023          	sd	s0,0(sp)
    80005e40:	01010413          	addi	s0,sp,16
    80005e44:	000105b7          	lui	a1,0x10
    80005e48:	fff58593          	addi	a1,a1,-1 # ffff <_entry-0x7fff0001>
    80005e4c:	00100513          	li	a0,1
    80005e50:	00000097          	auipc	ra,0x0
    80005e54:	8d8080e7          	jalr	-1832(ra) # 80005728 <_Z41__static_initialization_and_destruction_0ii>
    80005e58:	00813083          	ld	ra,8(sp)
    80005e5c:	00013403          	ld	s0,0(sp)
    80005e60:	01010113          	addi	sp,sp,16
    80005e64:	00008067          	ret

0000000080005e68 <_Z41__static_initialization_and_destruction_0ii>:
    return readyCoroutineQueue.removeFirst();
}

void Scheduler::put(TCB *tcb) {
    readyCoroutineQueue.addLast(tcb);
}
    80005e68:	ff010113          	addi	sp,sp,-16
    80005e6c:	00813423          	sd	s0,8(sp)
    80005e70:	01010413          	addi	s0,sp,16
    80005e74:	00100793          	li	a5,1
    80005e78:	00f50863          	beq	a0,a5,80005e88 <_Z41__static_initialization_and_destruction_0ii+0x20>
    80005e7c:	00813403          	ld	s0,8(sp)
    80005e80:	01010113          	addi	sp,sp,16
    80005e84:	00008067          	ret
    80005e88:	000107b7          	lui	a5,0x10
    80005e8c:	fff78793          	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005e90:	fef596e3          	bne	a1,a5,80005e7c <_Z41__static_initialization_and_destruction_0ii+0x14>
    };
    Node *head, *tail;

public:
    List() : head(0), tail(0) {}
    80005e94:	00006797          	auipc	a5,0x6
    80005e98:	eec78793          	addi	a5,a5,-276 # 8000bd80 <_ZN9Scheduler19readyCoroutineQueueE>
    80005e9c:	0007b023          	sd	zero,0(a5)
    80005ea0:	0007b423          	sd	zero,8(a5)
    80005ea4:	fd9ff06f          	j	80005e7c <_Z41__static_initialization_and_destruction_0ii+0x14>

0000000080005ea8 <_ZN9Scheduler3getEv>:
TCB *Scheduler::get() {
    80005ea8:	fe010113          	addi	sp,sp,-32
    80005eac:	00113c23          	sd	ra,24(sp)
    80005eb0:	00813823          	sd	s0,16(sp)
    80005eb4:	00913423          	sd	s1,8(sp)
    80005eb8:	02010413          	addi	s0,sp,32
            head = tail = elem;
        }
    }

    T *removeFirst() {
        if (!head) { return 0; }
    80005ebc:	00006517          	auipc	a0,0x6
    80005ec0:	ec453503          	ld	a0,-316(a0) # 8000bd80 <_ZN9Scheduler19readyCoroutineQueueE>
    80005ec4:	04050263          	beqz	a0,80005f08 <_ZN9Scheduler3getEv+0x60>

        Node *elem = head;
        head = head->next;
    80005ec8:	00853783          	ld	a5,8(a0)
    80005ecc:	00006717          	auipc	a4,0x6
    80005ed0:	eaf73a23          	sd	a5,-332(a4) # 8000bd80 <_ZN9Scheduler19readyCoroutineQueueE>
        if (!head) { tail = 0; }
    80005ed4:	02078463          	beqz	a5,80005efc <_ZN9Scheduler3getEv+0x54>

        T *ret = elem->data;
    80005ed8:	00053483          	ld	s1,0(a0)
            MemoryAllocator::my_mem_free(p);
    80005edc:	00001097          	auipc	ra,0x1
    80005ee0:	814080e7          	jalr	-2028(ra) # 800066f0 <_ZN15MemoryAllocator11my_mem_freeEPKv>
}
    80005ee4:	00048513          	mv	a0,s1
    80005ee8:	01813083          	ld	ra,24(sp)
    80005eec:	01013403          	ld	s0,16(sp)
    80005ef0:	00813483          	ld	s1,8(sp)
    80005ef4:	02010113          	addi	sp,sp,32
    80005ef8:	00008067          	ret
        if (!head) { tail = 0; }
    80005efc:	00006797          	auipc	a5,0x6
    80005f00:	e807b623          	sd	zero,-372(a5) # 8000bd88 <_ZN9Scheduler19readyCoroutineQueueE+0x8>
    80005f04:	fd5ff06f          	j	80005ed8 <_ZN9Scheduler3getEv+0x30>
        if (!head) { return 0; }
    80005f08:	00050493          	mv	s1,a0
    return readyCoroutineQueue.removeFirst();
    80005f0c:	fd9ff06f          	j	80005ee4 <_ZN9Scheduler3getEv+0x3c>

0000000080005f10 <_ZN9Scheduler3putEP3TCB>:
void Scheduler::put(TCB *tcb) {
    80005f10:	fe010113          	addi	sp,sp,-32
    80005f14:	00113c23          	sd	ra,24(sp)
    80005f18:	00813823          	sd	s0,16(sp)
    80005f1c:	00913423          	sd	s1,8(sp)
    80005f20:	02010413          	addi	s0,sp,32
    80005f24:	00050493          	mv	s1,a0
            return MemoryAllocator::my_mem_alloc(numofBlocks);
    80005f28:	00100513          	li	a0,1
    80005f2c:	00000097          	auipc	ra,0x0
    80005f30:	6a0080e7          	jalr	1696(ra) # 800065cc <_ZN15MemoryAllocator12my_mem_allocEm>
        Node(T *data, Node *next, uint64 time = 0) : data(data), next(next), timeBlockOrSleep(time) {}
    80005f34:	00953023          	sd	s1,0(a0)
    80005f38:	00053423          	sd	zero,8(a0)
    80005f3c:	00053823          	sd	zero,16(a0)
        if (tail) {
    80005f40:	00006797          	auipc	a5,0x6
    80005f44:	e487b783          	ld	a5,-440(a5) # 8000bd88 <_ZN9Scheduler19readyCoroutineQueueE+0x8>
    80005f48:	02078263          	beqz	a5,80005f6c <_ZN9Scheduler3putEP3TCB+0x5c>
            tail->next = elem;
    80005f4c:	00a7b423          	sd	a0,8(a5)
            tail = elem;
    80005f50:	00006797          	auipc	a5,0x6
    80005f54:	e2a7bc23          	sd	a0,-456(a5) # 8000bd88 <_ZN9Scheduler19readyCoroutineQueueE+0x8>
}
    80005f58:	01813083          	ld	ra,24(sp)
    80005f5c:	01013403          	ld	s0,16(sp)
    80005f60:	00813483          	ld	s1,8(sp)
    80005f64:	02010113          	addi	sp,sp,32
    80005f68:	00008067          	ret
            head = tail = elem;
    80005f6c:	00006797          	auipc	a5,0x6
    80005f70:	e1478793          	addi	a5,a5,-492 # 8000bd80 <_ZN9Scheduler19readyCoroutineQueueE>
    80005f74:	00a7b423          	sd	a0,8(a5)
    80005f78:	00a7b023          	sd	a0,0(a5)
    80005f7c:	fddff06f          	j	80005f58 <_ZN9Scheduler3putEP3TCB+0x48>

0000000080005f80 <_GLOBAL__sub_I__ZN9Scheduler19readyCoroutineQueueE>:
    80005f80:	ff010113          	addi	sp,sp,-16
    80005f84:	00113423          	sd	ra,8(sp)
    80005f88:	00813023          	sd	s0,0(sp)
    80005f8c:	01010413          	addi	s0,sp,16
    80005f90:	000105b7          	lui	a1,0x10
    80005f94:	fff58593          	addi	a1,a1,-1 # ffff <_entry-0x7fff0001>
    80005f98:	00100513          	li	a0,1
    80005f9c:	00000097          	auipc	ra,0x0
    80005fa0:	ecc080e7          	jalr	-308(ra) # 80005e68 <_Z41__static_initialization_and_destruction_0ii>
    80005fa4:	00813083          	ld	ra,8(sp)
    80005fa8:	00013403          	ld	s0,0(sp)
    80005fac:	01010113          	addi	sp,sp,16
    80005fb0:	00008067          	ret

0000000080005fb4 <_ZN6Thread12startWrapperEPv>:
    return time_sleep(time);
}

Thread::Thread(): body(nullptr), arg(nullptr) {}

void Thread::startWrapper(void* t) {
    80005fb4:	ff010113          	addi	sp,sp,-16
    80005fb8:	00113423          	sd	ra,8(sp)
    80005fbc:	00813023          	sd	s0,0(sp)
    80005fc0:	01010413          	addi	s0,sp,16
    Thread* thr = (Thread*) t;
    thr->run();
    80005fc4:	00053783          	ld	a5,0(a0)
    80005fc8:	0107b783          	ld	a5,16(a5)
    80005fcc:	000780e7          	jalr	a5
}
    80005fd0:	00813083          	ld	ra,8(sp)
    80005fd4:	00013403          	ld	s0,0(sp)
    80005fd8:	01010113          	addi	sp,sp,16
    80005fdc:	00008067          	ret

0000000080005fe0 <_ZN9SemaphoreD1Ev>:

Semaphore::Semaphore(unsigned int init) {
    sem_open(&myHandle, init);
}

Semaphore::~Semaphore() {
    80005fe0:	ff010113          	addi	sp,sp,-16
    80005fe4:	00113423          	sd	ra,8(sp)
    80005fe8:	00813023          	sd	s0,0(sp)
    80005fec:	01010413          	addi	s0,sp,16
    80005ff0:	00003797          	auipc	a5,0x3
    80005ff4:	7b878793          	addi	a5,a5,1976 # 800097a8 <_ZTV9Semaphore+0x10>
    80005ff8:	00f53023          	sd	a5,0(a0)
    sem_close(myHandle);
    80005ffc:	00853503          	ld	a0,8(a0)
    80006000:	fffff097          	auipc	ra,0xfffff
    80006004:	f9c080e7          	jalr	-100(ra) # 80004f9c <_Z9sem_closeP11mySemaphore>
}
    80006008:	00813083          	ld	ra,8(sp)
    8000600c:	00013403          	ld	s0,0(sp)
    80006010:	01010113          	addi	sp,sp,16
    80006014:	00008067          	ret

0000000080006018 <_Znwm>:
void *operator new(size_t n) {
    80006018:	ff010113          	addi	sp,sp,-16
    8000601c:	00113423          	sd	ra,8(sp)
    80006020:	00813023          	sd	s0,0(sp)
    80006024:	01010413          	addi	s0,sp,16
    return mem_alloc(n);
    80006028:	fffff097          	auipc	ra,0xfffff
    8000602c:	db4080e7          	jalr	-588(ra) # 80004ddc <_Z9mem_allocm>
}
    80006030:	00813083          	ld	ra,8(sp)
    80006034:	00013403          	ld	s0,0(sp)
    80006038:	01010113          	addi	sp,sp,16
    8000603c:	00008067          	ret

0000000080006040 <_Znam>:
void *operator new[](size_t n) {
    80006040:	ff010113          	addi	sp,sp,-16
    80006044:	00113423          	sd	ra,8(sp)
    80006048:	00813023          	sd	s0,0(sp)
    8000604c:	01010413          	addi	s0,sp,16
    return mem_alloc(n);
    80006050:	fffff097          	auipc	ra,0xfffff
    80006054:	d8c080e7          	jalr	-628(ra) # 80004ddc <_Z9mem_allocm>
}
    80006058:	00813083          	ld	ra,8(sp)
    8000605c:	00013403          	ld	s0,0(sp)
    80006060:	01010113          	addi	sp,sp,16
    80006064:	00008067          	ret

0000000080006068 <_ZdlPv>:
void operator delete(void *p) noexcept {
    80006068:	ff010113          	addi	sp,sp,-16
    8000606c:	00113423          	sd	ra,8(sp)
    80006070:	00813023          	sd	s0,0(sp)
    80006074:	01010413          	addi	s0,sp,16
    mem_free(p);
    80006078:	fffff097          	auipc	ra,0xfffff
    8000607c:	dac080e7          	jalr	-596(ra) # 80004e24 <_Z8mem_freePv>
}
    80006080:	00813083          	ld	ra,8(sp)
    80006084:	00013403          	ld	s0,0(sp)
    80006088:	01010113          	addi	sp,sp,16
    8000608c:	00008067          	ret

0000000080006090 <_ZN9SemaphoreD0Ev>:
Semaphore::~Semaphore() {
    80006090:	fe010113          	addi	sp,sp,-32
    80006094:	00113c23          	sd	ra,24(sp)
    80006098:	00813823          	sd	s0,16(sp)
    8000609c:	00913423          	sd	s1,8(sp)
    800060a0:	02010413          	addi	s0,sp,32
    800060a4:	00050493          	mv	s1,a0
}
    800060a8:	00000097          	auipc	ra,0x0
    800060ac:	f38080e7          	jalr	-200(ra) # 80005fe0 <_ZN9SemaphoreD1Ev>
    800060b0:	00048513          	mv	a0,s1
    800060b4:	00000097          	auipc	ra,0x0
    800060b8:	fb4080e7          	jalr	-76(ra) # 80006068 <_ZdlPv>
    800060bc:	01813083          	ld	ra,24(sp)
    800060c0:	01013403          	ld	s0,16(sp)
    800060c4:	00813483          	ld	s1,8(sp)
    800060c8:	02010113          	addi	sp,sp,32
    800060cc:	00008067          	ret

00000000800060d0 <_ZdaPv>:
void operator delete[](void *p) noexcept {
    800060d0:	ff010113          	addi	sp,sp,-16
    800060d4:	00113423          	sd	ra,8(sp)
    800060d8:	00813023          	sd	s0,0(sp)
    800060dc:	01010413          	addi	s0,sp,16
    mem_free(p);
    800060e0:	fffff097          	auipc	ra,0xfffff
    800060e4:	d44080e7          	jalr	-700(ra) # 80004e24 <_Z8mem_freePv>
}
    800060e8:	00813083          	ld	ra,8(sp)
    800060ec:	00013403          	ld	s0,0(sp)
    800060f0:	01010113          	addi	sp,sp,16
    800060f4:	00008067          	ret

00000000800060f8 <_ZN6ThreadD1Ev>:
Thread::~Thread() {
    800060f8:	fe010113          	addi	sp,sp,-32
    800060fc:	00113c23          	sd	ra,24(sp)
    80006100:	00813823          	sd	s0,16(sp)
    80006104:	00913423          	sd	s1,8(sp)
    80006108:	02010413          	addi	s0,sp,32
    8000610c:	00003797          	auipc	a5,0x3
    80006110:	67478793          	addi	a5,a5,1652 # 80009780 <_ZTV6Thread+0x10>
    80006114:	00f53023          	sd	a5,0(a0)
    delete myHandle;
    80006118:	00853483          	ld	s1,8(a0)
    8000611c:	02048063          	beqz	s1,8000613c <_ZN6ThreadD1Ev+0x44>
class TCB {
public:
    void* operator new(size_t size);
    void operator delete(void *p);

    ~TCB() { delete[] stack; }
    80006120:	0184b503          	ld	a0,24(s1)
    80006124:	00050663          	beqz	a0,80006130 <_ZN6ThreadD1Ev+0x38>
    80006128:	00000097          	auipc	ra,0x0
    8000612c:	fa8080e7          	jalr	-88(ra) # 800060d0 <_ZdaPv>
    80006130:	00048513          	mv	a0,s1
    80006134:	fffff097          	auipc	ra,0xfffff
    80006138:	914080e7          	jalr	-1772(ra) # 80004a48 <_ZN3TCBdlEPv>
}
    8000613c:	01813083          	ld	ra,24(sp)
    80006140:	01013403          	ld	s0,16(sp)
    80006144:	00813483          	ld	s1,8(sp)
    80006148:	02010113          	addi	sp,sp,32
    8000614c:	00008067          	ret

0000000080006150 <_ZN6ThreadD0Ev>:
Thread::~Thread() {
    80006150:	fe010113          	addi	sp,sp,-32
    80006154:	00113c23          	sd	ra,24(sp)
    80006158:	00813823          	sd	s0,16(sp)
    8000615c:	00913423          	sd	s1,8(sp)
    80006160:	02010413          	addi	s0,sp,32
    80006164:	00050493          	mv	s1,a0
}
    80006168:	00000097          	auipc	ra,0x0
    8000616c:	f90080e7          	jalr	-112(ra) # 800060f8 <_ZN6ThreadD1Ev>
    80006170:	00048513          	mv	a0,s1
    80006174:	00000097          	auipc	ra,0x0
    80006178:	ef4080e7          	jalr	-268(ra) # 80006068 <_ZdlPv>
    8000617c:	01813083          	ld	ra,24(sp)
    80006180:	01013403          	ld	s0,16(sp)
    80006184:	00813483          	ld	s1,8(sp)
    80006188:	02010113          	addi	sp,sp,32
    8000618c:	00008067          	ret

0000000080006190 <_ZN6ThreadC1EPFvPvES0_>:
Thread::Thread(void (*body)(void *), void *arg): body(body), arg(arg) {}
    80006190:	ff010113          	addi	sp,sp,-16
    80006194:	00813423          	sd	s0,8(sp)
    80006198:	01010413          	addi	s0,sp,16
    8000619c:	00003797          	auipc	a5,0x3
    800061a0:	5e478793          	addi	a5,a5,1508 # 80009780 <_ZTV6Thread+0x10>
    800061a4:	00f53023          	sd	a5,0(a0)
    800061a8:	00b53823          	sd	a1,16(a0)
    800061ac:	00c53c23          	sd	a2,24(a0)
    800061b0:	00813403          	ld	s0,8(sp)
    800061b4:	01010113          	addi	sp,sp,16
    800061b8:	00008067          	ret

00000000800061bc <_ZN6Thread5startEv>:
int Thread::start () {
    800061bc:	ff010113          	addi	sp,sp,-16
    800061c0:	00113423          	sd	ra,8(sp)
    800061c4:	00813023          	sd	s0,0(sp)
    800061c8:	01010413          	addi	s0,sp,16
    if (body) {
    800061cc:	01053583          	ld	a1,16(a0)
    800061d0:	02058263          	beqz	a1,800061f4 <_ZN6Thread5startEv+0x38>
        return thread_create(&myHandle, body, arg);
    800061d4:	01853603          	ld	a2,24(a0)
    800061d8:	00850513          	addi	a0,a0,8
    800061dc:	fffff097          	auipc	ra,0xfffff
    800061e0:	c8c080e7          	jalr	-884(ra) # 80004e68 <_Z13thread_createPP3TCBPFvPvES2_>
}
    800061e4:	00813083          	ld	ra,8(sp)
    800061e8:	00013403          	ld	s0,0(sp)
    800061ec:	01010113          	addi	sp,sp,16
    800061f0:	00008067          	ret
        return thread_create(&myHandle, startWrapper, this);
    800061f4:	00050613          	mv	a2,a0
    800061f8:	00000597          	auipc	a1,0x0
    800061fc:	dbc58593          	addi	a1,a1,-580 # 80005fb4 <_ZN6Thread12startWrapperEPv>
    80006200:	00850513          	addi	a0,a0,8
    80006204:	fffff097          	auipc	ra,0xfffff
    80006208:	c64080e7          	jalr	-924(ra) # 80004e68 <_Z13thread_createPP3TCBPFvPvES2_>
    8000620c:	fd9ff06f          	j	800061e4 <_ZN6Thread5startEv+0x28>

0000000080006210 <_ZN6Thread8dispatchEv>:
void Thread::dispatch() {
    80006210:	ff010113          	addi	sp,sp,-16
    80006214:	00113423          	sd	ra,8(sp)
    80006218:	00813023          	sd	s0,0(sp)
    8000621c:	01010413          	addi	s0,sp,16
    thread_dispatch();
    80006220:	fffff097          	auipc	ra,0xfffff
    80006224:	d10080e7          	jalr	-752(ra) # 80004f30 <_Z15thread_dispatchv>
}
    80006228:	00813083          	ld	ra,8(sp)
    8000622c:	00013403          	ld	s0,0(sp)
    80006230:	01010113          	addi	sp,sp,16
    80006234:	00008067          	ret

0000000080006238 <_ZN6Thread5sleepEm>:
int Thread::sleep(time_t time) {
    80006238:	ff010113          	addi	sp,sp,-16
    8000623c:	00113423          	sd	ra,8(sp)
    80006240:	00813023          	sd	s0,0(sp)
    80006244:	01010413          	addi	s0,sp,16
    return time_sleep(time);
    80006248:	fffff097          	auipc	ra,0xfffff
    8000624c:	e70080e7          	jalr	-400(ra) # 800050b8 <_Z10time_sleepm>
}
    80006250:	00813083          	ld	ra,8(sp)
    80006254:	00013403          	ld	s0,0(sp)
    80006258:	01010113          	addi	sp,sp,16
    8000625c:	00008067          	ret

0000000080006260 <_ZN14PeriodicThread12startWrapperEPv>:
};

PeriodicThread::PeriodicThread(time_t period) : Thread(PeriodicThread::startWrapper, new PeriodicArgs(period, this)), period(period) {}


void PeriodicThread::startWrapper(void *arg) {
    80006260:	fe010113          	addi	sp,sp,-32
    80006264:	00113c23          	sd	ra,24(sp)
    80006268:	00813823          	sd	s0,16(sp)
    8000626c:	00913423          	sd	s1,8(sp)
    80006270:	01213023          	sd	s2,0(sp)
    80006274:	02010413          	addi	s0,sp,32
    80006278:	00050913          	mv	s2,a0
    PeriodicArgs* parg = (PeriodicArgs*) arg;
    PeriodicThread* thr = (PeriodicThread*) parg->handler;
    8000627c:	00853483          	ld	s1,8(a0)
    while (1) {
        if (thr->period == 0xFFFFFFFF) {        //stop signal
    80006280:	0204b703          	ld	a4,32(s1)
    80006284:	fff00793          	li	a5,-1
    80006288:	0207d793          	srli	a5,a5,0x20
    8000628c:	02f70263          	beq	a4,a5,800062b0 <_ZN14PeriodicThread12startWrapperEPv+0x50>
            break;
        }
        thr->periodicActivation();
    80006290:	0004b783          	ld	a5,0(s1)
    80006294:	0187b783          	ld	a5,24(a5)
    80006298:	00048513          	mv	a0,s1
    8000629c:	000780e7          	jalr	a5
        Thread::sleep(parg->time);
    800062a0:	00093503          	ld	a0,0(s2)
    800062a4:	00000097          	auipc	ra,0x0
    800062a8:	f94080e7          	jalr	-108(ra) # 80006238 <_ZN6Thread5sleepEm>
        if (thr->period == 0xFFFFFFFF) {        //stop signal
    800062ac:	fd5ff06f          	j	80006280 <_ZN14PeriodicThread12startWrapperEPv+0x20>
    }
}
    800062b0:	01813083          	ld	ra,24(sp)
    800062b4:	01013403          	ld	s0,16(sp)
    800062b8:	00813483          	ld	s1,8(sp)
    800062bc:	00013903          	ld	s2,0(sp)
    800062c0:	02010113          	addi	sp,sp,32
    800062c4:	00008067          	ret

00000000800062c8 <_ZN6ThreadC1Ev>:
Thread::Thread(): body(nullptr), arg(nullptr) {}
    800062c8:	ff010113          	addi	sp,sp,-16
    800062cc:	00813423          	sd	s0,8(sp)
    800062d0:	01010413          	addi	s0,sp,16
    800062d4:	00003797          	auipc	a5,0x3
    800062d8:	4ac78793          	addi	a5,a5,1196 # 80009780 <_ZTV6Thread+0x10>
    800062dc:	00f53023          	sd	a5,0(a0)
    800062e0:	00053823          	sd	zero,16(a0)
    800062e4:	00053c23          	sd	zero,24(a0)
    800062e8:	00813403          	ld	s0,8(sp)
    800062ec:	01010113          	addi	sp,sp,16
    800062f0:	00008067          	ret

00000000800062f4 <_ZN9SemaphoreC1Ej>:
Semaphore::Semaphore(unsigned int init) {
    800062f4:	ff010113          	addi	sp,sp,-16
    800062f8:	00113423          	sd	ra,8(sp)
    800062fc:	00813023          	sd	s0,0(sp)
    80006300:	01010413          	addi	s0,sp,16
    80006304:	00003797          	auipc	a5,0x3
    80006308:	4a478793          	addi	a5,a5,1188 # 800097a8 <_ZTV9Semaphore+0x10>
    8000630c:	00f53023          	sd	a5,0(a0)
    sem_open(&myHandle, init);
    80006310:	00850513          	addi	a0,a0,8
    80006314:	fffff097          	auipc	ra,0xfffff
    80006318:	c44080e7          	jalr	-956(ra) # 80004f58 <_Z8sem_openPP11mySemaphorej>
}
    8000631c:	00813083          	ld	ra,8(sp)
    80006320:	00013403          	ld	s0,0(sp)
    80006324:	01010113          	addi	sp,sp,16
    80006328:	00008067          	ret

000000008000632c <_ZN9Semaphore4waitEv>:
int Semaphore::wait() {
    8000632c:	ff010113          	addi	sp,sp,-16
    80006330:	00113423          	sd	ra,8(sp)
    80006334:	00813023          	sd	s0,0(sp)
    80006338:	01010413          	addi	s0,sp,16
    return sem_wait(myHandle);
    8000633c:	00853503          	ld	a0,8(a0)
    80006340:	fffff097          	auipc	ra,0xfffff
    80006344:	c94080e7          	jalr	-876(ra) # 80004fd4 <_Z8sem_waitP11mySemaphore>
}
    80006348:	00813083          	ld	ra,8(sp)
    8000634c:	00013403          	ld	s0,0(sp)
    80006350:	01010113          	addi	sp,sp,16
    80006354:	00008067          	ret

0000000080006358 <_ZN9Semaphore6signalEv>:
int Semaphore::signal() {
    80006358:	ff010113          	addi	sp,sp,-16
    8000635c:	00113423          	sd	ra,8(sp)
    80006360:	00813023          	sd	s0,0(sp)
    80006364:	01010413          	addi	s0,sp,16
    return sem_signal(myHandle);
    80006368:	00853503          	ld	a0,8(a0)
    8000636c:	fffff097          	auipc	ra,0xfffff
    80006370:	ca0080e7          	jalr	-864(ra) # 8000500c <_Z10sem_signalP11mySemaphore>
}
    80006374:	00813083          	ld	ra,8(sp)
    80006378:	00013403          	ld	s0,0(sp)
    8000637c:	01010113          	addi	sp,sp,16
    80006380:	00008067          	ret

0000000080006384 <_ZN9Semaphore9timedWaitEm>:
int Semaphore::timedWait(time_t time) {
    80006384:	ff010113          	addi	sp,sp,-16
    80006388:	00113423          	sd	ra,8(sp)
    8000638c:	00813023          	sd	s0,0(sp)
    80006390:	01010413          	addi	s0,sp,16
    return sem_timedwait(myHandle, time);
    80006394:	00853503          	ld	a0,8(a0)
    80006398:	fffff097          	auipc	ra,0xfffff
    8000639c:	cac080e7          	jalr	-852(ra) # 80005044 <_Z13sem_timedwaitP11mySemaphorem>
}
    800063a0:	00813083          	ld	ra,8(sp)
    800063a4:	00013403          	ld	s0,0(sp)
    800063a8:	01010113          	addi	sp,sp,16
    800063ac:	00008067          	ret

00000000800063b0 <_ZN9Semaphore7tryWaitEv>:
int Semaphore::tryWait() {
    800063b0:	ff010113          	addi	sp,sp,-16
    800063b4:	00113423          	sd	ra,8(sp)
    800063b8:	00813023          	sd	s0,0(sp)
    800063bc:	01010413          	addi	s0,sp,16
    return sem_trywait(myHandle);
    800063c0:	00853503          	ld	a0,8(a0)
    800063c4:	fffff097          	auipc	ra,0xfffff
    800063c8:	cbc080e7          	jalr	-836(ra) # 80005080 <_Z11sem_trywaitP11mySemaphore>
}
    800063cc:	00813083          	ld	ra,8(sp)
    800063d0:	00013403          	ld	s0,0(sp)
    800063d4:	01010113          	addi	sp,sp,16
    800063d8:	00008067          	ret

00000000800063dc <_ZN14PeriodicThread9terminateEv>:
void PeriodicThread::terminate() {
    800063dc:	ff010113          	addi	sp,sp,-16
    800063e0:	00813423          	sd	s0,8(sp)
    800063e4:	01010413          	addi	s0,sp,16
    period = 0xFFFFFFFF;
    800063e8:	fff00793          	li	a5,-1
    800063ec:	0207d793          	srli	a5,a5,0x20
    800063f0:	02f53023          	sd	a5,32(a0)
}
    800063f4:	00813403          	ld	s0,8(sp)
    800063f8:	01010113          	addi	sp,sp,16
    800063fc:	00008067          	ret

0000000080006400 <_ZN14PeriodicThreadC1Em>:
PeriodicThread::PeriodicThread(time_t period) : Thread(PeriodicThread::startWrapper, new PeriodicArgs(period, this)), period(period) {}
    80006400:	fe010113          	addi	sp,sp,-32
    80006404:	00113c23          	sd	ra,24(sp)
    80006408:	00813823          	sd	s0,16(sp)
    8000640c:	00913423          	sd	s1,8(sp)
    80006410:	01213023          	sd	s2,0(sp)
    80006414:	02010413          	addi	s0,sp,32
    80006418:	00050493          	mv	s1,a0
    8000641c:	00058913          	mv	s2,a1
    80006420:	01000513          	li	a0,16
    80006424:	00000097          	auipc	ra,0x0
    80006428:	bf4080e7          	jalr	-1036(ra) # 80006018 <_Znwm>
    8000642c:	00050613          	mv	a2,a0
    PeriodicArgs(time_t time, void* handler) : time(time), handler(handler){}
    80006430:	01253023          	sd	s2,0(a0)
    80006434:	00953423          	sd	s1,8(a0)
PeriodicThread::PeriodicThread(time_t period) : Thread(PeriodicThread::startWrapper, new PeriodicArgs(period, this)), period(period) {}
    80006438:	00000597          	auipc	a1,0x0
    8000643c:	e2858593          	addi	a1,a1,-472 # 80006260 <_ZN14PeriodicThread12startWrapperEPv>
    80006440:	00048513          	mv	a0,s1
    80006444:	00000097          	auipc	ra,0x0
    80006448:	d4c080e7          	jalr	-692(ra) # 80006190 <_ZN6ThreadC1EPFvPvES0_>
    8000644c:	00003797          	auipc	a5,0x3
    80006450:	30478793          	addi	a5,a5,772 # 80009750 <_ZTV14PeriodicThread+0x10>
    80006454:	00f4b023          	sd	a5,0(s1)
    80006458:	0324b023          	sd	s2,32(s1)
    8000645c:	01813083          	ld	ra,24(sp)
    80006460:	01013403          	ld	s0,16(sp)
    80006464:	00813483          	ld	s1,8(sp)
    80006468:	00013903          	ld	s2,0(sp)
    8000646c:	02010113          	addi	sp,sp,32
    80006470:	00008067          	ret

0000000080006474 <_ZN7Console4getcEv>:

char Console::getc() {
    80006474:	ff010113          	addi	sp,sp,-16
    80006478:	00113423          	sd	ra,8(sp)
    8000647c:	00813023          	sd	s0,0(sp)
    80006480:	01010413          	addi	s0,sp,16
    return ::getc();            //from C_API
    80006484:	fffff097          	auipc	ra,0xfffff
    80006488:	c78080e7          	jalr	-904(ra) # 800050fc <_Z4getcv>
}
    8000648c:	00813083          	ld	ra,8(sp)
    80006490:	00013403          	ld	s0,0(sp)
    80006494:	01010113          	addi	sp,sp,16
    80006498:	00008067          	ret

000000008000649c <_ZN7Console4putcEc>:

void Console::putc(char c) {
    8000649c:	ff010113          	addi	sp,sp,-16
    800064a0:	00113423          	sd	ra,8(sp)
    800064a4:	00813023          	sd	s0,0(sp)
    800064a8:	01010413          	addi	s0,sp,16
    ::putc(c);                  //from C_API
    800064ac:	fffff097          	auipc	ra,0xfffff
    800064b0:	c84080e7          	jalr	-892(ra) # 80005130 <_Z4putcc>
}
    800064b4:	00813083          	ld	ra,8(sp)
    800064b8:	00013403          	ld	s0,0(sp)
    800064bc:	01010113          	addi	sp,sp,16
    800064c0:	00008067          	ret

00000000800064c4 <_ZN6Thread3runEv>:
    static void dispatch ();
    static int sleep (time_t);

protected:
    Thread ();
    virtual void run () { }
    800064c4:	ff010113          	addi	sp,sp,-16
    800064c8:	00813423          	sd	s0,8(sp)
    800064cc:	01010413          	addi	s0,sp,16
    800064d0:	00813403          	ld	s0,8(sp)
    800064d4:	01010113          	addi	sp,sp,16
    800064d8:	00008067          	ret

00000000800064dc <_ZN14PeriodicThread18periodicActivationEv>:
    void terminate ();

protected:
    PeriodicThread (time_t period);

    virtual void periodicActivation () {}
    800064dc:	ff010113          	addi	sp,sp,-16
    800064e0:	00813423          	sd	s0,8(sp)
    800064e4:	01010413          	addi	s0,sp,16
    800064e8:	00813403          	ld	s0,8(sp)
    800064ec:	01010113          	addi	sp,sp,16
    800064f0:	00008067          	ret

00000000800064f4 <_ZN14PeriodicThreadD1Ev>:
class PeriodicThread : public Thread {
    800064f4:	ff010113          	addi	sp,sp,-16
    800064f8:	00113423          	sd	ra,8(sp)
    800064fc:	00813023          	sd	s0,0(sp)
    80006500:	01010413          	addi	s0,sp,16
    80006504:	00003797          	auipc	a5,0x3
    80006508:	24c78793          	addi	a5,a5,588 # 80009750 <_ZTV14PeriodicThread+0x10>
    8000650c:	00f53023          	sd	a5,0(a0)
    80006510:	00000097          	auipc	ra,0x0
    80006514:	be8080e7          	jalr	-1048(ra) # 800060f8 <_ZN6ThreadD1Ev>
    80006518:	00813083          	ld	ra,8(sp)
    8000651c:	00013403          	ld	s0,0(sp)
    80006520:	01010113          	addi	sp,sp,16
    80006524:	00008067          	ret

0000000080006528 <_ZN14PeriodicThreadD0Ev>:
    80006528:	fe010113          	addi	sp,sp,-32
    8000652c:	00113c23          	sd	ra,24(sp)
    80006530:	00813823          	sd	s0,16(sp)
    80006534:	00913423          	sd	s1,8(sp)
    80006538:	02010413          	addi	s0,sp,32
    8000653c:	00050493          	mv	s1,a0
    80006540:	00003797          	auipc	a5,0x3
    80006544:	21078793          	addi	a5,a5,528 # 80009750 <_ZTV14PeriodicThread+0x10>
    80006548:	00f53023          	sd	a5,0(a0)
    8000654c:	00000097          	auipc	ra,0x0
    80006550:	bac080e7          	jalr	-1108(ra) # 800060f8 <_ZN6ThreadD1Ev>
    80006554:	00048513          	mv	a0,s1
    80006558:	00000097          	auipc	ra,0x0
    8000655c:	b10080e7          	jalr	-1264(ra) # 80006068 <_ZdlPv>
    80006560:	01813083          	ld	ra,24(sp)
    80006564:	01013403          	ld	s0,16(sp)
    80006568:	00813483          	ld	s1,8(sp)
    8000656c:	02010113          	addi	sp,sp,32
    80006570:	00008067          	ret

0000000080006574 <_ZN15MemoryAllocator11memory_initEv>:
#include "../h/TCB.hpp"

MemoryAllocator::FreeMemBlock* MemoryAllocator::freeMemHead = nullptr;
int MemoryAllocator::memoryIntitialized = 0;

void MemoryAllocator::memory_init() {
    80006574:	ff010113          	addi	sp,sp,-16
    80006578:	00813423          	sd	s0,8(sp)
    8000657c:	01010413          	addi	s0,sp,16
    if (memoryIntitialized == 1) return;
    80006580:	00005717          	auipc	a4,0x5
    80006584:	76872703          	lw	a4,1896(a4) # 8000bce8 <_ZN15MemoryAllocator18memoryIntitializedE>
    80006588:	00100793          	li	a5,1
    8000658c:	02f70a63          	beq	a4,a5,800065c0 <_ZN15MemoryAllocator11memory_initEv+0x4c>
    memoryIntitialized = 1;
    80006590:	00005717          	auipc	a4,0x5
    80006594:	74f72c23          	sw	a5,1880(a4) # 8000bce8 <_ZN15MemoryAllocator18memoryIntitializedE>
    freeMemHead = (FreeMemBlock*) HEAP_START_ADDR;
    80006598:	00005717          	auipc	a4,0x5
    8000659c:	35873703          	ld	a4,856(a4) # 8000b8f0 <HEAP_START_ADDR>
    800065a0:	00005797          	auipc	a5,0x5
    800065a4:	74e7b823          	sd	a4,1872(a5) # 8000bcf0 <_ZN15MemoryAllocator11freeMemHeadE>
    *freeMemHead = { nullptr, (size_t) HEAP_END_ADDR - (size_t) HEAP_START_ADDR - HEADER_SIZE};
    800065a8:	00005797          	auipc	a5,0x5
    800065ac:	3407b783          	ld	a5,832(a5) # 8000b8e8 <HEAP_END_ADDR>
    800065b0:	40e787b3          	sub	a5,a5,a4
    800065b4:	ff078793          	addi	a5,a5,-16
    800065b8:	00073023          	sd	zero,0(a4)
    800065bc:	00f73423          	sd	a5,8(a4)
}
    800065c0:	00813403          	ld	s0,8(sp)
    800065c4:	01010113          	addi	sp,sp,16
    800065c8:	00008067          	ret

00000000800065cc <_ZN15MemoryAllocator12my_mem_allocEm>:

//deo koda je dat na proslim kolokvijumima - u delu Kontinualna alokacija
void *MemoryAllocator::my_mem_alloc(size_t size) {                           // size - numberOfBlocks (HEADER included)
    800065cc:	fe010113          	addi	sp,sp,-32
    800065d0:	00113c23          	sd	ra,24(sp)
    800065d4:	00813823          	sd	s0,16(sp)
    800065d8:	00913423          	sd	s1,8(sp)
    800065dc:	01213023          	sd	s2,0(sp)
    800065e0:	02010413          	addi	s0,sp,32
    800065e4:	00050493          	mv	s1,a0
    memory_init();
    800065e8:	00000097          	auipc	ra,0x0
    800065ec:	f8c080e7          	jalr	-116(ra) # 80006574 <_ZN15MemoryAllocator11memory_initEv>
    FreeMemBlock* cur = freeMemHead;
    800065f0:	00005517          	auipc	a0,0x5
    800065f4:	70053503          	ld	a0,1792(a0) # 8000bcf0 <_ZN15MemoryAllocator11freeMemHeadE>
    FreeMemBlock* prev = nullptr;
    800065f8:	00000613          	li	a2,0
    FreeMemBlock* nextNode;

    for (; cur; prev = cur, cur = cur->next) {
    800065fc:	02050863          	beqz	a0,8000662c <_ZN15MemoryAllocator12my_mem_allocEm+0x60>
        if (cur->size < size*MEM_BLOCK_SIZE - HEADER_SIZE) continue;            //no space
    80006600:	00853783          	ld	a5,8(a0)
    80006604:	00649693          	slli	a3,s1,0x6
    80006608:	ff068713          	addi	a4,a3,-16
    8000660c:	04e7e663          	bltu	a5,a4,80006658 <_ZN15MemoryAllocator12my_mem_allocEm+0x8c>
        if (cur->size - size*MEM_BLOCK_SIZE < 0) {
            continue;                                                           //no left free space for header
        } else if (cur->size == size*MEM_BLOCK_SIZE - HEADER_SIZE) {
    80006610:	04e78a63          	beq	a5,a4,80006664 <_ZN15MemoryAllocator12my_mem_allocEm+0x98>
            nextNode = cur->next;
        } else {                                    //cur->size >= size*MEM_BLOCK_SIZE
            size_t nextSize = cur->size - size*MEM_BLOCK_SIZE;
    80006614:	40d787b3          	sub	a5,a5,a3
            cur->size = size*MEM_BLOCK_SIZE - HEADER_SIZE;
    80006618:	00e53423          	sd	a4,8(a0)
            nextNode = (FreeMemBlock*) ((size_t) cur + size*MEM_BLOCK_SIZE);
    8000661c:	00d50933          	add	s2,a0,a3
            nextNode->next = cur->next;
    80006620:	00053703          	ld	a4,0(a0)
    80006624:	00e93023          	sd	a4,0(s2)
            nextNode->size = nextSize;
    80006628:	00f93423          	sd	a5,8(s2)
        }
        break;
    }
    if (!cur) return nullptr;
    8000662c:	00050a63          	beqz	a0,80006640 <_ZN15MemoryAllocator12my_mem_allocEm+0x74>

    cur->next = nullptr;
    80006630:	00053023          	sd	zero,0(a0)
    if (prev) prev->next = nextNode;
    80006634:	02060c63          	beqz	a2,8000666c <_ZN15MemoryAllocator12my_mem_allocEm+0xa0>
    80006638:	01263023          	sd	s2,0(a2)
    else freeMemHead = nextNode;
    return (cur + 1);             //preskace zaglavlje ( +1 jer je pokazivac na FreeMemBlock, pa se dodaje + 1*sizeof(FreeMemBlock) = 16)
    8000663c:	01050513          	addi	a0,a0,16
}
    80006640:	01813083          	ld	ra,24(sp)
    80006644:	01013403          	ld	s0,16(sp)
    80006648:	00813483          	ld	s1,8(sp)
    8000664c:	00013903          	ld	s2,0(sp)
    80006650:	02010113          	addi	sp,sp,32
    80006654:	00008067          	ret
    for (; cur; prev = cur, cur = cur->next) {
    80006658:	00050613          	mv	a2,a0
    8000665c:	00053503          	ld	a0,0(a0)
    80006660:	f9dff06f          	j	800065fc <_ZN15MemoryAllocator12my_mem_allocEm+0x30>
            nextNode = cur->next;
    80006664:	00053903          	ld	s2,0(a0)
    80006668:	fc5ff06f          	j	8000662c <_ZN15MemoryAllocator12my_mem_allocEm+0x60>
    else freeMemHead = nextNode;
    8000666c:	00005797          	auipc	a5,0x5
    80006670:	6927b223          	sd	s2,1668(a5) # 8000bcf0 <_ZN15MemoryAllocator11freeMemHeadE>
    80006674:	fc9ff06f          	j	8000663c <_ZN15MemoryAllocator12my_mem_allocEm+0x70>

0000000080006678 <_ZN15MemoryAllocator9tryToJoinEPNS_12FreeMemBlockES1_>:

    return 0;
}

//zadatak sa kolokvijuma - gotovo identican
void MemoryAllocator::tryToJoin(MemoryAllocator::FreeMemBlock *f1, MemoryAllocator::FreeMemBlock *f2) {
    80006678:	fe010113          	addi	sp,sp,-32
    8000667c:	00113c23          	sd	ra,24(sp)
    80006680:	00813823          	sd	s0,16(sp)
    80006684:	00913423          	sd	s1,8(sp)
    80006688:	01213023          	sd	s2,0(sp)
    8000668c:	02010413          	addi	s0,sp,32
    80006690:	00050493          	mv	s1,a0
    80006694:	00058913          	mv	s2,a1
    memory_init();
    80006698:	00000097          	auipc	ra,0x0
    8000669c:	edc080e7          	jalr	-292(ra) # 80006574 <_ZN15MemoryAllocator11memory_initEv>
    if (!f1) return;
    800066a0:	00048e63          	beqz	s1,800066bc <_ZN15MemoryAllocator9tryToJoinEPNS_12FreeMemBlockES1_+0x44>
    if (f2 && ((uint64) f1 + HEADER_SIZE + f1->size == (uint64) f2)) {
    800066a4:	00090a63          	beqz	s2,800066b8 <_ZN15MemoryAllocator9tryToJoinEPNS_12FreeMemBlockES1_+0x40>
    800066a8:	0084b703          	ld	a4,8(s1)
    800066ac:	00e487b3          	add	a5,s1,a4
    800066b0:	01078793          	addi	a5,a5,16
    800066b4:	03278063          	beq	a5,s2,800066d4 <_ZN15MemoryAllocator9tryToJoinEPNS_12FreeMemBlockES1_+0x5c>
        f1->size += HEADER_SIZE + f2->size;
        f1->next = f2->next;
    } else {
        f1->next = f2;
    800066b8:	0124b023          	sd	s2,0(s1)
    }
}
    800066bc:	01813083          	ld	ra,24(sp)
    800066c0:	01013403          	ld	s0,16(sp)
    800066c4:	00813483          	ld	s1,8(sp)
    800066c8:	00013903          	ld	s2,0(sp)
    800066cc:	02010113          	addi	sp,sp,32
    800066d0:	00008067          	ret
        f1->size += HEADER_SIZE + f2->size;
    800066d4:	00893783          	ld	a5,8(s2)
    800066d8:	00f70733          	add	a4,a4,a5
    800066dc:	01070713          	addi	a4,a4,16
    800066e0:	00e4b423          	sd	a4,8(s1)
        f1->next = f2->next;
    800066e4:	00093783          	ld	a5,0(s2)
    800066e8:	00f4b023          	sd	a5,0(s1)
    800066ec:	fd1ff06f          	j	800066bc <_ZN15MemoryAllocator9tryToJoinEPNS_12FreeMemBlockES1_+0x44>

00000000800066f0 <_ZN15MemoryAllocator11my_mem_freeEPKv>:
int MemoryAllocator::my_mem_free(const void * f) {
    800066f0:	fe010113          	addi	sp,sp,-32
    800066f4:	00113c23          	sd	ra,24(sp)
    800066f8:	00813823          	sd	s0,16(sp)
    800066fc:	00913423          	sd	s1,8(sp)
    80006700:	01213023          	sd	s2,0(sp)
    80006704:	02010413          	addi	s0,sp,32
    80006708:	00050493          	mv	s1,a0
    memory_init();
    8000670c:	00000097          	auipc	ra,0x0
    80006710:	e68080e7          	jalr	-408(ra) # 80006574 <_ZN15MemoryAllocator11memory_initEv>
    FreeMemBlock* toFree = ((FreeMemBlock*) f) - 1;
    80006714:	ff048493          	addi	s1,s1,-16
    if (toFree < HEAP_START_ADDR || toFree >= HEAP_END_ADDR) return -1;
    80006718:	00005797          	auipc	a5,0x5
    8000671c:	1d87b783          	ld	a5,472(a5) # 8000b8f0 <HEAP_START_ADDR>
    80006720:	08f4e263          	bltu	s1,a5,800067a4 <_ZN15MemoryAllocator11my_mem_freeEPKv+0xb4>
    80006724:	00005797          	auipc	a5,0x5
    80006728:	1c47b783          	ld	a5,452(a5) # 8000b8e8 <HEAP_END_ADDR>
    8000672c:	08f4f063          	bgeu	s1,a5,800067ac <_ZN15MemoryAllocator11my_mem_freeEPKv+0xbc>
    if (toFree < freeMemHead) {
    80006730:	00005917          	auipc	s2,0x5
    80006734:	5c093903          	ld	s2,1472(s2) # 8000bcf0 <_ZN15MemoryAllocator11freeMemHeadE>
    80006738:	0524f663          	bgeu	s1,s2,80006784 <_ZN15MemoryAllocator11my_mem_freeEPKv+0x94>
        freeMemHead = toFree;
    8000673c:	00005797          	auipc	a5,0x5
    80006740:	5a97ba23          	sd	s1,1460(a5) # 8000bcf0 <_ZN15MemoryAllocator11freeMemHeadE>
        nextNode = freeMemHead;
    80006744:	00090593          	mv	a1,s2
        prev = nullptr;
    80006748:	00000913          	li	s2,0
    tryToJoin(toFree, nextNode);
    8000674c:	00048513          	mv	a0,s1
    80006750:	00000097          	auipc	ra,0x0
    80006754:	f28080e7          	jalr	-216(ra) # 80006678 <_ZN15MemoryAllocator9tryToJoinEPNS_12FreeMemBlockES1_>
    tryToJoin(prev, toFree);
    80006758:	00048593          	mv	a1,s1
    8000675c:	00090513          	mv	a0,s2
    80006760:	00000097          	auipc	ra,0x0
    80006764:	f18080e7          	jalr	-232(ra) # 80006678 <_ZN15MemoryAllocator9tryToJoinEPNS_12FreeMemBlockES1_>
    return 0;
    80006768:	00000513          	li	a0,0
}
    8000676c:	01813083          	ld	ra,24(sp)
    80006770:	01013403          	ld	s0,16(sp)
    80006774:	00813483          	ld	s1,8(sp)
    80006778:	00013903          	ld	s2,0(sp)
    8000677c:	02010113          	addi	sp,sp,32
    80006780:	00008067          	ret
        nextNode = freeMemHead->next;
    80006784:	00093583          	ld	a1,0(s2)
    80006788:	00c0006f          	j	80006794 <_ZN15MemoryAllocator11my_mem_freeEPKv+0xa4>
        for (; nextNode && !(prev <toFree && nextNode > toFree); prev = nextNode, nextNode = nextNode->next);
    8000678c:	00058913          	mv	s2,a1
    80006790:	0005b583          	ld	a1,0(a1)
    80006794:	fa058ce3          	beqz	a1,8000674c <_ZN15MemoryAllocator11my_mem_freeEPKv+0x5c>
    80006798:	fe997ae3          	bgeu	s2,s1,8000678c <_ZN15MemoryAllocator11my_mem_freeEPKv+0x9c>
    8000679c:	feb4f8e3          	bgeu	s1,a1,8000678c <_ZN15MemoryAllocator11my_mem_freeEPKv+0x9c>
    800067a0:	fadff06f          	j	8000674c <_ZN15MemoryAllocator11my_mem_freeEPKv+0x5c>
    if (toFree < HEAP_START_ADDR || toFree >= HEAP_END_ADDR) return -1;
    800067a4:	fff00513          	li	a0,-1
    800067a8:	fc5ff06f          	j	8000676c <_ZN15MemoryAllocator11my_mem_freeEPKv+0x7c>
    800067ac:	fff00513          	li	a0,-1
    800067b0:	fbdff06f          	j	8000676c <_ZN15MemoryAllocator11my_mem_freeEPKv+0x7c>

00000000800067b4 <_ZN15MemoryAllocator15prepareMemAllocEm>:


void MemoryAllocator::prepareMemAlloc(size_t size) {                    //number of blocks - size
    800067b4:	ff010113          	addi	sp,sp,-16
    800067b8:	00113423          	sd	ra,8(sp)
    800067bc:	00813023          	sd	s0,0(sp)
    800067c0:	01010413          	addi	s0,sp,16

    void* addr = my_mem_alloc(size);
    800067c4:	00000097          	auipc	ra,0x0
    800067c8:	e08080e7          	jalr	-504(ra) # 800065cc <_ZN15MemoryAllocator12my_mem_allocEm>

    __asm__ volatile("mv a0, %0" : : "r"((uint64) addr));       //ret value
    800067cc:	00050513          	mv	a0,a0

    //save a0 on old context stack
    Riscv::setA0onStack();
    800067d0:	fffff097          	auipc	ra,0xfffff
    800067d4:	b80080e7          	jalr	-1152(ra) # 80005350 <_ZN5Riscv12setA0onStackEv>

}
    800067d8:	00813083          	ld	ra,8(sp)
    800067dc:	00013403          	ld	s0,0(sp)
    800067e0:	01010113          	addi	sp,sp,16
    800067e4:	00008067          	ret

00000000800067e8 <_ZN15MemoryAllocator14prepareMemFreeEm>:

void MemoryAllocator::prepareMemFree(uint64 addr) {
    800067e8:	ff010113          	addi	sp,sp,-16
    800067ec:	00113423          	sd	ra,8(sp)
    800067f0:	00813023          	sd	s0,0(sp)
    800067f4:	01010413          	addi	s0,sp,16

    uint64 ret = my_mem_free((void*) addr);
    800067f8:	00000097          	auipc	ra,0x0
    800067fc:	ef8080e7          	jalr	-264(ra) # 800066f0 <_ZN15MemoryAllocator11my_mem_freeEPKv>

    __asm__ volatile("mv a0, %0" : : "r"(ret));       //ret value
    80006800:	00050513          	mv	a0,a0

    //save a0 on old context stack
    Riscv::setA0onStack();
    80006804:	fffff097          	auipc	ra,0xfffff
    80006808:	b4c080e7          	jalr	-1204(ra) # 80005350 <_ZN5Riscv12setA0onStackEv>
}
    8000680c:	00813083          	ld	ra,8(sp)
    80006810:	00013403          	ld	s0,0(sp)
    80006814:	01010113          	addi	sp,sp,16
    80006818:	00008067          	ret

000000008000681c <_ZN9myConsole12console_initEv>:
uint64 myConsole::numberOfCharToSend = 0;
uint64 myConsole::numberOfCharToGet = 0;
bool myConsole::stopConsole = false;


void myConsole::console_init() {
    8000681c:	fe010113          	addi	sp,sp,-32
    80006820:	00113c23          	sd	ra,24(sp)
    80006824:	00813823          	sd	s0,16(sp)
    80006828:	00913423          	sd	s1,8(sp)
    8000682c:	01213023          	sd	s2,0(sp)
    80006830:	02010413          	addi	s0,sp,32
    semInput = new mySemaphore(0);
    80006834:	01800513          	li	a0,24
    80006838:	fffff097          	auipc	ra,0xfffff
    8000683c:	f30080e7          	jalr	-208(ra) # 80005768 <_ZN11mySemaphorenwEm>
    80006840:	00050493          	mv	s1,a0
    80006844:	00000593          	li	a1,0
    80006848:	fffff097          	auipc	ra,0xfffff
    8000684c:	f78080e7          	jalr	-136(ra) # 800057c0 <_ZN11mySemaphoreC1Ei>
    80006850:	00005797          	auipc	a5,0x5
    80006854:	4e97b423          	sd	s1,1256(a5) # 8000bd38 <_ZN9myConsole8semInputE>
    semOutput = new mySemaphore(0);
    80006858:	01800513          	li	a0,24
    8000685c:	fffff097          	auipc	ra,0xfffff
    80006860:	f0c080e7          	jalr	-244(ra) # 80005768 <_ZN11mySemaphorenwEm>
    80006864:	00050493          	mv	s1,a0
    80006868:	00000593          	li	a1,0
    8000686c:	fffff097          	auipc	ra,0xfffff
    80006870:	f54080e7          	jalr	-172(ra) # 800057c0 <_ZN11mySemaphoreC1Ei>
    80006874:	00005797          	auipc	a5,0x5
    80006878:	4a97be23          	sd	s1,1212(a5) # 8000bd30 <_ZN9myConsole9semOutputE>
}
    8000687c:	01813083          	ld	ra,24(sp)
    80006880:	01013403          	ld	s0,16(sp)
    80006884:	00813483          	ld	s1,8(sp)
    80006888:	00013903          	ld	s2,0(sp)
    8000688c:	02010113          	addi	sp,sp,32
    80006890:	00008067          	ret
    80006894:	00050913          	mv	s2,a0
    semInput = new mySemaphore(0);
    80006898:	00048513          	mv	a0,s1
    8000689c:	fffff097          	auipc	ra,0xfffff
    800068a0:	efc080e7          	jalr	-260(ra) # 80005798 <_ZN11mySemaphoredlEPv>
    800068a4:	00090513          	mv	a0,s2
    800068a8:	00007097          	auipc	ra,0x7
    800068ac:	db0080e7          	jalr	-592(ra) # 8000d658 <_Unwind_Resume>
    800068b0:	00050913          	mv	s2,a0
    semOutput = new mySemaphore(0);
    800068b4:	00048513          	mv	a0,s1
    800068b8:	fffff097          	auipc	ra,0xfffff
    800068bc:	ee0080e7          	jalr	-288(ra) # 80005798 <_ZN11mySemaphoredlEPv>
    800068c0:	00090513          	mv	a0,s2
    800068c4:	00007097          	auipc	ra,0x7
    800068c8:	d94080e7          	jalr	-620(ra) # 8000d658 <_Unwind_Resume>

00000000800068cc <_ZN9myConsole11putCOutBuffEc>:

void myConsole::putCOutBuff(char c) {
    if ((outputTail+1) % BUFFER_SIZE == outputHead) {
    800068cc:	00005717          	auipc	a4,0x5
    800068d0:	44473703          	ld	a4,1092(a4) # 8000bd10 <_ZN9myConsole10outputTailE>
    800068d4:	00170793          	addi	a5,a4,1
    800068d8:	3ff7f793          	andi	a5,a5,1023
    800068dc:	00005697          	auipc	a3,0x5
    800068e0:	43c6b683          	ld	a3,1084(a3) # 8000bd18 <_ZN9myConsole10outputHeadE>
    800068e4:	06d78063          	beq	a5,a3,80006944 <_ZN9myConsole11putCOutBuffEc+0x78>
void myConsole::putCOutBuff(char c) {
    800068e8:	ff010113          	addi	sp,sp,-16
    800068ec:	00113423          	sd	ra,8(sp)
    800068f0:	00813023          	sd	s0,0(sp)
    800068f4:	01010413          	addi	s0,sp,16
        return;                                 //outputBuffer FULL
    }

    outputBuffer[outputTail] =  c;
    800068f8:	00005697          	auipc	a3,0x5
    800068fc:	49868693          	addi	a3,a3,1176 # 8000bd90 <_ZN9myConsole12outputBufferE>
    80006900:	00e68733          	add	a4,a3,a4
    80006904:	00a70023          	sb	a0,0(a4)
    outputTail = (outputTail+1) % BUFFER_SIZE;
    80006908:	00005717          	auipc	a4,0x5
    8000690c:	40f73423          	sd	a5,1032(a4) # 8000bd10 <_ZN9myConsole10outputTailE>
    numberOfCharToSend++;
    80006910:	00005717          	auipc	a4,0x5
    80006914:	3f870713          	addi	a4,a4,1016 # 8000bd08 <_ZN9myConsole18numberOfCharToSendE>
    80006918:	00073783          	ld	a5,0(a4)
    8000691c:	00178793          	addi	a5,a5,1
    80006920:	00f73023          	sd	a5,0(a4)
    semOutput->signal();
    80006924:	00005517          	auipc	a0,0x5
    80006928:	40c53503          	ld	a0,1036(a0) # 8000bd30 <_ZN9myConsole9semOutputE>
    8000692c:	fffff097          	auipc	ra,0xfffff
    80006930:	0b0080e7          	jalr	176(ra) # 800059dc <_ZN11mySemaphore6signalEv>
}
    80006934:	00813083          	ld	ra,8(sp)
    80006938:	00013403          	ld	s0,0(sp)
    8000693c:	01010113          	addi	sp,sp,16
    80006940:	00008067          	ret
    80006944:	00008067          	ret

0000000080006948 <_ZN9myConsole10getCInBuffEv>:

int myConsole::getCInBuff() {
    80006948:	ff010113          	addi	sp,sp,-16
    8000694c:	00113423          	sd	ra,8(sp)
    80006950:	00813023          	sd	s0,0(sp)
    80006954:	01010413          	addi	s0,sp,16
    semInput->wait();
    80006958:	00000593          	li	a1,0
    8000695c:	00005517          	auipc	a0,0x5
    80006960:	3dc53503          	ld	a0,988(a0) # 8000bd38 <_ZN9myConsole8semInputE>
    80006964:	fffff097          	auipc	ra,0xfffff
    80006968:	fc4080e7          	jalr	-60(ra) # 80005928 <_ZN11mySemaphore4waitEm>
    if (inputHead == inputTail) {
    8000696c:	00005797          	auipc	a5,0x5
    80006970:	3bc7b783          	ld	a5,956(a5) # 8000bd28 <_ZN9myConsole9inputHeadE>
    80006974:	00005717          	auipc	a4,0x5
    80006978:	3ac73703          	ld	a4,940(a4) # 8000bd20 <_ZN9myConsole9inputTailE>
    8000697c:	02e78a63          	beq	a5,a4,800069b0 <_ZN9myConsole10getCInBuffEv+0x68>
        return -1;                  //ERROR code
    }
    char res = inputBuffer[inputHead];
    80006980:	00005717          	auipc	a4,0x5
    80006984:	41070713          	addi	a4,a4,1040 # 8000bd90 <_ZN9myConsole12outputBufferE>
    80006988:	00f70733          	add	a4,a4,a5
    inputHead = (inputHead+1) % BUFFER_SIZE;
    8000698c:	00178793          	addi	a5,a5,1
    80006990:	3ff7f793          	andi	a5,a5,1023
    80006994:	00005697          	auipc	a3,0x5
    80006998:	38f6ba23          	sd	a5,916(a3) # 8000bd28 <_ZN9myConsole9inputHeadE>
    return res;
    8000699c:	40074503          	lbu	a0,1024(a4)
}
    800069a0:	00813083          	ld	ra,8(sp)
    800069a4:	00013403          	ld	s0,0(sp)
    800069a8:	01010113          	addi	sp,sp,16
    800069ac:	00008067          	ret
        return -1;                  //ERROR code
    800069b0:	fff00513          	li	a0,-1
    800069b4:	fedff06f          	j	800069a0 <_ZN9myConsole10getCInBuffEv+0x58>

00000000800069b8 <_ZN9myConsole10putCInBuffEc>:

void myConsole::putCInBuff(char c) {
    if ((inputTail+1) % BUFFER_SIZE == inputHead) {
    800069b8:	00005717          	auipc	a4,0x5
    800069bc:	36873703          	ld	a4,872(a4) # 8000bd20 <_ZN9myConsole9inputTailE>
    800069c0:	00170793          	addi	a5,a4,1
    800069c4:	3ff7f793          	andi	a5,a5,1023
    800069c8:	00005697          	auipc	a3,0x5
    800069cc:	3606b683          	ld	a3,864(a3) # 8000bd28 <_ZN9myConsole9inputHeadE>
    800069d0:	04d78663          	beq	a5,a3,80006a1c <_ZN9myConsole10putCInBuffEc+0x64>
void myConsole::putCInBuff(char c) {
    800069d4:	ff010113          	addi	sp,sp,-16
    800069d8:	00113423          	sd	ra,8(sp)
    800069dc:	00813023          	sd	s0,0(sp)
    800069e0:	01010413          	addi	s0,sp,16
        return;                                 //outputBuffer FULL
    }
    inputBuffer[inputTail] =  c;
    800069e4:	00005697          	auipc	a3,0x5
    800069e8:	3ac68693          	addi	a3,a3,940 # 8000bd90 <_ZN9myConsole12outputBufferE>
    800069ec:	00e68733          	add	a4,a3,a4
    800069f0:	40a70023          	sb	a0,1024(a4)
    inputTail = (inputTail+1) % BUFFER_SIZE;
    800069f4:	00005717          	auipc	a4,0x5
    800069f8:	32f73623          	sd	a5,812(a4) # 8000bd20 <_ZN9myConsole9inputTailE>
    semInput->signal();
    800069fc:	00005517          	auipc	a0,0x5
    80006a00:	33c53503          	ld	a0,828(a0) # 8000bd38 <_ZN9myConsole8semInputE>
    80006a04:	fffff097          	auipc	ra,0xfffff
    80006a08:	fd8080e7          	jalr	-40(ra) # 800059dc <_ZN11mySemaphore6signalEv>
}
    80006a0c:	00813083          	ld	ra,8(sp)
    80006a10:	00013403          	ld	s0,0(sp)
    80006a14:	01010113          	addi	sp,sp,16
    80006a18:	00008067          	ret
    80006a1c:	00008067          	ret

0000000080006a20 <_ZN9myConsole11getCOutBuffEv>:

int myConsole::getCOutBuff() {
    80006a20:	ff010113          	addi	sp,sp,-16
    80006a24:	00113423          	sd	ra,8(sp)
    80006a28:	00813023          	sd	s0,0(sp)
    80006a2c:	01010413          	addi	s0,sp,16
    semOutput->wait();
    80006a30:	00000593          	li	a1,0
    80006a34:	00005517          	auipc	a0,0x5
    80006a38:	2fc53503          	ld	a0,764(a0) # 8000bd30 <_ZN9myConsole9semOutputE>
    80006a3c:	fffff097          	auipc	ra,0xfffff
    80006a40:	eec080e7          	jalr	-276(ra) # 80005928 <_ZN11mySemaphore4waitEm>
    if (outputHead == outputTail) {
    80006a44:	00005797          	auipc	a5,0x5
    80006a48:	2d47b783          	ld	a5,724(a5) # 8000bd18 <_ZN9myConsole10outputHeadE>
    80006a4c:	00005717          	auipc	a4,0x5
    80006a50:	2c473703          	ld	a4,708(a4) # 8000bd10 <_ZN9myConsole10outputTailE>
    80006a54:	02e78a63          	beq	a5,a4,80006a88 <_ZN9myConsole11getCOutBuffEv+0x68>
        return -1;                  //ERROR code
    }
    char res = outputBuffer[outputHead];
    80006a58:	00005717          	auipc	a4,0x5
    80006a5c:	33870713          	addi	a4,a4,824 # 8000bd90 <_ZN9myConsole12outputBufferE>
    80006a60:	00f70733          	add	a4,a4,a5
    outputHead = (outputHead+1) % BUFFER_SIZE;
    80006a64:	00178793          	addi	a5,a5,1
    80006a68:	3ff7f793          	andi	a5,a5,1023
    80006a6c:	00005697          	auipc	a3,0x5
    80006a70:	2af6b623          	sd	a5,684(a3) # 8000bd18 <_ZN9myConsole10outputHeadE>
    return res;
    80006a74:	00074503          	lbu	a0,0(a4)
}
    80006a78:	00813083          	ld	ra,8(sp)
    80006a7c:	00013403          	ld	s0,0(sp)
    80006a80:	01010113          	addi	sp,sp,16
    80006a84:	00008067          	ret
        return -1;                  //ERROR code
    80006a88:	fff00513          	li	a0,-1
    80006a8c:	fedff06f          	j	80006a78 <_ZN9myConsole11getCOutBuffEv+0x58>

0000000080006a90 <_ZN9myConsole16sendCharacterOutEPv>:


void myConsole::sendCharacterOut(void*) {       //console thread running
    80006a90:	ff010113          	addi	sp,sp,-16
    80006a94:	00113423          	sd	ra,8(sp)
    80006a98:	00813023          	sd	s0,0(sp)
    80006a9c:	01010413          	addi	s0,sp,16
    80006aa0:	0180006f          	j	80006ab8 <_ZN9myConsole16sendCharacterOutEPv+0x28>
    while (1) {
        if (myConsole::stopConsole && numberOfCharToSend == 0 && numberOfCharToGet == 0) {   //outBuff is full and no more character to get AND main thread said to finish
            thread_exit();
    80006aa4:	ffffe097          	auipc	ra,0xffffe
    80006aa8:	458080e7          	jalr	1112(ra) # 80004efc <_Z11thread_exitv>
    80006aac:	0300006f          	j	80006adc <_ZN9myConsole16sendCharacterOutEPv+0x4c>
            char character = putcHelper();
            char* tmp = (char*) CONSOLE_TX_DATA;
            *tmp = character;
            numberOfCharToSend--;
        } else {
            thread_dispatch();
    80006ab0:	ffffe097          	auipc	ra,0xffffe
    80006ab4:	480080e7          	jalr	1152(ra) # 80004f30 <_Z15thread_dispatchv>
        if (myConsole::stopConsole && numberOfCharToSend == 0 && numberOfCharToGet == 0) {   //outBuff is full and no more character to get AND main thread said to finish
    80006ab8:	00005797          	auipc	a5,0x5
    80006abc:	2407c783          	lbu	a5,576(a5) # 8000bcf8 <_ZN9myConsole11stopConsoleE>
    80006ac0:	00078e63          	beqz	a5,80006adc <_ZN9myConsole16sendCharacterOutEPv+0x4c>
    80006ac4:	00005797          	auipc	a5,0x5
    80006ac8:	2447b783          	ld	a5,580(a5) # 8000bd08 <_ZN9myConsole18numberOfCharToSendE>
    80006acc:	00079863          	bnez	a5,80006adc <_ZN9myConsole16sendCharacterOutEPv+0x4c>
    80006ad0:	00005797          	auipc	a5,0x5
    80006ad4:	2307b783          	ld	a5,560(a5) # 8000bd00 <_ZN9myConsole17numberOfCharToGetE>
    80006ad8:	fc0786e3          	beqz	a5,80006aa4 <_ZN9myConsole16sendCharacterOutEPv+0x14>
        char console_status = *((char*) CONSOLE_STATUS);
    80006adc:	00002797          	auipc	a5,0x2
    80006ae0:	5347b783          	ld	a5,1332(a5) # 80009010 <CONSOLE_STATUS>
    80006ae4:	0007c783          	lbu	a5,0(a5)
        if (numberOfCharToSend>0 && (console_status & CONSOLE_TX_STATUS_BIT)) {
    80006ae8:	00005717          	auipc	a4,0x5
    80006aec:	22073703          	ld	a4,544(a4) # 8000bd08 <_ZN9myConsole18numberOfCharToSendE>
    80006af0:	fc0700e3          	beqz	a4,80006ab0 <_ZN9myConsole16sendCharacterOutEPv+0x20>
    80006af4:	0207f793          	andi	a5,a5,32
    80006af8:	fa078ce3          	beqz	a5,80006ab0 <_ZN9myConsole16sendCharacterOutEPv+0x20>
            char character = putcHelper();
    80006afc:	ffffe097          	auipc	ra,0xffffe
    80006b00:	658080e7          	jalr	1624(ra) # 80005154 <_Z10putcHelperv>
            char* tmp = (char*) CONSOLE_TX_DATA;
    80006b04:	00002797          	auipc	a5,0x2
    80006b08:	5047b783          	ld	a5,1284(a5) # 80009008 <CONSOLE_TX_DATA>
            *tmp = character;
    80006b0c:	00a78023          	sb	a0,0(a5)
            numberOfCharToSend--;
    80006b10:	00005717          	auipc	a4,0x5
    80006b14:	1f870713          	addi	a4,a4,504 # 8000bd08 <_ZN9myConsole18numberOfCharToSendE>
    80006b18:	00073783          	ld	a5,0(a4)
    80006b1c:	fff78793          	addi	a5,a5,-1
    80006b20:	00f73023          	sd	a5,0(a4)
    80006b24:	f95ff06f          	j	80006ab8 <_ZN9myConsole16sendCharacterOutEPv+0x28>

0000000080006b28 <_ZN9myConsole11prepareGetCEv>:
        }
    }
}

void myConsole::prepareGetC() {
    80006b28:	fe010113          	addi	sp,sp,-32
    80006b2c:	00113c23          	sd	ra,24(sp)
    80006b30:	00813823          	sd	s0,16(sp)
    80006b34:	00913423          	sd	s1,8(sp)
    80006b38:	02010413          	addi	s0,sp,32
    numberOfCharToGet++;
    80006b3c:	00005717          	auipc	a4,0x5
    80006b40:	1c470713          	addi	a4,a4,452 # 8000bd00 <_ZN9myConsole17numberOfCharToGetE>
    80006b44:	00073783          	ld	a5,0(a4)
    80006b48:	00178793          	addi	a5,a5,1
    80006b4c:	00f73023          	sd	a5,0(a4)
    char res = getCInBuff();
    80006b50:	00000097          	auipc	ra,0x0
    80006b54:	df8080e7          	jalr	-520(ra) # 80006948 <_ZN9myConsole10getCInBuffEv>
    80006b58:	0ff57493          	andi	s1,a0,255

    if (res != 0x01b && res != 13) {               //ESCAPE
    80006b5c:	01b00793          	li	a5,27
    80006b60:	00f48663          	beq	s1,a5,80006b6c <_ZN9myConsole11prepareGetCEv+0x44>
    80006b64:	00d00793          	li	a5,13
    80006b68:	02f49663          	bne	s1,a5,80006b94 <_ZN9myConsole11prepareGetCEv+0x6c>
        putCOutBuff(res);
    }
    if(res==13) {                   //carrige return
    80006b6c:	00d00793          	li	a5,13
    80006b70:	02f48a63          	beq	s1,a5,80006ba4 <_ZN9myConsole11prepareGetCEv+0x7c>
        putCOutBuff(13);
        putCOutBuff(10);        //line feed
    }

    __asm__ volatile("mv a0, %0" : :"r"((uint64)res));
    80006b74:	00048513          	mv	a0,s1

    //save a0 on old context stack
    Riscv::setA0onStack();
    80006b78:	ffffe097          	auipc	ra,0xffffe
    80006b7c:	7d8080e7          	jalr	2008(ra) # 80005350 <_ZN5Riscv12setA0onStackEv>
}
    80006b80:	01813083          	ld	ra,24(sp)
    80006b84:	01013403          	ld	s0,16(sp)
    80006b88:	00813483          	ld	s1,8(sp)
    80006b8c:	02010113          	addi	sp,sp,32
    80006b90:	00008067          	ret
        putCOutBuff(res);
    80006b94:	00048513          	mv	a0,s1
    80006b98:	00000097          	auipc	ra,0x0
    80006b9c:	d34080e7          	jalr	-716(ra) # 800068cc <_ZN9myConsole11putCOutBuffEc>
    80006ba0:	fcdff06f          	j	80006b6c <_ZN9myConsole11prepareGetCEv+0x44>
        putCOutBuff(13);
    80006ba4:	00d00513          	li	a0,13
    80006ba8:	00000097          	auipc	ra,0x0
    80006bac:	d24080e7          	jalr	-732(ra) # 800068cc <_ZN9myConsole11putCOutBuffEc>
        putCOutBuff(10);        //line feed
    80006bb0:	00a00513          	li	a0,10
    80006bb4:	00000097          	auipc	ra,0x0
    80006bb8:	d18080e7          	jalr	-744(ra) # 800068cc <_ZN9myConsole11putCOutBuffEc>
    80006bbc:	fb9ff06f          	j	80006b74 <_ZN9myConsole11prepareGetCEv+0x4c>

0000000080006bc0 <_ZN9myConsole11preparePutCEc>:

void myConsole::preparePutC(char c) {
    80006bc0:	ff010113          	addi	sp,sp,-16
    80006bc4:	00113423          	sd	ra,8(sp)
    80006bc8:	00813023          	sd	s0,0(sp)
    80006bcc:	01010413          	addi	s0,sp,16
    // put char in outputBuffer
    putCOutBuff(c);
    80006bd0:	00000097          	auipc	ra,0x0
    80006bd4:	cfc080e7          	jalr	-772(ra) # 800068cc <_ZN9myConsole11putCOutBuffEc>
}
    80006bd8:	00813083          	ld	ra,8(sp)
    80006bdc:	00013403          	ld	s0,0(sp)
    80006be0:	01010113          	addi	sp,sp,16
    80006be4:	00008067          	ret

0000000080006be8 <_Z13exit_emulatorv>:
#include "../h/MemoryAllocator.hpp"
#include "../h/syscall_c.hpp"
#include "../h/syscall_cpp.hpp"
#include "../test/userMain.hpp"

void exit_emulator() {
    80006be8:	ff010113          	addi	sp,sp,-16
    80006bec:	00813423          	sd	s0,8(sp)
    80006bf0:	01010413          	addi	s0,sp,16
    __asm__ volatile("li a0, 0x5555 \n"
                     "li a0, 0x100000 \n"
                     "sw a0, 0(a1)");
    80006bf4:	00005537          	lui	a0,0x5
    80006bf8:	5555051b          	addiw	a0,a0,1365
    80006bfc:	00100537          	lui	a0,0x100
    80006c00:	00a5a023          	sw	a0,0(a1)
}
    80006c04:	00813403          	ld	s0,8(sp)
    80006c08:	01010113          	addi	sp,sp,16
    80006c0c:	00008067          	ret

0000000080006c10 <_Z14initializationv>:

void initialization() {
    80006c10:	ff010113          	addi	sp,sp,-16
    80006c14:	00113423          	sd	ra,8(sp)
    80006c18:	00813023          	sd	s0,0(sp)
    80006c1c:	01010413          	addi	s0,sp,16
    //set Trap routine
    Riscv::w_stvec((uint64) &Riscv::supervisorTrap);
    80006c20:	ffffa797          	auipc	a5,0xffffa
    80006c24:	40078793          	addi	a5,a5,1024 # 80001020 <_ZN5Riscv14supervisorTrapEv>
    __asm__ volatile ("csrw stvec, %[stvec]" : : [stvec] "r"(stvec));
    80006c28:	10579073          	csrw	stvec,a5
    TCB::initTCB();
    80006c2c:	ffffe097          	auipc	ra,0xffffe
    80006c30:	f40080e7          	jalr	-192(ra) # 80004b6c <_ZN3TCB7initTCBEv>
}
    80006c34:	00813083          	ld	ra,8(sp)
    80006c38:	00013403          	ld	s0,0(sp)
    80006c3c:	01010113          	addi	sp,sp,16
    80006c40:	00008067          	ret

0000000080006c44 <_Z3endv>:

void end() {
    80006c44:	ff010113          	addi	sp,sp,-16
    80006c48:	00113423          	sd	ra,8(sp)
    80006c4c:	00813023          	sd	s0,0(sp)
    80006c50:	01010413          	addi	s0,sp,16
    TCB::endTCB();
    80006c54:	ffffe097          	auipc	ra,0xffffe
    80006c58:	114080e7          	jalr	276(ra) # 80004d68 <_ZN3TCB6endTCBEv>
    __asm__ volatile ("csrc sstatus, %[mask]" : : [mask] "r"(mask));
    80006c5c:	00200793          	li	a5,2
    80006c60:	1007b073          	csrc	sstatus,a5
    //disable interrupts
    Riscv::mc_sstatus(Riscv::SSTATUS_SIE);
}
    80006c64:	00813083          	ld	ra,8(sp)
    80006c68:	00013403          	ld	s0,0(sp)
    80006c6c:	01010113          	addi	sp,sp,16
    80006c70:	00008067          	ret

0000000080006c74 <main>:


int main() {
    80006c74:	ff010113          	addi	sp,sp,-16
    80006c78:	00113423          	sd	ra,8(sp)
    80006c7c:	00813023          	sd	s0,0(sp)
    80006c80:	01010413          	addi	s0,sp,16
    initialization();
    80006c84:	00000097          	auipc	ra,0x0
    80006c88:	f8c080e7          	jalr	-116(ra) # 80006c10 <_Z14initializationv>
    end();
    80006c8c:	00000097          	auipc	ra,0x0
    80006c90:	fb8080e7          	jalr	-72(ra) # 80006c44 <_Z3endv>
    return 0;
}
    80006c94:	00000513          	li	a0,0
    80006c98:	00813083          	ld	ra,8(sp)
    80006c9c:	00013403          	ld	s0,0(sp)
    80006ca0:	01010113          	addi	sp,sp,16
    80006ca4:	00008067          	ret

0000000080006ca8 <start>:
    80006ca8:	ff010113          	addi	sp,sp,-16
    80006cac:	00813423          	sd	s0,8(sp)
    80006cb0:	01010413          	addi	s0,sp,16
    80006cb4:	300027f3          	csrr	a5,mstatus
    80006cb8:	ffffe737          	lui	a4,0xffffe
    80006cbc:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fff100f>
    80006cc0:	00e7f7b3          	and	a5,a5,a4
    80006cc4:	00001737          	lui	a4,0x1
    80006cc8:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80006ccc:	00e7e7b3          	or	a5,a5,a4
    80006cd0:	30079073          	csrw	mstatus,a5
    80006cd4:	00000797          	auipc	a5,0x0
    80006cd8:	16078793          	addi	a5,a5,352 # 80006e34 <system_main>
    80006cdc:	34179073          	csrw	mepc,a5
    80006ce0:	00000793          	li	a5,0
    80006ce4:	18079073          	csrw	satp,a5
    80006ce8:	000107b7          	lui	a5,0x10
    80006cec:	fff78793          	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80006cf0:	30279073          	csrw	medeleg,a5
    80006cf4:	30379073          	csrw	mideleg,a5
    80006cf8:	104027f3          	csrr	a5,sie
    80006cfc:	2227e793          	ori	a5,a5,546
    80006d00:	10479073          	csrw	sie,a5
    80006d04:	fff00793          	li	a5,-1
    80006d08:	00a7d793          	srli	a5,a5,0xa
    80006d0c:	3b079073          	csrw	pmpaddr0,a5
    80006d10:	00f00793          	li	a5,15
    80006d14:	3a079073          	csrw	pmpcfg0,a5
    80006d18:	f14027f3          	csrr	a5,mhartid
    80006d1c:	0200c737          	lui	a4,0x200c
    80006d20:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80006d24:	0007869b          	sext.w	a3,a5
    80006d28:	00269713          	slli	a4,a3,0x2
    80006d2c:	000f4637          	lui	a2,0xf4
    80006d30:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80006d34:	00d70733          	add	a4,a4,a3
    80006d38:	0037979b          	slliw	a5,a5,0x3
    80006d3c:	020046b7          	lui	a3,0x2004
    80006d40:	00d787b3          	add	a5,a5,a3
    80006d44:	00c585b3          	add	a1,a1,a2
    80006d48:	00371693          	slli	a3,a4,0x3
    80006d4c:	00006717          	auipc	a4,0x6
    80006d50:	84470713          	addi	a4,a4,-1980 # 8000c590 <timer_scratch>
    80006d54:	00b7b023          	sd	a1,0(a5)
    80006d58:	00d70733          	add	a4,a4,a3
    80006d5c:	00f73c23          	sd	a5,24(a4)
    80006d60:	02c73023          	sd	a2,32(a4)
    80006d64:	34071073          	csrw	mscratch,a4
    80006d68:	00000797          	auipc	a5,0x0
    80006d6c:	6e878793          	addi	a5,a5,1768 # 80007450 <timervec>
    80006d70:	30579073          	csrw	mtvec,a5
    80006d74:	300027f3          	csrr	a5,mstatus
    80006d78:	0087e793          	ori	a5,a5,8
    80006d7c:	30079073          	csrw	mstatus,a5
    80006d80:	304027f3          	csrr	a5,mie
    80006d84:	0807e793          	ori	a5,a5,128
    80006d88:	30479073          	csrw	mie,a5
    80006d8c:	f14027f3          	csrr	a5,mhartid
    80006d90:	0007879b          	sext.w	a5,a5
    80006d94:	00078213          	mv	tp,a5
    80006d98:	30200073          	mret
    80006d9c:	00813403          	ld	s0,8(sp)
    80006da0:	01010113          	addi	sp,sp,16
    80006da4:	00008067          	ret

0000000080006da8 <timerinit>:
    80006da8:	ff010113          	addi	sp,sp,-16
    80006dac:	00813423          	sd	s0,8(sp)
    80006db0:	01010413          	addi	s0,sp,16
    80006db4:	f14027f3          	csrr	a5,mhartid
    80006db8:	0200c737          	lui	a4,0x200c
    80006dbc:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80006dc0:	0007869b          	sext.w	a3,a5
    80006dc4:	00269713          	slli	a4,a3,0x2
    80006dc8:	000f4637          	lui	a2,0xf4
    80006dcc:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80006dd0:	00d70733          	add	a4,a4,a3
    80006dd4:	0037979b          	slliw	a5,a5,0x3
    80006dd8:	020046b7          	lui	a3,0x2004
    80006ddc:	00d787b3          	add	a5,a5,a3
    80006de0:	00c585b3          	add	a1,a1,a2
    80006de4:	00371693          	slli	a3,a4,0x3
    80006de8:	00005717          	auipc	a4,0x5
    80006dec:	7a870713          	addi	a4,a4,1960 # 8000c590 <timer_scratch>
    80006df0:	00b7b023          	sd	a1,0(a5)
    80006df4:	00d70733          	add	a4,a4,a3
    80006df8:	00f73c23          	sd	a5,24(a4)
    80006dfc:	02c73023          	sd	a2,32(a4)
    80006e00:	34071073          	csrw	mscratch,a4
    80006e04:	00000797          	auipc	a5,0x0
    80006e08:	64c78793          	addi	a5,a5,1612 # 80007450 <timervec>
    80006e0c:	30579073          	csrw	mtvec,a5
    80006e10:	300027f3          	csrr	a5,mstatus
    80006e14:	0087e793          	ori	a5,a5,8
    80006e18:	30079073          	csrw	mstatus,a5
    80006e1c:	304027f3          	csrr	a5,mie
    80006e20:	0807e793          	ori	a5,a5,128
    80006e24:	30479073          	csrw	mie,a5
    80006e28:	00813403          	ld	s0,8(sp)
    80006e2c:	01010113          	addi	sp,sp,16
    80006e30:	00008067          	ret

0000000080006e34 <system_main>:
    80006e34:	fe010113          	addi	sp,sp,-32
    80006e38:	00813823          	sd	s0,16(sp)
    80006e3c:	00913423          	sd	s1,8(sp)
    80006e40:	00113c23          	sd	ra,24(sp)
    80006e44:	02010413          	addi	s0,sp,32
    80006e48:	00000097          	auipc	ra,0x0
    80006e4c:	0c4080e7          	jalr	196(ra) # 80006f0c <cpuid>
    80006e50:	00005497          	auipc	s1,0x5
    80006e54:	ef048493          	addi	s1,s1,-272 # 8000bd40 <started>
    80006e58:	02050263          	beqz	a0,80006e7c <system_main+0x48>
    80006e5c:	0004a783          	lw	a5,0(s1)
    80006e60:	0007879b          	sext.w	a5,a5
    80006e64:	fe078ce3          	beqz	a5,80006e5c <system_main+0x28>
    80006e68:	0ff0000f          	fence
    80006e6c:	00003517          	auipc	a0,0x3
    80006e70:	97c50513          	addi	a0,a0,-1668 # 800097e8 <_ZTV9Semaphore+0x50>
    80006e74:	00001097          	auipc	ra,0x1
    80006e78:	a78080e7          	jalr	-1416(ra) # 800078ec <panic>
    80006e7c:	00001097          	auipc	ra,0x1
    80006e80:	9cc080e7          	jalr	-1588(ra) # 80007848 <consoleinit>
    80006e84:	00001097          	auipc	ra,0x1
    80006e88:	158080e7          	jalr	344(ra) # 80007fdc <printfinit>
    80006e8c:	00002517          	auipc	a0,0x2
    80006e90:	54450513          	addi	a0,a0,1348 # 800093d0 <_ZTV12ConsumerSync+0x278>
    80006e94:	00001097          	auipc	ra,0x1
    80006e98:	ab4080e7          	jalr	-1356(ra) # 80007948 <__printf>
    80006e9c:	00003517          	auipc	a0,0x3
    80006ea0:	91c50513          	addi	a0,a0,-1764 # 800097b8 <_ZTV9Semaphore+0x20>
    80006ea4:	00001097          	auipc	ra,0x1
    80006ea8:	aa4080e7          	jalr	-1372(ra) # 80007948 <__printf>
    80006eac:	00002517          	auipc	a0,0x2
    80006eb0:	52450513          	addi	a0,a0,1316 # 800093d0 <_ZTV12ConsumerSync+0x278>
    80006eb4:	00001097          	auipc	ra,0x1
    80006eb8:	a94080e7          	jalr	-1388(ra) # 80007948 <__printf>
    80006ebc:	00001097          	auipc	ra,0x1
    80006ec0:	4ac080e7          	jalr	1196(ra) # 80008368 <kinit>
    80006ec4:	00000097          	auipc	ra,0x0
    80006ec8:	148080e7          	jalr	328(ra) # 8000700c <trapinit>
    80006ecc:	00000097          	auipc	ra,0x0
    80006ed0:	16c080e7          	jalr	364(ra) # 80007038 <trapinithart>
    80006ed4:	00000097          	auipc	ra,0x0
    80006ed8:	5bc080e7          	jalr	1468(ra) # 80007490 <plicinit>
    80006edc:	00000097          	auipc	ra,0x0
    80006ee0:	5dc080e7          	jalr	1500(ra) # 800074b8 <plicinithart>
    80006ee4:	00000097          	auipc	ra,0x0
    80006ee8:	078080e7          	jalr	120(ra) # 80006f5c <userinit>
    80006eec:	0ff0000f          	fence
    80006ef0:	00100793          	li	a5,1
    80006ef4:	00003517          	auipc	a0,0x3
    80006ef8:	8dc50513          	addi	a0,a0,-1828 # 800097d0 <_ZTV9Semaphore+0x38>
    80006efc:	00f4a023          	sw	a5,0(s1)
    80006f00:	00001097          	auipc	ra,0x1
    80006f04:	a48080e7          	jalr	-1464(ra) # 80007948 <__printf>
    80006f08:	0000006f          	j	80006f08 <system_main+0xd4>

0000000080006f0c <cpuid>:
    80006f0c:	ff010113          	addi	sp,sp,-16
    80006f10:	00813423          	sd	s0,8(sp)
    80006f14:	01010413          	addi	s0,sp,16
    80006f18:	00020513          	mv	a0,tp
    80006f1c:	00813403          	ld	s0,8(sp)
    80006f20:	0005051b          	sext.w	a0,a0
    80006f24:	01010113          	addi	sp,sp,16
    80006f28:	00008067          	ret

0000000080006f2c <mycpu>:
    80006f2c:	ff010113          	addi	sp,sp,-16
    80006f30:	00813423          	sd	s0,8(sp)
    80006f34:	01010413          	addi	s0,sp,16
    80006f38:	00020793          	mv	a5,tp
    80006f3c:	00813403          	ld	s0,8(sp)
    80006f40:	0007879b          	sext.w	a5,a5
    80006f44:	00779793          	slli	a5,a5,0x7
    80006f48:	00006517          	auipc	a0,0x6
    80006f4c:	67850513          	addi	a0,a0,1656 # 8000d5c0 <cpus>
    80006f50:	00f50533          	add	a0,a0,a5
    80006f54:	01010113          	addi	sp,sp,16
    80006f58:	00008067          	ret

0000000080006f5c <userinit>:
    80006f5c:	ff010113          	addi	sp,sp,-16
    80006f60:	00813423          	sd	s0,8(sp)
    80006f64:	01010413          	addi	s0,sp,16
    80006f68:	00813403          	ld	s0,8(sp)
    80006f6c:	01010113          	addi	sp,sp,16
    80006f70:	00000317          	auipc	t1,0x0
    80006f74:	d0430067          	jr	-764(t1) # 80006c74 <main>

0000000080006f78 <either_copyout>:
    80006f78:	ff010113          	addi	sp,sp,-16
    80006f7c:	00813023          	sd	s0,0(sp)
    80006f80:	00113423          	sd	ra,8(sp)
    80006f84:	01010413          	addi	s0,sp,16
    80006f88:	02051663          	bnez	a0,80006fb4 <either_copyout+0x3c>
    80006f8c:	00058513          	mv	a0,a1
    80006f90:	00060593          	mv	a1,a2
    80006f94:	0006861b          	sext.w	a2,a3
    80006f98:	00002097          	auipc	ra,0x2
    80006f9c:	c5c080e7          	jalr	-932(ra) # 80008bf4 <__memmove>
    80006fa0:	00813083          	ld	ra,8(sp)
    80006fa4:	00013403          	ld	s0,0(sp)
    80006fa8:	00000513          	li	a0,0
    80006fac:	01010113          	addi	sp,sp,16
    80006fb0:	00008067          	ret
    80006fb4:	00003517          	auipc	a0,0x3
    80006fb8:	85c50513          	addi	a0,a0,-1956 # 80009810 <_ZTV9Semaphore+0x78>
    80006fbc:	00001097          	auipc	ra,0x1
    80006fc0:	930080e7          	jalr	-1744(ra) # 800078ec <panic>

0000000080006fc4 <either_copyin>:
    80006fc4:	ff010113          	addi	sp,sp,-16
    80006fc8:	00813023          	sd	s0,0(sp)
    80006fcc:	00113423          	sd	ra,8(sp)
    80006fd0:	01010413          	addi	s0,sp,16
    80006fd4:	02059463          	bnez	a1,80006ffc <either_copyin+0x38>
    80006fd8:	00060593          	mv	a1,a2
    80006fdc:	0006861b          	sext.w	a2,a3
    80006fe0:	00002097          	auipc	ra,0x2
    80006fe4:	c14080e7          	jalr	-1004(ra) # 80008bf4 <__memmove>
    80006fe8:	00813083          	ld	ra,8(sp)
    80006fec:	00013403          	ld	s0,0(sp)
    80006ff0:	00000513          	li	a0,0
    80006ff4:	01010113          	addi	sp,sp,16
    80006ff8:	00008067          	ret
    80006ffc:	00003517          	auipc	a0,0x3
    80007000:	83c50513          	addi	a0,a0,-1988 # 80009838 <_ZTV9Semaphore+0xa0>
    80007004:	00001097          	auipc	ra,0x1
    80007008:	8e8080e7          	jalr	-1816(ra) # 800078ec <panic>

000000008000700c <trapinit>:
    8000700c:	ff010113          	addi	sp,sp,-16
    80007010:	00813423          	sd	s0,8(sp)
    80007014:	01010413          	addi	s0,sp,16
    80007018:	00813403          	ld	s0,8(sp)
    8000701c:	00003597          	auipc	a1,0x3
    80007020:	84458593          	addi	a1,a1,-1980 # 80009860 <_ZTV9Semaphore+0xc8>
    80007024:	00006517          	auipc	a0,0x6
    80007028:	61c50513          	addi	a0,a0,1564 # 8000d640 <tickslock>
    8000702c:	01010113          	addi	sp,sp,16
    80007030:	00001317          	auipc	t1,0x1
    80007034:	5c830067          	jr	1480(t1) # 800085f8 <initlock>

0000000080007038 <trapinithart>:
    80007038:	ff010113          	addi	sp,sp,-16
    8000703c:	00813423          	sd	s0,8(sp)
    80007040:	01010413          	addi	s0,sp,16
    80007044:	00000797          	auipc	a5,0x0
    80007048:	2fc78793          	addi	a5,a5,764 # 80007340 <kernelvec>
    8000704c:	10579073          	csrw	stvec,a5
    80007050:	00813403          	ld	s0,8(sp)
    80007054:	01010113          	addi	sp,sp,16
    80007058:	00008067          	ret

000000008000705c <usertrap>:
    8000705c:	ff010113          	addi	sp,sp,-16
    80007060:	00813423          	sd	s0,8(sp)
    80007064:	01010413          	addi	s0,sp,16
    80007068:	00813403          	ld	s0,8(sp)
    8000706c:	01010113          	addi	sp,sp,16
    80007070:	00008067          	ret

0000000080007074 <usertrapret>:
    80007074:	ff010113          	addi	sp,sp,-16
    80007078:	00813423          	sd	s0,8(sp)
    8000707c:	01010413          	addi	s0,sp,16
    80007080:	00813403          	ld	s0,8(sp)
    80007084:	01010113          	addi	sp,sp,16
    80007088:	00008067          	ret

000000008000708c <kerneltrap>:
    8000708c:	fe010113          	addi	sp,sp,-32
    80007090:	00813823          	sd	s0,16(sp)
    80007094:	00113c23          	sd	ra,24(sp)
    80007098:	00913423          	sd	s1,8(sp)
    8000709c:	02010413          	addi	s0,sp,32
    800070a0:	142025f3          	csrr	a1,scause
    800070a4:	100027f3          	csrr	a5,sstatus
    800070a8:	0027f793          	andi	a5,a5,2
    800070ac:	10079c63          	bnez	a5,800071c4 <kerneltrap+0x138>
    800070b0:	142027f3          	csrr	a5,scause
    800070b4:	0207ce63          	bltz	a5,800070f0 <kerneltrap+0x64>
    800070b8:	00002517          	auipc	a0,0x2
    800070bc:	7f050513          	addi	a0,a0,2032 # 800098a8 <_ZTV9Semaphore+0x110>
    800070c0:	00001097          	auipc	ra,0x1
    800070c4:	888080e7          	jalr	-1912(ra) # 80007948 <__printf>
    800070c8:	141025f3          	csrr	a1,sepc
    800070cc:	14302673          	csrr	a2,stval
    800070d0:	00002517          	auipc	a0,0x2
    800070d4:	7e850513          	addi	a0,a0,2024 # 800098b8 <_ZTV9Semaphore+0x120>
    800070d8:	00001097          	auipc	ra,0x1
    800070dc:	870080e7          	jalr	-1936(ra) # 80007948 <__printf>
    800070e0:	00002517          	auipc	a0,0x2
    800070e4:	7f050513          	addi	a0,a0,2032 # 800098d0 <_ZTV9Semaphore+0x138>
    800070e8:	00001097          	auipc	ra,0x1
    800070ec:	804080e7          	jalr	-2044(ra) # 800078ec <panic>
    800070f0:	0ff7f713          	andi	a4,a5,255
    800070f4:	00900693          	li	a3,9
    800070f8:	04d70063          	beq	a4,a3,80007138 <kerneltrap+0xac>
    800070fc:	fff00713          	li	a4,-1
    80007100:	03f71713          	slli	a4,a4,0x3f
    80007104:	00170713          	addi	a4,a4,1
    80007108:	fae798e3          	bne	a5,a4,800070b8 <kerneltrap+0x2c>
    8000710c:	00000097          	auipc	ra,0x0
    80007110:	e00080e7          	jalr	-512(ra) # 80006f0c <cpuid>
    80007114:	06050663          	beqz	a0,80007180 <kerneltrap+0xf4>
    80007118:	144027f3          	csrr	a5,sip
    8000711c:	ffd7f793          	andi	a5,a5,-3
    80007120:	14479073          	csrw	sip,a5
    80007124:	01813083          	ld	ra,24(sp)
    80007128:	01013403          	ld	s0,16(sp)
    8000712c:	00813483          	ld	s1,8(sp)
    80007130:	02010113          	addi	sp,sp,32
    80007134:	00008067          	ret
    80007138:	00000097          	auipc	ra,0x0
    8000713c:	3cc080e7          	jalr	972(ra) # 80007504 <plic_claim>
    80007140:	00a00793          	li	a5,10
    80007144:	00050493          	mv	s1,a0
    80007148:	06f50863          	beq	a0,a5,800071b8 <kerneltrap+0x12c>
    8000714c:	fc050ce3          	beqz	a0,80007124 <kerneltrap+0x98>
    80007150:	00050593          	mv	a1,a0
    80007154:	00002517          	auipc	a0,0x2
    80007158:	73450513          	addi	a0,a0,1844 # 80009888 <_ZTV9Semaphore+0xf0>
    8000715c:	00000097          	auipc	ra,0x0
    80007160:	7ec080e7          	jalr	2028(ra) # 80007948 <__printf>
    80007164:	01013403          	ld	s0,16(sp)
    80007168:	01813083          	ld	ra,24(sp)
    8000716c:	00048513          	mv	a0,s1
    80007170:	00813483          	ld	s1,8(sp)
    80007174:	02010113          	addi	sp,sp,32
    80007178:	00000317          	auipc	t1,0x0
    8000717c:	3c430067          	jr	964(t1) # 8000753c <plic_complete>
    80007180:	00006517          	auipc	a0,0x6
    80007184:	4c050513          	addi	a0,a0,1216 # 8000d640 <tickslock>
    80007188:	00001097          	auipc	ra,0x1
    8000718c:	494080e7          	jalr	1172(ra) # 8000861c <acquire>
    80007190:	00005717          	auipc	a4,0x5
    80007194:	bb470713          	addi	a4,a4,-1100 # 8000bd44 <ticks>
    80007198:	00072783          	lw	a5,0(a4)
    8000719c:	00006517          	auipc	a0,0x6
    800071a0:	4a450513          	addi	a0,a0,1188 # 8000d640 <tickslock>
    800071a4:	0017879b          	addiw	a5,a5,1
    800071a8:	00f72023          	sw	a5,0(a4)
    800071ac:	00001097          	auipc	ra,0x1
    800071b0:	53c080e7          	jalr	1340(ra) # 800086e8 <release>
    800071b4:	f65ff06f          	j	80007118 <kerneltrap+0x8c>
    800071b8:	00001097          	auipc	ra,0x1
    800071bc:	098080e7          	jalr	152(ra) # 80008250 <uartintr>
    800071c0:	fa5ff06f          	j	80007164 <kerneltrap+0xd8>
    800071c4:	00002517          	auipc	a0,0x2
    800071c8:	6a450513          	addi	a0,a0,1700 # 80009868 <_ZTV9Semaphore+0xd0>
    800071cc:	00000097          	auipc	ra,0x0
    800071d0:	720080e7          	jalr	1824(ra) # 800078ec <panic>

00000000800071d4 <clockintr>:
    800071d4:	fe010113          	addi	sp,sp,-32
    800071d8:	00813823          	sd	s0,16(sp)
    800071dc:	00913423          	sd	s1,8(sp)
    800071e0:	00113c23          	sd	ra,24(sp)
    800071e4:	02010413          	addi	s0,sp,32
    800071e8:	00006497          	auipc	s1,0x6
    800071ec:	45848493          	addi	s1,s1,1112 # 8000d640 <tickslock>
    800071f0:	00048513          	mv	a0,s1
    800071f4:	00001097          	auipc	ra,0x1
    800071f8:	428080e7          	jalr	1064(ra) # 8000861c <acquire>
    800071fc:	00005717          	auipc	a4,0x5
    80007200:	b4870713          	addi	a4,a4,-1208 # 8000bd44 <ticks>
    80007204:	00072783          	lw	a5,0(a4)
    80007208:	01013403          	ld	s0,16(sp)
    8000720c:	01813083          	ld	ra,24(sp)
    80007210:	00048513          	mv	a0,s1
    80007214:	0017879b          	addiw	a5,a5,1
    80007218:	00813483          	ld	s1,8(sp)
    8000721c:	00f72023          	sw	a5,0(a4)
    80007220:	02010113          	addi	sp,sp,32
    80007224:	00001317          	auipc	t1,0x1
    80007228:	4c430067          	jr	1220(t1) # 800086e8 <release>

000000008000722c <devintr>:
    8000722c:	142027f3          	csrr	a5,scause
    80007230:	00000513          	li	a0,0
    80007234:	0007c463          	bltz	a5,8000723c <devintr+0x10>
    80007238:	00008067          	ret
    8000723c:	fe010113          	addi	sp,sp,-32
    80007240:	00813823          	sd	s0,16(sp)
    80007244:	00113c23          	sd	ra,24(sp)
    80007248:	00913423          	sd	s1,8(sp)
    8000724c:	02010413          	addi	s0,sp,32
    80007250:	0ff7f713          	andi	a4,a5,255
    80007254:	00900693          	li	a3,9
    80007258:	04d70c63          	beq	a4,a3,800072b0 <devintr+0x84>
    8000725c:	fff00713          	li	a4,-1
    80007260:	03f71713          	slli	a4,a4,0x3f
    80007264:	00170713          	addi	a4,a4,1
    80007268:	00e78c63          	beq	a5,a4,80007280 <devintr+0x54>
    8000726c:	01813083          	ld	ra,24(sp)
    80007270:	01013403          	ld	s0,16(sp)
    80007274:	00813483          	ld	s1,8(sp)
    80007278:	02010113          	addi	sp,sp,32
    8000727c:	00008067          	ret
    80007280:	00000097          	auipc	ra,0x0
    80007284:	c8c080e7          	jalr	-884(ra) # 80006f0c <cpuid>
    80007288:	06050663          	beqz	a0,800072f4 <devintr+0xc8>
    8000728c:	144027f3          	csrr	a5,sip
    80007290:	ffd7f793          	andi	a5,a5,-3
    80007294:	14479073          	csrw	sip,a5
    80007298:	01813083          	ld	ra,24(sp)
    8000729c:	01013403          	ld	s0,16(sp)
    800072a0:	00813483          	ld	s1,8(sp)
    800072a4:	00200513          	li	a0,2
    800072a8:	02010113          	addi	sp,sp,32
    800072ac:	00008067          	ret
    800072b0:	00000097          	auipc	ra,0x0
    800072b4:	254080e7          	jalr	596(ra) # 80007504 <plic_claim>
    800072b8:	00a00793          	li	a5,10
    800072bc:	00050493          	mv	s1,a0
    800072c0:	06f50663          	beq	a0,a5,8000732c <devintr+0x100>
    800072c4:	00100513          	li	a0,1
    800072c8:	fa0482e3          	beqz	s1,8000726c <devintr+0x40>
    800072cc:	00048593          	mv	a1,s1
    800072d0:	00002517          	auipc	a0,0x2
    800072d4:	5b850513          	addi	a0,a0,1464 # 80009888 <_ZTV9Semaphore+0xf0>
    800072d8:	00000097          	auipc	ra,0x0
    800072dc:	670080e7          	jalr	1648(ra) # 80007948 <__printf>
    800072e0:	00048513          	mv	a0,s1
    800072e4:	00000097          	auipc	ra,0x0
    800072e8:	258080e7          	jalr	600(ra) # 8000753c <plic_complete>
    800072ec:	00100513          	li	a0,1
    800072f0:	f7dff06f          	j	8000726c <devintr+0x40>
    800072f4:	00006517          	auipc	a0,0x6
    800072f8:	34c50513          	addi	a0,a0,844 # 8000d640 <tickslock>
    800072fc:	00001097          	auipc	ra,0x1
    80007300:	320080e7          	jalr	800(ra) # 8000861c <acquire>
    80007304:	00005717          	auipc	a4,0x5
    80007308:	a4070713          	addi	a4,a4,-1472 # 8000bd44 <ticks>
    8000730c:	00072783          	lw	a5,0(a4)
    80007310:	00006517          	auipc	a0,0x6
    80007314:	33050513          	addi	a0,a0,816 # 8000d640 <tickslock>
    80007318:	0017879b          	addiw	a5,a5,1
    8000731c:	00f72023          	sw	a5,0(a4)
    80007320:	00001097          	auipc	ra,0x1
    80007324:	3c8080e7          	jalr	968(ra) # 800086e8 <release>
    80007328:	f65ff06f          	j	8000728c <devintr+0x60>
    8000732c:	00001097          	auipc	ra,0x1
    80007330:	f24080e7          	jalr	-220(ra) # 80008250 <uartintr>
    80007334:	fadff06f          	j	800072e0 <devintr+0xb4>
	...

0000000080007340 <kernelvec>:
    80007340:	f0010113          	addi	sp,sp,-256
    80007344:	00113023          	sd	ra,0(sp)
    80007348:	00213423          	sd	sp,8(sp)
    8000734c:	00313823          	sd	gp,16(sp)
    80007350:	00413c23          	sd	tp,24(sp)
    80007354:	02513023          	sd	t0,32(sp)
    80007358:	02613423          	sd	t1,40(sp)
    8000735c:	02713823          	sd	t2,48(sp)
    80007360:	02813c23          	sd	s0,56(sp)
    80007364:	04913023          	sd	s1,64(sp)
    80007368:	04a13423          	sd	a0,72(sp)
    8000736c:	04b13823          	sd	a1,80(sp)
    80007370:	04c13c23          	sd	a2,88(sp)
    80007374:	06d13023          	sd	a3,96(sp)
    80007378:	06e13423          	sd	a4,104(sp)
    8000737c:	06f13823          	sd	a5,112(sp)
    80007380:	07013c23          	sd	a6,120(sp)
    80007384:	09113023          	sd	a7,128(sp)
    80007388:	09213423          	sd	s2,136(sp)
    8000738c:	09313823          	sd	s3,144(sp)
    80007390:	09413c23          	sd	s4,152(sp)
    80007394:	0b513023          	sd	s5,160(sp)
    80007398:	0b613423          	sd	s6,168(sp)
    8000739c:	0b713823          	sd	s7,176(sp)
    800073a0:	0b813c23          	sd	s8,184(sp)
    800073a4:	0d913023          	sd	s9,192(sp)
    800073a8:	0da13423          	sd	s10,200(sp)
    800073ac:	0db13823          	sd	s11,208(sp)
    800073b0:	0dc13c23          	sd	t3,216(sp)
    800073b4:	0fd13023          	sd	t4,224(sp)
    800073b8:	0fe13423          	sd	t5,232(sp)
    800073bc:	0ff13823          	sd	t6,240(sp)
    800073c0:	ccdff0ef          	jal	ra,8000708c <kerneltrap>
    800073c4:	00013083          	ld	ra,0(sp)
    800073c8:	00813103          	ld	sp,8(sp)
    800073cc:	01013183          	ld	gp,16(sp)
    800073d0:	02013283          	ld	t0,32(sp)
    800073d4:	02813303          	ld	t1,40(sp)
    800073d8:	03013383          	ld	t2,48(sp)
    800073dc:	03813403          	ld	s0,56(sp)
    800073e0:	04013483          	ld	s1,64(sp)
    800073e4:	04813503          	ld	a0,72(sp)
    800073e8:	05013583          	ld	a1,80(sp)
    800073ec:	05813603          	ld	a2,88(sp)
    800073f0:	06013683          	ld	a3,96(sp)
    800073f4:	06813703          	ld	a4,104(sp)
    800073f8:	07013783          	ld	a5,112(sp)
    800073fc:	07813803          	ld	a6,120(sp)
    80007400:	08013883          	ld	a7,128(sp)
    80007404:	08813903          	ld	s2,136(sp)
    80007408:	09013983          	ld	s3,144(sp)
    8000740c:	09813a03          	ld	s4,152(sp)
    80007410:	0a013a83          	ld	s5,160(sp)
    80007414:	0a813b03          	ld	s6,168(sp)
    80007418:	0b013b83          	ld	s7,176(sp)
    8000741c:	0b813c03          	ld	s8,184(sp)
    80007420:	0c013c83          	ld	s9,192(sp)
    80007424:	0c813d03          	ld	s10,200(sp)
    80007428:	0d013d83          	ld	s11,208(sp)
    8000742c:	0d813e03          	ld	t3,216(sp)
    80007430:	0e013e83          	ld	t4,224(sp)
    80007434:	0e813f03          	ld	t5,232(sp)
    80007438:	0f013f83          	ld	t6,240(sp)
    8000743c:	10010113          	addi	sp,sp,256
    80007440:	10200073          	sret
    80007444:	00000013          	nop
    80007448:	00000013          	nop
    8000744c:	00000013          	nop

0000000080007450 <timervec>:
    80007450:	34051573          	csrrw	a0,mscratch,a0
    80007454:	00b53023          	sd	a1,0(a0)
    80007458:	00c53423          	sd	a2,8(a0)
    8000745c:	00d53823          	sd	a3,16(a0)
    80007460:	01853583          	ld	a1,24(a0)
    80007464:	02053603          	ld	a2,32(a0)
    80007468:	0005b683          	ld	a3,0(a1)
    8000746c:	00c686b3          	add	a3,a3,a2
    80007470:	00d5b023          	sd	a3,0(a1)
    80007474:	00200593          	li	a1,2
    80007478:	14459073          	csrw	sip,a1
    8000747c:	01053683          	ld	a3,16(a0)
    80007480:	00853603          	ld	a2,8(a0)
    80007484:	00053583          	ld	a1,0(a0)
    80007488:	34051573          	csrrw	a0,mscratch,a0
    8000748c:	30200073          	mret

0000000080007490 <plicinit>:
    80007490:	ff010113          	addi	sp,sp,-16
    80007494:	00813423          	sd	s0,8(sp)
    80007498:	01010413          	addi	s0,sp,16
    8000749c:	00813403          	ld	s0,8(sp)
    800074a0:	0c0007b7          	lui	a5,0xc000
    800074a4:	00100713          	li	a4,1
    800074a8:	02e7a423          	sw	a4,40(a5) # c000028 <_entry-0x73ffffd8>
    800074ac:	00e7a223          	sw	a4,4(a5)
    800074b0:	01010113          	addi	sp,sp,16
    800074b4:	00008067          	ret

00000000800074b8 <plicinithart>:
    800074b8:	ff010113          	addi	sp,sp,-16
    800074bc:	00813023          	sd	s0,0(sp)
    800074c0:	00113423          	sd	ra,8(sp)
    800074c4:	01010413          	addi	s0,sp,16
    800074c8:	00000097          	auipc	ra,0x0
    800074cc:	a44080e7          	jalr	-1468(ra) # 80006f0c <cpuid>
    800074d0:	0085171b          	slliw	a4,a0,0x8
    800074d4:	0c0027b7          	lui	a5,0xc002
    800074d8:	00e787b3          	add	a5,a5,a4
    800074dc:	40200713          	li	a4,1026
    800074e0:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>
    800074e4:	00813083          	ld	ra,8(sp)
    800074e8:	00013403          	ld	s0,0(sp)
    800074ec:	00d5151b          	slliw	a0,a0,0xd
    800074f0:	0c2017b7          	lui	a5,0xc201
    800074f4:	00a78533          	add	a0,a5,a0
    800074f8:	00052023          	sw	zero,0(a0)
    800074fc:	01010113          	addi	sp,sp,16
    80007500:	00008067          	ret

0000000080007504 <plic_claim>:
    80007504:	ff010113          	addi	sp,sp,-16
    80007508:	00813023          	sd	s0,0(sp)
    8000750c:	00113423          	sd	ra,8(sp)
    80007510:	01010413          	addi	s0,sp,16
    80007514:	00000097          	auipc	ra,0x0
    80007518:	9f8080e7          	jalr	-1544(ra) # 80006f0c <cpuid>
    8000751c:	00813083          	ld	ra,8(sp)
    80007520:	00013403          	ld	s0,0(sp)
    80007524:	00d5151b          	slliw	a0,a0,0xd
    80007528:	0c2017b7          	lui	a5,0xc201
    8000752c:	00a78533          	add	a0,a5,a0
    80007530:	00452503          	lw	a0,4(a0)
    80007534:	01010113          	addi	sp,sp,16
    80007538:	00008067          	ret

000000008000753c <plic_complete>:
    8000753c:	fe010113          	addi	sp,sp,-32
    80007540:	00813823          	sd	s0,16(sp)
    80007544:	00913423          	sd	s1,8(sp)
    80007548:	00113c23          	sd	ra,24(sp)
    8000754c:	02010413          	addi	s0,sp,32
    80007550:	00050493          	mv	s1,a0
    80007554:	00000097          	auipc	ra,0x0
    80007558:	9b8080e7          	jalr	-1608(ra) # 80006f0c <cpuid>
    8000755c:	01813083          	ld	ra,24(sp)
    80007560:	01013403          	ld	s0,16(sp)
    80007564:	00d5179b          	slliw	a5,a0,0xd
    80007568:	0c201737          	lui	a4,0xc201
    8000756c:	00f707b3          	add	a5,a4,a5
    80007570:	0097a223          	sw	s1,4(a5) # c201004 <_entry-0x73dfeffc>
    80007574:	00813483          	ld	s1,8(sp)
    80007578:	02010113          	addi	sp,sp,32
    8000757c:	00008067          	ret

0000000080007580 <consolewrite>:
    80007580:	fb010113          	addi	sp,sp,-80
    80007584:	04813023          	sd	s0,64(sp)
    80007588:	04113423          	sd	ra,72(sp)
    8000758c:	02913c23          	sd	s1,56(sp)
    80007590:	03213823          	sd	s2,48(sp)
    80007594:	03313423          	sd	s3,40(sp)
    80007598:	03413023          	sd	s4,32(sp)
    8000759c:	01513c23          	sd	s5,24(sp)
    800075a0:	05010413          	addi	s0,sp,80
    800075a4:	06c05c63          	blez	a2,8000761c <consolewrite+0x9c>
    800075a8:	00060993          	mv	s3,a2
    800075ac:	00050a13          	mv	s4,a0
    800075b0:	00058493          	mv	s1,a1
    800075b4:	00000913          	li	s2,0
    800075b8:	fff00a93          	li	s5,-1
    800075bc:	01c0006f          	j	800075d8 <consolewrite+0x58>
    800075c0:	fbf44503          	lbu	a0,-65(s0)
    800075c4:	0019091b          	addiw	s2,s2,1
    800075c8:	00148493          	addi	s1,s1,1
    800075cc:	00001097          	auipc	ra,0x1
    800075d0:	a9c080e7          	jalr	-1380(ra) # 80008068 <uartputc>
    800075d4:	03298063          	beq	s3,s2,800075f4 <consolewrite+0x74>
    800075d8:	00048613          	mv	a2,s1
    800075dc:	00100693          	li	a3,1
    800075e0:	000a0593          	mv	a1,s4
    800075e4:	fbf40513          	addi	a0,s0,-65
    800075e8:	00000097          	auipc	ra,0x0
    800075ec:	9dc080e7          	jalr	-1572(ra) # 80006fc4 <either_copyin>
    800075f0:	fd5518e3          	bne	a0,s5,800075c0 <consolewrite+0x40>
    800075f4:	04813083          	ld	ra,72(sp)
    800075f8:	04013403          	ld	s0,64(sp)
    800075fc:	03813483          	ld	s1,56(sp)
    80007600:	02813983          	ld	s3,40(sp)
    80007604:	02013a03          	ld	s4,32(sp)
    80007608:	01813a83          	ld	s5,24(sp)
    8000760c:	00090513          	mv	a0,s2
    80007610:	03013903          	ld	s2,48(sp)
    80007614:	05010113          	addi	sp,sp,80
    80007618:	00008067          	ret
    8000761c:	00000913          	li	s2,0
    80007620:	fd5ff06f          	j	800075f4 <consolewrite+0x74>

0000000080007624 <consoleread>:
    80007624:	f9010113          	addi	sp,sp,-112
    80007628:	06813023          	sd	s0,96(sp)
    8000762c:	04913c23          	sd	s1,88(sp)
    80007630:	05213823          	sd	s2,80(sp)
    80007634:	05313423          	sd	s3,72(sp)
    80007638:	05413023          	sd	s4,64(sp)
    8000763c:	03513c23          	sd	s5,56(sp)
    80007640:	03613823          	sd	s6,48(sp)
    80007644:	03713423          	sd	s7,40(sp)
    80007648:	03813023          	sd	s8,32(sp)
    8000764c:	06113423          	sd	ra,104(sp)
    80007650:	01913c23          	sd	s9,24(sp)
    80007654:	07010413          	addi	s0,sp,112
    80007658:	00060b93          	mv	s7,a2
    8000765c:	00050913          	mv	s2,a0
    80007660:	00058c13          	mv	s8,a1
    80007664:	00060b1b          	sext.w	s6,a2
    80007668:	00006497          	auipc	s1,0x6
    8000766c:	00048493          	mv	s1,s1
    80007670:	00400993          	li	s3,4
    80007674:	fff00a13          	li	s4,-1
    80007678:	00a00a93          	li	s5,10
    8000767c:	05705e63          	blez	s7,800076d8 <consoleread+0xb4>
    80007680:	09c4a703          	lw	a4,156(s1) # 8000d704 <cons+0x9c>
    80007684:	0984a783          	lw	a5,152(s1)
    80007688:	0007071b          	sext.w	a4,a4
    8000768c:	08e78463          	beq	a5,a4,80007714 <consoleread+0xf0>
    80007690:	07f7f713          	andi	a4,a5,127
    80007694:	00e48733          	add	a4,s1,a4
    80007698:	01874703          	lbu	a4,24(a4) # c201018 <_entry-0x73dfefe8>
    8000769c:	0017869b          	addiw	a3,a5,1
    800076a0:	08d4ac23          	sw	a3,152(s1)
    800076a4:	00070c9b          	sext.w	s9,a4
    800076a8:	0b370663          	beq	a4,s3,80007754 <consoleread+0x130>
    800076ac:	00100693          	li	a3,1
    800076b0:	f9f40613          	addi	a2,s0,-97
    800076b4:	000c0593          	mv	a1,s8
    800076b8:	00090513          	mv	a0,s2
    800076bc:	f8e40fa3          	sb	a4,-97(s0)
    800076c0:	00000097          	auipc	ra,0x0
    800076c4:	8b8080e7          	jalr	-1864(ra) # 80006f78 <either_copyout>
    800076c8:	01450863          	beq	a0,s4,800076d8 <consoleread+0xb4>
    800076cc:	001c0c13          	addi	s8,s8,1
    800076d0:	fffb8b9b          	addiw	s7,s7,-1
    800076d4:	fb5c94e3          	bne	s9,s5,8000767c <consoleread+0x58>
    800076d8:	000b851b          	sext.w	a0,s7
    800076dc:	06813083          	ld	ra,104(sp)
    800076e0:	06013403          	ld	s0,96(sp)
    800076e4:	05813483          	ld	s1,88(sp)
    800076e8:	05013903          	ld	s2,80(sp)
    800076ec:	04813983          	ld	s3,72(sp)
    800076f0:	04013a03          	ld	s4,64(sp)
    800076f4:	03813a83          	ld	s5,56(sp)
    800076f8:	02813b83          	ld	s7,40(sp)
    800076fc:	02013c03          	ld	s8,32(sp)
    80007700:	01813c83          	ld	s9,24(sp)
    80007704:	40ab053b          	subw	a0,s6,a0
    80007708:	03013b03          	ld	s6,48(sp)
    8000770c:	07010113          	addi	sp,sp,112
    80007710:	00008067          	ret
    80007714:	00001097          	auipc	ra,0x1
    80007718:	1d8080e7          	jalr	472(ra) # 800088ec <push_on>
    8000771c:	0984a703          	lw	a4,152(s1)
    80007720:	09c4a783          	lw	a5,156(s1)
    80007724:	0007879b          	sext.w	a5,a5
    80007728:	fef70ce3          	beq	a4,a5,80007720 <consoleread+0xfc>
    8000772c:	00001097          	auipc	ra,0x1
    80007730:	234080e7          	jalr	564(ra) # 80008960 <pop_on>
    80007734:	0984a783          	lw	a5,152(s1)
    80007738:	07f7f713          	andi	a4,a5,127
    8000773c:	00e48733          	add	a4,s1,a4
    80007740:	01874703          	lbu	a4,24(a4)
    80007744:	0017869b          	addiw	a3,a5,1
    80007748:	08d4ac23          	sw	a3,152(s1)
    8000774c:	00070c9b          	sext.w	s9,a4
    80007750:	f5371ee3          	bne	a4,s3,800076ac <consoleread+0x88>
    80007754:	000b851b          	sext.w	a0,s7
    80007758:	f96bf2e3          	bgeu	s7,s6,800076dc <consoleread+0xb8>
    8000775c:	08f4ac23          	sw	a5,152(s1)
    80007760:	f7dff06f          	j	800076dc <consoleread+0xb8>

0000000080007764 <consputc>:
    80007764:	10000793          	li	a5,256
    80007768:	00f50663          	beq	a0,a5,80007774 <consputc+0x10>
    8000776c:	00001317          	auipc	t1,0x1
    80007770:	9f430067          	jr	-1548(t1) # 80008160 <uartputc_sync>
    80007774:	ff010113          	addi	sp,sp,-16
    80007778:	00113423          	sd	ra,8(sp)
    8000777c:	00813023          	sd	s0,0(sp)
    80007780:	01010413          	addi	s0,sp,16
    80007784:	00800513          	li	a0,8
    80007788:	00001097          	auipc	ra,0x1
    8000778c:	9d8080e7          	jalr	-1576(ra) # 80008160 <uartputc_sync>
    80007790:	02000513          	li	a0,32
    80007794:	00001097          	auipc	ra,0x1
    80007798:	9cc080e7          	jalr	-1588(ra) # 80008160 <uartputc_sync>
    8000779c:	00013403          	ld	s0,0(sp)
    800077a0:	00813083          	ld	ra,8(sp)
    800077a4:	00800513          	li	a0,8
    800077a8:	01010113          	addi	sp,sp,16
    800077ac:	00001317          	auipc	t1,0x1
    800077b0:	9b430067          	jr	-1612(t1) # 80008160 <uartputc_sync>

00000000800077b4 <consoleintr>:
    800077b4:	fe010113          	addi	sp,sp,-32
    800077b8:	00813823          	sd	s0,16(sp)
    800077bc:	00913423          	sd	s1,8(sp)
    800077c0:	01213023          	sd	s2,0(sp)
    800077c4:	00113c23          	sd	ra,24(sp)
    800077c8:	02010413          	addi	s0,sp,32
    800077cc:	00006917          	auipc	s2,0x6
    800077d0:	e9c90913          	addi	s2,s2,-356 # 8000d668 <cons>
    800077d4:	00050493          	mv	s1,a0
    800077d8:	00090513          	mv	a0,s2
    800077dc:	00001097          	auipc	ra,0x1
    800077e0:	e40080e7          	jalr	-448(ra) # 8000861c <acquire>
    800077e4:	02048c63          	beqz	s1,8000781c <consoleintr+0x68>
    800077e8:	0a092783          	lw	a5,160(s2)
    800077ec:	09892703          	lw	a4,152(s2)
    800077f0:	07f00693          	li	a3,127
    800077f4:	40e7873b          	subw	a4,a5,a4
    800077f8:	02e6e263          	bltu	a3,a4,8000781c <consoleintr+0x68>
    800077fc:	00d00713          	li	a4,13
    80007800:	04e48063          	beq	s1,a4,80007840 <consoleintr+0x8c>
    80007804:	07f7f713          	andi	a4,a5,127
    80007808:	00e90733          	add	a4,s2,a4
    8000780c:	0017879b          	addiw	a5,a5,1
    80007810:	0af92023          	sw	a5,160(s2)
    80007814:	00970c23          	sb	s1,24(a4)
    80007818:	08f92e23          	sw	a5,156(s2)
    8000781c:	01013403          	ld	s0,16(sp)
    80007820:	01813083          	ld	ra,24(sp)
    80007824:	00813483          	ld	s1,8(sp)
    80007828:	00013903          	ld	s2,0(sp)
    8000782c:	00006517          	auipc	a0,0x6
    80007830:	e3c50513          	addi	a0,a0,-452 # 8000d668 <cons>
    80007834:	02010113          	addi	sp,sp,32
    80007838:	00001317          	auipc	t1,0x1
    8000783c:	eb030067          	jr	-336(t1) # 800086e8 <release>
    80007840:	00a00493          	li	s1,10
    80007844:	fc1ff06f          	j	80007804 <consoleintr+0x50>

0000000080007848 <consoleinit>:
    80007848:	fe010113          	addi	sp,sp,-32
    8000784c:	00113c23          	sd	ra,24(sp)
    80007850:	00813823          	sd	s0,16(sp)
    80007854:	00913423          	sd	s1,8(sp)
    80007858:	02010413          	addi	s0,sp,32
    8000785c:	00006497          	auipc	s1,0x6
    80007860:	e0c48493          	addi	s1,s1,-500 # 8000d668 <cons>
    80007864:	00048513          	mv	a0,s1
    80007868:	00002597          	auipc	a1,0x2
    8000786c:	07858593          	addi	a1,a1,120 # 800098e0 <_ZTV9Semaphore+0x148>
    80007870:	00001097          	auipc	ra,0x1
    80007874:	d88080e7          	jalr	-632(ra) # 800085f8 <initlock>
    80007878:	00000097          	auipc	ra,0x0
    8000787c:	7ac080e7          	jalr	1964(ra) # 80008024 <uartinit>
    80007880:	01813083          	ld	ra,24(sp)
    80007884:	01013403          	ld	s0,16(sp)
    80007888:	00000797          	auipc	a5,0x0
    8000788c:	d9c78793          	addi	a5,a5,-612 # 80007624 <consoleread>
    80007890:	0af4bc23          	sd	a5,184(s1)
    80007894:	00000797          	auipc	a5,0x0
    80007898:	cec78793          	addi	a5,a5,-788 # 80007580 <consolewrite>
    8000789c:	0cf4b023          	sd	a5,192(s1)
    800078a0:	00813483          	ld	s1,8(sp)
    800078a4:	02010113          	addi	sp,sp,32
    800078a8:	00008067          	ret

00000000800078ac <console_read>:
    800078ac:	ff010113          	addi	sp,sp,-16
    800078b0:	00813423          	sd	s0,8(sp)
    800078b4:	01010413          	addi	s0,sp,16
    800078b8:	00813403          	ld	s0,8(sp)
    800078bc:	00006317          	auipc	t1,0x6
    800078c0:	e6433303          	ld	t1,-412(t1) # 8000d720 <devsw+0x10>
    800078c4:	01010113          	addi	sp,sp,16
    800078c8:	00030067          	jr	t1

00000000800078cc <console_write>:
    800078cc:	ff010113          	addi	sp,sp,-16
    800078d0:	00813423          	sd	s0,8(sp)
    800078d4:	01010413          	addi	s0,sp,16
    800078d8:	00813403          	ld	s0,8(sp)
    800078dc:	00006317          	auipc	t1,0x6
    800078e0:	e4c33303          	ld	t1,-436(t1) # 8000d728 <devsw+0x18>
    800078e4:	01010113          	addi	sp,sp,16
    800078e8:	00030067          	jr	t1

00000000800078ec <panic>:
    800078ec:	fe010113          	addi	sp,sp,-32
    800078f0:	00113c23          	sd	ra,24(sp)
    800078f4:	00813823          	sd	s0,16(sp)
    800078f8:	00913423          	sd	s1,8(sp)
    800078fc:	02010413          	addi	s0,sp,32
    80007900:	00050493          	mv	s1,a0
    80007904:	00002517          	auipc	a0,0x2
    80007908:	fe450513          	addi	a0,a0,-28 # 800098e8 <_ZTV9Semaphore+0x150>
    8000790c:	00006797          	auipc	a5,0x6
    80007910:	ea07ae23          	sw	zero,-324(a5) # 8000d7c8 <pr+0x18>
    80007914:	00000097          	auipc	ra,0x0
    80007918:	034080e7          	jalr	52(ra) # 80007948 <__printf>
    8000791c:	00048513          	mv	a0,s1
    80007920:	00000097          	auipc	ra,0x0
    80007924:	028080e7          	jalr	40(ra) # 80007948 <__printf>
    80007928:	00002517          	auipc	a0,0x2
    8000792c:	aa850513          	addi	a0,a0,-1368 # 800093d0 <_ZTV12ConsumerSync+0x278>
    80007930:	00000097          	auipc	ra,0x0
    80007934:	018080e7          	jalr	24(ra) # 80007948 <__printf>
    80007938:	00100793          	li	a5,1
    8000793c:	00004717          	auipc	a4,0x4
    80007940:	40f72623          	sw	a5,1036(a4) # 8000bd48 <panicked>
    80007944:	0000006f          	j	80007944 <panic+0x58>

0000000080007948 <__printf>:
    80007948:	f3010113          	addi	sp,sp,-208
    8000794c:	08813023          	sd	s0,128(sp)
    80007950:	07313423          	sd	s3,104(sp)
    80007954:	09010413          	addi	s0,sp,144
    80007958:	05813023          	sd	s8,64(sp)
    8000795c:	08113423          	sd	ra,136(sp)
    80007960:	06913c23          	sd	s1,120(sp)
    80007964:	07213823          	sd	s2,112(sp)
    80007968:	07413023          	sd	s4,96(sp)
    8000796c:	05513c23          	sd	s5,88(sp)
    80007970:	05613823          	sd	s6,80(sp)
    80007974:	05713423          	sd	s7,72(sp)
    80007978:	03913c23          	sd	s9,56(sp)
    8000797c:	03a13823          	sd	s10,48(sp)
    80007980:	03b13423          	sd	s11,40(sp)
    80007984:	00006317          	auipc	t1,0x6
    80007988:	e2c30313          	addi	t1,t1,-468 # 8000d7b0 <pr>
    8000798c:	01832c03          	lw	s8,24(t1)
    80007990:	00b43423          	sd	a1,8(s0)
    80007994:	00c43823          	sd	a2,16(s0)
    80007998:	00d43c23          	sd	a3,24(s0)
    8000799c:	02e43023          	sd	a4,32(s0)
    800079a0:	02f43423          	sd	a5,40(s0)
    800079a4:	03043823          	sd	a6,48(s0)
    800079a8:	03143c23          	sd	a7,56(s0)
    800079ac:	00050993          	mv	s3,a0
    800079b0:	4a0c1663          	bnez	s8,80007e5c <__printf+0x514>
    800079b4:	60098c63          	beqz	s3,80007fcc <__printf+0x684>
    800079b8:	0009c503          	lbu	a0,0(s3)
    800079bc:	00840793          	addi	a5,s0,8
    800079c0:	f6f43c23          	sd	a5,-136(s0)
    800079c4:	00000493          	li	s1,0
    800079c8:	22050063          	beqz	a0,80007be8 <__printf+0x2a0>
    800079cc:	00002a37          	lui	s4,0x2
    800079d0:	00018ab7          	lui	s5,0x18
    800079d4:	000f4b37          	lui	s6,0xf4
    800079d8:	00989bb7          	lui	s7,0x989
    800079dc:	70fa0a13          	addi	s4,s4,1807 # 270f <_entry-0x7fffd8f1>
    800079e0:	69fa8a93          	addi	s5,s5,1695 # 1869f <_entry-0x7ffe7961>
    800079e4:	23fb0b13          	addi	s6,s6,575 # f423f <_entry-0x7ff0bdc1>
    800079e8:	67fb8b93          	addi	s7,s7,1663 # 98967f <_entry-0x7f676981>
    800079ec:	00148c9b          	addiw	s9,s1,1
    800079f0:	02500793          	li	a5,37
    800079f4:	01998933          	add	s2,s3,s9
    800079f8:	38f51263          	bne	a0,a5,80007d7c <__printf+0x434>
    800079fc:	00094783          	lbu	a5,0(s2)
    80007a00:	00078c9b          	sext.w	s9,a5
    80007a04:	1e078263          	beqz	a5,80007be8 <__printf+0x2a0>
    80007a08:	0024849b          	addiw	s1,s1,2
    80007a0c:	07000713          	li	a4,112
    80007a10:	00998933          	add	s2,s3,s1
    80007a14:	38e78a63          	beq	a5,a4,80007da8 <__printf+0x460>
    80007a18:	20f76863          	bltu	a4,a5,80007c28 <__printf+0x2e0>
    80007a1c:	42a78863          	beq	a5,a0,80007e4c <__printf+0x504>
    80007a20:	06400713          	li	a4,100
    80007a24:	40e79663          	bne	a5,a4,80007e30 <__printf+0x4e8>
    80007a28:	f7843783          	ld	a5,-136(s0)
    80007a2c:	0007a603          	lw	a2,0(a5)
    80007a30:	00878793          	addi	a5,a5,8
    80007a34:	f6f43c23          	sd	a5,-136(s0)
    80007a38:	42064a63          	bltz	a2,80007e6c <__printf+0x524>
    80007a3c:	00a00713          	li	a4,10
    80007a40:	02e677bb          	remuw	a5,a2,a4
    80007a44:	00002d97          	auipc	s11,0x2
    80007a48:	eccd8d93          	addi	s11,s11,-308 # 80009910 <digits>
    80007a4c:	00900593          	li	a1,9
    80007a50:	0006051b          	sext.w	a0,a2
    80007a54:	00000c93          	li	s9,0
    80007a58:	02079793          	slli	a5,a5,0x20
    80007a5c:	0207d793          	srli	a5,a5,0x20
    80007a60:	00fd87b3          	add	a5,s11,a5
    80007a64:	0007c783          	lbu	a5,0(a5)
    80007a68:	02e656bb          	divuw	a3,a2,a4
    80007a6c:	f8f40023          	sb	a5,-128(s0)
    80007a70:	14c5d863          	bge	a1,a2,80007bc0 <__printf+0x278>
    80007a74:	06300593          	li	a1,99
    80007a78:	00100c93          	li	s9,1
    80007a7c:	02e6f7bb          	remuw	a5,a3,a4
    80007a80:	02079793          	slli	a5,a5,0x20
    80007a84:	0207d793          	srli	a5,a5,0x20
    80007a88:	00fd87b3          	add	a5,s11,a5
    80007a8c:	0007c783          	lbu	a5,0(a5)
    80007a90:	02e6d73b          	divuw	a4,a3,a4
    80007a94:	f8f400a3          	sb	a5,-127(s0)
    80007a98:	12a5f463          	bgeu	a1,a0,80007bc0 <__printf+0x278>
    80007a9c:	00a00693          	li	a3,10
    80007aa0:	00900593          	li	a1,9
    80007aa4:	02d777bb          	remuw	a5,a4,a3
    80007aa8:	02079793          	slli	a5,a5,0x20
    80007aac:	0207d793          	srli	a5,a5,0x20
    80007ab0:	00fd87b3          	add	a5,s11,a5
    80007ab4:	0007c503          	lbu	a0,0(a5)
    80007ab8:	02d757bb          	divuw	a5,a4,a3
    80007abc:	f8a40123          	sb	a0,-126(s0)
    80007ac0:	48e5f263          	bgeu	a1,a4,80007f44 <__printf+0x5fc>
    80007ac4:	06300513          	li	a0,99
    80007ac8:	02d7f5bb          	remuw	a1,a5,a3
    80007acc:	02059593          	slli	a1,a1,0x20
    80007ad0:	0205d593          	srli	a1,a1,0x20
    80007ad4:	00bd85b3          	add	a1,s11,a1
    80007ad8:	0005c583          	lbu	a1,0(a1)
    80007adc:	02d7d7bb          	divuw	a5,a5,a3
    80007ae0:	f8b401a3          	sb	a1,-125(s0)
    80007ae4:	48e57263          	bgeu	a0,a4,80007f68 <__printf+0x620>
    80007ae8:	3e700513          	li	a0,999
    80007aec:	02d7f5bb          	remuw	a1,a5,a3
    80007af0:	02059593          	slli	a1,a1,0x20
    80007af4:	0205d593          	srli	a1,a1,0x20
    80007af8:	00bd85b3          	add	a1,s11,a1
    80007afc:	0005c583          	lbu	a1,0(a1)
    80007b00:	02d7d7bb          	divuw	a5,a5,a3
    80007b04:	f8b40223          	sb	a1,-124(s0)
    80007b08:	46e57663          	bgeu	a0,a4,80007f74 <__printf+0x62c>
    80007b0c:	02d7f5bb          	remuw	a1,a5,a3
    80007b10:	02059593          	slli	a1,a1,0x20
    80007b14:	0205d593          	srli	a1,a1,0x20
    80007b18:	00bd85b3          	add	a1,s11,a1
    80007b1c:	0005c583          	lbu	a1,0(a1)
    80007b20:	02d7d7bb          	divuw	a5,a5,a3
    80007b24:	f8b402a3          	sb	a1,-123(s0)
    80007b28:	46ea7863          	bgeu	s4,a4,80007f98 <__printf+0x650>
    80007b2c:	02d7f5bb          	remuw	a1,a5,a3
    80007b30:	02059593          	slli	a1,a1,0x20
    80007b34:	0205d593          	srli	a1,a1,0x20
    80007b38:	00bd85b3          	add	a1,s11,a1
    80007b3c:	0005c583          	lbu	a1,0(a1)
    80007b40:	02d7d7bb          	divuw	a5,a5,a3
    80007b44:	f8b40323          	sb	a1,-122(s0)
    80007b48:	3eeaf863          	bgeu	s5,a4,80007f38 <__printf+0x5f0>
    80007b4c:	02d7f5bb          	remuw	a1,a5,a3
    80007b50:	02059593          	slli	a1,a1,0x20
    80007b54:	0205d593          	srli	a1,a1,0x20
    80007b58:	00bd85b3          	add	a1,s11,a1
    80007b5c:	0005c583          	lbu	a1,0(a1)
    80007b60:	02d7d7bb          	divuw	a5,a5,a3
    80007b64:	f8b403a3          	sb	a1,-121(s0)
    80007b68:	42eb7e63          	bgeu	s6,a4,80007fa4 <__printf+0x65c>
    80007b6c:	02d7f5bb          	remuw	a1,a5,a3
    80007b70:	02059593          	slli	a1,a1,0x20
    80007b74:	0205d593          	srli	a1,a1,0x20
    80007b78:	00bd85b3          	add	a1,s11,a1
    80007b7c:	0005c583          	lbu	a1,0(a1)
    80007b80:	02d7d7bb          	divuw	a5,a5,a3
    80007b84:	f8b40423          	sb	a1,-120(s0)
    80007b88:	42ebfc63          	bgeu	s7,a4,80007fc0 <__printf+0x678>
    80007b8c:	02079793          	slli	a5,a5,0x20
    80007b90:	0207d793          	srli	a5,a5,0x20
    80007b94:	00fd8db3          	add	s11,s11,a5
    80007b98:	000dc703          	lbu	a4,0(s11)
    80007b9c:	00a00793          	li	a5,10
    80007ba0:	00900c93          	li	s9,9
    80007ba4:	f8e404a3          	sb	a4,-119(s0)
    80007ba8:	00065c63          	bgez	a2,80007bc0 <__printf+0x278>
    80007bac:	f9040713          	addi	a4,s0,-112
    80007bb0:	00f70733          	add	a4,a4,a5
    80007bb4:	02d00693          	li	a3,45
    80007bb8:	fed70823          	sb	a3,-16(a4)
    80007bbc:	00078c93          	mv	s9,a5
    80007bc0:	f8040793          	addi	a5,s0,-128
    80007bc4:	01978cb3          	add	s9,a5,s9
    80007bc8:	f7f40d13          	addi	s10,s0,-129
    80007bcc:	000cc503          	lbu	a0,0(s9)
    80007bd0:	fffc8c93          	addi	s9,s9,-1
    80007bd4:	00000097          	auipc	ra,0x0
    80007bd8:	b90080e7          	jalr	-1136(ra) # 80007764 <consputc>
    80007bdc:	ffac98e3          	bne	s9,s10,80007bcc <__printf+0x284>
    80007be0:	00094503          	lbu	a0,0(s2)
    80007be4:	e00514e3          	bnez	a0,800079ec <__printf+0xa4>
    80007be8:	1a0c1663          	bnez	s8,80007d94 <__printf+0x44c>
    80007bec:	08813083          	ld	ra,136(sp)
    80007bf0:	08013403          	ld	s0,128(sp)
    80007bf4:	07813483          	ld	s1,120(sp)
    80007bf8:	07013903          	ld	s2,112(sp)
    80007bfc:	06813983          	ld	s3,104(sp)
    80007c00:	06013a03          	ld	s4,96(sp)
    80007c04:	05813a83          	ld	s5,88(sp)
    80007c08:	05013b03          	ld	s6,80(sp)
    80007c0c:	04813b83          	ld	s7,72(sp)
    80007c10:	04013c03          	ld	s8,64(sp)
    80007c14:	03813c83          	ld	s9,56(sp)
    80007c18:	03013d03          	ld	s10,48(sp)
    80007c1c:	02813d83          	ld	s11,40(sp)
    80007c20:	0d010113          	addi	sp,sp,208
    80007c24:	00008067          	ret
    80007c28:	07300713          	li	a4,115
    80007c2c:	1ce78a63          	beq	a5,a4,80007e00 <__printf+0x4b8>
    80007c30:	07800713          	li	a4,120
    80007c34:	1ee79e63          	bne	a5,a4,80007e30 <__printf+0x4e8>
    80007c38:	f7843783          	ld	a5,-136(s0)
    80007c3c:	0007a703          	lw	a4,0(a5)
    80007c40:	00878793          	addi	a5,a5,8
    80007c44:	f6f43c23          	sd	a5,-136(s0)
    80007c48:	28074263          	bltz	a4,80007ecc <__printf+0x584>
    80007c4c:	00002d97          	auipc	s11,0x2
    80007c50:	cc4d8d93          	addi	s11,s11,-828 # 80009910 <digits>
    80007c54:	00f77793          	andi	a5,a4,15
    80007c58:	00fd87b3          	add	a5,s11,a5
    80007c5c:	0007c683          	lbu	a3,0(a5)
    80007c60:	00f00613          	li	a2,15
    80007c64:	0007079b          	sext.w	a5,a4
    80007c68:	f8d40023          	sb	a3,-128(s0)
    80007c6c:	0047559b          	srliw	a1,a4,0x4
    80007c70:	0047569b          	srliw	a3,a4,0x4
    80007c74:	00000c93          	li	s9,0
    80007c78:	0ee65063          	bge	a2,a4,80007d58 <__printf+0x410>
    80007c7c:	00f6f693          	andi	a3,a3,15
    80007c80:	00dd86b3          	add	a3,s11,a3
    80007c84:	0006c683          	lbu	a3,0(a3) # 2004000 <_entry-0x7dffc000>
    80007c88:	0087d79b          	srliw	a5,a5,0x8
    80007c8c:	00100c93          	li	s9,1
    80007c90:	f8d400a3          	sb	a3,-127(s0)
    80007c94:	0cb67263          	bgeu	a2,a1,80007d58 <__printf+0x410>
    80007c98:	00f7f693          	andi	a3,a5,15
    80007c9c:	00dd86b3          	add	a3,s11,a3
    80007ca0:	0006c583          	lbu	a1,0(a3)
    80007ca4:	00f00613          	li	a2,15
    80007ca8:	0047d69b          	srliw	a3,a5,0x4
    80007cac:	f8b40123          	sb	a1,-126(s0)
    80007cb0:	0047d593          	srli	a1,a5,0x4
    80007cb4:	28f67e63          	bgeu	a2,a5,80007f50 <__printf+0x608>
    80007cb8:	00f6f693          	andi	a3,a3,15
    80007cbc:	00dd86b3          	add	a3,s11,a3
    80007cc0:	0006c503          	lbu	a0,0(a3)
    80007cc4:	0087d813          	srli	a6,a5,0x8
    80007cc8:	0087d69b          	srliw	a3,a5,0x8
    80007ccc:	f8a401a3          	sb	a0,-125(s0)
    80007cd0:	28b67663          	bgeu	a2,a1,80007f5c <__printf+0x614>
    80007cd4:	00f6f693          	andi	a3,a3,15
    80007cd8:	00dd86b3          	add	a3,s11,a3
    80007cdc:	0006c583          	lbu	a1,0(a3)
    80007ce0:	00c7d513          	srli	a0,a5,0xc
    80007ce4:	00c7d69b          	srliw	a3,a5,0xc
    80007ce8:	f8b40223          	sb	a1,-124(s0)
    80007cec:	29067a63          	bgeu	a2,a6,80007f80 <__printf+0x638>
    80007cf0:	00f6f693          	andi	a3,a3,15
    80007cf4:	00dd86b3          	add	a3,s11,a3
    80007cf8:	0006c583          	lbu	a1,0(a3)
    80007cfc:	0107d813          	srli	a6,a5,0x10
    80007d00:	0107d69b          	srliw	a3,a5,0x10
    80007d04:	f8b402a3          	sb	a1,-123(s0)
    80007d08:	28a67263          	bgeu	a2,a0,80007f8c <__printf+0x644>
    80007d0c:	00f6f693          	andi	a3,a3,15
    80007d10:	00dd86b3          	add	a3,s11,a3
    80007d14:	0006c683          	lbu	a3,0(a3)
    80007d18:	0147d79b          	srliw	a5,a5,0x14
    80007d1c:	f8d40323          	sb	a3,-122(s0)
    80007d20:	21067663          	bgeu	a2,a6,80007f2c <__printf+0x5e4>
    80007d24:	02079793          	slli	a5,a5,0x20
    80007d28:	0207d793          	srli	a5,a5,0x20
    80007d2c:	00fd8db3          	add	s11,s11,a5
    80007d30:	000dc683          	lbu	a3,0(s11)
    80007d34:	00800793          	li	a5,8
    80007d38:	00700c93          	li	s9,7
    80007d3c:	f8d403a3          	sb	a3,-121(s0)
    80007d40:	00075c63          	bgez	a4,80007d58 <__printf+0x410>
    80007d44:	f9040713          	addi	a4,s0,-112
    80007d48:	00f70733          	add	a4,a4,a5
    80007d4c:	02d00693          	li	a3,45
    80007d50:	fed70823          	sb	a3,-16(a4)
    80007d54:	00078c93          	mv	s9,a5
    80007d58:	f8040793          	addi	a5,s0,-128
    80007d5c:	01978cb3          	add	s9,a5,s9
    80007d60:	f7f40d13          	addi	s10,s0,-129
    80007d64:	000cc503          	lbu	a0,0(s9)
    80007d68:	fffc8c93          	addi	s9,s9,-1
    80007d6c:	00000097          	auipc	ra,0x0
    80007d70:	9f8080e7          	jalr	-1544(ra) # 80007764 <consputc>
    80007d74:	ff9d18e3          	bne	s10,s9,80007d64 <__printf+0x41c>
    80007d78:	0100006f          	j	80007d88 <__printf+0x440>
    80007d7c:	00000097          	auipc	ra,0x0
    80007d80:	9e8080e7          	jalr	-1560(ra) # 80007764 <consputc>
    80007d84:	000c8493          	mv	s1,s9
    80007d88:	00094503          	lbu	a0,0(s2)
    80007d8c:	c60510e3          	bnez	a0,800079ec <__printf+0xa4>
    80007d90:	e40c0ee3          	beqz	s8,80007bec <__printf+0x2a4>
    80007d94:	00006517          	auipc	a0,0x6
    80007d98:	a1c50513          	addi	a0,a0,-1508 # 8000d7b0 <pr>
    80007d9c:	00001097          	auipc	ra,0x1
    80007da0:	94c080e7          	jalr	-1716(ra) # 800086e8 <release>
    80007da4:	e49ff06f          	j	80007bec <__printf+0x2a4>
    80007da8:	f7843783          	ld	a5,-136(s0)
    80007dac:	03000513          	li	a0,48
    80007db0:	01000d13          	li	s10,16
    80007db4:	00878713          	addi	a4,a5,8
    80007db8:	0007bc83          	ld	s9,0(a5)
    80007dbc:	f6e43c23          	sd	a4,-136(s0)
    80007dc0:	00000097          	auipc	ra,0x0
    80007dc4:	9a4080e7          	jalr	-1628(ra) # 80007764 <consputc>
    80007dc8:	07800513          	li	a0,120
    80007dcc:	00000097          	auipc	ra,0x0
    80007dd0:	998080e7          	jalr	-1640(ra) # 80007764 <consputc>
    80007dd4:	00002d97          	auipc	s11,0x2
    80007dd8:	b3cd8d93          	addi	s11,s11,-1220 # 80009910 <digits>
    80007ddc:	03ccd793          	srli	a5,s9,0x3c
    80007de0:	00fd87b3          	add	a5,s11,a5
    80007de4:	0007c503          	lbu	a0,0(a5)
    80007de8:	fffd0d1b          	addiw	s10,s10,-1
    80007dec:	004c9c93          	slli	s9,s9,0x4
    80007df0:	00000097          	auipc	ra,0x0
    80007df4:	974080e7          	jalr	-1676(ra) # 80007764 <consputc>
    80007df8:	fe0d12e3          	bnez	s10,80007ddc <__printf+0x494>
    80007dfc:	f8dff06f          	j	80007d88 <__printf+0x440>
    80007e00:	f7843783          	ld	a5,-136(s0)
    80007e04:	0007bc83          	ld	s9,0(a5)
    80007e08:	00878793          	addi	a5,a5,8
    80007e0c:	f6f43c23          	sd	a5,-136(s0)
    80007e10:	000c9a63          	bnez	s9,80007e24 <__printf+0x4dc>
    80007e14:	1080006f          	j	80007f1c <__printf+0x5d4>
    80007e18:	001c8c93          	addi	s9,s9,1
    80007e1c:	00000097          	auipc	ra,0x0
    80007e20:	948080e7          	jalr	-1720(ra) # 80007764 <consputc>
    80007e24:	000cc503          	lbu	a0,0(s9)
    80007e28:	fe0518e3          	bnez	a0,80007e18 <__printf+0x4d0>
    80007e2c:	f5dff06f          	j	80007d88 <__printf+0x440>
    80007e30:	02500513          	li	a0,37
    80007e34:	00000097          	auipc	ra,0x0
    80007e38:	930080e7          	jalr	-1744(ra) # 80007764 <consputc>
    80007e3c:	000c8513          	mv	a0,s9
    80007e40:	00000097          	auipc	ra,0x0
    80007e44:	924080e7          	jalr	-1756(ra) # 80007764 <consputc>
    80007e48:	f41ff06f          	j	80007d88 <__printf+0x440>
    80007e4c:	02500513          	li	a0,37
    80007e50:	00000097          	auipc	ra,0x0
    80007e54:	914080e7          	jalr	-1772(ra) # 80007764 <consputc>
    80007e58:	f31ff06f          	j	80007d88 <__printf+0x440>
    80007e5c:	00030513          	mv	a0,t1
    80007e60:	00000097          	auipc	ra,0x0
    80007e64:	7bc080e7          	jalr	1980(ra) # 8000861c <acquire>
    80007e68:	b4dff06f          	j	800079b4 <__printf+0x6c>
    80007e6c:	40c0053b          	negw	a0,a2
    80007e70:	00a00713          	li	a4,10
    80007e74:	02e576bb          	remuw	a3,a0,a4
    80007e78:	00002d97          	auipc	s11,0x2
    80007e7c:	a98d8d93          	addi	s11,s11,-1384 # 80009910 <digits>
    80007e80:	ff700593          	li	a1,-9
    80007e84:	02069693          	slli	a3,a3,0x20
    80007e88:	0206d693          	srli	a3,a3,0x20
    80007e8c:	00dd86b3          	add	a3,s11,a3
    80007e90:	0006c683          	lbu	a3,0(a3)
    80007e94:	02e557bb          	divuw	a5,a0,a4
    80007e98:	f8d40023          	sb	a3,-128(s0)
    80007e9c:	10b65e63          	bge	a2,a1,80007fb8 <__printf+0x670>
    80007ea0:	06300593          	li	a1,99
    80007ea4:	02e7f6bb          	remuw	a3,a5,a4
    80007ea8:	02069693          	slli	a3,a3,0x20
    80007eac:	0206d693          	srli	a3,a3,0x20
    80007eb0:	00dd86b3          	add	a3,s11,a3
    80007eb4:	0006c683          	lbu	a3,0(a3)
    80007eb8:	02e7d73b          	divuw	a4,a5,a4
    80007ebc:	00200793          	li	a5,2
    80007ec0:	f8d400a3          	sb	a3,-127(s0)
    80007ec4:	bca5ece3          	bltu	a1,a0,80007a9c <__printf+0x154>
    80007ec8:	ce5ff06f          	j	80007bac <__printf+0x264>
    80007ecc:	40e007bb          	negw	a5,a4
    80007ed0:	00002d97          	auipc	s11,0x2
    80007ed4:	a40d8d93          	addi	s11,s11,-1472 # 80009910 <digits>
    80007ed8:	00f7f693          	andi	a3,a5,15
    80007edc:	00dd86b3          	add	a3,s11,a3
    80007ee0:	0006c583          	lbu	a1,0(a3)
    80007ee4:	ff100613          	li	a2,-15
    80007ee8:	0047d69b          	srliw	a3,a5,0x4
    80007eec:	f8b40023          	sb	a1,-128(s0)
    80007ef0:	0047d59b          	srliw	a1,a5,0x4
    80007ef4:	0ac75e63          	bge	a4,a2,80007fb0 <__printf+0x668>
    80007ef8:	00f6f693          	andi	a3,a3,15
    80007efc:	00dd86b3          	add	a3,s11,a3
    80007f00:	0006c603          	lbu	a2,0(a3)
    80007f04:	00f00693          	li	a3,15
    80007f08:	0087d79b          	srliw	a5,a5,0x8
    80007f0c:	f8c400a3          	sb	a2,-127(s0)
    80007f10:	d8b6e4e3          	bltu	a3,a1,80007c98 <__printf+0x350>
    80007f14:	00200793          	li	a5,2
    80007f18:	e2dff06f          	j	80007d44 <__printf+0x3fc>
    80007f1c:	00002c97          	auipc	s9,0x2
    80007f20:	9d4c8c93          	addi	s9,s9,-1580 # 800098f0 <_ZTV9Semaphore+0x158>
    80007f24:	02800513          	li	a0,40
    80007f28:	ef1ff06f          	j	80007e18 <__printf+0x4d0>
    80007f2c:	00700793          	li	a5,7
    80007f30:	00600c93          	li	s9,6
    80007f34:	e0dff06f          	j	80007d40 <__printf+0x3f8>
    80007f38:	00700793          	li	a5,7
    80007f3c:	00600c93          	li	s9,6
    80007f40:	c69ff06f          	j	80007ba8 <__printf+0x260>
    80007f44:	00300793          	li	a5,3
    80007f48:	00200c93          	li	s9,2
    80007f4c:	c5dff06f          	j	80007ba8 <__printf+0x260>
    80007f50:	00300793          	li	a5,3
    80007f54:	00200c93          	li	s9,2
    80007f58:	de9ff06f          	j	80007d40 <__printf+0x3f8>
    80007f5c:	00400793          	li	a5,4
    80007f60:	00300c93          	li	s9,3
    80007f64:	dddff06f          	j	80007d40 <__printf+0x3f8>
    80007f68:	00400793          	li	a5,4
    80007f6c:	00300c93          	li	s9,3
    80007f70:	c39ff06f          	j	80007ba8 <__printf+0x260>
    80007f74:	00500793          	li	a5,5
    80007f78:	00400c93          	li	s9,4
    80007f7c:	c2dff06f          	j	80007ba8 <__printf+0x260>
    80007f80:	00500793          	li	a5,5
    80007f84:	00400c93          	li	s9,4
    80007f88:	db9ff06f          	j	80007d40 <__printf+0x3f8>
    80007f8c:	00600793          	li	a5,6
    80007f90:	00500c93          	li	s9,5
    80007f94:	dadff06f          	j	80007d40 <__printf+0x3f8>
    80007f98:	00600793          	li	a5,6
    80007f9c:	00500c93          	li	s9,5
    80007fa0:	c09ff06f          	j	80007ba8 <__printf+0x260>
    80007fa4:	00800793          	li	a5,8
    80007fa8:	00700c93          	li	s9,7
    80007fac:	bfdff06f          	j	80007ba8 <__printf+0x260>
    80007fb0:	00100793          	li	a5,1
    80007fb4:	d91ff06f          	j	80007d44 <__printf+0x3fc>
    80007fb8:	00100793          	li	a5,1
    80007fbc:	bf1ff06f          	j	80007bac <__printf+0x264>
    80007fc0:	00900793          	li	a5,9
    80007fc4:	00800c93          	li	s9,8
    80007fc8:	be1ff06f          	j	80007ba8 <__printf+0x260>
    80007fcc:	00002517          	auipc	a0,0x2
    80007fd0:	92c50513          	addi	a0,a0,-1748 # 800098f8 <_ZTV9Semaphore+0x160>
    80007fd4:	00000097          	auipc	ra,0x0
    80007fd8:	918080e7          	jalr	-1768(ra) # 800078ec <panic>

0000000080007fdc <printfinit>:
    80007fdc:	fe010113          	addi	sp,sp,-32
    80007fe0:	00813823          	sd	s0,16(sp)
    80007fe4:	00913423          	sd	s1,8(sp)
    80007fe8:	00113c23          	sd	ra,24(sp)
    80007fec:	02010413          	addi	s0,sp,32
    80007ff0:	00005497          	auipc	s1,0x5
    80007ff4:	7c048493          	addi	s1,s1,1984 # 8000d7b0 <pr>
    80007ff8:	00048513          	mv	a0,s1
    80007ffc:	00002597          	auipc	a1,0x2
    80008000:	90c58593          	addi	a1,a1,-1780 # 80009908 <_ZTV9Semaphore+0x170>
    80008004:	00000097          	auipc	ra,0x0
    80008008:	5f4080e7          	jalr	1524(ra) # 800085f8 <initlock>
    8000800c:	01813083          	ld	ra,24(sp)
    80008010:	01013403          	ld	s0,16(sp)
    80008014:	0004ac23          	sw	zero,24(s1)
    80008018:	00813483          	ld	s1,8(sp)
    8000801c:	02010113          	addi	sp,sp,32
    80008020:	00008067          	ret

0000000080008024 <uartinit>:
    80008024:	ff010113          	addi	sp,sp,-16
    80008028:	00813423          	sd	s0,8(sp)
    8000802c:	01010413          	addi	s0,sp,16
    80008030:	100007b7          	lui	a5,0x10000
    80008034:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>
    80008038:	f8000713          	li	a4,-128
    8000803c:	00e781a3          	sb	a4,3(a5)
    80008040:	00300713          	li	a4,3
    80008044:	00e78023          	sb	a4,0(a5)
    80008048:	000780a3          	sb	zero,1(a5)
    8000804c:	00e781a3          	sb	a4,3(a5)
    80008050:	00700693          	li	a3,7
    80008054:	00d78123          	sb	a3,2(a5)
    80008058:	00e780a3          	sb	a4,1(a5)
    8000805c:	00813403          	ld	s0,8(sp)
    80008060:	01010113          	addi	sp,sp,16
    80008064:	00008067          	ret

0000000080008068 <uartputc>:
    80008068:	00004797          	auipc	a5,0x4
    8000806c:	ce07a783          	lw	a5,-800(a5) # 8000bd48 <panicked>
    80008070:	00078463          	beqz	a5,80008078 <uartputc+0x10>
    80008074:	0000006f          	j	80008074 <uartputc+0xc>
    80008078:	fd010113          	addi	sp,sp,-48
    8000807c:	02813023          	sd	s0,32(sp)
    80008080:	00913c23          	sd	s1,24(sp)
    80008084:	01213823          	sd	s2,16(sp)
    80008088:	01313423          	sd	s3,8(sp)
    8000808c:	02113423          	sd	ra,40(sp)
    80008090:	03010413          	addi	s0,sp,48
    80008094:	00004917          	auipc	s2,0x4
    80008098:	cbc90913          	addi	s2,s2,-836 # 8000bd50 <uart_tx_r>
    8000809c:	00093783          	ld	a5,0(s2)
    800080a0:	00004497          	auipc	s1,0x4
    800080a4:	cb848493          	addi	s1,s1,-840 # 8000bd58 <uart_tx_w>
    800080a8:	0004b703          	ld	a4,0(s1)
    800080ac:	02078693          	addi	a3,a5,32
    800080b0:	00050993          	mv	s3,a0
    800080b4:	02e69c63          	bne	a3,a4,800080ec <uartputc+0x84>
    800080b8:	00001097          	auipc	ra,0x1
    800080bc:	834080e7          	jalr	-1996(ra) # 800088ec <push_on>
    800080c0:	00093783          	ld	a5,0(s2)
    800080c4:	0004b703          	ld	a4,0(s1)
    800080c8:	02078793          	addi	a5,a5,32
    800080cc:	00e79463          	bne	a5,a4,800080d4 <uartputc+0x6c>
    800080d0:	0000006f          	j	800080d0 <uartputc+0x68>
    800080d4:	00001097          	auipc	ra,0x1
    800080d8:	88c080e7          	jalr	-1908(ra) # 80008960 <pop_on>
    800080dc:	00093783          	ld	a5,0(s2)
    800080e0:	0004b703          	ld	a4,0(s1)
    800080e4:	02078693          	addi	a3,a5,32
    800080e8:	fce688e3          	beq	a3,a4,800080b8 <uartputc+0x50>
    800080ec:	01f77693          	andi	a3,a4,31
    800080f0:	00005597          	auipc	a1,0x5
    800080f4:	6e058593          	addi	a1,a1,1760 # 8000d7d0 <uart_tx_buf>
    800080f8:	00d586b3          	add	a3,a1,a3
    800080fc:	00170713          	addi	a4,a4,1
    80008100:	01368023          	sb	s3,0(a3)
    80008104:	00e4b023          	sd	a4,0(s1)
    80008108:	10000637          	lui	a2,0x10000
    8000810c:	02f71063          	bne	a4,a5,8000812c <uartputc+0xc4>
    80008110:	0340006f          	j	80008144 <uartputc+0xdc>
    80008114:	00074703          	lbu	a4,0(a4)
    80008118:	00f93023          	sd	a5,0(s2)
    8000811c:	00e60023          	sb	a4,0(a2) # 10000000 <_entry-0x70000000>
    80008120:	00093783          	ld	a5,0(s2)
    80008124:	0004b703          	ld	a4,0(s1)
    80008128:	00f70e63          	beq	a4,a5,80008144 <uartputc+0xdc>
    8000812c:	00564683          	lbu	a3,5(a2)
    80008130:	01f7f713          	andi	a4,a5,31
    80008134:	00e58733          	add	a4,a1,a4
    80008138:	0206f693          	andi	a3,a3,32
    8000813c:	00178793          	addi	a5,a5,1
    80008140:	fc069ae3          	bnez	a3,80008114 <uartputc+0xac>
    80008144:	02813083          	ld	ra,40(sp)
    80008148:	02013403          	ld	s0,32(sp)
    8000814c:	01813483          	ld	s1,24(sp)
    80008150:	01013903          	ld	s2,16(sp)
    80008154:	00813983          	ld	s3,8(sp)
    80008158:	03010113          	addi	sp,sp,48
    8000815c:	00008067          	ret

0000000080008160 <uartputc_sync>:
    80008160:	ff010113          	addi	sp,sp,-16
    80008164:	00813423          	sd	s0,8(sp)
    80008168:	01010413          	addi	s0,sp,16
    8000816c:	00004717          	auipc	a4,0x4
    80008170:	bdc72703          	lw	a4,-1060(a4) # 8000bd48 <panicked>
    80008174:	02071663          	bnez	a4,800081a0 <uartputc_sync+0x40>
    80008178:	00050793          	mv	a5,a0
    8000817c:	100006b7          	lui	a3,0x10000
    80008180:	0056c703          	lbu	a4,5(a3) # 10000005 <_entry-0x6ffffffb>
    80008184:	02077713          	andi	a4,a4,32
    80008188:	fe070ce3          	beqz	a4,80008180 <uartputc_sync+0x20>
    8000818c:	0ff7f793          	andi	a5,a5,255
    80008190:	00f68023          	sb	a5,0(a3)
    80008194:	00813403          	ld	s0,8(sp)
    80008198:	01010113          	addi	sp,sp,16
    8000819c:	00008067          	ret
    800081a0:	0000006f          	j	800081a0 <uartputc_sync+0x40>

00000000800081a4 <uartstart>:
    800081a4:	ff010113          	addi	sp,sp,-16
    800081a8:	00813423          	sd	s0,8(sp)
    800081ac:	01010413          	addi	s0,sp,16
    800081b0:	00004617          	auipc	a2,0x4
    800081b4:	ba060613          	addi	a2,a2,-1120 # 8000bd50 <uart_tx_r>
    800081b8:	00004517          	auipc	a0,0x4
    800081bc:	ba050513          	addi	a0,a0,-1120 # 8000bd58 <uart_tx_w>
    800081c0:	00063783          	ld	a5,0(a2)
    800081c4:	00053703          	ld	a4,0(a0)
    800081c8:	04f70263          	beq	a4,a5,8000820c <uartstart+0x68>
    800081cc:	100005b7          	lui	a1,0x10000
    800081d0:	00005817          	auipc	a6,0x5
    800081d4:	60080813          	addi	a6,a6,1536 # 8000d7d0 <uart_tx_buf>
    800081d8:	01c0006f          	j	800081f4 <uartstart+0x50>
    800081dc:	0006c703          	lbu	a4,0(a3)
    800081e0:	00f63023          	sd	a5,0(a2)
    800081e4:	00e58023          	sb	a4,0(a1) # 10000000 <_entry-0x70000000>
    800081e8:	00063783          	ld	a5,0(a2)
    800081ec:	00053703          	ld	a4,0(a0)
    800081f0:	00f70e63          	beq	a4,a5,8000820c <uartstart+0x68>
    800081f4:	01f7f713          	andi	a4,a5,31
    800081f8:	00e806b3          	add	a3,a6,a4
    800081fc:	0055c703          	lbu	a4,5(a1)
    80008200:	00178793          	addi	a5,a5,1
    80008204:	02077713          	andi	a4,a4,32
    80008208:	fc071ae3          	bnez	a4,800081dc <uartstart+0x38>
    8000820c:	00813403          	ld	s0,8(sp)
    80008210:	01010113          	addi	sp,sp,16
    80008214:	00008067          	ret

0000000080008218 <uartgetc>:
    80008218:	ff010113          	addi	sp,sp,-16
    8000821c:	00813423          	sd	s0,8(sp)
    80008220:	01010413          	addi	s0,sp,16
    80008224:	10000737          	lui	a4,0x10000
    80008228:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000822c:	0017f793          	andi	a5,a5,1
    80008230:	00078c63          	beqz	a5,80008248 <uartgetc+0x30>
    80008234:	00074503          	lbu	a0,0(a4)
    80008238:	0ff57513          	andi	a0,a0,255
    8000823c:	00813403          	ld	s0,8(sp)
    80008240:	01010113          	addi	sp,sp,16
    80008244:	00008067          	ret
    80008248:	fff00513          	li	a0,-1
    8000824c:	ff1ff06f          	j	8000823c <uartgetc+0x24>

0000000080008250 <uartintr>:
    80008250:	100007b7          	lui	a5,0x10000
    80008254:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80008258:	0017f793          	andi	a5,a5,1
    8000825c:	0a078463          	beqz	a5,80008304 <uartintr+0xb4>
    80008260:	fe010113          	addi	sp,sp,-32
    80008264:	00813823          	sd	s0,16(sp)
    80008268:	00913423          	sd	s1,8(sp)
    8000826c:	00113c23          	sd	ra,24(sp)
    80008270:	02010413          	addi	s0,sp,32
    80008274:	100004b7          	lui	s1,0x10000
    80008278:	0004c503          	lbu	a0,0(s1) # 10000000 <_entry-0x70000000>
    8000827c:	0ff57513          	andi	a0,a0,255
    80008280:	fffff097          	auipc	ra,0xfffff
    80008284:	534080e7          	jalr	1332(ra) # 800077b4 <consoleintr>
    80008288:	0054c783          	lbu	a5,5(s1)
    8000828c:	0017f793          	andi	a5,a5,1
    80008290:	fe0794e3          	bnez	a5,80008278 <uartintr+0x28>
    80008294:	00004617          	auipc	a2,0x4
    80008298:	abc60613          	addi	a2,a2,-1348 # 8000bd50 <uart_tx_r>
    8000829c:	00004517          	auipc	a0,0x4
    800082a0:	abc50513          	addi	a0,a0,-1348 # 8000bd58 <uart_tx_w>
    800082a4:	00063783          	ld	a5,0(a2)
    800082a8:	00053703          	ld	a4,0(a0)
    800082ac:	04f70263          	beq	a4,a5,800082f0 <uartintr+0xa0>
    800082b0:	100005b7          	lui	a1,0x10000
    800082b4:	00005817          	auipc	a6,0x5
    800082b8:	51c80813          	addi	a6,a6,1308 # 8000d7d0 <uart_tx_buf>
    800082bc:	01c0006f          	j	800082d8 <uartintr+0x88>
    800082c0:	0006c703          	lbu	a4,0(a3)
    800082c4:	00f63023          	sd	a5,0(a2)
    800082c8:	00e58023          	sb	a4,0(a1) # 10000000 <_entry-0x70000000>
    800082cc:	00063783          	ld	a5,0(a2)
    800082d0:	00053703          	ld	a4,0(a0)
    800082d4:	00f70e63          	beq	a4,a5,800082f0 <uartintr+0xa0>
    800082d8:	01f7f713          	andi	a4,a5,31
    800082dc:	00e806b3          	add	a3,a6,a4
    800082e0:	0055c703          	lbu	a4,5(a1)
    800082e4:	00178793          	addi	a5,a5,1
    800082e8:	02077713          	andi	a4,a4,32
    800082ec:	fc071ae3          	bnez	a4,800082c0 <uartintr+0x70>
    800082f0:	01813083          	ld	ra,24(sp)
    800082f4:	01013403          	ld	s0,16(sp)
    800082f8:	00813483          	ld	s1,8(sp)
    800082fc:	02010113          	addi	sp,sp,32
    80008300:	00008067          	ret
    80008304:	00004617          	auipc	a2,0x4
    80008308:	a4c60613          	addi	a2,a2,-1460 # 8000bd50 <uart_tx_r>
    8000830c:	00004517          	auipc	a0,0x4
    80008310:	a4c50513          	addi	a0,a0,-1460 # 8000bd58 <uart_tx_w>
    80008314:	00063783          	ld	a5,0(a2)
    80008318:	00053703          	ld	a4,0(a0)
    8000831c:	04f70263          	beq	a4,a5,80008360 <uartintr+0x110>
    80008320:	100005b7          	lui	a1,0x10000
    80008324:	00005817          	auipc	a6,0x5
    80008328:	4ac80813          	addi	a6,a6,1196 # 8000d7d0 <uart_tx_buf>
    8000832c:	01c0006f          	j	80008348 <uartintr+0xf8>
    80008330:	0006c703          	lbu	a4,0(a3)
    80008334:	00f63023          	sd	a5,0(a2)
    80008338:	00e58023          	sb	a4,0(a1) # 10000000 <_entry-0x70000000>
    8000833c:	00063783          	ld	a5,0(a2)
    80008340:	00053703          	ld	a4,0(a0)
    80008344:	02f70063          	beq	a4,a5,80008364 <uartintr+0x114>
    80008348:	01f7f713          	andi	a4,a5,31
    8000834c:	00e806b3          	add	a3,a6,a4
    80008350:	0055c703          	lbu	a4,5(a1)
    80008354:	00178793          	addi	a5,a5,1
    80008358:	02077713          	andi	a4,a4,32
    8000835c:	fc071ae3          	bnez	a4,80008330 <uartintr+0xe0>
    80008360:	00008067          	ret
    80008364:	00008067          	ret

0000000080008368 <kinit>:
    80008368:	fc010113          	addi	sp,sp,-64
    8000836c:	02913423          	sd	s1,40(sp)
    80008370:	fffff7b7          	lui	a5,0xfffff
    80008374:	00006497          	auipc	s1,0x6
    80008378:	47b48493          	addi	s1,s1,1147 # 8000e7ef <end+0xfff>
    8000837c:	02813823          	sd	s0,48(sp)
    80008380:	01313c23          	sd	s3,24(sp)
    80008384:	00f4f4b3          	and	s1,s1,a5
    80008388:	02113c23          	sd	ra,56(sp)
    8000838c:	03213023          	sd	s2,32(sp)
    80008390:	01413823          	sd	s4,16(sp)
    80008394:	01513423          	sd	s5,8(sp)
    80008398:	04010413          	addi	s0,sp,64
    8000839c:	000017b7          	lui	a5,0x1
    800083a0:	01100993          	li	s3,17
    800083a4:	00f487b3          	add	a5,s1,a5
    800083a8:	01b99993          	slli	s3,s3,0x1b
    800083ac:	06f9e063          	bltu	s3,a5,8000840c <kinit+0xa4>
    800083b0:	00005a97          	auipc	s5,0x5
    800083b4:	440a8a93          	addi	s5,s5,1088 # 8000d7f0 <end>
    800083b8:	0754ec63          	bltu	s1,s5,80008430 <kinit+0xc8>
    800083bc:	0734fa63          	bgeu	s1,s3,80008430 <kinit+0xc8>
    800083c0:	00088a37          	lui	s4,0x88
    800083c4:	fffa0a13          	addi	s4,s4,-1 # 87fff <_entry-0x7ff78001>
    800083c8:	00004917          	auipc	s2,0x4
    800083cc:	99890913          	addi	s2,s2,-1640 # 8000bd60 <kmem>
    800083d0:	00ca1a13          	slli	s4,s4,0xc
    800083d4:	0140006f          	j	800083e8 <kinit+0x80>
    800083d8:	000017b7          	lui	a5,0x1
    800083dc:	00f484b3          	add	s1,s1,a5
    800083e0:	0554e863          	bltu	s1,s5,80008430 <kinit+0xc8>
    800083e4:	0534f663          	bgeu	s1,s3,80008430 <kinit+0xc8>
    800083e8:	00001637          	lui	a2,0x1
    800083ec:	00100593          	li	a1,1
    800083f0:	00048513          	mv	a0,s1
    800083f4:	00000097          	auipc	ra,0x0
    800083f8:	5e4080e7          	jalr	1508(ra) # 800089d8 <__memset>
    800083fc:	00093783          	ld	a5,0(s2)
    80008400:	00f4b023          	sd	a5,0(s1)
    80008404:	00993023          	sd	s1,0(s2)
    80008408:	fd4498e3          	bne	s1,s4,800083d8 <kinit+0x70>
    8000840c:	03813083          	ld	ra,56(sp)
    80008410:	03013403          	ld	s0,48(sp)
    80008414:	02813483          	ld	s1,40(sp)
    80008418:	02013903          	ld	s2,32(sp)
    8000841c:	01813983          	ld	s3,24(sp)
    80008420:	01013a03          	ld	s4,16(sp)
    80008424:	00813a83          	ld	s5,8(sp)
    80008428:	04010113          	addi	sp,sp,64
    8000842c:	00008067          	ret
    80008430:	00001517          	auipc	a0,0x1
    80008434:	4f850513          	addi	a0,a0,1272 # 80009928 <digits+0x18>
    80008438:	fffff097          	auipc	ra,0xfffff
    8000843c:	4b4080e7          	jalr	1204(ra) # 800078ec <panic>

0000000080008440 <freerange>:
    80008440:	fc010113          	addi	sp,sp,-64
    80008444:	000017b7          	lui	a5,0x1
    80008448:	02913423          	sd	s1,40(sp)
    8000844c:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80008450:	009504b3          	add	s1,a0,s1
    80008454:	fffff537          	lui	a0,0xfffff
    80008458:	02813823          	sd	s0,48(sp)
    8000845c:	02113c23          	sd	ra,56(sp)
    80008460:	03213023          	sd	s2,32(sp)
    80008464:	01313c23          	sd	s3,24(sp)
    80008468:	01413823          	sd	s4,16(sp)
    8000846c:	01513423          	sd	s5,8(sp)
    80008470:	01613023          	sd	s6,0(sp)
    80008474:	04010413          	addi	s0,sp,64
    80008478:	00a4f4b3          	and	s1,s1,a0
    8000847c:	00f487b3          	add	a5,s1,a5
    80008480:	06f5e463          	bltu	a1,a5,800084e8 <freerange+0xa8>
    80008484:	00005a97          	auipc	s5,0x5
    80008488:	36ca8a93          	addi	s5,s5,876 # 8000d7f0 <end>
    8000848c:	0954e263          	bltu	s1,s5,80008510 <freerange+0xd0>
    80008490:	01100993          	li	s3,17
    80008494:	01b99993          	slli	s3,s3,0x1b
    80008498:	0734fc63          	bgeu	s1,s3,80008510 <freerange+0xd0>
    8000849c:	00058a13          	mv	s4,a1
    800084a0:	00004917          	auipc	s2,0x4
    800084a4:	8c090913          	addi	s2,s2,-1856 # 8000bd60 <kmem>
    800084a8:	00002b37          	lui	s6,0x2
    800084ac:	0140006f          	j	800084c0 <freerange+0x80>
    800084b0:	000017b7          	lui	a5,0x1
    800084b4:	00f484b3          	add	s1,s1,a5
    800084b8:	0554ec63          	bltu	s1,s5,80008510 <freerange+0xd0>
    800084bc:	0534fa63          	bgeu	s1,s3,80008510 <freerange+0xd0>
    800084c0:	00001637          	lui	a2,0x1
    800084c4:	00100593          	li	a1,1
    800084c8:	00048513          	mv	a0,s1
    800084cc:	00000097          	auipc	ra,0x0
    800084d0:	50c080e7          	jalr	1292(ra) # 800089d8 <__memset>
    800084d4:	00093703          	ld	a4,0(s2)
    800084d8:	016487b3          	add	a5,s1,s6
    800084dc:	00e4b023          	sd	a4,0(s1)
    800084e0:	00993023          	sd	s1,0(s2)
    800084e4:	fcfa76e3          	bgeu	s4,a5,800084b0 <freerange+0x70>
    800084e8:	03813083          	ld	ra,56(sp)
    800084ec:	03013403          	ld	s0,48(sp)
    800084f0:	02813483          	ld	s1,40(sp)
    800084f4:	02013903          	ld	s2,32(sp)
    800084f8:	01813983          	ld	s3,24(sp)
    800084fc:	01013a03          	ld	s4,16(sp)
    80008500:	00813a83          	ld	s5,8(sp)
    80008504:	00013b03          	ld	s6,0(sp)
    80008508:	04010113          	addi	sp,sp,64
    8000850c:	00008067          	ret
    80008510:	00001517          	auipc	a0,0x1
    80008514:	41850513          	addi	a0,a0,1048 # 80009928 <digits+0x18>
    80008518:	fffff097          	auipc	ra,0xfffff
    8000851c:	3d4080e7          	jalr	980(ra) # 800078ec <panic>

0000000080008520 <kfree>:
    80008520:	fe010113          	addi	sp,sp,-32
    80008524:	00813823          	sd	s0,16(sp)
    80008528:	00113c23          	sd	ra,24(sp)
    8000852c:	00913423          	sd	s1,8(sp)
    80008530:	02010413          	addi	s0,sp,32
    80008534:	03451793          	slli	a5,a0,0x34
    80008538:	04079c63          	bnez	a5,80008590 <kfree+0x70>
    8000853c:	00005797          	auipc	a5,0x5
    80008540:	2b478793          	addi	a5,a5,692 # 8000d7f0 <end>
    80008544:	00050493          	mv	s1,a0
    80008548:	04f56463          	bltu	a0,a5,80008590 <kfree+0x70>
    8000854c:	01100793          	li	a5,17
    80008550:	01b79793          	slli	a5,a5,0x1b
    80008554:	02f57e63          	bgeu	a0,a5,80008590 <kfree+0x70>
    80008558:	00001637          	lui	a2,0x1
    8000855c:	00100593          	li	a1,1
    80008560:	00000097          	auipc	ra,0x0
    80008564:	478080e7          	jalr	1144(ra) # 800089d8 <__memset>
    80008568:	00003797          	auipc	a5,0x3
    8000856c:	7f878793          	addi	a5,a5,2040 # 8000bd60 <kmem>
    80008570:	0007b703          	ld	a4,0(a5)
    80008574:	01813083          	ld	ra,24(sp)
    80008578:	01013403          	ld	s0,16(sp)
    8000857c:	00e4b023          	sd	a4,0(s1)
    80008580:	0097b023          	sd	s1,0(a5)
    80008584:	00813483          	ld	s1,8(sp)
    80008588:	02010113          	addi	sp,sp,32
    8000858c:	00008067          	ret
    80008590:	00001517          	auipc	a0,0x1
    80008594:	39850513          	addi	a0,a0,920 # 80009928 <digits+0x18>
    80008598:	fffff097          	auipc	ra,0xfffff
    8000859c:	354080e7          	jalr	852(ra) # 800078ec <panic>

00000000800085a0 <kalloc>:
    800085a0:	fe010113          	addi	sp,sp,-32
    800085a4:	00813823          	sd	s0,16(sp)
    800085a8:	00913423          	sd	s1,8(sp)
    800085ac:	00113c23          	sd	ra,24(sp)
    800085b0:	02010413          	addi	s0,sp,32
    800085b4:	00003797          	auipc	a5,0x3
    800085b8:	7ac78793          	addi	a5,a5,1964 # 8000bd60 <kmem>
    800085bc:	0007b483          	ld	s1,0(a5)
    800085c0:	02048063          	beqz	s1,800085e0 <kalloc+0x40>
    800085c4:	0004b703          	ld	a4,0(s1)
    800085c8:	00001637          	lui	a2,0x1
    800085cc:	00500593          	li	a1,5
    800085d0:	00048513          	mv	a0,s1
    800085d4:	00e7b023          	sd	a4,0(a5)
    800085d8:	00000097          	auipc	ra,0x0
    800085dc:	400080e7          	jalr	1024(ra) # 800089d8 <__memset>
    800085e0:	01813083          	ld	ra,24(sp)
    800085e4:	01013403          	ld	s0,16(sp)
    800085e8:	00048513          	mv	a0,s1
    800085ec:	00813483          	ld	s1,8(sp)
    800085f0:	02010113          	addi	sp,sp,32
    800085f4:	00008067          	ret

00000000800085f8 <initlock>:
    800085f8:	ff010113          	addi	sp,sp,-16
    800085fc:	00813423          	sd	s0,8(sp)
    80008600:	01010413          	addi	s0,sp,16
    80008604:	00813403          	ld	s0,8(sp)
    80008608:	00b53423          	sd	a1,8(a0)
    8000860c:	00052023          	sw	zero,0(a0)
    80008610:	00053823          	sd	zero,16(a0)
    80008614:	01010113          	addi	sp,sp,16
    80008618:	00008067          	ret

000000008000861c <acquire>:
    8000861c:	fe010113          	addi	sp,sp,-32
    80008620:	00813823          	sd	s0,16(sp)
    80008624:	00913423          	sd	s1,8(sp)
    80008628:	00113c23          	sd	ra,24(sp)
    8000862c:	01213023          	sd	s2,0(sp)
    80008630:	02010413          	addi	s0,sp,32
    80008634:	00050493          	mv	s1,a0
    80008638:	10002973          	csrr	s2,sstatus
    8000863c:	100027f3          	csrr	a5,sstatus
    80008640:	ffd7f793          	andi	a5,a5,-3
    80008644:	10079073          	csrw	sstatus,a5
    80008648:	fffff097          	auipc	ra,0xfffff
    8000864c:	8e4080e7          	jalr	-1820(ra) # 80006f2c <mycpu>
    80008650:	07852783          	lw	a5,120(a0)
    80008654:	06078e63          	beqz	a5,800086d0 <acquire+0xb4>
    80008658:	fffff097          	auipc	ra,0xfffff
    8000865c:	8d4080e7          	jalr	-1836(ra) # 80006f2c <mycpu>
    80008660:	07852783          	lw	a5,120(a0)
    80008664:	0004a703          	lw	a4,0(s1)
    80008668:	0017879b          	addiw	a5,a5,1
    8000866c:	06f52c23          	sw	a5,120(a0)
    80008670:	04071063          	bnez	a4,800086b0 <acquire+0x94>
    80008674:	00100713          	li	a4,1
    80008678:	00070793          	mv	a5,a4
    8000867c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80008680:	0007879b          	sext.w	a5,a5
    80008684:	fe079ae3          	bnez	a5,80008678 <acquire+0x5c>
    80008688:	0ff0000f          	fence
    8000868c:	fffff097          	auipc	ra,0xfffff
    80008690:	8a0080e7          	jalr	-1888(ra) # 80006f2c <mycpu>
    80008694:	01813083          	ld	ra,24(sp)
    80008698:	01013403          	ld	s0,16(sp)
    8000869c:	00a4b823          	sd	a0,16(s1)
    800086a0:	00013903          	ld	s2,0(sp)
    800086a4:	00813483          	ld	s1,8(sp)
    800086a8:	02010113          	addi	sp,sp,32
    800086ac:	00008067          	ret
    800086b0:	0104b903          	ld	s2,16(s1)
    800086b4:	fffff097          	auipc	ra,0xfffff
    800086b8:	878080e7          	jalr	-1928(ra) # 80006f2c <mycpu>
    800086bc:	faa91ce3          	bne	s2,a0,80008674 <acquire+0x58>
    800086c0:	00001517          	auipc	a0,0x1
    800086c4:	27050513          	addi	a0,a0,624 # 80009930 <digits+0x20>
    800086c8:	fffff097          	auipc	ra,0xfffff
    800086cc:	224080e7          	jalr	548(ra) # 800078ec <panic>
    800086d0:	00195913          	srli	s2,s2,0x1
    800086d4:	fffff097          	auipc	ra,0xfffff
    800086d8:	858080e7          	jalr	-1960(ra) # 80006f2c <mycpu>
    800086dc:	00197913          	andi	s2,s2,1
    800086e0:	07252e23          	sw	s2,124(a0)
    800086e4:	f75ff06f          	j	80008658 <acquire+0x3c>

00000000800086e8 <release>:
    800086e8:	fe010113          	addi	sp,sp,-32
    800086ec:	00813823          	sd	s0,16(sp)
    800086f0:	00113c23          	sd	ra,24(sp)
    800086f4:	00913423          	sd	s1,8(sp)
    800086f8:	01213023          	sd	s2,0(sp)
    800086fc:	02010413          	addi	s0,sp,32
    80008700:	00052783          	lw	a5,0(a0)
    80008704:	00079a63          	bnez	a5,80008718 <release+0x30>
    80008708:	00001517          	auipc	a0,0x1
    8000870c:	23050513          	addi	a0,a0,560 # 80009938 <digits+0x28>
    80008710:	fffff097          	auipc	ra,0xfffff
    80008714:	1dc080e7          	jalr	476(ra) # 800078ec <panic>
    80008718:	01053903          	ld	s2,16(a0)
    8000871c:	00050493          	mv	s1,a0
    80008720:	fffff097          	auipc	ra,0xfffff
    80008724:	80c080e7          	jalr	-2036(ra) # 80006f2c <mycpu>
    80008728:	fea910e3          	bne	s2,a0,80008708 <release+0x20>
    8000872c:	0004b823          	sd	zero,16(s1)
    80008730:	0ff0000f          	fence
    80008734:	0f50000f          	fence	iorw,ow
    80008738:	0804a02f          	amoswap.w	zero,zero,(s1)
    8000873c:	ffffe097          	auipc	ra,0xffffe
    80008740:	7f0080e7          	jalr	2032(ra) # 80006f2c <mycpu>
    80008744:	100027f3          	csrr	a5,sstatus
    80008748:	0027f793          	andi	a5,a5,2
    8000874c:	04079a63          	bnez	a5,800087a0 <release+0xb8>
    80008750:	07852783          	lw	a5,120(a0)
    80008754:	02f05e63          	blez	a5,80008790 <release+0xa8>
    80008758:	fff7871b          	addiw	a4,a5,-1
    8000875c:	06e52c23          	sw	a4,120(a0)
    80008760:	00071c63          	bnez	a4,80008778 <release+0x90>
    80008764:	07c52783          	lw	a5,124(a0)
    80008768:	00078863          	beqz	a5,80008778 <release+0x90>
    8000876c:	100027f3          	csrr	a5,sstatus
    80008770:	0027e793          	ori	a5,a5,2
    80008774:	10079073          	csrw	sstatus,a5
    80008778:	01813083          	ld	ra,24(sp)
    8000877c:	01013403          	ld	s0,16(sp)
    80008780:	00813483          	ld	s1,8(sp)
    80008784:	00013903          	ld	s2,0(sp)
    80008788:	02010113          	addi	sp,sp,32
    8000878c:	00008067          	ret
    80008790:	00001517          	auipc	a0,0x1
    80008794:	1c850513          	addi	a0,a0,456 # 80009958 <digits+0x48>
    80008798:	fffff097          	auipc	ra,0xfffff
    8000879c:	154080e7          	jalr	340(ra) # 800078ec <panic>
    800087a0:	00001517          	auipc	a0,0x1
    800087a4:	1a050513          	addi	a0,a0,416 # 80009940 <digits+0x30>
    800087a8:	fffff097          	auipc	ra,0xfffff
    800087ac:	144080e7          	jalr	324(ra) # 800078ec <panic>

00000000800087b0 <holding>:
    800087b0:	00052783          	lw	a5,0(a0)
    800087b4:	00079663          	bnez	a5,800087c0 <holding+0x10>
    800087b8:	00000513          	li	a0,0
    800087bc:	00008067          	ret
    800087c0:	fe010113          	addi	sp,sp,-32
    800087c4:	00813823          	sd	s0,16(sp)
    800087c8:	00913423          	sd	s1,8(sp)
    800087cc:	00113c23          	sd	ra,24(sp)
    800087d0:	02010413          	addi	s0,sp,32
    800087d4:	01053483          	ld	s1,16(a0)
    800087d8:	ffffe097          	auipc	ra,0xffffe
    800087dc:	754080e7          	jalr	1876(ra) # 80006f2c <mycpu>
    800087e0:	01813083          	ld	ra,24(sp)
    800087e4:	01013403          	ld	s0,16(sp)
    800087e8:	40a48533          	sub	a0,s1,a0
    800087ec:	00153513          	seqz	a0,a0
    800087f0:	00813483          	ld	s1,8(sp)
    800087f4:	02010113          	addi	sp,sp,32
    800087f8:	00008067          	ret

00000000800087fc <push_off>:
    800087fc:	fe010113          	addi	sp,sp,-32
    80008800:	00813823          	sd	s0,16(sp)
    80008804:	00113c23          	sd	ra,24(sp)
    80008808:	00913423          	sd	s1,8(sp)
    8000880c:	02010413          	addi	s0,sp,32
    80008810:	100024f3          	csrr	s1,sstatus
    80008814:	100027f3          	csrr	a5,sstatus
    80008818:	ffd7f793          	andi	a5,a5,-3
    8000881c:	10079073          	csrw	sstatus,a5
    80008820:	ffffe097          	auipc	ra,0xffffe
    80008824:	70c080e7          	jalr	1804(ra) # 80006f2c <mycpu>
    80008828:	07852783          	lw	a5,120(a0)
    8000882c:	02078663          	beqz	a5,80008858 <push_off+0x5c>
    80008830:	ffffe097          	auipc	ra,0xffffe
    80008834:	6fc080e7          	jalr	1788(ra) # 80006f2c <mycpu>
    80008838:	07852783          	lw	a5,120(a0)
    8000883c:	01813083          	ld	ra,24(sp)
    80008840:	01013403          	ld	s0,16(sp)
    80008844:	0017879b          	addiw	a5,a5,1
    80008848:	06f52c23          	sw	a5,120(a0)
    8000884c:	00813483          	ld	s1,8(sp)
    80008850:	02010113          	addi	sp,sp,32
    80008854:	00008067          	ret
    80008858:	0014d493          	srli	s1,s1,0x1
    8000885c:	ffffe097          	auipc	ra,0xffffe
    80008860:	6d0080e7          	jalr	1744(ra) # 80006f2c <mycpu>
    80008864:	0014f493          	andi	s1,s1,1
    80008868:	06952e23          	sw	s1,124(a0)
    8000886c:	fc5ff06f          	j	80008830 <push_off+0x34>

0000000080008870 <pop_off>:
    80008870:	ff010113          	addi	sp,sp,-16
    80008874:	00813023          	sd	s0,0(sp)
    80008878:	00113423          	sd	ra,8(sp)
    8000887c:	01010413          	addi	s0,sp,16
    80008880:	ffffe097          	auipc	ra,0xffffe
    80008884:	6ac080e7          	jalr	1708(ra) # 80006f2c <mycpu>
    80008888:	100027f3          	csrr	a5,sstatus
    8000888c:	0027f793          	andi	a5,a5,2
    80008890:	04079663          	bnez	a5,800088dc <pop_off+0x6c>
    80008894:	07852783          	lw	a5,120(a0)
    80008898:	02f05a63          	blez	a5,800088cc <pop_off+0x5c>
    8000889c:	fff7871b          	addiw	a4,a5,-1
    800088a0:	06e52c23          	sw	a4,120(a0)
    800088a4:	00071c63          	bnez	a4,800088bc <pop_off+0x4c>
    800088a8:	07c52783          	lw	a5,124(a0)
    800088ac:	00078863          	beqz	a5,800088bc <pop_off+0x4c>
    800088b0:	100027f3          	csrr	a5,sstatus
    800088b4:	0027e793          	ori	a5,a5,2
    800088b8:	10079073          	csrw	sstatus,a5
    800088bc:	00813083          	ld	ra,8(sp)
    800088c0:	00013403          	ld	s0,0(sp)
    800088c4:	01010113          	addi	sp,sp,16
    800088c8:	00008067          	ret
    800088cc:	00001517          	auipc	a0,0x1
    800088d0:	08c50513          	addi	a0,a0,140 # 80009958 <digits+0x48>
    800088d4:	fffff097          	auipc	ra,0xfffff
    800088d8:	018080e7          	jalr	24(ra) # 800078ec <panic>
    800088dc:	00001517          	auipc	a0,0x1
    800088e0:	06450513          	addi	a0,a0,100 # 80009940 <digits+0x30>
    800088e4:	fffff097          	auipc	ra,0xfffff
    800088e8:	008080e7          	jalr	8(ra) # 800078ec <panic>

00000000800088ec <push_on>:
    800088ec:	fe010113          	addi	sp,sp,-32
    800088f0:	00813823          	sd	s0,16(sp)
    800088f4:	00113c23          	sd	ra,24(sp)
    800088f8:	00913423          	sd	s1,8(sp)
    800088fc:	02010413          	addi	s0,sp,32
    80008900:	100024f3          	csrr	s1,sstatus
    80008904:	100027f3          	csrr	a5,sstatus
    80008908:	0027e793          	ori	a5,a5,2
    8000890c:	10079073          	csrw	sstatus,a5
    80008910:	ffffe097          	auipc	ra,0xffffe
    80008914:	61c080e7          	jalr	1564(ra) # 80006f2c <mycpu>
    80008918:	07852783          	lw	a5,120(a0)
    8000891c:	02078663          	beqz	a5,80008948 <push_on+0x5c>
    80008920:	ffffe097          	auipc	ra,0xffffe
    80008924:	60c080e7          	jalr	1548(ra) # 80006f2c <mycpu>
    80008928:	07852783          	lw	a5,120(a0)
    8000892c:	01813083          	ld	ra,24(sp)
    80008930:	01013403          	ld	s0,16(sp)
    80008934:	0017879b          	addiw	a5,a5,1
    80008938:	06f52c23          	sw	a5,120(a0)
    8000893c:	00813483          	ld	s1,8(sp)
    80008940:	02010113          	addi	sp,sp,32
    80008944:	00008067          	ret
    80008948:	0014d493          	srli	s1,s1,0x1
    8000894c:	ffffe097          	auipc	ra,0xffffe
    80008950:	5e0080e7          	jalr	1504(ra) # 80006f2c <mycpu>
    80008954:	0014f493          	andi	s1,s1,1
    80008958:	06952e23          	sw	s1,124(a0)
    8000895c:	fc5ff06f          	j	80008920 <push_on+0x34>

0000000080008960 <pop_on>:
    80008960:	ff010113          	addi	sp,sp,-16
    80008964:	00813023          	sd	s0,0(sp)
    80008968:	00113423          	sd	ra,8(sp)
    8000896c:	01010413          	addi	s0,sp,16
    80008970:	ffffe097          	auipc	ra,0xffffe
    80008974:	5bc080e7          	jalr	1468(ra) # 80006f2c <mycpu>
    80008978:	100027f3          	csrr	a5,sstatus
    8000897c:	0027f793          	andi	a5,a5,2
    80008980:	04078463          	beqz	a5,800089c8 <pop_on+0x68>
    80008984:	07852783          	lw	a5,120(a0)
    80008988:	02f05863          	blez	a5,800089b8 <pop_on+0x58>
    8000898c:	fff7879b          	addiw	a5,a5,-1
    80008990:	06f52c23          	sw	a5,120(a0)
    80008994:	07853783          	ld	a5,120(a0)
    80008998:	00079863          	bnez	a5,800089a8 <pop_on+0x48>
    8000899c:	100027f3          	csrr	a5,sstatus
    800089a0:	ffd7f793          	andi	a5,a5,-3
    800089a4:	10079073          	csrw	sstatus,a5
    800089a8:	00813083          	ld	ra,8(sp)
    800089ac:	00013403          	ld	s0,0(sp)
    800089b0:	01010113          	addi	sp,sp,16
    800089b4:	00008067          	ret
    800089b8:	00001517          	auipc	a0,0x1
    800089bc:	fc850513          	addi	a0,a0,-56 # 80009980 <digits+0x70>
    800089c0:	fffff097          	auipc	ra,0xfffff
    800089c4:	f2c080e7          	jalr	-212(ra) # 800078ec <panic>
    800089c8:	00001517          	auipc	a0,0x1
    800089cc:	f9850513          	addi	a0,a0,-104 # 80009960 <digits+0x50>
    800089d0:	fffff097          	auipc	ra,0xfffff
    800089d4:	f1c080e7          	jalr	-228(ra) # 800078ec <panic>

00000000800089d8 <__memset>:
    800089d8:	ff010113          	addi	sp,sp,-16
    800089dc:	00813423          	sd	s0,8(sp)
    800089e0:	01010413          	addi	s0,sp,16
    800089e4:	1a060e63          	beqz	a2,80008ba0 <__memset+0x1c8>
    800089e8:	40a007b3          	neg	a5,a0
    800089ec:	0077f793          	andi	a5,a5,7
    800089f0:	00778693          	addi	a3,a5,7
    800089f4:	00b00813          	li	a6,11
    800089f8:	0ff5f593          	andi	a1,a1,255
    800089fc:	fff6071b          	addiw	a4,a2,-1
    80008a00:	1b06e663          	bltu	a3,a6,80008bac <__memset+0x1d4>
    80008a04:	1cd76463          	bltu	a4,a3,80008bcc <__memset+0x1f4>
    80008a08:	1a078e63          	beqz	a5,80008bc4 <__memset+0x1ec>
    80008a0c:	00b50023          	sb	a1,0(a0)
    80008a10:	00100713          	li	a4,1
    80008a14:	1ae78463          	beq	a5,a4,80008bbc <__memset+0x1e4>
    80008a18:	00b500a3          	sb	a1,1(a0)
    80008a1c:	00200713          	li	a4,2
    80008a20:	1ae78a63          	beq	a5,a4,80008bd4 <__memset+0x1fc>
    80008a24:	00b50123          	sb	a1,2(a0)
    80008a28:	00300713          	li	a4,3
    80008a2c:	18e78463          	beq	a5,a4,80008bb4 <__memset+0x1dc>
    80008a30:	00b501a3          	sb	a1,3(a0)
    80008a34:	00400713          	li	a4,4
    80008a38:	1ae78263          	beq	a5,a4,80008bdc <__memset+0x204>
    80008a3c:	00b50223          	sb	a1,4(a0)
    80008a40:	00500713          	li	a4,5
    80008a44:	1ae78063          	beq	a5,a4,80008be4 <__memset+0x20c>
    80008a48:	00b502a3          	sb	a1,5(a0)
    80008a4c:	00700713          	li	a4,7
    80008a50:	18e79e63          	bne	a5,a4,80008bec <__memset+0x214>
    80008a54:	00b50323          	sb	a1,6(a0)
    80008a58:	00700e93          	li	t4,7
    80008a5c:	00859713          	slli	a4,a1,0x8
    80008a60:	00e5e733          	or	a4,a1,a4
    80008a64:	01059e13          	slli	t3,a1,0x10
    80008a68:	01c76e33          	or	t3,a4,t3
    80008a6c:	01859313          	slli	t1,a1,0x18
    80008a70:	006e6333          	or	t1,t3,t1
    80008a74:	02059893          	slli	a7,a1,0x20
    80008a78:	40f60e3b          	subw	t3,a2,a5
    80008a7c:	011368b3          	or	a7,t1,a7
    80008a80:	02859813          	slli	a6,a1,0x28
    80008a84:	0108e833          	or	a6,a7,a6
    80008a88:	03059693          	slli	a3,a1,0x30
    80008a8c:	003e589b          	srliw	a7,t3,0x3
    80008a90:	00d866b3          	or	a3,a6,a3
    80008a94:	03859713          	slli	a4,a1,0x38
    80008a98:	00389813          	slli	a6,a7,0x3
    80008a9c:	00f507b3          	add	a5,a0,a5
    80008aa0:	00e6e733          	or	a4,a3,a4
    80008aa4:	000e089b          	sext.w	a7,t3
    80008aa8:	00f806b3          	add	a3,a6,a5
    80008aac:	00e7b023          	sd	a4,0(a5)
    80008ab0:	00878793          	addi	a5,a5,8
    80008ab4:	fed79ce3          	bne	a5,a3,80008aac <__memset+0xd4>
    80008ab8:	ff8e7793          	andi	a5,t3,-8
    80008abc:	0007871b          	sext.w	a4,a5
    80008ac0:	01d787bb          	addw	a5,a5,t4
    80008ac4:	0ce88e63          	beq	a7,a4,80008ba0 <__memset+0x1c8>
    80008ac8:	00f50733          	add	a4,a0,a5
    80008acc:	00b70023          	sb	a1,0(a4)
    80008ad0:	0017871b          	addiw	a4,a5,1
    80008ad4:	0cc77663          	bgeu	a4,a2,80008ba0 <__memset+0x1c8>
    80008ad8:	00e50733          	add	a4,a0,a4
    80008adc:	00b70023          	sb	a1,0(a4)
    80008ae0:	0027871b          	addiw	a4,a5,2
    80008ae4:	0ac77e63          	bgeu	a4,a2,80008ba0 <__memset+0x1c8>
    80008ae8:	00e50733          	add	a4,a0,a4
    80008aec:	00b70023          	sb	a1,0(a4)
    80008af0:	0037871b          	addiw	a4,a5,3
    80008af4:	0ac77663          	bgeu	a4,a2,80008ba0 <__memset+0x1c8>
    80008af8:	00e50733          	add	a4,a0,a4
    80008afc:	00b70023          	sb	a1,0(a4)
    80008b00:	0047871b          	addiw	a4,a5,4
    80008b04:	08c77e63          	bgeu	a4,a2,80008ba0 <__memset+0x1c8>
    80008b08:	00e50733          	add	a4,a0,a4
    80008b0c:	00b70023          	sb	a1,0(a4)
    80008b10:	0057871b          	addiw	a4,a5,5
    80008b14:	08c77663          	bgeu	a4,a2,80008ba0 <__memset+0x1c8>
    80008b18:	00e50733          	add	a4,a0,a4
    80008b1c:	00b70023          	sb	a1,0(a4)
    80008b20:	0067871b          	addiw	a4,a5,6
    80008b24:	06c77e63          	bgeu	a4,a2,80008ba0 <__memset+0x1c8>
    80008b28:	00e50733          	add	a4,a0,a4
    80008b2c:	00b70023          	sb	a1,0(a4)
    80008b30:	0077871b          	addiw	a4,a5,7
    80008b34:	06c77663          	bgeu	a4,a2,80008ba0 <__memset+0x1c8>
    80008b38:	00e50733          	add	a4,a0,a4
    80008b3c:	00b70023          	sb	a1,0(a4)
    80008b40:	0087871b          	addiw	a4,a5,8
    80008b44:	04c77e63          	bgeu	a4,a2,80008ba0 <__memset+0x1c8>
    80008b48:	00e50733          	add	a4,a0,a4
    80008b4c:	00b70023          	sb	a1,0(a4)
    80008b50:	0097871b          	addiw	a4,a5,9
    80008b54:	04c77663          	bgeu	a4,a2,80008ba0 <__memset+0x1c8>
    80008b58:	00e50733          	add	a4,a0,a4
    80008b5c:	00b70023          	sb	a1,0(a4)
    80008b60:	00a7871b          	addiw	a4,a5,10
    80008b64:	02c77e63          	bgeu	a4,a2,80008ba0 <__memset+0x1c8>
    80008b68:	00e50733          	add	a4,a0,a4
    80008b6c:	00b70023          	sb	a1,0(a4)
    80008b70:	00b7871b          	addiw	a4,a5,11
    80008b74:	02c77663          	bgeu	a4,a2,80008ba0 <__memset+0x1c8>
    80008b78:	00e50733          	add	a4,a0,a4
    80008b7c:	00b70023          	sb	a1,0(a4)
    80008b80:	00c7871b          	addiw	a4,a5,12
    80008b84:	00c77e63          	bgeu	a4,a2,80008ba0 <__memset+0x1c8>
    80008b88:	00e50733          	add	a4,a0,a4
    80008b8c:	00b70023          	sb	a1,0(a4)
    80008b90:	00d7879b          	addiw	a5,a5,13
    80008b94:	00c7f663          	bgeu	a5,a2,80008ba0 <__memset+0x1c8>
    80008b98:	00f507b3          	add	a5,a0,a5
    80008b9c:	00b78023          	sb	a1,0(a5)
    80008ba0:	00813403          	ld	s0,8(sp)
    80008ba4:	01010113          	addi	sp,sp,16
    80008ba8:	00008067          	ret
    80008bac:	00b00693          	li	a3,11
    80008bb0:	e55ff06f          	j	80008a04 <__memset+0x2c>
    80008bb4:	00300e93          	li	t4,3
    80008bb8:	ea5ff06f          	j	80008a5c <__memset+0x84>
    80008bbc:	00100e93          	li	t4,1
    80008bc0:	e9dff06f          	j	80008a5c <__memset+0x84>
    80008bc4:	00000e93          	li	t4,0
    80008bc8:	e95ff06f          	j	80008a5c <__memset+0x84>
    80008bcc:	00000793          	li	a5,0
    80008bd0:	ef9ff06f          	j	80008ac8 <__memset+0xf0>
    80008bd4:	00200e93          	li	t4,2
    80008bd8:	e85ff06f          	j	80008a5c <__memset+0x84>
    80008bdc:	00400e93          	li	t4,4
    80008be0:	e7dff06f          	j	80008a5c <__memset+0x84>
    80008be4:	00500e93          	li	t4,5
    80008be8:	e75ff06f          	j	80008a5c <__memset+0x84>
    80008bec:	00600e93          	li	t4,6
    80008bf0:	e6dff06f          	j	80008a5c <__memset+0x84>

0000000080008bf4 <__memmove>:
    80008bf4:	ff010113          	addi	sp,sp,-16
    80008bf8:	00813423          	sd	s0,8(sp)
    80008bfc:	01010413          	addi	s0,sp,16
    80008c00:	0e060863          	beqz	a2,80008cf0 <__memmove+0xfc>
    80008c04:	fff6069b          	addiw	a3,a2,-1
    80008c08:	0006881b          	sext.w	a6,a3
    80008c0c:	0ea5e863          	bltu	a1,a0,80008cfc <__memmove+0x108>
    80008c10:	00758713          	addi	a4,a1,7
    80008c14:	00a5e7b3          	or	a5,a1,a0
    80008c18:	40a70733          	sub	a4,a4,a0
    80008c1c:	0077f793          	andi	a5,a5,7
    80008c20:	00f73713          	sltiu	a4,a4,15
    80008c24:	00174713          	xori	a4,a4,1
    80008c28:	0017b793          	seqz	a5,a5
    80008c2c:	00e7f7b3          	and	a5,a5,a4
    80008c30:	10078863          	beqz	a5,80008d40 <__memmove+0x14c>
    80008c34:	00900793          	li	a5,9
    80008c38:	1107f463          	bgeu	a5,a6,80008d40 <__memmove+0x14c>
    80008c3c:	0036581b          	srliw	a6,a2,0x3
    80008c40:	fff8081b          	addiw	a6,a6,-1
    80008c44:	02081813          	slli	a6,a6,0x20
    80008c48:	01d85893          	srli	a7,a6,0x1d
    80008c4c:	00858813          	addi	a6,a1,8
    80008c50:	00058793          	mv	a5,a1
    80008c54:	00050713          	mv	a4,a0
    80008c58:	01088833          	add	a6,a7,a6
    80008c5c:	0007b883          	ld	a7,0(a5)
    80008c60:	00878793          	addi	a5,a5,8
    80008c64:	00870713          	addi	a4,a4,8
    80008c68:	ff173c23          	sd	a7,-8(a4)
    80008c6c:	ff0798e3          	bne	a5,a6,80008c5c <__memmove+0x68>
    80008c70:	ff867713          	andi	a4,a2,-8
    80008c74:	02071793          	slli	a5,a4,0x20
    80008c78:	0207d793          	srli	a5,a5,0x20
    80008c7c:	00f585b3          	add	a1,a1,a5
    80008c80:	40e686bb          	subw	a3,a3,a4
    80008c84:	00f507b3          	add	a5,a0,a5
    80008c88:	06e60463          	beq	a2,a4,80008cf0 <__memmove+0xfc>
    80008c8c:	0005c703          	lbu	a4,0(a1)
    80008c90:	00e78023          	sb	a4,0(a5)
    80008c94:	04068e63          	beqz	a3,80008cf0 <__memmove+0xfc>
    80008c98:	0015c603          	lbu	a2,1(a1)
    80008c9c:	00100713          	li	a4,1
    80008ca0:	00c780a3          	sb	a2,1(a5)
    80008ca4:	04e68663          	beq	a3,a4,80008cf0 <__memmove+0xfc>
    80008ca8:	0025c603          	lbu	a2,2(a1)
    80008cac:	00200713          	li	a4,2
    80008cb0:	00c78123          	sb	a2,2(a5)
    80008cb4:	02e68e63          	beq	a3,a4,80008cf0 <__memmove+0xfc>
    80008cb8:	0035c603          	lbu	a2,3(a1)
    80008cbc:	00300713          	li	a4,3
    80008cc0:	00c781a3          	sb	a2,3(a5)
    80008cc4:	02e68663          	beq	a3,a4,80008cf0 <__memmove+0xfc>
    80008cc8:	0045c603          	lbu	a2,4(a1)
    80008ccc:	00400713          	li	a4,4
    80008cd0:	00c78223          	sb	a2,4(a5)
    80008cd4:	00e68e63          	beq	a3,a4,80008cf0 <__memmove+0xfc>
    80008cd8:	0055c603          	lbu	a2,5(a1)
    80008cdc:	00500713          	li	a4,5
    80008ce0:	00c782a3          	sb	a2,5(a5)
    80008ce4:	00e68663          	beq	a3,a4,80008cf0 <__memmove+0xfc>
    80008ce8:	0065c703          	lbu	a4,6(a1)
    80008cec:	00e78323          	sb	a4,6(a5)
    80008cf0:	00813403          	ld	s0,8(sp)
    80008cf4:	01010113          	addi	sp,sp,16
    80008cf8:	00008067          	ret
    80008cfc:	02061713          	slli	a4,a2,0x20
    80008d00:	02075713          	srli	a4,a4,0x20
    80008d04:	00e587b3          	add	a5,a1,a4
    80008d08:	f0f574e3          	bgeu	a0,a5,80008c10 <__memmove+0x1c>
    80008d0c:	02069613          	slli	a2,a3,0x20
    80008d10:	02065613          	srli	a2,a2,0x20
    80008d14:	fff64613          	not	a2,a2
    80008d18:	00e50733          	add	a4,a0,a4
    80008d1c:	00c78633          	add	a2,a5,a2
    80008d20:	fff7c683          	lbu	a3,-1(a5)
    80008d24:	fff78793          	addi	a5,a5,-1
    80008d28:	fff70713          	addi	a4,a4,-1
    80008d2c:	00d70023          	sb	a3,0(a4)
    80008d30:	fec798e3          	bne	a5,a2,80008d20 <__memmove+0x12c>
    80008d34:	00813403          	ld	s0,8(sp)
    80008d38:	01010113          	addi	sp,sp,16
    80008d3c:	00008067          	ret
    80008d40:	02069713          	slli	a4,a3,0x20
    80008d44:	02075713          	srli	a4,a4,0x20
    80008d48:	00170713          	addi	a4,a4,1
    80008d4c:	00e50733          	add	a4,a0,a4
    80008d50:	00050793          	mv	a5,a0
    80008d54:	0005c683          	lbu	a3,0(a1)
    80008d58:	00178793          	addi	a5,a5,1
    80008d5c:	00158593          	addi	a1,a1,1
    80008d60:	fed78fa3          	sb	a3,-1(a5)
    80008d64:	fee798e3          	bne	a5,a4,80008d54 <__memmove+0x160>
    80008d68:	f89ff06f          	j	80008cf0 <__memmove+0xfc>
	...
