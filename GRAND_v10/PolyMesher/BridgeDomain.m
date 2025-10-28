function [x] = BridgeDomain(Demand,Arg)
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
  LeftBottom = sqrt((Node(:,1)-BdBox(1)).^2+(Node(:,2)-BdBox(3)).^2);
  [~,LeftBottom] = sort(LeftBottom);
  RightBottom = sqrt((Node(:,1)-BdBox(2)).^2+(Node(:,2)-BdBox(3)).^2);
  [~,RightBottom] = sort(RightBottom);
  Supp = [LeftBottom(1)  0 0;
          RightBottom(1) 0 0];
  MidSpan = sqrt((Node(:,1)-sum(BdBox(1:2))/2).^2+(Node(:,2)-BdBox(3)).^2);
  [~,MidSpan] = sort(MidSpan);
  Load = [MidSpan(1),0,-1];
  x = {Supp,Load};
%----------------------------------------------------- SPECIFY FIXED POINTS
function [PFix] = FixedPoints(BdBox)
  PFix = [sum(BdBox(1:2))/2 BdBox(3)];
%-------------------------------------------------------------------------%