gca= 4.4;
gk= 8.0;
gl= 2;
vca= 120;
vk= -84;
vl= 60;
phi= 0.02;
V1= -1.2;
V2= 18;
V3= 2;
V4= 30;
V5= 2;
V6= 30;
C= 20;
arr_w_inf= zeros(200/0.1, 1);
arr_w= zeros(200/0.1, 1);
arr_V= zeros(200/0.1, 1);
i=1;
for V= -80:0.1:120
    [minf, winf, w, tau]= minfv(V);
    arr_w_inf(i)= winf;
    arr_w(i)= w;
    arr_V(i)= V;
    i= i+1;
end;

err= immse(arr_w(1), arr_w_inf(1))
m=1;
for i1= 1:300
    if immse(arr_w(i1), arr_w_inf(i1))< err
        immse(arr_w(i1), arr_w_inf(i1))
        m=i1;
        err= immse(arr_w(i1), arr_w_inf(i1))
    end
end
;
fun = @root2d;
x0 = [-80,0, 0, 0];
x = fsolve(fun,x0)%,options)
disp(arr_V(m))

jac= jacobian([x(1); x(2)])
e = eig(jac)


[x,y] = meshgrid(-80:10:30,0:0.005:0.05);
%[u, v]= plotquiver([x,y])
u= zeros(11, 12);
v= zeros(11, 12);
for i= 1:11
    for j=1: 12
        [u(i, j), v(i,j)]= plotquiver([x(i,j), y(i,j)]);
    end
end
figure
plot(arr_V, arr_w);
hold on;
plot (arr_V, arr_w_inf);
quiver(x,y,u,v)