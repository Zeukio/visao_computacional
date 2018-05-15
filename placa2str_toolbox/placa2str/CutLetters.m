function sub_im  = CutLetters( im, temp, type_moto)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

im = [ones(1,length(im(1,:)));im; ones(1,length(im(1,:)))];
im_sub_box = iblobs(im);
[~, i] = max(im_sub_box.area);
sub_regioes = im_sub_box(i).children;



for i = 1:length(sub_regioes)
    %filtrando area
    if im_sub_box(sub_regioes(i)).area > 20
        sub_regioes1(i) = sub_regioes(i);
    end
end

% Coloca o vetor de sub-regi�es na ordem correta
if ~temp & type_moto
    
    sub_regioes = Sortzitos(sub_regioes1, im_sub_box);
else
    sub_regioes = SortzitosTemp(sub_regioes1, im_sub_box);
end



% Separa cada sub-imagem e as coloca em uma c�lula

% Selecionando a sub-regi�o correta
p = im_sub_box(sub_regioes);

% Definindo o tamanho da regi�o de corte
bufrect = [p.umin',p.umax',p.vmin', p.vmax'];

% Aplicando o corte
for i = 1:length(bufrect)
    sub_im{i} = iroi(im,[bufrect(i,1:2);bufrect(i,3:4)]);
    
    [a b] = size(sub_im{i});
    
    if b/a<0.2
       sub_im{i} = [sub_im{i}, ones(length(sub_im{i}),30); ]
    end
end
% idisp(sub_im)

end

