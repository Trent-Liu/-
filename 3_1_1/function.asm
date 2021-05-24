.686P
.model flat,c
printf proto:vararg
extern lpFmt:sbyte
extern lpFmt1:sbyte
extern  lpFmt3:sbyte
extern NENOUGH: sbyte
extern SOLDGOODS: sbyte
extern UPDATEPRIOT: sbyte

GOODS1  STRUCT
GOODSNAME  db 10 DUP(0)
BUYPRICE   DW  0
SELLPRICE  DW  0
BUYNUM     DW  0
SELLNUM    DW  0
RATE       DW  0
GOODS1  ENDS




.code
;strcmp:比较两字符串是否相等
;
;

strcmp proc NEAR str1:dword,str2:dword 
	
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

strcmp endp


 
GOODSELL proc NEAR Shipment1:word,pos:dword 
	
	MOV EDI,pos
	MOV AX,(GOODS1 ptr [EDI]).BUYNUM		
	MOV BX,(GOODS1 ptr [EDI]).SELLNUM
	MOV DX,Shipment1
	SUB AX,BX
	CMP AX,DX
	JB NOTENOUGH

	ADD (GOODS1 ptr [EDI]).SELLNUM,DX
		
	
	invoke printf,offset lpFmt,OFFSET SOLDGOODS
	invoke printf,offset lpFmt3,(GOODS1 ptr [EDI]).SELLNUM
	invoke printf,offset lpFmt,OFFSET UPDATEPRIOT
	JMP ENDGOODSSELL
	NOTENOUGH:
	invoke printf,offset lpFmt,OFFSET NENOUGH
	ENDGOODSSELL:
	ret

GOODSELL endp
end