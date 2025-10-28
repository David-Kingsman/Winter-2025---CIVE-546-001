function [x] = HalfcircleDomain(Demand,Arg)
  R = 1;
  BdBox = [-R R 0 R];
  switch(Demand)
    case('Dist');  x = DistFnc(Arg,BdBox);
    case('BC');    x = BndryCnds(Arg{:},BdBox);
    case('BdBox'); x = BdBox;
    case('PFix');  x = FixedPoints(BdBox);
  end
%----------------------------------------------- COMPUTE DISTANCE FUNCTIONS
function Dist = DistFnc(P,BdBox)
  d1 = dRectangle(P,BdBox(1),BdBox(2),BdBox(3),BdBox(4));
  d2 = dCircle(P,0,0,BdBox(4));
  Dist = dIntersect(d1,d2);
%---------------------------------------------- SPECIFY BOUNDARY CONDITIONS
function [x] = BndryCnds(Node,Element,BdBox)
  CenterCircle = sqrt(Node(:,1).^2+Node(:,2).^2);
  [~,CenterCircle] = sort(CenterCircle);
  LeftCorner = sqrt((Node(:,1)-BdBox(1)).^2+Node(:,2).^2);
  [~,LeftCorner] = sort(LeftCorner);
  RightCorner = sqrt((Node(:,1)-BdBox(2)).^2+Node(:,2).^2);
  [~,RightCorner] = sort(RightCorner);
  Supp = [LeftCorner(1)  0 0;
          RightCorner(1) 0 0];
  Load = [CenterCircle(1) 0 -1];
  x = {Supp,Load};
%----------------------------------------------------- SPECIFY FIXED POINTS
function [PFix] = FixedPoints(BdBox)
  PFix = [0 0];
%-------------------------------------------------------------------------%