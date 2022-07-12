%% Comparação entre controladores PID

clc
clear
close all

%% Parâmetros do sistema
addpath('Matrizes\')

A = importdata('matrix_A1lin.txt');
B = -importdata('matrix_B1lin.txt');
C = importdata('matrix_C1.txt');
D = importdata('matrix_D1.txt');

sample_rate = 100;
t = 0:1/sample_rate:10;
n = length(t);

%% Construção da função de transferência de malha aberta (q3->Rot Própria)

[Num,Den] = ss2tf(A,B,C,D,3);
Num=Num(3,:);

sys=tf(Num,Den);
N=tf(Num,1);
D=tf(Den,1);
s=tf([1 0],1);

%% Método ZN sem compensador

% Determinação do ganho crítico
kcrit = 2.5; %Utilizar o mais adequado a partir do lugar das raizes anterior
Gkcrit=pid(kcrit,0,0); 
a=series(Gkcrit,sys); 
syskcrit=feedback(a,1);

% Determinação do período de oscilação harmônica
ycrit=step(syskcrit,t);

[~,peaklocs] = findpeaks(ycrit);
Pcrit = t(round(mean(diff(peaklocs))));

% Determinação do controlador
Ti=Pcrit/2;
Td=.125*Pcrit;

kp=.6*kcrit;
ki=kp/Ti;
kd=Td*kp;

GcZN=pid(kp,ki,kd); 
a=series(GcZN,sys); 
sysZN=feedback(a,1);

y_ZN=step(sysZN,t);

%% Método de alocação de polos

% Escolha dos polos
p1 = -1 + 0.3i;
p2 = conj(p1);
p3 = 0;
p4 = 0;
p5 = 0;
p6 = 0;
p7 = 0;

Num1 = flip(Num);
Den1 = flip(Den);

% Cálculo dos ganhos de forma analítica
ki_ana = (1/Num1(5))*(-p1*p2*p3 - p1*p2*p4 - p1*p3*p4 - p2*p3*p4 - p1*p2*p5 -... 
  p1*p3*p5 - p2*p3*p5 - p1*p4*p5 - p2*p4*p5 - p3*p4*p5 - p1*p2*p6 - ...
  p1*p3*p6 - p2*p3*p6 - p1*p4*p6 - p2*p4*p6 - p3*p4*p6 - p1*p5*p6 - ...
  p2*p5*p6 - p3*p5*p6 - p4*p5*p6 - p1*p2*p7 - p1*p3*p7 - p2*p3*p7 - ...
  p1*p4*p7 - p2*p4*p7 - p3*p4*p7 - p1*p5*p7 - p2*p5*p7 - p3*p5*p7 - ...
  p4*p5*p7 - p1*p6*p7 - p2*p6*p7 - p3*p6*p7 - p4*p6*p7 - p5*p6*p7);

kp_ana = (1/Num1(5))*(p1*p2 + p1*p3 + p2*p3 + p1*p4 + p2*p4 + p3*p4 + p1*p5 + p2*p5 +... 
   p3*p5 + p4*p5 + p1*p6 + p2*p6 + p3*p6 + p4*p6 + p5*p6 + p1*p7 + ...
   p2*p7 + p3*p7 + p4*p7 + p5*p7 + p6*p7);

kd_ana = (-p1 - p2 - p3 - p4 - p5 - p6 - p7)/Num1(5);

Gc_ana = pid(kp_ana,ki_ana,kd_ana); 
u_ana = series(Gc_ana,sys); 
sys_ana = feedback(u_ana,1);
y_aloc = step(sys_ana,t);

%% Método ITAE

% Polinômio ITAE

wn = 1.2; %valor arbitrado de omega_n

tab = [1 1.783*wn 2.172*wn^2 wn^3]; %tabela de coeficientes

a = Num(3);
kd = tab(2)/a;
kp = tab(3)/a;
ki = tab(4)/a;

itae_ref = tf(wn^3, tab);

% Sintonia sem pré-compensador
Gkd = pid(kp,ki,kd); 
a_t = series(Gkd,sys); 
sys_itae = feedback(a_t,1);

y_scomp_itae = step(sys_itae,t);
y_itae = step(itae_ref,t);

% Sintonia com pré-compensador

[num, den] = tfdata(sys_itae);

num_comp = num{1}(4:8);
den_comp = den{1}(1:8);

FT_comp = tf(num_comp, den_comp);

y_comp_itae = step(FT_comp,t);

%% Método lugar das raízes

% Com compensador
close all
[Gc,Kc]=compensador2P(-0.5+1i,Den);
sysKc=series(Gc,sys);
Numcomp=tf(Gc.Numerator{1},1);
Dencomp=tf(Gc.Denominator{1},1);

% Sintonia proporcional
kpKc=0.04; %Utilizar o mais adequado a partir do lugar das raizes anterior
GkpKc=pid(kpKc,0,0); 
a=series(GkpKc,sysKc); 
syskpmfKc=feedback(a,1);


% Sintonia integrativa
syskimaKc=(Numcomp*N/(s*(Dencomp*D+(kpKc*Numcomp*N))));

% Sintonia integrativa (continuação)
kiKc=0.025; %Utilizar o mais adequado a partir do lugar das raizes anterior
GkiKc=pid(kpKc,kiKc,0); 
a=series(GkiKc,sysKc); 
syskimfKc=feedback(a,1);

% Sintonia derivativa
syskdmaKc=((Numcomp*N*(s^2))/(s*Dencomp*D+(kpKc*s*Numcomp*N)+(kiKc*Numcomp*N)));

% Sintonia derivativa (continuação)
kdKc=0.02; %Utilizar o mais adequado a partir do lugar das raizes anterior
GkdKc=pid(kpKc,kiKc,kdKc); 
a=series(GkdKc,sysKc); 
syskdmfKc=feedback(a,1);

[y_comp_rl]=step(syskdmfKc,t); 


%% Gr�ficos finais
%Cores RGB (Vermelho Ferrari, Azul Marinho, Ouro met�lico, Verde escuro, 
%Violeta, Laranja)
col=[[207 14 14];[18 10 143];[212 175 55]; [50 150 50]; [102 0 161];...
    [242 79 0]]./255;

figure(1)
ZN = plot(t,y_ZN,'LineWidth',1.2);
ZN.Color=col(1,:);
hold on
aloc=plot(t,y_aloc,'LineWidth',1.2);
aloc.Color=col(2,:);
itae=plot(t,y_comp_itae,'LineWidth',1.2);
itae.Color=col(3,:);
rl=plot(t,y_comp_rl,'LineWidth',1.2);
rl.Color=col(4,:);
grid on
title("Posi��o angular q_3 em fun��o do tempo")
xlabel("Tempo [s]")
ylabel("Posi��o angular [rad]")
legend('ZN sem Compensador','Aloca��o de Polos sem Compensador',...
    'ITAE com Compensador','Lugar das Ra�zes com Compensador','Location','southeast')
hold off

figure(2)
ZNb = bodeplot(sysZN,'-r');
hold on
alocb=bodeplot(sys_ana,'-y');
itaeb=bodeplot(FT_comp,'-b');
rlb=bodeplot(syskdmfKc,'-g');
grid on
legend('ZN sem Compensador','Aloca��o de Polos sem Compensador',...
    'ITAE com Compensador','Lugar das Ra�zes com Compensador','Location','best')
hold off