function u = u_selector(mag,ti,tf,t)
% if nargin<4
%     tf=ti;
% end

u1 = zeros(length(t),1);
u2 = zeros(length(t),1);
u3 = zeros(length(t),1);

u = [u1 u2 u3];

for i=1:3
    index_i=find(t==ti(i));
    index_f=find(t==tf(i));
    signal=ones(index_f-index_i+1,1)*mag(i);
    u(index_i:index_f,i)=u(index_i:index_f,i)+signal;
end
end