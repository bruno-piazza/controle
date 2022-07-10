%% Sintonia por Lugar das Raízes (Executar célula por célula)
clc
clear
close all
%% Parâmetros do sistema

A = importdata('matrix_A1lin.txt');
B = -importdata('matrix_B1lin.txt');
C = importdata('matrix_C1.txt');
D = importdata('matrix_D1.txt');
t = 0:0.01:10;

%% Construção do sistema via espaço de estados
sysSS=ss(A,B,C,D);

%% Construção da função de transferência de malha aberta (q3->Rot Própria)
[Num,Den] = ss2tf(A,B,C,D,3);
Num=Num(3,:);
sys=tf(Num,Den);
N=tf(Num,1);
D=tf(Den,1);
s=tf([1 0],1);

%% Escolha dos polos
p1 = -1 + 0.3i;
p2 = conj(p1);
p3 = -2 + 0.3i;
p4 = conj(p3);
p5 = -1.5 + 0.3i;
p6 = conj(p5);
p7 = -0.0;

%% MMQ

Num = flip(Num);
Den = flip(Den);

a = [Num(1) 0 0;...
    Num(2) Num(1) 0;...
    Num(3) Num(2) Num(1);...
    Num(4) Num(3) Num(2);...
    Num(5) Num(4) Num(3);...
    0 Num(5) Num(4);...
    0 0 Num(5)];


b = [(p1*p2*p3*p4*p5*p6*p7)*Den(7);...
    (p1*p2*p3*p4*p5*p6 + p2*p3*p4*p5*p6*p7)*(Den(7)-Den(1));...
    (p1*p2*p3*p4*p5 + p2*p3*p4*p5*p6 + p3*p4*p5*p6*p7)*(Den(7)-Den(2));...
    (p1*p2*p3*p4 + p2*p3*p4*p5 + p3*p4*p5*p6 + p4*p5*p6*p7)*(Den(7)-Den(3));...
    (p1*p2*p3 + p2*p3*p4 + p3*p4*p5 + p4*p5*p6 + p5*p6*p7)*(Den(7)-Den(4));...
    (p1*p2 + p2*p3 + p3*p4 + p4*p5 + p5*p6 + p6*p7)*(Den(7)-Den(5));...
    (p1 + p2 + p3 + p4 + p5 + p6 + p7)*(Den(7)-Den(6))];

Ks = lsqr(a,b);

ki_norm = norm(Ks(1));
kp_norm = norm(Ks(2));
kd_norm = norm(Ks(3));

ki_real = abs(real(Ks(1)));
kp_real = abs(real(Ks(2)));
kd_real = abs(real(Ks(3)));

Gc_norm = pid(kp_norm,ki_norm,kd_norm); 
u_norm = series(Gc_norm,sys); 
sys_norm = feedback(u_norm,1);

y_norm = step(sys_norm,t);

Gc_real = pid(kp_real,ki_real,kd_real); 
u_real = series(Gc_real,sys); 
sys_real = feedback(u_real,1);
y_real = step(sys_real,t);

figure(1)
pzmap(sys_real)

figure(2)
pzmap(sys_norm)

figure(3)
plot(t,y_norm)
hold on
plot(t,y_real)
legend("Norma","Real")




