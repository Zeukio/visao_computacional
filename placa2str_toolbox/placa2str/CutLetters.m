function sub_im  = CutLetters( im, temp, type_moto)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
im_sub_box = iblobs(im);
[~, i] = max(im_sub_box.area);
sub_regioes = im_sub_box(i).children;

im_box_area = im_sub_box(sub_regioes).area;

im_box_area_mean = mean(im_box_area(im_box_area>0));
if ~temp
    for i = 1:length(sub_regioes)
        %filtrando area
        if im_box_area(i) > .4*im_box_area_mean && im_box_area(i) < 8*im_box_area_mean
            sub_regioes1(i) = sub_regioes(i);
        end
        
        
    end
else
     sub_regioes1 = sub_regioes;
end
% Coloca o vetor de sub-regiões na ordem correta
if ~temp & type_moto
    
    sub_regioes = Sortzitos(sub_regioes1, im_sub_box);
else
    sub_regioes = Sortzitos(sub_regioes1, im_sub_box,'template');
end



% Separa cada sub-imagem e as coloca em uma célula

% Selecionando a sub-região correta
p = im_sub_box(sub_regioes);

% Definindo o tamanho da região de corte
bufrect = [p.umin',p.umax',p.vmin', p.vmax'];

% Aplicando o corte
for i = 1:length(bufrect(:,1))
    sub_im{i} = iroi(im,[bufrect(i,1:2);bufrect(i,3:4)]);
    
    [a b] = size(sub_im{i});
    
    if b/a<0.2 %% caso for um i ou 1 fazer um redimensionamento grande
        vala = round(a*0.3);
        valb = round(b*1.3);
      
    else
        vala = round(a*0.3);
        valb = round(b*0.3);
      
    end
    
      sub_im{i} = [ones( vala,length(sub_im{i}(1,:)));sub_im{i}; ones(vala,length(sub_im{i}(1,:)))];
      sub_im{i} = [ones(length(sub_im{i}(:,1)),valb),sub_im{i}, ones(length(sub_im{i}(:,1)),valb)];      
end


% idisp(sub_im)

end

