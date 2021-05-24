 .686P     
.model flat, stdcall
 ExitProcess PROTO STDCALL :DWORD
 includelib  kernel32.lib  ; ExitProcess 在 kernel32.lib中实现
printf    PROTO C : dword,:vararg;对printf函数声明.
scanf    PROTO C : dword,:vararg;对scanf函数声明.
 includelib  libcmt.lib
 includelib  legacy_stdio_definitions.lib




timeGetTime proto stdcall
includelib  Winmm.lib




.DATA
;格式化输入输出的定义
lpFmt	db	"%s",0ah, 0dh, 0
lpFmt1	db	"%s", 0
lpFmt2  db	"%d", 0
lpFmt3	db	"%d",0ah,0dh, 0
lpFmt4	db	"%hd",0ah,0dh, 0
lpFmt5  db	"%s",0ah, 0dh, 0

NEWLINE DB ' ',0
;登陆选项
INPUTNAME	DB 'User Name:',0
OUTNAMEW DB 'Invalid User Name',0
INNAME	DB 20 DUP(0)
BNAME  	DB 'LiuYiKang', 0			;老板姓名

INPUTPWD	DB 'Password:',0
OUTPWDW DB 'Invalid Password',0
INPWD	DB 20 DUP(0)
BPASS  	DB 'U201914873', 0				;密码
SUCCESSIN DB 'Success login in',0

;菜单选项
MENUT	DB 'Please Enter a Number(1~9):',0
MENUT1 DB '1.Search for products and print information',0
MENUT2 DB '2.Shipment ',0
MENUT3 DB '3.Purchase ',0
MENUT4 DB '4.Calculate profit margin ',0
MENUT5 DB '5.Profit margin ranking ',0
MENUT6 DB 'Please Enter a Number(1~9):',0
CHOICE DB 0


;选项2出货
Shipment DB 0
Shipment_buf DB  'Please Enter Shipment quantity:',0
SOLDGOODS DB 'The goods have been sold:',0
NENOUGH DB 'There is not enough left:',0
;选项3进货
Replenishment DB 0
Replenishment_buf  DB  'Please Enter Replenishment quantity:',0
PURCHASEDGOODS DB 'The goods have been purchase:',0



;选择good选项
INGOODT DB 'Good Name:',0
INGOOD	DB 10 DUP(0)
NOGOODT	DB 'No Goods',0

;选项1输出信息
Purchase_price DB 'Purchase price:',0
Sales_price DB 'Sales price:',0
Purchase_quantity DB 'Purchase quantity:',0
Sold_quantity DB 'Sold quantity:',0


;选项5排序
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


AMOUNT Dword 9
GA1 GOODS <'PEN',15,20,70,25,?>
GA2 GOODS <'PENCIL',2,3,100,50,?>
GA3 GOODS <'BOOK',30,40,25,5,?>
GA4 GOODS <'RULER',3,4,200,150,?>
GA5 GOODS <'ERASER',15,20,70,25,?>
GA6 GOODS <'DIPPEN',20,35,100,35,?>
GA7 GOODS <'BOOK1',30,50,125,35,?>
GA8 GOODS <'BOOK2',3,6,80,50,?>
GA9 GOODS <'BOOK3',10,9,45,15,?>

GATEMP GOODS<>

SORT  STRUCT
pos DWORD 0
profit DW 0
SORT  ENDS


SORT1 SORT <1,0>
SORT2 SORT <2,0>
SORT3 SORT <3,0>
SORT4 SORT <4,0>
SORT5 SORT <5,0>
SORT6 SORT <6,0>
SORT7 SORT <7,0>
SORT8 SORT <8,0>
SORT9 SORT <9,0>
SORTN   SORT 1 DUP(<>)

BEGINTIME dword 0
ENDTIME DWORD 0
TIMECOST DWORD 0
ALLTIME DB 'Total time consumed after 1000000 cycles(ms):',0

.STACK 200



.CODE
main proc c
Start:
;输入用户名
invoke printf,offset lpFmt,OFFSET INPUTNAME
invoke scanf,offset lpFmt1,OFFSET INNAME

		MOV CL,10
		LEA EDI, INNAME
		LEA ESI, BNAME

CHECK_USER:							;逐字节比较用户名
		MOV AL, [EDI]
		CMP AL, [ESI]
		JNE WRONG_NAME
		INC EDI
		INC ESI
		DEC CL
		JNZ CHECK_USER
		
;输入密码
invoke printf,offset lpFmt,OFFSET INPUTPWD
invoke scanf,offset lpFmt1,OFFSET INPWD

		MOV CL,11
		LEA EDI, INPWD
		LEA ESI, BPASS

CHECK_PWD:							;逐字节比较用户名
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
invoke printf,offset lpFmt,OFFSET NEWLINE
JMP Start
WRONG_PWD:
invoke printf,offset lpFmt,OFFSET OUTPWDW
invoke printf,offset lpFmt,OFFSET NEWLINE
JMP Start

LOGIN_S:							;登陆成功
invoke printf,offset lpFmt,OFFSET NEWLINE
invoke printf,offset lpFmt,OFFSET SUCCESSIN
invoke printf,offset lpFmt,OFFSET NEWLINE






;菜单输出
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
		




invoke printf,offset lpFmt,OFFSET NEWLINE
invoke printf,offset lpFmt,OFFSET INGOODT			

MOV EBX,0
KEEP:
MOV INGOOD[EBX],0
inc EBX
CMP EBX,10
JL KEEP

invoke scanf,offset lpFmt1,OFFSET INGOOD

		MOV EAX, -1
CHECK_GOOD:							;选择下一个比较商品
		INC EAX                     ;查看商品是否查找完
		CMP EAX,AMOUNT

		JE NO_GOOD
		
		MOV ECX, EAX
		
		IMUL ECX, 20
		ADD ECX, OFFSET GA1     ;ECX此时存放当前商品的首地址
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
;查找指定商品并显示其信息：提示用户输入商品名称；
;用户输入名称后,在商店中寻找是否存在该商品；
;若存在,显示找到的商品信息；若没有找到,提示没有找到。最后都返回到主菜单界面。
FUNC1:
		;显示商品信息
		pop ECX
		MOV EDI, ECX
		invoke printf,offset lpFmt,OFFSET NEWLINE
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




FUNC2:   ;出货
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

FUNC3:   ;进货
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
		invoke printf,offset lpFmt,OFFSET NEWLINE
		invoke printf,offset lpFmt,OFFSET GOODSPROFIT
		MOV ESI, -1
		push ESI
ALLGOOD:							;选择下一个比较商品
		pop ESI
		INC ESI   ;查看商品是否查找完
		push ESI
		CMP ESI, AMOUNT
		JE FUNC5
		
		
		
		IMUL ESI, 20
		ADD ESI, OFFSET GA1     ;ECX此时存放当前商品的首地址
		push ESI

		invoke printf,offset lpFmt,ESI

		POP ESI


		
		ADD ESI,10
		
		MOV AL,[ESI]   ;进货价
		
		
		ADD ESI,4
		MOV BL,[ESI]   ;进货数量
		
		IMUL BL

		PUSH AX      ;进货



		SUB ESI,2
		MOV AL,[ESI]   ;销售价
		
		
		ADD ESI,4
		MOV BL,[ESI]   ;销售数量
		
		IMUL BL    

		PUSH AX      ;售货

		MOV EAX,0
		MOV EBX,0
		pop AX
		POP BX
		SUB EAX,EBX 
		IMUL EAX,EAX,100
		CDQ
		idiv EBX
		
		ADD ESI,2
		MOV [ESI],AX

		invoke printf,offset lpFmt3,EAX
		
		jmp ALLGOOD

FUNC5: 

		CALL timeGetTime
		LEA EBX,BEGINTIME
		MOV [EBX],EAX


		MOV EAX,10
BEGINTIMEGET:
		CMP Eax,0
		JBE GETTIME
		push EAX


		;以下这段代码的作用是创建一个结构数组，保存地址和利润
		

		MOV EAX, -1					;选择下一个比较商品
SORTKEEP:
		INC EAX                     ;查看商品是否查找完
		CMP EAX,AMOUNT
		JE FUNC5KEEP
		MOV EBX,EAX
		IMUL EBX,6
		MOV ECX,EAX
		IMUL ECX,20
		ADD ECX,offset GA1
		ADD EBX,offset SORT1
		MOV dx,[ECX+18]
		MOV [EBX+4],dx
		MOV [EBX],ECX
		JMP SORTKEEP



		;以下为选择排序算法

		
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
		;打印所需的时间
		
		invoke printf,offset lpFmt,OFFSET NEWLINE
		invoke printf,offset lpFmt,OFFSET ALLTIME
		invoke printf,offset lpFmt3,dword ptr[TIMECOST]
		invoke printf,offset lpFmt,OFFSET NEWLINE

;
;
;
;
;


		invoke printf,offset lpFmt,OFFSET SORTRESULT
				;显示商品信息
		MOV ebx,0
		LEA ECX,SORT1
PRINTFUNC5:		
		CMP ebx,AMOUNT
		push ECX
		push ebx
		jae ENDFUNC5
		
		MOV EDI, dword ptr[ECX]
		invoke printf,offset lpFmt1,EDI
		invoke printf,offset lpFmt,OFFSET NEWLINE
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
		ADD EDI,2
		invoke printf,offset lpFmt1,OFFSET PROFIT
		MOV AX,[EDI]
		invoke printf,offset lpFmt4,AX
		

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


		MOV EAX,10
BEGINTIMEGETAFTER:
		CMP Eax,0
		JBE GETTIMEAFTER
		push EAX


		;以下这段代码的作用是创建一个结构数组，保存地址和利润
		

		MOV EAX, -1					;选择下一个比较商品
SORTKEEPAFTER:
		INC EAX                     ;查看商品是否查找完
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



		;以下为选择排序算法

		
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
		;打印所需的时间
		invoke printf,offset lpFmt,OFFSET SORTIMPROVE
		invoke printf,offset lpFmt,OFFSET NEWLINE
		invoke printf,offset lpFmt,OFFSET ALLTIME
		invoke printf,offset lpFmt3,dword ptr[TIMECOST]
		invoke printf,offset lpFmt,OFFSET NEWLINE






		invoke printf,offset lpFmt,OFFSET SORTRESULT
				;显示商品信息
		MOV ebx,0
		LEA ECX,SORT1
PRINTFUNC5AFTER:		
		CMP ebx,AMOUNT
		push ECX
		push ebx
		jae ENDFUNC5AFTER
		
		MOV EDI, dword ptr[ECX]
		invoke printf,offset lpFmt1,EDI
		invoke printf,offset lpFmt,OFFSET NEWLINE
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
		ADD EDI,2
		invoke printf,offset lpFmt1,OFFSET PROFIT
		MOV AX,[EDI]
		invoke printf,offset lpFmt4,AX
		

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
END
