function [x] = FlowerDomain(Demand,Arg)
  R = 1;
  BdBox = [-R R -R R];
  switch(Demand)
    case('Dist');  x = DistFnc(Arg,BdBox);
    case('BC');    x = BndryCnds(Arg{:},BdBox);
    case('BdBox'); x = BdBox;
    case('PFix');  x = FixedPoints(BdBox);
  end
%----------------------------------------------- COMPUTE DISTANCE FUNCTIONS
function Dist = DistFnc(P,BdBox)
  d1 = dCircle(P,0,0,BdBox(4));
  d2 = dCircle(P,0,0,0.25*BdBox(4));
  Dist = dDiff(d1,d2);
%---------------------------------------------- SPECIFY BOUNDARY CONDITIONS
function [x] = BndryCnds(Node,Element,BdBox)
  Nload = 5;
  dist = sqrt(Node(:,1).^2+Node(:,2).^2);
  Inner = find(dist-0.25*BdBox(4)<1e-2*BdBox(4));
  Supp = zeros(length(Inner),3);
  Supp(:,1) = Inner;
  theta = linspace(0,2*pi,Nload+1);
  theta(end)=[]; Petal=zeros(Nload,1);
  P = BdBox(4) * [cos(theta)' sin(theta)'];
  for i=1:Nload
      aux = sqrt((Node(:,1)-P(i,1)).^2+(Node(:,2)-P(i,2)).^2);
      [~,aux] = sort(aux); Petal(i)=aux(1);
  end
  Load = [Petal -sin(theta)' cos(theta)'];
  x = {Supp,Load};
%----------------------------------------------------- SPECIFY FIXED POINTS
function [PFix] = FixedPoints(BdBox)
  Nload = 5;
  theta = linspace(0,2*pi,Nload+1);
  theta(end)=[]; Petal=zeros(Nload,1);
  PFix = BdBox(4) * [cos(theta)' sin(theta)'];
%-------------------------------------------------------------------------%