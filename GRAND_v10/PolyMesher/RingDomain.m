function [x] = QuarterRingDomain(Demand,Arg)
  BdBox = [0 2 0 2];
  switch(Demand)
    case('Dist');  x = DistFnc(Arg,BdBox);
    case('BC');    x = BndryCnds(Arg{:},BdBox);
    case('BdBox'); x = BdBox;
    case('PFix');  x = FixedPoints(BdBox);
  end
%----------------------------------------------- COMPUTE DISTANCE FUNCTIONS
function Dist = DistFnc(P,BdBox)
  d1 = dRectangle(P,0,2,0,2);
  d2 = dCircle(P,0,0,2);
  d3 = dCircle(P,0,0,1);
  Dist = dDiff(dIntersect(d1,d2),d3);
%---------------------------------------------- SPECIFY BOUNDARY CONDITIONS
function [x] = BndryCnds(Node,Element,BdBox)
  Right = find(Node(:,2)<1e-3);
  Left  = find(Node(:,1)<1e-3);
  Supp = [Left  zeros(length(Left),1) nan(length(Left),1);
          Right nan(length(Right),1)  zeros(length(Right),1)];
  Tip = sqrt((Node(:,1)-2.0).^2+Node(:,2).^2);
  [~,Tip] = sort(Tip);
  Load = [Tip(1) -0.5 0];
  x = {Supp,Load};
%----------------------------------------------------- SPECIFY FIXED POINTS
function [PFix] = FixedPoints(BdBox)
  PFix = [];
%-------------------------------------------------------------------------%