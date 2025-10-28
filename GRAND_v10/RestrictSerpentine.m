function flag=RestrictSerpentine(NODE,BARS)
tol = 1e-3;

flag = rCircle([0 -2.645751311064591],4-tol,NODE,BARS) | ... %  -sqrt(7)
       rCircle([9  5.291502622129181],4-tol,NODE,BARS);      % 2*sqrt(7)