function []=PlotGroundStructure(NODE,BARS,A,Cutoff,Ng,Nf)

figure('Name','GRAND v1.0 -- Zegard T, Paulino GH','NumberTitle','off')
hold on, axis equal, axis off; %color=jet(Ng);
color=[1,0,0;0.25,0.25,0.25]
A = A/max(A); % Normalize to [0,1] areas
ind = find(A>Cutoff);
% MyGroup = ceil(Ng*A(ind)); % Round up to the closest group of bars
% Groups = cell(Ng,1);       % Store the indices of similar bars
% for i=1:Ng, Groups{i} = ind(find(MyGroup==i)); end
% for i=Ng:-1:1 % Plot each group of similar bars in a single plot call
%     if ~isempty(Groups{i})
%         XY = [NODE(BARS(Groups{i},1),:) NODE(BARS(Groups{i},2),:)];
%         GroupArea = mean(A(Groups{i})); % Mean area for this group
%         plot(XY(:,[1 3])',XY(:,[2 4])','LineWidth',5*sqrt(GroupArea),'Color',color(i,:))
%     end
% end

MyGroup = ceil(Ng*Nf(ind)); % Round up to the closest group of bars
Groups = cell(Ng,1);            % Store the indices of similar bars
% for i=1:Ng, Groups{i} = ind(find(MyGroup==i)); end
Groups{1}=ind(find(Nf(ind)>0))
Groups{2}=ind(find(Nf(ind)<0))
for i=Ng:-1:1 % Plot each group of similar bars in a single plot call
    if ~isempty(Groups{i})
        XY = [NODE(BARS(Groups{i},1),:) NODE(BARS(Groups{i},2),:)];
        GroupArea = mean(A(Groups{i})); % Mean area for this group
        plot(XY(:,[1 3])',XY(:,[2 4])','LineWidth',10,'Color',color(i,:))
    end
end
fprintf('-PLOT- Cutoff %g, Groups %g, Bars plotted %g\n',Cutoff,Ng,length(ind))