function []=PlotBoundary(ELEM,NODE)

% Get number of nodes, elements and edges (nodes) per element
Nn = size(NODE,1); Ne = length(ELEM); NpE = cellfun(@numel,ELEM);

FACE = sparse([],[],[],Nn,Nn,sum(NpE));
for i=1:Ne
    MyFACE = [ELEM{i}; ELEM{i}(2:end) ELEM{i}(1)];
    for j=1:NpE(i)
        if FACE(MyFACE(1,j),MyFACE(2,j))==0 % New edge - Flag it
            FACE(MyFACE(1,j),MyFACE(2,j)) = i;
            FACE(MyFACE(2,j),MyFACE(1,j)) =-i;
        elseif isnan(FACE(MyFACE(1,j),MyFACE(2,j)))
            error(sprintf('Edge [%d %d] found in >2 elements',MyFACE(:,j)))
        else % Edge belongs to 2 elements: inside domain. Lock it.
            FACE(MyFACE(1,j),MyFACE(2,j)) = NaN;
            FACE(MyFACE(2,j),MyFACE(1,j)) = NaN;
        end
    end
end
[BOUND(:,1),BOUND(:,2)] = find(FACE>0);
BOUND(:,3) = FACE(sub2ind(size(FACE),BOUND(:,1),BOUND(:,2)));
plot([NODE(BOUND(:,1),1) NODE(BOUND(:,2),1)]',[NODE(BOUND(:,1),2) NODE(BOUND(:,2),2)]','k')