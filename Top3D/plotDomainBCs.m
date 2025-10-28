function []=plotDomainBCs(nelx,nely,nelz,loaddof,fixeddof,loadval)
% Plots the domain and BCs

Color=0.65*[1 1 1];
Alpha=0.35;

NODE=[  0    0    0 ;
      nelx   0    0 ;
      nelx nely   0 ;
        0  nely   0 ;
        0    0  nelz;
      nelx   0  nelz;
      nelx nely nelz;
        0  nely nelz];
FACE=[1 2 3 4; 8 7 6 5; 2 1 5 6; 4 3 7 8; 3 2 6 7; 1 4 8 5];

figure('Color','w'), hold on, axis equal, view(30,20), rotate3d on, box
plot3([repmat([0 nelx nelx 0 0]',1,nelz+1) repmat(0:nelx,5,1) repmat([0 nelx nelx 0 0]',1,nely+1)],...
      [repmat([0 0 nely nely 0]',1,nelz+1) repmat([0 nely nely 0 0]',1,nelx+1) repmat(0:nely,5,1)],...
      [repmat(0:nelz,5,1) repmat([0 0 nelz nelz 0]',1,nelx+1) repmat([0 0 nelz nelz 0]',1,nely+1)],...
      'Color',0.5*Color)
patch('Faces',FACE,'Vertices',NODE,'FaceColor',Color,'FaceAlpha',Alpha);
axis([-1 nelx+1 -1 nely+1 -1 nelz+1])

[X,Y,Z]=meshgrid(0:nelx,0:nely,0:nelz);
%LOAD=unique(ceil(loaddof/3));
SUPP=unique(ceil(fixeddof/3));
%plot3(X(LOAD),Y(LOAD),Z(LOAD),'b^')
plot3(X(SUPP),Y(SUPP),Z(SUPP),'rx','MarkerSize',12)

LOAD=ceil(loaddof/3);
F=sparse(LOAD,1,abs(loadval),(nelx+1)*(nely+1)*(nelz+1),1);
ind=find(F); F=F/max(F);
for i=1:length(ind)
    plot3(X(ind(i)),Y(ind(i)),Z(ind(i)),'b^','MarkerSize',12*F(ind(i)))
end