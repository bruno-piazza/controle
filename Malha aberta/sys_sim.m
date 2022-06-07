function [y_lin,y_nonlin,t] = sys_sim(A,B,C,D,x0lin,x0nlin,x_eq,u,t,mag,ti,tf,rot_seq,q)

    [y_lin,t,x_lin] = linear_sim(A,B,C,D,x0lin,x_eq,u,t);
    %[y_nonlin,t,x_nonlin] = nonlinear_sim(x0nlin,t,mag,ti,tf);
    y_nonlin=0;
    %[y_lin(:,1),y_lin(:,2),y_lin(:,3)] = quat2eulang(q(1),y_lin(:,1),y_lin(:,2),y_lin(:,3),rot_seq);
    %[psi,theta,phi] = quat2eulang(y_nonlin(1),y_nonlin(2),y_nonlin(3),y_nonlin(4),rot_seq);

%     figure(1)
%     plot(t,y_lin(:,1),'linewidth',1.5)
%     hold on
%     %plot(t,y_nonlin(:,1),'--','linewidth',1.5)
%     grid on
%     xlabel('Tempo [s]','fontsize',12.5)
%     ylabel('\psi [rad]','fontsize',12.5)
%     title('Rotação própria em função do tempo','fontsize',12.5)
%     legend({'linear','não linear'},'Location','southwest')
    
    figure(1)
    plot(t,y_lin(:,1),'linewidth',1.2)
    hold on
    %plot(t,y_nonlin(:,1),'--','linewidth',1.5)
    grid on
    xlabel('Tempo [s]')
    ylabel('q_1 [rad]')
    title("Posição angular: pulso aplicado")
        
    figure(2)
    plot(t,y_lin(:,2),'linewidth',1.5)
    hold on
    %plot(t,y_nonlin(:,2),'--','linewidth',1.5)
    grid on
    xlabel('Tempo [s]','fontsize',12.5)
    ylabel('\theta [rad]','fontsize',12.5)
    title('Precessão em função do tempo','fontsize',12.5)
    legend({'linear','não linear'},'Location','northwest')
    
    figure(3)
    plot(t,y_lin(:,3),'linewidth',1.5)
    hold on
    %plot(t,y_nonlin(:,3),'--','linewidth',1.5)
    grid on
    xlabel('Tempo [s]','fontsize',12.5)
    ylabel('\phi [rad]','fontsize',12.5)
    title('Nutação em função do tempo','fontsize',12.5)
    legend({'linear','não linear'},'Location','southwest')

%     figure(4)
%     plot(t,y_lin(:,4),'linewidth',1.5)
%     hold on
%     %plot(t,y_nonlin(:,4),'--','linewidth',1.5)
%     grid on
%     xlabel('Tempo [s]','fontsize',12.5)
%     ylabel('d\phi [rad]','fontsize',12.5)
%     title('Taxa de rotação própria em função do tempo','fontsize',12.5)
%     legend({'linear','não linear'},'Location','northeast')
    
    figure(4)
    plot(t,y_lin(:,4),'linewidth',1.2)
    hold on
    %plot(t,y_nonlin(:,4),'--','linewidth',1.5)
    grid on
    xlabel('Tempo [s]')
    ylabel('\omega_1 [rad/s]')
    title("Velocidade angular: pulso aplicado")
    
    figure(5)
    plot(t,y_lin(:,5),'linewidth',1.5)
    hold on
    %plot(t,y_nonlin(:,5),'--','linewidth',1.5)
    grid on
    xlabel('Tempo [s]','fontsize',12.5)
    ylabel('d\psi [rad]','fontsize',12.5)
    title('Taxa de precessão em função do tempo','fontsize',12.5)
    legend({'linear','não linear'},'Location','southeast')
    
    figure(6)
    plot(t,y_lin(:,6),'linewidth',1.5)
    hold on
    %plot(t,y_nonlin(:,6),'--','linewidth',1.5)
    grid on
    xlabel('Tempo [s]','fontsize',12.5)
    ylabel('d\theta [rad]','fontsize',12.5)
    title('Taxa de nutação em função do tempo','fontsize',12.5)
    legend({'linear','não linear'},'Location','southwest')
end