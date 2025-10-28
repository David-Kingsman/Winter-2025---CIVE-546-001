function [F]=GetVectorF(LOAD,BC,Nn)
% Return nodal force vector
Nl = sum(sum(~isnan(LOAD(:,2:3))));
F = sparse([],[],[],2*Nn,1,Nl);
for i=1:size(LOAD,1)
    n = LOAD(i,1);
    if ~isnan(LOAD(i,2)), F(2*n-1) = LOAD(i,2); end
    if ~isnan(LOAD(i,3)), F(2*n) = LOAD(i,3);   end
end
F(BC) = [];