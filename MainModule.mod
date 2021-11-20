MODULE MainModule
    
    VAR socketdev server;
    VAR socketdev client;
    VAR string Client_IP;
    VAR string data := "";
    VAR string msg := "Hei Client";
    VAR string part;
    VAR num lenght;
    VAR string numberStr;
    VAR num numberN;
    VAR bool ok;
    VAR robtarget p1;
    VAR robtarget home;
    
    
    PROC main()
        home := CRobT(\Tool:=Griper_1 \WObj:=Workobject_1);
        SocketCreate server; 
        SocketBind server,"127.0.0.1",2222;
        SocketListen server;
        SocketAccept server, client,\ClientAddress:=Client_IP,\Time:=120;
        
        TPWrite "Client_IP: " + Client_IP;
        
        WHILE data <> "exit" DO 
        p1 := CRobT(\Tool:=Griper_1 \WObj:=Workobject_1);
        SocketReceive client \Str:=data;
        TPWrite "Data motatt: " + data;
        part := StrPart(data ,1,1);
        lenght := StrLen(data);
        numberStr := StrPart(data,2,lenght-1);
        ok := StrToVal(numberStr, numberN);
        
        IF part = "x" THEN
            
             MoveJ Offs(p1, numberN, 0, 0), v50, fine, Griper_1,\WObj:=Workobject_1;
             
        ELSEIF part = "y" THEN
            
             MoveJ Offs(p1, 0, numberN, 0), v50, fine, Griper_1,\WObj:=Workobject_1;  
             
        ELSEIF   part = "z" THEN
            
             MoveJ Offs(p1, 0, 0, numberN), v50, fine, Griper_1,\WObj:=Workobject_1;  
             
        ELSEIF data = "set" THEN
            
            Set DO10_2;
            Reset DO10_3;
            
        ELSEIF data = "reset" THEN    
            
            Set DO10_3;
            Reset DO10_2;
            
        ELSE 
            
            data := "exit";
            
            ENDIF
        
        
        SocketSend client \Str:=msg;
        
        ENDWHILE
        
        IF data = "exit" THEN
            
            MoveJ home, v50, fine, Griper_1,\WObj:=Workobject_1; 
        
        ENDIF
        
        IF data = "exit" THEN
            
            Set DO10_3;
            Reset DO10_2;
            
        ENDIF 
        
        
        SocketClose server;
        SocketClose client;
        
        
    EndProc
ENDMODULE