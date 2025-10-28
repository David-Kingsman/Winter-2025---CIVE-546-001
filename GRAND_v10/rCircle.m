function flag=rCircle(C,r,NODE,BARS)
% Circle with center point C and radius R
Nb = size(BARS,1);
U = NODE(BARS(:,1),:) - repmat(C,Nb,1);
V = NODE(BARS(:,2),:) - repmat(C,Nb,1);
D = V - U;
L = sqrt(D(:,1).^2 + D(:,2).^2);
D = [ D(:,1)./L D(:,2)./L ];
flag = any( [ ( sum(D.*V,2)>=0 ) .* ( sum(D.*U,2)<=0 ) .*...
              ( abs(D(:,1).*U(:,2)-D(:,2).*U(:,1))<r ) , ...
              ( U(:,1).^2+U(:,2).^2<=r^2 ) , ...
              ( V(:,1).^2+V(:,2).^2<=r^2 ) ] , 2);