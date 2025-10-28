function []=PlotPolyMesh(NODE,ELEM,SUPP,LOAD)
figure, hold on, axis equal, axis off
MaxNVer = max(cellfun(@numel,ELEM));         %Max. num. of vertices in mesh
PadWNaN = @(E) [E NaN(1,MaxNVer-numel(E))];  %Pad cells with NaN
ElemMat = cellfun(PadWNaN,ELEM,'UniformOutput',false);
ElemMat = vertcat(ElemMat{:});               %Create padded element matrix
patch('Faces',ElemMat,'Vertices',NODE,'FaceColor','w');
if (nargin==4 && ~isempty(SUPP) && ~isempty(LOAD))
    plot(NODE(SUPP(:,1),1),NODE(SUPP(:,1),2),'b>','MarkerSize',8);
    plot(NODE(LOAD(:,1),1),NODE(LOAD(:,1),2),'m^','MarkerSize',8);
end
axis tight, drawnow