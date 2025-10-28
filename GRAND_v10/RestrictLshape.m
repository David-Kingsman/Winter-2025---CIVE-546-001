function flag=RestrictLshape(NODE,BARS)
tol = 1e-3;

flag = rRectangle([1+tol -1-tol],[2 0],NODE,BARS);