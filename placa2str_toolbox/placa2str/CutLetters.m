function sub_im  = CutLetters( im, temp )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

im = [im; im(1,:)];
im_sub_box = iblobs(im);
[~, i] = max(im_sub_box.area);
sub_regioes = im_sub_box(i).children;



for i = 1:length(sub_regioes)
    %filtrando area
    if im_sub_box(sub_regioes(i)).area > 20
        sub_regioes1(i) = sub_regioes(i);
    end
end

% Coloca o vetor de sub-regiões na ordem correta
if ~temp
    
    sub_regioes = Sortzitos(sub_regioes1, im_sub_box);
else
    
    sub_regioes = SortzitosTemp(sub_regioes1, im_sub_box);
end



% Separa cada sub-imagem e as coloca em uma célula

% Selecionando a sub-região correta
p = im_sub_box(sub_regioes);

% Definindo o tamanho da região de corte
bufrect = [p.umin',p.umax',p.vmin', p.vmax'];

% Aplicando o corte
for i = 1:length(bufrect)
    sub_im{i} = iroi(im,[bufrect(i,1:2);bufrect(i,3:4)]);
end
% idisp(sub_im)

end

