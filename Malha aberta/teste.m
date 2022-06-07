%% Dados do sistema
% Matrizes do espaço de estados
addpath('Matrizes\')

A = importdata('matrix_A1lin.txt');
B = importdata('matrix_B1lin.txt');
C=eye(6);
D=[zeros(6,3)];

