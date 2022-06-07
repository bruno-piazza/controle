function dx = x_dot(t,x,params,mag,ti,tf)

    kt = params(1);
    kb = params(2);
    Ra = params(3);
    b = params(4);
    Irr = params(5);
    I1 = params(6);
    I2 = params(7);
    I3 = params(8);

    phi = x(1);
    psi = x(2);
    theta = x(3);
    phip = x(4);
    psip = x(5);
    thetap = x(6);
    hx = x(7);
    hy = x(8);
    hz = x(9);

    if t>=ti(1) && t<=tf(1)
        u = mag;
        ea1 = u(1);
    else
        ea1 = 0;
    end
    if t>=ti(2) && t<=tf(2)
        u = mag;
        ea2 = u(2);
    else
        ea2 = 0;
    end
    if t>=ti(3) && t<=tf(3)
        u = mag;
        ea3 = u(3);
    else
        ea3 = 0;
    end

    a = zeros(6,6);
    g = zeros(6,1);

    a(1,:) = [0,I3*sin(phi)*sin(theta),I3*cos(phi),1,0,0];
    g(1) = I3*(-(phip*thetap*sin(phi))+ psip*thetap*cos(theta)*sin(phi) + phip*psip*cos(phi)*sin(theta))...
            -(I2 - I1)*(phip + psip*cos(theta))*(-(thetap*sin(phi)) + psip*cos(phi)*sin(theta));

    a(2,:) = [0,I2*cos(phi)*sin(theta),-I2*sin(phi),0,1,0];
    g(2) = I2*(-(phip*thetap*cos(phi)) + psip*thetap*cos(phi)*cos(theta) - phip*psip*sin(phi)*sin(theta))-...
        (-I3 + I1)*(phip + psip*cos(theta))*(thetap*cos(phi) + psip*sin(phi)*sin(theta));

    a(3,:) = [I1,I1*cos(theta),0,0,0,1];
    g(3) = I1*(-(psip*thetap*sin(theta)))...
        -(I3 - I2)*(-(thetap*sin(phi)) + psip*cos(phi)*sin(theta))*(thetap*cos(phi) + psip*sin(phi)*sin(theta));

    a(4,:) = [0,0,0,1,0,0];
    g(4) = (kb*kt+b*Ra)/(Irr*Ra)*hx - ea1*kt/Ra;

    a(5,:) = [0,0,0,0,1,0];
    g(5) = (kb*kt+b*Ra)/(Irr*Ra)*hy - ea2*kt/Ra;

    a(6,:) = [0,0,0,0,0,1];
    g(6) = (kb*kt+b*Ra)/(Irr*Ra)*hz - ea3*kt/Ra;

    aux = -a \ g;

    dx(1) = phip;
    dx(2) = psip;
    dx(3) = thetap;
    dx(4) = aux(1);
    dx(5) = aux(2);
    dx(6) = aux(3);
    dx(7) = aux(4);
    dx(8) = aux(5);
    dx(9) = aux(6);

    dx = dx';

end
