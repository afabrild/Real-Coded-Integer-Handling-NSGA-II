function [ p, idxs] = paretoFront( p )
% Filters a set of points P according to Pareto dominance, i.e., points
% that are dominated (both weakly and strongly) are filtered.
%
% Inputs: 
% - P    : N-by-D matrix, where N is the number of points and D is the 
%          number of elements (objectives) of each point.
%
% Outputs:
% - P    : Pareto-filtered P
% - idxs : indices of the non-dominated solutions
%
% Example:
% p = [1 1 1; 2 0 1; 2 -1 1; 1, 1, 0];
% [f, idxs] = paretoFront(p)
%     f = [1 1 1; 2 0 1]
%     idxs = [1; 2]

[i, dim] = size(p);
idxs = [1 : i]';
while i >= 1
    old_size = size(p,1);
    indices = sum( bsxfun( @ge, p(i,:), p ), 2 ) == dim;
    indices(i) = false;
    p(indices,:) = [];
    idxs(indices) = [];
    i = i - 1 - (old_size - size(p,1)) + sum(indices(i:end));
end    

end