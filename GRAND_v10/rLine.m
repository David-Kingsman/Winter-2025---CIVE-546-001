function flag=rLine(A,B,NODE,BARS)
% Line segment between points A and B
P = NODE(BARS(:,1),:); D = NODE(BARS(:,2),:) - P; V = B - A;
C = D(:,1)*V(2) - V(1)*D(:,2);                      % cross(d,v)
Ct = (A(1)-P(:,1)).*D(:,2) - (A(2)-P(:,2)).*D(:,1); % cross(a-p,d)
Cu = (A(1)-P(:,1))*V(2) - (A(2)-P(:,2))*V(1);       % cross(a-p,v)
Ct = Ct./C; Cu = Cu./C;
% If intersection is between A-B and P-Q
flag = (Ct>0).*(Ct<1).*(Cu>0).*(Cu<1);