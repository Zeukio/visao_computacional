function sub_im  = CutLetters( im, temp, type_moto)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

im = [ones(1,length(im(1,:)));im; ones(1,length(im(1,:)))];
im_sub_box = iblobs(im);
[~, i] = max(im_sub_box.area);
sub_regioes = im_sub_box(i).children;



% for i = 1:length(sub_regioes)
%     %filtrando area
%     if im_sub_box(sub_regioes(i)).area > 20
%         sub_regioes1(i) = sub_regioes(i);
%     end
% end

for i = 1:length(sub_regioes)
    %filtrando area
    if im_sub_box(sub_regioes(i)).area > .3*mean(im_sub_box(sub_regioes).area)
        sub_regioes1(i) = sub_regioes(i);
    end
    
        
end

% Coloca o vetor de sub-regiões na ordem correta
if ~temp & type_moto
    
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
    
    [a b] = size(sub_im{i});
    
    if b/a<0.2 %% caso for um i ou 1 fazer um redimensionamento grande
        vala = 0.2;
        valb = 0.3;
      
    else
        vala = 0.2;
        valb = 0.2;
      
    end
      sub_im{i} = [ones(round(a*vala),b); sub_im{i}];
      [a b] = size(sub_im{i});
      sub_im{i} =  [sub_im{i},ones(a,round(b*valb));ones(round(a*vala/3),b+round(b*valb))];
      [a b] = size(sub_im{i});
      sub_im{i} =  [ones(a,round(b*valb/5)),sub_im{i}];
       
end
% idisp(sub_im)

end

