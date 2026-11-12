	.file	"program.c"
	.text
	.globl	initialized_global
	.data
	.align 4
	.type	initialized_global, @object
	.size	initialized_global, 4
initialized_global:
	.long	42
	.globl	uninitialized_global
	.bss
	.align 4
	.type	uninitialized_global, @object
	.size	uninitialized_global, 4
uninitialized_global:
	.zero	4
	.section	.rodata
.LC0:
	.string	"malloc"
.LC1:
	.string	"PID: %ld\n"
	.align 8
.LC2:
	.string	"Initialized global at %p = %d\n"
	.align 8
.LC3:
	.string	"Uninitialized global at %p = %d\n"
.LC4:
	.string	"Local variable at %p = %d\n"
.LC5:
	.string	"Heap value at %p = %d\n"
	.text
	.type	show_memory, @function
show_memory:
.LFB0:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$7, -20(%rbp)
	movl	$4, %edi
	call	malloc@PLT
	movq	%rax, -16(%rbp)
	cmpq	$0, -16(%rbp)
	jne	.L2
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L2:
	movq	-16(%rbp), %rax
	movl	$99, (%rax)
	call	getpid@PLT
	cltq
	leaq	.LC1(%rip), %rdx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	initialized_global(%rip), %eax
	leaq	initialized_global(%rip), %rsi
	leaq	.LC2(%rip), %rcx
	movl	%eax, %edx
	movq	%rcx, %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	uninitialized_global(%rip), %eax
	leaq	uninitialized_global(%rip), %rsi
	leaq	.LC3(%rip), %rcx
	movl	%eax, %edx
	movq	%rcx, %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	-20(%rbp), %edx
	leaq	-20(%rbp), %rax
	leaq	.LC4(%rip), %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	movl	$0, %eax
	call	printf@PLT
	movq	-16(%rbp), %rax
	movl	(%rax), %edx
	movq	-16(%rbp), %rax
	leaq	.LC5(%rip), %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	movl	$0, %eax
	call	printf@PLT
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	nop
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L3
	call	__stack_chk_fail@PLT
.L3:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	show_memory, .-show_memory
	.section	.rodata
.LC6:
	.string	"w"
.LC7:
	.string	"assignment-output.txt"
.LC8:
	.string	"fopen"
.LC9:
	.string	"File operation from PID %ld\n"
	.text
	.type	use_file, @function
use_file:
.LFB1:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	leaq	.LC6(%rip), %rdx
	leaq	.LC7(%rip), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	fopen@PLT
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	jne	.L5
	leaq	.LC8(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	jmp	.L4
.L5:
	call	getpid@PLT
	movslq	%eax, %rdx
	leaq	.LC9(%rip), %rcx
	movq	-8(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	fclose@PLT
.L4:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	use_file, .-use_file
	.section	.rodata
.LC10:
	.string	"fork"
	.align 8
.LC11:
	.string	"Child PID: %ld; parent PID: %ld\n"
.LC12:
	.string	"-l"
.LC13:
	.string	"ls"
.LC14:
	.string	"execlp"
	.align 8
.LC15:
	.string	"Parent PID: %ld; child PID: %ld\n"
.LC16:
	.string	"Parent waiting for child..."
.LC17:
	.string	"waitpid"
.LC18:
	.string	"Child exited with status %d\n"
.LC19:
	.string	"Child ended from signal %d\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB2:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$24, %rsp
	.cfi_offset 3, -24
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	call	show_memory
	call	use_file
	call	fork@PLT
	movl	%eax, -28(%rbp)
	cmpl	$0, -28(%rbp)
	jns	.L8
	leaq	.LC10(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %eax
	jmp	.L14
.L8:
	cmpl	$0, -28(%rbp)
	jne	.L10
	call	getppid@PLT
	movslq	%eax, %rbx
	call	getpid@PLT
	cltq
	leaq	.LC11(%rip), %rcx
	movq	%rbx, %rdx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	movl	$0, %eax
	call	printf@PLT
	movq	stdout(%rip), %rax
	movq	%rax, %rdi
	call	fflush@PLT
	movl	$20, %edi
	call	sleep@PLT
	leaq	.LC7(%rip), %rcx
	leaq	.LC12(%rip), %rdx
	leaq	.LC13(%rip), %rsi
	leaq	.LC13(%rip), %rax
	movl	$0, %r8d
	movq	%rax, %rdi
	movl	$0, %eax
	call	execlp@PLT
	leaq	.LC14(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$127, %edi
	call	_exit@PLT
.L10:
	movl	-28(%rbp), %eax
	movslq	%eax, %rbx
	call	getpid@PLT
	cltq
	leaq	.LC15(%rip), %rcx
	movq	%rbx, %rdx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	movl	$0, %eax
	call	printf@PLT
	leaq	.LC16(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movq	stdout(%rip), %rax
	movq	%rax, %rdi
	call	fflush@PLT
	leaq	-32(%rbp), %rcx
	movl	-28(%rbp), %eax
	movl	$0, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	waitpid@PLT
	testl	%eax, %eax
	jns	.L11
	leaq	.LC17(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %eax
	jmp	.L14
.L11:
	movl	-32(%rbp), %eax
	andl	$127, %eax
	testl	%eax, %eax
	jne	.L12
	movl	-32(%rbp), %eax
	sarl	$8, %eax
	movzbl	%al, %eax
	leaq	.LC18(%rip), %rdx
	movl	%eax, %esi
	movq	%rdx, %rdi
	movl	$0, %eax
	call	printf@PLT
	jmp	.L13
.L12:
	movl	-32(%rbp), %eax
	andl	$127, %eax
	addl	$1, %eax
	sarb	%al
	testb	%al, %al
	jle	.L13
	movl	-32(%rbp), %eax
	andl	$127, %eax
	movl	%eax, %edx
	leaq	.LC19(%rip), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
.L13:
	movl	$0, %eax
.L14:
	movq	-24(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L15
	call	__stack_chk_fail@PLT
.L15:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 15.2.0-16ubuntu1) 15.2.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
