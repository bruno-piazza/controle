clc
close all

% writematrix([out.ref1.time out.ref1.Data],"q3_ref1.txt");
% writematrix([out.y1.time out.y1.Data],"q3_y1.txt");

q3_ref1 = importdata("q3_ref1.txt");
q3_sim1 = importdata("q3_y1.txt");

figure(1)
plot(q3_sim1(:,1),q3_sim1(:,2),LineWidth=1.30)
hold on
plot(q3_ref1(:,1),q3_ref1(:,2),LineWidth=1,LineStyle='- -')
grid on
title("Seguidor de referência")
xlabel("Tempo [s]")
ylabel("Posição angular q_3 [rad]")
legend('Resposta do sistema','Referência','Location','southeast')
hold off

baseFileName = sprintf('Image_%s.png', "q3_1");
fullFileName = fullfile("Imagens\", baseFileName);
saveas(1, fullFileName);


% writematrix([out.ref2.time out.ref2.Data],"q3_ref2.txt");
% writematrix([out.y2.time out.y2.Data],"q3_y2.txt");
% writematrix([out.dist2.time out.dist2.Data],"q3_dist2.txt");

q3_ref2 = importdata("q3_ref2.txt");
q3_sim2 = importdata("q3_y2.txt");
q3_dist2 = importdata("q3_dist2.txt");

figure(2)
plot(q3_sim2(:,1),q3_sim2(:,2),LineWidth=1.30)
hold on
plot(q3_ref2(:,1),q3_ref2(:,2),LineWidth=1,LineStyle='- -')
plot(q3_dist2(:,1),q3_dist2(:,2),LineWidth=1.3,LineStyle=':',Color='black')

grid on
title("Rejeitador de distúrbio")
xlabel("Tempo [s]")
ylabel("Posição angular q_3 [rad]")
legend('Resposta do sistema','Referência','Distúrbio','Location','southeast')
hold off

baseFileName = sprintf('Image_%s.png', "q3_2");
fullFileName = fullfile("Imagens\", baseFileName);
saveas(2, fullFileName);

