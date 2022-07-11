% Seguidor de referência variante

clc
clear
close all

addpath('Matrizes\')
addpath("Imagens\Controle Moderno\")

%Importa matrizes
A = importdata('matrix_A1lin.txt');
B2 = importdata('matrix_B1lin.txt');
B1 = -B2;
C = importdata('matrix_C1.txt');
D = importdata('matrix_D1.txt');

% Define a referência constante
x_r = [pi/3 pi/4 pi/5 0 0 0];
seq = 'ZXZ';
q_r = angle2quat(x_r(1),x_r(2),x_r(3),seq);
xq_r = [q_r(2:4),x_r(4:6)];

% Regulador por alocação de polos
p1 = -0.3+0.3i;
p2 = -0.4+0.3i;
p = [p1 conj(p1) p2 conj(p2) -0.5 -0.4];
K = place(A,B2,p);
F = A-B2*K;

% Cálculo da entrada em regime permanente
Gamma = [A,B2;C,D];
B_ls = [zeros(6,6);eye(3,6);zeros(3,6)];
N = linsolve(Gamma,B_ls);
Nx = N(1:6,:);
Nu = N(7:9,:);