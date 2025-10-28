function flag=RestrictWrench(NODE,BARS)
tol = 1e-3;

flag = rCircle([0 0],0.175-tol,NODE,BARS) | ...
       rCircle([2 0],0.3-tol,NODE,BARS);