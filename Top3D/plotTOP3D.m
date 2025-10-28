% DISPLAY 3D TOPOLOGY (ISO-VIEW)
function plotTOP3D(x,cutoff)

if nargin==1, cutoff = 0.5; end

[nely,nelx,nelz] = size(x);
Px = (0:nelx+1)-0.5;
Py = (0:nely+1)-0.5;
Pz = (0:nelz+1)-0.5;
padded_x = zeros(nely+2,nelx+2,nelz+2);
padded_x(2:end-1,2:end-1,2:end-1) = x;

clf, hold on, axis equal, axis off, rotate3d on, view(30,20)
hsurf = patch(isosurface(Px,Py,Pz,padded_x,cutoff),'FaceColor','r',...
              'EdgeColor','none','FaceLighting','gouraud','AmbientStrength',0.5);
%plot3(nelx*[0 1 1 0 0 0 1 1 0 0 1 1 1 1 0 0],nely*[0 0 1 1 0 0 0 1 1 0 0 0 1 1 1 1],...
%      nelz*[0 0 0 0 0 1 1 1 1 1 1 0 0 1 1 0],'k','LineWidth',1.75)
axis([0 nelx 0 nely 0 nelz]+1e-1*[-1 1 -1 1 -1 1])
camlight
end