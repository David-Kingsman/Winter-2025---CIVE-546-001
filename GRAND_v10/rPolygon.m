function flag=rPolygon(P,NODE,BARS)
% Polygon with N edges defined by P of size [N x 2]
% Get normals for each half-space (P are poly nodes in CCW)
Np= size(P,1); % Number of half-spaces
N = zeros(Np,2);
N(1:Np-1,:) = P(2:Np,:) - P(1:Np-1,:); N(Np,:) = P(1,:) - P(Np,:);
N = [ N(:,2) -N(:,1) ]; % Normal vectors for all half-spaces
% Get number of bars and initialize T
Nb= size(BARS,1);
D = NODE(BARS(:,2),:) - NODE(BARS(:,1),:);
Tmin = zeros(Nb,1); Tmax = ones(Nb,1);
% Loop through all halfspaces
for i=1:Np
    deno = D * N(i,:)';
    dist = ( repmat(P(i,:),Nb,1) - NODE(BARS(:,1),:) ) * N(i,:)';
    T = dist ./ deno;
    ind = find( (T>Tmin) .* (deno<0) ); Tmin(ind) = T(ind);
    ind = find( (T<Tmax) .* (deno>0) ); Tmax(ind) = T(ind);
end
% No intersection if Tmin>Tmax
flag = (Tmin<=Tmax);