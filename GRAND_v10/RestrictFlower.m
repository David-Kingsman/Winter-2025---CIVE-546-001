function flag=RestrictFlower(NODE,BARS)
tol = 1e-3;

R = 1;
flag = rCircle([0 0],0.25*R-tol,NODE,BARS);