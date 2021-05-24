.386
.model   flat,stdcall
option   casemap:none
WinMain  proto :DWORD,:DWORD,:DWORD,:DWORD
WndProc  proto :DWORD,:DWORD,:DWORD,:DWORD
Display  proto :DWORD
sprintf	proto C:DWORD,:DWORD,:vararg
CalculateRate	proto
SORT	proto

include      menuID.INC

include      windows.inc
include      user32.inc
include      kernel32.inc
include      gdi32.inc
include      shell32.inc

includelib   user32.lib
includelib   kernel32.lib
includelib   gdi32.lib
includelib   shell32.lib

 includelib  ucrt.lib
 includelib  legacy_stdio_definitions.lib
 includelib  Winmm.lib



GOODS  STRUCT
GOODSNAME  db 10 DUP(0)
BUYPRICE   DW  0
SELLPRICE  DW  0
BUYNUM     DW  0
SELLNUM    DW  0
RATE       DW  0

NAMELENGTH dw 0
BUYPRICELENGTH dw 0
SELLPRICELENGTH  DW  0
BUYNUMLENGTH     DW  0
SELLNUMLENGTH    DW  0
RATELENGTH       DW  0
GOODS  ENDS



.data
ClassName    db       'TryWinClass',0
AppName      db       'Our First Window',0
MenuName     db       'MyMenu',0
DlGOODSSNAME	     db       'MyDialog',0
AboutMsg     db       'I am CE1901 LiuYiKang',0
RecoMsg		 db		  'Calculate completed', 0
hInstance    dd       0
CommandLine  dd       0
msg_name     db       'name',0
msg_off db 'Off', 0
msg_BUYPRICE  db       'BuyPrice',0
msg_SELLPRICE     db       'SellPrice',0
msg_BUYNUM  db       'BuyAmount',0
msg_SELLNUM  db       'SellAmount',0
msg_RATE    db       'RATE',0
menuItem     db       0  


AMOUNT Dword 4
GA1   GOODS < 'PEN',15,20,70,25,0,3,2,2,2,2,3 >  ;��Ʒ1 ����, �����ۡ����ۼۡ�������������������,�����ʣ���δ���㣩
GA2   GOODS < 'PENCIL',2,3,100,50,0,6,1,1,3,2,3 >
GA3   GOODS < 'BOOK',30,40,25,5,0,4,2,2,2,1,3 >
GA4   GOODS < 'RULER',3,4,200,150,0,5,1,1,3,3,1 >

SORThelp  STRUCT
POS DWORD 0
RATE DW 0
SORThelp  ENDS


SORT1 SORThelp <1,0>
SORT2 SORThelp <2,0>
SORT3 SORThelp <3,0>
SORT4 SORThelp <4,0>

lpFmt  db	"%hd", 0
NAME dword 0
BUYPRICE   DB 5 DUP(0)
SELLPRICE  DB 5 DUP(0)
BUYNUM     DB 5 DUP(0)
SELLNUM    DB 5 DUP(0)
RATE       DB 5 DUP(0)

NAMELENGTH DW 0
.code
Start:	     invoke GetModuleHandle,NULL
	     mov    hInstance,eax
	     invoke GetCommandLine
	     mov    CommandLine,eax
	     invoke WinMain,hInstance,NULL,CommandLine,SW_SHOWDEFAULT
	     invoke ExitProcess,eax
	    
WinMain      proc   hInst:DWORD,hPrevInst:DWORD,CmdLine:DWORD,CmdShow:DWORD
	     LOCAL  wc:WNDCLASSEX
	     LOCAL  msg:MSG
	     LOCAL  hWnd:HWND
             invoke RtlZeroMemory,addr wc,sizeof wc
	     mov    wc.cbSize,SIZEOF WNDCLASSEX
	     mov    wc.style, CS_HREDRAW or CS_VREDRAW
	     mov    wc.lpfnWndProc, offset WndProc
	     mov    wc.cbClsExtra,NULL
	     mov    wc.cbWndExtra,NULL
	     push   hInst
	     pop    wc.hInstance
	     mov    wc.hbrBackground,COLOR_WINDOW+1
	     mov    wc.lpszMenuName, offset MenuName
	     mov    wc.lpszClassName,offset ClassName
	     invoke LoadIcon,NULL,IDI_APPLICATION
	     mov    wc.hIcon,eax
	     mov    wc.hIconSm,0
	     invoke LoadCursor,NULL,IDC_ARROW
	     mov    wc.hCursor,eax
	     invoke RegisterClassEx, addr wc
	     INVOKE CreateWindowEx,NULL,addr ClassName,addr AppName,\
                    WS_OVERLAPPEDWINDOW,CW_USEDEFAULT,\
                    CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,NULL,NULL,\
                    hInst,NULL
	     mov    hWnd,eax
	     INVOKE ShowWindow,hWnd,SW_SHOWNORMAL
	     INVOKE UpdateWindow,hWnd
	     ;;
MsgLoop:     INVOKE GetMessage,addr msg,NULL,0,0
             cmp    EAX,0
             je     ExitLoop
             INVOKE TranslateMessage,addr msg
             INVOKE DispatchMessage,addr msg
	     jmp    MsgLoop 
ExitLoop:    mov    eax,msg.wParam
	     ret
WinMain      endp

WndProc      proc   hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
	     LOCAL  hdc:HDC
	     LOCAL  ps:PAINTSTRUCT
     .IF     uMsg == WM_DESTROY
	     invoke PostQuitMessage,NULL
     .ELSEIF uMsg == WM_KEYDOWN
	    .IF     wParam == VK_F1
             ;;your code
	    .ENDIF
     .ELSEIF uMsg == WM_COMMAND
	    .IF     wParam == IDM_FILE_EXIT
		    invoke SendMessage,hWnd,WM_CLOSE,0,0
	    .ELSEIF wParam == IDM_ACTION_RECO
			invoke CalculateRate
			invoke MessageBox,hWnd,addr RecoMsg,addr AppName,0
	    .ELSEIF wParam == IDM_ACTION_LIST
		    mov menuItem, 1
		    invoke InvalidateRect,hWnd,0,1  
		    invoke UpdateWindow, hWnd
	    .ELSEIF wParam == IDM_HELP_ABOUT
		    invoke MessageBox,hWnd,addr AboutMsg,addr AppName,0
	    .ENDIF
     .ELSEIF uMsg == WM_PAINT
             invoke BeginPaint,hWnd, addr ps
             mov hdc,eax
	     .IF menuItem == 1
		 invoke Display,hdc
	     .ENDIF
	     invoke EndPaint,hWnd,addr ps
     .ELSE
             invoke DefWindowProc,hWnd,uMsg,wParam,lParam
             ret
     .ENDIF
  	     xor    eax,eax
	     ret
WndProc      endp

Display      proc   hdc:HDC
             Xpos     equ  10
             Ypos     equ  10
	     
			invoke SORT
             invoke TextOut,hdc,Xpos+0*100,Ypos+0*30,offset msg_name,4
             invoke TextOut,hdc,Xpos+1*100,Ypos+0*30,offset msg_BUYPRICE,8
             invoke TextOut,hdc,Xpos+2*100,Ypos+0*30,offset msg_SELLPRICE,9
             invoke TextOut,hdc,Xpos+3*100,Ypos+0*30,offset msg_BUYNUM,9
             invoke TextOut,hdc,Xpos+4*100,Ypos+0*30,offset msg_SELLNUM,10
			 invoke TextOut,hdc,Xpos+5*100,Ypos+0*30,offset msg_RATE,4
			 ;;

			 
			 LEA ECX,SORT1
			 MOV EDI, dword ptr[ECX]
			 invoke sprintf,OFFSET BUYPRICE,offset lpFmt,(GOODS ptr [EDI]).BUYPRICE
			 invoke sprintf,OFFSET SELLPRICE,offset lpFmt,(GOODS ptr [EDI]).SELLPRICE
			 invoke sprintf,OFFSET BUYNUM,offset lpFmt,(GOODS ptr [EDI]).BUYNUM
			 invoke sprintf,OFFSET SELLNUM,offset lpFmt,(GOODS ptr [EDI]).SELLNUM
			 invoke sprintf,OFFSET RATE,offset lpFmt,(GOODS ptr [EDI]).RATE
			


             invoke TextOut,hdc,Xpos+0*100,Ypos+1*30,SORT1.POS , (GOODS ptr [EDI]).NAMELENGTH
			 invoke TextOut,hdc,Xpos+1*100,Ypos+1*30,offset BUYPRICE, (GOODS ptr [EDI]).BUYPRICELENGTH
             invoke TextOut,hdc,Xpos+2*100,Ypos+1*30,offset SELLPRICE,(GOODS ptr [EDI]).SELLPRICELENGTH
             invoke TextOut,hdc,Xpos+3*100,Ypos+1*30,offset BUYNUM, (GOODS ptr [EDI]).BUYNUMLENGTH
             invoke TextOut,hdc,Xpos+4*100,Ypos+1*30,offset SELLNUM,(GOODS ptr [EDI]).SELLNUMLENGTH
             invoke TextOut,hdc,Xpos+5*100,Ypos+1*30,offset RATE, (GOODS ptr [EDI]).RATELENGTH


			 LEA ECX,SORT2
			 MOV EDI, dword ptr[ECX]
			 invoke sprintf,OFFSET BUYPRICE,offset lpFmt,(GOODS ptr [EDI]).BUYPRICE
			 invoke sprintf,OFFSET SELLPRICE,offset lpFmt,(GOODS ptr [EDI]).SELLPRICE
			 invoke sprintf,OFFSET BUYNUM,offset lpFmt,(GOODS ptr [EDI]).BUYNUM
			 invoke sprintf,OFFSET SELLNUM,offset lpFmt,(GOODS ptr [EDI]).SELLNUM
			 invoke sprintf,OFFSET RATE,offset lpFmt,(GOODS ptr [EDI]).RATE


			 invoke TextOut,hdc,Xpos+0*100,Ypos+2*30,SORT2.POS , (GOODS ptr [EDI]).NAMELENGTH
			 invoke TextOut,hdc,Xpos+1*100,Ypos+2*30,offset BUYPRICE, (GOODS ptr [EDI]).BUYPRICELENGTH
             invoke TextOut,hdc,Xpos+2*100,Ypos+2*30,offset SELLPRICE,(GOODS ptr [EDI]).SELLPRICELENGTH
             invoke TextOut,hdc,Xpos+3*100,Ypos+2*30,offset BUYNUM, (GOODS ptr [EDI]).BUYNUMLENGTH
             invoke TextOut,hdc,Xpos+4*100,Ypos+2*30,offset SELLNUM,(GOODS ptr [EDI]).SELLNUMLENGTH
             invoke TextOut,hdc,Xpos+5*100,Ypos+2*30,offset RATE, (GOODS ptr [EDI]).RATELENGTH


			 LEA ECX,SORT3
			 MOV EDI, dword ptr[ECX]
			 invoke sprintf,OFFSET BUYPRICE,offset lpFmt,(GOODS ptr [EDI]).BUYPRICE
			 invoke sprintf,OFFSET SELLPRICE,offset lpFmt,(GOODS ptr [EDI]).SELLPRICE
			 invoke sprintf,OFFSET BUYNUM,offset lpFmt,(GOODS ptr [EDI]).BUYNUM
			 invoke sprintf,OFFSET SELLNUM,offset lpFmt,(GOODS ptr [EDI]).SELLNUM
			 invoke sprintf,OFFSET RATE,offset lpFmt,(GOODS ptr [EDI]).RATE


             invoke TextOut,hdc,Xpos+0*100,Ypos+3*30,SORT3.POS , (GOODS ptr [EDI]).NAMELENGTH
			 invoke TextOut,hdc,Xpos+1*100,Ypos+3*30,offset BUYPRICE, (GOODS ptr [EDI]).BUYPRICELENGTH
             invoke TextOut,hdc,Xpos+2*100,Ypos+3*30,offset SELLPRICE,(GOODS ptr [EDI]).SELLPRICELENGTH
             invoke TextOut,hdc,Xpos+3*100,Ypos+3*30,offset BUYNUM, (GOODS ptr [EDI]).BUYNUMLENGTH
             invoke TextOut,hdc,Xpos+4*100,Ypos+3*30,offset SELLNUM,(GOODS ptr [EDI]).SELLNUMLENGTH
             invoke TextOut,hdc,Xpos+5*100,Ypos+3*30,offset RATE, (GOODS ptr [EDI]).RATELENGTH


			 LEA ECX,SORT4
			 MOV EDI, dword ptr[ECX]
			 invoke sprintf,OFFSET BUYPRICE,offset lpFmt,(GOODS ptr [EDI]).BUYPRICE
			 invoke sprintf,OFFSET SELLPRICE,offset lpFmt,(GOODS ptr [EDI]).SELLPRICE
			 invoke sprintf,OFFSET BUYNUM,offset lpFmt,(GOODS ptr [EDI]).BUYNUM
			 invoke sprintf,OFFSET SELLNUM,offset lpFmt,(GOODS ptr [EDI]).SELLNUM
			 invoke sprintf,OFFSET RATE,offset lpFmt,(GOODS ptr [EDI]).RATE


             invoke TextOut,hdc,Xpos+0*100,Ypos+4*30,SORT4.POS , (GOODS ptr [EDI]).NAMELENGTH
			 invoke TextOut,hdc,Xpos+1*100,Ypos+4*30,offset BUYPRICE, (GOODS ptr [EDI]).BUYPRICELENGTH
             invoke TextOut,hdc,Xpos+2*100,Ypos+4*30,offset SELLPRICE,(GOODS ptr [EDI]).SELLPRICELENGTH
             invoke TextOut,hdc,Xpos+3*100,Ypos+4*30,offset BUYNUM, (GOODS ptr [EDI]).BUYNUMLENGTH
             invoke TextOut,hdc,Xpos+4*100,Ypos+4*30,offset SELLNUM,(GOODS ptr [EDI]).SELLNUMLENGTH
             invoke TextOut,hdc,Xpos+5*100,Ypos+4*30,offset RATE, (GOODS ptr [EDI]).RATELENGTH

			 ;;
             ret
Display      endp

CalculateRate proc
	push ebp
	mov ebp,esp

		MOV ESI, -1
		push ESI
ALLGOOD:							;ѡ����һ���Ƚ���Ʒ
		pop ESI
		INC ESI   ;�鿴��Ʒ�Ƿ������
		push ESI
		CMP ESI, AMOUNT
		JE ENDCalculate

		IMUL ESI, 32
		ADD ESI, OFFSET GA1     ;ESI��ʱ��ŵ�ǰ��Ʒ���׵�ַ
		MOV EAX,0
		MOV EBX,0

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
		jmp ALLGOOD

ENDCalculate:
	pop ESI
	pop ebp
	ret
CalculateRate endp

SORT proc
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
		IMUL ECX,32
		ADD ECX,offset GA1
		ADD EBX,offset SORT1
		MOV dx,[ECX+18]
		MOV [EBX+4],dx
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
		JMP BEGINLOOP2
		ENDLOOP2:
		INC AX
		JMP BEGINLOOP1
ENDLOOP1:


		pop ebp
		ret
SORT endp
             end  Start