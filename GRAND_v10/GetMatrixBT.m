function [BT,L]=GetMatrixBT(NODE,BARS,BC,Nn,Nb)
% Generate equilibrium matrix BT and get member lengths L
D = [NODE(BARS(:,2),1)-NODE(BARS(:,1),1) NODE(BARS(:,2),2)-NODE(BARS(:,1),2)];
L = sqrt(D(:,1).^2+D(:,2).^2);
D = [D(:,1)./L D(:,2)./L];
BT = sparse([2*BARS(:,1)-1 2*BARS(:,1) 2*BARS(:,2)-1 2*BARS(:,2)],...
             repmat((1:Nb)',1,4),[-D D],2*Nn,Nb);
BT(BC,:) = [];