
synos:     file format elf64-x86-64


Disassembly of section .text:

0000000000100000 <__KERN_CODE_START>:
  100000:	66 b8 00 00          	mov    ax,0x0
  100004:	8e d0                	mov    ss,eax
  100006:	8e d8                	mov    ds,eax
  100008:	8e c0                	mov    es,eax
  10000a:	8e e0                	mov    fs,eax
  10000c:	8e e8                	mov    gs,eax
  10000e:	48 31 ed             	xor    rbp,rbp
  100011:	e8 14 28 00 00       	call   10282a <startup>
  100016:	f4                   	hlt    
  100017:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
  10001e:	00 00 

0000000000100020 <_start>:
  100020:	bc 00 30 12 00       	mov    esp,0x123000
  100025:	a3 d4 60 10 00 89 1d 	movabs ds:0x60d01d89001060d4,eax
  10002c:	d0 60 
  10002e:	10 00                	adc    BYTE PTR [rax],al
  100030:	e8 41 00 00 00       	call   100076 <_CPUID_enabled32>
  100035:	e8 13 00 00 00       	call   10004d <_ISX64_32>
  10003a:	e8 5d 00 00 00       	call   10009c <_64INIT>
  10003f:	0f 01 15 c4 60 10 00 	lgdt   [rip+0x1060c4]        # 20610a <__KERN_MEM_END+0xdb10a>
  100046:	ea                   	(bad)  
  100047:	00 00                	add    BYTE PTR [rax],al
  100049:	10 00                	adc    BYTE PTR [rax],al
  10004b:	08 00                	or     BYTE PTR [rax],al

000000000010004d <_ISX64_32>:
  10004d:	b8 00 00 00 80       	mov    eax,0x80000000
  100052:	0f a2                	cpuid  
  100054:	3d 01 00 00 80       	cmp    eax,0x80000001
  100059:	72 10                	jb     10006b <_ISX64_32.no_long_mode>
  10005b:	b8 01 00 00 80       	mov    eax,0x80000001
  100060:	0f a2                	cpuid  
  100062:	f7 c2 00 00 00 20    	test   edx,0x20000000
  100068:	74 01                	je     10006b <_ISX64_32.no_long_mode>
  10006a:	c3                   	ret    

000000000010006b <_ISX64_32.no_long_mode>:
  10006b:	be 3f 60 10 00       	mov    esi,0x10603f
  100070:	e8 d0 00 00 00       	call   100145 <_print>
  100075:	f4                   	hlt    

0000000000100076 <_CPUID_enabled32>:
  100076:	9c                   	pushf  
  100077:	9c                   	pushf  
  100078:	81 34 24 00 00 20 00 	xor    DWORD PTR [rsp],0x200000
  10007f:	9d                   	popf   
  100080:	9c                   	pushf  
  100081:	58                   	pop    rax
  100082:	33 04 24             	xor    eax,DWORD PTR [rsp]
  100085:	9d                   	popf   
  100086:	25 00 00 20 00       	and    eax,0x200000
  10008b:	83 f8 00             	cmp    eax,0x0
  10008e:	74 01                	je     100091 <_CPUID_enabled32.no_CPUID>
  100090:	c3                   	ret    

0000000000100091 <_CPUID_enabled32.no_CPUID>:
  100091:	be 0c 60 10 00       	mov    esi,0x10600c
  100096:	e8 aa 00 00 00       	call   100145 <_print>
  10009b:	f4                   	hlt    

000000000010009c <_64INIT>:
  10009c:	b8 00 40 12 00       	mov    eax,0x124000
  1000a1:	83 c8 03             	or     eax,0x3
  1000a4:	a3 00 30 12 00 b8 00 	movabs ds:0x125000b800123000,eax
  1000ab:	50 12 
  1000ad:	00 83 c8 03 a3 00    	add    BYTE PTR [rbx+0xa303c8],al
  1000b3:	40 12 00             	adc    al,BYTE PTR [rax]
  1000b6:	31 c9                	xor    ecx,ecx

00000000001000b8 <_64INIT.loop>:
  1000b8:	b8 00 00 20 00       	mov    eax,0x200000
  1000bd:	f7 e1                	mul    ecx
  1000bf:	0d 83 00 00 00       	or     eax,0x83
  1000c4:	89 04 cd 00 50 12 00 	mov    DWORD PTR [rcx*8+0x125000],eax
  1000cb:	41 81 f9 00 02 00 00 	cmp    r9d,0x200
  1000d2:	75 e4                	jne    1000b8 <_64INIT.loop>
  1000d4:	b8 00 30 12 00       	mov    eax,0x123000
  1000d9:	0f 22 d8             	mov    cr3,rax
  1000dc:	0f 20 e0             	mov    rax,cr4
  1000df:	83 c8 20             	or     eax,0x20
  1000e2:	0f 22 e0             	mov    cr4,rax
  1000e5:	b9 80 00 00 c0       	mov    ecx,0xc0000080
  1000ea:	0f 32                	rdmsr  
  1000ec:	0d 00 01 00 00       	or     eax,0x100
  1000f1:	0f 30                	wrmsr  
  1000f3:	0f 20 c0             	mov    rax,cr0
  1000f6:	0d 00 00 00 80       	or     eax,0x80000000
  1000fb:	0f 22 c0             	mov    cr0,rax
  1000fe:	c3                   	ret    

00000000001000ff <_setCursorPos>:
  1000ff:	50                   	push   rax
  100100:	53                   	push   rbx
  100101:	51                   	push   rcx
  100102:	a3 04 60 10 00 89 1d 	movabs ds:0x60081d8900106004,eax
  100109:	08 60 
  10010b:	10 00                	adc    BYTE PTR [rax],al
  10010d:	93                   	xchg   ebx,eax
  10010e:	b9 50 00 00 00       	mov    ecx,0x50
  100113:	f7 e1                	mul    ecx
  100115:	01 d8                	add    eax,ebx
  100117:	b9 02 00 00 00       	mov    ecx,0x2
  10011c:	f7 e1                	mul    ecx
  10011e:	a3 00 60 10 00 59 5b 	movabs ds:0xc3585b5900106000,eax
  100125:	58 c3 

0000000000100127 <_XY_calc>:
  100127:	50                   	push   rax
  100128:	52                   	push   rdx
  100129:	51                   	push   rcx
  10012a:	a1 00 60 10 00 b9 50 	movabs eax,ds:0x50b900106000
  100131:	00 00 
  100133:	00 f7                	add    bh,dh
  100135:	f1                   	icebp  
  100136:	89 15 04 60 10 00    	mov    DWORD PTR [rip+0x106004],edx        # 206140 <__KERN_MEM_END+0xdb140>
  10013c:	a3 08 60 10 00 59 5a 	movabs ds:0xc3585a5900106008,eax
  100143:	58 c3 

0000000000100145 <_print>:
  100145:	53                   	push   rbx
  100146:	56                   	push   rsi
  100147:	50                   	push   rax
  100148:	51                   	push   rcx
  100149:	bb 00 80 0b 00       	mov    ebx,0xb8000
  10014e:	8b 0d 00 60 10 00    	mov    ecx,DWORD PTR [rip+0x106000]        # 206154 <__KERN_MEM_END+0xdb154>
  100154:	01 cb                	add    ebx,ecx

0000000000100156 <_print.loop>:
  100156:	ac                   	lods   al,BYTE PTR ds:[rsi]
  100157:	3c 00                	cmp    al,0x0
  100159:	74 40                	je     10019b <_print.done>
  10015b:	3c 0a                	cmp    al,0xa
  10015d:	74 1e                	je     10017d <_print.jmp_line>
  10015f:	b4 0f                	mov    ah,0xf
  100161:	66 89 03             	mov    WORD PTR [rbx],ax
  100164:	83 c3 02             	add    ebx,0x2
  100167:	8b 0d 00 60 10 00    	mov    ecx,DWORD PTR [rip+0x106000]        # 20616d <__KERN_MEM_END+0xdb16d>
  10016d:	83 c1 02             	add    ecx,0x2
  100170:	89 0d 00 60 10 00    	mov    DWORD PTR [rip+0x106000],ecx        # 206176 <__KERN_MEM_END+0xdb176>
  100176:	e8 ac ff ff ff       	call   100127 <_XY_calc>
  10017b:	eb d9                	jmp    100156 <_print.loop>

000000000010017d <_print.jmp_line>:
  10017d:	50                   	push   rax
  10017e:	53                   	push   rbx
  10017f:	e8 a3 ff ff ff       	call   100127 <_XY_calc>
  100184:	a1 04 60 10 00 8b 1d 	movabs eax,ds:0x60081d8b00106004
  10018b:	08 60 
  10018d:	10 00                	adc    BYTE PTR [rax],al
  10018f:	83 c3 01             	add    ebx,0x1
  100192:	e8 68 ff ff ff       	call   1000ff <_setCursorPos>
  100197:	5b                   	pop    rbx
  100198:	58                   	pop    rax
  100199:	eb bb                	jmp    100156 <_print.loop>

000000000010019b <_print.done>:
  10019b:	59                   	pop    rcx
  10019c:	58                   	pop    rax
  10019d:	5e                   	pop    rsi
  10019e:	5b                   	pop    rbx
  10019f:	c3                   	ret    

00000000001001a0 <port_compare_exchange>:
  1001a0:	55                   	push   rbp
  1001a1:	48 89 e5             	mov    rbp,rsp
  1001a4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
  1001a8:	89 f1                	mov    ecx,esi
  1001aa:	89 d0                	mov    eax,edx
  1001ac:	89 ca                	mov    edx,ecx
  1001ae:	88 55 f4             	mov    BYTE PTR [rbp-0xc],dl
  1001b1:	88 45 f0             	mov    BYTE PTR [rbp-0x10],al
  1001b4:	0f b6 45 f0          	movzx  eax,BYTE PTR [rbp-0x10]
  1001b8:	0f b6 c8             	movzx  ecx,al
  1001bb:	48 8b 75 f8          	mov    rsi,QWORD PTR [rbp-0x8]
  1001bf:	48 8d 55 f4          	lea    rdx,[rbp-0xc]
  1001c3:	0f b6 02             	movzx  eax,BYTE PTR [rdx]
  1001c6:	f0 0f b0 0e          	lock cmpxchg BYTE PTR [rsi],cl
  1001ca:	89 c1                	mov    ecx,eax
  1001cc:	0f 94 c0             	sete   al
  1001cf:	84 c0                	test   al,al
  1001d1:	75 02                	jne    1001d5 <port_compare_exchange+0x35>
  1001d3:	88 0a                	mov    BYTE PTR [rdx],cl
  1001d5:	0f b6 c0             	movzx  eax,al
  1001d8:	5d                   	pop    rbp
  1001d9:	c3                   	ret    

00000000001001da <port_store>:
  1001da:	55                   	push   rbp
  1001db:	48 89 e5             	mov    rbp,rsp
  1001de:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
  1001e2:	89 f0                	mov    eax,esi
  1001e4:	88 45 f4             	mov    BYTE PTR [rbp-0xc],al
  1001e7:	0f b6 45 f4          	movzx  eax,BYTE PTR [rbp-0xc]
  1001eb:	0f b6 d0             	movzx  edx,al
  1001ee:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1001f2:	88 10                	mov    BYTE PTR [rax],dl
  1001f4:	0f ae f0             	mfence 
  1001f7:	90                   	nop
  1001f8:	5d                   	pop    rbp
  1001f9:	c3                   	ret    

00000000001001fa <initPorts>:
  1001fa:	55                   	push   rbp
  1001fb:	48 89 e5             	mov    rbp,rsp
  1001fe:	c7 45 fc 00 00 00 00 	mov    DWORD PTR [rbp-0x4],0x0
  100205:	eb 14                	jmp    10021b <initPorts+0x21>
  100207:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  10020a:	48 98                	cdqe   
  10020c:	48 8d 15 2d be 00 00 	lea    rdx,[rip+0xbe2d]        # 10c040 <portLocked>
  100213:	c6 04 10 00          	mov    BYTE PTR [rax+rdx*1],0x0
  100217:	83 45 fc 01          	add    DWORD PTR [rbp-0x4],0x1
  10021b:	81 7d fc ff ff 00 00 	cmp    DWORD PTR [rbp-0x4],0xffff
  100222:	7e e3                	jle    100207 <initPorts+0xd>
  100224:	c6 05 d5 5d 02 00 01 	mov    BYTE PTR [rip+0x25dd5],0x1        # 126000 <portInit>
  10022b:	90                   	nop
  10022c:	5d                   	pop    rbp
  10022d:	c3                   	ret    

000000000010022e <port_lock>:
  10022e:	55                   	push   rbp
  10022f:	48 89 e5             	mov    rbp,rsp
  100232:	48 83 ec 08          	sub    rsp,0x8
  100236:	89 7d fc             	mov    DWORD PTR [rbp-0x4],edi
  100239:	0f b6 05 c0 5d 02 00 	movzx  eax,BYTE PTR [rip+0x25dc0]        # 126000 <portInit>
  100240:	84 c0                	test   al,al
  100242:	75 0a                	jne    10024e <port_lock+0x20>
  100244:	b8 00 00 00 00       	mov    eax,0x0
  100249:	e8 ac ff ff ff       	call   1001fa <initPorts>
  10024e:	90                   	nop
  10024f:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  100252:	48 8d 15 e7 bd 00 00 	lea    rdx,[rip+0xbde7]        # 10c040 <portLocked>
  100259:	48 01 d0             	add    rax,rdx
  10025c:	ba 01 00 00 00       	mov    edx,0x1
  100261:	be 00 00 00 00       	mov    esi,0x0
  100266:	48 89 c7             	mov    rdi,rax
  100269:	e8 32 ff ff ff       	call   1001a0 <port_compare_exchange>
  10026e:	85 c0                	test   eax,eax
  100270:	74 dd                	je     10024f <port_lock+0x21>
  100272:	90                   	nop
  100273:	90                   	nop
  100274:	c9                   	leave  
  100275:	c3                   	ret    

0000000000100276 <port_unlock>:
  100276:	55                   	push   rbp
  100277:	48 89 e5             	mov    rbp,rsp
  10027a:	48 83 ec 08          	sub    rsp,0x8
  10027e:	89 7d fc             	mov    DWORD PTR [rbp-0x4],edi
  100281:	0f b6 05 78 5d 02 00 	movzx  eax,BYTE PTR [rip+0x25d78]        # 126000 <portInit>
  100288:	84 c0                	test   al,al
  10028a:	75 0a                	jne    100296 <port_unlock+0x20>
  10028c:	b8 00 00 00 00       	mov    eax,0x0
  100291:	e8 64 ff ff ff       	call   1001fa <initPorts>
  100296:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  100299:	48 8d 15 a0 bd 00 00 	lea    rdx,[rip+0xbda0]        # 10c040 <portLocked>
  1002a0:	48 01 d0             	add    rax,rdx
  1002a3:	be 00 00 00 00       	mov    esi,0x0
  1002a8:	48 89 c7             	mov    rdi,rax
  1002ab:	e8 2a ff ff ff       	call   1001da <port_store>
  1002b0:	90                   	nop
  1002b1:	c9                   	leave  
  1002b2:	c3                   	ret    

00000000001002b3 <inb>:
  1002b3:	55                   	push   rbp
  1002b4:	48 89 e5             	mov    rbp,rsp
  1002b7:	48 83 ec 18          	sub    rsp,0x18
  1002bb:	89 7d ec             	mov    DWORD PTR [rbp-0x14],edi
  1002be:	8b 45 ec             	mov    eax,DWORD PTR [rbp-0x14]
  1002c1:	89 c7                	mov    edi,eax
  1002c3:	e8 66 ff ff ff       	call   10022e <port_lock>
  1002c8:	8b 45 ec             	mov    eax,DWORD PTR [rbp-0x14]
  1002cb:	ec                   	in     al,dx
  1002cc:	88 45 ff             	mov    BYTE PTR [rbp-0x1],al
  1002cf:	8b 45 ec             	mov    eax,DWORD PTR [rbp-0x14]
  1002d2:	89 c7                	mov    edi,eax
  1002d4:	e8 9d ff ff ff       	call   100276 <port_unlock>
  1002d9:	0f b6 45 ff          	movzx  eax,BYTE PTR [rbp-0x1]
  1002dd:	c9                   	leave  
  1002de:	c3                   	ret    

00000000001002df <outb>:
  1002df:	55                   	push   rbp
  1002e0:	48 89 e5             	mov    rbp,rsp
  1002e3:	48 83 ec 08          	sub    rsp,0x8
  1002e7:	89 7d fc             	mov    DWORD PTR [rbp-0x4],edi
  1002ea:	89 f0                	mov    eax,esi
  1002ec:	88 45 f8             	mov    BYTE PTR [rbp-0x8],al
  1002ef:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  1002f2:	89 c7                	mov    edi,eax
  1002f4:	e8 35 ff ff ff       	call   10022e <port_lock>
  1002f9:	8b 55 fc             	mov    edx,DWORD PTR [rbp-0x4]
  1002fc:	0f b6 45 f8          	movzx  eax,BYTE PTR [rbp-0x8]
  100300:	ee                   	out    dx,al
  100301:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  100304:	89 c7                	mov    edi,eax
  100306:	e8 6b ff ff ff       	call   100276 <port_unlock>
  10030b:	90                   	nop
  10030c:	c9                   	leave  
  10030d:	c3                   	ret    

000000000010030e <io_wait>:
  10030e:	55                   	push   rbp
  10030f:	48 89 e5             	mov    rbp,rsp
  100312:	bf 80 00 00 00       	mov    edi,0x80
  100317:	e8 12 ff ff ff       	call   10022e <port_lock>
  10031c:	ba 80 00 00 00       	mov    edx,0x80
  100321:	b8 00 00 00 00       	mov    eax,0x0
  100326:	ee                   	out    dx,al
  100327:	bf 80 00 00 00       	mov    edi,0x80
  10032c:	e8 45 ff ff ff       	call   100276 <port_unlock>
  100331:	90                   	nop
  100332:	5d                   	pop    rbp
  100333:	c3                   	ret    

0000000000100334 <getCPUINFO>:
  100334:	55                   	push   rbp
  100335:	48 89 e5             	mov    rbp,rsp
  100338:	48 83 ec 30          	sub    rsp,0x30
  10033c:	48 89 7d d8          	mov    QWORD PTR [rbp-0x28],rdi
  100340:	b8 00 00 00 00       	mov    eax,0x0
  100345:	e8 e6 04 00 00       	call   100830 <CPUID_enabled>
  10034a:	48 85 c0             	test   rax,rax
  10034d:	75 10                	jne    10035f <getCPUINFO+0x2b>
  10034f:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  100353:	c6 00 00             	mov    BYTE PTR [rax],0x0
  100356:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  10035a:	e9 86 04 00 00       	jmp    1007e5 <getCPUINFO+0x4b1>
  10035f:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  100363:	c6 00 01             	mov    BYTE PTR [rax],0x1
  100366:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  10036a:	48 8d 15 0f cd 01 00 	lea    rdx,[rip+0x1cd0f]        # 11d080 <x64ID>
  100371:	48 89 50 08          	mov    QWORD PTR [rax+0x8],rdx
  100375:	c6 45 ff 00          	mov    BYTE PTR [rbp-0x1],0x0
  100379:	48 8d 45 f3          	lea    rax,[rbp-0xd]
  10037d:	48 89 c7             	mov    rdi,rax
  100380:	e8 d7 04 00 00       	call   10085c <CPUID_manufacturer>
  100385:	48 8d 45 f3          	lea    rax,[rbp-0xd]
  100389:	ba 0c 00 00 00       	mov    edx,0xc
  10038e:	48 89 c6             	mov    rsi,rax
  100391:	48 8d 3d e8 cc 01 00 	lea    rdi,[rip+0x1cce8]        # 11d080 <x64ID>
  100398:	e8 cc 41 00 00       	call   104569 <memcpy>
  10039d:	48 8d 45 f3          	lea    rax,[rbp-0xd]
  1003a1:	48 8d 35 38 5d 00 00 	lea    rsi,[rip+0x5d38]        # 1060e0 <isBigEndian+0x4>
  1003a8:	48 89 c7             	mov    rdi,rax
  1003ab:	e8 23 42 00 00       	call   1045d3 <strcmp>
  1003b0:	85 c0                	test   eax,eax
  1003b2:	75 18                	jne    1003cc <getCPUINFO+0x98>
  1003b4:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1003b8:	c7 40 10 00 00 00 00 	mov    DWORD PTR [rax+0x10],0x0
  1003bf:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1003c3:	c6 40 14 00          	mov    BYTE PTR [rax+0x14],0x0
  1003c7:	e9 e5 03 00 00       	jmp    1007b1 <getCPUINFO+0x47d>
  1003cc:	48 8d 45 f3          	lea    rax,[rbp-0xd]
  1003d0:	48 8d 35 16 5d 00 00 	lea    rsi,[rip+0x5d16]        # 1060ed <isBigEndian+0x11>
  1003d7:	48 89 c7             	mov    rdi,rax
  1003da:	e8 f4 41 00 00       	call   1045d3 <strcmp>
  1003df:	85 c0                	test   eax,eax
  1003e1:	75 18                	jne    1003fb <getCPUINFO+0xc7>
  1003e3:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1003e7:	c7 40 10 01 00 00 00 	mov    DWORD PTR [rax+0x10],0x1
  1003ee:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1003f2:	c6 40 14 00          	mov    BYTE PTR [rax+0x14],0x0
  1003f6:	e9 b6 03 00 00       	jmp    1007b1 <getCPUINFO+0x47d>
  1003fb:	48 8d 45 f3          	lea    rax,[rbp-0xd]
  1003ff:	48 8d 35 f4 5c 00 00 	lea    rsi,[rip+0x5cf4]        # 1060fa <isBigEndian+0x1e>
  100406:	48 89 c7             	mov    rdi,rax
  100409:	e8 c5 41 00 00       	call   1045d3 <strcmp>
  10040e:	85 c0                	test   eax,eax
  100410:	75 18                	jne    10042a <getCPUINFO+0xf6>
  100412:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  100416:	c7 40 10 02 00 00 00 	mov    DWORD PTR [rax+0x10],0x2
  10041d:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  100421:	c6 40 14 00          	mov    BYTE PTR [rax+0x14],0x0
  100425:	e9 87 03 00 00       	jmp    1007b1 <getCPUINFO+0x47d>
  10042a:	48 8d 45 f3          	lea    rax,[rbp-0xd]
  10042e:	48 8d 35 d2 5c 00 00 	lea    rsi,[rip+0x5cd2]        # 106107 <isBigEndian+0x2b>
  100435:	48 89 c7             	mov    rdi,rax
  100438:	e8 96 41 00 00       	call   1045d3 <strcmp>
  10043d:	85 c0                	test   eax,eax
  10043f:	75 18                	jne    100459 <getCPUINFO+0x125>
  100441:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  100445:	c7 40 10 01 00 00 00 	mov    DWORD PTR [rax+0x10],0x1
  10044c:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  100450:	c6 40 14 00          	mov    BYTE PTR [rax+0x14],0x0
  100454:	e9 58 03 00 00       	jmp    1007b1 <getCPUINFO+0x47d>
  100459:	48 8d 45 f3          	lea    rax,[rbp-0xd]
  10045d:	48 8d 35 b0 5c 00 00 	lea    rsi,[rip+0x5cb0]        # 106114 <isBigEndian+0x38>
  100464:	48 89 c7             	mov    rdi,rax
  100467:	e8 67 41 00 00       	call   1045d3 <strcmp>
  10046c:	85 c0                	test   eax,eax
  10046e:	75 18                	jne    100488 <getCPUINFO+0x154>
  100470:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  100474:	c7 40 10 04 00 00 00 	mov    DWORD PTR [rax+0x10],0x4
  10047b:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  10047f:	c6 40 14 00          	mov    BYTE PTR [rax+0x14],0x0
  100483:	e9 29 03 00 00       	jmp    1007b1 <getCPUINFO+0x47d>
  100488:	48 8d 45 f3          	lea    rax,[rbp-0xd]
  10048c:	48 8d 35 8e 5c 00 00 	lea    rsi,[rip+0x5c8e]        # 106121 <isBigEndian+0x45>
  100493:	48 89 c7             	mov    rdi,rax
  100496:	e8 38 41 00 00       	call   1045d3 <strcmp>
  10049b:	85 c0                	test   eax,eax
  10049d:	75 18                	jne    1004b7 <getCPUINFO+0x183>
  10049f:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1004a3:	c7 40 10 05 00 00 00 	mov    DWORD PTR [rax+0x10],0x5
  1004aa:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1004ae:	c6 40 14 00          	mov    BYTE PTR [rax+0x14],0x0
  1004b2:	e9 fa 02 00 00       	jmp    1007b1 <getCPUINFO+0x47d>
  1004b7:	48 8d 45 f3          	lea    rax,[rbp-0xd]
  1004bb:	48 8d 35 6c 5c 00 00 	lea    rsi,[rip+0x5c6c]        # 10612e <isBigEndian+0x52>
  1004c2:	48 89 c7             	mov    rdi,rax
  1004c5:	e8 09 41 00 00       	call   1045d3 <strcmp>
  1004ca:	85 c0                	test   eax,eax
  1004cc:	75 18                	jne    1004e6 <getCPUINFO+0x1b2>
  1004ce:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1004d2:	c7 40 10 06 00 00 00 	mov    DWORD PTR [rax+0x10],0x6
  1004d9:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1004dd:	c6 40 14 00          	mov    BYTE PTR [rax+0x14],0x0
  1004e1:	e9 cb 02 00 00       	jmp    1007b1 <getCPUINFO+0x47d>
  1004e6:	48 8d 45 f3          	lea    rax,[rbp-0xd]
  1004ea:	48 8d 35 4a 5c 00 00 	lea    rsi,[rip+0x5c4a]        # 10613b <isBigEndian+0x5f>
  1004f1:	48 89 c7             	mov    rdi,rax
  1004f4:	e8 da 40 00 00       	call   1045d3 <strcmp>
  1004f9:	85 c0                	test   eax,eax
  1004fb:	75 18                	jne    100515 <getCPUINFO+0x1e1>
  1004fd:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  100501:	c7 40 10 07 00 00 00 	mov    DWORD PTR [rax+0x10],0x7
  100508:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  10050c:	c6 40 14 00          	mov    BYTE PTR [rax+0x14],0x0
  100510:	e9 9c 02 00 00       	jmp    1007b1 <getCPUINFO+0x47d>
  100515:	48 8d 45 f3          	lea    rax,[rbp-0xd]
  100519:	48 8d 35 28 5c 00 00 	lea    rsi,[rip+0x5c28]        # 106148 <isBigEndian+0x6c>
  100520:	48 89 c7             	mov    rdi,rax
  100523:	e8 ab 40 00 00       	call   1045d3 <strcmp>
  100528:	85 c0                	test   eax,eax
  10052a:	75 18                	jne    100544 <getCPUINFO+0x210>
  10052c:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  100530:	c7 40 10 08 00 00 00 	mov    DWORD PTR [rax+0x10],0x8
  100537:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  10053b:	c6 40 14 00          	mov    BYTE PTR [rax+0x14],0x0
  10053f:	e9 6d 02 00 00       	jmp    1007b1 <getCPUINFO+0x47d>
  100544:	48 8d 45 f3          	lea    rax,[rbp-0xd]
  100548:	48 8d 35 06 5c 00 00 	lea    rsi,[rip+0x5c06]        # 106155 <isBigEndian+0x79>
  10054f:	48 89 c7             	mov    rdi,rax
  100552:	e8 7c 40 00 00       	call   1045d3 <strcmp>
  100557:	85 c0                	test   eax,eax
  100559:	75 18                	jne    100573 <getCPUINFO+0x23f>
  10055b:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  10055f:	c7 40 10 09 00 00 00 	mov    DWORD PTR [rax+0x10],0x9
  100566:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  10056a:	c6 40 14 00          	mov    BYTE PTR [rax+0x14],0x0
  10056e:	e9 3e 02 00 00       	jmp    1007b1 <getCPUINFO+0x47d>
  100573:	48 8d 45 f3          	lea    rax,[rbp-0xd]
  100577:	48 8d 35 e4 5b 00 00 	lea    rsi,[rip+0x5be4]        # 106162 <isBigEndian+0x86>
  10057e:	48 89 c7             	mov    rdi,rax
  100581:	e8 4d 40 00 00       	call   1045d3 <strcmp>
  100586:	85 c0                	test   eax,eax
  100588:	75 18                	jne    1005a2 <getCPUINFO+0x26e>
  10058a:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  10058e:	c7 40 10 0a 00 00 00 	mov    DWORD PTR [rax+0x10],0xa
  100595:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  100599:	c6 40 14 00          	mov    BYTE PTR [rax+0x14],0x0
  10059d:	e9 0f 02 00 00       	jmp    1007b1 <getCPUINFO+0x47d>
  1005a2:	48 8d 45 f3          	lea    rax,[rbp-0xd]
  1005a6:	48 8d 35 c2 5b 00 00 	lea    rsi,[rip+0x5bc2]        # 10616f <isBigEndian+0x93>
  1005ad:	48 89 c7             	mov    rdi,rax
  1005b0:	e8 1e 40 00 00       	call   1045d3 <strcmp>
  1005b5:	85 c0                	test   eax,eax
  1005b7:	75 18                	jne    1005d1 <getCPUINFO+0x29d>
  1005b9:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1005bd:	c7 40 10 0b 00 00 00 	mov    DWORD PTR [rax+0x10],0xb
  1005c4:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1005c8:	c6 40 14 00          	mov    BYTE PTR [rax+0x14],0x0
  1005cc:	e9 e0 01 00 00       	jmp    1007b1 <getCPUINFO+0x47d>
  1005d1:	48 8d 45 f3          	lea    rax,[rbp-0xd]
  1005d5:	48 8d 35 a0 5b 00 00 	lea    rsi,[rip+0x5ba0]        # 10617c <isBigEndian+0xa0>
  1005dc:	48 89 c7             	mov    rdi,rax
  1005df:	e8 ef 3f 00 00       	call   1045d3 <strcmp>
  1005e4:	85 c0                	test   eax,eax
  1005e6:	75 18                	jne    100600 <getCPUINFO+0x2cc>
  1005e8:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1005ec:	c7 40 10 0c 00 00 00 	mov    DWORD PTR [rax+0x10],0xc
  1005f3:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1005f7:	c6 40 14 00          	mov    BYTE PTR [rax+0x14],0x0
  1005fb:	e9 b1 01 00 00       	jmp    1007b1 <getCPUINFO+0x47d>
  100600:	48 8d 45 f3          	lea    rax,[rbp-0xd]
  100604:	48 8d 35 7e 5b 00 00 	lea    rsi,[rip+0x5b7e]        # 106189 <isBigEndian+0xad>
  10060b:	48 89 c7             	mov    rdi,rax
  10060e:	e8 c0 3f 00 00       	call   1045d3 <strcmp>
  100613:	85 c0                	test   eax,eax
  100615:	75 18                	jne    10062f <getCPUINFO+0x2fb>
  100617:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  10061b:	c7 40 10 0d 00 00 00 	mov    DWORD PTR [rax+0x10],0xd
  100622:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  100626:	c6 40 14 00          	mov    BYTE PTR [rax+0x14],0x0
  10062a:	e9 82 01 00 00       	jmp    1007b1 <getCPUINFO+0x47d>
  10062f:	48 8d 45 f3          	lea    rax,[rbp-0xd]
  100633:	48 8d 35 5c 5b 00 00 	lea    rsi,[rip+0x5b5c]        # 106196 <isBigEndian+0xba>
  10063a:	48 89 c7             	mov    rdi,rax
  10063d:	e8 91 3f 00 00       	call   1045d3 <strcmp>
  100642:	85 c0                	test   eax,eax
  100644:	75 18                	jne    10065e <getCPUINFO+0x32a>
  100646:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  10064a:	c7 40 10 0e 00 00 00 	mov    DWORD PTR [rax+0x10],0xe
  100651:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  100655:	c6 40 14 00          	mov    BYTE PTR [rax+0x14],0x0
  100659:	e9 53 01 00 00       	jmp    1007b1 <getCPUINFO+0x47d>
  10065e:	48 8d 45 f3          	lea    rax,[rbp-0xd]
  100662:	48 8d 35 3a 5b 00 00 	lea    rsi,[rip+0x5b3a]        # 1061a3 <isBigEndian+0xc7>
  100669:	48 89 c7             	mov    rdi,rax
  10066c:	e8 62 3f 00 00       	call   1045d3 <strcmp>
  100671:	85 c0                	test   eax,eax
  100673:	75 18                	jne    10068d <getCPUINFO+0x359>
  100675:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  100679:	c7 40 10 0f 00 00 00 	mov    DWORD PTR [rax+0x10],0xf
  100680:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  100684:	c6 40 14 01          	mov    BYTE PTR [rax+0x14],0x1
  100688:	e9 24 01 00 00       	jmp    1007b1 <getCPUINFO+0x47d>
  10068d:	48 8d 45 f3          	lea    rax,[rbp-0xd]
  100691:	48 8d 35 18 5b 00 00 	lea    rsi,[rip+0x5b18]        # 1061b0 <isBigEndian+0xd4>
  100698:	48 89 c7             	mov    rdi,rax
  10069b:	e8 33 3f 00 00       	call   1045d3 <strcmp>
  1006a0:	85 c0                	test   eax,eax
  1006a2:	75 18                	jne    1006bc <getCPUINFO+0x388>
  1006a4:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1006a8:	c7 40 10 10 00 00 00 	mov    DWORD PTR [rax+0x10],0x10
  1006af:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1006b3:	c6 40 14 01          	mov    BYTE PTR [rax+0x14],0x1
  1006b7:	e9 f5 00 00 00       	jmp    1007b1 <getCPUINFO+0x47d>
  1006bc:	48 8d 45 f3          	lea    rax,[rbp-0xd]
  1006c0:	48 8d 35 f6 5a 00 00 	lea    rsi,[rip+0x5af6]        # 1061bd <isBigEndian+0xe1>
  1006c7:	48 89 c7             	mov    rdi,rax
  1006ca:	e8 04 3f 00 00       	call   1045d3 <strcmp>
  1006cf:	85 c0                	test   eax,eax
  1006d1:	75 18                	jne    1006eb <getCPUINFO+0x3b7>
  1006d3:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1006d7:	c7 40 10 11 00 00 00 	mov    DWORD PTR [rax+0x10],0x11
  1006de:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1006e2:	c6 40 14 01          	mov    BYTE PTR [rax+0x14],0x1
  1006e6:	e9 c6 00 00 00       	jmp    1007b1 <getCPUINFO+0x47d>
  1006eb:	48 8d 45 f3          	lea    rax,[rbp-0xd]
  1006ef:	48 8d 35 d4 5a 00 00 	lea    rsi,[rip+0x5ad4]        # 1061ca <isBigEndian+0xee>
  1006f6:	48 89 c7             	mov    rdi,rax
  1006f9:	e8 d5 3e 00 00       	call   1045d3 <strcmp>
  1006fe:	85 c0                	test   eax,eax
  100700:	75 18                	jne    10071a <getCPUINFO+0x3e6>
  100702:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  100706:	c7 40 10 12 00 00 00 	mov    DWORD PTR [rax+0x10],0x12
  10070d:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  100711:	c6 40 14 01          	mov    BYTE PTR [rax+0x14],0x1
  100715:	e9 97 00 00 00       	jmp    1007b1 <getCPUINFO+0x47d>
  10071a:	48 8d 45 f3          	lea    rax,[rbp-0xd]
  10071e:	48 8d 35 b1 5a 00 00 	lea    rsi,[rip+0x5ab1]        # 1061d6 <isBigEndian+0xfa>
  100725:	48 89 c7             	mov    rdi,rax
  100728:	e8 a6 3e 00 00       	call   1045d3 <strcmp>
  10072d:	85 c0                	test   eax,eax
  10072f:	75 15                	jne    100746 <getCPUINFO+0x412>
  100731:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  100735:	c7 40 10 13 00 00 00 	mov    DWORD PTR [rax+0x10],0x13
  10073c:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  100740:	c6 40 14 01          	mov    BYTE PTR [rax+0x14],0x1
  100744:	eb 6b                	jmp    1007b1 <getCPUINFO+0x47d>
  100746:	48 8d 45 f3          	lea    rax,[rbp-0xd]
  10074a:	48 8d 35 92 5a 00 00 	lea    rsi,[rip+0x5a92]        # 1061e3 <isBigEndian+0x107>
  100751:	48 89 c7             	mov    rdi,rax
  100754:	e8 7a 3e 00 00       	call   1045d3 <strcmp>
  100759:	85 c0                	test   eax,eax
  10075b:	75 15                	jne    100772 <getCPUINFO+0x43e>
  10075d:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  100761:	c7 40 10 14 00 00 00 	mov    DWORD PTR [rax+0x10],0x14
  100768:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  10076c:	c6 40 14 01          	mov    BYTE PTR [rax+0x14],0x1
  100770:	eb 3f                	jmp    1007b1 <getCPUINFO+0x47d>
  100772:	48 8d 45 f3          	lea    rax,[rbp-0xd]
  100776:	48 8d 35 73 5a 00 00 	lea    rsi,[rip+0x5a73]        # 1061f0 <isBigEndian+0x114>
  10077d:	48 89 c7             	mov    rdi,rax
  100780:	e8 4e 3e 00 00       	call   1045d3 <strcmp>
  100785:	85 c0                	test   eax,eax
  100787:	75 15                	jne    10079e <getCPUINFO+0x46a>
  100789:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  10078d:	c7 40 10 15 00 00 00 	mov    DWORD PTR [rax+0x10],0x15
  100794:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  100798:	c6 40 14 01          	mov    BYTE PTR [rax+0x14],0x1
  10079c:	eb 13                	jmp    1007b1 <getCPUINFO+0x47d>
  10079e:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1007a2:	c7 40 10 16 00 00 00 	mov    DWORD PTR [rax+0x10],0x16
  1007a9:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1007ad:	c6 40 14 00          	mov    BYTE PTR [rax+0x14],0x0
  1007b1:	48 8d 45 e4          	lea    rax,[rbp-0x1c]
  1007b5:	48 89 c7             	mov    rdi,rax
  1007b8:	e8 b5 00 00 00       	call   100872 <CPUID_Info>
  1007bd:	8b 45 e8             	mov    eax,DWORD PTR [rbp-0x18]
  1007c0:	89 05 ca c8 01 00    	mov    DWORD PTR [rip+0x1c8ca],eax        # 11d090 <x64ID+0x10>
  1007c6:	8b 45 ec             	mov    eax,DWORD PTR [rbp-0x14]
  1007c9:	89 05 c5 c8 01 00    	mov    DWORD PTR [rip+0x1c8c5],eax        # 11d094 <x64ID+0x14>
  1007cf:	8b 05 bb c8 01 00    	mov    eax,DWORD PTR [rip+0x1c8bb]        # 11d090 <x64ID+0x10>
  1007d5:	c1 e8 09             	shr    eax,0x9
  1007d8:	83 e0 01             	and    eax,0x1
  1007db:	88 05 ab c8 01 00    	mov    BYTE PTR [rip+0x1c8ab],al        # 11d08c <x64ID+0xc>
  1007e1:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1007e5:	c9                   	leave  
  1007e6:	c3                   	ret    

00000000001007e7 <halt>:
  1007e7:	55                   	push   rbp
  1007e8:	48 89 e5             	mov    rbp,rsp
  1007eb:	f4                   	hlt    
  1007ec:	eb fd                	jmp    1007eb <halt+0x4>

00000000001007ee <readMSR>:
  1007ee:	55                   	push   rbp
  1007ef:	48 89 e5             	mov    rbp,rsp
  1007f2:	89 7d fc             	mov    DWORD PTR [rbp-0x4],edi
  1007f5:	48 89 75 f0          	mov    QWORD PTR [rbp-0x10],rsi
  1007f9:	48 89 55 e8          	mov    QWORD PTR [rbp-0x18],rdx
  1007fd:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  100800:	89 c1                	mov    ecx,eax
  100802:	0f 32                	rdmsr  
  100804:	89 c1                	mov    ecx,eax
  100806:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  10080a:	89 08                	mov    DWORD PTR [rax],ecx
  10080c:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  100810:	89 10                	mov    DWORD PTR [rax],edx
  100812:	90                   	nop
  100813:	5d                   	pop    rbp
  100814:	c3                   	ret    

0000000000100815 <writeMSR>:
  100815:	55                   	push   rbp
  100816:	48 89 e5             	mov    rbp,rsp
  100819:	89 7d fc             	mov    DWORD PTR [rbp-0x4],edi
  10081c:	89 75 f8             	mov    DWORD PTR [rbp-0x8],esi
  10081f:	89 55 f4             	mov    DWORD PTR [rbp-0xc],edx
  100822:	8b 45 f8             	mov    eax,DWORD PTR [rbp-0x8]
  100825:	8b 55 f4             	mov    edx,DWORD PTR [rbp-0xc]
  100828:	8b 4d fc             	mov    ecx,DWORD PTR [rbp-0x4]
  10082b:	0f 30                	wrmsr  
  10082d:	90                   	nop
  10082e:	5d                   	pop    rbp
  10082f:	c3                   	ret    

0000000000100830 <CPUID_enabled>:
  100830:	9c                   	pushf  
  100831:	9c                   	pushf  
  100832:	67 48 81 34 24 00 00 	xor    QWORD PTR [esp],0x200000
  100839:	20 00 
  10083b:	9d                   	popf   
  10083c:	9c                   	pushf  
  10083d:	58                   	pop    rax
  10083e:	67 48 33 04 24       	xor    rax,QWORD PTR [esp]
  100843:	9d                   	popf   
  100844:	48 25 00 00 20 00    	and    rax,0x200000
  10084a:	48 83 f8 00          	cmp    rax,0x0
  10084e:	75 01                	jne    100851 <CPUID_enabled.true>
  100850:	c3                   	ret    

0000000000100851 <CPUID_enabled.true>:
  100851:	b8 01 00 00 00       	mov    eax,0x1
  100856:	c3                   	ret    

0000000000100857 <CPUID>:
  100857:	89 f8                	mov    eax,edi
  100859:	0f a2                	cpuid  
  10085b:	c3                   	ret    

000000000010085c <CPUID_manufacturer>:
  10085c:	53                   	push   rbx
  10085d:	52                   	push   rdx
  10085e:	51                   	push   rcx
  10085f:	31 c0                	xor    eax,eax
  100861:	0f a2                	cpuid  
  100863:	89 1f                	mov    DWORD PTR [rdi],ebx
  100865:	89 57 04             	mov    DWORD PTR [rdi+0x4],edx
  100868:	89 4f 08             	mov    DWORD PTR [rdi+0x8],ecx
  10086b:	59                   	pop    rcx
  10086c:	5a                   	pop    rdx
  10086d:	5b                   	pop    rbx
  10086e:	48 89 f8             	mov    rax,rdi
  100871:	c3                   	ret    

0000000000100872 <CPUID_Info>:
  100872:	52                   	push   rdx
  100873:	51                   	push   rcx
  100874:	53                   	push   rbx
  100875:	b8 01 00 00 00       	mov    eax,0x1
  10087a:	0f a2                	cpuid  
  10087c:	89 07                	mov    DWORD PTR [rdi],eax
  10087e:	89 57 04             	mov    DWORD PTR [rdi+0x4],edx
  100881:	89 4f 08             	mov    DWORD PTR [rdi+0x8],ecx
  100884:	5b                   	pop    rbx
  100885:	59                   	pop    rcx
  100886:	5a                   	pop    rdx
  100887:	48 89 f8             	mov    rax,rdi
  10088a:	c3                   	ret    

000000000010088b <RFLAGS>:
  10088b:	9c                   	pushf  
  10088c:	58                   	pop    rax
  10088d:	c3                   	ret    

000000000010088e <gdtr_store>:
  10088e:	0f 01 07             	sgdt   [rdi]
  100891:	c3                   	ret    

0000000000100892 <pm_lowmem_fill>:
  100892:	55                   	push   rbp
  100893:	48 89 e5             	mov    rbp,rsp
  100896:	c7 45 fc 00 00 00 00 	mov    DWORD PTR [rbp-0x4],0x0
  10089d:	eb 5c                	jmp    1008fb <pm_lowmem_fill+0x69>
  10089f:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  1008a2:	c1 e0 0c             	shl    eax,0xc
  1008a5:	48 98                	cdqe   
  1008a7:	8b 55 fc             	mov    edx,DWORD PTR [rbp-0x4]
  1008aa:	48 63 d2             	movsxd rdx,edx
  1008ad:	48 8d 0c d5 00 00 00 	lea    rcx,[rdx*8+0x0]
  1008b4:	00 
  1008b5:	48 8d 15 44 d7 01 00 	lea    rdx,[rip+0x1d744]        # 11e000 <PT_0>
  1008bc:	48 89 04 11          	mov    QWORD PTR [rcx+rdx*1],rax
  1008c0:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  1008c3:	48 98                	cdqe   
  1008c5:	48 8d 14 c5 00 00 00 	lea    rdx,[rax*8+0x0]
  1008cc:	00 
  1008cd:	48 8d 05 2c d7 01 00 	lea    rax,[rip+0x1d72c]        # 11e000 <PT_0>
  1008d4:	48 8b 04 02          	mov    rax,QWORD PTR [rdx+rax*1]
  1008d8:	48 83 c8 03          	or     rax,0x3
  1008dc:	48 89 c1             	mov    rcx,rax
  1008df:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  1008e2:	48 98                	cdqe   
  1008e4:	48 8d 14 c5 00 00 00 	lea    rdx,[rax*8+0x0]
  1008eb:	00 
  1008ec:	48 8d 05 0d d7 01 00 	lea    rax,[rip+0x1d70d]        # 11e000 <PT_0>
  1008f3:	48 89 0c 02          	mov    QWORD PTR [rdx+rax*1],rcx
  1008f7:	83 45 fc 01          	add    DWORD PTR [rbp-0x4],0x1
  1008fb:	81 7d fc ff 00 00 00 	cmp    DWORD PTR [rbp-0x4],0xff
  100902:	7e 9b                	jle    10089f <pm_lowmem_fill+0xd>
  100904:	48 8b 05 f5 d6 01 00 	mov    rax,QWORD PTR [rip+0x1d6f5]        # 11e000 <PT_0>
  10090b:	48 ba 01 00 00 00 00 	movabs rdx,0x8000000000000001
  100912:	00 00 80 
  100915:	48 09 d0             	or     rax,rdx
  100918:	48 89 05 e1 d6 01 00 	mov    QWORD PTR [rip+0x1d6e1],rax        # 11e000 <PT_0>
  10091f:	48 8b 05 12 d7 01 00 	mov    rax,QWORD PTR [rip+0x1d712]        # 11e038 <PT_0+0x38>
  100926:	48 ba 03 00 00 00 00 	movabs rdx,0x8000000000000003
  10092d:	00 00 80 
  100930:	48 09 d0             	or     rax,rdx
  100933:	48 89 05 fe d6 01 00 	mov    QWORD PTR [rip+0x1d6fe],rax        # 11e038 <PT_0+0x38>
  10093a:	c7 45 f8 00 00 00 00 	mov    DWORD PTR [rbp-0x8],0x0
  100941:	eb 48                	jmp    10098b <pm_lowmem_fill+0xf9>
  100943:	8b 45 f8             	mov    eax,DWORD PTR [rbp-0x8]
  100946:	83 c0 50             	add    eax,0x50
  100949:	48 98                	cdqe   
  10094b:	48 8d 14 c5 00 00 00 	lea    rdx,[rax*8+0x0]
  100952:	00 
  100953:	48 8d 05 a6 d6 01 00 	lea    rax,[rip+0x1d6a6]        # 11e000 <PT_0>
  10095a:	48 8b 04 02          	mov    rax,QWORD PTR [rdx+rax*1]
  10095e:	8b 55 f8             	mov    edx,DWORD PTR [rbp-0x8]
  100961:	83 c2 50             	add    edx,0x50
  100964:	48 b9 01 00 00 00 00 	movabs rcx,0x8000000000000001
  10096b:	00 00 80 
  10096e:	48 09 c1             	or     rcx,rax
  100971:	48 63 c2             	movsxd rax,edx
  100974:	48 8d 14 c5 00 00 00 	lea    rdx,[rax*8+0x0]
  10097b:	00 
  10097c:	48 8d 05 7d d6 01 00 	lea    rax,[rip+0x1d67d]        # 11e000 <PT_0>
  100983:	48 89 0c 02          	mov    QWORD PTR [rdx+rax*1],rcx
  100987:	83 45 f8 01          	add    DWORD PTR [rbp-0x8],0x1
  10098b:	83 7d f8 7f          	cmp    DWORD PTR [rbp-0x8],0x7f
  10098f:	7e b2                	jle    100943 <pm_lowmem_fill+0xb1>
  100991:	90                   	nop
  100992:	90                   	nop
  100993:	5d                   	pop    rbp
  100994:	c3                   	ret    

0000000000100995 <mem_v_alloc>:
  100995:	55                   	push   rbp
  100996:	48 89 e5             	mov    rbp,rsp
  100999:	90                   	nop
  10099a:	5d                   	pop    rbp
  10099b:	c3                   	ret    

000000000010099c <kern_mem_map>:
  10099c:	55                   	push   rbp
  10099d:	48 89 e5             	mov    rbp,rsp
  1009a0:	48 8d 05 d2 4d 00 00 	lea    rax,[rip+0x4dd2]        # 105779 <__KERN_CODE_END>
  1009a7:	bf 00 10 00 00       	mov    edi,0x1000
  1009ac:	ba 00 00 00 00       	mov    edx,0x0
  1009b1:	48 f7 f7             	div    rdi
  1009b4:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  1009b8:	48 8d 05 ba 4d 00 00 	lea    rax,[rip+0x4dba]        # 105779 <__KERN_CODE_END>
  1009bf:	b9 00 10 00 00       	mov    ecx,0x1000
  1009c4:	ba 00 00 00 00       	mov    edx,0x0
  1009c9:	48 f7 f1             	div    rcx
  1009cc:	48 89 d0             	mov    rax,rdx
  1009cf:	48 85 c0             	test   rax,rax
  1009d2:	74 05                	je     1009d9 <kern_mem_map+0x3d>
  1009d4:	48 83 45 f8 01       	add    QWORD PTR [rbp-0x8],0x1
  1009d9:	c7 45 f4 00 00 00 00 	mov    DWORD PTR [rbp-0xc],0x0
  1009e0:	e9 d3 00 00 00       	jmp    100ab8 <kern_mem_map+0x11c>
  1009e5:	bf 00 10 00 00       	mov    edi,0x1000
  1009ea:	b8 00 00 10 00       	mov    eax,0x100000
  1009ef:	ba 00 00 00 00       	mov    edx,0x0
  1009f4:	48 f7 f7             	div    rdi
  1009f7:	48 89 c2             	mov    rdx,rax
  1009fa:	8b 45 f4             	mov    eax,DWORD PTR [rbp-0xc]
  1009fd:	48 01 d0             	add    rax,rdx
  100a00:	48 8d 14 c5 00 00 00 	lea    rdx,[rax*8+0x0]
  100a07:	00 
  100a08:	48 8d 05 f1 d5 01 00 	lea    rax,[rip+0x1d5f1]        # 11e000 <PT_0>
  100a0f:	48 c7 04 02 00 00 00 	mov    QWORD PTR [rdx+rax*1],0x0
  100a16:	00 
  100a17:	8b 45 f4             	mov    eax,DWORD PTR [rbp-0xc]
  100a1a:	05 00 01 00 00       	add    eax,0x100
  100a1f:	c1 e0 0c             	shl    eax,0xc
  100a22:	89 c1                	mov    ecx,eax
  100a24:	be 00 10 00 00       	mov    esi,0x1000
  100a29:	b8 00 00 10 00       	mov    eax,0x100000
  100a2e:	ba 00 00 00 00       	mov    edx,0x0
  100a33:	48 f7 f6             	div    rsi
  100a36:	48 89 c2             	mov    rdx,rax
  100a39:	8b 45 f4             	mov    eax,DWORD PTR [rbp-0xc]
  100a3c:	48 01 d0             	add    rax,rdx
  100a3f:	89 c9                	mov    ecx,ecx
  100a41:	48 8d 14 c5 00 00 00 	lea    rdx,[rax*8+0x0]
  100a48:	00 
  100a49:	48 8d 05 b0 d5 01 00 	lea    rax,[rip+0x1d5b0]        # 11e000 <PT_0>
  100a50:	48 89 0c 02          	mov    QWORD PTR [rdx+rax*1],rcx
  100a54:	bf 00 10 00 00       	mov    edi,0x1000
  100a59:	b8 00 00 10 00       	mov    eax,0x100000
  100a5e:	ba 00 00 00 00       	mov    edx,0x0
  100a63:	48 f7 f7             	div    rdi
  100a66:	48 89 c2             	mov    rdx,rax
  100a69:	8b 45 f4             	mov    eax,DWORD PTR [rbp-0xc]
  100a6c:	48 01 d0             	add    rax,rdx
  100a6f:	48 8d 14 c5 00 00 00 	lea    rdx,[rax*8+0x0]
  100a76:	00 
  100a77:	48 8d 05 82 d5 01 00 	lea    rax,[rip+0x1d582]        # 11e000 <PT_0>
  100a7e:	48 8b 0c 02          	mov    rcx,QWORD PTR [rdx+rax*1]
  100a82:	be 00 10 00 00       	mov    esi,0x1000
  100a87:	b8 00 00 10 00       	mov    eax,0x100000
  100a8c:	ba 00 00 00 00       	mov    edx,0x0
  100a91:	48 f7 f6             	div    rsi
  100a94:	48 89 c2             	mov    rdx,rax
  100a97:	8b 45 f4             	mov    eax,DWORD PTR [rbp-0xc]
  100a9a:	48 01 d0             	add    rax,rdx
  100a9d:	48 83 c9 01          	or     rcx,0x1
  100aa1:	48 8d 14 c5 00 00 00 	lea    rdx,[rax*8+0x0]
  100aa8:	00 
  100aa9:	48 8d 05 50 d5 01 00 	lea    rax,[rip+0x1d550]        # 11e000 <PT_0>
  100ab0:	48 89 0c 02          	mov    QWORD PTR [rdx+rax*1],rcx
  100ab4:	83 45 f4 01          	add    DWORD PTR [rbp-0xc],0x1
  100ab8:	8b 45 f4             	mov    eax,DWORD PTR [rbp-0xc]
  100abb:	48 39 45 f8          	cmp    QWORD PTR [rbp-0x8],rax
  100abf:	0f 87 20 ff ff ff    	ja     1009e5 <kern_mem_map+0x49>
  100ac5:	48 8d 05 04 45 fe ff 	lea    rax,[rip+0xfffffffffffe4504]        # e4fd0 <__KERN_DATA_SIZE>
  100acc:	bf 00 10 00 00       	mov    edi,0x1000
  100ad1:	ba 00 00 00 00       	mov    edx,0x0
  100ad6:	48 f7 f7             	div    rdi
  100ad9:	48 89 45 e8          	mov    QWORD PTR [rbp-0x18],rax
  100add:	48 8d 05 ec 44 fe ff 	lea    rax,[rip+0xfffffffffffe44ec]        # e4fd0 <__KERN_DATA_SIZE>
  100ae4:	b9 00 10 00 00       	mov    ecx,0x1000
  100ae9:	ba 00 00 00 00       	mov    edx,0x0
  100aee:	48 f7 f1             	div    rcx
  100af1:	48 89 d0             	mov    rax,rdx
  100af4:	48 85 c0             	test   rax,rax
  100af7:	74 05                	je     100afe <kern_mem_map+0x162>
  100af9:	48 83 45 e8 01       	add    QWORD PTR [rbp-0x18],0x1
  100afe:	c7 45 e4 00 00 00 00 	mov    DWORD PTR [rbp-0x1c],0x0
  100b05:	e9 e7 00 00 00       	jmp    100bf1 <kern_mem_map+0x255>
  100b0a:	48 8d 05 ef f4 ff ff 	lea    rax,[rip+0xfffffffffffff4ef]        # 100000 <__KERN_CODE_START>
  100b11:	be 00 10 00 00       	mov    esi,0x1000
  100b16:	ba 00 00 00 00       	mov    edx,0x0
  100b1b:	48 f7 f6             	div    rsi
  100b1e:	48 89 c2             	mov    rdx,rax
  100b21:	8b 45 e4             	mov    eax,DWORD PTR [rbp-0x1c]
  100b24:	48 01 d0             	add    rax,rdx
  100b27:	48 8d 14 c5 00 00 00 	lea    rdx,[rax*8+0x0]
  100b2e:	00 
  100b2f:	48 8d 05 ca d4 01 00 	lea    rax,[rip+0x1d4ca]        # 11e000 <PT_0>
  100b36:	48 c7 04 02 00 00 00 	mov    QWORD PTR [rdx+rax*1],0x0
  100b3d:	00 
  100b3e:	8b 45 e4             	mov    eax,DWORD PTR [rbp-0x1c]
  100b41:	c1 e0 0c             	shl    eax,0xc
  100b44:	89 c6                	mov    esi,eax
  100b46:	48 8d 0d b3 f4 ff ff 	lea    rcx,[rip+0xfffffffffffff4b3]        # 100000 <__KERN_CODE_START>
  100b4d:	48 8d 05 ac f4 ff ff 	lea    rax,[rip+0xfffffffffffff4ac]        # 100000 <__KERN_CODE_START>
  100b54:	bf 00 10 00 00       	mov    edi,0x1000
  100b59:	ba 00 00 00 00       	mov    edx,0x0
  100b5e:	48 f7 f7             	div    rdi
  100b61:	48 89 c2             	mov    rdx,rax
  100b64:	8b 45 e4             	mov    eax,DWORD PTR [rbp-0x1c]
  100b67:	48 01 d0             	add    rax,rdx
  100b6a:	48 01 f1             	add    rcx,rsi
  100b6d:	48 8d 14 c5 00 00 00 	lea    rdx,[rax*8+0x0]
  100b74:	00 
  100b75:	48 8d 05 84 d4 01 00 	lea    rax,[rip+0x1d484]        # 11e000 <PT_0>
  100b7c:	48 89 0c 02          	mov    QWORD PTR [rdx+rax*1],rcx
  100b80:	48 8d 05 79 f4 ff ff 	lea    rax,[rip+0xfffffffffffff479]        # 100000 <__KERN_CODE_START>
  100b87:	be 00 10 00 00       	mov    esi,0x1000
  100b8c:	ba 00 00 00 00       	mov    edx,0x0
  100b91:	48 f7 f6             	div    rsi
  100b94:	48 89 c2             	mov    rdx,rax
  100b97:	8b 45 e4             	mov    eax,DWORD PTR [rbp-0x1c]
  100b9a:	48 01 d0             	add    rax,rdx
  100b9d:	48 8d 14 c5 00 00 00 	lea    rdx,[rax*8+0x0]
  100ba4:	00 
  100ba5:	48 8d 05 54 d4 01 00 	lea    rax,[rip+0x1d454]        # 11e000 <PT_0>
  100bac:	48 8b 0c 02          	mov    rcx,QWORD PTR [rdx+rax*1]
  100bb0:	48 8d 05 49 f4 ff ff 	lea    rax,[rip+0xfffffffffffff449]        # 100000 <__KERN_CODE_START>
  100bb7:	bf 00 10 00 00       	mov    edi,0x1000
  100bbc:	ba 00 00 00 00       	mov    edx,0x0
  100bc1:	48 f7 f7             	div    rdi
  100bc4:	48 89 c2             	mov    rdx,rax
  100bc7:	8b 45 e4             	mov    eax,DWORD PTR [rbp-0x1c]
  100bca:	48 01 d0             	add    rax,rdx
  100bcd:	48 ba 03 00 00 00 00 	movabs rdx,0x8000000000000003
  100bd4:	00 00 80 
  100bd7:	48 09 d1             	or     rcx,rdx
  100bda:	48 8d 14 c5 00 00 00 	lea    rdx,[rax*8+0x0]
  100be1:	00 
  100be2:	48 8d 05 17 d4 01 00 	lea    rax,[rip+0x1d417]        # 11e000 <PT_0>
  100be9:	48 89 0c 02          	mov    QWORD PTR [rdx+rax*1],rcx
  100bed:	83 45 e4 01          	add    DWORD PTR [rbp-0x1c],0x1
  100bf1:	8b 45 e4             	mov    eax,DWORD PTR [rbp-0x1c]
  100bf4:	48 39 45 e8          	cmp    QWORD PTR [rbp-0x18],rax
  100bf8:	0f 87 0c ff ff ff    	ja     100b0a <kern_mem_map+0x16e>
  100bfe:	48 8b 05 7b 04 02 00 	mov    rax,QWORD PTR [rip+0x2047b]        # 121080 <MemStack>
  100c05:	48 8d 15 f4 a3 02 00 	lea    rdx,[rip+0x2a3f4]        # 12b000 <__KERN_MEM_END>
  100c0c:	48 29 d0             	sub    rax,rdx
  100c0f:	be 00 10 00 00       	mov    esi,0x1000
  100c14:	ba 00 00 00 00       	mov    edx,0x0
  100c19:	48 f7 f6             	div    rsi
  100c1c:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
  100c20:	48 8b 05 59 04 02 00 	mov    rax,QWORD PTR [rip+0x20459]        # 121080 <MemStack>
  100c27:	48 8d 15 d2 a3 02 00 	lea    rdx,[rip+0x2a3d2]        # 12b000 <__KERN_MEM_END>
  100c2e:	48 29 d0             	sub    rax,rdx
  100c31:	b9 00 10 00 00       	mov    ecx,0x1000
  100c36:	ba 00 00 00 00       	mov    edx,0x0
  100c3b:	48 f7 f1             	div    rcx
  100c3e:	48 89 d0             	mov    rax,rdx
  100c41:	48 85 c0             	test   rax,rax
  100c44:	74 05                	je     100c4b <kern_mem_map+0x2af>
  100c46:	48 83 45 d8 01       	add    QWORD PTR [rbp-0x28],0x1
  100c4b:	c7 45 d4 00 00 00 00 	mov    DWORD PTR [rbp-0x2c],0x0
  100c52:	e9 e7 00 00 00       	jmp    100d3e <kern_mem_map+0x3a2>
  100c57:	48 8d 05 d2 93 02 00 	lea    rax,[rip+0x293d2]        # 12a030 <__KERN_DATA_END>
  100c5e:	bf 00 10 00 00       	mov    edi,0x1000
  100c63:	ba 00 00 00 00       	mov    edx,0x0
  100c68:	48 f7 f7             	div    rdi
  100c6b:	48 89 c2             	mov    rdx,rax
  100c6e:	8b 45 d4             	mov    eax,DWORD PTR [rbp-0x2c]
  100c71:	48 01 d0             	add    rax,rdx
  100c74:	48 8d 14 c5 00 00 00 	lea    rdx,[rax*8+0x0]
  100c7b:	00 
  100c7c:	48 8d 05 7d d3 01 00 	lea    rax,[rip+0x1d37d]        # 11e000 <PT_0>
  100c83:	48 c7 04 02 00 00 00 	mov    QWORD PTR [rdx+rax*1],0x0
  100c8a:	00 
  100c8b:	8b 45 d4             	mov    eax,DWORD PTR [rbp-0x2c]
  100c8e:	c1 e0 0c             	shl    eax,0xc
  100c91:	89 c6                	mov    esi,eax
  100c93:	48 8d 0d 96 93 02 00 	lea    rcx,[rip+0x29396]        # 12a030 <__KERN_DATA_END>
  100c9a:	48 8d 05 8f 93 02 00 	lea    rax,[rip+0x2938f]        # 12a030 <__KERN_DATA_END>
  100ca1:	bf 00 10 00 00       	mov    edi,0x1000
  100ca6:	ba 00 00 00 00       	mov    edx,0x0
  100cab:	48 f7 f7             	div    rdi
  100cae:	48 89 c2             	mov    rdx,rax
  100cb1:	8b 45 d4             	mov    eax,DWORD PTR [rbp-0x2c]
  100cb4:	48 01 d0             	add    rax,rdx
  100cb7:	48 01 f1             	add    rcx,rsi
  100cba:	48 8d 14 c5 00 00 00 	lea    rdx,[rax*8+0x0]
  100cc1:	00 
  100cc2:	48 8d 05 37 d3 01 00 	lea    rax,[rip+0x1d337]        # 11e000 <PT_0>
  100cc9:	48 89 0c 02          	mov    QWORD PTR [rdx+rax*1],rcx
  100ccd:	48 8d 05 5c 93 02 00 	lea    rax,[rip+0x2935c]        # 12a030 <__KERN_DATA_END>
  100cd4:	be 00 10 00 00       	mov    esi,0x1000
  100cd9:	ba 00 00 00 00       	mov    edx,0x0
  100cde:	48 f7 f6             	div    rsi
  100ce1:	48 89 c2             	mov    rdx,rax
  100ce4:	8b 45 d4             	mov    eax,DWORD PTR [rbp-0x2c]
  100ce7:	48 01 d0             	add    rax,rdx
  100cea:	48 8d 14 c5 00 00 00 	lea    rdx,[rax*8+0x0]
  100cf1:	00 
  100cf2:	48 8d 05 07 d3 01 00 	lea    rax,[rip+0x1d307]        # 11e000 <PT_0>
  100cf9:	48 8b 0c 02          	mov    rcx,QWORD PTR [rdx+rax*1]
  100cfd:	48 8d 05 2c 93 02 00 	lea    rax,[rip+0x2932c]        # 12a030 <__KERN_DATA_END>
  100d04:	be 00 10 00 00       	mov    esi,0x1000
  100d09:	ba 00 00 00 00       	mov    edx,0x0
  100d0e:	48 f7 f6             	div    rsi
  100d11:	48 89 c2             	mov    rdx,rax
  100d14:	8b 45 d4             	mov    eax,DWORD PTR [rbp-0x2c]
  100d17:	48 01 d0             	add    rax,rdx
  100d1a:	48 ba 03 00 00 00 00 	movabs rdx,0x8000000000000003
  100d21:	00 00 80 
  100d24:	48 09 d1             	or     rcx,rdx
  100d27:	48 8d 14 c5 00 00 00 	lea    rdx,[rax*8+0x0]
  100d2e:	00 
  100d2f:	48 8d 05 ca d2 01 00 	lea    rax,[rip+0x1d2ca]        # 11e000 <PT_0>
  100d36:	48 89 0c 02          	mov    QWORD PTR [rdx+rax*1],rcx
  100d3a:	83 45 d4 01          	add    DWORD PTR [rbp-0x2c],0x1
  100d3e:	8b 45 d4             	mov    eax,DWORD PTR [rbp-0x2c]
  100d41:	48 39 45 d8          	cmp    QWORD PTR [rbp-0x28],rax
  100d45:	0f 87 0c ff ff ff    	ja     100c57 <kern_mem_map+0x2bb>
  100d4b:	90                   	nop
  100d4c:	90                   	nop
  100d4d:	5d                   	pop    rbp
  100d4e:	c3                   	ret    

0000000000100d4f <pga_init>:
  100d4f:	55                   	push   rbp
  100d50:	48 89 e5             	mov    rbp,rsp
  100d53:	48 8b 05 ee 72 00 00 	mov    rax,QWORD PTR [rip+0x72ee]        # 108048 <PML_4>
  100d5a:	ba 00 10 00 00       	mov    edx,0x1000
  100d5f:	be 00 00 00 00       	mov    esi,0x0
  100d64:	48 89 c7             	mov    rdi,rax
  100d67:	e8 29 38 00 00       	call   104595 <memset>
  100d6c:	48 8b 05 d5 72 00 00 	mov    rax,QWORD PTR [rip+0x72d5]        # 108048 <PML_4>
  100d73:	48 8d 15 86 a2 00 00 	lea    rdx,[rip+0xa286]        # 10b000 <PDP_0>
  100d7a:	48 89 10             	mov    QWORD PTR [rax],rdx
  100d7d:	48 8b 05 c4 72 00 00 	mov    rax,QWORD PTR [rip+0x72c4]        # 108048 <PML_4>
  100d84:	48 8b 10             	mov    rdx,QWORD PTR [rax]
  100d87:	48 8b 05 ba 72 00 00 	mov    rax,QWORD PTR [rip+0x72ba]        # 108048 <PML_4>
  100d8e:	48 83 ca 03          	or     rdx,0x3
  100d92:	48 89 10             	mov    QWORD PTR [rax],rdx
  100d95:	48 8d 05 64 92 00 00 	lea    rax,[rip+0x9264]        # 10a000 <PD_0>
  100d9c:	48 89 05 5d a2 00 00 	mov    QWORD PTR [rip+0xa25d],rax        # 10b000 <PDP_0>
  100da3:	48 8b 05 56 a2 00 00 	mov    rax,QWORD PTR [rip+0xa256]        # 10b000 <PDP_0>
  100daa:	48 83 c8 03          	or     rax,0x3
  100dae:	48 89 05 4b a2 00 00 	mov    QWORD PTR [rip+0xa24b],rax        # 10b000 <PDP_0>
  100db5:	48 8d 05 44 d2 01 00 	lea    rax,[rip+0x1d244]        # 11e000 <PT_0>
  100dbc:	48 89 05 3d 92 00 00 	mov    QWORD PTR [rip+0x923d],rax        # 10a000 <PD_0>
  100dc3:	48 8b 05 36 92 00 00 	mov    rax,QWORD PTR [rip+0x9236]        # 10a000 <PD_0>
  100dca:	48 83 c8 03          	or     rax,0x3
  100dce:	48 89 05 2b 92 00 00 	mov    QWORD PTR [rip+0x922b],rax        # 10a000 <PD_0>
  100dd5:	b8 00 00 00 00       	mov    eax,0x0
  100dda:	5d                   	pop    rbp
  100ddb:	c3                   	ret    

0000000000100ddc <pga_enable>:
  100ddc:	55                   	push   rbp
  100ddd:	48 89 e5             	mov    rbp,rsp
  100de0:	48 8b 05 61 72 00 00 	mov    rax,QWORD PTR [rip+0x7261]        # 108048 <PML_4>
  100de7:	0f 22 d8             	mov    cr3,rax
  100dea:	90                   	nop
  100deb:	5d                   	pop    rbp
  100dec:	c3                   	ret    

0000000000100ded <get_regions>:
  100ded:	55                   	push   rbp
  100dee:	48 89 e5             	mov    rbp,rsp
  100df1:	48 8b 05 d8 c2 01 00 	mov    rax,QWORD PTR [rip+0x1c2d8]        # 11d0d0 <X64+0x30>
  100df8:	5d                   	pop    rbp
  100df9:	c3                   	ret    

0000000000100dfa <getMEMID>:
  100dfa:	55                   	push   rbp
  100dfb:	48 89 e5             	mov    rbp,rsp
  100dfe:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
  100e02:	48 8b 05 c7 c2 01 00 	mov    rax,QWORD PTR [rip+0x1c2c7]        # 11d0d0 <X64+0x30>
  100e09:	48 85 c0             	test   rax,rax
  100e0c:	75 0d                	jne    100e1b <getMEMID+0x21>
  100e0e:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  100e12:	c6 00 00             	mov    BYTE PTR [rax],0x0
  100e15:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  100e19:	eb 73                	jmp    100e8e <getMEMID+0x94>
  100e1b:	48 8b 05 ae c2 01 00 	mov    rax,QWORD PTR [rip+0x1c2ae]        # 11d0d0 <X64+0x30>
  100e22:	8b 40 20             	mov    eax,DWORD PTR [rax+0x20]
  100e25:	89 c2                	mov    edx,eax
  100e27:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  100e2b:	48 89 50 08          	mov    QWORD PTR [rax+0x8],rdx
  100e2f:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  100e33:	48 c7 40 10 00 00 00 	mov    QWORD PTR [rax+0x10],0x0
  100e3a:	00 
  100e3b:	48 8b 05 8e c2 01 00 	mov    rax,QWORD PTR [rip+0x1c28e]        # 11d0d0 <X64+0x30>
  100e42:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  100e46:	c7 45 f4 00 00 00 00 	mov    DWORD PTR [rbp-0xc],0x0
  100e4d:	eb 2b                	jmp    100e7a <getMEMID+0x80>
  100e4f:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  100e53:	48 8b 50 10          	mov    rdx,QWORD PTR [rax+0x10]
  100e57:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  100e5b:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
  100e5f:	48 01 c2             	add    rdx,rax
  100e62:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  100e66:	48 89 50 10          	mov    QWORD PTR [rax+0x10],rdx
  100e6a:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  100e6e:	48 8b 40 28          	mov    rax,QWORD PTR [rax+0x28]
  100e72:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  100e76:	83 45 f4 01          	add    DWORD PTR [rbp-0xc],0x1
  100e7a:	8b 55 f4             	mov    edx,DWORD PTR [rbp-0xc]
  100e7d:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  100e81:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
  100e85:	48 39 c2             	cmp    rdx,rax
  100e88:	72 c5                	jb     100e4f <getMEMID+0x55>
  100e8a:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  100e8e:	5d                   	pop    rbp
  100e8f:	c3                   	ret    

0000000000100e90 <_CharEntry>:
  100e90:	55                   	push   rbp
  100e91:	48 89 e5             	mov    rbp,rsp
  100e94:	89 f8                	mov    eax,edi
  100e96:	88 45 ec             	mov    BYTE PTR [rbp-0x14],al
  100e99:	66 c7 45 fe 00 00    	mov    WORD PTR [rbp-0x2],0x0
  100e9f:	0f b6 05 5c 51 02 00 	movzx  eax,BYTE PTR [rip+0x2515c]        # 126002 <back_color>
  100ea6:	88 45 fd             	mov    BYTE PTR [rbp-0x3],al
  100ea9:	0f b6 45 ec          	movzx  eax,BYTE PTR [rbp-0x14]
  100ead:	88 45 fc             	mov    BYTE PTR [rbp-0x4],al
  100eb0:	c0 65 fd 04          	shl    BYTE PTR [rbp-0x3],0x4
  100eb4:	0f b6 05 4d 71 00 00 	movzx  eax,BYTE PTR [rip+0x714d]        # 108008 <fore_color>
  100ebb:	08 45 fd             	or     BYTE PTR [rbp-0x3],al
  100ebe:	0f b6 45 fd          	movzx  eax,BYTE PTR [rbp-0x3]
  100ec2:	66 89 45 fe          	mov    WORD PTR [rbp-0x2],ax
  100ec6:	66 c1 65 fe 08       	shl    WORD PTR [rbp-0x2],0x8
  100ecb:	0f b6 45 fc          	movzx  eax,BYTE PTR [rbp-0x4]
  100ecf:	66 09 45 fe          	or     WORD PTR [rbp-0x2],ax
  100ed3:	0f b7 45 fe          	movzx  eax,WORD PTR [rbp-0x2]
  100ed7:	5d                   	pop    rbp
  100ed8:	c3                   	ret    

0000000000100ed9 <_setCursorPos>:
  100ed9:	55                   	push   rbp
  100eda:	48 89 e5             	mov    rbp,rsp
  100edd:	48 83 ec 10          	sub    rsp,0x10
  100ee1:	89 7d fc             	mov    DWORD PTR [rbp-0x4],edi
  100ee4:	89 75 f8             	mov    DWORD PTR [rbp-0x8],esi
  100ee7:	8b 45 f8             	mov    eax,DWORD PTR [rbp-0x8]
  100eea:	89 c2                	mov    edx,eax
  100eec:	89 d0                	mov    eax,edx
  100eee:	c1 e0 02             	shl    eax,0x2
  100ef1:	01 d0                	add    eax,edx
  100ef3:	c1 e0 04             	shl    eax,0x4
  100ef6:	89 c2                	mov    edx,eax
  100ef8:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  100efb:	01 d0                	add    eax,edx
  100efd:	66 89 05 00 51 02 00 	mov    WORD PTR [rip+0x25100],ax        # 126004 <cursor_pos>
  100f04:	be 0f 00 00 00       	mov    esi,0xf
  100f09:	bf d4 03 00 00       	mov    edi,0x3d4
  100f0e:	e8 cc f3 ff ff       	call   1002df <outb>
  100f13:	0f b7 05 ea 50 02 00 	movzx  eax,WORD PTR [rip+0x250ea]        # 126004 <cursor_pos>
  100f1a:	0f b6 c0             	movzx  eax,al
  100f1d:	89 c6                	mov    esi,eax
  100f1f:	bf d5 03 00 00       	mov    edi,0x3d5
  100f24:	e8 b6 f3 ff ff       	call   1002df <outb>
  100f29:	be 0e 00 00 00       	mov    esi,0xe
  100f2e:	bf d4 03 00 00       	mov    edi,0x3d4
  100f33:	e8 a7 f3 ff ff       	call   1002df <outb>
  100f38:	0f b7 05 c5 50 02 00 	movzx  eax,WORD PTR [rip+0x250c5]        # 126004 <cursor_pos>
  100f3f:	66 c1 e8 08          	shr    ax,0x8
  100f43:	0f b6 c0             	movzx  eax,al
  100f46:	89 c6                	mov    esi,eax
  100f48:	bf d5 03 00 00       	mov    edi,0x3d5
  100f4d:	e8 8d f3 ff ff       	call   1002df <outb>
  100f52:	90                   	nop
  100f53:	c9                   	leave  
  100f54:	c3                   	ret    

0000000000100f55 <_getCursorPosX>:
  100f55:	55                   	push   rbp
  100f56:	48 89 e5             	mov    rbp,rsp
  100f59:	0f b7 0d a4 50 02 00 	movzx  ecx,WORD PTR [rip+0x250a4]        # 126004 <cursor_pos>
  100f60:	0f b7 c1             	movzx  eax,cx
  100f63:	69 c0 cd cc 00 00    	imul   eax,eax,0xcccd
  100f69:	c1 e8 10             	shr    eax,0x10
  100f6c:	89 c2                	mov    edx,eax
  100f6e:	66 c1 ea 06          	shr    dx,0x6
  100f72:	89 d0                	mov    eax,edx
  100f74:	c1 e0 02             	shl    eax,0x2
  100f77:	01 d0                	add    eax,edx
  100f79:	c1 e0 04             	shl    eax,0x4
  100f7c:	29 c1                	sub    ecx,eax
  100f7e:	89 ca                	mov    edx,ecx
  100f80:	0f b7 c2             	movzx  eax,dx
  100f83:	5d                   	pop    rbp
  100f84:	c3                   	ret    

0000000000100f85 <_getCursorPosY>:
  100f85:	55                   	push   rbp
  100f86:	48 89 e5             	mov    rbp,rsp
  100f89:	0f b7 05 74 50 02 00 	movzx  eax,WORD PTR [rip+0x25074]        # 126004 <cursor_pos>
  100f90:	0f b7 c0             	movzx  eax,ax
  100f93:	69 c0 cd cc 00 00    	imul   eax,eax,0xcccd
  100f99:	c1 e8 10             	shr    eax,0x10
  100f9c:	66 c1 e8 06          	shr    ax,0x6
  100fa0:	0f b7 c0             	movzx  eax,ax
  100fa3:	5d                   	pop    rbp
  100fa4:	c3                   	ret    

0000000000100fa5 <_clearScreen>:
  100fa5:	55                   	push   rbp
  100fa6:	48 89 e5             	mov    rbp,rsp
  100fa9:	53                   	push   rbx
  100faa:	48 83 ec 18          	sub    rsp,0x18
  100fae:	c7 45 ec 00 00 00 00 	mov    DWORD PTR [rbp-0x14],0x0
  100fb5:	eb 22                	jmp    100fd9 <_clearScreen+0x34>
  100fb7:	48 8b 05 52 70 00 00 	mov    rax,QWORD PTR [rip+0x7052]        # 108010 <display_buffer>
  100fbe:	8b 55 ec             	mov    edx,DWORD PTR [rbp-0x14]
  100fc1:	48 01 d2             	add    rdx,rdx
  100fc4:	48 8d 1c 10          	lea    rbx,[rax+rdx*1]
  100fc8:	bf 00 00 00 00       	mov    edi,0x0
  100fcd:	e8 be fe ff ff       	call   100e90 <_CharEntry>
  100fd2:	66 89 03             	mov    WORD PTR [rbx],ax
  100fd5:	83 45 ec 01          	add    DWORD PTR [rbp-0x14],0x1
  100fd9:	81 7d ec cf 07 00 00 	cmp    DWORD PTR [rbp-0x14],0x7cf
  100fe0:	76 d5                	jbe    100fb7 <_clearScreen+0x12>
  100fe2:	be 00 00 00 00       	mov    esi,0x0
  100fe7:	bf 00 00 00 00       	mov    edi,0x0
  100fec:	e8 e8 fe ff ff       	call   100ed9 <_setCursorPos>
  100ff1:	90                   	nop
  100ff2:	48 83 c4 18          	add    rsp,0x18
  100ff6:	5b                   	pop    rbx
  100ff7:	5d                   	pop    rbp
  100ff8:	c3                   	ret    

0000000000100ff9 <_scrollStep>:
  100ff9:	55                   	push   rbp
  100ffa:	48 89 e5             	mov    rbp,rsp
  100ffd:	53                   	push   rbx
  100ffe:	48 83 ec 18          	sub    rsp,0x18
  101002:	c7 45 ec 01 00 00 00 	mov    DWORD PTR [rbp-0x14],0x1
  101009:	eb 67                	jmp    101072 <_scrollStep+0x79>
  10100b:	c7 45 e8 00 00 00 00 	mov    DWORD PTR [rbp-0x18],0x0
  101012:	eb 54                	jmp    101068 <_scrollStep+0x6f>
  101014:	48 8b 0d f5 6f 00 00 	mov    rcx,QWORD PTR [rip+0x6ff5]        # 108010 <display_buffer>
  10101b:	8b 45 ec             	mov    eax,DWORD PTR [rbp-0x14]
  10101e:	8d 50 ff             	lea    edx,[rax-0x1]
  101021:	89 d0                	mov    eax,edx
  101023:	c1 e0 02             	shl    eax,0x2
  101026:	01 d0                	add    eax,edx
  101028:	c1 e0 04             	shl    eax,0x4
  10102b:	89 c2                	mov    edx,eax
  10102d:	8b 45 e8             	mov    eax,DWORD PTR [rbp-0x18]
  101030:	01 d0                	add    eax,edx
  101032:	48 98                	cdqe   
  101034:	48 01 c0             	add    rax,rax
  101037:	48 01 c1             	add    rcx,rax
  10103a:	48 8b 35 cf 6f 00 00 	mov    rsi,QWORD PTR [rip+0x6fcf]        # 108010 <display_buffer>
  101041:	8b 55 ec             	mov    edx,DWORD PTR [rbp-0x14]
  101044:	89 d0                	mov    eax,edx
  101046:	c1 e0 02             	shl    eax,0x2
  101049:	01 d0                	add    eax,edx
  10104b:	c1 e0 04             	shl    eax,0x4
  10104e:	89 c2                	mov    edx,eax
  101050:	8b 45 e8             	mov    eax,DWORD PTR [rbp-0x18]
  101053:	01 d0                	add    eax,edx
  101055:	48 98                	cdqe   
  101057:	48 01 c0             	add    rax,rax
  10105a:	48 8d 14 06          	lea    rdx,[rsi+rax*1]
  10105e:	0f b7 01             	movzx  eax,WORD PTR [rcx]
  101061:	66 89 02             	mov    WORD PTR [rdx],ax
  101064:	83 45 e8 01          	add    DWORD PTR [rbp-0x18],0x1
  101068:	83 7d e8 4f          	cmp    DWORD PTR [rbp-0x18],0x4f
  10106c:	7e a6                	jle    101014 <_scrollStep+0x1b>
  10106e:	83 45 ec 01          	add    DWORD PTR [rbp-0x14],0x1
  101072:	83 7d ec 18          	cmp    DWORD PTR [rbp-0x14],0x18
  101076:	7e 93                	jle    10100b <_scrollStep+0x12>
  101078:	b8 00 00 00 00       	mov    eax,0x0
  10107d:	e8 03 ff ff ff       	call   100f85 <_getCursorPosY>
  101082:	8d 58 ff             	lea    ebx,[rax-0x1]
  101085:	b8 00 00 00 00       	mov    eax,0x0
  10108a:	e8 c6 fe ff ff       	call   100f55 <_getCursorPosX>
  10108f:	89 de                	mov    esi,ebx
  101091:	89 c7                	mov    edi,eax
  101093:	e8 41 fe ff ff       	call   100ed9 <_setCursorPos>
  101098:	90                   	nop
  101099:	48 83 c4 18          	add    rsp,0x18
  10109d:	5b                   	pop    rbx
  10109e:	5d                   	pop    rbp
  10109f:	c3                   	ret    

00000000001010a0 <arch_printf>:
  1010a0:	55                   	push   rbp
  1010a1:	48 89 e5             	mov    rbp,rsp
  1010a4:	53                   	push   rbx
  1010a5:	48 83 ec 38          	sub    rsp,0x38
  1010a9:	48 89 7d c8          	mov    QWORD PTR [rbp-0x38],rdi
  1010ad:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
  1010b1:	48 89 c7             	mov    rdi,rax
  1010b4:	e8 5a 32 00 00       	call   104313 <strlen>
  1010b9:	48 89 45 e0          	mov    QWORD PTR [rbp-0x20],rax
  1010bd:	48 c7 45 e8 00 00 00 	mov    QWORD PTR [rbp-0x18],0x0
  1010c4:	00 
  1010c5:	eb 7b                	jmp    101142 <arch_printf+0xa2>
  1010c7:	48 8b 55 c8          	mov    rdx,QWORD PTR [rbp-0x38]
  1010cb:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  1010cf:	48 01 d0             	add    rax,rdx
  1010d2:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  1010d5:	0f be c0             	movsx  eax,al
  1010d8:	83 f8 0a             	cmp    eax,0xa
  1010db:	75 1b                	jne    1010f8 <arch_printf+0x58>
  1010dd:	b8 00 00 00 00       	mov    eax,0x0
  1010e2:	e8 9e fe ff ff       	call   100f85 <_getCursorPosY>
  1010e7:	83 c0 01             	add    eax,0x1
  1010ea:	89 c6                	mov    esi,eax
  1010ec:	bf 00 00 00 00       	mov    edi,0x0
  1010f1:	e8 e3 fd ff ff       	call   100ed9 <_setCursorPos>
  1010f6:	eb 45                	jmp    10113d <arch_printf+0x9d>
  1010f8:	48 8b 55 c8          	mov    rdx,QWORD PTR [rbp-0x38]
  1010fc:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  101100:	48 01 d0             	add    rax,rdx
  101103:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  101106:	0f b6 c0             	movzx  eax,al
  101109:	48 8b 15 00 6f 00 00 	mov    rdx,QWORD PTR [rip+0x6f00]        # 108010 <display_buffer>
  101110:	0f b7 0d ed 4e 02 00 	movzx  ecx,WORD PTR [rip+0x24eed]        # 126004 <cursor_pos>
  101117:	0f b7 c9             	movzx  ecx,cx
  10111a:	48 01 c9             	add    rcx,rcx
  10111d:	48 8d 1c 0a          	lea    rbx,[rdx+rcx*1]
  101121:	89 c7                	mov    edi,eax
  101123:	e8 68 fd ff ff       	call   100e90 <_CharEntry>
  101128:	66 89 03             	mov    WORD PTR [rbx],ax
  10112b:	0f b7 05 d2 4e 02 00 	movzx  eax,WORD PTR [rip+0x24ed2]        # 126004 <cursor_pos>
  101132:	83 c0 01             	add    eax,0x1
  101135:	66 89 05 c8 4e 02 00 	mov    WORD PTR [rip+0x24ec8],ax        # 126004 <cursor_pos>
  10113c:	90                   	nop
  10113d:	48 83 45 e8 01       	add    QWORD PTR [rbp-0x18],0x1
  101142:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  101146:	48 3b 45 e0          	cmp    rax,QWORD PTR [rbp-0x20]
  10114a:	0f 82 77 ff ff ff    	jb     1010c7 <arch_printf+0x27>
  101150:	0f b7 05 ad 4e 02 00 	movzx  eax,WORD PTR [rip+0x24ead]        # 126004 <cursor_pos>
  101157:	66 3d 80 07          	cmp    ax,0x780
  10115b:	75 0a                	jne    101167 <arch_printf+0xc7>
  10115d:	b8 00 00 00 00       	mov    eax,0x0
  101162:	e8 92 fe ff ff       	call   100ff9 <_scrollStep>
  101167:	0f b7 05 96 4e 02 00 	movzx  eax,WORD PTR [rip+0x24e96]        # 126004 <cursor_pos>
  10116e:	0f b7 c0             	movzx  eax,ax
  101171:	69 c0 cd cc 00 00    	imul   eax,eax,0xcccd
  101177:	c1 e8 10             	shr    eax,0x10
  10117a:	66 c1 e8 06          	shr    ax,0x6
  10117e:	0f b7 c0             	movzx  eax,ax
  101181:	89 45 dc             	mov    DWORD PTR [rbp-0x24],eax
  101184:	0f b7 0d 79 4e 02 00 	movzx  ecx,WORD PTR [rip+0x24e79]        # 126004 <cursor_pos>
  10118b:	0f b7 c1             	movzx  eax,cx
  10118e:	69 c0 cd cc 00 00    	imul   eax,eax,0xcccd
  101194:	c1 e8 10             	shr    eax,0x10
  101197:	89 c2                	mov    edx,eax
  101199:	66 c1 ea 06          	shr    dx,0x6
  10119d:	89 d0                	mov    eax,edx
  10119f:	c1 e0 02             	shl    eax,0x2
  1011a2:	01 d0                	add    eax,edx
  1011a4:	c1 e0 04             	shl    eax,0x4
  1011a7:	29 c1                	sub    ecx,eax
  1011a9:	89 ca                	mov    edx,ecx
  1011ab:	0f b7 c2             	movzx  eax,dx
  1011ae:	89 45 d8             	mov    DWORD PTR [rbp-0x28],eax
  1011b1:	8b 55 dc             	mov    edx,DWORD PTR [rbp-0x24]
  1011b4:	8b 45 d8             	mov    eax,DWORD PTR [rbp-0x28]
  1011b7:	89 d6                	mov    esi,edx
  1011b9:	89 c7                	mov    edi,eax
  1011bb:	e8 19 fd ff ff       	call   100ed9 <_setCursorPos>
  1011c0:	0f b7 05 3d 4e 02 00 	movzx  eax,WORD PTR [rip+0x24e3d]        # 126004 <cursor_pos>
  1011c7:	66 3d 80 07          	cmp    ax,0x780
  1011cb:	75 0c                	jne    1011d9 <arch_printf+0x139>
  1011cd:	b8 00 00 00 00       	mov    eax,0x0
  1011d2:	e8 22 fe ff ff       	call   100ff9 <_scrollStep>
  1011d7:	eb e7                	jmp    1011c0 <arch_printf+0x120>
  1011d9:	b8 01 00 00 00       	mov    eax,0x1
  1011de:	48 83 c4 38          	add    rsp,0x38
  1011e2:	5b                   	pop    rbx
  1011e3:	5d                   	pop    rbp
  1011e4:	c3                   	ret    

00000000001011e5 <printf_init>:
  1011e5:	55                   	push   rbp
  1011e6:	48 89 e5             	mov    rbp,rsp
  1011e9:	48 8d 35 28 50 00 00 	lea    rsi,[rip+0x5028]        # 106218 <PRINTF_FB_ENABLE+0x8>
  1011f0:	bf 04 00 00 00       	mov    edi,0x4
  1011f5:	b8 00 00 00 00       	mov    eax,0x0
  1011fa:	e8 2b 19 00 00       	call   102b2a <pr_log>
  1011ff:	b8 01 00 00 00       	mov    eax,0x1
  101204:	84 c0                	test   al,al
  101206:	75 07                	jne    10120f <printf_init+0x2a>
  101208:	b8 00 00 00 00       	mov    eax,0x0
  10120d:	eb 38                	jmp    101247 <printf_init+0x62>
  10120f:	0f b6 05 f0 4d 02 00 	movzx  eax,BYTE PTR [rip+0x24df0]        # 126006 <hasInit>
  101216:	84 c0                	test   al,al
  101218:	75 11                	jne    10122b <printf_init+0x46>
  10121a:	c6 05 e5 4d 02 00 01 	mov    BYTE PTR [rip+0x24de5],0x1        # 126006 <hasInit>
  101221:	b8 00 00 00 00       	mov    eax,0x0
  101226:	e8 7a fd ff ff       	call   100fa5 <_clearScreen>
  10122b:	c6 05 ce ad 00 00 01 	mov    BYTE PTR [rip+0xadce],0x1        # 10c000 <printf_fallback_fn>
  101232:	48 8d 05 67 fe ff ff 	lea    rax,[rip+0xfffffffffffffe67]        # 1010a0 <arch_printf>
  101239:	48 89 05 c8 ad 00 00 	mov    QWORD PTR [rip+0xadc8],rax        # 10c008 <printf_fallback_fn+0x8>
  101240:	48 8d 05 b9 ad 00 00 	lea    rax,[rip+0xadb9]        # 10c000 <printf_fallback_fn>
  101247:	5d                   	pop    rbp
  101248:	c3                   	ret    

0000000000101249 <TraceName>:
  101249:	55                   	push   rbp
  10124a:	48 89 e5             	mov    rbp,rsp
  10124d:	48 89 7d d8          	mov    QWORD PTR [rbp-0x28],rdi
  101251:	48 8b 05 48 be 01 00 	mov    rax,QWORD PTR [rip+0x1be48]        # 11d0a0 <X64>
  101258:	48 85 c0             	test   rax,rax
  10125b:	74 0b                	je     101268 <TraceName+0x1f>
  10125d:	8b 05 45 be 01 00    	mov    eax,DWORD PTR [rip+0x1be45]        # 11d0a8 <X64+0x8>
  101263:	83 f8 17             	cmp    eax,0x17
  101266:	77 0c                	ja     101274 <TraceName+0x2b>
  101268:	48 8b 05 e1 6d 00 00 	mov    rax,QWORD PTR [rip+0x6de1]        # 108050 <func_noname>
  10126f:	e9 fb 01 00 00       	jmp    10146f <TraceName+0x226>
  101274:	c7 45 fc 00 00 00 00 	mov    DWORD PTR [rbp-0x4],0x0
  10127b:	48 8b 0d 1e be 01 00 	mov    rcx,QWORD PTR [rip+0x1be1e]        # 11d0a0 <X64>
  101282:	8b 55 fc             	mov    edx,DWORD PTR [rbp-0x4]
  101285:	48 89 d0             	mov    rax,rdx
  101288:	48 01 c0             	add    rax,rax
  10128b:	48 01 d0             	add    rax,rdx
  10128e:	48 c1 e0 03          	shl    rax,0x3
  101292:	48 01 c8             	add    rax,rcx
  101295:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
  101299:	48 8b 55 d8          	mov    rdx,QWORD PTR [rbp-0x28]
  10129d:	48 29 c2             	sub    rdx,rax
  1012a0:	48 89 d0             	mov    rax,rdx
  1012a3:	48 89 45 f0          	mov    QWORD PTR [rbp-0x10],rax
  1012a7:	c7 45 ec 01 00 00 00 	mov    DWORD PTR [rbp-0x14],0x1
  1012ae:	e9 70 01 00 00       	jmp    101423 <TraceName+0x1da>
  1012b3:	48 8b 0d e6 bd 01 00 	mov    rcx,QWORD PTR [rip+0x1bde6]        # 11d0a0 <X64>
  1012ba:	8b 55 ec             	mov    edx,DWORD PTR [rbp-0x14]
  1012bd:	48 89 d0             	mov    rax,rdx
  1012c0:	48 01 c0             	add    rax,rax
  1012c3:	48 01 d0             	add    rax,rdx
  1012c6:	48 c1 e0 03          	shl    rax,0x3
  1012ca:	48 01 c8             	add    rax,rcx
  1012cd:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
  1012d1:	48 39 45 d8          	cmp    QWORD PTR [rbp-0x28],rax
  1012d5:	0f 82 43 01 00 00    	jb     10141e <TraceName+0x1d5>
  1012db:	48 8b 0d be bd 01 00 	mov    rcx,QWORD PTR [rip+0x1bdbe]        # 11d0a0 <X64>
  1012e2:	8b 55 ec             	mov    edx,DWORD PTR [rbp-0x14]
  1012e5:	48 89 d0             	mov    rax,rdx
  1012e8:	48 01 c0             	add    rax,rax
  1012eb:	48 01 d0             	add    rax,rdx
  1012ee:	48 c1 e0 03          	shl    rax,0x3
  1012f2:	48 01 c8             	add    rax,rcx
  1012f5:	0f b6 40 04          	movzx  eax,BYTE PTR [rax+0x4]
  1012f9:	0f b6 c0             	movzx  eax,al
  1012fc:	83 e0 0f             	and    eax,0xf
  1012ff:	83 f8 02             	cmp    eax,0x2
  101302:	74 2c                	je     101330 <TraceName+0xe7>
  101304:	48 8b 0d 95 bd 01 00 	mov    rcx,QWORD PTR [rip+0x1bd95]        # 11d0a0 <X64>
  10130b:	8b 55 ec             	mov    edx,DWORD PTR [rbp-0x14]
  10130e:	48 89 d0             	mov    rax,rdx
  101311:	48 01 c0             	add    rax,rax
  101314:	48 01 d0             	add    rax,rdx
  101317:	48 c1 e0 03          	shl    rax,0x3
  10131b:	48 01 c8             	add    rax,rcx
  10131e:	0f b6 40 04          	movzx  eax,BYTE PTR [rax+0x4]
  101322:	0f b6 c0             	movzx  eax,al
  101325:	83 e0 0f             	and    eax,0xf
  101328:	85 c0                	test   eax,eax
  10132a:	0f 85 ee 00 00 00    	jne    10141e <TraceName+0x1d5>
  101330:	48 8b 0d 69 bd 01 00 	mov    rcx,QWORD PTR [rip+0x1bd69]        # 11d0a0 <X64>
  101337:	8b 55 ec             	mov    edx,DWORD PTR [rbp-0x14]
  10133a:	48 89 d0             	mov    rax,rdx
  10133d:	48 01 c0             	add    rax,rax
  101340:	48 01 d0             	add    rax,rdx
  101343:	48 c1 e0 03          	shl    rax,0x3
  101347:	48 01 c8             	add    rax,rcx
  10134a:	0f b6 40 04          	movzx  eax,BYTE PTR [rax+0x4]
  10134e:	0f b6 c0             	movzx  eax,al
  101351:	83 e0 0f             	and    eax,0xf
  101354:	83 f8 02             	cmp    eax,0x2
  101357:	74 5c                	je     1013b5 <TraceName+0x16c>
  101359:	48 8b 0d 40 bd 01 00 	mov    rcx,QWORD PTR [rip+0x1bd40]        # 11d0a0 <X64>
  101360:	8b 55 ec             	mov    edx,DWORD PTR [rbp-0x14]
  101363:	48 89 d0             	mov    rax,rdx
  101366:	48 01 c0             	add    rax,rax
  101369:	48 01 d0             	add    rax,rdx
  10136c:	48 c1 e0 03          	shl    rax,0x3
  101370:	48 01 c8             	add    rax,rcx
  101373:	0f b6 40 04          	movzx  eax,BYTE PTR [rax+0x4]
  101377:	0f b6 c0             	movzx  eax,al
  10137a:	83 e0 0f             	and    eax,0xf
  10137d:	85 c0                	test   eax,eax
  10137f:	74 34                	je     1013b5 <TraceName+0x16c>
  101381:	8b 45 ec             	mov    eax,DWORD PTR [rbp-0x14]
  101384:	89 45 fc             	mov    DWORD PTR [rbp-0x4],eax
  101387:	48 8b 0d 12 bd 01 00 	mov    rcx,QWORD PTR [rip+0x1bd12]        # 11d0a0 <X64>
  10138e:	8b 55 ec             	mov    edx,DWORD PTR [rbp-0x14]
  101391:	48 89 d0             	mov    rax,rdx
  101394:	48 01 c0             	add    rax,rax
  101397:	48 01 d0             	add    rax,rdx
  10139a:	48 c1 e0 03          	shl    rax,0x3
  10139e:	48 01 c8             	add    rax,rcx
  1013a1:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
  1013a5:	48 8b 55 d8          	mov    rdx,QWORD PTR [rbp-0x28]
  1013a9:	48 29 c2             	sub    rdx,rax
  1013ac:	48 89 d0             	mov    rax,rdx
  1013af:	48 89 45 f0          	mov    QWORD PTR [rbp-0x10],rax
  1013b3:	eb 6a                	jmp    10141f <TraceName+0x1d6>
  1013b5:	48 8b 0d e4 bc 01 00 	mov    rcx,QWORD PTR [rip+0x1bce4]        # 11d0a0 <X64>
  1013bc:	8b 55 ec             	mov    edx,DWORD PTR [rbp-0x14]
  1013bf:	48 89 d0             	mov    rax,rdx
  1013c2:	48 01 c0             	add    rax,rax
  1013c5:	48 01 d0             	add    rax,rdx
  1013c8:	48 c1 e0 03          	shl    rax,0x3
  1013cc:	48 01 c8             	add    rax,rcx
  1013cf:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
  1013d3:	48 8b 55 d8          	mov    rdx,QWORD PTR [rbp-0x28]
  1013d7:	48 29 c2             	sub    rdx,rax
  1013da:	48 89 d0             	mov    rax,rdx
  1013dd:	48 39 45 f0          	cmp    QWORD PTR [rbp-0x10],rax
  1013e1:	76 3c                	jbe    10141f <TraceName+0x1d6>
  1013e3:	8b 45 ec             	mov    eax,DWORD PTR [rbp-0x14]
  1013e6:	89 45 fc             	mov    DWORD PTR [rbp-0x4],eax
  1013e9:	48 8b 0d b0 bc 01 00 	mov    rcx,QWORD PTR [rip+0x1bcb0]        # 11d0a0 <X64>
  1013f0:	8b 55 ec             	mov    edx,DWORD PTR [rbp-0x14]
  1013f3:	48 89 d0             	mov    rax,rdx
  1013f6:	48 01 c0             	add    rax,rax
  1013f9:	48 01 d0             	add    rax,rdx
  1013fc:	48 c1 e0 03          	shl    rax,0x3
  101400:	48 01 c8             	add    rax,rcx
  101403:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
  101407:	48 8b 55 d8          	mov    rdx,QWORD PTR [rbp-0x28]
  10140b:	48 29 c2             	sub    rdx,rax
  10140e:	48 89 d0             	mov    rax,rdx
  101411:	48 89 45 f0          	mov    QWORD PTR [rbp-0x10],rax
  101415:	48 83 7d f0 00       	cmp    QWORD PTR [rbp-0x10],0x0
  10141a:	74 2a                	je     101446 <TraceName+0x1fd>
  10141c:	eb 01                	jmp    10141f <TraceName+0x1d6>
  10141e:	90                   	nop
  10141f:	83 45 ec 01          	add    DWORD PTR [rbp-0x14],0x1
  101423:	8b 05 7f bc 01 00    	mov    eax,DWORD PTR [rip+0x1bc7f]        # 11d0a8 <X64+0x8>
  101429:	89 c2                	mov    edx,eax
  10142b:	b8 ab aa aa aa       	mov    eax,0xaaaaaaab
  101430:	48 0f af c2          	imul   rax,rdx
  101434:	48 c1 e8 20          	shr    rax,0x20
  101438:	c1 e8 04             	shr    eax,0x4
  10143b:	39 45 ec             	cmp    DWORD PTR [rbp-0x14],eax
  10143e:	0f 82 6f fe ff ff    	jb     1012b3 <TraceName+0x6a>
  101444:	eb 01                	jmp    101447 <TraceName+0x1fe>
  101446:	90                   	nop
  101447:	48 8b 0d 62 bc 01 00 	mov    rcx,QWORD PTR [rip+0x1bc62]        # 11d0b0 <X64+0x10>
  10144e:	48 8b 35 4b bc 01 00 	mov    rsi,QWORD PTR [rip+0x1bc4b]        # 11d0a0 <X64>
  101455:	8b 55 fc             	mov    edx,DWORD PTR [rbp-0x4]
  101458:	48 89 d0             	mov    rax,rdx
  10145b:	48 01 c0             	add    rax,rax
  10145e:	48 01 d0             	add    rax,rdx
  101461:	48 c1 e0 03          	shl    rax,0x3
  101465:	48 01 f0             	add    rax,rsi
  101468:	8b 00                	mov    eax,DWORD PTR [rax]
  10146a:	89 c0                	mov    eax,eax
  10146c:	48 01 c8             	add    rax,rcx
  10146f:	5d                   	pop    rbp
  101470:	c3                   	ret    

0000000000101471 <PrintStackTrace>:
  101471:	55                   	push   rbp
  101472:	48 89 e5             	mov    rbp,rsp
  101475:	48 83 ec 10          	sub    rsp,0x10
  101479:	48 8d 3d d8 4d 00 00 	lea    rdi,[rip+0x4dd8]        # 106258 <PRINTF_FB_ENABLE+0x48>
  101480:	b8 00 00 00 00       	mov    eax,0x0
  101485:	e8 49 2d 00 00       	call   1041d3 <printf>
  10148a:	48 c7 45 f8 00 00 00 	mov    QWORD PTR [rbp-0x8],0x0
  101491:	00 
  101492:	48 89 e8             	mov    rax,rbp
  101495:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  101499:	48 83 7d f8 00       	cmp    QWORD PTR [rbp-0x8],0x0
  10149e:	74 69                	je     101509 <PrintStackTrace+0x98>
  1014a0:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1014a4:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
  1014a8:	48 89 c7             	mov    rdi,rax
  1014ab:	e8 d7 32 00 00       	call   104787 <hex_str>
  1014b0:	48 89 c7             	mov    rdi,rax
  1014b3:	b8 00 00 00 00       	mov    eax,0x0
  1014b8:	e8 16 2d 00 00       	call   1041d3 <printf>
  1014bd:	48 8d 3d bb 4d 00 00 	lea    rdi,[rip+0x4dbb]        # 10627f <PRINTF_FB_ENABLE+0x6f>
  1014c4:	b8 00 00 00 00       	mov    eax,0x0
  1014c9:	e8 05 2d 00 00       	call   1041d3 <printf>
  1014ce:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1014d2:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
  1014d6:	48 89 c7             	mov    rdi,rax
  1014d9:	e8 6b fd ff ff       	call   101249 <TraceName>
  1014de:	48 89 c7             	mov    rdi,rax
  1014e1:	b8 00 00 00 00       	mov    eax,0x0
  1014e6:	e8 e8 2c 00 00       	call   1041d3 <printf>
  1014eb:	48 8d 3d 8f 4d 00 00 	lea    rdi,[rip+0x4d8f]        # 106281 <PRINTF_FB_ENABLE+0x71>
  1014f2:	b8 00 00 00 00       	mov    eax,0x0
  1014f7:	e8 d7 2c 00 00       	call   1041d3 <printf>
  1014fc:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  101500:	48 8b 00             	mov    rax,QWORD PTR [rax]
  101503:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  101507:	eb 90                	jmp    101499 <PrintStackTrace+0x28>
  101509:	90                   	nop
  10150a:	90                   	nop
  10150b:	c9                   	leave  
  10150c:	c3                   	ret    

000000000010150d <get_gdt_entry>:
  10150d:	55                   	push   rbp
  10150e:	48 89 e5             	mov    rbp,rsp
  101511:	89 f8                	mov    eax,edi
  101513:	66 89 45 fc          	mov    WORD PTR [rbp-0x4],ax
  101517:	66 83 7d fc 05       	cmp    WORD PTR [rbp-0x4],0x5
  10151c:	76 07                	jbe    101525 <get_gdt_entry+0x18>
  10151e:	b8 00 00 00 00       	mov    eax,0x0
  101523:	eb 12                	jmp    101537 <get_gdt_entry+0x2a>
  101525:	48 8b 05 d4 fa 01 00 	mov    rax,QWORD PTR [rip+0x1fad4]        # 121000 <GDT>
  10152c:	0f b7 55 fc          	movzx  edx,WORD PTR [rbp-0x4]
  101530:	48 c1 e2 03          	shl    rdx,0x3
  101534:	48 01 d0             	add    rax,rdx
  101537:	5d                   	pop    rbp
  101538:	c3                   	ret    

0000000000101539 <get_gdt>:
  101539:	55                   	push   rbp
  10153a:	48 89 e5             	mov    rbp,rsp
  10153d:	48 83 ec 10          	sub    rsp,0x10
  101541:	48 8d 45 f6          	lea    rax,[rbp-0xa]
  101545:	48 89 c7             	mov    rdi,rax
  101548:	e8 41 f3 ff ff       	call   10088e <gdtr_store>
  10154d:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  101551:	48 89 05 a8 fa 01 00 	mov    QWORD PTR [rip+0x1faa8],rax        # 121000 <GDT>
  101558:	90                   	nop
  101559:	c9                   	leave  
  10155a:	c3                   	ret    

000000000010155b <gdt_entry_map>:
  10155b:	55                   	push   rbp
  10155c:	48 89 e5             	mov    rbp,rsp
  10155f:	48 83 ec 10          	sub    rsp,0x10
  101563:	bf 05 00 00 00       	mov    edi,0x5
  101568:	e8 a0 ff ff ff       	call   10150d <get_gdt_entry>
  10156d:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  101571:	48 83 7d f8 00       	cmp    QWORD PTR [rbp-0x8],0x0
  101576:	75 0c                	jne    101584 <gdt_entry_map+0x29>
  101578:	48 8d 3d 04 4d 00 00 	lea    rdi,[rip+0x4d04]        # 106283 <PRINTF_FB_ENABLE+0x73>
  10157f:	e8 3c 14 00 00       	call   1029c0 <panic>
  101584:	48 8b 05 cd 6a 00 00 	mov    rax,QWORD PTR [rip+0x6acd]        # 108058 <proc_tss>
  10158b:	48 89 45 f0          	mov    QWORD PTR [rbp-0x10],rax
  10158f:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  101593:	89 c2                	mov    edx,eax
  101595:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  101599:	66 89 50 02          	mov    WORD PTR [rax+0x2],dx
  10159d:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  1015a1:	48 c1 e8 10          	shr    rax,0x10
  1015a5:	89 c2                	mov    edx,eax
  1015a7:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1015ab:	88 50 04             	mov    BYTE PTR [rax+0x4],dl
  1015ae:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  1015b2:	48 c1 e8 18          	shr    rax,0x18
  1015b6:	89 c2                	mov    edx,eax
  1015b8:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1015bc:	88 50 07             	mov    BYTE PTR [rax+0x7],dl
  1015bf:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1015c3:	66 c7 00 68 00       	mov    WORD PTR [rax],0x68
  1015c8:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1015cc:	c6 40 05 89          	mov    BYTE PTR [rax+0x5],0x89
  1015d0:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1015d4:	c6 40 06 40          	mov    BYTE PTR [rax+0x6],0x40
  1015d8:	90                   	nop
  1015d9:	c9                   	leave  
  1015da:	c3                   	ret    

00000000001015db <initGDT>:
  1015db:	55                   	push   rbp
  1015dc:	48 89 e5             	mov    rbp,rsp
  1015df:	b8 00 00 00 00       	mov    eax,0x0
  1015e4:	e8 50 ff ff ff       	call   101539 <get_gdt>
  1015e9:	b8 00 00 00 00       	mov    eax,0x0
  1015ee:	e8 68 ff ff ff       	call   10155b <gdt_entry_map>
  1015f3:	90                   	nop
  1015f4:	5d                   	pop    rbp
  1015f5:	c3                   	ret    

00000000001015f6 <tab_search>:
  1015f6:	55                   	push   rbp
  1015f7:	48 89 e5             	mov    rbp,rsp
  1015fa:	48 83 ec 10          	sub    rsp,0x10
  1015fe:	48 8b 05 bb ba 01 00 	mov    rax,QWORD PTR [rip+0x1babb]        # 11d0c0 <X64+0x20>
  101605:	48 85 c0             	test   rax,rax
  101608:	0f 84 96 01 00 00    	je     1017a4 <tab_search+0x1ae>
  10160e:	8b 05 b4 ba 01 00    	mov    eax,DWORD PTR [rip+0x1bab4]        # 11d0c8 <X64+0x28>
  101614:	85 c0                	test   eax,eax
  101616:	0f 84 88 01 00 00    	je     1017a4 <tab_search+0x1ae>
  10161c:	48 c7 05 79 ba 01 00 	mov    QWORD PTR [rip+0x1ba79],0x0        # 11d0a0 <X64>
  101623:	00 00 00 00 
  101627:	48 c7 05 7e ba 01 00 	mov    QWORD PTR [rip+0x1ba7e],0x0        # 11d0b0 <X64+0x10>
  10162e:	00 00 00 00 
  101632:	c7 05 6c ba 01 00 00 	mov    DWORD PTR [rip+0x1ba6c],0x0        # 11d0a8 <X64+0x8>
  101639:	00 00 00 
  10163c:	c7 05 72 ba 01 00 00 	mov    DWORD PTR [rip+0x1ba72],0x0        # 11d0b8 <X64+0x18>
  101643:	00 00 00 
  101646:	c7 45 fc 01 00 00 00 	mov    DWORD PTR [rbp-0x4],0x1
  10164d:	e9 29 01 00 00       	jmp    10177b <tab_search+0x185>
  101652:	48 8b 05 47 ba 01 00 	mov    rax,QWORD PTR [rip+0x1ba47]        # 11d0a0 <X64>
  101659:	48 85 c0             	test   rax,rax
  10165c:	0f 85 85 00 00 00    	jne    1016e7 <tab_search+0xf1>
  101662:	48 8b 05 57 ba 01 00 	mov    rax,QWORD PTR [rip+0x1ba57]        # 11d0c0 <X64+0x20>
  101669:	8b 55 fc             	mov    edx,DWORD PTR [rbp-0x4]
  10166c:	48 c1 e2 06          	shl    rdx,0x6
  101670:	48 01 d0             	add    rax,rdx
  101673:	8b 40 04             	mov    eax,DWORD PTR [rax+0x4]
  101676:	83 f8 02             	cmp    eax,0x2
  101679:	75 6c                	jne    1016e7 <tab_search+0xf1>
  10167b:	48 8b 05 3e ba 01 00 	mov    rax,QWORD PTR [rip+0x1ba3e]        # 11d0c0 <X64+0x20>
  101682:	8b 55 fc             	mov    edx,DWORD PTR [rbp-0x4]
  101685:	48 c1 e2 06          	shl    rdx,0x6
  101689:	48 01 d0             	add    rax,rdx
  10168c:	48 8b 40 20          	mov    rax,QWORD PTR [rax+0x20]
  101690:	89 05 12 ba 01 00    	mov    DWORD PTR [rip+0x1ba12],eax        # 11d0a8 <X64+0x8>
  101696:	8b 05 0c ba 01 00    	mov    eax,DWORD PTR [rip+0x1ba0c]        # 11d0a8 <X64+0x8>
  10169c:	89 c0                	mov    eax,eax
  10169e:	48 89 c7             	mov    rdi,rax
  1016a1:	e8 a9 18 00 00       	call   102f4f <kmalloc>
  1016a6:	48 89 05 f3 b9 01 00 	mov    QWORD PTR [rip+0x1b9f3],rax        # 11d0a0 <X64>
  1016ad:	8b 05 f5 b9 01 00    	mov    eax,DWORD PTR [rip+0x1b9f5]        # 11d0a8 <X64+0x8>
  1016b3:	89 c6                	mov    esi,eax
  1016b5:	48 8b 05 04 ba 01 00 	mov    rax,QWORD PTR [rip+0x1ba04]        # 11d0c0 <X64+0x20>
  1016bc:	8b 55 fc             	mov    edx,DWORD PTR [rbp-0x4]
  1016bf:	48 c1 e2 06          	shl    rdx,0x6
  1016c3:	48 01 d0             	add    rax,rdx
  1016c6:	48 8b 40 10          	mov    rax,QWORD PTR [rax+0x10]
  1016ca:	48 89 c1             	mov    rcx,rax
  1016cd:	48 8b 05 cc b9 01 00 	mov    rax,QWORD PTR [rip+0x1b9cc]        # 11d0a0 <X64>
  1016d4:	48 89 f2             	mov    rdx,rsi
  1016d7:	48 89 ce             	mov    rsi,rcx
  1016da:	48 89 c7             	mov    rdi,rax
  1016dd:	e8 87 2e 00 00       	call   104569 <memcpy>
  1016e2:	e9 90 00 00 00       	jmp    101777 <tab_search+0x181>
  1016e7:	48 8b 05 c2 b9 01 00 	mov    rax,QWORD PTR [rip+0x1b9c2]        # 11d0b0 <X64+0x10>
  1016ee:	48 85 c0             	test   rax,rax
  1016f1:	0f 85 80 00 00 00    	jne    101777 <tab_search+0x181>
  1016f7:	48 8b 05 c2 b9 01 00 	mov    rax,QWORD PTR [rip+0x1b9c2]        # 11d0c0 <X64+0x20>
  1016fe:	8b 55 fc             	mov    edx,DWORD PTR [rbp-0x4]
  101701:	48 c1 e2 06          	shl    rdx,0x6
  101705:	48 01 d0             	add    rax,rdx
  101708:	8b 40 04             	mov    eax,DWORD PTR [rax+0x4]
  10170b:	83 f8 03             	cmp    eax,0x3
  10170e:	75 67                	jne    101777 <tab_search+0x181>
  101710:	48 8b 05 a9 b9 01 00 	mov    rax,QWORD PTR [rip+0x1b9a9]        # 11d0c0 <X64+0x20>
  101717:	8b 55 fc             	mov    edx,DWORD PTR [rbp-0x4]
  10171a:	48 c1 e2 06          	shl    rdx,0x6
  10171e:	48 01 d0             	add    rax,rdx
  101721:	48 8b 40 20          	mov    rax,QWORD PTR [rax+0x20]
  101725:	89 05 8d b9 01 00    	mov    DWORD PTR [rip+0x1b98d],eax        # 11d0b8 <X64+0x18>
  10172b:	8b 05 87 b9 01 00    	mov    eax,DWORD PTR [rip+0x1b987]        # 11d0b8 <X64+0x18>
  101731:	89 c0                	mov    eax,eax
  101733:	48 89 c7             	mov    rdi,rax
  101736:	e8 14 18 00 00       	call   102f4f <kmalloc>
  10173b:	48 89 05 6e b9 01 00 	mov    QWORD PTR [rip+0x1b96e],rax        # 11d0b0 <X64+0x10>
  101742:	8b 05 70 b9 01 00    	mov    eax,DWORD PTR [rip+0x1b970]        # 11d0b8 <X64+0x18>
  101748:	89 c6                	mov    esi,eax
  10174a:	48 8b 05 6f b9 01 00 	mov    rax,QWORD PTR [rip+0x1b96f]        # 11d0c0 <X64+0x20>
  101751:	8b 55 fc             	mov    edx,DWORD PTR [rbp-0x4]
  101754:	48 c1 e2 06          	shl    rdx,0x6
  101758:	48 01 d0             	add    rax,rdx
  10175b:	48 8b 40 10          	mov    rax,QWORD PTR [rax+0x10]
  10175f:	48 89 c1             	mov    rcx,rax
  101762:	48 8b 05 47 b9 01 00 	mov    rax,QWORD PTR [rip+0x1b947]        # 11d0b0 <X64+0x10>
  101769:	48 89 f2             	mov    rdx,rsi
  10176c:	48 89 ce             	mov    rsi,rcx
  10176f:	48 89 c7             	mov    rdi,rax
  101772:	e8 f2 2d 00 00       	call   104569 <memcpy>
  101777:	83 45 fc 01          	add    DWORD PTR [rbp-0x4],0x1
  10177b:	48 8b 05 1e b9 01 00 	mov    rax,QWORD PTR [rip+0x1b91e]        # 11d0a0 <X64>
  101782:	48 85 c0             	test   rax,rax
  101785:	74 0c                	je     101793 <tab_search+0x19d>
  101787:	48 8b 05 22 b9 01 00 	mov    rax,QWORD PTR [rip+0x1b922]        # 11d0b0 <X64+0x10>
  10178e:	48 85 c0             	test   rax,rax
  101791:	75 12                	jne    1017a5 <tab_search+0x1af>
  101793:	8b 05 2f b9 01 00    	mov    eax,DWORD PTR [rip+0x1b92f]        # 11d0c8 <X64+0x28>
  101799:	39 45 fc             	cmp    DWORD PTR [rbp-0x4],eax
  10179c:	0f 82 b0 fe ff ff    	jb     101652 <tab_search+0x5c>
  1017a2:	eb 01                	jmp    1017a5 <tab_search+0x1af>
  1017a4:	90                   	nop
  1017a5:	c9                   	leave  
  1017a6:	c3                   	ret    

00000000001017a7 <load_sys_detect>:
  1017a7:	55                   	push   rbp
  1017a8:	48 89 e5             	mov    rbp,rsp
  1017ab:	8b 05 23 49 00 00    	mov    eax,DWORD PTR [rip+0x4923]        # 1060d4 <mbm>
  1017b1:	3d 02 b0 ad 2b       	cmp    eax,0x2badb002
  1017b6:	75 0c                	jne    1017c4 <load_sys_detect+0x1d>
  1017b8:	b8 00 00 00 00       	mov    eax,0x0
  1017bd:	e8 41 00 00 00       	call   101803 <mbootInit>
  1017c2:	eb 0d                	jmp    1017d1 <load_sys_detect+0x2a>
  1017c4:	48 8d 3d d5 4a 00 00 	lea    rdi,[rip+0x4ad5]        # 1062a0 <PRINTF_FB_ENABLE+0x90>
  1017cb:	e8 f0 11 00 00       	call   1029c0 <panic>
  1017d0:	90                   	nop
  1017d1:	5d                   	pop    rbp
  1017d2:	c3                   	ret    

00000000001017d3 <arch_init>:
  1017d3:	55                   	push   rbp
  1017d4:	48 89 e5             	mov    rbp,rsp
  1017d7:	b8 00 00 00 00       	mov    eax,0x0
  1017dc:	e8 c6 ff ff ff       	call   1017a7 <load_sys_detect>
  1017e1:	b8 00 00 00 00       	mov    eax,0x0
  1017e6:	e8 11 00 00 00       	call   1017fc <initTSS>
  1017eb:	b8 00 00 00 00       	mov    eax,0x0
  1017f0:	e8 e6 fd ff ff       	call   1015db <initGDT>
  1017f5:	b8 00 00 00 00       	mov    eax,0x0
  1017fa:	5d                   	pop    rbp
  1017fb:	c3                   	ret    

00000000001017fc <initTSS>:
  1017fc:	55                   	push   rbp
  1017fd:	48 89 e5             	mov    rbp,rsp
  101800:	90                   	nop
  101801:	5d                   	pop    rbp
  101802:	c3                   	ret    

0000000000101803 <mbootInit>:
  101803:	55                   	push   rbp
  101804:	48 89 e5             	mov    rbp,rsp
  101807:	48 83 ec 20          	sub    rsp,0x20
  10180b:	8b 05 c3 48 00 00    	mov    eax,DWORD PTR [rip+0x48c3]        # 1060d4 <mbm>
  101811:	3d 02 b0 ad 2b       	cmp    eax,0x2badb002
  101816:	74 0c                	je     101824 <mbootInit+0x21>
  101818:	48 8d 3d d9 4a 00 00 	lea    rdi,[rip+0x4ad9]        # 1062f8 <PRINTF_FB_ENABLE+0xe8>
  10181f:	e8 9c 11 00 00       	call   1029c0 <panic>
  101824:	c7 05 12 a8 01 00 00 	mov    DWORD PTR [rip+0x1a812],0x0        # 11c040 <load_sys>
  10182b:	00 00 00 
  10182e:	8b 05 9c 48 00 00    	mov    eax,DWORD PTR [rip+0x489c]        # 1060d0 <mbp>
  101834:	89 c0                	mov    eax,eax
  101836:	48 89 05 2b b8 01 00 	mov    QWORD PTR [rip+0x1b82b],rax        # 11d068 <mbinf>
  10183d:	48 8b 05 24 b8 01 00 	mov    rax,QWORD PTR [rip+0x1b824]        # 11d068 <mbinf>
  101844:	8b 00                	mov    eax,DWORD PTR [rax]
  101846:	83 e0 20             	and    eax,0x20
  101849:	85 c0                	test   eax,eax
  10184b:	74 2f                	je     10187c <mbootInit+0x79>
  10184d:	48 8b 05 14 b8 01 00 	mov    rax,QWORD PTR [rip+0x1b814]        # 11d068 <mbinf>
  101854:	8b 40 1c             	mov    eax,DWORD PTR [rax+0x1c]
  101857:	89 05 6b b8 01 00    	mov    DWORD PTR [rip+0x1b86b],eax        # 11d0c8 <X64+0x28>
  10185d:	48 8b 05 04 b8 01 00 	mov    rax,QWORD PTR [rip+0x1b804]        # 11d068 <mbinf>
  101864:	8b 40 24             	mov    eax,DWORD PTR [rax+0x24]
  101867:	89 c0                	mov    eax,eax
  101869:	48 89 05 50 b8 01 00 	mov    QWORD PTR [rip+0x1b850],rax        # 11d0c0 <X64+0x20>
  101870:	b8 00 00 00 00       	mov    eax,0x0
  101875:	e8 7c fd ff ff       	call   1015f6 <tab_search>
  10187a:	eb 3f                	jmp    1018bb <mbootInit+0xb8>
  10187c:	48 c7 05 19 b8 01 00 	mov    QWORD PTR [rip+0x1b819],0x0        # 11d0a0 <X64>
  101883:	00 00 00 00 
  101887:	48 c7 05 1e b8 01 00 	mov    QWORD PTR [rip+0x1b81e],0x0        # 11d0b0 <X64+0x10>
  10188e:	00 00 00 00 
  101892:	c7 05 0c b8 01 00 00 	mov    DWORD PTR [rip+0x1b80c],0x0        # 11d0a8 <X64+0x8>
  101899:	00 00 00 
  10189c:	c7 05 12 b8 01 00 00 	mov    DWORD PTR [rip+0x1b812],0x0        # 11d0b8 <X64+0x18>
  1018a3:	00 00 00 
  1018a6:	48 c7 05 0f b8 01 00 	mov    QWORD PTR [rip+0x1b80f],0x0        # 11d0c0 <X64+0x20>
  1018ad:	00 00 00 00 
  1018b1:	c7 05 0d b8 01 00 00 	mov    DWORD PTR [rip+0x1b80d],0x0        # 11d0c8 <X64+0x28>
  1018b8:	00 00 00 
  1018bb:	48 8b 05 a6 b7 01 00 	mov    rax,QWORD PTR [rip+0x1b7a6]        # 11d068 <mbinf>
  1018c2:	8b 00                	mov    eax,DWORD PTR [rax]
  1018c4:	83 e0 40             	and    eax,0x40
  1018c7:	85 c0                	test   eax,eax
  1018c9:	0f 84 9b 01 00 00    	je     101a6a <mbootInit+0x267>
  1018cf:	bf 38 00 00 00       	mov    edi,0x38
  1018d4:	e8 76 16 00 00       	call   102f4f <kmalloc>
  1018d9:	48 89 05 f0 b7 01 00 	mov    QWORD PTR [rip+0x1b7f0],rax        # 11d0d0 <X64+0x30>
  1018e0:	48 8b 05 e9 b7 01 00 	mov    rax,QWORD PTR [rip+0x1b7e9]        # 11d0d0 <X64+0x30>
  1018e7:	c7 40 20 00 00 00 00 	mov    DWORD PTR [rax+0x20],0x0
  1018ee:	48 8b 05 db b7 01 00 	mov    rax,QWORD PTR [rip+0x1b7db]        # 11d0d0 <X64+0x30>
  1018f5:	48 c7 40 18 00 00 00 	mov    QWORD PTR [rax+0x18],0x0
  1018fc:	00 
  1018fd:	48 8b 05 cc b7 01 00 	mov    rax,QWORD PTR [rip+0x1b7cc]        # 11d0d0 <X64+0x30>
  101904:	48 c7 40 28 00 00 00 	mov    QWORD PTR [rax+0x28],0x0
  10190b:	00 
  10190c:	48 8b 05 bd b7 01 00 	mov    rax,QWORD PTR [rip+0x1b7bd]        # 11d0d0 <X64+0x30>
  101913:	c7 40 30 00 00 00 00 	mov    DWORD PTR [rax+0x30],0x0
  10191a:	48 c7 45 f8 00 00 00 	mov    QWORD PTR [rbp-0x8],0x0
  101921:	00 
  101922:	48 8b 05 3f b7 01 00 	mov    rax,QWORD PTR [rip+0x1b73f]        # 11d068 <mbinf>
  101929:	8b 40 30             	mov    eax,DWORD PTR [rax+0x30]
  10192c:	89 c0                	mov    eax,eax
  10192e:	48 89 45 f0          	mov    QWORD PTR [rbp-0x10],rax
  101932:	e9 09 01 00 00       	jmp    101a40 <mbootInit+0x23d>
  101937:	48 83 7d f8 00       	cmp    QWORD PTR [rbp-0x8],0x0
  10193c:	75 0d                	jne    10194b <mbootInit+0x148>
  10193e:	48 8b 05 8b b7 01 00 	mov    rax,QWORD PTR [rip+0x1b78b]        # 11d0d0 <X64+0x30>
  101945:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  101949:	eb 50                	jmp    10199b <mbootInit+0x198>
  10194b:	bf 38 00 00 00       	mov    edi,0x38
  101950:	e8 fa 15 00 00       	call   102f4f <kmalloc>
  101955:	48 89 45 e8          	mov    QWORD PTR [rbp-0x18],rax
  101959:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10195d:	48 8b 55 e8          	mov    rdx,QWORD PTR [rbp-0x18]
  101961:	48 89 50 28          	mov    QWORD PTR [rax+0x28],rdx
  101965:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  101969:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  10196d:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  101971:	c7 40 20 00 00 00 00 	mov    DWORD PTR [rax+0x20],0x0
  101978:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10197c:	48 c7 40 18 00 00 00 	mov    QWORD PTR [rax+0x18],0x0
  101983:	00 
  101984:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  101988:	48 c7 40 28 00 00 00 	mov    QWORD PTR [rax+0x28],0x0
  10198f:	00 
  101990:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  101994:	c7 40 30 00 00 00 00 	mov    DWORD PTR [rax+0x30],0x0
  10199b:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  10199f:	48 8b 50 04          	mov    rdx,QWORD PTR [rax+0x4]
  1019a3:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1019a7:	48 89 10             	mov    QWORD PTR [rax],rdx
  1019aa:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  1019ae:	48 8b 50 0c          	mov    rdx,QWORD PTR [rax+0xc]
  1019b2:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1019b6:	48 89 50 08          	mov    QWORD PTR [rax+0x8],rdx
  1019ba:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  1019be:	8b 40 14             	mov    eax,DWORD PTR [rax+0x14]
  1019c1:	83 f8 05             	cmp    eax,0x5
  1019c4:	77 53                	ja     101a19 <mbootInit+0x216>
  1019c6:	89 c0                	mov    eax,eax
  1019c8:	48 8d 14 85 00 00 00 	lea    rdx,[rax*4+0x0]
  1019cf:	00 
  1019d0:	48 8d 05 7d 49 00 00 	lea    rax,[rip+0x497d]        # 106354 <PRINTF_FB_ENABLE+0x144>
  1019d7:	8b 04 02             	mov    eax,DWORD PTR [rdx+rax*1]
  1019da:	48 98                	cdqe   
  1019dc:	48 8d 15 71 49 00 00 	lea    rdx,[rip+0x4971]        # 106354 <PRINTF_FB_ENABLE+0x144>
  1019e3:	48 01 d0             	add    rax,rdx
  1019e6:	ff e0                	jmp    rax
  1019e8:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1019ec:	c6 40 10 4b          	mov    BYTE PTR [rax+0x10],0x4b
  1019f0:	eb 27                	jmp    101a19 <mbootInit+0x216>
  1019f2:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1019f6:	c6 40 10 04          	mov    BYTE PTR [rax+0x10],0x4
  1019fa:	eb 1d                	jmp    101a19 <mbootInit+0x216>
  1019fc:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  101a00:	c6 40 10 0f          	mov    BYTE PTR [rax+0x10],0xf
  101a04:	eb 13                	jmp    101a19 <mbootInit+0x216>
  101a06:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  101a0a:	c6 40 10 2b          	mov    BYTE PTR [rax+0x10],0x2b
  101a0e:	eb 09                	jmp    101a19 <mbootInit+0x216>
  101a10:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  101a14:	c6 40 10 1c          	mov    BYTE PTR [rax+0x10],0x1c
  101a18:	90                   	nop
  101a19:	48 8b 05 b0 b6 01 00 	mov    rax,QWORD PTR [rip+0x1b6b0]        # 11d0d0 <X64+0x30>
  101a20:	8b 50 20             	mov    edx,DWORD PTR [rax+0x20]
  101a23:	83 c2 01             	add    edx,0x1
  101a26:	89 50 20             	mov    DWORD PTR [rax+0x20],edx
  101a29:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  101a2d:	8b 00                	mov    eax,DWORD PTR [rax]
  101a2f:	89 c2                	mov    edx,eax
  101a31:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  101a35:	48 01 d0             	add    rax,rdx
  101a38:	48 83 c0 04          	add    rax,0x4
  101a3c:	48 89 45 f0          	mov    QWORD PTR [rbp-0x10],rax
  101a40:	48 8b 05 21 b6 01 00 	mov    rax,QWORD PTR [rip+0x1b621]        # 11d068 <mbinf>
  101a47:	8b 40 30             	mov    eax,DWORD PTR [rax+0x30]
  101a4a:	89 c2                	mov    edx,eax
  101a4c:	48 8b 05 15 b6 01 00 	mov    rax,QWORD PTR [rip+0x1b615]        # 11d068 <mbinf>
  101a53:	8b 40 2c             	mov    eax,DWORD PTR [rax+0x2c]
  101a56:	89 c0                	mov    eax,eax
  101a58:	48 01 c2             	add    rdx,rax
  101a5b:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  101a5f:	48 39 c2             	cmp    rdx,rax
  101a62:	0f 87 cf fe ff ff    	ja     101937 <mbootInit+0x134>
  101a68:	eb 0b                	jmp    101a75 <mbootInit+0x272>
  101a6a:	48 c7 05 5b b6 01 00 	mov    QWORD PTR [rip+0x1b65b],0x0        # 11d0d0 <X64+0x30>
  101a71:	00 00 00 00 
  101a75:	b8 00 00 00 00       	mov    eax,0x0
  101a7a:	c9                   	leave  
  101a7b:	c3                   	ret    

0000000000101a7c <init_c>:
  101a7c:	55                   	push   rbp
  101a7d:	48 89 e5             	mov    rbp,rsp
  101a80:	90                   	nop
  101a81:	5d                   	pop    rbp
  101a82:	c3                   	ret    

0000000000101a83 <interrupt_enabled>:
  101a83:	55                   	push   rbp
  101a84:	48 89 e5             	mov    rbp,rsp
  101a87:	b8 00 00 00 00       	mov    eax,0x0
  101a8c:	e8 fa ed ff ff       	call   10088b <RFLAGS>
  101a91:	25 00 02 00 00       	and    eax,0x200
  101a96:	5d                   	pop    rbp
  101a97:	c3                   	ret    

0000000000101a98 <idt_set>:
  101a98:	55                   	push   rbp
  101a99:	48 89 e5             	mov    rbp,rsp
  101a9c:	89 f9                	mov    ecx,edi
  101a9e:	48 89 75 f0          	mov    QWORD PTR [rbp-0x10],rsi
  101aa2:	89 d0                	mov    eax,edx
  101aa4:	89 ca                	mov    edx,ecx
  101aa6:	88 55 fc             	mov    BYTE PTR [rbp-0x4],dl
  101aa9:	88 45 f8             	mov    BYTE PTR [rbp-0x8],al
  101aac:	0f b6 45 fc          	movzx  eax,BYTE PTR [rbp-0x4]
  101ab0:	48 8b 55 f0          	mov    rdx,QWORD PTR [rbp-0x10]
  101ab4:	89 d1                	mov    ecx,edx
  101ab6:	48 98                	cdqe   
  101ab8:	48 c1 e0 04          	shl    rax,0x4
  101abc:	48 89 c2             	mov    rdx,rax
  101abf:	48 8d 05 9a a5 01 00 	lea    rax,[rip+0x1a59a]        # 11c060 <IDT>
  101ac6:	66 89 0c 02          	mov    WORD PTR [rdx+rax*1],cx
  101aca:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  101ace:	48 c1 e8 10          	shr    rax,0x10
  101ad2:	48 89 c2             	mov    rdx,rax
  101ad5:	0f b6 45 fc          	movzx  eax,BYTE PTR [rbp-0x4]
  101ad9:	89 d1                	mov    ecx,edx
  101adb:	48 98                	cdqe   
  101add:	48 c1 e0 04          	shl    rax,0x4
  101ae1:	48 89 c2             	mov    rdx,rax
  101ae4:	48 8d 05 7b a5 01 00 	lea    rax,[rip+0x1a57b]        # 11c066 <IDT+0x6>
  101aeb:	66 89 0c 02          	mov    WORD PTR [rdx+rax*1],cx
  101aef:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  101af3:	48 c1 e8 20          	shr    rax,0x20
  101af7:	0f b6 55 fc          	movzx  edx,BYTE PTR [rbp-0x4]
  101afb:	0f b7 c0             	movzx  eax,ax
  101afe:	48 63 d2             	movsxd rdx,edx
  101b01:	48 89 d1             	mov    rcx,rdx
  101b04:	48 c1 e1 04          	shl    rcx,0x4
  101b08:	48 8d 15 59 a5 01 00 	lea    rdx,[rip+0x1a559]        # 11c068 <IDT+0x8>
  101b0f:	89 04 11             	mov    DWORD PTR [rcx+rdx*1],eax
  101b12:	0f b6 45 fc          	movzx  eax,BYTE PTR [rbp-0x4]
  101b16:	48 98                	cdqe   
  101b18:	48 c1 e0 04          	shl    rax,0x4
  101b1c:	48 89 c2             	mov    rdx,rax
  101b1f:	48 8d 05 3c a5 01 00 	lea    rax,[rip+0x1a53c]        # 11c062 <IDT+0x2>
  101b26:	66 c7 04 02 08 00    	mov    WORD PTR [rdx+rax*1],0x8
  101b2c:	0f b6 45 fc          	movzx  eax,BYTE PTR [rbp-0x4]
  101b30:	48 98                	cdqe   
  101b32:	48 c1 e0 04          	shl    rax,0x4
  101b36:	48 89 c1             	mov    rcx,rax
  101b39:	48 8d 15 25 a5 01 00 	lea    rdx,[rip+0x1a525]        # 11c065 <IDT+0x5>
  101b40:	0f b6 45 f8          	movzx  eax,BYTE PTR [rbp-0x8]
  101b44:	88 04 11             	mov    BYTE PTR [rcx+rdx*1],al
  101b47:	0f b6 45 fc          	movzx  eax,BYTE PTR [rbp-0x4]
  101b4b:	48 98                	cdqe   
  101b4d:	48 c1 e0 04          	shl    rax,0x4
  101b51:	48 89 c2             	mov    rdx,rax
  101b54:	48 8d 05 09 a5 01 00 	lea    rax,[rip+0x1a509]        # 11c064 <IDT+0x4>
  101b5b:	c6 04 02 00          	mov    BYTE PTR [rdx+rax*1],0x0
  101b5f:	0f b6 45 fc          	movzx  eax,BYTE PTR [rbp-0x4]
  101b63:	48 98                	cdqe   
  101b65:	48 c1 e0 04          	shl    rax,0x4
  101b69:	48 89 c2             	mov    rdx,rax
  101b6c:	48 8d 05 f9 a4 01 00 	lea    rax,[rip+0x1a4f9]        # 11c06c <IDT+0xc>
  101b73:	c7 04 02 00 00 00 00 	mov    DWORD PTR [rdx+rax*1],0x0
  101b7a:	90                   	nop
  101b7b:	5d                   	pop    rbp
  101b7c:	c3                   	ret    

0000000000101b7d <idt_map>:
  101b7d:	55                   	push   rbp
  101b7e:	48 89 e5             	mov    rbp,rsp
  101b81:	48 c7 c0 9f 20 10 00 	mov    rax,0x10209f
  101b88:	ba 8e 00 00 00       	mov    edx,0x8e
  101b8d:	48 89 c6             	mov    rsi,rax
  101b90:	bf 00 00 00 00       	mov    edi,0x0
  101b95:	e8 fe fe ff ff       	call   101a98 <idt_set>
  101b9a:	48 c7 c0 a1 20 10 00 	mov    rax,0x1020a1
  101ba1:	ba 8f 00 00 00       	mov    edx,0x8f
  101ba6:	48 89 c6             	mov    rsi,rax
  101ba9:	bf 01 00 00 00       	mov    edi,0x1
  101bae:	e8 e5 fe ff ff       	call   101a98 <idt_set>
  101bb3:	48 c7 c0 a3 20 10 00 	mov    rax,0x1020a3
  101bba:	ba 8e 00 00 00       	mov    edx,0x8e
  101bbf:	48 89 c6             	mov    rsi,rax
  101bc2:	bf 02 00 00 00       	mov    edi,0x2
  101bc7:	e8 cc fe ff ff       	call   101a98 <idt_set>
  101bcc:	48 c7 c0 a5 20 10 00 	mov    rax,0x1020a5
  101bd3:	ba 8f 00 00 00       	mov    edx,0x8f
  101bd8:	48 89 c6             	mov    rsi,rax
  101bdb:	bf 03 00 00 00       	mov    edi,0x3
  101be0:	e8 b3 fe ff ff       	call   101a98 <idt_set>
  101be5:	48 c7 c0 a7 20 10 00 	mov    rax,0x1020a7
  101bec:	ba 8e 00 00 00       	mov    edx,0x8e
  101bf1:	48 89 c6             	mov    rsi,rax
  101bf4:	bf 04 00 00 00       	mov    edi,0x4
  101bf9:	e8 9a fe ff ff       	call   101a98 <idt_set>
  101bfe:	48 c7 c0 a9 20 10 00 	mov    rax,0x1020a9
  101c05:	ba 8e 00 00 00       	mov    edx,0x8e
  101c0a:	48 89 c6             	mov    rsi,rax
  101c0d:	bf 05 00 00 00       	mov    edi,0x5
  101c12:	e8 81 fe ff ff       	call   101a98 <idt_set>
  101c17:	48 c7 c0 ab 20 10 00 	mov    rax,0x1020ab
  101c1e:	ba 8e 00 00 00       	mov    edx,0x8e
  101c23:	48 89 c6             	mov    rsi,rax
  101c26:	bf 06 00 00 00       	mov    edi,0x6
  101c2b:	e8 68 fe ff ff       	call   101a98 <idt_set>
  101c30:	48 c7 c0 ad 20 10 00 	mov    rax,0x1020ad
  101c37:	ba 8e 00 00 00       	mov    edx,0x8e
  101c3c:	48 89 c6             	mov    rsi,rax
  101c3f:	bf 07 00 00 00       	mov    edi,0x7
  101c44:	e8 4f fe ff ff       	call   101a98 <idt_set>
  101c49:	48 c7 c0 af 20 10 00 	mov    rax,0x1020af
  101c50:	ba 8e 00 00 00       	mov    edx,0x8e
  101c55:	48 89 c6             	mov    rsi,rax
  101c58:	bf 08 00 00 00       	mov    edi,0x8
  101c5d:	e8 36 fe ff ff       	call   101a98 <idt_set>
  101c62:	48 c7 c0 b1 20 10 00 	mov    rax,0x1020b1
  101c69:	ba 8e 00 00 00       	mov    edx,0x8e
  101c6e:	48 89 c6             	mov    rsi,rax
  101c71:	bf 09 00 00 00       	mov    edi,0x9
  101c76:	e8 1d fe ff ff       	call   101a98 <idt_set>
  101c7b:	48 c7 c0 b3 20 10 00 	mov    rax,0x1020b3
  101c82:	ba 8e 00 00 00       	mov    edx,0x8e
  101c87:	48 89 c6             	mov    rsi,rax
  101c8a:	bf 0a 00 00 00       	mov    edi,0xa
  101c8f:	e8 04 fe ff ff       	call   101a98 <idt_set>
  101c94:	48 c7 c0 b5 20 10 00 	mov    rax,0x1020b5
  101c9b:	ba 8e 00 00 00       	mov    edx,0x8e
  101ca0:	48 89 c6             	mov    rsi,rax
  101ca3:	bf 0b 00 00 00       	mov    edi,0xb
  101ca8:	e8 eb fd ff ff       	call   101a98 <idt_set>
  101cad:	48 c7 c0 b7 20 10 00 	mov    rax,0x1020b7
  101cb4:	ba 8e 00 00 00       	mov    edx,0x8e
  101cb9:	48 89 c6             	mov    rsi,rax
  101cbc:	bf 0c 00 00 00       	mov    edi,0xc
  101cc1:	e8 d2 fd ff ff       	call   101a98 <idt_set>
  101cc6:	48 c7 c0 b9 20 10 00 	mov    rax,0x1020b9
  101ccd:	ba 8e 00 00 00       	mov    edx,0x8e
  101cd2:	48 89 c6             	mov    rsi,rax
  101cd5:	bf 0d 00 00 00       	mov    edi,0xd
  101cda:	e8 b9 fd ff ff       	call   101a98 <idt_set>
  101cdf:	48 c7 c0 bb 20 10 00 	mov    rax,0x1020bb
  101ce6:	ba 8e 00 00 00       	mov    edx,0x8e
  101ceb:	48 89 c6             	mov    rsi,rax
  101cee:	bf 0e 00 00 00       	mov    edi,0xe
  101cf3:	e8 a0 fd ff ff       	call   101a98 <idt_set>
  101cf8:	48 c7 c0 bd 20 10 00 	mov    rax,0x1020bd
  101cff:	ba 8e 00 00 00       	mov    edx,0x8e
  101d04:	48 89 c6             	mov    rsi,rax
  101d07:	bf 10 00 00 00       	mov    edi,0x10
  101d0c:	e8 87 fd ff ff       	call   101a98 <idt_set>
  101d11:	48 c7 c0 bf 20 10 00 	mov    rax,0x1020bf
  101d18:	ba 8e 00 00 00       	mov    edx,0x8e
  101d1d:	48 89 c6             	mov    rsi,rax
  101d20:	bf 11 00 00 00       	mov    edi,0x11
  101d25:	e8 6e fd ff ff       	call   101a98 <idt_set>
  101d2a:	48 c7 c0 c1 20 10 00 	mov    rax,0x1020c1
  101d31:	ba 8e 00 00 00       	mov    edx,0x8e
  101d36:	48 89 c6             	mov    rsi,rax
  101d39:	bf 12 00 00 00       	mov    edi,0x12
  101d3e:	e8 55 fd ff ff       	call   101a98 <idt_set>
  101d43:	48 c7 c0 c3 20 10 00 	mov    rax,0x1020c3
  101d4a:	ba 8e 00 00 00       	mov    edx,0x8e
  101d4f:	48 89 c6             	mov    rsi,rax
  101d52:	bf 13 00 00 00       	mov    edi,0x13
  101d57:	e8 3c fd ff ff       	call   101a98 <idt_set>
  101d5c:	48 c7 c0 c5 20 10 00 	mov    rax,0x1020c5
  101d63:	ba 8e 00 00 00       	mov    edx,0x8e
  101d68:	48 89 c6             	mov    rsi,rax
  101d6b:	bf 14 00 00 00       	mov    edi,0x14
  101d70:	e8 23 fd ff ff       	call   101a98 <idt_set>
  101d75:	48 c7 c0 c7 20 10 00 	mov    rax,0x1020c7
  101d7c:	ba 8e 00 00 00       	mov    edx,0x8e
  101d81:	48 89 c6             	mov    rsi,rax
  101d84:	bf 1e 00 00 00       	mov    edi,0x1e
  101d89:	e8 0a fd ff ff       	call   101a98 <idt_set>
  101d8e:	48 c7 c0 c9 20 10 00 	mov    rax,0x1020c9
  101d95:	48 89 c1             	mov    rcx,rax
  101d98:	b8 64 00 00 00       	mov    eax,0x64
  101d9d:	0f b6 c0             	movzx  eax,al
  101da0:	ba 8e 00 00 00       	mov    edx,0x8e
  101da5:	48 89 ce             	mov    rsi,rcx
  101da8:	89 c7                	mov    edi,eax
  101daa:	e8 e9 fc ff ff       	call   101a98 <idt_set>
  101daf:	48 c7 c0 e3 20 10 00 	mov    rax,0x1020e3
  101db6:	48 89 c1             	mov    rcx,rax
  101db9:	b8 64 00 00 00       	mov    eax,0x64
  101dbe:	83 c0 01             	add    eax,0x1
  101dc1:	0f b6 c0             	movzx  eax,al
  101dc4:	ba 8e 00 00 00       	mov    edx,0x8e
  101dc9:	48 89 ce             	mov    rsi,rcx
  101dcc:	89 c7                	mov    edi,eax
  101dce:	e8 c5 fc ff ff       	call   101a98 <idt_set>
  101dd3:	48 c7 c0 fd 20 10 00 	mov    rax,0x1020fd
  101dda:	48 89 c1             	mov    rcx,rax
  101ddd:	b8 64 00 00 00       	mov    eax,0x64
  101de2:	83 c0 02             	add    eax,0x2
  101de5:	0f b6 c0             	movzx  eax,al
  101de8:	ba 8e 00 00 00       	mov    edx,0x8e
  101ded:	48 89 ce             	mov    rsi,rcx
  101df0:	89 c7                	mov    edi,eax
  101df2:	e8 a1 fc ff ff       	call   101a98 <idt_set>
  101df7:	48 c7 c0 17 21 10 00 	mov    rax,0x102117
  101dfe:	48 89 c1             	mov    rcx,rax
  101e01:	b8 64 00 00 00       	mov    eax,0x64
  101e06:	83 c0 03             	add    eax,0x3
  101e09:	0f b6 c0             	movzx  eax,al
  101e0c:	ba 8e 00 00 00       	mov    edx,0x8e
  101e11:	48 89 ce             	mov    rsi,rcx
  101e14:	89 c7                	mov    edi,eax
  101e16:	e8 7d fc ff ff       	call   101a98 <idt_set>
  101e1b:	48 c7 c0 31 21 10 00 	mov    rax,0x102131
  101e22:	48 89 c1             	mov    rcx,rax
  101e25:	b8 64 00 00 00       	mov    eax,0x64
  101e2a:	83 c0 04             	add    eax,0x4
  101e2d:	0f b6 c0             	movzx  eax,al
  101e30:	ba 8e 00 00 00       	mov    edx,0x8e
  101e35:	48 89 ce             	mov    rsi,rcx
  101e38:	89 c7                	mov    edi,eax
  101e3a:	e8 59 fc ff ff       	call   101a98 <idt_set>
  101e3f:	48 c7 c0 4b 21 10 00 	mov    rax,0x10214b
  101e46:	48 89 c1             	mov    rcx,rax
  101e49:	b8 64 00 00 00       	mov    eax,0x64
  101e4e:	83 c0 05             	add    eax,0x5
  101e51:	0f b6 c0             	movzx  eax,al
  101e54:	ba 8e 00 00 00       	mov    edx,0x8e
  101e59:	48 89 ce             	mov    rsi,rcx
  101e5c:	89 c7                	mov    edi,eax
  101e5e:	e8 35 fc ff ff       	call   101a98 <idt_set>
  101e63:	48 c7 c0 65 21 10 00 	mov    rax,0x102165
  101e6a:	48 89 c1             	mov    rcx,rax
  101e6d:	b8 64 00 00 00       	mov    eax,0x64
  101e72:	83 c0 06             	add    eax,0x6
  101e75:	0f b6 c0             	movzx  eax,al
  101e78:	ba 8e 00 00 00       	mov    edx,0x8e
  101e7d:	48 89 ce             	mov    rsi,rcx
  101e80:	89 c7                	mov    edi,eax
  101e82:	e8 11 fc ff ff       	call   101a98 <idt_set>
  101e87:	48 c7 c0 7f 21 10 00 	mov    rax,0x10217f
  101e8e:	48 89 c1             	mov    rcx,rax
  101e91:	b8 64 00 00 00       	mov    eax,0x64
  101e96:	83 c0 07             	add    eax,0x7
  101e99:	0f b6 c0             	movzx  eax,al
  101e9c:	ba 8e 00 00 00       	mov    edx,0x8e
  101ea1:	48 89 ce             	mov    rsi,rcx
  101ea4:	89 c7                	mov    edi,eax
  101ea6:	e8 ed fb ff ff       	call   101a98 <idt_set>
  101eab:	48 c7 c0 99 21 10 00 	mov    rax,0x102199
  101eb2:	48 89 c1             	mov    rcx,rax
  101eb5:	b8 64 00 00 00       	mov    eax,0x64
  101eba:	83 c0 08             	add    eax,0x8
  101ebd:	0f b6 c0             	movzx  eax,al
  101ec0:	ba 8e 00 00 00       	mov    edx,0x8e
  101ec5:	48 89 ce             	mov    rsi,rcx
  101ec8:	89 c7                	mov    edi,eax
  101eca:	e8 c9 fb ff ff       	call   101a98 <idt_set>
  101ecf:	48 c7 c0 b3 21 10 00 	mov    rax,0x1021b3
  101ed6:	48 89 c1             	mov    rcx,rax
  101ed9:	b8 64 00 00 00       	mov    eax,0x64
  101ede:	83 c0 09             	add    eax,0x9
  101ee1:	0f b6 c0             	movzx  eax,al
  101ee4:	ba 8e 00 00 00       	mov    edx,0x8e
  101ee9:	48 89 ce             	mov    rsi,rcx
  101eec:	89 c7                	mov    edi,eax
  101eee:	e8 a5 fb ff ff       	call   101a98 <idt_set>
  101ef3:	48 c7 c0 cd 21 10 00 	mov    rax,0x1021cd
  101efa:	48 89 c1             	mov    rcx,rax
  101efd:	b8 64 00 00 00       	mov    eax,0x64
  101f02:	83 c0 0a             	add    eax,0xa
  101f05:	0f b6 c0             	movzx  eax,al
  101f08:	ba 8e 00 00 00       	mov    edx,0x8e
  101f0d:	48 89 ce             	mov    rsi,rcx
  101f10:	89 c7                	mov    edi,eax
  101f12:	e8 81 fb ff ff       	call   101a98 <idt_set>
  101f17:	48 c7 c0 e7 21 10 00 	mov    rax,0x1021e7
  101f1e:	48 89 c1             	mov    rcx,rax
  101f21:	b8 64 00 00 00       	mov    eax,0x64
  101f26:	83 c0 0b             	add    eax,0xb
  101f29:	0f b6 c0             	movzx  eax,al
  101f2c:	ba 8e 00 00 00       	mov    edx,0x8e
  101f31:	48 89 ce             	mov    rsi,rcx
  101f34:	89 c7                	mov    edi,eax
  101f36:	e8 5d fb ff ff       	call   101a98 <idt_set>
  101f3b:	48 c7 c0 01 22 10 00 	mov    rax,0x102201
  101f42:	48 89 c1             	mov    rcx,rax
  101f45:	b8 64 00 00 00       	mov    eax,0x64
  101f4a:	83 c0 0c             	add    eax,0xc
  101f4d:	0f b6 c0             	movzx  eax,al
  101f50:	ba 8e 00 00 00       	mov    edx,0x8e
  101f55:	48 89 ce             	mov    rsi,rcx
  101f58:	89 c7                	mov    edi,eax
  101f5a:	e8 39 fb ff ff       	call   101a98 <idt_set>
  101f5f:	48 c7 c0 1b 22 10 00 	mov    rax,0x10221b
  101f66:	48 89 c1             	mov    rcx,rax
  101f69:	b8 64 00 00 00       	mov    eax,0x64
  101f6e:	83 c0 0d             	add    eax,0xd
  101f71:	0f b6 c0             	movzx  eax,al
  101f74:	ba 8e 00 00 00       	mov    edx,0x8e
  101f79:	48 89 ce             	mov    rsi,rcx
  101f7c:	89 c7                	mov    edi,eax
  101f7e:	e8 15 fb ff ff       	call   101a98 <idt_set>
  101f83:	48 c7 c0 35 22 10 00 	mov    rax,0x102235
  101f8a:	48 89 c1             	mov    rcx,rax
  101f8d:	b8 64 00 00 00       	mov    eax,0x64
  101f92:	83 c0 0e             	add    eax,0xe
  101f95:	0f b6 c0             	movzx  eax,al
  101f98:	ba 8e 00 00 00       	mov    edx,0x8e
  101f9d:	48 89 ce             	mov    rsi,rcx
  101fa0:	89 c7                	mov    edi,eax
  101fa2:	e8 f1 fa ff ff       	call   101a98 <idt_set>
  101fa7:	48 c7 c0 4f 22 10 00 	mov    rax,0x10224f
  101fae:	48 89 c1             	mov    rcx,rax
  101fb1:	b8 64 00 00 00       	mov    eax,0x64
  101fb6:	83 c0 0f             	add    eax,0xf
  101fb9:	0f b6 c0             	movzx  eax,al
  101fbc:	ba 8e 00 00 00       	mov    edx,0x8e
  101fc1:	48 89 ce             	mov    rsi,rcx
  101fc4:	89 c7                	mov    edi,eax
  101fc6:	e8 cd fa ff ff       	call   101a98 <idt_set>
  101fcb:	48 c7 c0 89 20 10 00 	mov    rax,0x102089
  101fd2:	48 89 c1             	mov    rcx,rax
  101fd5:	b8 80 ff ff ff       	mov    eax,0xffffff80
  101fda:	0f b6 c0             	movzx  eax,al
  101fdd:	ba 8e 00 00 00       	mov    edx,0x8e
  101fe2:	48 89 ce             	mov    rsi,rcx
  101fe5:	89 c7                	mov    edi,eax
  101fe7:	e8 ac fa ff ff       	call   101a98 <idt_set>
  101fec:	90                   	nop
  101fed:	5d                   	pop    rbp
  101fee:	c3                   	ret    

0000000000101fef <interrupt_init>:
  101fef:	55                   	push   rbp
  101ff0:	48 89 e5             	mov    rbp,rsp
  101ff3:	ba 64 00 00 00       	mov    edx,0x64
  101ff8:	b8 80 ff ff ff       	mov    eax,0xffffff80
  101ffd:	38 c2                	cmp    dl,al
  101fff:	77 23                	ja     102024 <interrupt_init+0x35>
  102001:	b8 64 00 00 00       	mov    eax,0x64
  102006:	0f b6 c0             	movzx  eax,al
  102009:	8d 50 0f             	lea    edx,[rax+0xf]
  10200c:	b8 80 ff ff ff       	mov    eax,0xffffff80
  102011:	0f b6 c0             	movzx  eax,al
  102014:	39 c2                	cmp    edx,eax
  102016:	7c 0c                	jl     102024 <interrupt_init+0x35>
  102018:	48 8d 3d 79 43 00 00 	lea    rdi,[rip+0x4379]        # 106398 <syscall_isr+0x7>
  10201f:	e8 9c 09 00 00       	call   1029c0 <panic>
  102024:	b8 80 ff ff ff       	mov    eax,0xffffff80
  102029:	3c 1f                	cmp    al,0x1f
  10202b:	77 0c                	ja     102039 <interrupt_init+0x4a>
  10202d:	48 8d 3d 8c 43 00 00 	lea    rdi,[rip+0x438c]        # 1063c0 <syscall_isr+0x2f>
  102034:	e8 87 09 00 00       	call   1029c0 <panic>
  102039:	b8 00 00 00 00       	mov    eax,0x0
  10203e:	e8 3a fb ff ff       	call   101b7d <idt_map>
  102043:	b8 00 00 00 00       	mov    eax,0x0
  102048:	e8 1e 02 00 00       	call   10226b <IC_Controller>
  10204d:	89 c7                	mov    edi,eax
  10204f:	e8 34 02 00 00       	call   102288 <IC_Configure>
  102054:	66 c7 05 ab cf 01 00 	mov    WORD PTR [rip+0x1cfab],0x1000        # 11f008 <IDTR>
  10205b:	00 10 
  10205d:	48 8d 05 fc 9f 01 00 	lea    rax,[rip+0x19ffc]        # 11c060 <IDT>
  102064:	48 89 05 9f cf 01 00 	mov    QWORD PTR [rip+0x1cf9f],rax        # 11f00a <IDTR+0x2>
  10206b:	48 8d 3d 96 cf 01 00 	lea    rdi,[rip+0x1cf96]        # 11f008 <IDTR>
  102072:	e8 0d 00 00 00       	call   102084 <IDT_load>
  102077:	b8 00 00 00 00       	mov    eax,0x0
  10207c:	5d                   	pop    rbp
  10207d:	c3                   	ret    
  10207e:	66 90                	xchg   ax,ax

0000000000102080 <interrupt_enable>:
  102080:	fb                   	sti    
  102081:	c3                   	ret    

0000000000102082 <interrupt_disable>:
  102082:	fa                   	cli    
  102083:	c3                   	ret    

0000000000102084 <IDT_load>:
  102084:	fa                   	cli    
  102085:	0f 01 1f             	lidt   [rdi]
  102088:	c3                   	ret    

0000000000102089 <syscall_fn>:
  102089:	53                   	push   rbx
  10208a:	55                   	push   rbp
  10208b:	41 54                	push   r12
  10208d:	41 55                	push   r13
  10208f:	41 56                	push   r14
  102091:	41 57                	push   r15
  102093:	41 5f                	pop    r15
  102095:	41 5e                	pop    r14
  102097:	41 5d                	pop    r13
  102099:	41 5c                	pop    r12
  10209b:	5d                   	pop    rbp
  10209c:	5b                   	pop    rbx
  10209d:	48 cf                	iretq  

000000000010209f <exc_0>:
  10209f:	48 cf                	iretq  

00000000001020a1 <exc_1>:
  1020a1:	48 cf                	iretq  

00000000001020a3 <exc_2>:
  1020a3:	48 cf                	iretq  

00000000001020a5 <exc_3>:
  1020a5:	48 cf                	iretq  

00000000001020a7 <exc_4>:
  1020a7:	48 cf                	iretq  

00000000001020a9 <exc_5>:
  1020a9:	48 cf                	iretq  

00000000001020ab <exc_6>:
  1020ab:	48 cf                	iretq  

00000000001020ad <exc_7>:
  1020ad:	48 cf                	iretq  

00000000001020af <exc_8>:
  1020af:	48 cf                	iretq  

00000000001020b1 <exc_9>:
  1020b1:	48 cf                	iretq  

00000000001020b3 <exc_10>:
  1020b3:	48 cf                	iretq  

00000000001020b5 <exc_11>:
  1020b5:	48 cf                	iretq  

00000000001020b7 <exc_12>:
  1020b7:	48 cf                	iretq  

00000000001020b9 <exc_13>:
  1020b9:	48 cf                	iretq  

00000000001020bb <exc_14>:
  1020bb:	48 cf                	iretq  

00000000001020bd <exc_16>:
  1020bd:	48 cf                	iretq  

00000000001020bf <exc_17>:
  1020bf:	48 cf                	iretq  

00000000001020c1 <exc_18>:
  1020c1:	48 cf                	iretq  

00000000001020c3 <exc_19>:
  1020c3:	48 cf                	iretq  

00000000001020c5 <exc_20>:
  1020c5:	48 cf                	iretq  

00000000001020c7 <exc_30>:
  1020c7:	48 cf                	iretq  

00000000001020c9 <irq_0>:
  1020c9:	57                   	push   rdi
  1020ca:	bf 00 00 00 00       	mov    edi,0x0
  1020cf:	e8 15 02 00 00       	call   1022e9 <IC_SOI>
  1020d4:	5f                   	pop    rdi
  1020d5:	57                   	push   rdi
  1020d6:	bf 00 00 00 00       	mov    edi,0x0
  1020db:	e8 4f 02 00 00       	call   10232f <IC_EOI>
  1020e0:	5f                   	pop    rdi
  1020e1:	48 cf                	iretq  

00000000001020e3 <irq_1>:
  1020e3:	57                   	push   rdi
  1020e4:	bf 01 00 00 00       	mov    edi,0x1
  1020e9:	e8 fb 01 00 00       	call   1022e9 <IC_SOI>
  1020ee:	5f                   	pop    rdi
  1020ef:	57                   	push   rdi
  1020f0:	bf 01 00 00 00       	mov    edi,0x1
  1020f5:	e8 35 02 00 00       	call   10232f <IC_EOI>
  1020fa:	5f                   	pop    rdi
  1020fb:	48 cf                	iretq  

00000000001020fd <irq_2>:
  1020fd:	57                   	push   rdi
  1020fe:	bf 02 00 00 00       	mov    edi,0x2
  102103:	e8 e1 01 00 00       	call   1022e9 <IC_SOI>
  102108:	5f                   	pop    rdi
  102109:	57                   	push   rdi
  10210a:	bf 02 00 00 00       	mov    edi,0x2
  10210f:	e8 1b 02 00 00       	call   10232f <IC_EOI>
  102114:	5f                   	pop    rdi
  102115:	48 cf                	iretq  

0000000000102117 <irq_3>:
  102117:	57                   	push   rdi
  102118:	bf 03 00 00 00       	mov    edi,0x3
  10211d:	e8 c7 01 00 00       	call   1022e9 <IC_SOI>
  102122:	5f                   	pop    rdi
  102123:	57                   	push   rdi
  102124:	bf 03 00 00 00       	mov    edi,0x3
  102129:	e8 01 02 00 00       	call   10232f <IC_EOI>
  10212e:	5f                   	pop    rdi
  10212f:	48 cf                	iretq  

0000000000102131 <irq_4>:
  102131:	57                   	push   rdi
  102132:	bf 04 00 00 00       	mov    edi,0x4
  102137:	e8 ad 01 00 00       	call   1022e9 <IC_SOI>
  10213c:	5f                   	pop    rdi
  10213d:	57                   	push   rdi
  10213e:	bf 04 00 00 00       	mov    edi,0x4
  102143:	e8 e7 01 00 00       	call   10232f <IC_EOI>
  102148:	5f                   	pop    rdi
  102149:	48 cf                	iretq  

000000000010214b <irq_5>:
  10214b:	57                   	push   rdi
  10214c:	bf 05 00 00 00       	mov    edi,0x5
  102151:	e8 93 01 00 00       	call   1022e9 <IC_SOI>
  102156:	5f                   	pop    rdi
  102157:	57                   	push   rdi
  102158:	bf 05 00 00 00       	mov    edi,0x5
  10215d:	e8 cd 01 00 00       	call   10232f <IC_EOI>
  102162:	5f                   	pop    rdi
  102163:	48 cf                	iretq  

0000000000102165 <irq_6>:
  102165:	57                   	push   rdi
  102166:	bf 06 00 00 00       	mov    edi,0x6
  10216b:	e8 79 01 00 00       	call   1022e9 <IC_SOI>
  102170:	5f                   	pop    rdi
  102171:	57                   	push   rdi
  102172:	bf 06 00 00 00       	mov    edi,0x6
  102177:	e8 b3 01 00 00       	call   10232f <IC_EOI>
  10217c:	5f                   	pop    rdi
  10217d:	48 cf                	iretq  

000000000010217f <irq_7>:
  10217f:	57                   	push   rdi
  102180:	bf 07 00 00 00       	mov    edi,0x7
  102185:	e8 5f 01 00 00       	call   1022e9 <IC_SOI>
  10218a:	5f                   	pop    rdi
  10218b:	57                   	push   rdi
  10218c:	bf 07 00 00 00       	mov    edi,0x7
  102191:	e8 99 01 00 00       	call   10232f <IC_EOI>
  102196:	5f                   	pop    rdi
  102197:	48 cf                	iretq  

0000000000102199 <irq_8>:
  102199:	57                   	push   rdi
  10219a:	bf 08 00 00 00       	mov    edi,0x8
  10219f:	e8 45 01 00 00       	call   1022e9 <IC_SOI>
  1021a4:	5f                   	pop    rdi
  1021a5:	57                   	push   rdi
  1021a6:	bf 08 00 00 00       	mov    edi,0x8
  1021ab:	e8 7f 01 00 00       	call   10232f <IC_EOI>
  1021b0:	5f                   	pop    rdi
  1021b1:	48 cf                	iretq  

00000000001021b3 <irq_9>:
  1021b3:	57                   	push   rdi
  1021b4:	bf 09 00 00 00       	mov    edi,0x9
  1021b9:	e8 2b 01 00 00       	call   1022e9 <IC_SOI>
  1021be:	5f                   	pop    rdi
  1021bf:	57                   	push   rdi
  1021c0:	bf 09 00 00 00       	mov    edi,0x9
  1021c5:	e8 65 01 00 00       	call   10232f <IC_EOI>
  1021ca:	5f                   	pop    rdi
  1021cb:	48 cf                	iretq  

00000000001021cd <irq_10>:
  1021cd:	57                   	push   rdi
  1021ce:	bf 0a 00 00 00       	mov    edi,0xa
  1021d3:	e8 11 01 00 00       	call   1022e9 <IC_SOI>
  1021d8:	5f                   	pop    rdi
  1021d9:	57                   	push   rdi
  1021da:	bf 0a 00 00 00       	mov    edi,0xa
  1021df:	e8 4b 01 00 00       	call   10232f <IC_EOI>
  1021e4:	5f                   	pop    rdi
  1021e5:	48 cf                	iretq  

00000000001021e7 <irq_11>:
  1021e7:	57                   	push   rdi
  1021e8:	bf 0b 00 00 00       	mov    edi,0xb
  1021ed:	e8 f7 00 00 00       	call   1022e9 <IC_SOI>
  1021f2:	5f                   	pop    rdi
  1021f3:	57                   	push   rdi
  1021f4:	bf 0b 00 00 00       	mov    edi,0xb
  1021f9:	e8 31 01 00 00       	call   10232f <IC_EOI>
  1021fe:	5f                   	pop    rdi
  1021ff:	48 cf                	iretq  

0000000000102201 <irq_12>:
  102201:	57                   	push   rdi
  102202:	bf 0c 00 00 00       	mov    edi,0xc
  102207:	e8 dd 00 00 00       	call   1022e9 <IC_SOI>
  10220c:	5f                   	pop    rdi
  10220d:	57                   	push   rdi
  10220e:	bf 0c 00 00 00       	mov    edi,0xc
  102213:	e8 17 01 00 00       	call   10232f <IC_EOI>
  102218:	5f                   	pop    rdi
  102219:	48 cf                	iretq  

000000000010221b <irq_13>:
  10221b:	57                   	push   rdi
  10221c:	bf 0d 00 00 00       	mov    edi,0xd
  102221:	e8 c3 00 00 00       	call   1022e9 <IC_SOI>
  102226:	5f                   	pop    rdi
  102227:	57                   	push   rdi
  102228:	bf 0d 00 00 00       	mov    edi,0xd
  10222d:	e8 fd 00 00 00       	call   10232f <IC_EOI>
  102232:	5f                   	pop    rdi
  102233:	48 cf                	iretq  

0000000000102235 <irq_14>:
  102235:	57                   	push   rdi
  102236:	bf 0e 00 00 00       	mov    edi,0xe
  10223b:	e8 a9 00 00 00       	call   1022e9 <IC_SOI>
  102240:	5f                   	pop    rdi
  102241:	57                   	push   rdi
  102242:	bf 0e 00 00 00       	mov    edi,0xe
  102247:	e8 e3 00 00 00       	call   10232f <IC_EOI>
  10224c:	5f                   	pop    rdi
  10224d:	48 cf                	iretq  

000000000010224f <irq_15>:
  10224f:	57                   	push   rdi
  102250:	bf 0f 00 00 00       	mov    edi,0xf
  102255:	e8 8f 00 00 00       	call   1022e9 <IC_SOI>
  10225a:	5f                   	pop    rdi
  10225b:	57                   	push   rdi
  10225c:	bf 0f 00 00 00       	mov    edi,0xf
  102261:	e8 c9 00 00 00       	call   10232f <IC_EOI>
  102266:	5f                   	pop    rdi
  102267:	48 cf                	iretq  

0000000000102269 <isr_spurious>:
  102269:	48 cf                	iretq  

000000000010226b <IC_Controller>:
  10226b:	55                   	push   rbp
  10226c:	48 89 e5             	mov    rbp,rsp
  10226f:	0f b6 05 16 ae 01 00 	movzx  eax,BYTE PTR [rip+0x1ae16]        # 11d08c <x64ID+0xc>
  102276:	84 c0                	test   al,al
  102278:	74 07                	je     102281 <IC_Controller+0x16>
  10227a:	b8 01 00 00 00       	mov    eax,0x1
  10227f:	eb 05                	jmp    102286 <IC_Controller+0x1b>
  102281:	b8 00 00 00 00       	mov    eax,0x0
  102286:	5d                   	pop    rbp
  102287:	c3                   	ret    

0000000000102288 <IC_Configure>:
  102288:	55                   	push   rbp
  102289:	48 89 e5             	mov    rbp,rsp
  10228c:	48 83 ec 10          	sub    rsp,0x10
  102290:	89 7d fc             	mov    DWORD PTR [rbp-0x4],edi
  102293:	83 7d fc 00          	cmp    DWORD PTR [rbp-0x4],0x0
  102297:	74 08                	je     1022a1 <IC_Configure+0x19>
  102299:	83 7d fc 01          	cmp    DWORD PTR [rbp-0x4],0x1
  10229d:	74 24                	je     1022c3 <IC_Configure+0x3b>
  10229f:	eb 35                	jmp    1022d6 <IC_Configure+0x4e>
  1022a1:	0f b6 05 e8 40 00 00 	movzx  eax,BYTE PTR [rip+0x40e8]        # 106390 <IRQ_start>
  1022a8:	83 c0 08             	add    eax,0x8
  1022ab:	0f b6 d0             	movzx  edx,al
  1022ae:	0f b6 05 db 40 00 00 	movzx  eax,BYTE PTR [rip+0x40db]        # 106390 <IRQ_start>
  1022b5:	0f b6 c0             	movzx  eax,al
  1022b8:	89 d6                	mov    esi,edx
  1022ba:	89 c7                	mov    edi,eax
  1022bc:	e8 65 01 00 00       	call   102426 <PIC_Configure>
  1022c1:	eb 24                	jmp    1022e7 <IC_Configure+0x5f>
  1022c3:	0f b6 05 c6 40 00 00 	movzx  eax,BYTE PTR [rip+0x40c6]        # 106390 <IRQ_start>
  1022ca:	0f b6 c0             	movzx  eax,al
  1022cd:	89 c7                	mov    edi,eax
  1022cf:	e8 a1 04 00 00       	call   102775 <APIC_Configure>
  1022d4:	eb 11                	jmp    1022e7 <IC_Configure+0x5f>
  1022d6:	48 8d 3d 14 41 00 00 	lea    rdi,[rip+0x4114]        # 1063f1 <syscall_isr+0x60>
  1022dd:	e8 de 06 00 00       	call   1029c0 <panic>
  1022e2:	b8 ff ff ff ff       	mov    eax,0xffffffff
  1022e7:	c9                   	leave  
  1022e8:	c3                   	ret    

00000000001022e9 <IC_SOI>:
  1022e9:	55                   	push   rbp
  1022ea:	48 89 e5             	mov    rbp,rsp
  1022ed:	48 83 ec 10          	sub    rsp,0x10
  1022f1:	89 f8                	mov    eax,edi
  1022f3:	88 45 fc             	mov    BYTE PTR [rbp-0x4],al
  1022f6:	8b 05 74 ad 01 00    	mov    eax,DWORD PTR [rip+0x1ad74]        # 11d070 <ic_control>
  1022fc:	85 c0                	test   eax,eax
  1022fe:	74 07                	je     102307 <IC_SOI+0x1e>
  102300:	83 f8 01             	cmp    eax,0x1
  102303:	74 0f                	je     102314 <IC_SOI+0x2b>
  102305:	eb 1a                	jmp    102321 <IC_SOI+0x38>
  102307:	0f b6 45 fc          	movzx  eax,BYTE PTR [rbp-0x4]
  10230b:	89 c7                	mov    edi,eax
  10230d:	e8 ac 02 00 00       	call   1025be <PIC_SOI>
  102312:	eb 19                	jmp    10232d <IC_SOI+0x44>
  102314:	0f b6 45 fc          	movzx  eax,BYTE PTR [rbp-0x4]
  102318:	89 c7                	mov    edi,eax
  10231a:	e8 8b 04 00 00       	call   1027aa <APIC_SOI>
  10231f:	eb 0c                	jmp    10232d <IC_SOI+0x44>
  102321:	48 8d 3d c9 40 00 00 	lea    rdi,[rip+0x40c9]        # 1063f1 <syscall_isr+0x60>
  102328:	e8 93 06 00 00       	call   1029c0 <panic>
  10232d:	c9                   	leave  
  10232e:	c3                   	ret    

000000000010232f <IC_EOI>:
  10232f:	55                   	push   rbp
  102330:	48 89 e5             	mov    rbp,rsp
  102333:	48 83 ec 10          	sub    rsp,0x10
  102337:	89 f8                	mov    eax,edi
  102339:	88 45 fc             	mov    BYTE PTR [rbp-0x4],al
  10233c:	8b 05 2e ad 01 00    	mov    eax,DWORD PTR [rip+0x1ad2e]        # 11d070 <ic_control>
  102342:	85 c0                	test   eax,eax
  102344:	74 07                	je     10234d <IC_EOI+0x1e>
  102346:	83 f8 01             	cmp    eax,0x1
  102349:	74 0f                	je     10235a <IC_EOI+0x2b>
  10234b:	eb 1a                	jmp    102367 <IC_EOI+0x38>
  10234d:	0f b6 45 fc          	movzx  eax,BYTE PTR [rbp-0x4]
  102351:	89 c7                	mov    edi,eax
  102353:	e8 e1 02 00 00       	call   102639 <PIC_EOI>
  102358:	eb 19                	jmp    102373 <IC_EOI+0x44>
  10235a:	0f b6 45 fc          	movzx  eax,BYTE PTR [rbp-0x4]
  10235e:	89 c7                	mov    edi,eax
  102360:	e8 51 04 00 00       	call   1027b6 <APIC_EOI>
  102365:	eb 0c                	jmp    102373 <IC_EOI+0x44>
  102367:	48 8d 3d 83 40 00 00 	lea    rdi,[rip+0x4083]        # 1063f1 <syscall_isr+0x60>
  10236e:	e8 4d 06 00 00       	call   1029c0 <panic>
  102373:	c9                   	leave  
  102374:	c3                   	ret    

0000000000102375 <IRQ_save>:
  102375:	55                   	push   rbp
  102376:	48 89 e5             	mov    rbp,rsp
  102379:	8b 05 f1 ac 01 00    	mov    eax,DWORD PTR [rip+0x1acf1]        # 11d070 <ic_control>
  10237f:	85 c0                	test   eax,eax
  102381:	74 07                	je     10238a <IRQ_save+0x15>
  102383:	83 f8 01             	cmp    eax,0x1
  102386:	74 0e                	je     102396 <IRQ_save+0x21>
  102388:	eb 18                	jmp    1023a2 <IRQ_save+0x2d>
  10238a:	b8 00 00 00 00       	mov    eax,0x0
  10238f:	e8 d9 02 00 00       	call   10266d <PIC_IRQ_save>
  102394:	eb 18                	jmp    1023ae <IRQ_save+0x39>
  102396:	b8 00 00 00 00       	mov    eax,0x0
  10239b:	e8 33 04 00 00       	call   1027d3 <APIC_IRQ_save>
  1023a0:	eb 0c                	jmp    1023ae <IRQ_save+0x39>
  1023a2:	48 8d 3d 48 40 00 00 	lea    rdi,[rip+0x4048]        # 1063f1 <syscall_isr+0x60>
  1023a9:	e8 12 06 00 00       	call   1029c0 <panic>
  1023ae:	5d                   	pop    rbp
  1023af:	c3                   	ret    

00000000001023b0 <IRQ_kill>:
  1023b0:	55                   	push   rbp
  1023b1:	48 89 e5             	mov    rbp,rsp
  1023b4:	8b 05 b6 ac 01 00    	mov    eax,DWORD PTR [rip+0x1acb6]        # 11d070 <ic_control>
  1023ba:	85 c0                	test   eax,eax
  1023bc:	74 07                	je     1023c5 <IRQ_kill+0x15>
  1023be:	83 f8 01             	cmp    eax,0x1
  1023c1:	74 0e                	je     1023d1 <IRQ_kill+0x21>
  1023c3:	eb 18                	jmp    1023dd <IRQ_kill+0x2d>
  1023c5:	b8 00 00 00 00       	mov    eax,0x0
  1023ca:	e8 c5 02 00 00       	call   102694 <PIC_IRQ_kill>
  1023cf:	eb 18                	jmp    1023e9 <IRQ_kill+0x39>
  1023d1:	b8 00 00 00 00       	mov    eax,0x0
  1023d6:	e8 ff 03 00 00       	call   1027da <APIC_IRQ_kill>
  1023db:	eb 0c                	jmp    1023e9 <IRQ_kill+0x39>
  1023dd:	48 8d 3d 0d 40 00 00 	lea    rdi,[rip+0x400d]        # 1063f1 <syscall_isr+0x60>
  1023e4:	e8 d7 05 00 00       	call   1029c0 <panic>
  1023e9:	5d                   	pop    rbp
  1023ea:	c3                   	ret    

00000000001023eb <IRQ_restore>:
  1023eb:	55                   	push   rbp
  1023ec:	48 89 e5             	mov    rbp,rsp
  1023ef:	8b 05 7b ac 01 00    	mov    eax,DWORD PTR [rip+0x1ac7b]        # 11d070 <ic_control>
  1023f5:	85 c0                	test   eax,eax
  1023f7:	74 07                	je     102400 <IRQ_restore+0x15>
  1023f9:	83 f8 01             	cmp    eax,0x1
  1023fc:	74 0e                	je     10240c <IRQ_restore+0x21>
  1023fe:	eb 18                	jmp    102418 <IRQ_restore+0x2d>
  102400:	b8 00 00 00 00       	mov    eax,0x0
  102405:	e8 af 02 00 00       	call   1026b9 <PIC_IRQ_restore>
  10240a:	eb 18                	jmp    102424 <IRQ_restore+0x39>
  10240c:	b8 00 00 00 00       	mov    eax,0x0
  102411:	e8 cb 03 00 00       	call   1027e1 <APIC_IRQ_restore>
  102416:	eb 0c                	jmp    102424 <IRQ_restore+0x39>
  102418:	48 8d 3d d2 3f 00 00 	lea    rdi,[rip+0x3fd2]        # 1063f1 <syscall_isr+0x60>
  10241f:	e8 9c 05 00 00       	call   1029c0 <panic>
  102424:	5d                   	pop    rbp
  102425:	c3                   	ret    

0000000000102426 <PIC_Configure>:
  102426:	55                   	push   rbp
  102427:	48 89 e5             	mov    rbp,rsp
  10242a:	48 83 ec 20          	sub    rsp,0x20
  10242e:	89 fa                	mov    edx,edi
  102430:	89 f0                	mov    eax,esi
  102432:	88 55 ec             	mov    BYTE PTR [rbp-0x14],dl
  102435:	88 45 e8             	mov    BYTE PTR [rbp-0x18],al
  102438:	0f b6 05 4d ac 01 00 	movzx  eax,BYTE PTR [rip+0x1ac4d]        # 11d08c <x64ID+0xc>
  10243f:	84 c0                	test   al,al
  102441:	74 0a                	je     10244d <PIC_Configure+0x27>
  102443:	b8 00 00 00 00       	mov    eax,0x0
  102448:	e8 9b 03 00 00       	call   1027e8 <APIC_disable>
  10244d:	bf 21 00 00 00       	mov    edi,0x21
  102452:	e8 5c de ff ff       	call   1002b3 <inb>
  102457:	88 45 ff             	mov    BYTE PTR [rbp-0x1],al
  10245a:	bf a1 00 00 00       	mov    edi,0xa1
  10245f:	e8 4f de ff ff       	call   1002b3 <inb>
  102464:	88 45 fe             	mov    BYTE PTR [rbp-0x2],al
  102467:	be 11 00 00 00       	mov    esi,0x11
  10246c:	bf 20 00 00 00       	mov    edi,0x20
  102471:	e8 69 de ff ff       	call   1002df <outb>
  102476:	b8 00 00 00 00       	mov    eax,0x0
  10247b:	e8 8e de ff ff       	call   10030e <io_wait>
  102480:	be 11 00 00 00       	mov    esi,0x11
  102485:	bf a0 00 00 00       	mov    edi,0xa0
  10248a:	e8 50 de ff ff       	call   1002df <outb>
  10248f:	b8 00 00 00 00       	mov    eax,0x0
  102494:	e8 75 de ff ff       	call   10030e <io_wait>
  102499:	0f b6 45 ec          	movzx  eax,BYTE PTR [rbp-0x14]
  10249d:	89 c6                	mov    esi,eax
  10249f:	bf 21 00 00 00       	mov    edi,0x21
  1024a4:	e8 36 de ff ff       	call   1002df <outb>
  1024a9:	b8 00 00 00 00       	mov    eax,0x0
  1024ae:	e8 5b de ff ff       	call   10030e <io_wait>
  1024b3:	0f b6 45 e8          	movzx  eax,BYTE PTR [rbp-0x18]
  1024b7:	89 c6                	mov    esi,eax
  1024b9:	bf a1 00 00 00       	mov    edi,0xa1
  1024be:	e8 1c de ff ff       	call   1002df <outb>
  1024c3:	b8 00 00 00 00       	mov    eax,0x0
  1024c8:	e8 41 de ff ff       	call   10030e <io_wait>
  1024cd:	be 04 00 00 00       	mov    esi,0x4
  1024d2:	bf 21 00 00 00       	mov    edi,0x21
  1024d7:	e8 03 de ff ff       	call   1002df <outb>
  1024dc:	b8 00 00 00 00       	mov    eax,0x0
  1024e1:	e8 28 de ff ff       	call   10030e <io_wait>
  1024e6:	be 02 00 00 00       	mov    esi,0x2
  1024eb:	bf a1 00 00 00       	mov    edi,0xa1
  1024f0:	e8 ea dd ff ff       	call   1002df <outb>
  1024f5:	b8 00 00 00 00       	mov    eax,0x0
  1024fa:	e8 0f de ff ff       	call   10030e <io_wait>
  1024ff:	be 01 00 00 00       	mov    esi,0x1
  102504:	bf 21 00 00 00       	mov    edi,0x21
  102509:	e8 d1 dd ff ff       	call   1002df <outb>
  10250e:	b8 00 00 00 00       	mov    eax,0x0
  102513:	e8 f6 dd ff ff       	call   10030e <io_wait>
  102518:	be 01 00 00 00       	mov    esi,0x1
  10251d:	bf a1 00 00 00       	mov    edi,0xa1
  102522:	e8 b8 dd ff ff       	call   1002df <outb>
  102527:	b8 00 00 00 00       	mov    eax,0x0
  10252c:	e8 dd dd ff ff       	call   10030e <io_wait>
  102531:	0f b6 45 ff          	movzx  eax,BYTE PTR [rbp-0x1]
  102535:	89 c6                	mov    esi,eax
  102537:	bf 21 00 00 00       	mov    edi,0x21
  10253c:	e8 9e dd ff ff       	call   1002df <outb>
  102541:	0f b6 45 fe          	movzx  eax,BYTE PTR [rbp-0x2]
  102545:	89 c6                	mov    esi,eax
  102547:	bf a1 00 00 00       	mov    edi,0xa1
  10254c:	e8 8e dd ff ff       	call   1002df <outb>
  102551:	b8 00 00 00 00       	mov    eax,0x0
  102556:	c9                   	leave  
  102557:	c3                   	ret    

0000000000102558 <_pic_read>:
  102558:	55                   	push   rbp
  102559:	48 89 e5             	mov    rbp,rsp
  10255c:	53                   	push   rbx
  10255d:	48 83 ec 18          	sub    rsp,0x18
  102561:	89 f8                	mov    eax,edi
  102563:	88 45 ec             	mov    BYTE PTR [rbp-0x14],al
  102566:	0f b6 45 ec          	movzx  eax,BYTE PTR [rbp-0x14]
  10256a:	89 c6                	mov    esi,eax
  10256c:	bf 20 00 00 00       	mov    edi,0x20
  102571:	e8 69 dd ff ff       	call   1002df <outb>
  102576:	0f b6 45 ec          	movzx  eax,BYTE PTR [rbp-0x14]
  10257a:	89 c6                	mov    esi,eax
  10257c:	bf a0 00 00 00       	mov    edi,0xa0
  102581:	e8 59 dd ff ff       	call   1002df <outb>
  102586:	bf a0 00 00 00       	mov    edi,0xa0
  10258b:	e8 23 dd ff ff       	call   1002b3 <inb>
  102590:	0f b6 c0             	movzx  eax,al
  102593:	c1 e0 08             	shl    eax,0x8
  102596:	89 c3                	mov    ebx,eax
  102598:	bf 20 00 00 00       	mov    edi,0x20
  10259d:	e8 11 dd ff ff       	call   1002b3 <inb>
  1025a2:	0f b6 c0             	movzx  eax,al
  1025a5:	09 d8                	or     eax,ebx
  1025a7:	48 83 c4 18          	add    rsp,0x18
  1025ab:	5b                   	pop    rbx
  1025ac:	5d                   	pop    rbp
  1025ad:	c3                   	ret    

00000000001025ae <_pic_isr>:
  1025ae:	55                   	push   rbp
  1025af:	48 89 e5             	mov    rbp,rsp
  1025b2:	bf 0b 00 00 00       	mov    edi,0xb
  1025b7:	e8 9c ff ff ff       	call   102558 <_pic_read>
  1025bc:	5d                   	pop    rbp
  1025bd:	c3                   	ret    

00000000001025be <PIC_SOI>:
  1025be:	55                   	push   rbp
  1025bf:	48 89 e5             	mov    rbp,rsp
  1025c2:	48 83 ec 20          	sub    rsp,0x20
  1025c6:	89 f8                	mov    eax,edi
  1025c8:	88 45 ec             	mov    BYTE PTR [rbp-0x14],al
  1025cb:	80 7d ec 07          	cmp    BYTE PTR [rbp-0x14],0x7
  1025cf:	74 06                	je     1025d7 <PIC_SOI+0x19>
  1025d1:	80 7d ec 0f          	cmp    BYTE PTR [rbp-0x14],0xf
  1025d5:	75 5f                	jne    102636 <PIC_SOI+0x78>
  1025d7:	b8 00 00 00 00       	mov    eax,0x0
  1025dc:	e8 cd ff ff ff       	call   1025ae <_pic_isr>
  1025e1:	66 89 45 fe          	mov    WORD PTR [rbp-0x2],ax
  1025e5:	80 7d ec 07          	cmp    BYTE PTR [rbp-0x14],0x7
  1025e9:	75 14                	jne    1025ff <PIC_SOI+0x41>
  1025eb:	48 8b 05 0e 7a 02 00 	mov    rax,QWORD PTR [rip+0x27a0e]        # 12a000 <irq_spurious>
  1025f2:	48 83 c0 01          	add    rax,0x1
  1025f6:	48 89 05 03 7a 02 00 	mov    QWORD PTR [rip+0x27a03],rax        # 12a000 <irq_spurious>
  1025fd:	48 cf                	iretq  
  1025ff:	80 7d ec 0f          	cmp    BYTE PTR [rbp-0x14],0xf
  102603:	75 32                	jne    102637 <PIC_SOI+0x79>
  102605:	0f b7 45 fe          	movzx  eax,WORD PTR [rbp-0x2]
  102609:	0f b6 c0             	movzx  eax,al
  10260c:	83 f8 0f             	cmp    eax,0xf
  10260f:	74 26                	je     102637 <PIC_SOI+0x79>
  102611:	48 8b 05 e8 79 02 00 	mov    rax,QWORD PTR [rip+0x279e8]        # 12a000 <irq_spurious>
  102618:	48 83 c0 01          	add    rax,0x1
  10261c:	48 89 05 dd 79 02 00 	mov    QWORD PTR [rip+0x279dd],rax        # 12a000 <irq_spurious>
  102623:	be 20 00 00 00       	mov    esi,0x20
  102628:	bf 20 00 00 00       	mov    edi,0x20
  10262d:	e8 ad dc ff ff       	call   1002df <outb>
  102632:	48 cf                	iretq  
  102634:	eb 01                	jmp    102637 <PIC_SOI+0x79>
  102636:	90                   	nop
  102637:	c9                   	leave  
  102638:	c3                   	ret    

0000000000102639 <PIC_EOI>:
  102639:	55                   	push   rbp
  10263a:	48 89 e5             	mov    rbp,rsp
  10263d:	48 83 ec 10          	sub    rsp,0x10
  102641:	89 f8                	mov    eax,edi
  102643:	88 45 fc             	mov    BYTE PTR [rbp-0x4],al
  102646:	80 7d fc 07          	cmp    BYTE PTR [rbp-0x4],0x7
  10264a:	76 0f                	jbe    10265b <PIC_EOI+0x22>
  10264c:	be 20 00 00 00       	mov    esi,0x20
  102651:	bf a0 00 00 00       	mov    edi,0xa0
  102656:	e8 84 dc ff ff       	call   1002df <outb>
  10265b:	be 20 00 00 00       	mov    esi,0x20
  102660:	bf 20 00 00 00       	mov    edi,0x20
  102665:	e8 75 dc ff ff       	call   1002df <outb>
  10266a:	90                   	nop
  10266b:	c9                   	leave  
  10266c:	c3                   	ret    

000000000010266d <PIC_IRQ_save>:
  10266d:	55                   	push   rbp
  10266e:	48 89 e5             	mov    rbp,rsp
  102671:	bf 21 00 00 00       	mov    edi,0x21
  102676:	e8 38 dc ff ff       	call   1002b3 <inb>
  10267b:	88 05 df a9 01 00    	mov    BYTE PTR [rip+0x1a9df],al        # 11d060 <irq1>
  102681:	bf a1 00 00 00       	mov    edi,0xa1
  102686:	e8 28 dc ff ff       	call   1002b3 <inb>
  10268b:	88 05 6f c9 01 00    	mov    BYTE PTR [rip+0x1c96f],al        # 11f000 <irq2>
  102691:	90                   	nop
  102692:	5d                   	pop    rbp
  102693:	c3                   	ret    

0000000000102694 <PIC_IRQ_kill>:
  102694:	55                   	push   rbp
  102695:	48 89 e5             	mov    rbp,rsp
  102698:	be ff 00 00 00       	mov    esi,0xff
  10269d:	bf 21 00 00 00       	mov    edi,0x21
  1026a2:	e8 38 dc ff ff       	call   1002df <outb>
  1026a7:	be ff 00 00 00       	mov    esi,0xff
  1026ac:	bf a1 00 00 00       	mov    edi,0xa1
  1026b1:	e8 29 dc ff ff       	call   1002df <outb>
  1026b6:	90                   	nop
  1026b7:	5d                   	pop    rbp
  1026b8:	c3                   	ret    

00000000001026b9 <PIC_IRQ_restore>:
  1026b9:	55                   	push   rbp
  1026ba:	48 89 e5             	mov    rbp,rsp
  1026bd:	0f b6 05 9c a9 01 00 	movzx  eax,BYTE PTR [rip+0x1a99c]        # 11d060 <irq1>
  1026c4:	0f b6 c0             	movzx  eax,al
  1026c7:	89 c6                	mov    esi,eax
  1026c9:	bf 21 00 00 00       	mov    edi,0x21
  1026ce:	e8 0c dc ff ff       	call   1002df <outb>
  1026d3:	0f b6 05 26 c9 01 00 	movzx  eax,BYTE PTR [rip+0x1c926]        # 11f000 <irq2>
  1026da:	0f b6 c0             	movzx  eax,al
  1026dd:	89 c6                	mov    esi,eax
  1026df:	bf a1 00 00 00       	mov    edi,0xa1
  1026e4:	e8 f6 db ff ff       	call   1002df <outb>
  1026e9:	90                   	nop
  1026ea:	5d                   	pop    rbp
  1026eb:	c3                   	ret    

00000000001026ec <PIC_disable>:
  1026ec:	55                   	push   rbp
  1026ed:	48 89 e5             	mov    rbp,rsp
  1026f0:	b8 00 00 00 00       	mov    eax,0x0
  1026f5:	e8 9a ff ff ff       	call   102694 <PIC_IRQ_kill>
  1026fa:	90                   	nop
  1026fb:	5d                   	pop    rbp
  1026fc:	c3                   	ret    

00000000001026fd <set_apic_base>:
  1026fd:	55                   	push   rbp
  1026fe:	48 89 e5             	mov    rbp,rsp
  102701:	48 83 ec 20          	sub    rsp,0x20
  102705:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
  102709:	c7 45 fc 00 00 00 00 	mov    DWORD PTR [rbp-0x4],0x0
  102710:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  102714:	25 00 f0 ff ff       	and    eax,0xfffff000
  102719:	80 cc 08             	or     ah,0x8
  10271c:	89 45 f8             	mov    DWORD PTR [rbp-0x8],eax
  10271f:	8b 55 fc             	mov    edx,DWORD PTR [rbp-0x4]
  102722:	8b 45 f8             	mov    eax,DWORD PTR [rbp-0x8]
  102725:	89 c6                	mov    esi,eax
  102727:	bf 1b 00 00 00       	mov    edi,0x1b
  10272c:	e8 e4 e0 ff ff       	call   100815 <writeMSR>
  102731:	90                   	nop
  102732:	c9                   	leave  
  102733:	c3                   	ret    

0000000000102734 <apic_spurious_set>:
  102734:	55                   	push   rbp
  102735:	48 89 e5             	mov    rbp,rsp
  102738:	48 c7 c0 69 22 10 00 	mov    rax,0x102269
  10273f:	48 89 c1             	mov    rcx,rax
  102742:	b8 ff ff ff ff       	mov    eax,0xffffffff
  102747:	0f b6 c0             	movzx  eax,al
  10274a:	ba 8e 00 00 00       	mov    edx,0x8e
  10274f:	48 89 ce             	mov    rsi,rcx
  102752:	89 c7                	mov    edi,eax
  102754:	e8 3f f3 ff ff       	call   101a98 <idt_set>
  102759:	b8 ff ff ff ff       	mov    eax,0xffffffff
  10275e:	0f b6 c0             	movzx  eax,al
  102761:	80 cc 11             	or     ah,0x11
  102764:	ba 00 10 00 00       	mov    edx,0x1000
  102769:	48 81 c2 f0 00 00 00 	add    rdx,0xf0
  102770:	89 02                	mov    DWORD PTR [rdx],eax
  102772:	90                   	nop
  102773:	5d                   	pop    rbp
  102774:	c3                   	ret    

0000000000102775 <APIC_Configure>:
  102775:	55                   	push   rbp
  102776:	48 89 e5             	mov    rbp,rsp
  102779:	48 83 ec 10          	sub    rsp,0x10
  10277d:	89 f8                	mov    eax,edi
  10277f:	88 45 fc             	mov    BYTE PTR [rbp-0x4],al
  102782:	b8 00 00 00 00       	mov    eax,0x0
  102787:	e8 60 ff ff ff       	call   1026ec <PIC_disable>
  10278c:	b8 00 10 00 00       	mov    eax,0x1000
  102791:	48 89 c7             	mov    rdi,rax
  102794:	e8 64 ff ff ff       	call   1026fd <set_apic_base>
  102799:	b8 00 00 00 00       	mov    eax,0x0
  10279e:	e8 91 ff ff ff       	call   102734 <apic_spurious_set>
  1027a3:	b8 00 00 00 00       	mov    eax,0x0
  1027a8:	c9                   	leave  
  1027a9:	c3                   	ret    

00000000001027aa <APIC_SOI>:
  1027aa:	55                   	push   rbp
  1027ab:	48 89 e5             	mov    rbp,rsp
  1027ae:	89 f8                	mov    eax,edi
  1027b0:	88 45 fc             	mov    BYTE PTR [rbp-0x4],al
  1027b3:	90                   	nop
  1027b4:	5d                   	pop    rbp
  1027b5:	c3                   	ret    

00000000001027b6 <APIC_EOI>:
  1027b6:	55                   	push   rbp
  1027b7:	48 89 e5             	mov    rbp,rsp
  1027ba:	89 f8                	mov    eax,edi
  1027bc:	88 45 fc             	mov    BYTE PTR [rbp-0x4],al
  1027bf:	b8 00 10 00 00       	mov    eax,0x1000
  1027c4:	48 05 b0 00 00 00    	add    rax,0xb0
  1027ca:	c7 00 00 00 00 00    	mov    DWORD PTR [rax],0x0
  1027d0:	90                   	nop
  1027d1:	5d                   	pop    rbp
  1027d2:	c3                   	ret    

00000000001027d3 <APIC_IRQ_save>:
  1027d3:	55                   	push   rbp
  1027d4:	48 89 e5             	mov    rbp,rsp
  1027d7:	90                   	nop
  1027d8:	5d                   	pop    rbp
  1027d9:	c3                   	ret    

00000000001027da <APIC_IRQ_kill>:
  1027da:	55                   	push   rbp
  1027db:	48 89 e5             	mov    rbp,rsp
  1027de:	90                   	nop
  1027df:	5d                   	pop    rbp
  1027e0:	c3                   	ret    

00000000001027e1 <APIC_IRQ_restore>:
  1027e1:	55                   	push   rbp
  1027e2:	48 89 e5             	mov    rbp,rsp
  1027e5:	90                   	nop
  1027e6:	5d                   	pop    rbp
  1027e7:	c3                   	ret    

00000000001027e8 <APIC_disable>:
  1027e8:	55                   	push   rbp
  1027e9:	48 89 e5             	mov    rbp,rsp
  1027ec:	48 83 ec 10          	sub    rsp,0x10
  1027f0:	48 8d 55 f8          	lea    rdx,[rbp-0x8]
  1027f4:	48 8d 45 fc          	lea    rax,[rbp-0x4]
  1027f8:	48 89 c6             	mov    rsi,rax
  1027fb:	bf 1b 00 00 00       	mov    edi,0x1b
  102800:	e8 e9 df ff ff       	call   1007ee <readMSR>
  102805:	c7 45 f8 00 00 00 00 	mov    DWORD PTR [rbp-0x8],0x0
  10280c:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  10280f:	80 e4 f7             	and    ah,0xf7
  102812:	89 45 fc             	mov    DWORD PTR [rbp-0x4],eax
  102815:	8b 55 f8             	mov    edx,DWORD PTR [rbp-0x8]
  102818:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  10281b:	89 c6                	mov    esi,eax
  10281d:	bf 1b 00 00 00       	mov    edi,0x1b
  102822:	e8 ee df ff ff       	call   100815 <writeMSR>
  102827:	90                   	nop
  102828:	c9                   	leave  
  102829:	c3                   	ret    

000000000010282a <startup>:
  10282a:	55                   	push   rbp
  10282b:	48 89 e5             	mov    rbp,rsp
  10282e:	b8 00 00 00 00       	mov    eax,0x0
  102833:	e8 4b f2 ff ff       	call   101a83 <interrupt_enabled>
  102838:	85 c0                	test   eax,eax
  10283a:	74 0a                	je     102846 <startup+0x1c>
  10283c:	b8 00 00 00 00       	mov    eax,0x0
  102841:	e8 3c f8 ff ff       	call   102082 <interrupt_disable>
  102846:	c6 05 23 e8 01 00 00 	mov    BYTE PTR [rip+0x1e823],0x0        # 121070 <System+0x30>
  10284d:	b8 00 00 00 00       	mov    eax,0x0
  102852:	e8 67 02 00 00       	call   102abe <log_init>
  102857:	b8 00 00 00 00       	mov    eax,0x0
  10285c:	e8 84 e9 ff ff       	call   1011e5 <printf_init>
  102861:	b8 00 00 00 00       	mov    eax,0x0
  102866:	e8 68 ef ff ff       	call   1017d3 <arch_init>
  10286b:	85 c0                	test   eax,eax
  10286d:	74 0c                	je     10287b <startup+0x51>
  10286f:	48 8d 3d aa 3b 00 00 	lea    rdi,[rip+0x3baa]        # 106420 <IRQ_spurious+0x8>
  102876:	e8 45 01 00 00       	call   1029c0 <panic>
  10287b:	b8 00 00 00 00       	mov    eax,0x0
  102880:	e8 ab 06 00 00       	call   102f30 <mm_init>
  102885:	48 8d 35 ae 3b 00 00 	lea    rsi,[rip+0x3bae]        # 10643a <IRQ_spurious+0x22>
  10288c:	bf 04 00 00 00       	mov    edi,0x4
  102891:	b8 00 00 00 00       	mov    eax,0x0
  102896:	e8 8f 02 00 00       	call   102b2a <pr_log>
  10289b:	48 8d 3d ac 3b 00 00 	lea    rdi,[rip+0x3bac]        # 10644e <IRQ_spurious+0x36>
  1028a2:	b8 00 00 00 00       	mov    eax,0x0
  1028a7:	e8 27 19 00 00       	call   1041d3 <printf>
  1028ac:	48 8d 3d ad 3b 00 00 	lea    rdi,[rip+0x3bad]        # 106460 <IRQ_spurious+0x48>
  1028b3:	b8 00 00 00 00       	mov    eax,0x0
  1028b8:	e8 16 19 00 00       	call   1041d3 <printf>
  1028bd:	48 8d 3d a0 3b 00 00 	lea    rdi,[rip+0x3ba0]        # 106464 <IRQ_spurious+0x4c>
  1028c4:	b8 00 00 00 00       	mov    eax,0x0
  1028c9:	e8 05 19 00 00       	call   1041d3 <printf>
  1028ce:	48 8d 3d 91 3b 00 00 	lea    rdi,[rip+0x3b91]        # 106466 <IRQ_spurious+0x4e>
  1028d5:	b8 00 00 00 00       	mov    eax,0x0
  1028da:	e8 f4 18 00 00       	call   1041d3 <printf>
  1028df:	48 8d 3d 8a 3b 00 00 	lea    rdi,[rip+0x3b8a]        # 106470 <IRQ_spurious+0x58>
  1028e6:	b8 00 00 00 00       	mov    eax,0x0
  1028eb:	e8 e3 18 00 00       	call   1041d3 <printf>
  1028f0:	48 8d 3d 7b 3b 00 00 	lea    rdi,[rip+0x3b7b]        # 106472 <IRQ_spurious+0x5a>
  1028f7:	b8 00 00 00 00       	mov    eax,0x0
  1028fc:	e8 d2 18 00 00       	call   1041d3 <printf>
  102901:	48 8d 3d 70 3b 00 00 	lea    rdi,[rip+0x3b70]        # 106478 <IRQ_spurious+0x60>
  102908:	b8 00 00 00 00       	mov    eax,0x0
  10290d:	e8 c1 18 00 00       	call   1041d3 <printf>
  102912:	48 8d 3d 27 e7 01 00 	lea    rdi,[rip+0x1e727]        # 121040 <System>
  102919:	e8 16 da ff ff       	call   100334 <getCPUINFO>
  10291e:	0f b6 05 1b e7 01 00 	movzx  eax,BYTE PTR [rip+0x1e71b]        # 121040 <System>
  102925:	84 c0                	test   al,al
  102927:	75 0c                	jne    102935 <startup+0x10b>
  102929:	48 8d 3d 50 3b 00 00 	lea    rdi,[rip+0x3b50]        # 106480 <IRQ_spurious+0x68>
  102930:	e8 8b 00 00 00       	call   1029c0 <panic>
  102935:	8b 05 15 e7 01 00    	mov    eax,DWORD PTR [rip+0x1e715]        # 121050 <System+0x10>
  10293b:	83 f8 16             	cmp    eax,0x16
  10293e:	75 16                	jne    102956 <startup+0x12c>
  102940:	48 8d 35 61 3b 00 00 	lea    rsi,[rip+0x3b61]        # 1064a8 <IRQ_spurious+0x90>
  102947:	bf 03 00 00 00       	mov    edi,0x3
  10294c:	b8 00 00 00 00       	mov    eax,0x0
  102951:	e8 d4 01 00 00       	call   102b2a <pr_log>
  102956:	48 8d 3d fb e6 01 00 	lea    rdi,[rip+0x1e6fb]        # 121058 <System+0x18>
  10295d:	e8 98 e4 ff ff       	call   100dfa <getMEMID>
  102962:	48 8b 05 ff e6 01 00 	mov    rax,QWORD PTR [rip+0x1e6ff]        # 121068 <System+0x28>
  102969:	48 c1 e8 14          	shr    rax,0x14
  10296d:	48 89 c2             	mov    rdx,rax
  102970:	48 8b 05 e9 e6 01 00 	mov    rax,QWORD PTR [rip+0x1e6e9]        # 121060 <System+0x20>
  102977:	48 89 d1             	mov    rcx,rdx
  10297a:	48 89 c2             	mov    rdx,rax
  10297d:	48 8d 35 6c 3b 00 00 	lea    rsi,[rip+0x3b6c]        # 1064f0 <IRQ_spurious+0xd8>
  102984:	bf 04 00 00 00       	mov    edi,0x4
  102989:	b8 00 00 00 00       	mov    eax,0x0
  10298e:	e8 97 01 00 00       	call   102b2a <pr_log>
  102993:	b8 00 00 00 00       	mov    eax,0x0
  102998:	e8 52 f6 ff ff       	call   101fef <interrupt_init>
  10299d:	b8 00 00 00 00       	mov    eax,0x0
  1029a2:	e8 ee 03 00 00       	call   102d95 <syscall_init>
  1029a7:	b8 00 00 00 00       	mov    eax,0x0
  1029ac:	e8 cf f6 ff ff       	call   102080 <interrupt_enable>
  1029b1:	48 8d 3d 68 3b 00 00 	lea    rdi,[rip+0x3b68]        # 106520 <IRQ_spurious+0x108>
  1029b8:	e8 03 00 00 00       	call   1029c0 <panic>
  1029bd:	90                   	nop
  1029be:	5d                   	pop    rbp
  1029bf:	c3                   	ret    

00000000001029c0 <panic>:
  1029c0:	55                   	push   rbp
  1029c1:	48 89 e5             	mov    rbp,rsp
  1029c4:	48 83 ec 10          	sub    rsp,0x10
  1029c8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
  1029cc:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1029d0:	48 89 c2             	mov    rdx,rax
  1029d3:	48 8d 35 8e 3b 00 00 	lea    rsi,[rip+0x3b8e]        # 106568 <IRQ_spurious+0x150>
  1029da:	bf 04 00 00 00       	mov    edi,0x4
  1029df:	b8 00 00 00 00       	mov    eax,0x0
  1029e4:	e8 41 01 00 00       	call   102b2a <pr_log>
  1029e9:	48 8d 3d a0 3b 00 00 	lea    rdi,[rip+0x3ba0]        # 106590 <IRQ_spurious+0x178>
  1029f0:	b8 00 00 00 00       	mov    eax,0x0
  1029f5:	e8 d9 17 00 00       	call   1041d3 <printf>
  1029fa:	48 8d 3d bb 3b 00 00 	lea    rdi,[rip+0x3bbb]        # 1065bc <IRQ_spurious+0x1a4>
  102a01:	b8 00 00 00 00       	mov    eax,0x0
  102a06:	e8 c8 17 00 00       	call   1041d3 <printf>
  102a0b:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  102a0f:	48 89 c7             	mov    rdi,rax
  102a12:	b8 00 00 00 00       	mov    eax,0x0
  102a17:	e8 b7 17 00 00       	call   1041d3 <printf>
  102a1c:	48 8d 3d 55 3a 00 00 	lea    rdi,[rip+0x3a55]        # 106478 <IRQ_spurious+0x60>
  102a23:	b8 00 00 00 00       	mov    eax,0x0
  102a28:	e8 a6 17 00 00       	call   1041d3 <printf>
  102a2d:	b8 00 00 00 00       	mov    eax,0x0
  102a32:	e8 3a ea ff ff       	call   101471 <PrintStackTrace>
  102a37:	48 8d 3d 3a 3a 00 00 	lea    rdi,[rip+0x3a3a]        # 106478 <IRQ_spurious+0x60>
  102a3e:	b8 00 00 00 00       	mov    eax,0x0
  102a43:	e8 8b 17 00 00       	call   1041d3 <printf>
  102a48:	48 8d 3d 7d 3b 00 00 	lea    rdi,[rip+0x3b7d]        # 1065cc <IRQ_spurious+0x1b4>
  102a4f:	b8 00 00 00 00       	mov    eax,0x0
  102a54:	e8 7a 17 00 00       	call   1041d3 <printf>
  102a59:	48 8d 35 7d 3b 00 00 	lea    rsi,[rip+0x3b7d]        # 1065dd <IRQ_spurious+0x1c5>
  102a60:	bf 04 00 00 00       	mov    edi,0x4
  102a65:	b8 00 00 00 00       	mov    eax,0x0
  102a6a:	e8 bb 00 00 00       	call   102b2a <pr_log>
  102a6f:	48 8d 35 83 3b 00 00 	lea    rsi,[rip+0x3b83]        # 1065f9 <IRQ_spurious+0x1e1>
  102a76:	bf 04 00 00 00       	mov    edi,0x4
  102a7b:	b8 00 00 00 00       	mov    eax,0x0
  102a80:	e8 a5 00 00 00       	call   102b2a <pr_log>
  102a85:	48 8d 35 84 3b 00 00 	lea    rsi,[rip+0x3b84]        # 106610 <IRQ_spurious+0x1f8>
  102a8c:	bf 04 00 00 00       	mov    edi,0x4
  102a91:	b8 00 00 00 00       	mov    eax,0x0
  102a96:	e8 8f 00 00 00       	call   102b2a <pr_log>
  102a9b:	48 8d 35 96 3b 00 00 	lea    rsi,[rip+0x3b96]        # 106638 <IRQ_spurious+0x220>
  102aa2:	bf 04 00 00 00       	mov    edi,0x4
  102aa7:	b8 00 00 00 00       	mov    eax,0x0
  102aac:	e8 79 00 00 00       	call   102b2a <pr_log>
  102ab1:	b8 00 00 00 00       	mov    eax,0x0
  102ab6:	e8 2c dd ff ff       	call   1007e7 <halt>
  102abb:	90                   	nop
  102abc:	c9                   	leave  
  102abd:	c3                   	ret    

0000000000102abe <log_init>:
  102abe:	55                   	push   rbp
  102abf:	48 89 e5             	mov    rbp,rsp
  102ac2:	ba 00 02 00 00       	mov    edx,0x200
  102ac7:	48 89 d0             	mov    rax,rdx
  102aca:	48 01 c0             	add    rax,rax
  102acd:	48 01 d0             	add    rax,rdx
  102ad0:	48 c1 e0 03          	shl    rax,0x3
  102ad4:	48 89 c7             	mov    rdi,rax
  102ad7:	e8 81 1d 00 00       	call   10485d <malloc>
  102adc:	48 89 05 3d e5 01 00 	mov    QWORD PTR [rip+0x1e53d],rax        # 121020 <log_entries>
  102ae3:	48 8b 05 36 e5 01 00 	mov    rax,QWORD PTR [rip+0x1e536]        # 121020 <log_entries>
  102aea:	48 85 c0             	test   rax,rax
  102aed:	75 07                	jne    102af6 <log_init+0x38>
  102aef:	b8 00 00 00 00       	mov    eax,0x0
  102af4:	eb 32                	jmp    102b28 <log_init+0x6a>
  102af6:	c6 05 13 75 02 00 01 	mov    BYTE PTR [rip+0x27513],0x1        # 12a010 <log_enable>
  102afd:	b8 00 00 00 00       	mov    eax,0x0
  102b02:	84 c0                	test   al,al
  102b04:	74 1d                	je     102b23 <log_init+0x65>
  102b06:	48 8d 15 73 3b 00 00 	lea    rdx,[rip+0x3b73]        # 106680 <log_entries_size+0x8>
  102b0d:	48 8d 35 84 3b 00 00 	lea    rsi,[rip+0x3b84]        # 106698 <log_entries_size+0x20>
  102b14:	bf 03 00 00 00       	mov    edi,0x3
  102b19:	b8 00 00 00 00       	mov    eax,0x0
  102b1e:	e8 07 00 00 00       	call   102b2a <pr_log>
  102b23:	b8 01 00 00 00       	mov    eax,0x1
  102b28:	5d                   	pop    rbp
  102b29:	c3                   	ret    

0000000000102b2a <pr_log>:
  102b2a:	55                   	push   rbp
  102b2b:	48 89 e5             	mov    rbp,rsp
  102b2e:	53                   	push   rbx
  102b2f:	48 81 ec d8 00 00 00 	sub    rsp,0xd8
  102b36:	89 bd 2c ff ff ff    	mov    DWORD PTR [rbp-0xd4],edi
  102b3c:	48 89 b5 20 ff ff ff 	mov    QWORD PTR [rbp-0xe0],rsi
  102b43:	48 89 95 50 ff ff ff 	mov    QWORD PTR [rbp-0xb0],rdx
  102b4a:	48 89 8d 58 ff ff ff 	mov    QWORD PTR [rbp-0xa8],rcx
  102b51:	4c 89 85 60 ff ff ff 	mov    QWORD PTR [rbp-0xa0],r8
  102b58:	4c 89 8d 68 ff ff ff 	mov    QWORD PTR [rbp-0x98],r9
  102b5f:	84 c0                	test   al,al
  102b61:	74 23                	je     102b86 <pr_log+0x5c>
  102b63:	0f 29 85 70 ff ff ff 	movaps XMMWORD PTR [rbp-0x90],xmm0
  102b6a:	0f 29 4d 80          	movaps XMMWORD PTR [rbp-0x80],xmm1
  102b6e:	0f 29 55 90          	movaps XMMWORD PTR [rbp-0x70],xmm2
  102b72:	0f 29 5d a0          	movaps XMMWORD PTR [rbp-0x60],xmm3
  102b76:	0f 29 65 b0          	movaps XMMWORD PTR [rbp-0x50],xmm4
  102b7a:	0f 29 6d c0          	movaps XMMWORD PTR [rbp-0x40],xmm5
  102b7e:	0f 29 75 d0          	movaps XMMWORD PTR [rbp-0x30],xmm6
  102b82:	0f 29 7d e0          	movaps XMMWORD PTR [rbp-0x20],xmm7
  102b86:	48 8b 05 7b 74 02 00 	mov    rax,QWORD PTR [rip+0x2747b]        # 12a008 <n_free_entry>
  102b8d:	ba 00 02 00 00       	mov    edx,0x200
  102b92:	48 39 d0             	cmp    rax,rdx
  102b95:	75 0c                	jne    102ba3 <pr_log+0x79>
  102b97:	48 8d 3d 7e 3b 00 00 	lea    rdi,[rip+0x3b7e]        # 10671c <log_entries_size+0xa4>
  102b9e:	e8 1d fe ff ff       	call   1029c0 <panic>
  102ba3:	48 8b 05 5e 74 02 00 	mov    rax,QWORD PTR [rip+0x2745e]        # 12a008 <n_free_entry>
  102baa:	48 89 85 38 ff ff ff 	mov    QWORD PTR [rbp-0xc8],rax
  102bb1:	48 8b 0d 68 e4 01 00 	mov    rcx,QWORD PTR [rip+0x1e468]        # 121020 <log_entries>
  102bb8:	48 8b 95 38 ff ff ff 	mov    rdx,QWORD PTR [rbp-0xc8]
  102bbf:	48 89 d0             	mov    rax,rdx
  102bc2:	48 01 c0             	add    rax,rax
  102bc5:	48 01 d0             	add    rax,rdx
  102bc8:	48 c1 e0 03          	shl    rax,0x3
  102bcc:	48 8d 1c 01          	lea    rbx,[rcx+rax*1]
  102bd0:	48 8b 85 20 ff ff ff 	mov    rax,QWORD PTR [rbp-0xe0]
  102bd7:	48 89 c7             	mov    rdi,rax
  102bda:	e8 34 17 00 00       	call   104313 <strlen>
  102bdf:	48 89 03             	mov    QWORD PTR [rbx],rax
  102be2:	48 8b 0d 37 e4 01 00 	mov    rcx,QWORD PTR [rip+0x1e437]        # 121020 <log_entries>
  102be9:	48 8b 95 38 ff ff ff 	mov    rdx,QWORD PTR [rbp-0xc8]
  102bf0:	48 89 d0             	mov    rax,rdx
  102bf3:	48 01 c0             	add    rax,rax
  102bf6:	48 01 d0             	add    rax,rdx
  102bf9:	48 c1 e0 03          	shl    rax,0x3
  102bfd:	48 8d 14 01          	lea    rdx,[rcx+rax*1]
  102c01:	8b 85 2c ff ff ff    	mov    eax,DWORD PTR [rbp-0xd4]
  102c07:	89 42 08             	mov    DWORD PTR [rdx+0x8],eax
  102c0a:	48 8b 0d 0f e4 01 00 	mov    rcx,QWORD PTR [rip+0x1e40f]        # 121020 <log_entries>
  102c11:	48 8b 95 38 ff ff ff 	mov    rdx,QWORD PTR [rbp-0xc8]
  102c18:	48 89 d0             	mov    rax,rdx
  102c1b:	48 01 c0             	add    rax,rax
  102c1e:	48 01 d0             	add    rax,rdx
  102c21:	48 c1 e0 03          	shl    rax,0x3
  102c25:	48 01 c8             	add    rax,rcx
  102c28:	48 8b 08             	mov    rcx,QWORD PTR [rax]
  102c2b:	48 8b 35 ee e3 01 00 	mov    rsi,QWORD PTR [rip+0x1e3ee]        # 121020 <log_entries>
  102c32:	48 8b 95 38 ff ff ff 	mov    rdx,QWORD PTR [rbp-0xc8]
  102c39:	48 89 d0             	mov    rax,rdx
  102c3c:	48 01 c0             	add    rax,rax
  102c3f:	48 01 d0             	add    rax,rdx
  102c42:	48 c1 e0 03          	shl    rax,0x3
  102c46:	48 8d 1c 06          	lea    rbx,[rsi+rax*1]
  102c4a:	48 89 cf             	mov    rdi,rcx
  102c4d:	e8 fd 02 00 00       	call   102f4f <kmalloc>
  102c52:	48 89 43 10          	mov    QWORD PTR [rbx+0x10],rax
  102c56:	48 8b 0d c3 e3 01 00 	mov    rcx,QWORD PTR [rip+0x1e3c3]        # 121020 <log_entries>
  102c5d:	48 8b 95 38 ff ff ff 	mov    rdx,QWORD PTR [rbp-0xc8]
  102c64:	48 89 d0             	mov    rax,rdx
  102c67:	48 01 c0             	add    rax,rax
  102c6a:	48 01 d0             	add    rax,rdx
  102c6d:	48 c1 e0 03          	shl    rax,0x3
  102c71:	48 01 c8             	add    rax,rcx
  102c74:	48 8b 00             	mov    rax,QWORD PTR [rax]
  102c77:	48 8d 70 01          	lea    rsi,[rax+0x1]
  102c7b:	48 8b 0d 9e e3 01 00 	mov    rcx,QWORD PTR [rip+0x1e39e]        # 121020 <log_entries>
  102c82:	48 8b 95 38 ff ff ff 	mov    rdx,QWORD PTR [rbp-0xc8]
  102c89:	48 89 d0             	mov    rax,rdx
  102c8c:	48 01 c0             	add    rax,rax
  102c8f:	48 01 d0             	add    rax,rdx
  102c92:	48 c1 e0 03          	shl    rax,0x3
  102c96:	48 01 c8             	add    rax,rcx
  102c99:	48 8b 40 10          	mov    rax,QWORD PTR [rax+0x10]
  102c9d:	48 8b 8d 20 ff ff ff 	mov    rcx,QWORD PTR [rbp-0xe0]
  102ca4:	48 89 f2             	mov    rdx,rsi
  102ca7:	48 89 ce             	mov    rsi,rcx
  102caa:	48 89 c7             	mov    rdi,rax
  102cad:	e8 b7 18 00 00       	call   104569 <memcpy>
  102cb2:	48 8b 0d 67 e3 01 00 	mov    rcx,QWORD PTR [rip+0x1e367]        # 121020 <log_entries>
  102cb9:	48 8b 95 38 ff ff ff 	mov    rdx,QWORD PTR [rbp-0xc8]
  102cc0:	48 89 d0             	mov    rax,rdx
  102cc3:	48 01 c0             	add    rax,rax
  102cc6:	48 01 d0             	add    rax,rdx
  102cc9:	48 c1 e0 03          	shl    rax,0x3
  102ccd:	48 01 c8             	add    rax,rcx
  102cd0:	8b 40 08             	mov    eax,DWORD PTR [rax+0x8]
  102cd3:	ba 02 00 00 00       	mov    edx,0x2
  102cd8:	39 d0                	cmp    eax,edx
  102cda:	77 40                	ja     102d1c <pr_log+0x1f2>
  102cdc:	48 8b 0d 3d e3 01 00 	mov    rcx,QWORD PTR [rip+0x1e33d]        # 121020 <log_entries>
  102ce3:	48 8b 95 38 ff ff ff 	mov    rdx,QWORD PTR [rbp-0xc8]
  102cea:	48 89 d0             	mov    rax,rdx
  102ced:	48 01 c0             	add    rax,rax
  102cf0:	48 01 d0             	add    rax,rdx
  102cf3:	48 c1 e0 03          	shl    rax,0x3
  102cf7:	48 01 c8             	add    rax,rcx
  102cfa:	48 8b 40 10          	mov    rax,QWORD PTR [rax+0x10]
  102cfe:	48 89 c7             	mov    rdi,rax
  102d01:	b8 00 00 00 00       	mov    eax,0x0
  102d06:	e8 c8 14 00 00       	call   1041d3 <printf>
  102d0b:	48 8d 3d 27 3a 00 00 	lea    rdi,[rip+0x3a27]        # 106739 <log_entries_size+0xc1>
  102d12:	b8 00 00 00 00       	mov    eax,0x0
  102d17:	e8 b7 14 00 00       	call   1041d3 <printf>
  102d1c:	48 8b 05 e5 72 02 00 	mov    rax,QWORD PTR [rip+0x272e5]        # 12a008 <n_free_entry>
  102d23:	48 83 c0 01          	add    rax,0x1
  102d27:	48 89 05 da 72 02 00 	mov    QWORD PTR [rip+0x272da],rax        # 12a008 <n_free_entry>
  102d2e:	90                   	nop
  102d2f:	48 81 c4 d8 00 00 00 	add    rsp,0xd8
  102d36:	5b                   	pop    rbx
  102d37:	5d                   	pop    rbp
  102d38:	c3                   	ret    

0000000000102d39 <sc_fnc>:
  102d39:	55                   	push   rbp
  102d3a:	48 89 e5             	mov    rbp,rsp
  102d3d:	48 83 ec 48          	sub    rsp,0x48
  102d41:	89 bd 4c ff ff ff    	mov    DWORD PTR [rbp-0xb4],edi
  102d47:	48 89 b5 58 ff ff ff 	mov    QWORD PTR [rbp-0xa8],rsi
  102d4e:	48 89 95 60 ff ff ff 	mov    QWORD PTR [rbp-0xa0],rdx
  102d55:	48 89 8d 68 ff ff ff 	mov    QWORD PTR [rbp-0x98],rcx
  102d5c:	4c 89 85 70 ff ff ff 	mov    QWORD PTR [rbp-0x90],r8
  102d63:	4c 89 8d 78 ff ff ff 	mov    QWORD PTR [rbp-0x88],r9
  102d6a:	84 c0                	test   al,al
  102d6c:	74 20                	je     102d8e <sc_fnc+0x55>
  102d6e:	0f 29 45 80          	movaps XMMWORD PTR [rbp-0x80],xmm0
  102d72:	0f 29 4d 90          	movaps XMMWORD PTR [rbp-0x70],xmm1
  102d76:	0f 29 55 a0          	movaps XMMWORD PTR [rbp-0x60],xmm2
  102d7a:	0f 29 5d b0          	movaps XMMWORD PTR [rbp-0x50],xmm3
  102d7e:	0f 29 65 c0          	movaps XMMWORD PTR [rbp-0x40],xmm4
  102d82:	0f 29 6d d0          	movaps XMMWORD PTR [rbp-0x30],xmm5
  102d86:	0f 29 75 e0          	movaps XMMWORD PTR [rbp-0x20],xmm6
  102d8a:	0f 29 7d f0          	movaps XMMWORD PTR [rbp-0x10],xmm7
  102d8e:	b8 00 00 00 00       	mov    eax,0x0
  102d93:	c9                   	leave  
  102d94:	c3                   	ret    

0000000000102d95 <syscall_init>:
  102d95:	55                   	push   rbp
  102d96:	48 89 e5             	mov    rbp,rsp
  102d99:	bf 01 00 00 00       	mov    edi,0x1
  102d9e:	e8 ac 01 00 00       	call   102f4f <kmalloc>
  102da3:	48 89 05 7e e2 01 00 	mov    QWORD PTR [rip+0x1e27e],rax        # 121028 <syscall_VT>
  102daa:	48 8d 35 88 ff ff ff 	lea    rsi,[rip+0xffffffffffffff88]        # 102d39 <sc_fnc>
  102db1:	bf 02 00 00 00       	mov    edi,0x2
  102db6:	e8 4f 00 00 00       	call   102e0a <syscall_set>
  102dbb:	b8 00 00 00 00       	mov    eax,0x0
  102dc0:	5d                   	pop    rbp
  102dc1:	c3                   	ret    

0000000000102dc2 <syscall_find_index>:
  102dc2:	55                   	push   rbp
  102dc3:	48 89 e5             	mov    rbp,rsp
  102dc6:	53                   	push   rbx
  102dc7:	89 7d f4             	mov    DWORD PTR [rbp-0xc],edi
  102dca:	bb 00 00 00 00       	mov    ebx,0x0
  102dcf:	eb 21                	jmp    102df2 <syscall_find_index+0x30>
  102dd1:	48 8b 05 50 e2 01 00 	mov    rax,QWORD PTR [rip+0x1e250]        # 121028 <syscall_VT>
  102dd8:	89 da                	mov    edx,ebx
  102dda:	48 c1 e2 03          	shl    rdx,0x3
  102dde:	48 01 d0             	add    rax,rdx
  102de1:	48 8b 00             	mov    rax,QWORD PTR [rax]
  102de4:	8b 00                	mov    eax,DWORD PTR [rax]
  102de6:	39 45 f4             	cmp    DWORD PTR [rbp-0xc],eax
  102de9:	75 04                	jne    102def <syscall_find_index+0x2d>
  102deb:	89 d8                	mov    eax,ebx
  102ded:	eb 18                	jmp    102e07 <syscall_find_index+0x45>
  102def:	83 c3 01             	add    ebx,0x1
  102df2:	89 da                	mov    edx,ebx
  102df4:	48 8b 05 1d 72 02 00 	mov    rax,QWORD PTR [rip+0x2721d]        # 12a018 <syscall_VT_length>
  102dfb:	48 39 c2             	cmp    rdx,rax
  102dfe:	72 d1                	jb     102dd1 <syscall_find_index+0xf>
  102e00:	48 c7 c0 ff ff ff ff 	mov    rax,0xffffffffffffffff
  102e07:	5b                   	pop    rbx
  102e08:	5d                   	pop    rbp
  102e09:	c3                   	ret    

0000000000102e0a <syscall_set>:
  102e0a:	55                   	push   rbp
  102e0b:	48 89 e5             	mov    rbp,rsp
  102e0e:	53                   	push   rbx
  102e0f:	48 83 ec 28          	sub    rsp,0x28
  102e13:	89 7d dc             	mov    DWORD PTR [rbp-0x24],edi
  102e16:	48 89 75 d0          	mov    QWORD PTR [rbp-0x30],rsi
  102e1a:	8b 45 dc             	mov    eax,DWORD PTR [rbp-0x24]
  102e1d:	89 c7                	mov    edi,eax
  102e1f:	e8 9e ff ff ff       	call   102dc2 <syscall_find_index>
  102e24:	48 89 45 e8          	mov    QWORD PTR [rbp-0x18],rax
  102e28:	48 83 7d e8 ff       	cmp    QWORD PTR [rbp-0x18],0xffffffffffffffff
  102e2d:	0f 85 ae 00 00 00    	jne    102ee1 <syscall_set+0xd7>
  102e33:	48 8b 05 de 71 02 00 	mov    rax,QWORD PTR [rip+0x271de]        # 12a018 <syscall_VT_length>
  102e3a:	48 83 c0 01          	add    rax,0x1
  102e3e:	48 c1 e0 03          	shl    rax,0x3
  102e42:	48 89 c7             	mov    rdi,rax
  102e45:	e8 05 01 00 00       	call   102f4f <kmalloc>
  102e4a:	48 89 c3             	mov    rbx,rax
  102e4d:	48 8b 05 c4 71 02 00 	mov    rax,QWORD PTR [rip+0x271c4]        # 12a018 <syscall_VT_length>
  102e54:	48 8d 14 c5 00 00 00 	lea    rdx,[rax*8+0x0]
  102e5b:	00 
  102e5c:	48 8b 05 c5 e1 01 00 	mov    rax,QWORD PTR [rip+0x1e1c5]        # 121028 <syscall_VT>
  102e63:	48 89 c6             	mov    rsi,rax
  102e66:	48 89 df             	mov    rdi,rbx
  102e69:	e8 fb 16 00 00       	call   104569 <memcpy>
  102e6e:	48 8b 05 b3 e1 01 00 	mov    rax,QWORD PTR [rip+0x1e1b3]        # 121028 <syscall_VT>
  102e75:	48 89 c7             	mov    rdi,rax
  102e78:	e8 fe 00 00 00       	call   102f7b <kfree>
  102e7d:	48 89 1d a4 e1 01 00 	mov    QWORD PTR [rip+0x1e1a4],rbx        # 121028 <syscall_VT>
  102e84:	48 8b 05 9d e1 01 00 	mov    rax,QWORD PTR [rip+0x1e19d]        # 121028 <syscall_VT>
  102e8b:	48 8b 15 86 71 02 00 	mov    rdx,QWORD PTR [rip+0x27186]        # 12a018 <syscall_VT_length>
  102e92:	48 c1 e2 03          	shl    rdx,0x3
  102e96:	48 8d 1c 10          	lea    rbx,[rax+rdx*1]
  102e9a:	bf 10 00 00 00       	mov    edi,0x10
  102e9f:	e8 ab 00 00 00       	call   102f4f <kmalloc>
  102ea4:	48 89 03             	mov    QWORD PTR [rbx],rax
  102ea7:	48 8b 05 7a e1 01 00 	mov    rax,QWORD PTR [rip+0x1e17a]        # 121028 <syscall_VT>
  102eae:	48 8b 15 63 71 02 00 	mov    rdx,QWORD PTR [rip+0x27163]        # 12a018 <syscall_VT_length>
  102eb5:	48 c1 e2 03          	shl    rdx,0x3
  102eb9:	48 01 d0             	add    rax,rdx
  102ebc:	48 8b 00             	mov    rax,QWORD PTR [rax]
  102ebf:	8b 55 dc             	mov    edx,DWORD PTR [rbp-0x24]
  102ec2:	89 10                	mov    DWORD PTR [rax],edx
  102ec4:	48 8b 05 4d 71 02 00 	mov    rax,QWORD PTR [rip+0x2714d]        # 12a018 <syscall_VT_length>
  102ecb:	48 89 45 e8          	mov    QWORD PTR [rbp-0x18],rax
  102ecf:	48 8b 05 42 71 02 00 	mov    rax,QWORD PTR [rip+0x27142]        # 12a018 <syscall_VT_length>
  102ed6:	48 83 c0 01          	add    rax,0x1
  102eda:	48 89 05 37 71 02 00 	mov    QWORD PTR [rip+0x27137],rax        # 12a018 <syscall_VT_length>
  102ee1:	48 8b 05 40 e1 01 00 	mov    rax,QWORD PTR [rip+0x1e140]        # 121028 <syscall_VT>
  102ee8:	48 8b 55 e8          	mov    rdx,QWORD PTR [rbp-0x18]
  102eec:	48 c1 e2 03          	shl    rdx,0x3
  102ef0:	48 01 d0             	add    rax,rdx
  102ef3:	48 8b 00             	mov    rax,QWORD PTR [rax]
  102ef6:	48 8b 55 d0          	mov    rdx,QWORD PTR [rbp-0x30]
  102efa:	48 89 50 08          	mov    QWORD PTR [rax+0x8],rdx
  102efe:	b8 00 00 00 00       	mov    eax,0x0
  102f03:	48 83 c4 28          	add    rsp,0x28
  102f07:	5b                   	pop    rbx
  102f08:	5d                   	pop    rbp
  102f09:	c3                   	ret    

0000000000102f0a <syscall_resolve_function>:
  102f0a:	55                   	push   rbp
  102f0b:	48 89 e5             	mov    rbp,rsp
  102f0e:	89 7d fc             	mov    DWORD PTR [rbp-0x4],edi
  102f11:	b8 00 00 00 00       	mov    eax,0x0
  102f16:	5d                   	pop    rbp
  102f17:	c3                   	ret    

0000000000102f18 <syscall_c>:
  102f18:	55                   	push   rbp
  102f19:	48 89 e5             	mov    rbp,rsp
  102f1c:	48 8d 3d 19 38 00 00 	lea    rdi,[rip+0x3819]        # 10673c <syscall_int+0x1>
  102f23:	b8 00 00 00 00       	mov    eax,0x0
  102f28:	e8 a6 12 00 00       	call   1041d3 <printf>
  102f2d:	90                   	nop
  102f2e:	5d                   	pop    rbp
  102f2f:	c3                   	ret    

0000000000102f30 <mm_init>:
  102f30:	55                   	push   rbp
  102f31:	48 89 e5             	mov    rbp,rsp
  102f34:	b8 00 00 00 00       	mov    eax,0x0
  102f39:	e8 c8 02 00 00       	call   103206 <vpage_init>
  102f3e:	b8 00 00 00 00       	mov    eax,0x0
  102f43:	e8 e5 00 00 00       	call   10302d <ppage_init>
  102f48:	b8 00 00 00 00       	mov    eax,0x0
  102f4d:	5d                   	pop    rbp
  102f4e:	c3                   	ret    

0000000000102f4f <kmalloc>:
  102f4f:	55                   	push   rbp
  102f50:	48 89 e5             	mov    rbp,rsp
  102f53:	48 83 ec 10          	sub    rsp,0x10
  102f57:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
  102f5b:	0f b6 05 0f e1 01 00 	movzx  eax,BYTE PTR [rip+0x1e10f]        # 121071 <System+0x31>
  102f62:	84 c0                	test   al,al
  102f64:	75 0e                	jne    102f74 <kmalloc+0x25>
  102f66:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  102f6a:	48 89 c7             	mov    rdi,rax
  102f6d:	e8 10 02 00 00       	call   103182 <memstck_malloc>
  102f72:	eb 05                	jmp    102f79 <kmalloc+0x2a>
  102f74:	b8 00 00 00 00       	mov    eax,0x0
  102f79:	c9                   	leave  
  102f7a:	c3                   	ret    

0000000000102f7b <kfree>:
  102f7b:	55                   	push   rbp
  102f7c:	48 89 e5             	mov    rbp,rsp
  102f7f:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
  102f83:	0f b6 05 e7 e0 01 00 	movzx  eax,BYTE PTR [rip+0x1e0e7]        # 121071 <System+0x31>
  102f8a:	84 c0                	test   al,al
  102f8c:	90                   	nop
  102f8d:	5d                   	pop    rbp
  102f8e:	c3                   	ret    

0000000000102f8f <findNextRegion>:
  102f8f:	55                   	push   rbp
  102f90:	48 89 e5             	mov    rbp,rsp
  102f93:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
  102f97:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  102f9b:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  102f9f:	eb 4b                	jmp    102fec <findNextRegion+0x5d>
  102fa1:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  102fa5:	0f b6 40 10          	movzx  eax,BYTE PTR [rax+0x10]
  102fa9:	0f b6 c0             	movzx  eax,al
  102fac:	83 e0 43             	and    eax,0x43
  102faf:	83 f8 43             	cmp    eax,0x43
  102fb2:	75 2c                	jne    102fe0 <findNextRegion+0x51>
  102fb4:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  102fb8:	0f b6 40 10          	movzx  eax,BYTE PTR [rax+0x10]
  102fbc:	0f b6 c0             	movzx  eax,al
  102fbf:	83 e0 34             	and    eax,0x34
  102fc2:	85 c0                	test   eax,eax
  102fc4:	75 1a                	jne    102fe0 <findNextRegion+0x51>
  102fc6:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  102fca:	48 8b 50 08          	mov    rdx,QWORD PTR [rax+0x8]
  102fce:	48 8b 05 2b 32 00 00 	mov    rax,QWORD PTR [rip+0x322b]        # 106200 <page_size>
  102fd5:	48 39 c2             	cmp    rdx,rax
  102fd8:	72 06                	jb     102fe0 <findNextRegion+0x51>
  102fda:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  102fde:	eb 18                	jmp    102ff8 <findNextRegion+0x69>
  102fe0:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  102fe4:	48 8b 40 28          	mov    rax,QWORD PTR [rax+0x28]
  102fe8:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  102fec:	48 83 7d f8 00       	cmp    QWORD PTR [rbp-0x8],0x0
  102ff1:	75 ae                	jne    102fa1 <findNextRegion+0x12>
  102ff3:	b8 00 00 00 00       	mov    eax,0x0
  102ff8:	5d                   	pop    rbp
  102ff9:	c3                   	ret    

0000000000102ffa <regions_map>:
  102ffa:	55                   	push   rbp
  102ffb:	48 89 e5             	mov    rbp,rsp
  102ffe:	48 8b 05 83 e0 01 00 	mov    rax,QWORD PTR [rip+0x1e083]        # 121088 <regions>
  103005:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  103009:	eb 17                	jmp    103022 <regions_map+0x28>
  10300b:	48 8b 05 66 e0 01 00 	mov    rax,QWORD PTR [rip+0x1e066]        # 121078 <alloc_region>
  103012:	48 39 45 f8          	cmp    QWORD PTR [rbp-0x8],rax
  103016:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10301a:	48 8b 40 28          	mov    rax,QWORD PTR [rax+0x28]
  10301e:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  103022:	48 83 7d f8 00       	cmp    QWORD PTR [rbp-0x8],0x0
  103027:	75 e2                	jne    10300b <regions_map+0x11>
  103029:	90                   	nop
  10302a:	90                   	nop
  10302b:	5d                   	pop    rbp
  10302c:	c3                   	ret    

000000000010302d <ppage_init>:
  10302d:	55                   	push   rbp
  10302e:	48 89 e5             	mov    rbp,rsp
  103031:	48 83 ec 30          	sub    rsp,0x30
  103035:	b8 00 00 00 00       	mov    eax,0x0
  10303a:	e8 ae dd ff ff       	call   100ded <get_regions>
  10303f:	48 89 c7             	mov    rdi,rax
  103042:	e8 48 ff ff ff       	call   102f8f <findNextRegion>
  103047:	48 89 05 3a e0 01 00 	mov    QWORD PTR [rip+0x1e03a],rax        # 121088 <regions>
  10304e:	48 8b 05 33 e0 01 00 	mov    rax,QWORD PTR [rip+0x1e033]        # 121088 <regions>
  103055:	48 89 05 1c e0 01 00 	mov    QWORD PTR [rip+0x1e01c],rax        # 121078 <alloc_region>
  10305c:	48 8b 05 15 e0 01 00 	mov    rax,QWORD PTR [rip+0x1e015]        # 121078 <alloc_region>
  103063:	48 85 c0             	test   rax,rax
  103066:	75 0c                	jne    103074 <ppage_init+0x47>
  103068:	48 8d 3d d9 36 00 00 	lea    rdi,[rip+0x36d9]        # 106748 <syscall_int+0xd>
  10306f:	e8 4c f9 ff ff       	call   1029c0 <panic>
  103074:	48 8b 05 fd df 01 00 	mov    rax,QWORD PTR [rip+0x1dffd]        # 121078 <alloc_region>
  10307b:	48 8b 48 08          	mov    rcx,QWORD PTR [rax+0x8]
  10307f:	48 8b 05 e2 df 01 00 	mov    rax,QWORD PTR [rip+0x1dfe2]        # 121068 <System+0x28>
  103086:	48 8b 35 73 31 00 00 	mov    rsi,QWORD PTR [rip+0x3173]        # 106200 <page_size>
  10308d:	ba 00 00 00 00       	mov    edx,0x0
  103092:	48 f7 f6             	div    rsi
  103095:	48 89 c2             	mov    rdx,rax
  103098:	48 8b 05 09 37 00 00 	mov    rax,QWORD PTR [rip+0x3709]        # 1067a8 <bits_per_page>
  10309f:	48 0f af c2          	imul   rax,rdx
  1030a3:	48 c1 e8 03          	shr    rax,0x3
  1030a7:	48 39 c1             	cmp    rcx,rax
  1030aa:	72 12                	jb     1030be <ppage_init+0x91>
  1030ac:	48 8b 05 c5 df 01 00 	mov    rax,QWORD PTR [rip+0x1dfc5]        # 121078 <alloc_region>
  1030b3:	48 8b 00             	mov    rax,QWORD PTR [rax]
  1030b6:	48 3d ff ff 0f 00    	cmp    rax,0xfffff
  1030bc:	77 1c                	ja     1030da <ppage_init+0xad>
  1030be:	48 8b 05 b3 df 01 00 	mov    rax,QWORD PTR [rip+0x1dfb3]        # 121078 <alloc_region>
  1030c5:	48 8b 40 28          	mov    rax,QWORD PTR [rax+0x28]
  1030c9:	48 89 c7             	mov    rdi,rax
  1030cc:	e8 be fe ff ff       	call   102f8f <findNextRegion>
  1030d1:	48 89 05 a0 df 01 00 	mov    QWORD PTR [rip+0x1dfa0],rax        # 121078 <alloc_region>
  1030d8:	eb 82                	jmp    10305c <ppage_init+0x2f>
  1030da:	48 8b 05 97 df 01 00 	mov    rax,QWORD PTR [rip+0x1df97]        # 121078 <alloc_region>
  1030e1:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
  1030e5:	48 8b 0d 14 31 00 00 	mov    rcx,QWORD PTR [rip+0x3114]        # 106200 <page_size>
  1030ec:	ba 00 00 00 00       	mov    edx,0x0
  1030f1:	48 f7 f1             	div    rcx
  1030f4:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  1030f8:	48 8b 05 a9 36 00 00 	mov    rax,QWORD PTR [rip+0x36a9]        # 1067a8 <bits_per_page>
  1030ff:	48 0f af 45 f8       	imul   rax,QWORD PTR [rbp-0x8]
  103104:	48 83 c0 07          	add    rax,0x7
  103108:	48 c1 e8 03          	shr    rax,0x3
  10310c:	48 89 45 f0          	mov    QWORD PTR [rbp-0x10],rax
  103110:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  103114:	48 89 c7             	mov    rdi,rax
  103117:	e8 66 00 00 00       	call   103182 <memstck_malloc>
  10311c:	48 89 45 e8          	mov    QWORD PTR [rbp-0x18],rax
  103120:	48 8b 05 79 36 00 00 	mov    rax,QWORD PTR [rip+0x3679]        # 1067a0 <mm_sb_size>
  103127:	48 89 c7             	mov    rdi,rax
  10312a:	e8 53 00 00 00       	call   103182 <memstck_malloc>
  10312f:	48 89 45 e0          	mov    QWORD PTR [rbp-0x20],rax
  103133:	48 83 7d e8 00       	cmp    QWORD PTR [rbp-0x18],0x0
  103138:	74 07                	je     103141 <ppage_init+0x114>
  10313a:	48 83 7d e0 00       	cmp    QWORD PTR [rbp-0x20],0x0
  10313f:	75 0c                	jne    10314d <ppage_init+0x120>
  103141:	48 8d 3d 38 36 00 00 	lea    rdi,[rip+0x3638]        # 106780 <syscall_int+0x45>
  103148:	e8 73 f8 ff ff       	call   1029c0 <panic>
  10314d:	48 8b 05 24 df 01 00 	mov    rax,QWORD PTR [rip+0x1df24]        # 121078 <alloc_region>
  103154:	48 8b 4d e8          	mov    rcx,QWORD PTR [rbp-0x18]
  103158:	48 8b 55 e0          	mov    rdx,QWORD PTR [rbp-0x20]
  10315c:	48 8b 75 f8          	mov    rsi,QWORD PTR [rbp-0x8]
  103160:	48 89 c7             	mov    rdi,rax
  103163:	e8 97 04 00 00       	call   1035ff <region_map>
  103168:	48 8b 05 09 df 01 00 	mov    rax,QWORD PTR [rip+0x1df09]        # 121078 <alloc_region>
  10316f:	48 89 c7             	mov    rdi,rax
  103172:	e8 74 0b 00 00       	call   103ceb <page_alloc>
  103177:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
  10317b:	b8 00 00 00 00       	mov    eax,0x0
  103180:	c9                   	leave  
  103181:	c3                   	ret    

0000000000103182 <memstck_malloc>:
  103182:	55                   	push   rbp
  103183:	48 89 e5             	mov    rbp,rsp
  103186:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
  10318a:	0f b6 05 88 4e 00 00 	movzx  eax,BYTE PTR [rip+0x4e88]        # 108019 <MemStack_enable>
  103191:	84 c0                	test   al,al
  103193:	75 07                	jne    10319c <memstck_malloc+0x1a>
  103195:	b8 00 00 00 00       	mov    eax,0x0
  10319a:	eb 5a                	jmp    1031f6 <memstck_malloc+0x74>
  10319c:	0f b6 05 7d 6e 02 00 	movzx  eax,BYTE PTR [rip+0x26e7d]        # 12a020 <MemStack_init>
  1031a3:	84 c0                	test   al,al
  1031a5:	75 19                	jne    1031c0 <memstck_malloc+0x3e>
  1031a7:	48 8b 05 8a 4e 00 00 	mov    rax,QWORD PTR [rip+0x4e8a]        # 108038 <_MemEnd>
  1031ae:	48 83 c0 40          	add    rax,0x40
  1031b2:	48 89 05 c7 de 01 00 	mov    QWORD PTR [rip+0x1dec7],rax        # 121080 <MemStack>
  1031b9:	c6 05 60 6e 02 00 01 	mov    BYTE PTR [rip+0x26e60],0x1        # 12a020 <MemStack_init>
  1031c0:	48 8b 05 b9 de 01 00 	mov    rax,QWORD PTR [rip+0x1deb9]        # 121080 <MemStack>
  1031c7:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  1031cb:	48 8b 15 ae de 01 00 	mov    rdx,QWORD PTR [rip+0x1deae]        # 121080 <MemStack>
  1031d2:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  1031d6:	48 01 d0             	add    rax,rdx
  1031d9:	48 83 c0 01          	add    rax,0x1
  1031dd:	48 89 05 9c de 01 00 	mov    QWORD PTR [rip+0x1de9c],rax        # 121080 <MemStack>
  1031e4:	48 8b 55 f8          	mov    rdx,QWORD PTR [rbp-0x8]
  1031e8:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  1031ec:	48 01 d0             	add    rax,rdx
  1031ef:	c6 00 00             	mov    BYTE PTR [rax],0x0
  1031f2:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1031f6:	5d                   	pop    rbp
  1031f7:	c3                   	ret    

00000000001031f8 <memstck_disable>:
  1031f8:	55                   	push   rbp
  1031f9:	48 89 e5             	mov    rbp,rsp
  1031fc:	c6 05 16 4e 00 00 00 	mov    BYTE PTR [rip+0x4e16],0x0        # 108019 <MemStack_enable>
  103203:	90                   	nop
  103204:	5d                   	pop    rbp
  103205:	c3                   	ret    

0000000000103206 <vpage_init>:
  103206:	55                   	push   rbp
  103207:	48 89 e5             	mov    rbp,rsp
  10320a:	b8 00 00 00 00       	mov    eax,0x0
  10320f:	e8 3b db ff ff       	call   100d4f <pga_init>
  103214:	b8 00 00 00 00       	mov    eax,0x0
  103219:	e8 77 d7 ff ff       	call   100995 <mem_v_alloc>
  10321e:	b8 00 00 00 00       	mov    eax,0x0
  103223:	5d                   	pop    rbp
  103224:	c3                   	ret    

0000000000103225 <block_set>:
  103225:	55                   	push   rbp
  103226:	48 89 e5             	mov    rbp,rsp
  103229:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
  10322d:	89 75 e4             	mov    DWORD PTR [rbp-0x1c],esi
  103230:	48 89 55 d8          	mov    QWORD PTR [rbp-0x28],rdx
  103234:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103238:	48 8b 40 18          	mov    rax,QWORD PTR [rax+0x18]
  10323c:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  103240:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103244:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  103247:	48 83 c2 02          	add    rdx,0x2
  10324b:	48 8b 14 d0          	mov    rdx,QWORD PTR [rax+rdx*8]
  10324f:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  103253:	48 c1 e8 03          	shr    rax,0x3
  103257:	48 01 c2             	add    rdx,rax
  10325a:	0f b6 32             	movzx  esi,BYTE PTR [rdx]
  10325d:	48 8b 55 d8          	mov    rdx,QWORD PTR [rbp-0x28]
  103261:	83 e2 07             	and    edx,0x7
  103264:	bf 01 00 00 00       	mov    edi,0x1
  103269:	89 d1                	mov    ecx,edx
  10326b:	d3 e7                	shl    edi,cl
  10326d:	89 fa                	mov    edx,edi
  10326f:	89 d7                	mov    edi,edx
  103271:	48 8b 55 f8          	mov    rdx,QWORD PTR [rbp-0x8]
  103275:	8b 4d e4             	mov    ecx,DWORD PTR [rbp-0x1c]
  103278:	48 83 c1 02          	add    rcx,0x2
  10327c:	48 8b 14 ca          	mov    rdx,QWORD PTR [rdx+rcx*8]
  103280:	48 01 d0             	add    rax,rdx
  103283:	09 fe                	or     esi,edi
  103285:	89 f2                	mov    edx,esi
  103287:	88 10                	mov    BYTE PTR [rax],dl
  103289:	90                   	nop
  10328a:	5d                   	pop    rbp
  10328b:	c3                   	ret    

000000000010328c <block_clear>:
  10328c:	55                   	push   rbp
  10328d:	48 89 e5             	mov    rbp,rsp
  103290:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
  103294:	89 75 e4             	mov    DWORD PTR [rbp-0x1c],esi
  103297:	48 89 55 d8          	mov    QWORD PTR [rbp-0x28],rdx
  10329b:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  10329f:	48 8b 40 18          	mov    rax,QWORD PTR [rax+0x18]
  1032a3:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  1032a7:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1032ab:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  1032ae:	48 83 c2 02          	add    rdx,0x2
  1032b2:	48 8b 14 d0          	mov    rdx,QWORD PTR [rax+rdx*8]
  1032b6:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1032ba:	48 c1 e8 03          	shr    rax,0x3
  1032be:	48 01 c2             	add    rdx,rax
  1032c1:	0f b6 32             	movzx  esi,BYTE PTR [rdx]
  1032c4:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  1032c7:	83 e2 07             	and    edx,0x7
  1032ca:	bf 01 00 00 00       	mov    edi,0x1
  1032cf:	89 d1                	mov    ecx,edx
  1032d1:	d3 e7                	shl    edi,cl
  1032d3:	89 fa                	mov    edx,edi
  1032d5:	89 d7                	mov    edi,edx
  1032d7:	f7 d7                	not    edi
  1032d9:	48 8b 55 f8          	mov    rdx,QWORD PTR [rbp-0x8]
  1032dd:	8b 4d e4             	mov    ecx,DWORD PTR [rbp-0x1c]
  1032e0:	48 83 c1 02          	add    rcx,0x2
  1032e4:	48 8b 14 ca          	mov    rdx,QWORD PTR [rdx+rcx*8]
  1032e8:	48 01 d0             	add    rax,rdx
  1032eb:	21 fe                	and    esi,edi
  1032ed:	89 f2                	mov    edx,esi
  1032ef:	88 10                	mov    BYTE PTR [rax],dl
  1032f1:	90                   	nop
  1032f2:	5d                   	pop    rbp
  1032f3:	c3                   	ret    

00000000001032f4 <block_check>:
  1032f4:	55                   	push   rbp
  1032f5:	48 89 e5             	mov    rbp,rsp
  1032f8:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
  1032fc:	89 75 e4             	mov    DWORD PTR [rbp-0x1c],esi
  1032ff:	48 89 55 d8          	mov    QWORD PTR [rbp-0x28],rdx
  103303:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103307:	48 8b 40 18          	mov    rax,QWORD PTR [rax+0x18]
  10330b:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  10330f:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103313:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  103316:	48 83 c2 02          	add    rdx,0x2
  10331a:	48 8b 04 d0          	mov    rax,QWORD PTR [rax+rdx*8]
  10331e:	48 8b 55 d8          	mov    rdx,QWORD PTR [rbp-0x28]
  103322:	48 c1 ea 03          	shr    rdx,0x3
  103326:	48 01 d0             	add    rax,rdx
  103329:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  10332c:	0f be d0             	movsx  edx,al
  10332f:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  103333:	83 e0 07             	and    eax,0x7
  103336:	89 c1                	mov    ecx,eax
  103338:	d3 fa                	sar    edx,cl
  10333a:	89 d0                	mov    eax,edx
  10333c:	83 e0 01             	and    eax,0x1
  10333f:	5d                   	pop    rbp
  103340:	c3                   	ret    

0000000000103341 <blocks_set>:
  103341:	55                   	push   rbp
  103342:	48 89 e5             	mov    rbp,rsp
  103345:	48 83 ec 30          	sub    rsp,0x30
  103349:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
  10334d:	89 75 e4             	mov    DWORD PTR [rbp-0x1c],esi
  103350:	48 89 55 d8          	mov    QWORD PTR [rbp-0x28],rdx
  103354:	48 89 4d d0          	mov    QWORD PTR [rbp-0x30],rcx
  103358:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  10335c:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  103360:	eb 1a                	jmp    10337c <blocks_set+0x3b>
  103362:	48 8b 55 f8          	mov    rdx,QWORD PTR [rbp-0x8]
  103366:	8b 4d e4             	mov    ecx,DWORD PTR [rbp-0x1c]
  103369:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  10336d:	89 ce                	mov    esi,ecx
  10336f:	48 89 c7             	mov    rdi,rax
  103372:	e8 ae fe ff ff       	call   103225 <block_set>
  103377:	48 83 45 f8 01       	add    QWORD PTR [rbp-0x8],0x1
  10337c:	48 8b 55 d8          	mov    rdx,QWORD PTR [rbp-0x28]
  103380:	48 8b 45 d0          	mov    rax,QWORD PTR [rbp-0x30]
  103384:	48 01 d0             	add    rax,rdx
  103387:	48 39 45 f8          	cmp    QWORD PTR [rbp-0x8],rax
  10338b:	72 d5                	jb     103362 <blocks_set+0x21>
  10338d:	90                   	nop
  10338e:	90                   	nop
  10338f:	c9                   	leave  
  103390:	c3                   	ret    

0000000000103391 <free_area_length>:
  103391:	55                   	push   rbp
  103392:	48 89 e5             	mov    rbp,rsp
  103395:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
  103399:	89 75 e4             	mov    DWORD PTR [rbp-0x1c],esi
  10339c:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  1033a0:	48 8b 40 18          	mov    rax,QWORD PTR [rax+0x18]
  1033a4:	48 8b 00             	mov    rax,QWORD PTR [rax]
  1033a7:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  1033ab:	c7 45 f4 00 00 00 00 	mov    DWORD PTR [rbp-0xc],0x0
  1033b2:	eb 13                	jmp    1033c7 <free_area_length+0x36>
  1033b4:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1033b8:	48 83 c0 01          	add    rax,0x1
  1033bc:	48 d1 e8             	shr    rax,1
  1033bf:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  1033c3:	83 45 f4 01          	add    DWORD PTR [rbp-0xc],0x1
  1033c7:	8b 45 f4             	mov    eax,DWORD PTR [rbp-0xc]
  1033ca:	3b 45 e4             	cmp    eax,DWORD PTR [rbp-0x1c]
  1033cd:	72 e5                	jb     1033b4 <free_area_length+0x23>
  1033cf:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1033d3:	5d                   	pop    rbp
  1033d4:	c3                   	ret    

00000000001033d5 <order_max>:
  1033d5:	55                   	push   rbp
  1033d6:	48 89 e5             	mov    rbp,rsp
  1033d9:	48 83 ec 18          	sub    rsp,0x18
  1033dd:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
  1033e1:	48 c7 45 f8 09 00 00 	mov    QWORD PTR [rbp-0x8],0x9
  1033e8:	00 
  1033e9:	eb 24                	jmp    10340f <order_max+0x3a>
  1033eb:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1033ef:	89 c2                	mov    edx,eax
  1033f1:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  1033f5:	89 d6                	mov    esi,edx
  1033f7:	48 89 c7             	mov    rdi,rax
  1033fa:	e8 92 ff ff ff       	call   103391 <free_area_length>
  1033ff:	48 85 c0             	test   rax,rax
  103402:	74 06                	je     10340a <order_max+0x35>
  103404:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103408:	eb 11                	jmp    10341b <order_max+0x46>
  10340a:	48 83 6d f8 01       	sub    QWORD PTR [rbp-0x8],0x1
  10340f:	48 83 7d f8 00       	cmp    QWORD PTR [rbp-0x8],0x0
  103414:	79 d5                	jns    1033eb <order_max+0x16>
  103416:	b8 00 00 00 00       	mov    eax,0x0
  10341b:	c9                   	leave  
  10341c:	c3                   	ret    

000000000010341d <find_next_free_page>:
  10341d:	55                   	push   rbp
  10341e:	48 89 e5             	mov    rbp,rsp
  103421:	48 83 ec 28          	sub    rsp,0x28
  103425:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
  103429:	89 75 e4             	mov    DWORD PTR [rbp-0x1c],esi
  10342c:	48 89 55 d8          	mov    QWORD PTR [rbp-0x28],rdx
  103430:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  103434:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  103438:	eb 24                	jmp    10345e <find_next_free_page+0x41>
  10343a:	48 8b 55 f8          	mov    rdx,QWORD PTR [rbp-0x8]
  10343e:	8b 4d e4             	mov    ecx,DWORD PTR [rbp-0x1c]
  103441:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103445:	89 ce                	mov    esi,ecx
  103447:	48 89 c7             	mov    rdi,rax
  10344a:	e8 a5 fe ff ff       	call   1032f4 <block_check>
  10344f:	84 c0                	test   al,al
  103451:	75 06                	jne    103459 <find_next_free_page+0x3c>
  103453:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103457:	eb 40                	jmp    103499 <find_next_free_page+0x7c>
  103459:	48 83 45 f8 01       	add    QWORD PTR [rbp-0x8],0x1
  10345e:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  103461:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103465:	89 d6                	mov    esi,edx
  103467:	48 89 c7             	mov    rdi,rax
  10346a:	e8 22 ff ff ff       	call   103391 <free_area_length>
  10346f:	48 39 45 f8          	cmp    QWORD PTR [rbp-0x8],rax
  103473:	72 c5                	jb     10343a <find_next_free_page+0x1d>
  103475:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103479:	48 8b 40 18          	mov    rax,QWORD PTR [rax+0x18]
  10347d:	48 89 45 f0          	mov    QWORD PTR [rbp-0x10],rax
  103481:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  103485:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  103488:	48 83 c2 0c          	add    rdx,0xc
  10348c:	48 c7 04 d0 00 00 00 	mov    QWORD PTR [rax+rdx*8],0x0
  103493:	00 
  103494:	b8 00 00 00 00       	mov    eax,0x0
  103499:	c9                   	leave  
  10349a:	c3                   	ret    

000000000010349b <_free_area_map>:
  10349b:	55                   	push   rbp
  10349c:	48 89 e5             	mov    rbp,rsp
  10349f:	48 83 ec 28          	sub    rsp,0x28
  1034a3:	48 89 7d d8          	mov    QWORD PTR [rbp-0x28],rdi
  1034a7:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1034ab:	48 8b 00             	mov    rax,QWORD PTR [rax]
  1034ae:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  1034b2:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1034b6:	48 89 c7             	mov    rdi,rax
  1034b9:	e8 17 ff ff ff       	call   1033d5 <order_max>
  1034be:	89 45 e4             	mov    DWORD PTR [rbp-0x1c],eax
  1034c1:	48 c7 45 f0 00 00 00 	mov    QWORD PTR [rbp-0x10],0x0
  1034c8:	00 
  1034c9:	e9 c9 00 00 00       	jmp    103597 <_free_area_map+0xfc>
  1034ce:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1034d2:	48 8b 10             	mov    rdx,QWORD PTR [rax]
  1034d5:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1034d9:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
  1034dd:	48 01 d0             	add    rax,rdx
  1034e0:	48 39 45 f8          	cmp    QWORD PTR [rbp-0x8],rax
  1034e4:	73 3a                	jae    103520 <_free_area_map+0x85>
  1034e6:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1034ea:	48 8b 10             	mov    rdx,QWORD PTR [rax]
  1034ed:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1034f1:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
  1034f5:	48 01 d0             	add    rax,rdx
  1034f8:	48 2b 45 f8          	sub    rax,QWORD PTR [rbp-0x8]
  1034fc:	48 89 c2             	mov    rdx,rax
  1034ff:	8b 45 e4             	mov    eax,DWORD PTR [rbp-0x1c]
  103502:	be 01 00 00 00       	mov    esi,0x1
  103507:	89 c1                	mov    ecx,eax
  103509:	d3 e6                	shl    esi,cl
  10350b:	89 f0                	mov    eax,esi
  10350d:	48 63 c8             	movsxd rcx,eax
  103510:	48 8b 05 e9 2c 00 00 	mov    rax,QWORD PTR [rip+0x2ce9]        # 106200 <page_size>
  103517:	48 0f af c1          	imul   rax,rcx
  10351b:	48 39 c2             	cmp    rdx,rax
  10351e:	73 30                	jae    103550 <_free_area_map+0xb5>
  103520:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  103523:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  103527:	89 d6                	mov    esi,edx
  103529:	48 89 c7             	mov    rdi,rax
  10352c:	e8 60 fe ff ff       	call   103391 <free_area_length>
  103531:	48 2b 45 f0          	sub    rax,QWORD PTR [rbp-0x10]
  103535:	48 89 c1             	mov    rcx,rax
  103538:	48 8b 55 f0          	mov    rdx,QWORD PTR [rbp-0x10]
  10353c:	8b 75 e4             	mov    esi,DWORD PTR [rbp-0x1c]
  10353f:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  103543:	48 89 c7             	mov    rdi,rax
  103546:	e8 f6 fd ff ff       	call   103341 <blocks_set>
  10354b:	e9 ad 00 00 00       	jmp    1035fd <_free_area_map+0x162>
  103550:	8b 45 e4             	mov    eax,DWORD PTR [rbp-0x1c]
  103553:	ba 01 00 00 00       	mov    edx,0x1
  103558:	89 c1                	mov    ecx,eax
  10355a:	d3 e2                	shl    edx,cl
  10355c:	89 d0                	mov    eax,edx
  10355e:	48 63 d0             	movsxd rdx,eax
  103561:	48 8b 05 98 2c 00 00 	mov    rax,QWORD PTR [rip+0x2c98]        # 106200 <page_size>
  103568:	48 0f af c2          	imul   rax,rdx
  10356c:	48 01 45 f8          	add    QWORD PTR [rbp-0x8],rax
  103570:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  103574:	48 8b 40 18          	mov    rax,QWORD PTR [rax+0x18]
  103578:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  10357b:	48 83 c2 0c          	add    rdx,0xc
  10357f:	48 8b 14 d0          	mov    rdx,QWORD PTR [rax+rdx*8]
  103583:	48 8d 4a 01          	lea    rcx,[rdx+0x1]
  103587:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  10358a:	48 83 c2 0c          	add    rdx,0xc
  10358e:	48 89 0c d0          	mov    QWORD PTR [rax+rdx*8],rcx
  103592:	48 83 45 f0 01       	add    QWORD PTR [rbp-0x10],0x1
  103597:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  10359a:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  10359e:	89 d6                	mov    esi,edx
  1035a0:	48 89 c7             	mov    rdi,rax
  1035a3:	e8 e9 fd ff ff       	call   103391 <free_area_length>
  1035a8:	48 39 45 f0          	cmp    QWORD PTR [rbp-0x10],rax
  1035ac:	0f 82 1c ff ff ff    	jb     1034ce <_free_area_map+0x33>
  1035b2:	8b 45 e4             	mov    eax,DWORD PTR [rbp-0x1c]
  1035b5:	83 e8 01             	sub    eax,0x1
  1035b8:	89 c0                	mov    eax,eax
  1035ba:	48 89 45 e8          	mov    QWORD PTR [rbp-0x18],rax
  1035be:	eb 36                	jmp    1035f6 <_free_area_map+0x15b>
  1035c0:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  1035c4:	89 c2                	mov    edx,eax
  1035c6:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1035ca:	89 d6                	mov    esi,edx
  1035cc:	48 89 c7             	mov    rdi,rax
  1035cf:	e8 bd fd ff ff       	call   103391 <free_area_length>
  1035d4:	48 89 c2             	mov    rdx,rax
  1035d7:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  1035db:	89 c6                	mov    esi,eax
  1035dd:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1035e1:	48 89 d1             	mov    rcx,rdx
  1035e4:	ba 00 00 00 00       	mov    edx,0x0
  1035e9:	48 89 c7             	mov    rdi,rax
  1035ec:	e8 50 fd ff ff       	call   103341 <blocks_set>
  1035f1:	48 83 6d e8 01       	sub    QWORD PTR [rbp-0x18],0x1
  1035f6:	48 83 7d e8 00       	cmp    QWORD PTR [rbp-0x18],0x0
  1035fb:	79 c3                	jns    1035c0 <_free_area_map+0x125>
  1035fd:	c9                   	leave  
  1035fe:	c3                   	ret    

00000000001035ff <region_map>:
  1035ff:	55                   	push   rbp
  103600:	48 89 e5             	mov    rbp,rsp
  103603:	48 83 ec 40          	sub    rsp,0x40
  103607:	48 89 7d d8          	mov    QWORD PTR [rbp-0x28],rdi
  10360b:	48 89 75 d0          	mov    QWORD PTR [rbp-0x30],rsi
  10360f:	48 89 55 c8          	mov    QWORD PTR [rbp-0x38],rdx
  103613:	48 89 4d c0          	mov    QWORD PTR [rbp-0x40],rcx
  103617:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  10361b:	48 83 c0 30          	add    rax,0x30
  10361f:	48 89 c7             	mov    rdi,rax
  103622:	e8 58 0c 00 00       	call   10427f <spinlock_lock>
  103627:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  10362b:	48 8b 55 c8          	mov    rdx,QWORD PTR [rbp-0x38]
  10362f:	48 89 50 18          	mov    QWORD PTR [rax+0x18],rdx
  103633:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
  103637:	48 89 45 e0          	mov    QWORD PTR [rbp-0x20],rax
  10363b:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
  10363f:	48 8b 55 d0          	mov    rdx,QWORD PTR [rbp-0x30]
  103643:	48 89 10             	mov    QWORD PTR [rax],rdx
  103646:	48 8b 45 d0          	mov    rax,QWORD PTR [rbp-0x30]
  10364a:	48 01 c0             	add    rax,rax
  10364d:	48 83 c0 07          	add    rax,0x7
  103651:	48 c1 e8 03          	shr    rax,0x3
  103655:	48 89 c2             	mov    rdx,rax
  103658:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
  10365c:	48 89 50 08          	mov    QWORD PTR [rax+0x8],rdx
  103660:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
  103664:	48 8b 50 08          	mov    rdx,QWORD PTR [rax+0x8]
  103668:	48 8b 45 c0          	mov    rax,QWORD PTR [rbp-0x40]
  10366c:	be 00 00 00 00       	mov    esi,0x0
  103671:	48 89 c7             	mov    rdi,rax
  103674:	e8 1c 0f 00 00       	call   104595 <memset>
  103679:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
  10367d:	48 83 c0 60          	add    rax,0x60
  103681:	ba 50 00 00 00       	mov    edx,0x50
  103686:	be 00 00 00 00       	mov    esi,0x0
  10368b:	48 89 c7             	mov    rdi,rax
  10368e:	e8 02 0f 00 00       	call   104595 <memset>
  103693:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
  103697:	48 05 b0 00 00 00    	add    rax,0xb0
  10369d:	ba 50 00 00 00       	mov    edx,0x50
  1036a2:	be 00 00 00 00       	mov    esi,0x0
  1036a7:	48 89 c7             	mov    rdi,rax
  1036aa:	e8 e6 0e 00 00       	call   104595 <memset>
  1036af:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
  1036b3:	48 8b 55 c0          	mov    rdx,QWORD PTR [rbp-0x40]
  1036b7:	48 89 50 10          	mov    QWORD PTR [rax+0x10],rdx
  1036bb:	48 8b 45 c0          	mov    rax,QWORD PTR [rbp-0x40]
  1036bf:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  1036c3:	48 8b 45 d0          	mov    rax,QWORD PTR [rbp-0x30]
  1036c7:	48 83 c0 07          	add    rax,0x7
  1036cb:	48 c1 e8 03          	shr    rax,0x3
  1036cf:	48 89 45 f0          	mov    QWORD PTR [rbp-0x10],rax
  1036d3:	c7 45 ec 01 00 00 00 	mov    DWORD PTR [rbp-0x14],0x1
  1036da:	eb 31                	jmp    10370d <region_map+0x10e>
  1036dc:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  1036e0:	48 01 45 f8          	add    QWORD PTR [rbp-0x8],rax
  1036e4:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
  1036e8:	8b 55 ec             	mov    edx,DWORD PTR [rbp-0x14]
  1036eb:	48 63 d2             	movsxd rdx,edx
  1036ee:	48 8d 4a 02          	lea    rcx,[rdx+0x2]
  1036f2:	48 8b 55 f8          	mov    rdx,QWORD PTR [rbp-0x8]
  1036f6:	48 89 14 c8          	mov    QWORD PTR [rax+rcx*8],rdx
  1036fa:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  1036fe:	48 83 c0 01          	add    rax,0x1
  103702:	48 d1 e8             	shr    rax,1
  103705:	48 89 45 f0          	mov    QWORD PTR [rbp-0x10],rax
  103709:	83 45 ec 01          	add    DWORD PTR [rbp-0x14],0x1
  10370d:	83 7d ec 09          	cmp    DWORD PTR [rbp-0x14],0x9
  103711:	7e c9                	jle    1036dc <region_map+0xdd>
  103713:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  103717:	48 89 c7             	mov    rdi,rax
  10371a:	e8 7c fd ff ff       	call   10349b <_free_area_map>
  10371f:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  103723:	48 83 c0 30          	add    rax,0x30
  103727:	48 89 c7             	mov    rdi,rax
  10372a:	e8 7b 0b 00 00       	call   1042aa <spinlock_unlock>
  10372f:	90                   	nop
  103730:	c9                   	leave  
  103731:	c3                   	ret    

0000000000103732 <out_of_mem>:
  103732:	55                   	push   rbp
  103733:	48 89 e5             	mov    rbp,rsp
  103736:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
  10373a:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10373e:	c6 40 11 01          	mov    BYTE PTR [rax+0x11],0x1
  103742:	90                   	nop
  103743:	5d                   	pop    rbp
  103744:	c3                   	ret    

0000000000103745 <block_split>:
  103745:	55                   	push   rbp
  103746:	48 89 e5             	mov    rbp,rsp
  103749:	48 83 ec 20          	sub    rsp,0x20
  10374d:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
  103751:	89 75 e4             	mov    DWORD PTR [rbp-0x1c],esi
  103754:	83 7d e4 00          	cmp    DWORD PTR [rbp-0x1c],0x0
  103758:	0f 84 0a 02 00 00    	je     103968 <block_split+0x223>
  10375e:	83 7d e4 09          	cmp    DWORD PTR [rbp-0x1c],0x9
  103762:	0f 87 00 02 00 00    	ja     103968 <block_split+0x223>
  103768:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  10376c:	48 8b 40 18          	mov    rax,QWORD PTR [rax+0x18]
  103770:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  103774:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103778:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  10377b:	48 83 c2 0c          	add    rdx,0xc
  10377f:	48 8b 04 d0          	mov    rax,QWORD PTR [rax+rdx*8]
  103783:	48 85 c0             	test   rax,rax
  103786:	0f 84 8e 01 00 00    	je     10391a <block_split+0x1d5>
  10378c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103790:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  103793:	48 83 c2 16          	add    rdx,0x16
  103797:	48 8b 14 d0          	mov    rdx,QWORD PTR [rax+rdx*8]
  10379b:	8b 4d e4             	mov    ecx,DWORD PTR [rbp-0x1c]
  10379e:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  1037a2:	89 ce                	mov    esi,ecx
  1037a4:	48 89 c7             	mov    rdi,rax
  1037a7:	e8 79 fa ff ff       	call   103225 <block_set>
  1037ac:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1037b0:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  1037b3:	48 83 c2 16          	add    rdx,0x16
  1037b7:	48 8b 04 d0          	mov    rax,QWORD PTR [rax+rdx*8]
  1037bb:	48 8d 14 00          	lea    rdx,[rax+rax*1]
  1037bf:	8b 45 e4             	mov    eax,DWORD PTR [rbp-0x1c]
  1037c2:	8d 48 ff             	lea    ecx,[rax-0x1]
  1037c5:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  1037c9:	89 ce                	mov    esi,ecx
  1037cb:	48 89 c7             	mov    rdi,rax
  1037ce:	e8 b9 fa ff ff       	call   10328c <block_clear>
  1037d3:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1037d7:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  1037da:	48 83 c2 16          	add    rdx,0x16
  1037de:	48 8b 04 d0          	mov    rax,QWORD PTR [rax+rdx*8]
  1037e2:	48 01 c0             	add    rax,rax
  1037e5:	48 8d 50 01          	lea    rdx,[rax+0x1]
  1037e9:	8b 45 e4             	mov    eax,DWORD PTR [rbp-0x1c]
  1037ec:	8d 48 ff             	lea    ecx,[rax-0x1]
  1037ef:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  1037f3:	89 ce                	mov    esi,ecx
  1037f5:	48 89 c7             	mov    rdi,rax
  1037f8:	e8 8f fa ff ff       	call   10328c <block_clear>
  1037fd:	8b 45 e4             	mov    eax,DWORD PTR [rbp-0x1c]
  103800:	8d 50 ff             	lea    edx,[rax-0x1]
  103803:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103807:	89 d2                	mov    edx,edx
  103809:	48 83 c2 16          	add    rdx,0x16
  10380d:	48 8b 14 d0          	mov    rdx,QWORD PTR [rax+rdx*8]
  103811:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103815:	8b 4d e4             	mov    ecx,DWORD PTR [rbp-0x1c]
  103818:	48 83 c1 16          	add    rcx,0x16
  10381c:	48 8b 04 c8          	mov    rax,QWORD PTR [rax+rcx*8]
  103820:	48 01 c0             	add    rax,rax
  103823:	48 39 c2             	cmp    rdx,rax
  103826:	76 27                	jbe    10384f <block_split+0x10a>
  103828:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10382c:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  10382f:	48 83 c2 16          	add    rdx,0x16
  103833:	48 8b 04 d0          	mov    rax,QWORD PTR [rax+rdx*8]
  103837:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  10383a:	83 ea 01             	sub    edx,0x1
  10383d:	48 8d 0c 00          	lea    rcx,[rax+rax*1]
  103841:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103845:	89 d2                	mov    edx,edx
  103847:	48 83 c2 16          	add    rdx,0x16
  10384b:	48 89 0c d0          	mov    QWORD PTR [rax+rdx*8],rcx
  10384f:	8b 45 e4             	mov    eax,DWORD PTR [rbp-0x1c]
  103852:	8d 50 ff             	lea    edx,[rax-0x1]
  103855:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103859:	89 d2                	mov    edx,edx
  10385b:	48 83 c2 0c          	add    rdx,0xc
  10385f:	48 8b 04 d0          	mov    rax,QWORD PTR [rax+rdx*8]
  103863:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  103866:	83 ea 01             	sub    edx,0x1
  103869:	48 8d 48 02          	lea    rcx,[rax+0x2]
  10386d:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103871:	89 d2                	mov    edx,edx
  103873:	48 83 c2 0c          	add    rdx,0xc
  103877:	48 89 0c d0          	mov    QWORD PTR [rax+rdx*8],rcx
  10387b:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10387f:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  103882:	48 83 c2 0c          	add    rdx,0xc
  103886:	48 8b 04 d0          	mov    rax,QWORD PTR [rax+rdx*8]
  10388a:	48 83 f8 01          	cmp    rax,0x1
  10388e:	74 53                	je     1038e3 <block_split+0x19e>
  103890:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103894:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  103897:	48 83 c2 16          	add    rdx,0x16
  10389b:	48 8b 04 d0          	mov    rax,QWORD PTR [rax+rdx*8]
  10389f:	48 8d 48 01          	lea    rcx,[rax+0x1]
  1038a3:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1038a7:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  1038aa:	48 83 c2 16          	add    rdx,0x16
  1038ae:	48 89 0c d0          	mov    QWORD PTR [rax+rdx*8],rcx
  1038b2:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1038b6:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  1038b9:	48 83 c2 16          	add    rdx,0x16
  1038bd:	48 8b 14 d0          	mov    rdx,QWORD PTR [rax+rdx*8]
  1038c1:	8b 4d e4             	mov    ecx,DWORD PTR [rbp-0x1c]
  1038c4:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  1038c8:	89 ce                	mov    esi,ecx
  1038ca:	48 89 c7             	mov    rdi,rax
  1038cd:	e8 4b fb ff ff       	call   10341d <find_next_free_page>
  1038d2:	48 8b 55 f8          	mov    rdx,QWORD PTR [rbp-0x8]
  1038d6:	8b 4d e4             	mov    ecx,DWORD PTR [rbp-0x1c]
  1038d9:	48 83 c1 16          	add    rcx,0x16
  1038dd:	48 89 04 ca          	mov    QWORD PTR [rdx+rcx*8],rax
  1038e1:	eb 13                	jmp    1038f6 <block_split+0x1b1>
  1038e3:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1038e7:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  1038ea:	48 83 c2 16          	add    rdx,0x16
  1038ee:	48 c7 04 d0 00 00 00 	mov    QWORD PTR [rax+rdx*8],0x0
  1038f5:	00 
  1038f6:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1038fa:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  1038fd:	48 83 c2 0c          	add    rdx,0xc
  103901:	48 8b 04 d0          	mov    rax,QWORD PTR [rax+rdx*8]
  103905:	48 8d 48 ff          	lea    rcx,[rax-0x1]
  103909:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10390d:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  103910:	48 83 c2 0c          	add    rdx,0xc
  103914:	48 89 0c d0          	mov    QWORD PTR [rax+rdx*8],rcx
  103918:	eb 4f                	jmp    103969 <block_split+0x224>
  10391a:	83 7d e4 09          	cmp    DWORD PTR [rbp-0x1c],0x9
  10391e:	75 0e                	jne    10392e <block_split+0x1e9>
  103920:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103924:	48 89 c7             	mov    rdi,rax
  103927:	e8 06 fe ff ff       	call   103732 <out_of_mem>
  10392c:	eb 3b                	jmp    103969 <block_split+0x224>
  10392e:	8b 45 e4             	mov    eax,DWORD PTR [rbp-0x1c]
  103931:	8d 50 01             	lea    edx,[rax+0x1]
  103934:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103938:	89 d6                	mov    esi,edx
  10393a:	48 89 c7             	mov    rdi,rax
  10393d:	e8 03 fe ff ff       	call   103745 <block_split>
  103942:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103946:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  103949:	48 83 c2 0c          	add    rdx,0xc
  10394d:	48 8b 04 d0          	mov    rax,QWORD PTR [rax+rdx*8]
  103951:	48 85 c0             	test   rax,rax
  103954:	0f 85 1a fe ff ff    	jne    103774 <block_split+0x2f>
  10395a:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  10395e:	48 89 c7             	mov    rdi,rax
  103961:	e8 cc fd ff ff       	call   103732 <out_of_mem>
  103966:	eb 01                	jmp    103969 <block_split+0x224>
  103968:	90                   	nop
  103969:	c9                   	leave  
  10396a:	c3                   	ret    

000000000010396b <zblock_split>:
  10396b:	55                   	push   rbp
  10396c:	48 89 e5             	mov    rbp,rsp
  10396f:	48 83 ec 30          	sub    rsp,0x30
  103973:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
  103977:	89 75 e4             	mov    DWORD PTR [rbp-0x1c],esi
  10397a:	48 89 55 d8          	mov    QWORD PTR [rbp-0x28],rdx
  10397e:	83 7d e4 00          	cmp    DWORD PTR [rbp-0x1c],0x0
  103982:	0f 84 e7 01 00 00    	je     103b6f <zblock_split+0x204>
  103988:	83 7d e4 09          	cmp    DWORD PTR [rbp-0x1c],0x9
  10398c:	0f 87 dd 01 00 00    	ja     103b6f <zblock_split+0x204>
  103992:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103996:	48 8b 40 18          	mov    rax,QWORD PTR [rax+0x18]
  10399a:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  10399e:	48 8b 55 d8          	mov    rdx,QWORD PTR [rbp-0x28]
  1039a2:	8b 4d e4             	mov    ecx,DWORD PTR [rbp-0x1c]
  1039a5:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  1039a9:	89 ce                	mov    esi,ecx
  1039ab:	48 89 c7             	mov    rdi,rax
  1039ae:	e8 41 f9 ff ff       	call   1032f4 <block_check>
  1039b3:	84 c0                	test   al,al
  1039b5:	0f 85 71 01 00 00    	jne    103b2c <zblock_split+0x1c1>
  1039bb:	90                   	nop
  1039bc:	eb 01                	jmp    1039bf <zblock_split+0x54>
  1039be:	90                   	nop
  1039bf:	48 8b 55 d8          	mov    rdx,QWORD PTR [rbp-0x28]
  1039c3:	8b 4d e4             	mov    ecx,DWORD PTR [rbp-0x1c]
  1039c6:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  1039ca:	89 ce                	mov    esi,ecx
  1039cc:	48 89 c7             	mov    rdi,rax
  1039cf:	e8 51 f8 ff ff       	call   103225 <block_set>
  1039d4:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1039d8:	48 8d 14 00          	lea    rdx,[rax+rax*1]
  1039dc:	8b 45 e4             	mov    eax,DWORD PTR [rbp-0x1c]
  1039df:	8d 48 ff             	lea    ecx,[rax-0x1]
  1039e2:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  1039e6:	89 ce                	mov    esi,ecx
  1039e8:	48 89 c7             	mov    rdi,rax
  1039eb:	e8 9c f8 ff ff       	call   10328c <block_clear>
  1039f0:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1039f4:	48 01 c0             	add    rax,rax
  1039f7:	48 8d 50 01          	lea    rdx,[rax+0x1]
  1039fb:	8b 45 e4             	mov    eax,DWORD PTR [rbp-0x1c]
  1039fe:	8d 48 ff             	lea    ecx,[rax-0x1]
  103a01:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103a05:	89 ce                	mov    esi,ecx
  103a07:	48 89 c7             	mov    rdi,rax
  103a0a:	e8 7d f8 ff ff       	call   10328c <block_clear>
  103a0f:	8b 45 e4             	mov    eax,DWORD PTR [rbp-0x1c]
  103a12:	8d 50 ff             	lea    edx,[rax-0x1]
  103a15:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103a19:	89 d2                	mov    edx,edx
  103a1b:	48 83 c2 16          	add    rdx,0x16
  103a1f:	48 8b 14 d0          	mov    rdx,QWORD PTR [rax+rdx*8]
  103a23:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103a27:	8b 4d e4             	mov    ecx,DWORD PTR [rbp-0x1c]
  103a2a:	48 83 c1 16          	add    rcx,0x16
  103a2e:	48 8b 04 c8          	mov    rax,QWORD PTR [rax+rcx*8]
  103a32:	48 01 c0             	add    rax,rax
  103a35:	48 39 c2             	cmp    rdx,rax
  103a38:	76 27                	jbe    103a61 <zblock_split+0xf6>
  103a3a:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103a3e:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  103a41:	48 83 c2 16          	add    rdx,0x16
  103a45:	48 8b 04 d0          	mov    rax,QWORD PTR [rax+rdx*8]
  103a49:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  103a4c:	83 ea 01             	sub    edx,0x1
  103a4f:	48 8d 0c 00          	lea    rcx,[rax+rax*1]
  103a53:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103a57:	89 d2                	mov    edx,edx
  103a59:	48 83 c2 16          	add    rdx,0x16
  103a5d:	48 89 0c d0          	mov    QWORD PTR [rax+rdx*8],rcx
  103a61:	8b 45 e4             	mov    eax,DWORD PTR [rbp-0x1c]
  103a64:	8d 50 ff             	lea    edx,[rax-0x1]
  103a67:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103a6b:	89 d2                	mov    edx,edx
  103a6d:	48 83 c2 0c          	add    rdx,0xc
  103a71:	48 8b 04 d0          	mov    rax,QWORD PTR [rax+rdx*8]
  103a75:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  103a78:	83 ea 01             	sub    edx,0x1
  103a7b:	48 8d 48 02          	lea    rcx,[rax+0x2]
  103a7f:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103a83:	89 d2                	mov    edx,edx
  103a85:	48 83 c2 0c          	add    rdx,0xc
  103a89:	48 89 0c d0          	mov    QWORD PTR [rax+rdx*8],rcx
  103a8d:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103a91:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  103a94:	48 83 c2 0c          	add    rdx,0xc
  103a98:	48 8b 04 d0          	mov    rax,QWORD PTR [rax+rdx*8]
  103a9c:	48 83 f8 01          	cmp    rax,0x1
  103aa0:	74 53                	je     103af5 <zblock_split+0x18a>
  103aa2:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103aa6:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  103aa9:	48 83 c2 16          	add    rdx,0x16
  103aad:	48 8b 04 d0          	mov    rax,QWORD PTR [rax+rdx*8]
  103ab1:	48 8d 48 01          	lea    rcx,[rax+0x1]
  103ab5:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103ab9:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  103abc:	48 83 c2 16          	add    rdx,0x16
  103ac0:	48 89 0c d0          	mov    QWORD PTR [rax+rdx*8],rcx
  103ac4:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103ac8:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  103acb:	48 83 c2 16          	add    rdx,0x16
  103acf:	48 8b 14 d0          	mov    rdx,QWORD PTR [rax+rdx*8]
  103ad3:	8b 4d e4             	mov    ecx,DWORD PTR [rbp-0x1c]
  103ad6:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103ada:	89 ce                	mov    esi,ecx
  103adc:	48 89 c7             	mov    rdi,rax
  103adf:	e8 39 f9 ff ff       	call   10341d <find_next_free_page>
  103ae4:	48 8b 55 f8          	mov    rdx,QWORD PTR [rbp-0x8]
  103ae8:	8b 4d e4             	mov    ecx,DWORD PTR [rbp-0x1c]
  103aeb:	48 83 c1 16          	add    rcx,0x16
  103aef:	48 89 04 ca          	mov    QWORD PTR [rdx+rcx*8],rax
  103af3:	eb 13                	jmp    103b08 <zblock_split+0x19d>
  103af5:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103af9:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  103afc:	48 83 c2 16          	add    rdx,0x16
  103b00:	48 c7 04 d0 00 00 00 	mov    QWORD PTR [rax+rdx*8],0x0
  103b07:	00 
  103b08:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103b0c:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  103b0f:	48 83 c2 0c          	add    rdx,0xc
  103b13:	48 8b 04 d0          	mov    rax,QWORD PTR [rax+rdx*8]
  103b17:	48 8d 48 ff          	lea    rcx,[rax-0x1]
  103b1b:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103b1f:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  103b22:	48 83 c2 0c          	add    rdx,0xc
  103b26:	48 89 0c d0          	mov    QWORD PTR [rax+rdx*8],rcx
  103b2a:	eb 47                	jmp    103b73 <zblock_split+0x208>
  103b2c:	83 7d e4 09          	cmp    DWORD PTR [rbp-0x1c],0x9
  103b30:	74 40                	je     103b72 <zblock_split+0x207>
  103b32:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  103b36:	48 d1 e8             	shr    rax,1
  103b39:	48 89 c2             	mov    rdx,rax
  103b3c:	8b 45 e4             	mov    eax,DWORD PTR [rbp-0x1c]
  103b3f:	8d 48 01             	lea    ecx,[rax+0x1]
  103b42:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103b46:	89 ce                	mov    esi,ecx
  103b48:	48 89 c7             	mov    rdi,rax
  103b4b:	e8 1b fe ff ff       	call   10396b <zblock_split>
  103b50:	48 8b 55 d8          	mov    rdx,QWORD PTR [rbp-0x28]
  103b54:	8b 4d e4             	mov    ecx,DWORD PTR [rbp-0x1c]
  103b57:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103b5b:	89 ce                	mov    esi,ecx
  103b5d:	48 89 c7             	mov    rdi,rax
  103b60:	e8 8f f7 ff ff       	call   1032f4 <block_check>
  103b65:	84 c0                	test   al,al
  103b67:	0f 84 51 fe ff ff    	je     1039be <zblock_split+0x53>
  103b6d:	eb 04                	jmp    103b73 <zblock_split+0x208>
  103b6f:	90                   	nop
  103b70:	eb 01                	jmp    103b73 <zblock_split+0x208>
  103b72:	90                   	nop
  103b73:	c9                   	leave  
  103b74:	c3                   	ret    

0000000000103b75 <block_set>:
  103b75:	55                   	push   rbp
  103b76:	48 89 e5             	mov    rbp,rsp
  103b79:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
  103b7d:	89 75 e4             	mov    DWORD PTR [rbp-0x1c],esi
  103b80:	48 89 55 d8          	mov    QWORD PTR [rbp-0x28],rdx
  103b84:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103b88:	48 8b 40 18          	mov    rax,QWORD PTR [rax+0x18]
  103b8c:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  103b90:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103b94:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  103b97:	48 83 c2 02          	add    rdx,0x2
  103b9b:	48 8b 14 d0          	mov    rdx,QWORD PTR [rax+rdx*8]
  103b9f:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  103ba3:	48 c1 e8 03          	shr    rax,0x3
  103ba7:	48 01 c2             	add    rdx,rax
  103baa:	0f b6 32             	movzx  esi,BYTE PTR [rdx]
  103bad:	48 8b 55 d8          	mov    rdx,QWORD PTR [rbp-0x28]
  103bb1:	83 e2 07             	and    edx,0x7
  103bb4:	bf 01 00 00 00       	mov    edi,0x1
  103bb9:	89 d1                	mov    ecx,edx
  103bbb:	d3 e7                	shl    edi,cl
  103bbd:	89 fa                	mov    edx,edi
  103bbf:	89 d7                	mov    edi,edx
  103bc1:	48 8b 55 f8          	mov    rdx,QWORD PTR [rbp-0x8]
  103bc5:	8b 4d e4             	mov    ecx,DWORD PTR [rbp-0x1c]
  103bc8:	48 83 c1 02          	add    rcx,0x2
  103bcc:	48 8b 14 ca          	mov    rdx,QWORD PTR [rdx+rcx*8]
  103bd0:	48 01 d0             	add    rax,rdx
  103bd3:	09 fe                	or     esi,edi
  103bd5:	89 f2                	mov    edx,esi
  103bd7:	88 10                	mov    BYTE PTR [rax],dl
  103bd9:	90                   	nop
  103bda:	5d                   	pop    rbp
  103bdb:	c3                   	ret    

0000000000103bdc <block_check>:
  103bdc:	55                   	push   rbp
  103bdd:	48 89 e5             	mov    rbp,rsp
  103be0:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
  103be4:	89 75 e4             	mov    DWORD PTR [rbp-0x1c],esi
  103be7:	48 89 55 d8          	mov    QWORD PTR [rbp-0x28],rdx
  103beb:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103bef:	48 8b 40 18          	mov    rax,QWORD PTR [rax+0x18]
  103bf3:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  103bf7:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103bfb:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  103bfe:	48 83 c2 02          	add    rdx,0x2
  103c02:	48 8b 04 d0          	mov    rax,QWORD PTR [rax+rdx*8]
  103c06:	48 8b 55 d8          	mov    rdx,QWORD PTR [rbp-0x28]
  103c0a:	48 c1 ea 03          	shr    rdx,0x3
  103c0e:	48 01 d0             	add    rax,rdx
  103c11:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  103c14:	0f be d0             	movsx  edx,al
  103c17:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  103c1b:	83 e0 07             	and    eax,0x7
  103c1e:	89 c1                	mov    ecx,eax
  103c20:	d3 fa                	sar    edx,cl
  103c22:	89 d0                	mov    eax,edx
  103c24:	83 e0 01             	and    eax,0x1
  103c27:	5d                   	pop    rbp
  103c28:	c3                   	ret    

0000000000103c29 <free_area_length>:
  103c29:	55                   	push   rbp
  103c2a:	48 89 e5             	mov    rbp,rsp
  103c2d:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
  103c31:	89 75 e4             	mov    DWORD PTR [rbp-0x1c],esi
  103c34:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103c38:	48 8b 40 18          	mov    rax,QWORD PTR [rax+0x18]
  103c3c:	48 8b 00             	mov    rax,QWORD PTR [rax]
  103c3f:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  103c43:	c7 45 f4 00 00 00 00 	mov    DWORD PTR [rbp-0xc],0x0
  103c4a:	eb 13                	jmp    103c5f <free_area_length+0x36>
  103c4c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103c50:	48 83 c0 01          	add    rax,0x1
  103c54:	48 d1 e8             	shr    rax,1
  103c57:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  103c5b:	83 45 f4 01          	add    DWORD PTR [rbp-0xc],0x1
  103c5f:	8b 45 f4             	mov    eax,DWORD PTR [rbp-0xc]
  103c62:	3b 45 e4             	cmp    eax,DWORD PTR [rbp-0x1c]
  103c65:	72 e5                	jb     103c4c <free_area_length+0x23>
  103c67:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103c6b:	5d                   	pop    rbp
  103c6c:	c3                   	ret    

0000000000103c6d <find_next_free_page>:
  103c6d:	55                   	push   rbp
  103c6e:	48 89 e5             	mov    rbp,rsp
  103c71:	48 83 ec 28          	sub    rsp,0x28
  103c75:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
  103c79:	89 75 e4             	mov    DWORD PTR [rbp-0x1c],esi
  103c7c:	48 89 55 d8          	mov    QWORD PTR [rbp-0x28],rdx
  103c80:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  103c84:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  103c88:	eb 24                	jmp    103cae <find_next_free_page+0x41>
  103c8a:	48 8b 55 f8          	mov    rdx,QWORD PTR [rbp-0x8]
  103c8e:	8b 4d e4             	mov    ecx,DWORD PTR [rbp-0x1c]
  103c91:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103c95:	89 ce                	mov    esi,ecx
  103c97:	48 89 c7             	mov    rdi,rax
  103c9a:	e8 3d ff ff ff       	call   103bdc <block_check>
  103c9f:	84 c0                	test   al,al
  103ca1:	75 06                	jne    103ca9 <find_next_free_page+0x3c>
  103ca3:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103ca7:	eb 40                	jmp    103ce9 <find_next_free_page+0x7c>
  103ca9:	48 83 45 f8 01       	add    QWORD PTR [rbp-0x8],0x1
  103cae:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  103cb1:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103cb5:	89 d6                	mov    esi,edx
  103cb7:	48 89 c7             	mov    rdi,rax
  103cba:	e8 6a ff ff ff       	call   103c29 <free_area_length>
  103cbf:	48 39 45 f8          	cmp    QWORD PTR [rbp-0x8],rax
  103cc3:	72 c5                	jb     103c8a <find_next_free_page+0x1d>
  103cc5:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103cc9:	48 8b 40 18          	mov    rax,QWORD PTR [rax+0x18]
  103ccd:	48 89 45 f0          	mov    QWORD PTR [rbp-0x10],rax
  103cd1:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  103cd5:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  103cd8:	48 83 c2 0c          	add    rdx,0xc
  103cdc:	48 c7 04 d0 00 00 00 	mov    QWORD PTR [rax+rdx*8],0x0
  103ce3:	00 
  103ce4:	b8 00 00 00 00       	mov    eax,0x0
  103ce9:	c9                   	leave  
  103cea:	c3                   	ret    

0000000000103ceb <page_alloc>:
  103ceb:	55                   	push   rbp
  103cec:	48 89 e5             	mov    rbp,rsp
  103cef:	48 83 ec 20          	sub    rsp,0x20
  103cf3:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
  103cf7:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103cfb:	48 83 c0 30          	add    rax,0x30
  103cff:	48 89 c7             	mov    rdi,rax
  103d02:	e8 78 05 00 00       	call   10427f <spinlock_lock>
  103d07:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103d0b:	48 8b 40 18          	mov    rax,QWORD PTR [rax+0x18]
  103d0f:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  103d13:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103d17:	48 8b 40 60          	mov    rax,QWORD PTR [rax+0x60]
  103d1b:	48 85 c0             	test   rax,rax
  103d1e:	0f 84 ca 00 00 00    	je     103dee <page_alloc+0x103>
  103d24:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103d28:	48 8b 90 b0 00 00 00 	mov    rdx,QWORD PTR [rax+0xb0]
  103d2f:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103d33:	be 00 00 00 00       	mov    esi,0x0
  103d38:	48 89 c7             	mov    rdi,rax
  103d3b:	e8 35 fe ff ff       	call   103b75 <block_set>
  103d40:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103d44:	48 8b 90 b0 00 00 00 	mov    rdx,QWORD PTR [rax+0xb0]
  103d4b:	48 8b 05 ae 24 00 00 	mov    rax,QWORD PTR [rip+0x24ae]        # 106200 <page_size>
  103d52:	48 0f af d0          	imul   rdx,rax
  103d56:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103d5a:	48 8b 00             	mov    rax,QWORD PTR [rax]
  103d5d:	48 01 d0             	add    rax,rdx
  103d60:	48 89 45 f0          	mov    QWORD PTR [rbp-0x10],rax
  103d64:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103d68:	48 8b 40 60          	mov    rax,QWORD PTR [rax+0x60]
  103d6c:	48 83 f8 01          	cmp    rax,0x1
  103d70:	74 43                	je     103db5 <page_alloc+0xca>
  103d72:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103d76:	48 8b 80 b0 00 00 00 	mov    rax,QWORD PTR [rax+0xb0]
  103d7d:	48 8d 50 01          	lea    rdx,[rax+0x1]
  103d81:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103d85:	48 89 90 b0 00 00 00 	mov    QWORD PTR [rax+0xb0],rdx
  103d8c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103d90:	48 8b 90 b0 00 00 00 	mov    rdx,QWORD PTR [rax+0xb0]
  103d97:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103d9b:	be 00 00 00 00       	mov    esi,0x0
  103da0:	48 89 c7             	mov    rdi,rax
  103da3:	e8 c5 fe ff ff       	call   103c6d <find_next_free_page>
  103da8:	48 8b 55 f8          	mov    rdx,QWORD PTR [rbp-0x8]
  103dac:	48 89 82 b0 00 00 00 	mov    QWORD PTR [rdx+0xb0],rax
  103db3:	eb 0f                	jmp    103dc4 <page_alloc+0xd9>
  103db5:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103db9:	48 c7 80 b0 00 00 00 	mov    QWORD PTR [rax+0xb0],0x0
  103dc0:	00 00 00 00 
  103dc4:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103dc8:	48 8b 40 60          	mov    rax,QWORD PTR [rax+0x60]
  103dcc:	48 8d 50 ff          	lea    rdx,[rax-0x1]
  103dd0:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103dd4:	48 89 50 60          	mov    QWORD PTR [rax+0x60],rdx
  103dd8:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103ddc:	48 83 c0 30          	add    rax,0x30
  103de0:	48 89 c7             	mov    rdi,rax
  103de3:	e8 c2 04 00 00       	call   1042aa <spinlock_unlock>
  103de8:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  103dec:	eb 37                	jmp    103e25 <page_alloc+0x13a>
  103dee:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103df2:	be 01 00 00 00       	mov    esi,0x1
  103df7:	48 89 c7             	mov    rdi,rax
  103dfa:	e8 46 f9 ff ff       	call   103745 <block_split>
  103dff:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103e03:	48 8b 40 60          	mov    rax,QWORD PTR [rax+0x60]
  103e07:	48 85 c0             	test   rax,rax
  103e0a:	0f 85 03 ff ff ff    	jne    103d13 <page_alloc+0x28>
  103e10:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103e14:	48 83 c0 30          	add    rax,0x30
  103e18:	48 89 c7             	mov    rdi,rax
  103e1b:	e8 8a 04 00 00       	call   1042aa <spinlock_unlock>
  103e20:	b8 00 00 00 00       	mov    eax,0x0
  103e25:	c9                   	leave  
  103e26:	c3                   	ret    

0000000000103e27 <pages_alloc>:
  103e27:	55                   	push   rbp
  103e28:	48 89 e5             	mov    rbp,rsp
  103e2b:	48 83 ec 20          	sub    rsp,0x20
  103e2f:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
  103e33:	89 75 e4             	mov    DWORD PTR [rbp-0x1c],esi
  103e36:	83 7d e4 09          	cmp    DWORD PTR [rbp-0x1c],0x9
  103e3a:	76 0a                	jbe    103e46 <pages_alloc+0x1f>
  103e3c:	b8 00 00 00 00       	mov    eax,0x0
  103e41:	e9 ba 01 00 00       	jmp    104000 <pages_alloc+0x1d9>
  103e46:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103e4a:	48 83 c0 30          	add    rax,0x30
  103e4e:	48 89 c7             	mov    rdi,rax
  103e51:	e8 29 04 00 00       	call   10427f <spinlock_lock>
  103e56:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103e5a:	48 8b 40 18          	mov    rax,QWORD PTR [rax+0x18]
  103e5e:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  103e62:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103e66:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  103e69:	48 83 c2 0c          	add    rdx,0xc
  103e6d:	48 8b 04 d0          	mov    rax,QWORD PTR [rax+rdx*8]
  103e71:	48 85 c0             	test   rax,rax
  103e74:	0f 84 10 01 00 00    	je     103f8a <pages_alloc+0x163>
  103e7a:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103e7e:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  103e81:	48 83 c2 16          	add    rdx,0x16
  103e85:	48 8b 14 d0          	mov    rdx,QWORD PTR [rax+rdx*8]
  103e89:	8b 4d e4             	mov    ecx,DWORD PTR [rbp-0x1c]
  103e8c:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103e90:	89 ce                	mov    esi,ecx
  103e92:	48 89 c7             	mov    rdi,rax
  103e95:	e8 db fc ff ff       	call   103b75 <block_set>
  103e9a:	8b 45 e4             	mov    eax,DWORD PTR [rbp-0x1c]
  103e9d:	ba 01 00 00 00       	mov    edx,0x1
  103ea2:	89 c1                	mov    ecx,eax
  103ea4:	d3 e2                	shl    edx,cl
  103ea6:	89 d0                	mov    eax,edx
  103ea8:	48 63 d0             	movsxd rdx,eax
  103eab:	48 8b 05 4e 23 00 00 	mov    rax,QWORD PTR [rip+0x234e]        # 106200 <page_size>
  103eb2:	48 0f af d0          	imul   rdx,rax
  103eb6:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103eba:	8b 4d e4             	mov    ecx,DWORD PTR [rbp-0x1c]
  103ebd:	48 83 c1 16          	add    rcx,0x16
  103ec1:	48 8b 04 c8          	mov    rax,QWORD PTR [rax+rcx*8]
  103ec5:	48 0f af d0          	imul   rdx,rax
  103ec9:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103ecd:	48 8b 00             	mov    rax,QWORD PTR [rax]
  103ed0:	48 01 d0             	add    rax,rdx
  103ed3:	48 89 45 f0          	mov    QWORD PTR [rbp-0x10],rax
  103ed7:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103edb:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  103ede:	48 83 c2 0c          	add    rdx,0xc
  103ee2:	48 8b 04 d0          	mov    rax,QWORD PTR [rax+rdx*8]
  103ee6:	48 83 f8 01          	cmp    rax,0x1
  103eea:	74 53                	je     103f3f <pages_alloc+0x118>
  103eec:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103ef0:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  103ef3:	48 83 c2 16          	add    rdx,0x16
  103ef7:	48 8b 04 d0          	mov    rax,QWORD PTR [rax+rdx*8]
  103efb:	48 8d 48 01          	lea    rcx,[rax+0x1]
  103eff:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103f03:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  103f06:	48 83 c2 16          	add    rdx,0x16
  103f0a:	48 89 0c d0          	mov    QWORD PTR [rax+rdx*8],rcx
  103f0e:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103f12:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  103f15:	48 83 c2 16          	add    rdx,0x16
  103f19:	48 8b 14 d0          	mov    rdx,QWORD PTR [rax+rdx*8]
  103f1d:	8b 4d e4             	mov    ecx,DWORD PTR [rbp-0x1c]
  103f20:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103f24:	89 ce                	mov    esi,ecx
  103f26:	48 89 c7             	mov    rdi,rax
  103f29:	e8 3f fd ff ff       	call   103c6d <find_next_free_page>
  103f2e:	48 8b 55 f8          	mov    rdx,QWORD PTR [rbp-0x8]
  103f32:	8b 4d e4             	mov    ecx,DWORD PTR [rbp-0x1c]
  103f35:	48 83 c1 16          	add    rcx,0x16
  103f39:	48 89 04 ca          	mov    QWORD PTR [rdx+rcx*8],rax
  103f3d:	eb 13                	jmp    103f52 <pages_alloc+0x12b>
  103f3f:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103f43:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  103f46:	48 83 c2 16          	add    rdx,0x16
  103f4a:	48 c7 04 d0 00 00 00 	mov    QWORD PTR [rax+rdx*8],0x0
  103f51:	00 
  103f52:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103f56:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  103f59:	48 83 c2 0c          	add    rdx,0xc
  103f5d:	48 8b 04 d0          	mov    rax,QWORD PTR [rax+rdx*8]
  103f61:	48 8d 48 ff          	lea    rcx,[rax-0x1]
  103f65:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103f69:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  103f6c:	48 83 c2 0c          	add    rdx,0xc
  103f70:	48 89 0c d0          	mov    QWORD PTR [rax+rdx*8],rcx
  103f74:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103f78:	48 83 c0 30          	add    rax,0x30
  103f7c:	48 89 c7             	mov    rdi,rax
  103f7f:	e8 26 03 00 00       	call   1042aa <spinlock_unlock>
  103f84:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  103f88:	eb 76                	jmp    104000 <pages_alloc+0x1d9>
  103f8a:	83 7d e4 09          	cmp    DWORD PTR [rbp-0x1c],0x9
  103f8e:	75 23                	jne    103fb3 <pages_alloc+0x18c>
  103f90:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103f94:	48 89 c7             	mov    rdi,rax
  103f97:	e8 96 f7 ff ff       	call   103732 <out_of_mem>
  103f9c:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103fa0:	48 83 c0 30          	add    rax,0x30
  103fa4:	48 89 c7             	mov    rdi,rax
  103fa7:	e8 fe 02 00 00       	call   1042aa <spinlock_unlock>
  103fac:	b8 00 00 00 00       	mov    eax,0x0
  103fb1:	eb 4d                	jmp    104000 <pages_alloc+0x1d9>
  103fb3:	8b 45 e4             	mov    eax,DWORD PTR [rbp-0x1c]
  103fb6:	8d 50 01             	lea    edx,[rax+0x1]
  103fb9:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103fbd:	89 d6                	mov    esi,edx
  103fbf:	48 89 c7             	mov    rdi,rax
  103fc2:	e8 7e f7 ff ff       	call   103745 <block_split>
  103fc7:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  103fcb:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  103fce:	48 83 c2 0c          	add    rdx,0xc
  103fd2:	48 8b 04 d0          	mov    rax,QWORD PTR [rax+rdx*8]
  103fd6:	48 85 c0             	test   rax,rax
  103fd9:	0f 85 83 fe ff ff    	jne    103e62 <pages_alloc+0x3b>
  103fdf:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103fe3:	48 89 c7             	mov    rdi,rax
  103fe6:	e8 47 f7 ff ff       	call   103732 <out_of_mem>
  103feb:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  103fef:	48 83 c0 30          	add    rax,0x30
  103ff3:	48 89 c7             	mov    rdi,rax
  103ff6:	e8 af 02 00 00       	call   1042aa <spinlock_unlock>
  103ffb:	b8 00 00 00 00       	mov    eax,0x0
  104000:	c9                   	leave  
  104001:	c3                   	ret    

0000000000104002 <pages_reserve>:
  104002:	55                   	push   rbp
  104003:	48 89 e5             	mov    rbp,rsp
  104006:	48 83 ec 30          	sub    rsp,0x30
  10400a:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
  10400e:	89 75 e4             	mov    DWORD PTR [rbp-0x1c],esi
  104011:	48 89 55 d8          	mov    QWORD PTR [rbp-0x28],rdx
  104015:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  104019:	48 83 c0 30          	add    rax,0x30
  10401d:	48 89 c7             	mov    rdi,rax
  104020:	e8 5a 02 00 00       	call   10427f <spinlock_lock>
  104025:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  104029:	48 8b 40 18          	mov    rax,QWORD PTR [rax+0x18]
  10402d:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  104031:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  104035:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  104038:	48 83 c2 16          	add    rdx,0x16
  10403c:	48 8b 04 d0          	mov    rax,QWORD PTR [rax+rdx*8]
  104040:	48 39 45 d8          	cmp    QWORD PTR [rbp-0x28],rax
  104044:	72 1d                	jb     104063 <pages_reserve+0x61>
  104046:	48 8b 55 d8          	mov    rdx,QWORD PTR [rbp-0x28]
  10404a:	8b 4d e4             	mov    ecx,DWORD PTR [rbp-0x1c]
  10404d:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  104051:	89 ce                	mov    esi,ecx
  104053:	48 89 c7             	mov    rdi,rax
  104056:	e8 81 fb ff ff       	call   103bdc <block_check>
  10405b:	84 c0                	test   al,al
  10405d:	0f 85 ba 00 00 00    	jne    10411d <pages_reserve+0x11b>
  104063:	90                   	nop
  104064:	eb 01                	jmp    104067 <pages_reserve+0x65>
  104066:	90                   	nop
  104067:	48 8b 55 d8          	mov    rdx,QWORD PTR [rbp-0x28]
  10406b:	8b 4d e4             	mov    ecx,DWORD PTR [rbp-0x1c]
  10406e:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  104072:	89 ce                	mov    esi,ecx
  104074:	48 89 c7             	mov    rdi,rax
  104077:	e8 f9 fa ff ff       	call   103b75 <block_set>
  10407c:	8b 45 e4             	mov    eax,DWORD PTR [rbp-0x1c]
  10407f:	ba 01 00 00 00       	mov    edx,0x1
  104084:	89 c1                	mov    ecx,eax
  104086:	d3 e2                	shl    edx,cl
  104088:	89 d0                	mov    eax,edx
  10408a:	48 63 d0             	movsxd rdx,eax
  10408d:	48 8b 05 6c 21 00 00 	mov    rax,QWORD PTR [rip+0x216c]        # 106200 <page_size>
  104094:	48 0f af c2          	imul   rax,rdx
  104098:	48 0f af 45 d8       	imul   rax,QWORD PTR [rbp-0x28]
  10409d:	48 89 c2             	mov    rdx,rax
  1040a0:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  1040a4:	48 8b 00             	mov    rax,QWORD PTR [rax]
  1040a7:	48 01 d0             	add    rax,rdx
  1040aa:	48 89 45 f0          	mov    QWORD PTR [rbp-0x10],rax
  1040ae:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1040b2:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  1040b5:	48 83 c2 16          	add    rdx,0x16
  1040b9:	48 8b 04 d0          	mov    rax,QWORD PTR [rax+rdx*8]
  1040bd:	48 39 45 d8          	cmp    QWORD PTR [rbp-0x28],rax
  1040c1:	75 22                	jne    1040e5 <pages_reserve+0xe3>
  1040c3:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1040c7:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  1040ca:	48 83 c2 16          	add    rdx,0x16
  1040ce:	48 8b 04 d0          	mov    rax,QWORD PTR [rax+rdx*8]
  1040d2:	48 8d 48 01          	lea    rcx,[rax+0x1]
  1040d6:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1040da:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  1040dd:	48 83 c2 16          	add    rdx,0x16
  1040e1:	48 89 0c d0          	mov    QWORD PTR [rax+rdx*8],rcx
  1040e5:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1040e9:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  1040ec:	48 83 c2 0c          	add    rdx,0xc
  1040f0:	48 8b 04 d0          	mov    rax,QWORD PTR [rax+rdx*8]
  1040f4:	48 8d 48 ff          	lea    rcx,[rax-0x1]
  1040f8:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1040fc:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  1040ff:	48 83 c2 0c          	add    rdx,0xc
  104103:	48 89 0c d0          	mov    QWORD PTR [rax+rdx*8],rcx
  104107:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  10410b:	48 83 c0 30          	add    rax,0x30
  10410f:	48 89 c7             	mov    rdi,rax
  104112:	e8 93 01 00 00       	call   1042aa <spinlock_unlock>
  104117:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  10411b:	eb 6d                	jmp    10418a <pages_reserve+0x188>
  10411d:	83 7d e4 09          	cmp    DWORD PTR [rbp-0x1c],0x9
  104121:	75 17                	jne    10413a <pages_reserve+0x138>
  104123:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  104127:	48 83 c0 30          	add    rax,0x30
  10412b:	48 89 c7             	mov    rdi,rax
  10412e:	e8 77 01 00 00       	call   1042aa <spinlock_unlock>
  104133:	b8 00 00 00 00       	mov    eax,0x0
  104138:	eb 50                	jmp    10418a <pages_reserve+0x188>
  10413a:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  10413e:	48 d1 e8             	shr    rax,1
  104141:	48 89 c2             	mov    rdx,rax
  104144:	8b 45 e4             	mov    eax,DWORD PTR [rbp-0x1c]
  104147:	8d 48 01             	lea    ecx,[rax+0x1]
  10414a:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  10414e:	89 ce                	mov    esi,ecx
  104150:	48 89 c7             	mov    rdi,rax
  104153:	e8 13 f8 ff ff       	call   10396b <zblock_split>
  104158:	48 8b 55 d8          	mov    rdx,QWORD PTR [rbp-0x28]
  10415c:	8b 4d e4             	mov    ecx,DWORD PTR [rbp-0x1c]
  10415f:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  104163:	89 ce                	mov    esi,ecx
  104165:	48 89 c7             	mov    rdi,rax
  104168:	e8 6f fa ff ff       	call   103bdc <block_check>
  10416d:	84 c0                	test   al,al
  10416f:	0f 84 f1 fe ff ff    	je     104066 <pages_reserve+0x64>
  104175:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  104179:	48 83 c0 30          	add    rax,0x30
  10417d:	48 89 c7             	mov    rdi,rax
  104180:	e8 25 01 00 00       	call   1042aa <spinlock_unlock>
  104185:	b8 00 00 00 00       	mov    eax,0x0
  10418a:	c9                   	leave  
  10418b:	c3                   	ret    

000000000010418c <clearerr>:
  10418c:	55                   	push   rbp
  10418d:	48 89 e5             	mov    rbp,rsp
  104190:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
  104194:	90                   	nop
  104195:	5d                   	pop    rbp
  104196:	c3                   	ret    

0000000000104197 <fclose>:
  104197:	55                   	push   rbp
  104198:	48 89 e5             	mov    rbp,rsp
  10419b:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
  10419f:	b8 01 00 00 00       	mov    eax,0x1
  1041a4:	5d                   	pop    rbp
  1041a5:	c3                   	ret    

00000000001041a6 <feof>:
  1041a6:	55                   	push   rbp
  1041a7:	48 89 e5             	mov    rbp,rsp
  1041aa:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
  1041ae:	b8 01 00 00 00       	mov    eax,0x1
  1041b3:	5d                   	pop    rbp
  1041b4:	c3                   	ret    

00000000001041b5 <ferror>:
  1041b5:	55                   	push   rbp
  1041b6:	48 89 e5             	mov    rbp,rsp
  1041b9:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
  1041bd:	b8 01 00 00 00       	mov    eax,0x1
  1041c2:	5d                   	pop    rbp
  1041c3:	c3                   	ret    

00000000001041c4 <fflush>:
  1041c4:	55                   	push   rbp
  1041c5:	48 89 e5             	mov    rbp,rsp
  1041c8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
  1041cc:	b8 00 00 00 00       	mov    eax,0x0
  1041d1:	5d                   	pop    rbp
  1041d2:	c3                   	ret    

00000000001041d3 <printf>:
  1041d3:	55                   	push   rbp
  1041d4:	48 89 e5             	mov    rbp,rsp
  1041d7:	48 81 ec c0 00 00 00 	sub    rsp,0xc0
  1041de:	48 89 bd 48 ff ff ff 	mov    QWORD PTR [rbp-0xb8],rdi
  1041e5:	48 89 b5 58 ff ff ff 	mov    QWORD PTR [rbp-0xa8],rsi
  1041ec:	48 89 95 60 ff ff ff 	mov    QWORD PTR [rbp-0xa0],rdx
  1041f3:	48 89 8d 68 ff ff ff 	mov    QWORD PTR [rbp-0x98],rcx
  1041fa:	4c 89 85 70 ff ff ff 	mov    QWORD PTR [rbp-0x90],r8
  104201:	4c 89 8d 78 ff ff ff 	mov    QWORD PTR [rbp-0x88],r9
  104208:	84 c0                	test   al,al
  10420a:	74 20                	je     10422c <printf+0x59>
  10420c:	0f 29 45 80          	movaps XMMWORD PTR [rbp-0x80],xmm0
  104210:	0f 29 4d 90          	movaps XMMWORD PTR [rbp-0x70],xmm1
  104214:	0f 29 55 a0          	movaps XMMWORD PTR [rbp-0x60],xmm2
  104218:	0f 29 5d b0          	movaps XMMWORD PTR [rbp-0x50],xmm3
  10421c:	0f 29 65 c0          	movaps XMMWORD PTR [rbp-0x40],xmm4
  104220:	0f 29 6d d0          	movaps XMMWORD PTR [rbp-0x30],xmm5
  104224:	0f 29 75 e0          	movaps XMMWORD PTR [rbp-0x20],xmm6
  104228:	0f 29 7d f0          	movaps XMMWORD PTR [rbp-0x10],xmm7
  10422c:	48 8b 85 48 ff ff ff 	mov    rax,QWORD PTR [rbp-0xb8]
  104233:	48 89 c7             	mov    rdi,rax
  104236:	e8 02 00 00 00       	call   10423d <_impl_printf>
  10423b:	c9                   	leave  
  10423c:	c3                   	ret    

000000000010423d <_impl_printf>:
  10423d:	55                   	push   rbp
  10423e:	48 89 e5             	mov    rbp,rsp
  104241:	48 83 ec 10          	sub    rsp,0x10
  104245:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
  104249:	0f b6 05 c0 1f 00 00 	movzx  eax,BYTE PTR [rip+0x1fc0]        # 106210 <PRINTF_FB_ENABLE>
  104250:	84 c0                	test   al,al
  104252:	74 24                	je     104278 <_impl_printf+0x3b>
  104254:	0f b6 05 a5 7d 00 00 	movzx  eax,BYTE PTR [rip+0x7da5]        # 10c000 <printf_fallback_fn>
  10425b:	84 c0                	test   al,al
  10425d:	74 12                	je     104271 <_impl_printf+0x34>
  10425f:	48 8b 15 a2 7d 00 00 	mov    rdx,QWORD PTR [rip+0x7da2]        # 10c008 <printf_fallback_fn+0x8>
  104266:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10426a:	48 89 c7             	mov    rdi,rax
  10426d:	ff d2                	call   rdx
  10426f:	eb 0c                	jmp    10427d <_impl_printf+0x40>
  104271:	b8 00 00 00 00       	mov    eax,0x0
  104276:	eb 05                	jmp    10427d <_impl_printf+0x40>
  104278:	b8 00 00 00 00       	mov    eax,0x0
  10427d:	c9                   	leave  
  10427e:	c3                   	ret    

000000000010427f <spinlock_lock>:
  10427f:	55                   	push   rbp
  104280:	48 89 e5             	mov    rbp,rsp
  104283:	48 83 ec 10          	sub    rsp,0x10
  104287:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
  10428b:	90                   	nop
  10428c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  104290:	ba 01 00 00 00       	mov    edx,0x1
  104295:	be 00 00 00 00       	mov    esi,0x0
  10429a:	48 89 c7             	mov    rdi,rax
  10429d:	e8 28 00 00 00       	call   1042ca <atomic_compare_exchange>
  1042a2:	85 c0                	test   eax,eax
  1042a4:	74 e6                	je     10428c <spinlock_lock+0xd>
  1042a6:	90                   	nop
  1042a7:	90                   	nop
  1042a8:	c9                   	leave  
  1042a9:	c3                   	ret    

00000000001042aa <spinlock_unlock>:
  1042aa:	55                   	push   rbp
  1042ab:	48 89 e5             	mov    rbp,rsp
  1042ae:	48 83 ec 10          	sub    rsp,0x10
  1042b2:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
  1042b6:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1042ba:	be 00 00 00 00       	mov    esi,0x0
  1042bf:	48 89 c7             	mov    rdi,rax
  1042c2:	e8 32 00 00 00       	call   1042f9 <atomic_store>
  1042c7:	90                   	nop
  1042c8:	c9                   	leave  
  1042c9:	c3                   	ret    

00000000001042ca <atomic_compare_exchange>:
  1042ca:	55                   	push   rbp
  1042cb:	48 89 e5             	mov    rbp,rsp
  1042ce:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
  1042d2:	89 75 f4             	mov    DWORD PTR [rbp-0xc],esi
  1042d5:	89 55 f0             	mov    DWORD PTR [rbp-0x10],edx
  1042d8:	8b 4d f0             	mov    ecx,DWORD PTR [rbp-0x10]
  1042db:	48 8b 75 f8          	mov    rsi,QWORD PTR [rbp-0x8]
  1042df:	48 8d 55 f4          	lea    rdx,[rbp-0xc]
  1042e3:	8b 02                	mov    eax,DWORD PTR [rdx]
  1042e5:	f0 0f b1 0e          	lock cmpxchg DWORD PTR [rsi],ecx
  1042e9:	89 c1                	mov    ecx,eax
  1042eb:	0f 94 c0             	sete   al
  1042ee:	84 c0                	test   al,al
  1042f0:	75 02                	jne    1042f4 <atomic_compare_exchange+0x2a>
  1042f2:	89 0a                	mov    DWORD PTR [rdx],ecx
  1042f4:	0f b6 c0             	movzx  eax,al
  1042f7:	5d                   	pop    rbp
  1042f8:	c3                   	ret    

00000000001042f9 <atomic_store>:
  1042f9:	55                   	push   rbp
  1042fa:	48 89 e5             	mov    rbp,rsp
  1042fd:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
  104301:	89 75 f4             	mov    DWORD PTR [rbp-0xc],esi
  104304:	8b 55 f4             	mov    edx,DWORD PTR [rbp-0xc]
  104307:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10430b:	89 10                	mov    DWORD PTR [rax],edx
  10430d:	0f ae f0             	mfence 
  104310:	90                   	nop
  104311:	5d                   	pop    rbp
  104312:	c3                   	ret    

0000000000104313 <strlen>:
  104313:	55                   	push   rbp
  104314:	48 89 e5             	mov    rbp,rsp
  104317:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
  10431b:	48 c7 45 f8 00 00 00 	mov    QWORD PTR [rbp-0x8],0x0
  104322:	00 
  104323:	eb 05                	jmp    10432a <strlen+0x17>
  104325:	48 83 45 f8 01       	add    QWORD PTR [rbp-0x8],0x1
  10432a:	48 8b 55 e8          	mov    rdx,QWORD PTR [rbp-0x18]
  10432e:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  104332:	48 01 d0             	add    rax,rdx
  104335:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  104338:	84 c0                	test   al,al
  10433a:	75 e9                	jne    104325 <strlen+0x12>
  10433c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  104340:	5d                   	pop    rbp
  104341:	c3                   	ret    

0000000000104342 <tostring>:
  104342:	55                   	push   rbp
  104343:	48 89 e5             	mov    rbp,rsp
  104346:	48 83 ec 30          	sub    rsp,0x30
  10434a:	48 89 7d d8          	mov    QWORD PTR [rbp-0x28],rdi
  10434e:	48 89 75 d0          	mov    QWORD PTR [rbp-0x30],rsi
  104352:	48 8b 45 d0          	mov    rax,QWORD PTR [rbp-0x30]
  104356:	48 89 c7             	mov    rdi,rax
  104359:	e8 b5 ff ff ff       	call   104313 <strlen>
  10435e:	48 89 45 e8          	mov    QWORD PTR [rbp-0x18],rax
  104362:	48 c7 45 f8 00 00 00 	mov    QWORD PTR [rbp-0x8],0x0
  104369:	00 
  10436a:	eb 13                	jmp    10437f <tostring+0x3d>
  10436c:	48 8b 55 d0          	mov    rdx,QWORD PTR [rbp-0x30]
  104370:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  104374:	48 01 d0             	add    rax,rdx
  104377:	c6 00 00             	mov    BYTE PTR [rax],0x0
  10437a:	48 83 45 f8 01       	add    QWORD PTR [rbp-0x8],0x1
  10437f:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  104383:	48 3b 45 e8          	cmp    rax,QWORD PTR [rbp-0x18]
  104387:	72 e3                	jb     10436c <tostring+0x2a>
  104389:	48 83 7d d8 00       	cmp    QWORD PTR [rbp-0x28],0x0
  10438e:	75 11                	jne    1043a1 <tostring+0x5f>
  104390:	48 8b 45 d0          	mov    rax,QWORD PTR [rbp-0x30]
  104394:	c6 00 30             	mov    BYTE PTR [rax],0x30
  104397:	b8 01 00 00 00       	mov    eax,0x1
  10439c:	e9 b8 00 00 00       	jmp    104459 <tostring+0x117>
  1043a1:	48 c7 45 f0 00 00 00 	mov    QWORD PTR [rbp-0x10],0x0
  1043a8:	00 
  1043a9:	e9 8f 00 00 00       	jmp    10443d <tostring+0xfb>
  1043ae:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
  1043b2:	48 ba cd cc cc cc cc 	movabs rdx,0xcccccccccccccccd
  1043b9:	cc cc cc 
  1043bc:	48 89 c8             	mov    rax,rcx
  1043bf:	48 f7 e2             	mul    rdx
  1043c2:	48 c1 ea 03          	shr    rdx,0x3
  1043c6:	48 89 d0             	mov    rax,rdx
  1043c9:	48 c1 e0 02          	shl    rax,0x2
  1043cd:	48 01 d0             	add    rax,rdx
  1043d0:	48 01 c0             	add    rax,rax
  1043d3:	48 29 c1             	sub    rcx,rax
  1043d6:	48 89 ca             	mov    rdx,rcx
  1043d9:	89 d0                	mov    eax,edx
  1043db:	8d 48 30             	lea    ecx,[rax+0x30]
  1043de:	48 8b 55 d0          	mov    rdx,QWORD PTR [rbp-0x30]
  1043e2:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  1043e6:	48 01 d0             	add    rax,rdx
  1043e9:	89 ca                	mov    edx,ecx
  1043eb:	88 10                	mov    BYTE PTR [rax],dl
  1043ed:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
  1043f1:	48 ba cd cc cc cc cc 	movabs rdx,0xcccccccccccccccd
  1043f8:	cc cc cc 
  1043fb:	48 89 c8             	mov    rax,rcx
  1043fe:	48 f7 e2             	mul    rdx
  104401:	48 c1 ea 03          	shr    rdx,0x3
  104405:	48 89 d0             	mov    rax,rdx
  104408:	48 c1 e0 02          	shl    rax,0x2
  10440c:	48 01 d0             	add    rax,rdx
  10440f:	48 01 c0             	add    rax,rax
  104412:	48 29 c1             	sub    rcx,rax
  104415:	48 89 ca             	mov    rdx,rcx
  104418:	48 29 55 d8          	sub    QWORD PTR [rbp-0x28],rdx
  10441c:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  104420:	48 ba cd cc cc cc cc 	movabs rdx,0xcccccccccccccccd
  104427:	cc cc cc 
  10442a:	48 f7 e2             	mul    rdx
  10442d:	48 89 d0             	mov    rax,rdx
  104430:	48 c1 e8 03          	shr    rax,0x3
  104434:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
  104438:	48 83 45 f0 01       	add    QWORD PTR [rbp-0x10],0x1
  10443d:	48 83 7d d8 00       	cmp    QWORD PTR [rbp-0x28],0x0
  104442:	0f 85 66 ff ff ff    	jne    1043ae <tostring+0x6c>
  104448:	48 8b 45 d0          	mov    rax,QWORD PTR [rbp-0x30]
  10444c:	48 89 c7             	mov    rdi,rax
  10444f:	e8 07 00 00 00       	call   10445b <reverse>
  104454:	b8 01 00 00 00       	mov    eax,0x1
  104459:	c9                   	leave  
  10445a:	c3                   	ret    

000000000010445b <reverse>:
  10445b:	55                   	push   rbp
  10445c:	48 89 e5             	mov    rbp,rsp
  10445f:	48 83 ec 30          	sub    rsp,0x30
  104463:	48 89 7d d8          	mov    QWORD PTR [rbp-0x28],rdi
  104467:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  10446b:	48 89 c7             	mov    rdi,rax
  10446e:	e8 a0 fe ff ff       	call   104313 <strlen>
  104473:	48 89 45 e8          	mov    QWORD PTR [rbp-0x18],rax
  104477:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  10447b:	48 d1 e8             	shr    rax,1
  10447e:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  104482:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  104486:	83 e0 01             	and    eax,0x1
  104489:	48 85 c0             	test   rax,rax
  10448c:	74 05                	je     104493 <reverse+0x38>
  10448e:	48 83 45 f8 01       	add    QWORD PTR [rbp-0x8],0x1
  104493:	48 c7 45 f0 00 00 00 	mov    QWORD PTR [rbp-0x10],0x0
  10449a:	00 
  10449b:	e9 b4 00 00 00       	jmp    104554 <reverse+0xf9>
  1044a0:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  1044a4:	48 2b 45 f0          	sub    rax,QWORD PTR [rbp-0x10]
  1044a8:	48 8d 50 ff          	lea    rdx,[rax-0x1]
  1044ac:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1044b0:	48 01 d0             	add    rax,rdx
  1044b3:	0f b6 30             	movzx  esi,BYTE PTR [rax]
  1044b6:	48 8b 55 d8          	mov    rdx,QWORD PTR [rbp-0x28]
  1044ba:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  1044be:	48 01 d0             	add    rax,rdx
  1044c1:	0f b6 08             	movzx  ecx,BYTE PTR [rax]
  1044c4:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  1044c8:	48 2b 45 f0          	sub    rax,QWORD PTR [rbp-0x10]
  1044cc:	48 8d 50 ff          	lea    rdx,[rax-0x1]
  1044d0:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1044d4:	48 01 d0             	add    rax,rdx
  1044d7:	31 ce                	xor    esi,ecx
  1044d9:	89 f2                	mov    edx,esi
  1044db:	88 10                	mov    BYTE PTR [rax],dl
  1044dd:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  1044e1:	48 2b 45 f0          	sub    rax,QWORD PTR [rbp-0x10]
  1044e5:	48 8d 50 ff          	lea    rdx,[rax-0x1]
  1044e9:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1044ed:	48 01 d0             	add    rax,rdx
  1044f0:	0f b6 30             	movzx  esi,BYTE PTR [rax]
  1044f3:	48 8b 55 d8          	mov    rdx,QWORD PTR [rbp-0x28]
  1044f7:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  1044fb:	48 01 d0             	add    rax,rdx
  1044fe:	0f b6 08             	movzx  ecx,BYTE PTR [rax]
  104501:	48 8b 55 d8          	mov    rdx,QWORD PTR [rbp-0x28]
  104505:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104509:	48 01 d0             	add    rax,rdx
  10450c:	31 ce                	xor    esi,ecx
  10450e:	89 f2                	mov    edx,esi
  104510:	88 10                	mov    BYTE PTR [rax],dl
  104512:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  104516:	48 2b 45 f0          	sub    rax,QWORD PTR [rbp-0x10]
  10451a:	48 8d 50 ff          	lea    rdx,[rax-0x1]
  10451e:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  104522:	48 01 d0             	add    rax,rdx
  104525:	0f b6 30             	movzx  esi,BYTE PTR [rax]
  104528:	48 8b 55 d8          	mov    rdx,QWORD PTR [rbp-0x28]
  10452c:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104530:	48 01 d0             	add    rax,rdx
  104533:	0f b6 08             	movzx  ecx,BYTE PTR [rax]
  104536:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  10453a:	48 2b 45 f0          	sub    rax,QWORD PTR [rbp-0x10]
  10453e:	48 8d 50 ff          	lea    rdx,[rax-0x1]
  104542:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  104546:	48 01 d0             	add    rax,rdx
  104549:	31 ce                	xor    esi,ecx
  10454b:	89 f2                	mov    edx,esi
  10454d:	88 10                	mov    BYTE PTR [rax],dl
  10454f:	48 83 45 f0 01       	add    QWORD PTR [rbp-0x10],0x1
  104554:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104558:	48 3b 45 f8          	cmp    rax,QWORD PTR [rbp-0x8]
  10455c:	0f 82 3e ff ff ff    	jb     1044a0 <reverse+0x45>
  104562:	b8 01 00 00 00       	mov    eax,0x1
  104567:	c9                   	leave  
  104568:	c3                   	ret    

0000000000104569 <memcpy>:
  104569:	55                   	push   rbp
  10456a:	48 89 e5             	mov    rbp,rsp
  10456d:	53                   	push   rbx
  10456e:	48 89 f8             	mov    rax,rdi
  104571:	48 89 f1             	mov    rcx,rsi
  104574:	bb 00 00 00 00       	mov    ebx,0x0
  104579:	eb 12                	jmp    10458d <memcpy+0x24>
  10457b:	48 8d 3c 19          	lea    rdi,[rcx+rbx*1]
  10457f:	48 8d 34 18          	lea    rsi,[rax+rbx*1]
  104583:	0f b6 3f             	movzx  edi,BYTE PTR [rdi]
  104586:	40 88 3e             	mov    BYTE PTR [rsi],dil
  104589:	48 83 c3 01          	add    rbx,0x1
  10458d:	48 39 d3             	cmp    rbx,rdx
  104590:	72 e9                	jb     10457b <memcpy+0x12>
  104592:	5b                   	pop    rbx
  104593:	5d                   	pop    rbp
  104594:	c3                   	ret    

0000000000104595 <memset>:
  104595:	55                   	push   rbp
  104596:	48 89 e5             	mov    rbp,rsp
  104599:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
  10459d:	89 75 e4             	mov    DWORD PTR [rbp-0x1c],esi
  1045a0:	48 89 55 d8          	mov    QWORD PTR [rbp-0x28],rdx
  1045a4:	48 c7 45 f8 00 00 00 	mov    QWORD PTR [rbp-0x8],0x0
  1045ab:	00 
  1045ac:	eb 15                	jmp    1045c3 <memset+0x2e>
  1045ae:	48 8b 55 e8          	mov    rdx,QWORD PTR [rbp-0x18]
  1045b2:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1045b6:	48 01 d0             	add    rax,rdx
  1045b9:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  1045bc:	88 10                	mov    BYTE PTR [rax],dl
  1045be:	48 83 45 f8 01       	add    QWORD PTR [rbp-0x8],0x1
  1045c3:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1045c7:	48 3b 45 d8          	cmp    rax,QWORD PTR [rbp-0x28]
  1045cb:	72 e1                	jb     1045ae <memset+0x19>
  1045cd:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  1045d1:	5d                   	pop    rbp
  1045d2:	c3                   	ret    

00000000001045d3 <strcmp>:
  1045d3:	55                   	push   rbp
  1045d4:	48 89 e5             	mov    rbp,rsp
  1045d7:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
  1045db:	48 89 75 e0          	mov    QWORD PTR [rbp-0x20],rsi
  1045df:	48 c7 45 f8 00 00 00 	mov    QWORD PTR [rbp-0x8],0x0
  1045e6:	00 
  1045e7:	48 8b 55 e8          	mov    rdx,QWORD PTR [rbp-0x18]
  1045eb:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1045ef:	48 01 d0             	add    rax,rdx
  1045f2:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  1045f5:	84 c0                	test   al,al
  1045f7:	75 19                	jne    104612 <strcmp+0x3f>
  1045f9:	48 8b 55 e0          	mov    rdx,QWORD PTR [rbp-0x20]
  1045fd:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  104601:	48 01 d0             	add    rax,rdx
  104604:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  104607:	84 c0                	test   al,al
  104609:	75 07                	jne    104612 <strcmp+0x3f>
  10460b:	b8 00 00 00 00       	mov    eax,0x0
  104610:	eb 55                	jmp    104667 <strcmp+0x94>
  104612:	48 8b 55 e8          	mov    rdx,QWORD PTR [rbp-0x18]
  104616:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10461a:	48 01 d0             	add    rax,rdx
  10461d:	0f b6 10             	movzx  edx,BYTE PTR [rax]
  104620:	48 8b 4d e0          	mov    rcx,QWORD PTR [rbp-0x20]
  104624:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  104628:	48 01 c8             	add    rax,rcx
  10462b:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  10462e:	38 c2                	cmp    dl,al
  104630:	7e 07                	jle    104639 <strcmp+0x66>
  104632:	b8 01 00 00 00       	mov    eax,0x1
  104637:	eb 2e                	jmp    104667 <strcmp+0x94>
  104639:	48 8b 55 e8          	mov    rdx,QWORD PTR [rbp-0x18]
  10463d:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  104641:	48 01 d0             	add    rax,rdx
  104644:	0f b6 10             	movzx  edx,BYTE PTR [rax]
  104647:	48 8b 4d e0          	mov    rcx,QWORD PTR [rbp-0x20]
  10464b:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10464f:	48 01 c8             	add    rax,rcx
  104652:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  104655:	38 c2                	cmp    dl,al
  104657:	7d 07                	jge    104660 <strcmp+0x8d>
  104659:	b8 ff ff ff ff       	mov    eax,0xffffffff
  10465e:	eb 07                	jmp    104667 <strcmp+0x94>
  104660:	48 83 45 f8 01       	add    QWORD PTR [rbp-0x8],0x1
  104665:	eb 80                	jmp    1045e7 <strcmp+0x14>
  104667:	5d                   	pop    rbp
  104668:	c3                   	ret    

0000000000104669 <c_str>:
  104669:	55                   	push   rbp
  10466a:	48 89 e5             	mov    rbp,rsp
  10466d:	48 83 ec 30          	sub    rsp,0x30
  104671:	48 89 7d d8          	mov    QWORD PTR [rbp-0x28],rdi
  104675:	48 8d 05 34 21 00 00 	lea    rax,[rip+0x2134]        # 1067b0 <bits_per_page+0x8>
  10467c:	48 89 45 e8          	mov    QWORD PTR [rbp-0x18],rax
  104680:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  104684:	48 89 c7             	mov    rdi,rax
  104687:	e8 87 fc ff ff       	call   104313 <strlen>
  10468c:	48 89 45 e0          	mov    QWORD PTR [rbp-0x20],rax
  104690:	48 c7 45 f8 00 00 00 	mov    QWORD PTR [rbp-0x8],0x0
  104697:	00 
  104698:	eb 13                	jmp    1046ad <c_str+0x44>
  10469a:	48 8b 55 e8          	mov    rdx,QWORD PTR [rbp-0x18]
  10469e:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1046a2:	48 01 d0             	add    rax,rdx
  1046a5:	c6 00 00             	mov    BYTE PTR [rax],0x0
  1046a8:	48 83 45 f8 01       	add    QWORD PTR [rbp-0x8],0x1
  1046ad:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1046b1:	48 3b 45 e0          	cmp    rax,QWORD PTR [rbp-0x20]
  1046b5:	72 e3                	jb     10469a <c_str+0x31>
  1046b7:	48 83 7d d8 00       	cmp    QWORD PTR [rbp-0x28],0x0
  1046bc:	75 10                	jne    1046ce <c_str+0x65>
  1046be:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  1046c2:	c6 00 30             	mov    BYTE PTR [rax],0x30
  1046c5:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  1046c9:	e9 b7 00 00 00       	jmp    104785 <c_str+0x11c>
  1046ce:	48 c7 45 f0 00 00 00 	mov    QWORD PTR [rbp-0x10],0x0
  1046d5:	00 
  1046d6:	e9 8f 00 00 00       	jmp    10476a <c_str+0x101>
  1046db:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
  1046df:	48 ba cd cc cc cc cc 	movabs rdx,0xcccccccccccccccd
  1046e6:	cc cc cc 
  1046e9:	48 89 c8             	mov    rax,rcx
  1046ec:	48 f7 e2             	mul    rdx
  1046ef:	48 c1 ea 03          	shr    rdx,0x3
  1046f3:	48 89 d0             	mov    rax,rdx
  1046f6:	48 c1 e0 02          	shl    rax,0x2
  1046fa:	48 01 d0             	add    rax,rdx
  1046fd:	48 01 c0             	add    rax,rax
  104700:	48 29 c1             	sub    rcx,rax
  104703:	48 89 ca             	mov    rdx,rcx
  104706:	89 d0                	mov    eax,edx
  104708:	8d 48 30             	lea    ecx,[rax+0x30]
  10470b:	48 8b 55 e8          	mov    rdx,QWORD PTR [rbp-0x18]
  10470f:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104713:	48 01 d0             	add    rax,rdx
  104716:	89 ca                	mov    edx,ecx
  104718:	88 10                	mov    BYTE PTR [rax],dl
  10471a:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
  10471e:	48 ba cd cc cc cc cc 	movabs rdx,0xcccccccccccccccd
  104725:	cc cc cc 
  104728:	48 89 c8             	mov    rax,rcx
  10472b:	48 f7 e2             	mul    rdx
  10472e:	48 c1 ea 03          	shr    rdx,0x3
  104732:	48 89 d0             	mov    rax,rdx
  104735:	48 c1 e0 02          	shl    rax,0x2
  104739:	48 01 d0             	add    rax,rdx
  10473c:	48 01 c0             	add    rax,rax
  10473f:	48 29 c1             	sub    rcx,rax
  104742:	48 89 ca             	mov    rdx,rcx
  104745:	48 29 55 d8          	sub    QWORD PTR [rbp-0x28],rdx
  104749:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  10474d:	48 ba cd cc cc cc cc 	movabs rdx,0xcccccccccccccccd
  104754:	cc cc cc 
  104757:	48 f7 e2             	mul    rdx
  10475a:	48 89 d0             	mov    rax,rdx
  10475d:	48 c1 e8 03          	shr    rax,0x3
  104761:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
  104765:	48 83 45 f0 01       	add    QWORD PTR [rbp-0x10],0x1
  10476a:	48 83 7d d8 00       	cmp    QWORD PTR [rbp-0x28],0x0
  10476f:	0f 85 66 ff ff ff    	jne    1046db <c_str+0x72>
  104775:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  104779:	48 89 c7             	mov    rdi,rax
  10477c:	e8 da fc ff ff       	call   10445b <reverse>
  104781:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  104785:	c9                   	leave  
  104786:	c3                   	ret    

0000000000104787 <hex_str>:
  104787:	55                   	push   rbp
  104788:	48 89 e5             	mov    rbp,rsp
  10478b:	48 89 7d d8          	mov    QWORD PTR [rbp-0x28],rdi
  10478f:	48 8d 05 25 20 00 00 	lea    rax,[rip+0x2025]        # 1067bb <bits_per_page+0x13>
  104796:	48 89 45 f0          	mov    QWORD PTR [rbp-0x10],rax
  10479a:	48 83 7d d8 00       	cmp    QWORD PTR [rbp-0x28],0x0
  10479f:	75 09                	jne    1047aa <hex_str+0x23>
  1047a1:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  1047a5:	e9 b1 00 00 00       	jmp    10485b <hex_str+0xd4>
  1047aa:	c7 45 fc 00 00 00 00 	mov    DWORD PTR [rbp-0x4],0x0
  1047b1:	e9 97 00 00 00       	jmp    10484d <hex_str+0xc6>
  1047b6:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  1047b9:	83 c0 01             	add    eax,0x1
  1047bc:	01 c0                	add    eax,eax
  1047be:	48 63 d0             	movsxd rdx,eax
  1047c1:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  1047c5:	48 01 d0             	add    rax,rdx
  1047c8:	48 89 45 e8          	mov    QWORD PTR [rbp-0x18],rax
  1047cc:	b8 07 00 00 00       	mov    eax,0x7
  1047d1:	2b 45 fc             	sub    eax,DWORD PTR [rbp-0x4]
  1047d4:	c1 e0 03             	shl    eax,0x3
  1047d7:	ba ff 00 00 00       	mov    edx,0xff
  1047dc:	89 c1                	mov    ecx,eax
  1047de:	48 d3 e2             	shl    rdx,cl
  1047e1:	48 89 d0             	mov    rax,rdx
  1047e4:	48 23 45 d8          	and    rax,QWORD PTR [rbp-0x28]
  1047e8:	48 89 c2             	mov    rdx,rax
  1047eb:	b8 07 00 00 00       	mov    eax,0x7
  1047f0:	2b 45 fc             	sub    eax,DWORD PTR [rbp-0x4]
  1047f3:	c1 e0 03             	shl    eax,0x3
  1047f6:	89 c1                	mov    ecx,eax
  1047f8:	48 d3 ea             	shr    rdx,cl
  1047fb:	48 89 d0             	mov    rax,rdx
  1047fe:	88 45 e7             	mov    BYTE PTR [rbp-0x19],al
  104801:	0f b6 45 e7          	movzx  eax,BYTE PTR [rbp-0x19]
  104805:	83 e0 0f             	and    eax,0xf
  104808:	88 45 fb             	mov    BYTE PTR [rbp-0x5],al
  10480b:	0f b6 45 e7          	movzx  eax,BYTE PTR [rbp-0x19]
  10480f:	c0 e8 04             	shr    al,0x4
  104812:	88 45 fa             	mov    BYTE PTR [rbp-0x6],al
  104815:	80 7d fb 09          	cmp    BYTE PTR [rbp-0x5],0x9
  104819:	76 04                	jbe    10481f <hex_str+0x98>
  10481b:	80 45 fb 07          	add    BYTE PTR [rbp-0x5],0x7
  10481f:	80 7d fa 09          	cmp    BYTE PTR [rbp-0x6],0x9
  104823:	76 04                	jbe    104829 <hex_str+0xa2>
  104825:	80 45 fa 07          	add    BYTE PTR [rbp-0x6],0x7
  104829:	0f b6 45 fb          	movzx  eax,BYTE PTR [rbp-0x5]
  10482d:	8d 50 30             	lea    edx,[rax+0x30]
  104830:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  104834:	48 83 c0 01          	add    rax,0x1
  104838:	88 10                	mov    BYTE PTR [rax],dl
  10483a:	0f b6 45 fa          	movzx  eax,BYTE PTR [rbp-0x6]
  10483e:	83 c0 30             	add    eax,0x30
  104841:	89 c2                	mov    edx,eax
  104843:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  104847:	88 10                	mov    BYTE PTR [rax],dl
  104849:	83 45 fc 01          	add    DWORD PTR [rbp-0x4],0x1
  10484d:	83 7d fc 07          	cmp    DWORD PTR [rbp-0x4],0x7
  104851:	0f 8e 5f ff ff ff    	jle    1047b6 <hex_str+0x2f>
  104857:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  10485b:	5d                   	pop    rbp
  10485c:	c3                   	ret    

000000000010485d <malloc>:
  10485d:	55                   	push   rbp
  10485e:	48 89 e5             	mov    rbp,rsp
  104861:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
  104865:	b8 00 00 00 00       	mov    eax,0x0
  10486a:	5d                   	pop    rbp
  10486b:	c3                   	ret    

000000000010486c <ParseELF>:
  10486c:	55                   	push   rbp
  10486d:	48 89 e5             	mov    rbp,rsp
  104870:	48 83 ec 20          	sub    rsp,0x20
  104874:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
  104878:	48 89 75 e0          	mov    QWORD PTR [rbp-0x20],rsi
  10487c:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  104880:	48 89 c7             	mov    rdi,rax
  104883:	e8 e0 00 00 00       	call   104968 <FileIsELF>
  104888:	84 c0                	test   al,al
  10488a:	75 0a                	jne    104896 <ParseELF+0x2a>
  10488c:	b8 00 00 00 00       	mov    eax,0x0
  104891:	e9 d0 00 00 00       	jmp    104966 <ParseELF+0xfa>
  104896:	bf 28 00 00 00       	mov    edi,0x28
  10489b:	e8 af e6 ff ff       	call   102f4f <kmalloc>
  1048a0:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  1048a4:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1048a8:	48 8b 55 e0          	mov    rdx,QWORD PTR [rbp-0x20]
  1048ac:	48 89 50 08          	mov    QWORD PTR [rax+0x8],rdx
  1048b0:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
  1048b4:	48 89 c7             	mov    rdi,rax
  1048b7:	e8 93 e6 ff ff       	call   102f4f <kmalloc>
  1048bc:	48 8b 55 f8          	mov    rdx,QWORD PTR [rbp-0x8]
  1048c0:	48 89 02             	mov    QWORD PTR [rdx],rax
  1048c3:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1048c7:	48 8b 00             	mov    rax,QWORD PTR [rax]
  1048ca:	48 8b 55 e0          	mov    rdx,QWORD PTR [rbp-0x20]
  1048ce:	48 8b 4d e8          	mov    rcx,QWORD PTR [rbp-0x18]
  1048d2:	48 89 ce             	mov    rsi,rcx
  1048d5:	48 89 c7             	mov    rdi,rax
  1048d8:	e8 8c fc ff ff       	call   104569 <memcpy>
  1048dd:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1048e1:	48 8b 00             	mov    rax,QWORD PTR [rax]
  1048e4:	48 89 c7             	mov    rdi,rax
  1048e7:	e8 5c 01 00 00       	call   104a48 <ParseELF_HEADER>
  1048ec:	48 8b 55 f8          	mov    rdx,QWORD PTR [rbp-0x8]
  1048f0:	48 89 42 10          	mov    QWORD PTR [rdx+0x10],rax
  1048f4:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1048f8:	48 8b 00             	mov    rax,QWORD PTR [rax]
  1048fb:	48 89 c2             	mov    rdx,rax
  1048fe:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  104902:	48 8b 40 10          	mov    rax,QWORD PTR [rax+0x10]
  104906:	48 8b 40 28          	mov    rax,QWORD PTR [rax+0x28]
  10490a:	48 01 d0             	add    rax,rdx
  10490d:	48 89 c2             	mov    rdx,rax
  104910:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  104914:	48 8b 40 10          	mov    rax,QWORD PTR [rax+0x10]
  104918:	48 89 d6             	mov    rsi,rdx
  10491b:	48 89 c7             	mov    rdi,rax
  10491e:	e8 6d 04 00 00       	call   104d90 <ParseELF_PRG_HEADER>
  104923:	48 8b 55 f8          	mov    rdx,QWORD PTR [rbp-0x8]
  104927:	48 89 42 18          	mov    QWORD PTR [rdx+0x18],rax
  10492b:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10492f:	48 8b 00             	mov    rax,QWORD PTR [rax]
  104932:	48 89 c2             	mov    rdx,rax
  104935:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  104939:	48 8b 40 10          	mov    rax,QWORD PTR [rax+0x10]
  10493d:	48 8b 40 30          	mov    rax,QWORD PTR [rax+0x30]
  104941:	48 01 d0             	add    rax,rdx
  104944:	48 89 c2             	mov    rdx,rax
  104947:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10494b:	48 8b 40 10          	mov    rax,QWORD PTR [rax+0x10]
  10494f:	48 89 d6             	mov    rsi,rdx
  104952:	48 89 c7             	mov    rdi,rax
  104955:	e8 00 0a 00 00       	call   10535a <ParseELF_SCT_HEADER>
  10495a:	48 8b 55 f8          	mov    rdx,QWORD PTR [rbp-0x8]
  10495e:	48 89 42 20          	mov    QWORD PTR [rdx+0x20],rax
  104962:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  104966:	c9                   	leave  
  104967:	c3                   	ret    

0000000000104968 <FileIsELF>:
  104968:	55                   	push   rbp
  104969:	48 89 e5             	mov    rbp,rsp
  10496c:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
  104970:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  104974:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  104977:	3c 7f                	cmp    al,0x7f
  104979:	75 34                	jne    1049af <FileIsELF+0x47>
  10497b:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10497f:	48 83 c0 01          	add    rax,0x1
  104983:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  104986:	3c 45                	cmp    al,0x45
  104988:	75 25                	jne    1049af <FileIsELF+0x47>
  10498a:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10498e:	48 83 c0 02          	add    rax,0x2
  104992:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  104995:	3c 4c                	cmp    al,0x4c
  104997:	75 16                	jne    1049af <FileIsELF+0x47>
  104999:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10499d:	48 83 c0 03          	add    rax,0x3
  1049a1:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  1049a4:	3c 46                	cmp    al,0x46
  1049a6:	75 07                	jne    1049af <FileIsELF+0x47>
  1049a8:	b8 01 00 00 00       	mov    eax,0x1
  1049ad:	eb 05                	jmp    1049b4 <FileIsELF+0x4c>
  1049af:	b8 00 00 00 00       	mov    eax,0x0
  1049b4:	5d                   	pop    rbp
  1049b5:	c3                   	ret    

00000000001049b6 <swap_uint16>:
  1049b6:	55                   	push   rbp
  1049b7:	48 89 e5             	mov    rbp,rsp
  1049ba:	89 f8                	mov    eax,edi
  1049bc:	66 89 45 fc          	mov    WORD PTR [rbp-0x4],ax
  1049c0:	0f b7 45 fc          	movzx  eax,WORD PTR [rbp-0x4]
  1049c4:	c1 e0 08             	shl    eax,0x8
  1049c7:	89 c2                	mov    edx,eax
  1049c9:	0f b7 45 fc          	movzx  eax,WORD PTR [rbp-0x4]
  1049cd:	66 c1 e8 08          	shr    ax,0x8
  1049d1:	09 d0                	or     eax,edx
  1049d3:	5d                   	pop    rbp
  1049d4:	c3                   	ret    

00000000001049d5 <swap_uint32>:
  1049d5:	55                   	push   rbp
  1049d6:	48 89 e5             	mov    rbp,rsp
  1049d9:	89 7d fc             	mov    DWORD PTR [rbp-0x4],edi
  1049dc:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  1049df:	c1 e0 08             	shl    eax,0x8
  1049e2:	25 00 ff 00 ff       	and    eax,0xff00ff00
  1049e7:	89 c2                	mov    edx,eax
  1049e9:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  1049ec:	c1 e8 08             	shr    eax,0x8
  1049ef:	25 ff 00 ff 00       	and    eax,0xff00ff
  1049f4:	09 d0                	or     eax,edx
  1049f6:	89 45 fc             	mov    DWORD PTR [rbp-0x4],eax
  1049f9:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  1049fc:	c1 c0 10             	rol    eax,0x10
  1049ff:	5d                   	pop    rbp
  104a00:	c3                   	ret    

0000000000104a01 <swap_uintptr>:
  104a01:	55                   	push   rbp
  104a02:	48 89 e5             	mov    rbp,rsp
  104a05:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
  104a09:	c7 45 fc 07 00 00 00 	mov    DWORD PTR [rbp-0x4],0x7
  104a10:	eb 2a                	jmp    104a3c <swap_uintptr+0x3b>
  104a12:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  104a15:	48 98                	cdqe   
  104a17:	48 8d 55 e8          	lea    rdx,[rbp-0x18]
  104a1b:	48 01 d0             	add    rax,rdx
  104a1e:	8b 55 fc             	mov    edx,DWORD PTR [rbp-0x4]
  104a21:	48 63 d2             	movsxd rdx,edx
  104a24:	b9 07 00 00 00       	mov    ecx,0x7
  104a29:	48 29 d1             	sub    rcx,rdx
  104a2c:	48 8d 55 f0          	lea    rdx,[rbp-0x10]
  104a30:	48 01 ca             	add    rdx,rcx
  104a33:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  104a36:	88 02                	mov    BYTE PTR [rdx],al
  104a38:	83 6d fc 01          	sub    DWORD PTR [rbp-0x4],0x1
  104a3c:	83 7d fc 00          	cmp    DWORD PTR [rbp-0x4],0x0
  104a40:	79 d0                	jns    104a12 <swap_uintptr+0x11>
  104a42:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104a46:	5d                   	pop    rbp
  104a47:	c3                   	ret    

0000000000104a48 <ParseELF_HEADER>:
  104a48:	55                   	push   rbp
  104a49:	48 89 e5             	mov    rbp,rsp
  104a4c:	48 83 ec 20          	sub    rsp,0x20
  104a50:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
  104a54:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  104a58:	48 89 c7             	mov    rdi,rax
  104a5b:	e8 08 ff ff ff       	call   104968 <FileIsELF>
  104a60:	84 c0                	test   al,al
  104a62:	75 0a                	jne    104a6e <ParseELF_HEADER+0x26>
  104a64:	b8 00 00 00 00       	mov    eax,0x0
  104a69:	e9 20 03 00 00       	jmp    104d8e <ParseELF_HEADER+0x346>
  104a6e:	bf 48 00 00 00       	mov    edi,0x48
  104a73:	e8 d7 e4 ff ff       	call   102f4f <kmalloc>
  104a78:	48 89 45 f0          	mov    QWORD PTR [rbp-0x10],rax
  104a7c:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104a80:	48 8b 55 e8          	mov    rdx,QWORD PTR [rbp-0x18]
  104a84:	48 89 10             	mov    QWORD PTR [rax],rdx
  104a87:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104a8b:	48 8b 55 e8          	mov    rdx,QWORD PTR [rbp-0x18]
  104a8f:	48 89 50 10          	mov    QWORD PTR [rax+0x10],rdx
  104a93:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  104a97:	0f b7 50 10          	movzx  edx,WORD PTR [rax+0x10]
  104a9b:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104a9f:	66 89 50 18          	mov    WORD PTR [rax+0x18],dx
  104aa3:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  104aa7:	0f b7 50 12          	movzx  edx,WORD PTR [rax+0x12]
  104aab:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104aaf:	66 89 50 1a          	mov    WORD PTR [rax+0x1a],dx
  104ab3:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  104ab7:	8b 50 14             	mov    edx,DWORD PTR [rax+0x14]
  104aba:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104abe:	89 50 1c             	mov    DWORD PTR [rax+0x1c],edx
  104ac1:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  104ac5:	48 8b 50 18          	mov    rdx,QWORD PTR [rax+0x18]
  104ac9:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104acd:	48 89 50 20          	mov    QWORD PTR [rax+0x20],rdx
  104ad1:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104ad5:	48 8b 40 10          	mov    rax,QWORD PTR [rax+0x10]
  104ad9:	48 83 c0 04          	add    rax,0x4
  104add:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  104ae0:	3c 02                	cmp    al,0x2
  104ae2:	75 29                	jne    104b0d <ParseELF_HEADER+0xc5>
  104ae4:	c7 45 fc 30 00 00 00 	mov    DWORD PTR [rbp-0x4],0x30
  104aeb:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  104aef:	48 8b 50 20          	mov    rdx,QWORD PTR [rax+0x20]
  104af3:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104af7:	48 89 50 28          	mov    QWORD PTR [rax+0x28],rdx
  104afb:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  104aff:	48 8b 50 28          	mov    rdx,QWORD PTR [rax+0x28]
  104b03:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104b07:	48 89 50 30          	mov    QWORD PTR [rax+0x30],rdx
  104b0b:	eb 27                	jmp    104b34 <ParseELF_HEADER+0xec>
  104b0d:	c7 45 fc 24 00 00 00 	mov    DWORD PTR [rbp-0x4],0x24
  104b14:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  104b18:	48 8b 50 1c          	mov    rdx,QWORD PTR [rax+0x1c]
  104b1c:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104b20:	48 89 50 28          	mov    QWORD PTR [rax+0x28],rdx
  104b24:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  104b28:	48 8b 50 20          	mov    rdx,QWORD PTR [rax+0x20]
  104b2c:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104b30:	48 89 50 30          	mov    QWORD PTR [rax+0x30],rdx
  104b34:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  104b37:	48 63 d0             	movsxd rdx,eax
  104b3a:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  104b3e:	48 01 d0             	add    rax,rdx
  104b41:	8b 10                	mov    edx,DWORD PTR [rax]
  104b43:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104b47:	89 50 38             	mov    DWORD PTR [rax+0x38],edx
  104b4a:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  104b4d:	48 98                	cdqe   
  104b4f:	48 8d 50 04          	lea    rdx,[rax+0x4]
  104b53:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  104b57:	48 01 d0             	add    rax,rdx
  104b5a:	0f b7 10             	movzx  edx,WORD PTR [rax]
  104b5d:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104b61:	66 89 50 3c          	mov    WORD PTR [rax+0x3c],dx
  104b65:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  104b68:	48 98                	cdqe   
  104b6a:	48 8d 50 06          	lea    rdx,[rax+0x6]
  104b6e:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  104b72:	48 01 d0             	add    rax,rdx
  104b75:	0f b7 10             	movzx  edx,WORD PTR [rax]
  104b78:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104b7c:	66 89 50 3e          	mov    WORD PTR [rax+0x3e],dx
  104b80:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  104b83:	48 98                	cdqe   
  104b85:	48 8d 50 08          	lea    rdx,[rax+0x8]
  104b89:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  104b8d:	48 01 d0             	add    rax,rdx
  104b90:	0f b7 10             	movzx  edx,WORD PTR [rax]
  104b93:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104b97:	66 89 50 40          	mov    WORD PTR [rax+0x40],dx
  104b9b:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  104b9e:	48 98                	cdqe   
  104ba0:	48 8d 50 0a          	lea    rdx,[rax+0xa]
  104ba4:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  104ba8:	48 01 d0             	add    rax,rdx
  104bab:	0f b7 10             	movzx  edx,WORD PTR [rax]
  104bae:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104bb2:	66 89 50 42          	mov    WORD PTR [rax+0x42],dx
  104bb6:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  104bb9:	48 98                	cdqe   
  104bbb:	48 8d 50 0c          	lea    rdx,[rax+0xc]
  104bbf:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  104bc3:	48 01 d0             	add    rax,rdx
  104bc6:	0f b7 10             	movzx  edx,WORD PTR [rax]
  104bc9:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104bcd:	66 89 50 44          	mov    WORD PTR [rax+0x44],dx
  104bd1:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  104bd4:	48 98                	cdqe   
  104bd6:	48 8d 50 0e          	lea    rdx,[rax+0xe]
  104bda:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  104bde:	48 01 d0             	add    rax,rdx
  104be1:	0f b7 10             	movzx  edx,WORD PTR [rax]
  104be4:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104be8:	66 89 50 46          	mov    WORD PTR [rax+0x46],dx
  104bec:	8b 05 e6 14 00 00    	mov    eax,DWORD PTR [rip+0x14e6]        # 1060d8 <isLittleEndian>
  104bf2:	85 c0                	test   eax,eax
  104bf4:	74 13                	je     104c09 <ParseELF_HEADER+0x1c1>
  104bf6:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104bfa:	48 8b 40 10          	mov    rax,QWORD PTR [rax+0x10]
  104bfe:	48 83 c0 05          	add    rax,0x5
  104c02:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  104c05:	3c 02                	cmp    al,0x2
  104c07:	74 25                	je     104c2e <ParseELF_HEADER+0x1e6>
  104c09:	8b 05 cd 14 00 00    	mov    eax,DWORD PTR [rip+0x14cd]        # 1060dc <isBigEndian>
  104c0f:	85 c0                	test   eax,eax
  104c11:	0f 84 73 01 00 00    	je     104d8a <ParseELF_HEADER+0x342>
  104c17:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104c1b:	48 8b 40 10          	mov    rax,QWORD PTR [rax+0x10]
  104c1f:	48 83 c0 05          	add    rax,0x5
  104c23:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  104c26:	3c 01                	cmp    al,0x1
  104c28:	0f 85 5c 01 00 00    	jne    104d8a <ParseELF_HEADER+0x342>
  104c2e:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104c32:	0f b7 40 18          	movzx  eax,WORD PTR [rax+0x18]
  104c36:	0f b7 c0             	movzx  eax,ax
  104c39:	89 c7                	mov    edi,eax
  104c3b:	e8 76 fd ff ff       	call   1049b6 <swap_uint16>
  104c40:	48 8b 55 f0          	mov    rdx,QWORD PTR [rbp-0x10]
  104c44:	66 89 42 18          	mov    WORD PTR [rdx+0x18],ax
  104c48:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104c4c:	0f b7 40 1a          	movzx  eax,WORD PTR [rax+0x1a]
  104c50:	0f b7 c0             	movzx  eax,ax
  104c53:	89 c7                	mov    edi,eax
  104c55:	e8 5c fd ff ff       	call   1049b6 <swap_uint16>
  104c5a:	48 8b 55 f0          	mov    rdx,QWORD PTR [rbp-0x10]
  104c5e:	66 89 42 1a          	mov    WORD PTR [rdx+0x1a],ax
  104c62:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104c66:	0f b7 40 1a          	movzx  eax,WORD PTR [rax+0x1a]
  104c6a:	0f b7 c0             	movzx  eax,ax
  104c6d:	89 c7                	mov    edi,eax
  104c6f:	e8 42 fd ff ff       	call   1049b6 <swap_uint16>
  104c74:	48 8b 55 f0          	mov    rdx,QWORD PTR [rbp-0x10]
  104c78:	66 89 42 1a          	mov    WORD PTR [rdx+0x1a],ax
  104c7c:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104c80:	8b 40 1c             	mov    eax,DWORD PTR [rax+0x1c]
  104c83:	89 c7                	mov    edi,eax
  104c85:	e8 4b fd ff ff       	call   1049d5 <swap_uint32>
  104c8a:	48 8b 55 f0          	mov    rdx,QWORD PTR [rbp-0x10]
  104c8e:	89 42 1c             	mov    DWORD PTR [rdx+0x1c],eax
  104c91:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104c95:	48 8b 40 20          	mov    rax,QWORD PTR [rax+0x20]
  104c99:	48 89 c7             	mov    rdi,rax
  104c9c:	e8 60 fd ff ff       	call   104a01 <swap_uintptr>
  104ca1:	48 8b 55 f0          	mov    rdx,QWORD PTR [rbp-0x10]
  104ca5:	48 89 42 20          	mov    QWORD PTR [rdx+0x20],rax
  104ca9:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104cad:	48 8b 40 28          	mov    rax,QWORD PTR [rax+0x28]
  104cb1:	48 89 c7             	mov    rdi,rax
  104cb4:	e8 48 fd ff ff       	call   104a01 <swap_uintptr>
  104cb9:	48 8b 55 f0          	mov    rdx,QWORD PTR [rbp-0x10]
  104cbd:	48 89 42 28          	mov    QWORD PTR [rdx+0x28],rax
  104cc1:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104cc5:	48 8b 40 28          	mov    rax,QWORD PTR [rax+0x28]
  104cc9:	48 89 c7             	mov    rdi,rax
  104ccc:	e8 30 fd ff ff       	call   104a01 <swap_uintptr>
  104cd1:	48 8b 55 f0          	mov    rdx,QWORD PTR [rbp-0x10]
  104cd5:	48 89 42 30          	mov    QWORD PTR [rdx+0x30],rax
  104cd9:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104cdd:	8b 40 38             	mov    eax,DWORD PTR [rax+0x38]
  104ce0:	89 c7                	mov    edi,eax
  104ce2:	e8 ee fc ff ff       	call   1049d5 <swap_uint32>
  104ce7:	48 8b 55 f0          	mov    rdx,QWORD PTR [rbp-0x10]
  104ceb:	89 42 38             	mov    DWORD PTR [rdx+0x38],eax
  104cee:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104cf2:	0f b7 40 3c          	movzx  eax,WORD PTR [rax+0x3c]
  104cf6:	0f b7 c0             	movzx  eax,ax
  104cf9:	89 c7                	mov    edi,eax
  104cfb:	e8 b6 fc ff ff       	call   1049b6 <swap_uint16>
  104d00:	48 8b 55 f0          	mov    rdx,QWORD PTR [rbp-0x10]
  104d04:	66 89 42 3c          	mov    WORD PTR [rdx+0x3c],ax
  104d08:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104d0c:	0f b7 40 3e          	movzx  eax,WORD PTR [rax+0x3e]
  104d10:	0f b7 c0             	movzx  eax,ax
  104d13:	89 c7                	mov    edi,eax
  104d15:	e8 9c fc ff ff       	call   1049b6 <swap_uint16>
  104d1a:	48 8b 55 f0          	mov    rdx,QWORD PTR [rbp-0x10]
  104d1e:	66 89 42 3e          	mov    WORD PTR [rdx+0x3e],ax
  104d22:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104d26:	0f b7 40 40          	movzx  eax,WORD PTR [rax+0x40]
  104d2a:	0f b7 c0             	movzx  eax,ax
  104d2d:	89 c7                	mov    edi,eax
  104d2f:	e8 82 fc ff ff       	call   1049b6 <swap_uint16>
  104d34:	48 8b 55 f0          	mov    rdx,QWORD PTR [rbp-0x10]
  104d38:	66 89 42 40          	mov    WORD PTR [rdx+0x40],ax
  104d3c:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104d40:	0f b7 40 42          	movzx  eax,WORD PTR [rax+0x42]
  104d44:	0f b7 c0             	movzx  eax,ax
  104d47:	89 c7                	mov    edi,eax
  104d49:	e8 68 fc ff ff       	call   1049b6 <swap_uint16>
  104d4e:	48 8b 55 f0          	mov    rdx,QWORD PTR [rbp-0x10]
  104d52:	66 89 42 42          	mov    WORD PTR [rdx+0x42],ax
  104d56:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104d5a:	0f b7 40 44          	movzx  eax,WORD PTR [rax+0x44]
  104d5e:	0f b7 c0             	movzx  eax,ax
  104d61:	89 c7                	mov    edi,eax
  104d63:	e8 4e fc ff ff       	call   1049b6 <swap_uint16>
  104d68:	48 8b 55 f0          	mov    rdx,QWORD PTR [rbp-0x10]
  104d6c:	66 89 42 44          	mov    WORD PTR [rdx+0x44],ax
  104d70:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104d74:	0f b7 40 46          	movzx  eax,WORD PTR [rax+0x46]
  104d78:	0f b7 c0             	movzx  eax,ax
  104d7b:	89 c7                	mov    edi,eax
  104d7d:	e8 34 fc ff ff       	call   1049b6 <swap_uint16>
  104d82:	48 8b 55 f0          	mov    rdx,QWORD PTR [rbp-0x10]
  104d86:	66 89 42 46          	mov    WORD PTR [rdx+0x46],ax
  104d8a:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  104d8e:	c9                   	leave  
  104d8f:	c3                   	ret    

0000000000104d90 <ParseELF_PRG_HEADER>:
  104d90:	55                   	push   rbp
  104d91:	48 89 e5             	mov    rbp,rsp
  104d94:	53                   	push   rbx
  104d95:	48 83 ec 38          	sub    rsp,0x38
  104d99:	48 89 7d c8          	mov    QWORD PTR [rbp-0x38],rdi
  104d9d:	48 89 75 c0          	mov    QWORD PTR [rbp-0x40],rsi
  104da1:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
  104da5:	0f b7 40 40          	movzx  eax,WORD PTR [rax+0x40]
  104da9:	0f b7 d0             	movzx  edx,ax
  104dac:	48 89 d0             	mov    rax,rdx
  104daf:	48 c1 e0 03          	shl    rax,0x3
  104db3:	48 01 d0             	add    rax,rdx
  104db6:	48 c1 e0 03          	shl    rax,0x3
  104dba:	48 89 c7             	mov    rdi,rax
  104dbd:	e8 8d e1 ff ff       	call   102f4f <kmalloc>
  104dc2:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
  104dc6:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
  104dca:	48 8b 40 10          	mov    rax,QWORD PTR [rax+0x10]
  104dce:	48 83 c0 04          	add    rax,0x4
  104dd2:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  104dd5:	3c 02                	cmp    al,0x2
  104dd7:	75 10                	jne    104de9 <ParseELF_PRG_HEADER+0x59>
  104dd9:	c7 45 ec 38 00 00 00 	mov    DWORD PTR [rbp-0x14],0x38
  104de0:	c7 45 e8 08 00 00 00 	mov    DWORD PTR [rbp-0x18],0x8
  104de7:	eb 0e                	jmp    104df7 <ParseELF_PRG_HEADER+0x67>
  104de9:	c7 45 ec 20 00 00 00 	mov    DWORD PTR [rbp-0x14],0x20
  104df0:	c7 45 e8 04 00 00 00 	mov    DWORD PTR [rbp-0x18],0x4
  104df7:	66 c7 45 e6 00 00    	mov    WORD PTR [rbp-0x1a],0x0
  104dfd:	e9 3b 05 00 00       	jmp    10533d <ParseELF_PRG_HEADER+0x5ad>
  104e02:	0f b7 45 e6          	movzx  eax,WORD PTR [rbp-0x1a]
  104e06:	0f af 45 ec          	imul   eax,DWORD PTR [rbp-0x14]
  104e0a:	48 63 d0             	movsxd rdx,eax
  104e0d:	48 8b 45 c0          	mov    rax,QWORD PTR [rbp-0x40]
  104e11:	48 01 d0             	add    rax,rdx
  104e14:	48 89 45 d0          	mov    QWORD PTR [rbp-0x30],rax
  104e18:	0f b7 55 e6          	movzx  edx,WORD PTR [rbp-0x1a]
  104e1c:	48 89 d0             	mov    rax,rdx
  104e1f:	48 c1 e0 03          	shl    rax,0x3
  104e23:	48 01 d0             	add    rax,rdx
  104e26:	48 c1 e0 03          	shl    rax,0x3
  104e2a:	48 89 c2             	mov    rdx,rax
  104e2d:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  104e31:	48 01 c2             	add    rdx,rax
  104e34:	48 8b 45 d0          	mov    rax,QWORD PTR [rbp-0x30]
  104e38:	48 89 02             	mov    QWORD PTR [rdx],rax
  104e3b:	0f b7 55 e6          	movzx  edx,WORD PTR [rbp-0x1a]
  104e3f:	48 89 d0             	mov    rax,rdx
  104e42:	48 c1 e0 03          	shl    rax,0x3
  104e46:	48 01 d0             	add    rax,rdx
  104e49:	48 c1 e0 03          	shl    rax,0x3
  104e4d:	48 89 c2             	mov    rdx,rax
  104e50:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  104e54:	48 01 c2             	add    rdx,rax
  104e57:	8b 45 ec             	mov    eax,DWORD PTR [rbp-0x14]
  104e5a:	48 98                	cdqe   
  104e5c:	48 89 42 08          	mov    QWORD PTR [rdx+0x8],rax
  104e60:	0f b7 55 e6          	movzx  edx,WORD PTR [rbp-0x1a]
  104e64:	48 89 d0             	mov    rax,rdx
  104e67:	48 c1 e0 03          	shl    rax,0x3
  104e6b:	48 01 d0             	add    rax,rdx
  104e6e:	48 c1 e0 03          	shl    rax,0x3
  104e72:	48 89 c2             	mov    rdx,rax
  104e75:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  104e79:	48 01 c2             	add    rdx,rax
  104e7c:	48 8b 45 d0          	mov    rax,QWORD PTR [rbp-0x30]
  104e80:	8b 00                	mov    eax,DWORD PTR [rax]
  104e82:	89 42 10             	mov    DWORD PTR [rdx+0x10],eax
  104e85:	8b 45 e8             	mov    eax,DWORD PTR [rbp-0x18]
  104e88:	48 63 d0             	movsxd rdx,eax
  104e8b:	48 8b 45 d0          	mov    rax,QWORD PTR [rbp-0x30]
  104e8f:	48 8d 0c 02          	lea    rcx,[rdx+rax*1]
  104e93:	0f b7 55 e6          	movzx  edx,WORD PTR [rbp-0x1a]
  104e97:	48 89 d0             	mov    rax,rdx
  104e9a:	48 c1 e0 03          	shl    rax,0x3
  104e9e:	48 01 d0             	add    rax,rdx
  104ea1:	48 c1 e0 03          	shl    rax,0x3
  104ea5:	48 89 c2             	mov    rdx,rax
  104ea8:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  104eac:	48 01 c2             	add    rdx,rax
  104eaf:	48 8b 01             	mov    rax,QWORD PTR [rcx]
  104eb2:	48 89 42 18          	mov    QWORD PTR [rdx+0x18],rax
  104eb6:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
  104eba:	48 8b 40 10          	mov    rax,QWORD PTR [rax+0x10]
  104ebe:	48 83 c0 04          	add    rax,0x4
  104ec2:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  104ec5:	3c 02                	cmp    al,0x2
  104ec7:	0f 85 f3 00 00 00    	jne    104fc0 <ParseELF_PRG_HEADER+0x230>
  104ecd:	0f b7 55 e6          	movzx  edx,WORD PTR [rbp-0x1a]
  104ed1:	48 89 d0             	mov    rax,rdx
  104ed4:	48 c1 e0 03          	shl    rax,0x3
  104ed8:	48 01 d0             	add    rax,rdx
  104edb:	48 c1 e0 03          	shl    rax,0x3
  104edf:	48 89 c2             	mov    rdx,rax
  104ee2:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  104ee6:	48 01 c2             	add    rdx,rax
  104ee9:	48 8b 45 d0          	mov    rax,QWORD PTR [rbp-0x30]
  104eed:	48 8b 40 10          	mov    rax,QWORD PTR [rax+0x10]
  104ef1:	48 89 42 20          	mov    QWORD PTR [rdx+0x20],rax
  104ef5:	0f b7 55 e6          	movzx  edx,WORD PTR [rbp-0x1a]
  104ef9:	48 89 d0             	mov    rax,rdx
  104efc:	48 c1 e0 03          	shl    rax,0x3
  104f00:	48 01 d0             	add    rax,rdx
  104f03:	48 c1 e0 03          	shl    rax,0x3
  104f07:	48 89 c2             	mov    rdx,rax
  104f0a:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  104f0e:	48 01 c2             	add    rdx,rax
  104f11:	48 8b 45 d0          	mov    rax,QWORD PTR [rbp-0x30]
  104f15:	48 8b 40 18          	mov    rax,QWORD PTR [rax+0x18]
  104f19:	48 89 42 28          	mov    QWORD PTR [rdx+0x28],rax
  104f1d:	0f b7 55 e6          	movzx  edx,WORD PTR [rbp-0x1a]
  104f21:	48 89 d0             	mov    rax,rdx
  104f24:	48 c1 e0 03          	shl    rax,0x3
  104f28:	48 01 d0             	add    rax,rdx
  104f2b:	48 c1 e0 03          	shl    rax,0x3
  104f2f:	48 89 c2             	mov    rdx,rax
  104f32:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  104f36:	48 01 c2             	add    rdx,rax
  104f39:	48 8b 45 d0          	mov    rax,QWORD PTR [rbp-0x30]
  104f3d:	48 8b 40 20          	mov    rax,QWORD PTR [rax+0x20]
  104f41:	48 89 42 30          	mov    QWORD PTR [rdx+0x30],rax
  104f45:	0f b7 55 e6          	movzx  edx,WORD PTR [rbp-0x1a]
  104f49:	48 89 d0             	mov    rax,rdx
  104f4c:	48 c1 e0 03          	shl    rax,0x3
  104f50:	48 01 d0             	add    rax,rdx
  104f53:	48 c1 e0 03          	shl    rax,0x3
  104f57:	48 89 c2             	mov    rdx,rax
  104f5a:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  104f5e:	48 01 c2             	add    rdx,rax
  104f61:	48 8b 45 d0          	mov    rax,QWORD PTR [rbp-0x30]
  104f65:	48 8b 40 28          	mov    rax,QWORD PTR [rax+0x28]
  104f69:	48 89 42 38          	mov    QWORD PTR [rdx+0x38],rax
  104f6d:	0f b7 55 e6          	movzx  edx,WORD PTR [rbp-0x1a]
  104f71:	48 89 d0             	mov    rax,rdx
  104f74:	48 c1 e0 03          	shl    rax,0x3
  104f78:	48 01 d0             	add    rax,rdx
  104f7b:	48 c1 e0 03          	shl    rax,0x3
  104f7f:	48 89 c2             	mov    rdx,rax
  104f82:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  104f86:	48 01 c2             	add    rdx,rax
  104f89:	48 8b 45 d0          	mov    rax,QWORD PTR [rbp-0x30]
  104f8d:	48 8b 40 30          	mov    rax,QWORD PTR [rax+0x30]
  104f91:	48 89 42 40          	mov    QWORD PTR [rdx+0x40],rax
  104f95:	0f b7 55 e6          	movzx  edx,WORD PTR [rbp-0x1a]
  104f99:	48 89 d0             	mov    rax,rdx
  104f9c:	48 c1 e0 03          	shl    rax,0x3
  104fa0:	48 01 d0             	add    rax,rdx
  104fa3:	48 c1 e0 03          	shl    rax,0x3
  104fa7:	48 89 c2             	mov    rdx,rax
  104faa:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  104fae:	48 01 c2             	add    rdx,rax
  104fb1:	48 8b 45 d0          	mov    rax,QWORD PTR [rbp-0x30]
  104fb5:	8b 40 04             	mov    eax,DWORD PTR [rax+0x4]
  104fb8:	89 42 14             	mov    DWORD PTR [rdx+0x14],eax
  104fbb:	e9 ee 00 00 00       	jmp    1050ae <ParseELF_PRG_HEADER+0x31e>
  104fc0:	0f b7 55 e6          	movzx  edx,WORD PTR [rbp-0x1a]
  104fc4:	48 89 d0             	mov    rax,rdx
  104fc7:	48 c1 e0 03          	shl    rax,0x3
  104fcb:	48 01 d0             	add    rax,rdx
  104fce:	48 c1 e0 03          	shl    rax,0x3
  104fd2:	48 89 c2             	mov    rdx,rax
  104fd5:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  104fd9:	48 01 c2             	add    rdx,rax
  104fdc:	48 8b 45 d0          	mov    rax,QWORD PTR [rbp-0x30]
  104fe0:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
  104fe4:	48 89 42 20          	mov    QWORD PTR [rdx+0x20],rax
  104fe8:	0f b7 55 e6          	movzx  edx,WORD PTR [rbp-0x1a]
  104fec:	48 89 d0             	mov    rax,rdx
  104fef:	48 c1 e0 03          	shl    rax,0x3
  104ff3:	48 01 d0             	add    rax,rdx
  104ff6:	48 c1 e0 03          	shl    rax,0x3
  104ffa:	48 89 c2             	mov    rdx,rax
  104ffd:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  105001:	48 01 c2             	add    rdx,rax
  105004:	48 8b 45 d0          	mov    rax,QWORD PTR [rbp-0x30]
  105008:	48 8b 40 0c          	mov    rax,QWORD PTR [rax+0xc]
  10500c:	48 89 42 28          	mov    QWORD PTR [rdx+0x28],rax
  105010:	0f b7 55 e6          	movzx  edx,WORD PTR [rbp-0x1a]
  105014:	48 89 d0             	mov    rax,rdx
  105017:	48 c1 e0 03          	shl    rax,0x3
  10501b:	48 01 d0             	add    rax,rdx
  10501e:	48 c1 e0 03          	shl    rax,0x3
  105022:	48 89 c2             	mov    rdx,rax
  105025:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  105029:	48 01 c2             	add    rdx,rax
  10502c:	48 8b 45 d0          	mov    rax,QWORD PTR [rbp-0x30]
  105030:	48 8b 40 10          	mov    rax,QWORD PTR [rax+0x10]
  105034:	48 89 42 30          	mov    QWORD PTR [rdx+0x30],rax
  105038:	0f b7 55 e6          	movzx  edx,WORD PTR [rbp-0x1a]
  10503c:	48 89 d0             	mov    rax,rdx
  10503f:	48 c1 e0 03          	shl    rax,0x3
  105043:	48 01 d0             	add    rax,rdx
  105046:	48 c1 e0 03          	shl    rax,0x3
  10504a:	48 89 c2             	mov    rdx,rax
  10504d:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  105051:	48 01 c2             	add    rdx,rax
  105054:	48 8b 45 d0          	mov    rax,QWORD PTR [rbp-0x30]
  105058:	48 8b 40 14          	mov    rax,QWORD PTR [rax+0x14]
  10505c:	48 89 42 38          	mov    QWORD PTR [rdx+0x38],rax
  105060:	0f b7 55 e6          	movzx  edx,WORD PTR [rbp-0x1a]
  105064:	48 89 d0             	mov    rax,rdx
  105067:	48 c1 e0 03          	shl    rax,0x3
  10506b:	48 01 d0             	add    rax,rdx
  10506e:	48 c1 e0 03          	shl    rax,0x3
  105072:	48 89 c2             	mov    rdx,rax
  105075:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  105079:	48 01 c2             	add    rdx,rax
  10507c:	48 8b 45 d0          	mov    rax,QWORD PTR [rbp-0x30]
  105080:	48 8b 40 1c          	mov    rax,QWORD PTR [rax+0x1c]
  105084:	48 89 42 40          	mov    QWORD PTR [rdx+0x40],rax
  105088:	0f b7 55 e6          	movzx  edx,WORD PTR [rbp-0x1a]
  10508c:	48 89 d0             	mov    rax,rdx
  10508f:	48 c1 e0 03          	shl    rax,0x3
  105093:	48 01 d0             	add    rax,rdx
  105096:	48 c1 e0 03          	shl    rax,0x3
  10509a:	48 89 c2             	mov    rdx,rax
  10509d:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1050a1:	48 01 c2             	add    rdx,rax
  1050a4:	48 8b 45 d0          	mov    rax,QWORD PTR [rbp-0x30]
  1050a8:	8b 40 18             	mov    eax,DWORD PTR [rax+0x18]
  1050ab:	89 42 14             	mov    DWORD PTR [rdx+0x14],eax
  1050ae:	8b 05 24 10 00 00    	mov    eax,DWORD PTR [rip+0x1024]        # 1060d8 <isLittleEndian>
  1050b4:	85 c0                	test   eax,eax
  1050b6:	74 13                	je     1050cb <ParseELF_PRG_HEADER+0x33b>
  1050b8:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
  1050bc:	48 8b 40 10          	mov    rax,QWORD PTR [rax+0x10]
  1050c0:	48 83 c0 05          	add    rax,0x5
  1050c4:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  1050c7:	3c 02                	cmp    al,0x2
  1050c9:	74 25                	je     1050f0 <ParseELF_PRG_HEADER+0x360>
  1050cb:	8b 05 0b 10 00 00    	mov    eax,DWORD PTR [rip+0x100b]        # 1060dc <isBigEndian>
  1050d1:	85 c0                	test   eax,eax
  1050d3:	0f 84 59 02 00 00    	je     105332 <ParseELF_PRG_HEADER+0x5a2>
  1050d9:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
  1050dd:	48 8b 40 10          	mov    rax,QWORD PTR [rax+0x10]
  1050e1:	48 83 c0 05          	add    rax,0x5
  1050e5:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  1050e8:	3c 01                	cmp    al,0x1
  1050ea:	0f 85 42 02 00 00    	jne    105332 <ParseELF_PRG_HEADER+0x5a2>
  1050f0:	0f b7 55 e6          	movzx  edx,WORD PTR [rbp-0x1a]
  1050f4:	48 89 d0             	mov    rax,rdx
  1050f7:	48 c1 e0 03          	shl    rax,0x3
  1050fb:	48 01 d0             	add    rax,rdx
  1050fe:	48 c1 e0 03          	shl    rax,0x3
  105102:	48 89 c2             	mov    rdx,rax
  105105:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  105109:	48 01 d0             	add    rax,rdx
  10510c:	8b 48 10             	mov    ecx,DWORD PTR [rax+0x10]
  10510f:	0f b7 55 e6          	movzx  edx,WORD PTR [rbp-0x1a]
  105113:	48 89 d0             	mov    rax,rdx
  105116:	48 c1 e0 03          	shl    rax,0x3
  10511a:	48 01 d0             	add    rax,rdx
  10511d:	48 c1 e0 03          	shl    rax,0x3
  105121:	48 89 c2             	mov    rdx,rax
  105124:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  105128:	48 8d 1c 02          	lea    rbx,[rdx+rax*1]
  10512c:	89 cf                	mov    edi,ecx
  10512e:	e8 a2 f8 ff ff       	call   1049d5 <swap_uint32>
  105133:	89 43 10             	mov    DWORD PTR [rbx+0x10],eax
  105136:	0f b7 55 e6          	movzx  edx,WORD PTR [rbp-0x1a]
  10513a:	48 89 d0             	mov    rax,rdx
  10513d:	48 c1 e0 03          	shl    rax,0x3
  105141:	48 01 d0             	add    rax,rdx
  105144:	48 c1 e0 03          	shl    rax,0x3
  105148:	48 89 c2             	mov    rdx,rax
  10514b:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  10514f:	48 01 d0             	add    rax,rdx
  105152:	8b 48 14             	mov    ecx,DWORD PTR [rax+0x14]
  105155:	0f b7 55 e6          	movzx  edx,WORD PTR [rbp-0x1a]
  105159:	48 89 d0             	mov    rax,rdx
  10515c:	48 c1 e0 03          	shl    rax,0x3
  105160:	48 01 d0             	add    rax,rdx
  105163:	48 c1 e0 03          	shl    rax,0x3
  105167:	48 89 c2             	mov    rdx,rax
  10516a:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  10516e:	48 8d 1c 02          	lea    rbx,[rdx+rax*1]
  105172:	89 cf                	mov    edi,ecx
  105174:	e8 5c f8 ff ff       	call   1049d5 <swap_uint32>
  105179:	89 43 14             	mov    DWORD PTR [rbx+0x14],eax
  10517c:	0f b7 55 e6          	movzx  edx,WORD PTR [rbp-0x1a]
  105180:	48 89 d0             	mov    rax,rdx
  105183:	48 c1 e0 03          	shl    rax,0x3
  105187:	48 01 d0             	add    rax,rdx
  10518a:	48 c1 e0 03          	shl    rax,0x3
  10518e:	48 89 c2             	mov    rdx,rax
  105191:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  105195:	48 01 d0             	add    rax,rdx
  105198:	48 8b 48 18          	mov    rcx,QWORD PTR [rax+0x18]
  10519c:	0f b7 55 e6          	movzx  edx,WORD PTR [rbp-0x1a]
  1051a0:	48 89 d0             	mov    rax,rdx
  1051a3:	48 c1 e0 03          	shl    rax,0x3
  1051a7:	48 01 d0             	add    rax,rdx
  1051aa:	48 c1 e0 03          	shl    rax,0x3
  1051ae:	48 89 c2             	mov    rdx,rax
  1051b1:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1051b5:	48 8d 1c 02          	lea    rbx,[rdx+rax*1]
  1051b9:	48 89 cf             	mov    rdi,rcx
  1051bc:	e8 40 f8 ff ff       	call   104a01 <swap_uintptr>
  1051c1:	48 89 43 18          	mov    QWORD PTR [rbx+0x18],rax
  1051c5:	0f b7 55 e6          	movzx  edx,WORD PTR [rbp-0x1a]
  1051c9:	48 89 d0             	mov    rax,rdx
  1051cc:	48 c1 e0 03          	shl    rax,0x3
  1051d0:	48 01 d0             	add    rax,rdx
  1051d3:	48 c1 e0 03          	shl    rax,0x3
  1051d7:	48 89 c2             	mov    rdx,rax
  1051da:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1051de:	48 01 d0             	add    rax,rdx
  1051e1:	48 8b 48 20          	mov    rcx,QWORD PTR [rax+0x20]
  1051e5:	0f b7 55 e6          	movzx  edx,WORD PTR [rbp-0x1a]
  1051e9:	48 89 d0             	mov    rax,rdx
  1051ec:	48 c1 e0 03          	shl    rax,0x3
  1051f0:	48 01 d0             	add    rax,rdx
  1051f3:	48 c1 e0 03          	shl    rax,0x3
  1051f7:	48 89 c2             	mov    rdx,rax
  1051fa:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1051fe:	48 8d 1c 02          	lea    rbx,[rdx+rax*1]
  105202:	48 89 cf             	mov    rdi,rcx
  105205:	e8 f7 f7 ff ff       	call   104a01 <swap_uintptr>
  10520a:	48 89 43 20          	mov    QWORD PTR [rbx+0x20],rax
  10520e:	0f b7 55 e6          	movzx  edx,WORD PTR [rbp-0x1a]
  105212:	48 89 d0             	mov    rax,rdx
  105215:	48 c1 e0 03          	shl    rax,0x3
  105219:	48 01 d0             	add    rax,rdx
  10521c:	48 c1 e0 03          	shl    rax,0x3
  105220:	48 89 c2             	mov    rdx,rax
  105223:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  105227:	48 01 d0             	add    rax,rdx
  10522a:	48 8b 48 28          	mov    rcx,QWORD PTR [rax+0x28]
  10522e:	0f b7 55 e6          	movzx  edx,WORD PTR [rbp-0x1a]
  105232:	48 89 d0             	mov    rax,rdx
  105235:	48 c1 e0 03          	shl    rax,0x3
  105239:	48 01 d0             	add    rax,rdx
  10523c:	48 c1 e0 03          	shl    rax,0x3
  105240:	48 89 c2             	mov    rdx,rax
  105243:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  105247:	48 8d 1c 02          	lea    rbx,[rdx+rax*1]
  10524b:	48 89 cf             	mov    rdi,rcx
  10524e:	e8 ae f7 ff ff       	call   104a01 <swap_uintptr>
  105253:	48 89 43 28          	mov    QWORD PTR [rbx+0x28],rax
  105257:	0f b7 55 e6          	movzx  edx,WORD PTR [rbp-0x1a]
  10525b:	48 89 d0             	mov    rax,rdx
  10525e:	48 c1 e0 03          	shl    rax,0x3
  105262:	48 01 d0             	add    rax,rdx
  105265:	48 c1 e0 03          	shl    rax,0x3
  105269:	48 89 c2             	mov    rdx,rax
  10526c:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  105270:	48 01 d0             	add    rax,rdx
  105273:	48 8b 48 30          	mov    rcx,QWORD PTR [rax+0x30]
  105277:	0f b7 55 e6          	movzx  edx,WORD PTR [rbp-0x1a]
  10527b:	48 89 d0             	mov    rax,rdx
  10527e:	48 c1 e0 03          	shl    rax,0x3
  105282:	48 01 d0             	add    rax,rdx
  105285:	48 c1 e0 03          	shl    rax,0x3
  105289:	48 89 c2             	mov    rdx,rax
  10528c:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  105290:	48 8d 1c 02          	lea    rbx,[rdx+rax*1]
  105294:	48 89 cf             	mov    rdi,rcx
  105297:	e8 65 f7 ff ff       	call   104a01 <swap_uintptr>
  10529c:	48 89 43 30          	mov    QWORD PTR [rbx+0x30],rax
  1052a0:	0f b7 55 e6          	movzx  edx,WORD PTR [rbp-0x1a]
  1052a4:	48 89 d0             	mov    rax,rdx
  1052a7:	48 c1 e0 03          	shl    rax,0x3
  1052ab:	48 01 d0             	add    rax,rdx
  1052ae:	48 c1 e0 03          	shl    rax,0x3
  1052b2:	48 89 c2             	mov    rdx,rax
  1052b5:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1052b9:	48 01 d0             	add    rax,rdx
  1052bc:	48 8b 48 38          	mov    rcx,QWORD PTR [rax+0x38]
  1052c0:	0f b7 55 e6          	movzx  edx,WORD PTR [rbp-0x1a]
  1052c4:	48 89 d0             	mov    rax,rdx
  1052c7:	48 c1 e0 03          	shl    rax,0x3
  1052cb:	48 01 d0             	add    rax,rdx
  1052ce:	48 c1 e0 03          	shl    rax,0x3
  1052d2:	48 89 c2             	mov    rdx,rax
  1052d5:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1052d9:	48 8d 1c 02          	lea    rbx,[rdx+rax*1]
  1052dd:	48 89 cf             	mov    rdi,rcx
  1052e0:	e8 1c f7 ff ff       	call   104a01 <swap_uintptr>
  1052e5:	48 89 43 38          	mov    QWORD PTR [rbx+0x38],rax
  1052e9:	0f b7 55 e6          	movzx  edx,WORD PTR [rbp-0x1a]
  1052ed:	48 89 d0             	mov    rax,rdx
  1052f0:	48 c1 e0 03          	shl    rax,0x3
  1052f4:	48 01 d0             	add    rax,rdx
  1052f7:	48 c1 e0 03          	shl    rax,0x3
  1052fb:	48 89 c2             	mov    rdx,rax
  1052fe:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  105302:	48 01 d0             	add    rax,rdx
  105305:	48 8b 48 40          	mov    rcx,QWORD PTR [rax+0x40]
  105309:	0f b7 55 e6          	movzx  edx,WORD PTR [rbp-0x1a]
  10530d:	48 89 d0             	mov    rax,rdx
  105310:	48 c1 e0 03          	shl    rax,0x3
  105314:	48 01 d0             	add    rax,rdx
  105317:	48 c1 e0 03          	shl    rax,0x3
  10531b:	48 89 c2             	mov    rdx,rax
  10531e:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  105322:	48 8d 1c 02          	lea    rbx,[rdx+rax*1]
  105326:	48 89 cf             	mov    rdi,rcx
  105329:	e8 d3 f6 ff ff       	call   104a01 <swap_uintptr>
  10532e:	48 89 43 40          	mov    QWORD PTR [rbx+0x40],rax
  105332:	0f b7 45 e6          	movzx  eax,WORD PTR [rbp-0x1a]
  105336:	83 c0 01             	add    eax,0x1
  105339:	66 89 45 e6          	mov    WORD PTR [rbp-0x1a],ax
  10533d:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
  105341:	0f b7 40 40          	movzx  eax,WORD PTR [rax+0x40]
  105345:	66 39 45 e6          	cmp    WORD PTR [rbp-0x1a],ax
  105349:	0f 82 b3 fa ff ff    	jb     104e02 <ParseELF_PRG_HEADER+0x72>
  10534f:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  105353:	48 83 c4 38          	add    rsp,0x38
  105357:	5b                   	pop    rbx
  105358:	5d                   	pop    rbp
  105359:	c3                   	ret    

000000000010535a <ParseELF_SCT_HEADER>:
  10535a:	55                   	push   rbp
  10535b:	48 89 e5             	mov    rbp,rsp
  10535e:	53                   	push   rbx
  10535f:	48 83 ec 38          	sub    rsp,0x38
  105363:	48 89 7d c8          	mov    QWORD PTR [rbp-0x38],rdi
  105367:	48 89 75 c0          	mov    QWORD PTR [rbp-0x40],rsi
  10536b:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
  10536f:	0f b7 40 44          	movzx  eax,WORD PTR [rax+0x44]
  105373:	0f b7 c0             	movzx  eax,ax
  105376:	48 c1 e0 06          	shl    rax,0x6
  10537a:	48 89 c7             	mov    rdi,rax
  10537d:	e8 cd db ff ff       	call   102f4f <kmalloc>
  105382:	48 89 45 e0          	mov    QWORD PTR [rbp-0x20],rax
  105386:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
  10538a:	48 8b 40 10          	mov    rax,QWORD PTR [rax+0x10]
  10538e:	48 83 c0 04          	add    rax,0x4
  105392:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  105395:	3c 02                	cmp    al,0x2
  105397:	75 09                	jne    1053a2 <ParseELF_SCT_HEADER+0x48>
  105399:	c7 45 ec 40 00 00 00 	mov    DWORD PTR [rbp-0x14],0x40
  1053a0:	eb 07                	jmp    1053a9 <ParseELF_SCT_HEADER+0x4f>
  1053a2:	c7 45 ec 28 00 00 00 	mov    DWORD PTR [rbp-0x14],0x28
  1053a9:	66 c7 45 ea 00 00    	mov    WORD PTR [rbp-0x16],0x0
  1053af:	e9 a8 03 00 00       	jmp    10575c <ParseELF_SCT_HEADER+0x402>
  1053b4:	0f b7 45 ea          	movzx  eax,WORD PTR [rbp-0x16]
  1053b8:	0f af 45 ec          	imul   eax,DWORD PTR [rbp-0x14]
  1053bc:	48 63 d0             	movsxd rdx,eax
  1053bf:	48 8b 45 c0          	mov    rax,QWORD PTR [rbp-0x40]
  1053c3:	48 01 d0             	add    rax,rdx
  1053c6:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
  1053ca:	0f b7 45 ea          	movzx  eax,WORD PTR [rbp-0x16]
  1053ce:	48 c1 e0 06          	shl    rax,0x6
  1053d2:	48 89 c2             	mov    rdx,rax
  1053d5:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
  1053d9:	48 01 c2             	add    rdx,rax
  1053dc:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1053e0:	8b 00                	mov    eax,DWORD PTR [rax]
  1053e2:	89 02                	mov    DWORD PTR [rdx],eax
  1053e4:	0f b7 45 ea          	movzx  eax,WORD PTR [rbp-0x16]
  1053e8:	48 c1 e0 06          	shl    rax,0x6
  1053ec:	48 89 c2             	mov    rdx,rax
  1053ef:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
  1053f3:	48 01 c2             	add    rdx,rax
  1053f6:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1053fa:	8b 40 04             	mov    eax,DWORD PTR [rax+0x4]
  1053fd:	89 42 04             	mov    DWORD PTR [rdx+0x4],eax
  105400:	0f b7 45 ea          	movzx  eax,WORD PTR [rbp-0x16]
  105404:	48 c1 e0 06          	shl    rax,0x6
  105408:	48 89 c2             	mov    rdx,rax
  10540b:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
  10540f:	48 01 c2             	add    rdx,rax
  105412:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  105416:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
  10541a:	48 89 42 08          	mov    QWORD PTR [rdx+0x8],rax
  10541e:	0f b7 45 ea          	movzx  eax,WORD PTR [rbp-0x16]
  105422:	48 c1 e0 06          	shl    rax,0x6
  105426:	48 89 c2             	mov    rdx,rax
  105429:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
  10542d:	48 01 c2             	add    rdx,rax
  105430:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  105434:	48 8b 40 10          	mov    rax,QWORD PTR [rax+0x10]
  105438:	48 89 42 10          	mov    QWORD PTR [rdx+0x10],rax
  10543c:	0f b7 45 ea          	movzx  eax,WORD PTR [rbp-0x16]
  105440:	48 c1 e0 06          	shl    rax,0x6
  105444:	48 89 c2             	mov    rdx,rax
  105447:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
  10544b:	48 01 c2             	add    rdx,rax
  10544e:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  105452:	48 8b 40 18          	mov    rax,QWORD PTR [rax+0x18]
  105456:	48 89 42 18          	mov    QWORD PTR [rdx+0x18],rax
  10545a:	0f b7 45 ea          	movzx  eax,WORD PTR [rbp-0x16]
  10545e:	48 c1 e0 06          	shl    rax,0x6
  105462:	48 89 c2             	mov    rdx,rax
  105465:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
  105469:	48 01 c2             	add    rdx,rax
  10546c:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  105470:	48 8b 40 20          	mov    rax,QWORD PTR [rax+0x20]
  105474:	48 89 42 20          	mov    QWORD PTR [rdx+0x20],rax
  105478:	bb 28 00 00 00       	mov    ebx,0x28
  10547d:	0f b6 d3             	movzx  edx,bl
  105480:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  105484:	48 01 d0             	add    rax,rdx
  105487:	0f b7 55 ea          	movzx  edx,WORD PTR [rbp-0x16]
  10548b:	48 89 d1             	mov    rcx,rdx
  10548e:	48 c1 e1 06          	shl    rcx,0x6
  105492:	48 8b 55 e0          	mov    rdx,QWORD PTR [rbp-0x20]
  105496:	48 01 ca             	add    rdx,rcx
  105499:	8b 00                	mov    eax,DWORD PTR [rax]
  10549b:	89 42 28             	mov    DWORD PTR [rdx+0x28],eax
  10549e:	0f b6 c3             	movzx  eax,bl
  1054a1:	48 8d 50 04          	lea    rdx,[rax+0x4]
  1054a5:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1054a9:	48 01 d0             	add    rax,rdx
  1054ac:	0f b7 55 ea          	movzx  edx,WORD PTR [rbp-0x16]
  1054b0:	48 89 d1             	mov    rcx,rdx
  1054b3:	48 c1 e1 06          	shl    rcx,0x6
  1054b7:	48 8b 55 e0          	mov    rdx,QWORD PTR [rbp-0x20]
  1054bb:	48 01 ca             	add    rdx,rcx
  1054be:	8b 00                	mov    eax,DWORD PTR [rax]
  1054c0:	89 42 2c             	mov    DWORD PTR [rdx+0x2c],eax
  1054c3:	0f b6 c3             	movzx  eax,bl
  1054c6:	48 8d 50 08          	lea    rdx,[rax+0x8]
  1054ca:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1054ce:	48 01 d0             	add    rax,rdx
  1054d1:	0f b7 55 ea          	movzx  edx,WORD PTR [rbp-0x16]
  1054d5:	48 89 d1             	mov    rcx,rdx
  1054d8:	48 c1 e1 06          	shl    rcx,0x6
  1054dc:	48 8b 55 e0          	mov    rdx,QWORD PTR [rbp-0x20]
  1054e0:	48 01 ca             	add    rdx,rcx
  1054e3:	48 8b 00             	mov    rax,QWORD PTR [rax]
  1054e6:	48 89 42 30          	mov    QWORD PTR [rdx+0x30],rax
  1054ea:	0f b6 c3             	movzx  eax,bl
  1054ed:	48 8d 50 10          	lea    rdx,[rax+0x10]
  1054f1:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1054f5:	48 01 d0             	add    rax,rdx
  1054f8:	0f b7 55 ea          	movzx  edx,WORD PTR [rbp-0x16]
  1054fc:	48 89 d1             	mov    rcx,rdx
  1054ff:	48 c1 e1 06          	shl    rcx,0x6
  105503:	48 8b 55 e0          	mov    rdx,QWORD PTR [rbp-0x20]
  105507:	48 01 ca             	add    rdx,rcx
  10550a:	48 8b 00             	mov    rax,QWORD PTR [rax]
  10550d:	48 89 42 38          	mov    QWORD PTR [rdx+0x38],rax
  105511:	8b 05 c1 0b 00 00    	mov    eax,DWORD PTR [rip+0xbc1]        # 1060d8 <isLittleEndian>
  105517:	85 c0                	test   eax,eax
  105519:	74 13                	je     10552e <ParseELF_SCT_HEADER+0x1d4>
  10551b:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
  10551f:	48 8b 40 10          	mov    rax,QWORD PTR [rax+0x10]
  105523:	48 83 c0 05          	add    rax,0x5
  105527:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  10552a:	3c 02                	cmp    al,0x2
  10552c:	74 25                	je     105553 <ParseELF_SCT_HEADER+0x1f9>
  10552e:	8b 05 a8 0b 00 00    	mov    eax,DWORD PTR [rip+0xba8]        # 1060dc <isBigEndian>
  105534:	85 c0                	test   eax,eax
  105536:	0f 84 1b 02 00 00    	je     105757 <ParseELF_SCT_HEADER+0x3fd>
  10553c:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
  105540:	48 8b 40 10          	mov    rax,QWORD PTR [rax+0x10]
  105544:	48 83 c0 05          	add    rax,0x5
  105548:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  10554b:	3c 01                	cmp    al,0x1
  10554d:	0f 85 04 02 00 00    	jne    105757 <ParseELF_SCT_HEADER+0x3fd>
  105553:	0f b7 45 ea          	movzx  eax,WORD PTR [rbp-0x16]
  105557:	48 c1 e0 06          	shl    rax,0x6
  10555b:	48 89 c2             	mov    rdx,rax
  10555e:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
  105562:	48 01 d0             	add    rax,rdx
  105565:	8b 00                	mov    eax,DWORD PTR [rax]
  105567:	0f b7 55 ea          	movzx  edx,WORD PTR [rbp-0x16]
  10556b:	48 89 d1             	mov    rcx,rdx
  10556e:	48 c1 e1 06          	shl    rcx,0x6
  105572:	48 8b 55 e0          	mov    rdx,QWORD PTR [rbp-0x20]
  105576:	48 8d 1c 11          	lea    rbx,[rcx+rdx*1]
  10557a:	89 c7                	mov    edi,eax
  10557c:	e8 54 f4 ff ff       	call   1049d5 <swap_uint32>
  105581:	89 03                	mov    DWORD PTR [rbx],eax
  105583:	0f b7 45 ea          	movzx  eax,WORD PTR [rbp-0x16]
  105587:	48 c1 e0 06          	shl    rax,0x6
  10558b:	48 89 c2             	mov    rdx,rax
  10558e:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
  105592:	48 01 d0             	add    rax,rdx
  105595:	8b 40 04             	mov    eax,DWORD PTR [rax+0x4]
  105598:	0f b7 55 ea          	movzx  edx,WORD PTR [rbp-0x16]
  10559c:	48 89 d1             	mov    rcx,rdx
  10559f:	48 c1 e1 06          	shl    rcx,0x6
  1055a3:	48 8b 55 e0          	mov    rdx,QWORD PTR [rbp-0x20]
  1055a7:	48 8d 1c 11          	lea    rbx,[rcx+rdx*1]
  1055ab:	89 c7                	mov    edi,eax
  1055ad:	e8 23 f4 ff ff       	call   1049d5 <swap_uint32>
  1055b2:	89 43 04             	mov    DWORD PTR [rbx+0x4],eax
  1055b5:	0f b7 45 ea          	movzx  eax,WORD PTR [rbp-0x16]
  1055b9:	48 c1 e0 06          	shl    rax,0x6
  1055bd:	48 89 c2             	mov    rdx,rax
  1055c0:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
  1055c4:	48 01 d0             	add    rax,rdx
  1055c7:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
  1055cb:	0f b7 55 ea          	movzx  edx,WORD PTR [rbp-0x16]
  1055cf:	48 89 d1             	mov    rcx,rdx
  1055d2:	48 c1 e1 06          	shl    rcx,0x6
  1055d6:	48 8b 55 e0          	mov    rdx,QWORD PTR [rbp-0x20]
  1055da:	48 8d 1c 11          	lea    rbx,[rcx+rdx*1]
  1055de:	48 89 c7             	mov    rdi,rax
  1055e1:	e8 1b f4 ff ff       	call   104a01 <swap_uintptr>
  1055e6:	48 89 43 08          	mov    QWORD PTR [rbx+0x8],rax
  1055ea:	0f b7 45 ea          	movzx  eax,WORD PTR [rbp-0x16]
  1055ee:	48 c1 e0 06          	shl    rax,0x6
  1055f2:	48 89 c2             	mov    rdx,rax
  1055f5:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
  1055f9:	48 01 d0             	add    rax,rdx
  1055fc:	48 8b 40 10          	mov    rax,QWORD PTR [rax+0x10]
  105600:	0f b7 55 ea          	movzx  edx,WORD PTR [rbp-0x16]
  105604:	48 89 d1             	mov    rcx,rdx
  105607:	48 c1 e1 06          	shl    rcx,0x6
  10560b:	48 8b 55 e0          	mov    rdx,QWORD PTR [rbp-0x20]
  10560f:	48 8d 1c 11          	lea    rbx,[rcx+rdx*1]
  105613:	48 89 c7             	mov    rdi,rax
  105616:	e8 e6 f3 ff ff       	call   104a01 <swap_uintptr>
  10561b:	48 89 43 10          	mov    QWORD PTR [rbx+0x10],rax
  10561f:	0f b7 45 ea          	movzx  eax,WORD PTR [rbp-0x16]
  105623:	48 c1 e0 06          	shl    rax,0x6
  105627:	48 89 c2             	mov    rdx,rax
  10562a:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
  10562e:	48 01 d0             	add    rax,rdx
  105631:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
  105635:	0f b7 55 ea          	movzx  edx,WORD PTR [rbp-0x16]
  105639:	48 89 d1             	mov    rcx,rdx
  10563c:	48 c1 e1 06          	shl    rcx,0x6
  105640:	48 8b 55 e0          	mov    rdx,QWORD PTR [rbp-0x20]
  105644:	48 8d 1c 11          	lea    rbx,[rcx+rdx*1]
  105648:	48 89 c7             	mov    rdi,rax
  10564b:	e8 b1 f3 ff ff       	call   104a01 <swap_uintptr>
  105650:	48 89 43 18          	mov    QWORD PTR [rbx+0x18],rax
  105654:	0f b7 45 ea          	movzx  eax,WORD PTR [rbp-0x16]
  105658:	48 c1 e0 06          	shl    rax,0x6
  10565c:	48 89 c2             	mov    rdx,rax
  10565f:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
  105663:	48 01 d0             	add    rax,rdx
  105666:	48 8b 40 20          	mov    rax,QWORD PTR [rax+0x20]
  10566a:	0f b7 55 ea          	movzx  edx,WORD PTR [rbp-0x16]
  10566e:	48 89 d1             	mov    rcx,rdx
  105671:	48 c1 e1 06          	shl    rcx,0x6
  105675:	48 8b 55 e0          	mov    rdx,QWORD PTR [rbp-0x20]
  105679:	48 8d 1c 11          	lea    rbx,[rcx+rdx*1]
  10567d:	48 89 c7             	mov    rdi,rax
  105680:	e8 7c f3 ff ff       	call   104a01 <swap_uintptr>
  105685:	48 89 43 20          	mov    QWORD PTR [rbx+0x20],rax
  105689:	0f b7 45 ea          	movzx  eax,WORD PTR [rbp-0x16]
  10568d:	48 c1 e0 06          	shl    rax,0x6
  105691:	48 89 c2             	mov    rdx,rax
  105694:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
  105698:	48 01 d0             	add    rax,rdx
  10569b:	8b 40 28             	mov    eax,DWORD PTR [rax+0x28]
  10569e:	0f b7 55 ea          	movzx  edx,WORD PTR [rbp-0x16]
  1056a2:	48 89 d1             	mov    rcx,rdx
  1056a5:	48 c1 e1 06          	shl    rcx,0x6
  1056a9:	48 8b 55 e0          	mov    rdx,QWORD PTR [rbp-0x20]
  1056ad:	48 8d 1c 11          	lea    rbx,[rcx+rdx*1]
  1056b1:	89 c7                	mov    edi,eax
  1056b3:	e8 1d f3 ff ff       	call   1049d5 <swap_uint32>
  1056b8:	89 43 28             	mov    DWORD PTR [rbx+0x28],eax
  1056bb:	0f b7 45 ea          	movzx  eax,WORD PTR [rbp-0x16]
  1056bf:	48 c1 e0 06          	shl    rax,0x6
  1056c3:	48 89 c2             	mov    rdx,rax
  1056c6:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
  1056ca:	48 01 d0             	add    rax,rdx
  1056cd:	8b 40 2c             	mov    eax,DWORD PTR [rax+0x2c]
  1056d0:	0f b7 55 ea          	movzx  edx,WORD PTR [rbp-0x16]
  1056d4:	48 89 d1             	mov    rcx,rdx
  1056d7:	48 c1 e1 06          	shl    rcx,0x6
  1056db:	48 8b 55 e0          	mov    rdx,QWORD PTR [rbp-0x20]
  1056df:	48 8d 1c 11          	lea    rbx,[rcx+rdx*1]
  1056e3:	89 c7                	mov    edi,eax
  1056e5:	e8 eb f2 ff ff       	call   1049d5 <swap_uint32>
  1056ea:	89 43 2c             	mov    DWORD PTR [rbx+0x2c],eax
  1056ed:	0f b7 45 ea          	movzx  eax,WORD PTR [rbp-0x16]
  1056f1:	48 c1 e0 06          	shl    rax,0x6
  1056f5:	48 89 c2             	mov    rdx,rax
  1056f8:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
  1056fc:	48 01 d0             	add    rax,rdx
  1056ff:	48 8b 40 30          	mov    rax,QWORD PTR [rax+0x30]
  105703:	0f b7 55 ea          	movzx  edx,WORD PTR [rbp-0x16]
  105707:	48 89 d1             	mov    rcx,rdx
  10570a:	48 c1 e1 06          	shl    rcx,0x6
  10570e:	48 8b 55 e0          	mov    rdx,QWORD PTR [rbp-0x20]
  105712:	48 8d 1c 11          	lea    rbx,[rcx+rdx*1]
  105716:	48 89 c7             	mov    rdi,rax
  105719:	e8 e3 f2 ff ff       	call   104a01 <swap_uintptr>
  10571e:	48 89 43 30          	mov    QWORD PTR [rbx+0x30],rax
  105722:	0f b7 45 ea          	movzx  eax,WORD PTR [rbp-0x16]
  105726:	48 c1 e0 06          	shl    rax,0x6
  10572a:	48 89 c2             	mov    rdx,rax
  10572d:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
  105731:	48 01 d0             	add    rax,rdx
  105734:	48 8b 40 38          	mov    rax,QWORD PTR [rax+0x38]
  105738:	0f b7 55 ea          	movzx  edx,WORD PTR [rbp-0x16]
  10573c:	48 89 d1             	mov    rcx,rdx
  10573f:	48 c1 e1 06          	shl    rcx,0x6
  105743:	48 8b 55 e0          	mov    rdx,QWORD PTR [rbp-0x20]
  105747:	48 8d 1c 11          	lea    rbx,[rcx+rdx*1]
  10574b:	48 89 c7             	mov    rdi,rax
  10574e:	e8 ae f2 ff ff       	call   104a01 <swap_uintptr>
  105753:	48 89 43 38          	mov    QWORD PTR [rbx+0x38],rax
  105757:	66 83 45 ea 01       	add    WORD PTR [rbp-0x16],0x1
  10575c:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
  105760:	0f b7 40 44          	movzx  eax,WORD PTR [rax+0x44]
  105764:	66 39 45 ea          	cmp    WORD PTR [rbp-0x16],ax
  105768:	0f 82 46 fc ff ff    	jb     1053b4 <ParseELF_SCT_HEADER+0x5a>
  10576e:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
  105772:	48 83 c4 38          	add    rsp,0x38
  105776:	5b                   	pop    rbx
  105777:	5d                   	pop    rbp
  105778:	c3                   	ret    
