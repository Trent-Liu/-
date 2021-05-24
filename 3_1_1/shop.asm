 .686P     
.model flat, stdcall
 ExitProcess PROTO STDCALL :DWORD
 includelib  kernel32.lib  ; ExitProcess �� kernel32.lib��ʵ��
printf    PROTO C : dword,:vararg;��printf��������.
scanf    PROTO C : dword,:vararg;��scanf��������.

strcmp proto C:dword,:dword
GOODSELL proto C:word,:dword

 includelib  libcmt.lib
 includelib  legacy_stdio_definitions.lib
 includelib  Winmm.lib
 
 public lpFmt
 public lpFmt1
 public lpFmt3
 public NENOUGH
 public SOLDGOODS
 public UPDATEPRIOT



timeGetTime proto stdcall


PRINTGOOD macro A
		
		invoke printf,offset lpFmt1,EDI
		invoke printf,offset lpFmt,OFFSET NEWLINE
		invoke printf,offset lpFmt1,OFFSET Purchase_price
		invoke printf,offset lpFmt3,(GOODS ptr [EDI]).BUYPRICE
		invoke printf,offset lpFmt1,OFFSET Sales_price
		invoke printf,offset lpFmt3,(GOODS ptr [EDI]).SELLPRICE
		invoke printf,offset lpFmt1,OFFSET Purchase_quantity
		invoke printf,offset lpFmt3,(GOODS ptr [EDI]).BUYNUM
		invoke printf,offset lpFmt1,OFFSET Sold_quantity
		invoke printf,offset lpFmt3,(GOODS ptr [EDI]).SELLNUM
		invoke printf,offset lpFmt1,OFFSET PROFIT
		invoke printf,offset lpFmt4,(GOODS ptr[EDI]).RATE

endm


.DATA
;��ʽ����������Ķ���
lpFmt	db	"%s",0ah, 0dh, 0
lpFmt1	db	"%s", 0
lpFmt2  db	"%d", 0
lpFmt3	db	"%d",0ah,0dh, 0
lpFmt4	db	"%hd",0ah,0dh, 0
lpFmt5  db	"%s",0ah, 0dh, 0

NEWLINE DB ' ',0
;��½ѡ��
INPUTNAME	DB 'User Name:',0
OUTNAMEW DB 'Invalid User Name',0
INNAME	DB 20 DUP(0)
BNAME  	DB 'liuYIkang', 0			;�ϰ�����

INPUTPWD	DB 'Password:',0
OUTPWDW DB 'Invalid Password',0
INPWD	DB 20 DUP(0)
BPASS  	DB 'U201914873', 0				;����
SUCCESSIN DB 'Success login in',0

;�˵�ѡ��
MENUT	DB 'Please Enter a Number(1~9):',0
MENUT1 DB '1.Search for products and print information',0
MENUT2 DB '2.Shipment ',0
MENUT3 DB '3.Purchase ',0
MENUT4 DB '4.Calculate profit margin ',0
MENUT5 DB '5.Profit margin ranking ',0
MENUT6 DB 'Please Enter a Number(1~9):',0
CHOICE DB 0


;ѡ��2����
Shipment word 0
Shipment_buf DB  'Please Enter Shipment quantity:',0
SOLDGOODS DB 'The goods have been sold:',0
NENOUGH DB 'There is not enough left:',0
;ѡ��3����
Replenishment word 0
Replenishment_buf  DB  'Please Enter Replenishment quantity:',0
PURCHASEDGOODS DB 'The goods have been purchase:',0



;ѡ��goodѡ��
INGOODT DB 'Good Name:',0
INGOOD	DB 10 DUP(0)
NOGOODT	DB 'No Goods',0

;ѡ��1�����Ϣ
Purchase_price DB 'Purchase price:',0
Sales_price DB 'Sales price:',0
Purchase_quantity DB 'Purchase quantity:',0
Sold_quantity DB 'Sold quantity:',0


;ѡ��5����
PROFIT DB 'profit margin :',0

SORTRESULT DB 'In order of profit margin :',0
SORTIMPROVE DB 'After code optimization :',0

UPDATEPRIOT DB 'Priority Updated',0
GOODSPROFIT DB 'GOODS profit margin:',0


N		EQU	30


GOODS  STRUCT
GOODSNAME  db 10 DUP(0)
BUYPRICE   DW  0
SELLPRICE  DW  0
BUYNUM     DW  0
SELLNUM    DW  0
RATE       DW  0
GOODS  ENDS


AMOUNT Dword 4
GA1   GOODS < 'PEN',15,20,70,25,0 >  ;��Ʒ1 ����, �����ۡ����ۼۡ�������������������,�����ʣ���δ���㣩
GA2   GOODS < 'PENCIL',2,3,100,50,0 >
GA3   GOODS < 'BOOK',30,40,25,5,0 >
GA4   GOODS < 'RULER',3,4,200,150,0 >
GAN   GOODS 6 DUP(<>)
GATEMP GOODS<>

SORT  STRUCT
POS DWORD 0
RATE DW 0
SORT  ENDS


SORT1 SORT <1,0>
SORT2 SORT <2,0>
SORT3 SORT <3,0>
SORT4 SORT <4,0>
SORTN   SORT 6 DUP(<>)

BEGINTIME dword 0
ENDTIME DWORD 0
TIMECOST DWORD 0
ALLTIME DB 'Total time consumed after 1000000 cycles(ms):',0

.STACK 200



.CODE


main proc c
Start:
;�����û���
invoke printf,offset lpFmt,OFFSET INPUTNAME
invoke scanf,offset lpFmt1,OFFSET INNAME

		push offset INNAME
		push offset BNAME
		invoke strcmp,offset INNAME,offset BNAME
		cmp eax,0
		jne WRONG_NAME
		
;��������
invoke printf,offset lpFmt,OFFSET INPUTPWD
invoke scanf,offset lpFmt1,OFFSET INPWD

		push offset INPWD
		push offset BPASS
		invoke strcmp,offset INPWD,offset BPASS
		cmp eax,0
		jne WRONG_PWD

		JMP LOGIN_S

WRONG_NAME:
invoke printf,offset lpFmt,OFFSET OUTNAMEW
invoke printf,offset lpFmt,OFFSET NEWLINE
JMP Start
WRONG_PWD:
invoke printf,offset lpFmt,OFFSET OUTPWDW
invoke printf,offset lpFmt,OFFSET NEWLINE
JMP Start

LOGIN_S:							;��½�ɹ�
invoke printf,offset lpFmt,OFFSET NEWLINE
invoke printf,offset lpFmt,OFFSET SUCCESSIN
invoke printf,offset lpFmt,OFFSET NEWLINE






;�˵����
MENU:	
invoke printf,offset lpFmt,OFFSET NEWLINE
invoke printf,offset lpFmt,OFFSET MENUT1
invoke printf,offset lpFmt,OFFSET MENUT2
invoke printf,offset lpFmt,OFFSET MENUT3
invoke printf,offset lpFmt,OFFSET MENUT4
invoke printf,offset lpFmt,OFFSET MENUT5
invoke printf,offset lpFmt,OFFSET MENUT
		invoke scanf,offset lpFmt1,OFFSET CHOICE
		
		LEA EDI, CHOICE
		MOV AL, [EDI]
		
	
		CMP AL, '4'
		JE FUNC4
		CMP al,'5'
		JE FUNC5
		CMP AL, '9'
		JE OVER
		

;������Ʒ���������ҵ���Ӧ��λ��
	invoke printf,offset lpFmt,OFFSET NEWLINE
	invoke printf,offset lpFmt,OFFSET INGOODT			

	MOV EBX,0        ;INGGOD��ʼ��Ϊ�գ�Ϊ����ѡ����׼��
	KEEP:
	MOV INGOOD[EBX],0
	inc EBX
	CMP EBX,10
	JL KEEP
	invoke scanf,offset lpFmt1,OFFSET INGOOD

		MOV EBX, -1
CHECK_GOOD:							;ѡ����һ���Ƚ���Ʒ
		INC EBX                     ;�鿴��Ʒ�Ƿ������
		CMP EBX,AMOUNT

		JE NO_GOOD
		
		MOV ECX, EBX
		
		IMUL ECX, 20
		ADD ECX, OFFSET GA1     ;ECX��ʱ��ŵ�ǰ��Ʒ���׵�ַ
		
		push ECX
		push offset INGOOD
		call strcmp
		add esp,8
		cmp eax,0
		jne CHECK_GOOD

		push ECX
		jmp  NEEDGOODSFUNC

NO_GOOD:
invoke printf,offset lpFmt,OFFSET NOGOODT

		JMP MENU


NEEDGOODSFUNC:
		LEA EDI, CHOICE
		MOV AL, [EDI]
		
		CMP AL, '1'
		JE FUNC1
		CMP AL, '2'
		JE FUNC2
		CMP AL, '3'
		JE FUNC3
		JMP MENU
;����ָ����Ʒ����ʾ����Ϣ����ʾ�û�������Ʒ���ƣ�
;�û��������ƺ�,���̵���Ѱ���Ƿ���ڸ���Ʒ��
;������,��ʾ�ҵ�����Ʒ��Ϣ����û���ҵ�,��ʾû���ҵ�����󶼷��ص����˵����档
FUNC1:
		;��ʾ��Ʒ��Ϣ
		pop ECX		
		MOV EDI,ECX
		PRINTGOOD 
		
		
		JMP MENU




FUNC2:   ;����
		invoke printf,offset lpFmt,OFFSET Shipment_buf
		invoke scanf,offset lpFmt2,OFFSET Shipment
		POP ECX
		invoke GOODSELL,Shipment,ECX
		JMP MENU



FUNC3:   ;����
		invoke printf,offset lpFmt,OFFSET Replenishment_buf
		invoke scanf,offset lpFmt2,OFFSET Replenishment
		POP EDI

		
		MOV DX,Replenishment
		ADD (GOODS ptr [EDI]).BUYNUM,DX
		invoke printf,offset lpFmt1,OFFSET PURCHASEDGOODS

		invoke printf,offset lpFmt3,(GOODS ptr [EDI]).BUYNUM

		invoke printf,offset lpFmt,OFFSET UPDATEPRIOT

		JMP MENU


FUNC4:
		CALL CalculateRate

FUNC5: 

		CALL timeGetTime
		LEA EBX,BEGINTIME
		MOV [EBX],EAX


		MOV EAX,1000000
BEGINTIMEGET:
		CMP EAX,0
		JBE GETTIME
		push EAX

		CALL SORTBEFORE


		pop EAX
		dec EAX
		JMP BEGINTIMEGET
		GETTIME:

		CALL timeGetTime
		LEA EBX,ENDTIME
		MOV [EBX],EAX
		LEA ECX,BEGINTIME
		SUB EAX,[ECX]
		MOV TIMECOST,EAX
		;��ӡ�����ʱ��
		
		invoke printf,offset lpFmt,OFFSET NEWLINE
		invoke printf,offset lpFmt,OFFSET ALLTIME
		invoke printf,offset lpFmt3,dword ptr[TIMECOST]
		invoke printf,offset lpFmt,OFFSET NEWLINE

;������ɣ�����˳���ӡ��Ʒ��Ϣ
		invoke printf,offset lpFmt,OFFSET SORTRESULT
				;��ʾ��Ʒ��Ϣ
		MOV ebx,0
		LEA ECX,SORT1
PRINTFUNC5:		
		CMP ebx,AMOUNT
		push ECX
		push ebx
		jae ENDFUNC5
		
		MOV EDI, dword ptr[ECX]
		PRINTGOOD
		

		pop ebx
		inc ebx
		pop ECX
		ADD ECX,6

		JMP PRINTFUNC5
;
;
;
;

ENDFUNC5:


		invoke printf,offset lpFmt,OFFSET NEWLINE
		invoke printf,offset lpFmt,OFFSET NEWLINE

		MOV EAX,0


CALL timeGetTime
		LEA EBX,BEGINTIME
		MOV [EBX],EAX


		MOV EAX,1000000
BEGINTIMEGETAFTER:
		CMP Eax,0
		JBE GETTIMEAFTER
		push EAX


		call SORTAFTER
		
		pop EAX
		dec EAX
		JMP BEGINTIMEGETAFTER
		GETTIMEAFTER:

		CALL timeGetTime
		LEA EBX,ENDTIME
		MOV [EBX],EAX
		LEA ECX,BEGINTIME
		SUB EAX,[ECX]
		MOV TIMECOST,EAX
		;��ӡ�����ʱ��
		invoke printf,offset lpFmt,OFFSET SORTIMPROVE
		invoke printf,offset lpFmt,OFFSET NEWLINE
		invoke printf,offset lpFmt,OFFSET ALLTIME
		invoke printf,offset lpFmt3,dword ptr[TIMECOST]
		invoke printf,offset lpFmt,OFFSET NEWLINE






		invoke printf,offset lpFmt,OFFSET SORTRESULT
				;��ʾ��Ʒ��Ϣ
		MOV ebx,0
		LEA ECX,SORT1
PRINTFUNC5AFTER:		
		CMP ebx,AMOUNT
		push ECX
		push ebx
		jae ENDFUNC5AFTER
		
		MOV EDI, dword ptr[ECX]
		PRINTGOOD
		

		pop ebx
		inc ebx
		pop ECX
		ADD ECX,6

		JMP PRINTFUNC5AFTER



ENDFUNC5AFTER:



		JMP MENU
OVER:
invoke printf,offset lpFmt,OFFSET NEWLINE
	invoke printf,offset lpFmt,ESI
main endp




; ����������
CalculateRate proc
	push ebp
	mov ebp,esp

		invoke printf,offset lpFmt,OFFSET NEWLINE
		invoke printf,offset lpFmt,OFFSET GOODSPROFIT
		MOV ESI, -1
		push ESI
ALLGOOD:							;ѡ����һ���Ƚ���Ʒ
		pop ESI
		INC ESI   ;�鿴��Ʒ�Ƿ������
		push ESI
		CMP ESI, AMOUNT
		JE ENDCalculate

		IMUL ESI, 20
		ADD ESI, OFFSET GA1     ;ESI��ʱ��ŵ�ǰ��Ʒ���׵�ַ
		MOV EAX,0
		MOV EBX,0
		invoke printf,ESI
		invoke printf,offset lpFmt,OFFSET NEWLINE

		MOV AX,(GOODS ptr[ESI]).BUYPRICE   ;������
		MOV BX,(GOODS ptr[ESI]).BUYNUM   ;��������
		IMUL BX
		PUSH AX      ;����

		MOV AX,(GOODS ptr[ESI]).SELLPRICE   ;���ۼ�
		MOV BX,(GOODS ptr[ESI]).SELLNUM   ;��������
		IMUL BX    
		PUSH AX      ;�ۻ�
		
		MOV EAX,0
		MOV EBX,0
		pop AX
		POP BX
		SUB EAX,EBX 
		IMUL EAX,EAX,100
		CDQ
		idiv EBX
		
		MOV (GOODS ptr[ESI]).RATE,AX
		invoke printf,offset lpFmt3,EAX
		jmp ALLGOOD

ENDCalculate:
	pop ESI
	pop ebp
	ret
CalculateRate endp



;�Ľ�ǰ��ѡ������
SORTBEFORE proc
	push ebp
	mov ebp,esp

			;������δ���������Ǵ���һ���ṹ���飬�����ַ������
		
		MOV EAX, -1					;ѡ����һ���Ƚ���Ʒ
SORTKEEP:
		INC EAX                     ;�鿴��Ʒ�Ƿ������
		CMP EAX,AMOUNT
		JE FUNC5KEEP
		MOV EBX,EAX
		IMUL EBX,6
		MOV ECX,EAX
		IMUL ECX,20
		ADD ECX,offset GA1
		ADD EBX,offset SORT1
		MOV dx,(GOODS ptr [ECX]).RATE
		MOV (SORT ptr [EBX]).RATE,dx
		MOV [EBX],ECX
		JMP SORTKEEP



		;����Ϊѡ�������㷨
FUNC5KEEP:
		
		MOV AX,0
BEGINLOOP1:
		inc AX
		CMP AX,word ptr[AMOUNT]
	    Jnl ENDLOOP1
		dec AX
		MOV BX,AX
		MOV CX,AX
		INC CX
BEGINLOOP2:
		CMP CX,word ptr[AMOUNT]
		jnl ENDLOOP2
		MOV EDI,0
		MOV ESI,0
		MOV SI,CX
		MOV DI ,BX
		IMUL SI,6
		IMUL DI,6
		ADD SI,4
		ADD DI,4
		MOV DX,word ptr SORT1[DI]
		CMP word ptr SORT1[SI],DX
		jng GO
		MOV BX,CX
		GO:
		MOV EDI,0
		MOV ESI,0
		MOV SI,AX
		MOV DI ,BX
		IMUL SI,6
		IMUL DI,6
		MOV EDX,dword ptr[SORT1[SI]]
		XCHG EDX,dword ptr[SORT1[DI]]
		XCHG EDX,dword ptr[SORT1[SI]]
		ADD SI,4
		ADD DI,4
		MOV DX,word ptr[SORT1[SI]]
		XCHG DX,word ptr[SORT1[DI]]
		XCHG DX,word ptr[SORT1[SI]]
		INC CX
		JMP BEGINLOOP2
		ENDLOOP2:
		INC AX
		JMP BEGINLOOP1
ENDLOOP1:


	pop ebp
	ret

SORTBEFORE endp


;�Ľ��������
SORTAFTER proc
	push ebp
	mov ebp,esp

	;������δ���������Ǵ���һ���ṹ���飬�����ַ������
		MOV EAX, -1					;ѡ����һ���Ƚ���Ʒ
SORTKEEPAFTER:
		INC EAX                     ;�鿴��Ʒ�Ƿ������
		CMP EAX,AMOUNT
		JE FUNC5KEEPAFTER
		MOV EBX,EAX
		IMUL EBX,6
		MOV ECX,EAX
		IMUL ECX,20
		ADD ECX,offset GA1
		ADD EBX,offset SORT1
		MOV dx,[ECX+18]
		MOV [EBX+4],dx
		MOV [EBX],ECX
		JMP SORTKEEPAFTER


		;����Ϊѡ�������㷨
FUNC5KEEPAFTER:
		
		MOV AX,0
BEGINLOOP1AFTER:
		inc AX
		CMP AX,word ptr[AMOUNT]
	    Jnl ENDLOOP1AFTER
		dec AX

		MOV BX,AX
		MOV CX,AX
		INC CX
BEGINLOOP2AFTER:
		CMP CX,word ptr[AMOUNT]
		jnl ENDLOOP2AFTER
		MOV EDI,0
		MOV ESI,0
		MOV SI,CX
		MOV DI ,BX
		IMUL SI,6
		IMUL DI,6
		ADD SI,4
		ADD DI,4
		MOV DX,word ptr SORT1[DI]
		CMP word ptr SORT1[SI],DX
		jng GOAFTER
		MOV BX,CX


		GOAFTER:
		MOV EDI,0
		MOV ESI,0
		MOV SI,AX
		MOV DI ,BX
		IMUL SI,6
		IMUL DI,6
		MOV EDX,dword ptr[SORT1[SI]]
		push EDX
		MOV EDX,dword ptr[SORT1[DI]]
		MOV dword ptr[SORT1[SI]],EDX
		pop EDX
		MOV dword ptr[SORT1[DI]],EDX
		ADD SI,4
		ADD DI,4
		MOV DX,word ptr[SORT1[SI]]
		push DX
		MOV DX,word ptr[SORT1[DI]]
		MOV word ptr[SORT1[SI]],DX
		pop DX
		MOV word ptr[SORT1[DI]],DX

		INC CX
		JMP BEGINLOOP2AFTER
		ENDLOOP2AFTER:
		INC AX
		JMP BEGINLOOP1AFTER
ENDLOOP1AFTER:


		pop ebp
		ret
SORTAFTER endp

END
