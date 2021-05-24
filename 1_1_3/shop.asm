 .386     
.model flat, stdcall
 ExitProcess PROTO STDCALL :DWORD
 includelib  kernel32.lib  ; ExitProcess �� kernel32.lib��ʵ��
printf    PROTO C : dword,:vararg;��printf��������.
scanf    PROTO C : dword,:vararg;��scanf��������.
 includelib  libcmt.lib
 includelib  legacy_stdio_definitions.lib

.DATA
lpFmt	db	"%s",0ah, 0dh, 0
lpFmt1	db	"%s", 0
lpFmt2  db	"%d", 0
lpFmt3	db	"%d",0ah,0dh, 0


INPUTNAME	DB 'User Name:',0
OUTNAMEW DB 'Invalid User Name',0
INNAME	DB 20 DUP(0)
BNAME  	DB 'LiuYiKang', 0			;�ϰ�����

INPUTPWD	DB 'Password:',0
OUTPWDW DB 'Invalid Password',0
INPWD	DB 20 DUP(0)
BPASS  	DB 'U201914873', 0				;����


MENUT	DB 'Please Enter a Number(1~9):',0

CHOICE DB 0

Shipment DB 0
Shipment_buf DB  'Please Enter Shipment quantity:',0

Replenishment DB 0
Replenishment_buf  DB  'Please Enter Replenishment quantity:',0


SUCCESSIN DB 'Login in',0



INGOODT DB 'Good Name:',0
WRONGGOODT DB 'Invalid Good Name',0

INGOOD	DB 10 DUP(0)


NOGOODT	DB 'No Goods',0

Purchase_price DB 'Purchase price:',0
Sales_price DB 'Sales price:',0
Purchase_quantity DB 'Purchase quantity:',0
Sold_quantity DB 'Sold quantity:',0




SOLDGOODS DB 'The goods have been sold:',0
NENOUGH DB 'There is not enough left:',0
PURCHASEDGOODS DB 'The goods have been purchase:',0


UPDATEPRIOT DB 'Priority Updated',0



N		EQU	30



GA1   DB   'PEN', 7 DUP(0)  ;��Ʒ1 ����
      DW   15,20,70,25,?  ; �����ۡ����ۼۡ�������������������,�����ʣ���δ���㣩
GA2   DB  'PENCIL', 4 DUP(0) ;��Ʒ2 ����
      DW   2,3,100,50,?
GA3   DB   'BOOK', 6 DUP(0) ;��Ʒ3 ����
      DW   30,40,25,5,?
GA4   DB   'RULER',5 DUP(0)  ;��Ʒ4 ����
      DW   3,4,200,150,?
GAN   DB N-4 DUP( 'Temp',6 DUP(0) ,0,15,0,20,0,30,0,2,?,?) 





.STACK 200



.CODE
main proc c
Start:
;�����û���
invoke printf,offset lpFmt,OFFSET INPUTNAME
invoke scanf,offset lpFmt1,OFFSET INNAME

		MOV CL,9
		LEA EDI, INNAME
		LEA ESI, BNAME

CHECK_USER:							;���ֽڱȽ��û���
		MOV AL, [EDI]
		CMP AL, [ESI]
		JNE WRONG_NAME
		INC EDI
		INC ESI
		DEC CL
		JNZ CHECK_USER
		
;��������
invoke printf,offset lpFmt,OFFSET INPUTPWD
invoke scanf,offset lpFmt1,OFFSET INPWD

		MOV CL,10
		LEA EDI, INPWD
		LEA ESI, BPASS

CHECK_PWD:							;���ֽڱȽ��û���
		MOV AL, [EDI]
		CMP AL, [ESI]
		JNE WRONG_PWD
		INC EDI
		INC ESI
		DEC CL
		JNZ CHECK_PWD

		JMP LOGIN_S

WRONG_NAME:
invoke printf,offset lpFmt,OFFSET OUTNAMEW
JMP Start
WRONG_PWD:
invoke printf,offset lpFmt,OFFSET OUTPWDW
JMP Start

LOGIN_S:							;��½�ɹ�
invoke printf,offset lpFmt,OFFSET SUCCESSIN


MENU:	
invoke printf,offset lpFmt,OFFSET MENUT
		invoke scanf,offset lpFmt1,OFFSET CHOICE
		
		LEA EDI, CHOICE
		MOV AL, [EDI]
		
	
		CMP AL, '4'
		JE FUNC4
		
		CMP AL, '9'
		JE OVER
		





invoke printf,offset lpFmt,OFFSET INGOODT			

MOV EBX,0
KEEP:
MOV INGOOD[EBX],0
inc EBX
CMP EBX,10
JL KEEP

invoke scanf,offset lpFmt1,OFFSET INGOOD

		MOV EAX, -1
CHECK_GOOD:							;ѡ����һ���Ƚ���Ʒ
		INC EAX                     ;�鿴��Ʒ�Ƿ������
		CMP EAX, 4
		JE NO_GOOD
		
		MOV ECX, EAX
		
		IMUL ECX, 20
		ADD ECX, OFFSET GA1     ;ECX��ʱ��ŵ�ǰ��Ʒ���׵�ַ
		push ECX


		MOV BL,10
		MOV EDI, ECX
		LEA ESI, INGOOD

CHECK_NAME:					
		MOV DL, [EDI]
		CMP DL, [ESI]
		JNE CHECK_GOOD
		INC EDI
		INC ESI
		DEC BL
		JNZ CHECK_NAME

		jmp  NEEDGOODS

NO_GOOD:
invoke printf,offset lpFmt,OFFSET NOGOODT
		JMP MENU


NEEDGOODS:
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
		MOV EDI, ECX
		invoke printf,offset lpFmt,EDI
		ADD EDI,10
		invoke printf,offset lpFmt1,OFFSET Purchase_price
		MOV AX,[EDI]
		invoke printf,offset lpFmt3,AX
		ADD EDI,2
		invoke printf,offset lpFmt1,OFFSET Sales_price
		MOV AX,[EDI]
		invoke printf,offset lpFmt3,AX
		ADD EDI,2
		invoke printf,offset lpFmt1,OFFSET Purchase_quantity
		MOV AX,[EDI]
		invoke printf,offset lpFmt3,AX
		ADD EDI,2
		invoke printf,offset lpFmt1,OFFSET Sold_quantity
		MOV AX,[EDI]
		invoke printf,offset lpFmt3,AX
		
		JMP MENU




FUNC2:
		invoke printf,offset lpFmt,OFFSET Shipment_buf
		invoke scanf,offset lpFmt2,OFFSET Shipment
		POP ECX
		MOV EDI, ECX
		ADD EDI,14
		MOV AL,[EDI]
		add EDI,2
		MOV BL,[EDI]
		MOV DL,Shipment
		SUB AL,BL
		CMP AL,DL
		JB NOTENOUGH

		ADD [EDI],DL
		
	
		invoke printf,offset lpFmt1,OFFSET SOLDGOODS
		MOV AX,[EDI]
		invoke printf,offset lpFmt3,AX

		invoke printf,offset lpFmt,OFFSET UPDATEPRIOT

		JMP MENU
NOTENOUGH:
		invoke printf,offset lpFmt,OFFSET NENOUGH
JMP MENU

FUNC3:
		invoke printf,offset lpFmt,OFFSET Replenishment_buf
		invoke scanf,offset lpFmt2,OFFSET Replenishment
		POP ECX
		MOV EDI, ECX
		ADD EDI,14
		MOV DL,Replenishment
		ADD [EDI],DL
		invoke printf,offset lpFmt1,OFFSET PURCHASEDGOODS
		MOV AX,[EDI]
		invoke printf,offset lpFmt3,AX

		invoke printf,offset lpFmt,OFFSET UPDATEPRIOT

		JMP MENU
FUNC4:


		MOV ESI, -1
		push ESI
ALLGOOD:							;ѡ����һ���Ƚ���Ʒ
		pop ESI
		INC ESI   ;�鿴��Ʒ�Ƿ������
		push ESI
		CMP ESI, 4
		JE MENU
		
		
		
		IMUL ESI, 20
		ADD ESI, OFFSET GA1     ;ECX��ʱ��ŵ�ǰ��Ʒ���׵�ַ
		push ESI

		invoke printf,offset lpFmt,ESI

		POP ESI


		
		ADD ESI,10
		
		MOV AL,[ESI]   ;������
		
		
		ADD ESI,4
		MOV BL,[ESI]   ;��������
		
		IMUL BL

		PUSH AX      ;����



		SUB ESI,2
		MOV AL,[ESI]   ;���ۼ�
		
		
		ADD ESI,4
		MOV BL,[ESI]   ;��������
		
		IMUL BL    

		PUSH AX      ;�ۻ�

		MOV EAX,0
		MOV EBX,0
		pop AX
		POP BX
		SUB EAX,EBX 
		IMUL EAX,EAX,100
		CDQ
		idiv EBX
		
		
		
		invoke printf,offset lpFmt3,EAX
		jmp ALLGOOD



OVER:
	invoke printf,offset lpFmt,ESI
main endp
END
