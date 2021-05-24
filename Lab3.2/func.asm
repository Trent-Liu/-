PRINTGOOD macro POS
		MOV EDI,POS
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

.686
.model flat,C
 ExitProcess PROTO STDCALL :DWORD
 includelib  kernel32.lib  ; ExitProcess 在 kernel32.lib中实现
printf    PROTO C : dword,:vararg;对printf函数声明.
scanf    PROTO C : dword,:vararg;对scanf函数声明.
strcmp proto:dword,:dword
GOODSELL proto:word,:dword
 includelib  libcmt.lib
 includelib  legacy_stdio_definitions.lib
 includelib  legacy_stdio_definitions.lib
 timeGetTime proto stdcall
includelib  Winmm.lib

public AMOUNT
public GA1

.data
;格式化输入输出的定义
lpFmt	db	"%s",0ah, 0dh, 0
lpFmt1	db	"%s", 0
lpFmt2  db	"%d", 0
lpFmt3	db	"%d",0ah,0dh, 0
lpFmt4	db	"%hd",0ah,0dh, 0
lpFmt5  db	"%s",0ah, 0dh, 0
NEWLINE DB ' ',0
;选择good选项
INGOODT DB 'Good Name:',0
INGOOD	DB 10 DUP(0)
NOGOODT	DB 'No Goods',0

;输出商品信息选项
Purchase_price DB 'Purchase price:',0
Sales_price DB 'Sales price:',0
Purchase_quantity DB 'Purchase quantity:',0
Sold_quantity DB 'Sold quantity:',0
PROFIT DB 'profit margin :',0

;选项2出货
Shipment word 0
Shipment_buf DB  'Please Enter Shipment quantity:',0
SOLDGOODS DB 'The goods have been sold:',0
NENOUGH DB 'There is not enough left:',0
UPDATEPRIOT DB 'Priority Updated',0

;选项3进货
Replenishment word 0
Replenishment_buf  DB  'Please Enter Replenishment quantity:',0
PURCHASEDGOODS DB 'The goods have been purchase:',0

;选项4计算利润率
GOODSPROFIT DB 'GOODS profit margin:',0
;选项5利润率排序
SORTRESULT DB 'In order of profit margin :',0
SORTIMPROVE DB 'After code optimization :',0

;商品结构定义
GOODS  STRUCT
GOODSNAME  db 10 DUP(0)
BUYPRICE   DW  0
SELLPRICE  DW  0
BUYNUM     DW  0
SELLNUM    DW  0
RATE       DW  0
GOODS  ENDS

;具体商品信息
AMOUNT Dword 4
GA1   GOODS < 'PEN',15,20,70,25,0 >  ;商品1 名称, 进货价、销售价、进货数量、已售数量,利润率（尚未计算）
GA2   GOODS < 'PENCIL',2,3,100,50,0 >
GA3   GOODS < 'BOOK',30,40,25,5,0 >
GA4   GOODS < 'RULER',3,4,200,150,0 >
GAN   GOODS 6 DUP(<>)
GATEMP GOODS<>

;辅助排序结构定义
SORT  STRUCT
POS DWORD 0
RATE DW 0
SORT  ENDS

;排序辅助变量
SORT1 SORT <1,0>
SORT2 SORT <2,0>
SORT3 SORT <3,0>
SORT4 SORT <4,0>
SORTN   SORT 6 DUP(<>)


;计时变量定义及提示语句
BEGINTIME dword 0
ENDTIME DWORD 0
TIMECOST DWORD 0
ALLTIME DB 'Total time consumed after 1000000 cycles(ms):',0


.STACK 200

.code

;strcmp:比较两字符串是否相等
;
;

strcmp1 proc str1:dword,str2:dword
	push esi
	push edi
	push edx
	MOV edi,str1
	MOV esi,str2
strcmp_start:
	mov dl,[edi]
	cmp dl,[esi]
	ja strcmp_large
	jb strcmp_little
	cmp dl,0
	je strcmp_equ
	inc esi
	inc edi
	jmp strcmp_start
strcmp_large:
	mov eax,1
	jmp strcmp_exit
strcmp_little:
	 mov eax,-1
	 jmp strcmp_exit
strcmp_equ:
	mov eax,0
strcmp_exit:
	pop edx
	pop edi
	pop esi
	ret
strcmp1 endp


GOODSELL proc Shipment1:word,pos:dword
	
	MOV EDI,pos
	MOV AX,(GOODS ptr [EDI]).BUYNUM		
	MOV BX,(GOODS ptr [EDI]).SELLNUM
	MOV DX,Shipment1
	SUB AX,BX
	CMP AX,DX
	JB NOTENOUGH

	ADD (GOODS ptr [EDI]).SELLNUM,DX
		
	invoke printf,offset lpFmt1,OFFSET SOLDGOODS
	invoke printf,offset lpFmt3,(GOODS ptr [EDI]).SELLNUM
	invoke printf,offset lpFmt,OFFSET UPDATEPRIOT
	JMP ENDGOODSSELL
	NOTENOUGH:
	invoke printf,offset lpFmt,OFFSET NENOUGH
	ENDGOODSSELL:
	ret

GOODSELL endp

SearchGOOD proc str1:dword,str2:dword
	;输入商品名，并查找到相应的位置
	invoke printf,offset lpFmt,OFFSET NEWLINE
	invoke printf,offset lpFmt,OFFSET INGOODT			

	MOV EBX,0        ;INGGOD初始化为空，为二次选择做准备
	KEEP:
	MOV INGOOD[EBX],0
	inc EBX
	CMP EBX,10
	JL KEEP
	invoke scanf,offset lpFmt1,OFFSET INGOOD

		MOV EBX, -1
CHECK_GOOD:							;选择下一个比较商品
		INC EBX                     ;查看商品是否查找完
		CMP EBX,AMOUNT
		JE NO_GOOD
		MOV ECX, EBX
		IMUL ECX, 20
		ADD ECX, OFFSET GA1     ;ECX此时存放当前商品的首地址
		push ECX
		push offset INGOOD
		call strcmp1
		add esp,8
		cmp eax,0
		jne CHECK_GOOD
		jmp  EXITFUNC1
NO_GOOD:
invoke printf,offset lpFmt,OFFSET NOGOODT
		
EXITFUNC1:
	ret
SearchGOOD endp

; 计算利润率
CalculateRate proc
	push ebp
	mov ebp,esp

		invoke printf,offset lpFmt,OFFSET NEWLINE
		invoke printf,offset lpFmt,OFFSET GOODSPROFIT
		MOV ESI, -1
		push ESI
ALLGOOD:							;选择下一个比较商品
		pop ESI
		INC ESI   ;查看商品是否查找完
		push ESI
		CMP ESI, AMOUNT
		JE ENDCalculate

		IMUL ESI, 20
		ADD ESI, OFFSET GA1     ;ESI此时存放当前商品的首地址
		MOV EAX,0
		MOV EBX,0
		invoke printf,ESI
		invoke printf,offset lpFmt,OFFSET NEWLINE

		MOV AX,(GOODS ptr[ESI]).BUYPRICE   ;进货价
		MOV BX,(GOODS ptr[ESI]).BUYNUM   ;进货数量
		IMUL BX
		PUSH AX      ;进货

		MOV AX,(GOODS ptr[ESI]).SELLPRICE   ;销售价
		MOV BX,(GOODS ptr[ESI]).SELLNUM   ;销售数量
		IMUL BX    
		PUSH AX      ;售货
		
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



;改进前的选择排序
SORTBEFORE proc
	push ebp
	mov ebp,esp

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
		MOV dx,(GOODS ptr [ECX]).RATE
		MOV (SORT ptr [EBX]).RATE,dx
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


	pop ebp
	ret

SORTBEFORE endp


;改进后的排序
SORTAFTER proc
	push ebp
	mov ebp,esp

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


		pop ebp
		ret
SORTAFTER endp


FUNC1	PROC 		 				;功能1
		call SearchGOOD
		;MOV EDI,ECX
		PRINTGOOD ECX

		ret
FUNC1 endp


FUNC2 PROC
	call SearchGOOD
	push ECX
	invoke printf,offset lpFmt,OFFSET Shipment_buf
	invoke scanf,offset lpFmt2,OFFSET Shipment
	pop ECX
	invoke GOODSELL,Shipment,ECX
	
	ret
FUNC2 endp

FUNC3 PROC
	call SearchGOOD
	push ECX
	invoke printf,offset lpFmt,OFFSET Replenishment_buf
		invoke scanf,offset lpFmt2,OFFSET Replenishment
		pop EDI
		MOV DX,Replenishment
		ADD (GOODS ptr [EDI]).BUYNUM,DX
		invoke printf,offset lpFmt1,OFFSET PURCHASEDGOODS
		invoke printf,offset lpFmt3,(GOODS ptr [EDI]).BUYNUM
		invoke printf,offset lpFmt,OFFSET UPDATEPRIOT

		ret
FUNC3 endp

FUNC4 PROC
CALL CalculateRate
ret
FUNC4 endp

FUNC5 PROC

CALL timeGetTime
		LEA EBX,BEGINTIME
		MOV [EBX],EAX


		MOV EAX,3
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
		;打印所需的时间
		
		invoke printf,offset lpFmt,OFFSET NEWLINE
		invoke printf,offset lpFmt,OFFSET ALLTIME
		invoke printf,offset lpFmt3,dword ptr[TIMECOST]
		invoke printf,offset lpFmt,OFFSET NEWLINE

;排序完成，按照顺序打印商品信息
		invoke printf,offset lpFmt,OFFSET SORTRESULT
				;显示商品信息
		MOV ebx,0
		LEA ECX,SORT1
PRINTFUNC5:		
		CMP ebx,AMOUNT
		push ECX
		push ebx
		jae ENDFUNC5
		
		;MOV EDI, 
		PRINTGOOD dword ptr[ECX]
		
		pop ebx
		inc ebx
		pop ECX
		ADD ECX,6

		JMP PRINTFUNC5

ENDFUNC5:
pop EBX
pop ECX

		invoke printf,offset lpFmt,OFFSET NEWLINE
		invoke printf,offset lpFmt,OFFSET NEWLINE

		MOV EAX,0


CALL timeGetTime
		LEA EBX,BEGINTIME
		MOV [EBX],EAX


		MOV EAX,3
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
		
		;MOV EDI, 
		PRINTGOOD dword ptr[ECX]
		

		pop ebx
		inc ebx
		pop ECX
		ADD ECX,6

		JMP PRINTFUNC5AFTER

ENDFUNC5AFTER:
pop EBX
pop ECX

ret


FUNC5 endp

		end
