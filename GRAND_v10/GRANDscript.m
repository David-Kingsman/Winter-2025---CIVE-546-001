%GRAND - Ground Structure Analysis and Design Code.
%   Tomas Zegard, Glaucio H Paulino - Version 1.0, Dec-2013
clc,clear,close all
%% === MESH GENERATION LOADS/BCS ==========================================
kappa = 20; ColTol = 0.999999;
Cutoff = 0.002; Ng = 2; % Plot: Member Cutoff & Number of plot groups

% --- OPTION 1: POLYMESHER MESH GENERATION --------------------------------
% addpath('./PolyMesher')
% [NODE,ELEM,SUPP,LOAD] = PolyMesher(@MichellDomain,600,30);
% Lvl = 5; RestrictDomain = @RestrictMichell;
% rmpath('./PolyMesher')

% --- OPTION 2: STRUCTURED-ORTHOGONAL MESH GENERATION ---------------------
[NODE,ELEM,SUPP,LOAD] = StructDomain(8,6,8,6,'mbb');
Lvl = 3; RestrictDomain = []; % No restriction for box domain

% --- OPTION 3: LOAD EXTERNALLY GENERATED MESH ----------------------------
% load MeshHook
% Lvl = 10; RestrictDomain = @RestrictHook;

% load MeshSerpentine
% Lvl = 5; RestrictDomain = @RestrictSerpentine;

% load MeshMichell
% Lvl = 4; RestrictDomain = @RestrictMichell;

% load MeshFlower
% Lvl = 4; RestrictDomain = @RestrictFlower;

%% === GROUND STRUCTURE METHOD ============================================
PlotPolyMesh(NODE,ELEM,SUPP,LOAD) % Plot the base mesh
[BARS] = GenerateGS(NODE,ELEM,Lvl,RestrictDomain,ColTol); % Generate the GS
Nn = size(NODE,1); Ne = length(ELEM); Nb = size(BARS,1);
[BC] = GetSupports(SUPP);                 % Get reaction nodes
[BT,L] = GetMatrixBT(NODE,BARS,BC,Nn,Nb); % Get equilibrium matrix
[F] = GetVectorF(LOAD,BC,Nn);             % Get nodal force vector

fprintf('Mesh: Elements %d, Nodes %d, Bars %d, Level %d\n',Ne,Nn,Nb,Lvl)
BTBT = [BT -BT]; LL = [L; kappa*L]; sizeBTBT = whos('BTBT'); clear BT L
fprintf('Matrix [BT -BT]: %d x %d in %gMB (%gGB full)\n',...
        length(F),length(LL),sizeBTBT.bytes/2^20,16*(2*Nn)*Nb/2^30)

tic, [S,vol,exitflag] = linprog(LL,[],[],BTBT,F,zeros(2*Nb,1));
fprintf('Objective V = %f\nlinprog CPU time = %g s\n',vol,toc);

S = reshape(S,numel(S)/2,2);  % Separate slack variables
A = S(:,1) + kappa*S(:,2);    % Get cross-sectional areas
N = S(:,1) - S(:,2);          % Get member forces

%% === PLOTTING ===========================================================
PlotGroundStructure(NODE,BARS,A,Cutoff,Ng,N)
PlotBoundary(ELEM,NODE)