function [y_lin,t,x_lin] = linear_sim(A,B,C,D,x0,x_eq,u,t)

    sys = ss(A,B,C,D);
   
    phi_eq = x_eq(1);
    psi_eq = x_eq(2);
    theta_eq = x_eq(3);
    phip_eq = x_eq(4);
    psip_eq = x_eq(5);
    thetap_eq = x_eq(6);
    
    [y_lin,t,x_lin] = lsim(sys,u,t,x0);
    y_lin(:,1) = y_lin(:,1) + ones(size(y_lin(:,1)))*phi_eq;
    y_lin(:,2) = y_lin(:,2) + ones(size(y_lin(:,2)))*psi_eq;
    y_lin(:,3) = y_lin(:,3) + ones(size(y_lin(:,3)))*theta_eq;
    y_lin(:,4) = y_lin(:,4) + ones(size(y_lin(:,4)))*phip_eq;
    y_lin(:,5) = y_lin(:,5) + ones(size(y_lin(:,5)))*psip_eq;
    y_lin(:,6) = y_lin(:,6) + ones(size(y_lin(:,6)))*thetap_eq;
end