% A 169 LINE 3D TOPOLOGY OPITMIZATION CODE BY LIU AND TOVAR (JUL 2013)
% --- MODIFIED BY TOMAS ZEGARD (JAN 2014)
nelx = 45;
nely = 12;
nelz = 15;
volfrac = 0.15;
penal = 1.0;                % Initial penalization (see lines 127-135 for continuation)
rmin = 2.5;                 % Filter radius
Q = 2;                      % Filter exponent

% USER-DEFINED LOOP PARAMETERS
maxloop = 150;              % Maximum number of iterations
tolx = 0.00;                % Termination criterion (disabled for continuation - default: 0.01)
displayflag = true;         % Display structure flag
plotcutoff = 0.50;          % Display density cutoff
storefileprefix = 'output'; % Filename prefix for storage
storeiters = false;         % Store data for each iteration
storefinal = true;          % Store final result

% USER-DEFINED MATERIAL PROPERTIES
E0 = 1;            % Young's modulus of solid material
Emin = 1e-9;       % Young's modulus of void-like material
nu = 0.3;          % Poisson's ratio
% USER-DEFINED LOAD DOFs
il = nelx; jl = 0:nely; kl = 0;                         % Coordinates
loadnid = kl*(nelx+1)*(nely+1)+il*(nely+1)+(nely+1-jl); % Node IDs
loaddof = 3*loadnid(:);                                 % DOFs
loadval = -ones(nely+1,1);
loadval([1 end]) = -0.5;
% USER-DEFINED SUPPORT FIXED DOFs
[jf,kf] = meshgrid(1:nely+1,1:nelz+1);                        % Coordinates
fixednid = (kf-1)*(nely+1)*(nelx+1)+jf;                       % Node IDs
fixeddof = [3*fixednid(:); 3*fixednid(:)-1; 3*fixednid(:)-2]; % DOFs
% PREPARE FINITE ELEMENT ANALYSIS
nele = nelx*nely*nelz;
ndof = 3*(nelx+1)*(nely+1)*(nelz+1);
F = sparse(loaddof,1,loadval,ndof,1);
U = zeros(ndof,1);
freedofs = setdiff(1:ndof,fixeddof);
KE = lk_H8(nu);
nodegrd = reshape(1:(nely+1)*(nelx+1),nely+1,nelx+1);
nodeids = reshape(nodegrd(1:end-1,1:end-1),nely*nelx,1);
nodeidz = 0:(nely+1)*(nelx+1):(nelz-1)*(nely+1)*(nelx+1);
nodeids = repmat(nodeids,size(nodeidz))+repmat(nodeidz,size(nodeids));
edofVec = 3*nodeids(:)+1;
edofMat = repmat(edofVec,1,24)+ ...
    repmat([0 1 2 3*nely + [3 4 5 0 1 2] -3 -2 -1 ...
    3*(nely+1)*(nelx+1)+[0 1 2 3*nely + [3 4 5 0 1 2] -3 -2 -1]],nele,1);
iK = kron(edofMat,ones(24,1))';
jK = kron(edofMat,ones(1,24))';
% HOUSEKEEPING
clear If Jf Kf Fl Il Jl fixednid1 fixednid2 fixednid3 nodegrd nodeidz nodeids
% PREPARE FILTER
step = ceil(rmin)-1;
iH = zeros(nele*(2*step+1)^3,1);
jH = zeros(size(iH)); vH = zeros(size(iH));
n = 0;
for el=1:nele
    [i,j,k] = ind2sub([nely,nelx,nelz],el);
    [ispan,jspan,kspan] = meshgrid(max(1,i-step):min(nely,i+step),max(1,j-step):min(nelx,j+step),max(1,k-step):min(nelz,k+step));
    dist = max(0,rmin-sqrt((ispan-i).^2 + (jspan-j).^2 + (kspan-k).^2)).^Q;
    vH(n+(1:numel(dist))) = dist(:);
    iH(n+(1:numel(dist))) = el;
    jH(n+(1:numel(dist))) = sub2ind([nely nelx nelz],ispan,jspan,kspan);
    n = n + numel(dist);
end
iH(n+1:end)=[]; jH(n+1:end)=[]; vH(n+1:end)=[];
H = sparse(iH,jH,vH);
Hs = sum(H,2);
% HOUSEKEEPING
clear iH jH vH ispan jspan kspan dist

% DEFINE PASSIVE-SOLID ZONES
[Ip,Jp,Kp] = meshgrid(1:nelx,1:nely,nelz-1:nelz);       % Coordinates
pass_solid = false(nelx*nely*nelz,1);
% pass_solid( ) = true;
df_solid = sum(sum(sum(pass_solid)))/(nelx*nely*nelz);
volfrac = volfrac + df_solid; % Adjust the volume fraction to consider passive
% HOUSEKEEPING
clear Ip Jp Kp
% APPLY PASSIVE ZONES
x = repmat(volfrac,[nely,nelx,nelz]);
x(pass_solid) = 1;

% PLOT DOMAIN AND BCS
plotDomainBCs(nelx,nely,nelz,loaddof,fixeddof,loadval) % Plot the domain and BCs

% INITIALIZE ITERATION
xPhys = x; 
loop = 0; 
change = 1;
if displayflag, figure('Color','w'), end
fprintf('=== ITERATIONS BEGIN... ===\n')
% START ITERATION
while change > tolx && loop < maxloop
    if storeiters
        filename = sprintf('%s%03.0f.mat',storefileprefix,loop);
        save(filename,'xPhys','change','c','penal');
    end
    loop = loop+1;
    % FE-ANALYSIS
    sK = KE(:)*(Emin+xPhys(:)'.^penal*(E0-Emin));
    K = sparse(iK(:),jK(:),sK(:)); K = (K+K')/2;
    
    % OPTION 1: Direct solver (original)
    U(freedofs,:) = K(freedofs,freedofs)\F(freedofs,:);
    % OPTION 2: Jacobi PCG (suggested by Liu & Tovar for large problems)
    % M = diag(diag(K(freedofs,freedofs)));
    % U(freedofs,:) = pcg(K(freedofs,freedofs),F(freedofs,:),1e-8,1000,M);
    % OPTION 3: Incomplete Cholesky PCG [fast but might fail]
    % L = ichol(K(freedofs,freedofs));
    % U(freedofs,:) = pcg(K(freedofs,freedofs),F(freedofs,:),1e-8,2000,L,L');

    % OBJECTIVE FUNCTION AND SENSITIVITY ANALYSIS
    ce = reshape(sum((U(edofMat)*KE).*U(edofMat),2),[nely,nelx,nelz]);
    c = sum(sum(sum((Emin+xPhys.^penal*(E0-Emin)).*ce)));
    dc = -penal*(E0-Emin)*xPhys.^(penal-1).*ce;
    dv = ones(nely,nelx,nelz);
    % FILTERING AND MODIFICATION OF SENSITIVITIES
    dc(:) = H*(dc(:)./Hs);
    dv(:) = H*(dv(:)./Hs);
    % OPTIMALITY CRITERIA UPDATE
    if loop<round(maxloop/6),         l1 = 0.0;      l2 = 1e9;      move = 0.15;
    elseif loop<round(maxloop/3),     l1 = 0.0;      l2 = 1e9;      move = 0.15; penal = 1.5;
    elseif loop<round(maxloop/2),     l1 = 0.0;      l2 = 1e9;      move = 0.15; penal = 2.0;
    elseif loop<round(maxloop*2/3),   l1 = lmid/1.1; l2 = lmid*1.1; move = 0.15; penal = 2.5;
    elseif loop<round(maxloop*3/4),   l1 = lmid/1.1; l2 = lmid*1.1; move = 0.12; penal = 3.0;
    elseif loop<round(maxloop*5/6),   l1 = lmid/1.1; l2 = lmid*1.1; move = 0.10; penal = 3.5;
    elseif loop<round(maxloop*11/12), l1 = lmid/1.1; l2 = lmid*1.1; move = 0.08; penal = 4.0;
    else,                             l1 = lmid/1.1; l2 = lmid*1.1; move = 0.04; penal = 4.25;
    end
    while (l2-l1)/(l1+l2) > 1e-3
        lmid = 0.5*(l2+l1);
        xnew = max(0,max(x-move,min(1,min(x+move,x.*sqrt(-dc./dv/lmid)))));
        xnew(pass_solid) = 1;
        xPhys(:) = (H*xnew(:))./Hs;
        if sum(xPhys(:)) > volfrac*nele, l1 = lmid; else l2 = lmid; end
    end
    change = max(abs(xnew(:)-x(:)));
    x = xnew;
    % PRINT RESULTS
    fprintf(' It.:%5i Obj.:%11.4f Vol.:%7.3f ch.:%7.3f\n',loop,c,mean(xPhys(:)),change);
    % PLOT DENSITIES
    if displayflag
        plotTOP3D(xPhys,plotcutoff);
        s = sprintf('Iteration = %03.0f      Penal = %.2f',loop,penal);
        title(s), drawnow
    end
end
if storefinal
    filename = sprintf('%s%03.0f.mat',storefileprefix,loop);
    save(filename,'xPhys','change','c','penal');
end