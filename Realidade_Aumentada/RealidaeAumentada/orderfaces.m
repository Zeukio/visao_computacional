function [n_facescenter idx, ncor] = orderfaces( camloc, facescenter,c,ph,inic )
%ORDERFACES Summary of this function goes here
%   Detailed explanation goes here
camloc = -camloc';
% camloc(3) = -camloc(3);
camloc = [camloc(3) camloc(2) camloc(1)];

cor{1} = [1 2 3];
cor{2} = [1 2 4];
cor{3} = [1 3 5];
cor{4} = [1 5 4];
cor{5} = [2 3 6];
cor{6} = [2 6 4];
cor{7} = [3 5 6];
cor{8} = [4 5 6];


for i = 1:length(ph)
       discor(i) = sqrt(sum((ph(i,:)-camloc ) .^ 2));
end 

[~, ncor2] = sort(discor,'descend');

fin = cor{ncor2(2)};
ncor= ncor2(1);
nd = zeros(1,6);
fd = [];
f = [];
n = [];

% fin = [1 2 3 4 5 6];

for i = fin
    nd(i) =  sqrt(sum((camloc - facescenter(i,:)) .^ 2));
end



[~, nfac] = sort(nd,'ascend');
 

idx = nfac(4:-1:1);
n_facescenter = facescenter(idx,:);

end

