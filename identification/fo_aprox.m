function po_tf = fo_aprox(Y,U,t)
    %APROXIMACION-PRIMER ORDEN CON DATOS
    t0=t(find(U ~= 0, 1));
    Y1 =Y(find(U ~= 0, 1));
    %k=(Y(end)-Y(find(U ~= 0, 1)))/(U(end)-U(1))
    k=(Y(end)-Y(1))/(U(end));
    t1_1=t(find(Y >= 0.283*(Y(end)-Y1)+Y1, 1))-t0;
    t2_1=t(find(Y >= 0.632*(Y(end)-Y1)+Y1, 1))-t0;
    retardo_1=(3*t1_1-t2_1)/2;
    tau1=(t1_1-retardo_1)*3;
    if retardo_1>0
        po_tf = tf([k], [tau1 1],'Inputdelay',retardo_1);
    else
        po_tf = tf([k], [tau1 1]);
    end
end