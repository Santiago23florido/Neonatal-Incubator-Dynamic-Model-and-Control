function [R,S,t_val] = incremental_rst(pl,delay,desired,ts)
    syms z
    nb=length(nonzeros(pl.Numerator{1}))-1;
    na=length(pl.Denominator{1})-1;
    nr=nb+delay-1
    ns=na
    syms r [1 nr+1]
    syms s [1 ns+1]
    r_z = 0;
    for i = 0:nr
        r_z = r_z + r(i+1) * z^i;
    end
    s_z = 0;
    for i = 0:ns
        s_z = s_z + s(i+1) * z^i;
    end
    q=poly2sym(flip(desired), z);
    b=poly2sym(flip(nonzeros(pl.Numerator{1})), z);
    a=poly2sym(flip(pl.Denominator{1}), z);
    e1=a*r_z*(1-z)+(z^delay)*b*s_z;
    % Calcula los coeficientes de ambos polinomios
    [coef_izq, ~] = coeffs(e1, z, 'ALL');
    [coef_der, ~] = coeffs(q, z, 'ALL');
    % Calcula los grados de ambos polinomios
    grado_izq = length(coef_izq) - 1;
    grado_der = length(coef_der) - 1;
    % Ajusta los coeficientes para que tengan la misma longitud
    if grado_izq > grado_der
        % Rellena coef_der con ceros a la izquierda
        coef_der = [zeros(1, grado_izq - grado_der), coef_der];
    elseif grado_der > grado_izq
        % Rellena coef_izq con ceros a la izquierda
        coef_izq = [zeros(1, grado_der - grado_izq), coef_izq];
    end
    ecuaciones = [];
    num_coef = min(length(coef_izq), length(coef_der));
    for i = 1:num_coef
        ecuaciones = [ecuaciones, coef_izq(i) == coef_der(i)];
    end
    syms t
    b1=subs(b,z,1);
    q1=subs(q,z,1);
    eq1=t*b1/q1==1;
    vec=solve([ecuaciones,eq1],[r,s,t]);
    % Convertir las soluciones en una celda
    sol_celda = struct2cell(vec);
    
    % Convertir cada elemento de la celda a valores numéricos y concatenarlos en un vector
    coefis = double([sol_celda{:}]);
    ecuaciones
    r_den=coefis(1:nr+1);
    s_num=coefis(nr+2:end-1);
    t_val=coefis(end);
    r_num=zeros(1,length(r_den));
    r_num(1)=1;
    s_den=zeros(1,length(s_num));
    s_den(1)=1;
    R=tf(r_num,r_den,ts);
    S=tf(s_num,s_den,ts);
end