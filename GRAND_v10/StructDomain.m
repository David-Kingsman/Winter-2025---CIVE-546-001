function [NODE,ELEM,SUPP,LOAD]=StructDomain(Nx,Ny,Lx,Ly,ProblemID)
% Generate structured-orthogonal domains
[X,Y] = meshgrid(linspace(0,Lx,Nx+1),linspace(0,Ly,Ny+1));
NODE = [reshape(X,numel(X),1) reshape(Y,numel(Y),1)];
k = 0; ELEM = cell(Nx*Ny,1);
for j=1:Ny, for i=1:Nx
        k = k+1;
        n1 = (i-1)*(Ny+1)+j; n2 = i*(Ny+1)+j;
        ELEM{k} = [n1 n2 n2+1 n1+1];
end, end

if (nargin==4 || isempty(ProblemID)), ProblemID = 1; end
switch ProblemID
    case {'Cantilever','cantilever',1}
        SUPP = [(1:Ny+1)' ones(Ny+1,2)];
        LOAD = [Nx*(Ny+1)+round((Ny+1)/2) 0 -1];
    case {'MBB','Mbb','mbb',2}
        SUPP = [Nx*(Ny+1)+1 NaN 1;
                (1:Ny+1)' ones(Ny+1,1) nan(Ny+1,1)];
        LOAD = [Ny+1 0 -0.5];
    case {'NewCSB'}
        SUPP = [1 1 0;
                (Ny+1)*round(Nx/4)+1 1 1
                (Ny+1)*round(3*Nx/4)+1 1 1
                (Ny+1)*Nx+1 1 0];
        LOAD = [[1:(Ny+1):Nx*(Ny+1)+1]' zeros(Nx+1,1) [0.5 -ones(Nx+1-2,1)' 0.5]'];
     case {'CSB'}
         SUPP = [1 0 1;
                (Ny+1)*round(Nx/4)+1 1 1
                (Ny+1)*round(3*Nx/4)+1 1 1
                (Ny+1)*Nx+1 0 1];
     LOAD = [[1:(Ny+1):Nx*(Ny+1)+1]' zeros(Nx+1,1) [0.5 -ones(Nx+1-2,1)' 0.5]'];
     case {'DB'}
        SUPP = [1 1 1;
                Nx*(Ny+1)+1 NaN 1];
        LOAD = [(Nx/3+1)*(Ny+1) 0 -1
                     (Nx*2/3+1)*(Ny+1) 0 -1];
    otherwise
        SUPP = []; LOAD = [];
        disp('-INFO- Structured domain generated with no loads/BC')
end