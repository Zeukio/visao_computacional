function vecfinal =  SortzitosTemp(sub_regioes, im_sub_box)

% Para manter a ordem das sub-imagens da esquerda pra direita usa-se a
% ordena��o pela posi��o central de cada regi�o.
% idx = length(im_sub_box.('uc'));

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