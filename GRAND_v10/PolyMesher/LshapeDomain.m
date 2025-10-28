function [x] = LshapeDomain(Demand,Arg)
  BdBox = [0 3 -2 0];
  switch(Demand)
    case('Dist');  x = DistFnc(Arg,BdBox);
    case('BC');    x = BndryCnds(Arg{:},BdBox);
    case('BdBox'); x = BdBox;
    case('PFix');  x = FixedPoints(BdBox);
  end
%----------------------------------------------- COMPUTE DISTANCE FUNCTIONS
function Dist = DistFnc(P,BdBox)
  d1 = dRectangle(P,0,3,-2,0);
  d2 = dRectangle(P,1,3,-1,0);
  Dist = dDiff(d1,d2);
%---------------------------------------------- SPECIFY BOUNDARY CONDITIONS
function [x] = BndryCnds(Node,Element,BdBox)
  RightCorner = sqrt((Node(:,1)-3.0).^2+(Node(:,2)-(-1.0)).^2);
  [~,RightCorner] = sort(RightCorner);
  Load = [RightCorner(1) 0 -1];
  Bottom = find( abs(Node(:,2))<1e-3 );
  Supp = zeros(length(Bottom),3);
  Supp(:,1) = Bottom;
  x = {Supp,Load};
%----------------------------------------------------- SPECIFY FIXED POINTS
function [PFix] = FixedPoints(BdBox)
  PFix = [];
%-------------------------------------------------------------------------%