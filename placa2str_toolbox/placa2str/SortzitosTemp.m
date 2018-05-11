function vecfinal =  SortzitosTemp(sub_regioes,im_sub_box)




% Para manter a ordem das subimagens da esquerda pra direita usa-se a
%ordenação pela posção central de cada região.
%idxo = length(im_sub_box.('uc'));

[~,idx] = sort([im_sub_box.('uc')]);


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