function fig  = SimpleThrash( im, fil )
%SIMPLETHRASH Summary of this function goes here
%   Detailed explanation goes here
[U,V] = size(im);
fig = zeros(U,V);
fig(im<fil) = 1;
end

