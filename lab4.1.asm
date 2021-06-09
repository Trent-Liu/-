.386
STACK   SEGMENT  USE16  STACK       ;主程序的堆栈段
        DB  200  DUP(0)
STACK   ENDS



CODE    SEGMENT  USE16
        ASSUME  CS:CODE, DS:CODE, SS: STACK
;新INT08H使用的变量
    COUNT   DB  18          ;滴答计数
    HOUR    DB  ?,?,':'     ;时的ASCII码
    MIN     DB  ?,?,':'     ;分的ASCII码
    SEC     DB  ?,?         ;秒的ASCII码
    BUF_LEN=$-HOUR          ;显示信息的长度
    CURSOR  DW  ?           ;原光标位置
    OLD_INT DW  ?,?         ;原INT 08H的中断矢量

    INSTALLED_HINT DB 0DH,0AH,'Program has been installed yet.',0DH, 0AH,0DH, 0AH, '$'
    TMP      DB ?,?

    ;新的INT 08H代码
    NEW08H  PROC    FAR
        PUSHF
        CALL DWORD PTR CS:OLD_INT   ;完成原功能(变量在汇编后使用的默认段寄存器为DS，所以必须前面加上CS)
        DEC  CS:COUNT               ;倒计数
        JZ   DISP                   ;计数满18次，转时钟显示
        IRET                        ;未计满，中断返回
        
    DISP:   MOV  CS:COUNT,18            ;重置计数器
        STI                         ;开中断
        PUSHA                       ;保护现场
        PUSH DS
        PUSH ES
        MOV  AX,CS                  ;将DS、ES指向CS
        MOV  DS,AX
        MOV  ES,AX
        CALL GET_TIME               ;获取当前时间，并转换成ASCII码
        MOV  BH,0                   ;获取0号显示页面当前的光标位置 TODO:
        MOV  AH,3
        INT  10H
        MOV  CURSOR,DX              ;保存原光标位置
        MOV  BP,OFFSET HOUR         ;ES:[BP]指向显示信息的起始地址
        MOV  BH,0                   ;显示到0号页面
        MOV  DH,0                   ;显示在第0行 TODO:
        MOV  DL,79-BUF_LEN          ;显示在最后几列（光标设置在右上角）
        MOV  BL,07H                 ;显示的字符属性为白色
        MOV  CX,BUF_LEN             ;显示的字符串长度
        MOV  AL,0                   ;BL包含显示属性，写后光标不懂
        MOV  AH,13H                 ;调用显示字符串功能
        INT  10H                    ;右上角显示当前时间
        MOV  BH,0                   ;对0号页面操作
        MOV  DX,CURSOR              ;恢复光标
        MOV  AH,2                   ;设置光标位置的功能号
        INT  10H                    ;还原光标位置
        POP  ES
        POP  DS
        POPA                        ;恢复现场
        IRET                        ;中断返回
NEW08H  ENDP

;取时间的子程序，从RT/CMOS RAM中取得时分秒并转化成ASCII码存放到对应变量中
GET_TIME PROC
        MOV  AL,4                   ;设置“时”的信息偏移地址
        OUT  70H,AL                 ;设定将要访问的单元时偏移之为AL的信息
        JMP  $+2                    ;延时，保证端口操作有效
        IN   AL,71H                  ;读取“时”信息
        MOV  AH,AL                  ;将2位压缩的BCD码转化为未压缩的BCD码
        AND  AL,0FH
        SHR  AH,4
        ADD  AX,3030H               ;转换成对应ASCII码
        XCHG AH,AL                  ;高位在前面显示
        MOV  WORD PTR HOUR,AX       ;保存到HOUR变量指示的前两个字节中
        MOV  AL,2                   ;同理，获取“分”的信息，2为其偏移地址
        OUT  70H,AL
        JMP  $+2
        IN   AL,71H
        MOV  AH,AL
        AND  AL,0FH
        SHR  AH,4
        ADD  AX,3030H
        XCHG AH,AL
        MOV  WORD PTR MIN,AX        ;保存到MIN变量指示的前两个字节中
        MOV  AL,0                   ;获取“秒”的信息偏移地址
        OUT  70H,AL
        JMP  $+2
        IN   AL,71H
        MOV  AH,AL
        AND  AL,0FH
        SHR  AH,4
        ADD  AX,3030H
        XCHG AH,AL
        MOV  WORD PTR SEC,AX        ;保存到SEC变量指示的两个字节中
        RET
GET_TIME ENDP

;初始化（中断处理程序的安装）及主程序
BEGIN:  PUSH CS
        POP  DS

        
        ;--------------------------------------------------------------------------
        ;INT 21 : AH=35时，获取标号为AL的中断的偏移地址，存放到BX
        MOV  AX,3508H               ;利用INT 21H 的35H入口参数获取原来08H的中断矢量
        INT  21H                    ;系统功能调用35H的入口/出口参数，返回中断向量ES:BX
        MOV  OLD_INT,BX             ;保存中断矢量

        ;BX为当前中断为8的偏移地址，判断与NEW08H是否相同，则可以判断出NEW08H是否已被安装
        CMP  bx, OFFSET NEW08H
        JZ INSTALLED
        
        MOV  OLD_INT+2,ES           

        ;INT 21 : AH=25时，设置标号为AL的中断的偏移地址，设为DX
        MOV  DX,OFFSET NEW08H
        MOV  AX,2508H               ;利用25入口设置新的中断向量
        INT  21H


        



NEXT:   MOV  AH,0                   ;等待按键
        INT  16H
        CMP  AL,'q'
        JNE  NEXT                   ;如果按下了q则退出


       ;------------------------------------------
       ;设置驻留退出 
        MOV DX,OFFSET BEGIN+15    
        MOV CL,4
        SHR DX,CL
        ADD DX,10H
        MOV AL,0
        MOV AH,31H
        INT 21H
        ;-------------------------------------------

INSTALLED:
       LEA   DX, INSTALLED_HINT  ; 显示提示串
       MOV   AH, 9
       INT   21H  
       JMP   NEXT 




CODE    ENDS
        END      BEGIN