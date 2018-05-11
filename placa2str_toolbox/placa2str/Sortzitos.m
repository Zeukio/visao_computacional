function vecfinal =  Sortzitos(sub_regioes,im_sub_box)




% Para manter a ordem das subimagens da esquerda pra direita usa-se a
%ordenação pela posção central de cada região.
idxo = length(im_sub_box.('uc'));
p = im_sub_box.p;

% metodo de ordenção maluca (como os indices de uma matriz)
p = [[1:idxo]' p'];
[~, idxX]= sort(p(:,2));
pxo = p(idxX,:);
[~, idxY] = sort(p(:,3));
pyo = p(idxY,:);
pori = [];
porf = [];
medy = mean(p(:,3));
for i = 1:length(pxo)
    
    buf = pxo(i,:);
    
    if pxo(i,3) > medy        
        
        porf = [porf;buf];
    else
        
        pori = [pori;buf];
    end
end

por = [pori;porf];

idx = por(:,1);

vecfinal = [];

%
for i = 1:length(idx)
    for j = 1:length(sub_regioes)
        if idx(i) == sub_regioes(j)
            
            vecfinal = [vecfinal sub_regioes(j)];
        end
    end
end
end