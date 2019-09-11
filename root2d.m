function F = root2d(x)% Fsolve method (search)
    gca= 4.4;
    gk= 8.0;
    gl= 2;
    vca= 120;
    vk= -84;
    vl= -60;
    phi= 0.02;
    V1= -1.2;
    V2= 18;
    V3= 2;
    V4= 30;
    V5= 2;
    V6= 30;
    C= 20;
    Iext=0;
    %x(1)= V, x(2)=w, x(3)= winf, x(4)= minf
    F(1) = x(3)-0.5*(1+ tanh((x(1)- V3)/V4));
    F(2) = x(2)-(Iext- gca*x(4)*(x(1)- vca)- gl*(x(1) - vl))/(gk*(x(1)-vk));
    F(3)= x(4)-(exp((x(1)- V1)/V2)/ (exp((x(1)- V1)/V2)+ exp(-(x(1)- V1)/V2)));
    F(4)= x(3)- x(2)
end