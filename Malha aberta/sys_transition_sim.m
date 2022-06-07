function [y_lin,x,t] = sys_transition_sim(A,B,C,D,x0_lin,x0_nlin,x_eq,u,t)

    [y_lin,t,x_lin] = linear_sim(A,B,C,D,x0_lin,x_eq,u,t);
    [Phi_dt,Gamma_dt,x] = transition_matrix(A,B,t,x0_nlin',u');
    
    figure(1)
    plot(t,y_lin(:,1),'linewidth',1.5)
    hold on
    plot(t,x(1,:),'g--','linewidth',1.5)
    grid on
    xlabel('Tempo [s]','fontsize',12.5)
    ylabel('\phi [rad]','fontsize',12.5)
    title('Rotação própria em função do tempo','fontsize',12.5)
    legend({'linear','linear (transição)'},'Location','southwest')
    
    figure(2)
    plot(t,y_lin(:,2),'linewidth',1.5)
    hold on
    plot(t,x(2,:),'g--','linewidth',1.5)
    grid on
    xlabel('Tempo [s]','fontsize',12.5)
    ylabel('\psi [rad]','fontsize',12.5)
    title('Precessão em função do tempo','fontsize',12.5)
    legend({'linear','linear (transição)'},'Location','northwest')
    
    figure(3)
    plot(t,y_lin(:,3),'linewidth',1.5)
    hold on
    plot(t,x(3,:),'g--','linewidth',1.5)
    grid on
    xlabel('Tempo [s]','fontsize',12.5)
    ylabel('\theta [rad]','fontsize',12.5)
    title('Nutação em função do tempo','fontsize',12.5)
    legend({'linear','lina'},'Location','southwest')

    figure(4)
    plot(t,y_lin(:,4),'linewidth',1.5)
    hold on
    plot(t,x(4,:),'g--','linewidth',1.5)
    grid on
    xlabel('Tempo [s]','fontsize',12.5)
    ylabel('d\phi [rad]','fontsize',12.5)
    title('Taxa de rotação própria em função do tempo','fontsize',12.5)
    legend({'linear','linear (transição)'},'Location','northeast')
    
    figure(5)
    plot(t,y_lin(:,5),'linewidth',1.5)
    hold on
    plot(t,x(5,:),'g--','linewidth',1.5)
    grid on
    xlabel('Tempo [s]','fontsize',12.5)
    ylabel('d\psi [rad]','fontsize',12.5)
    title('Taxa de precessão em função do tempo','fontsize',12.5)
    legend({'linear','linear (transição)'},'Location','southeast')
    
    figure(6)
    plot(t,y_lin(:,6),'linewidth',1.5)
    hold on
    plot(t,x(6,:),'g--','linewidth',1.5)
    grid on
    xlabel('Tempo [s]','fontsize',12.5)
    ylabel('d\theta [rad]','fontsize',12.5)
    title('Taxa de nutação em função do tempo','fontsize',12.5)
    legend({'linear','linear (transição)'},'Location','southwest')
end