function [x] = CantileverDomain(Demand,Arg)
  BdBox = [0 3 0 1];
  switch(Demand)
    case('Dist');  x = DistFnc(Arg,BdBox);
    case('BC');    x = BndryCnds(Arg{:},BdBox);
    case('BdBox'); x = BdBox;
    case('PFix');  x = FixedPoints(BdBox);
  end
%----------------------------------------------- COMPUTE DISTANCE FUNCTIONS
function Dist = DistFnc(P,BdBox)
  Dist = dRectangle(P,BdBox(1),BdBox(2),BdBox(3),BdBox(4));
%---------------------------------------------- SPECIFY BOUNDARY CONDITIONS
function [x] = BndryCnds(Node,Element,BdBox)
  LeftEdge = find(abs(Node(:,1)-BdBox(1))<1e-3);
  Supp = zeros(length(LeftEdge),3);
  Supp(:,1)=LeftEdge;
  MidTip = sqrt((Node(:,1)-BdBox(2)).^2+(Node(:,2)-sum(BdBox(3:4))/2).^2);
  [~,MidTip] = sort(MidTip);
  Load = [MidTip(1),0,-1];
  x = {Supp,Load};
%----------------------------------------------------- SPECIFY FIXED POINTS
function [PFix] = FixedPoints(BdBox)
  PFix = [BdBox(2) sum(BdBox(3:4))/2];
%-------------------------------------------------------------------------%