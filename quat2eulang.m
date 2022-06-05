function y = quat2eulang(q0,q1,q2,q3,seq)
    L = length(q2);
    q = [ones(L,1)*q0,q1,q2,q3];
    y = quat2eul(q,seq);
end