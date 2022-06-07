A = importdata('matrix_A1lin.txt');

C1 = importdata('matrix_C1.txt');

C = [eye(3,3) zeros(3,3);zeros(3,6)]

Ob = obsv(A,C);
rank(Ob)

