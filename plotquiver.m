function [DV, DW]= plotquiver(y)
    V=y(1);
    w= y(2);
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
    minf= (exp((V- V1)/V2)/ (exp((V- V1)/V2)+ exp(-(V- V1)/V2)));
    winf= 0.5*(1+ tanh((V- V3)/V4));
    tau= 1/(cosh((V-V3)/(2*V4)));
    %w= (Iext- gca*minf*(V- vca)- gl*(V - vl))/(gk*(V-vk));
    DV= (Iext-gca*minf*(V-vca) - gk*w*(V-vk) - gl*(V-vl))/C;
    DW= phi*( winf - w)/tau;
end

