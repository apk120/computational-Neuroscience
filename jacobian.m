function jac = jacobian(y)
% MLODEJAC - computes Jacobian for MLE system.% To get the Jacobian, proceed in one of the two ways:% 1. t = 0; y = [state vector at the eq. pt. where the jacobian is desired];%    setmleparms(pml, iext)    
% Set parameters of MLE model%    jac = mlodejac(t, y)       
% Returns the jacobian%% 2. t = 0; y = [state vector]; fac = [];
%    setmleparms(pml, iext)%    [jacn,fac]=numjac(@mlode, t, y, mlode(t,y), [1e-5;1e-5],fac,0)
% Parameter vector:%          1    2   3   4    5   6   7    8   9  10  11  12  13  14 15   16
% pml=[gca, gk, gl, vca, vk, vl, phi, v1, v2, v3, v4, v5, v6, C, vic, wic]'% Get parameters:
pml=[4.4, 8.0, 2, 120, -84, -60, 0.02, -1.2, 18, 2, 30, 2, 30, 20, 0,  0];
iext = [0,   0,    0]';
%[pml,iext] = getmleparms;
% Compute Jacobian
minf= (exp((y(1)- pml(8))/pml(9))/ (exp((y(1)- pml(8))/pml(9))+ exp(-(y(1)- pml(8))/pml(9))));
tauw= 1/(cosh((y(1)-pml(10))/(2*pml(11))));
winf= 0.5*(1+ tanh((y(1)- pml(10))/pml(11)));
jac = zeros(2,2);
jac(1,1) = (-pml(1)*0.5/(pml(9)*cosh((y(1)-pml(8))/pml(9))^2)*(y(1)-pml(4))-pml(1)*minf- pml(2)*y(2)- pml(3))/pml(14);
jac(1,2) = -pml(2)*(y(1)-pml(5))/pml(14);
jac(2,1) = pml(7)*(0.5/(pml(11)*cosh((y(1)-pml(10))/pml(11))^2*tauw)-(winf-y(2))*sinh((y(1)-pml(12))/pml(13))/(2*pml(13)));
jac(2,2) = -pml(7)/tauw;
return
