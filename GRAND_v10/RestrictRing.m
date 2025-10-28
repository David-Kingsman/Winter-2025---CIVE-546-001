function flag=RestrictRing(NODE,BARS)
tol = 1e-3;

flag = rCircle([0 0],1-tol,NODE,BARS);