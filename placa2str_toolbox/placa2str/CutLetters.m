function sub_im  = CutLetters( im, temp, type_moto)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
 borda = 5 ;
% adicionando uma borda para melhorar o recorte
im = [ones( borda,length(im(1,:)));im; ones(borda,length(im(1,:)))];
im = [ones(length(im(:,1)),borda),im, ones(length(im(:,1)),borda)];
im_sub_box = iblobs(im);
[~, i] = max(im_sub_box.area);
sub_regioes = im_sub_box(i).children;



for i = 1:length(sub_regioes)
    %filtrando area
    if im_sub_box(sub_regioes(i)).area > .4*mean(im_sub_box(sub_regioes).area)
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
    
    if b/a<0.2 %% caso for um i ou 1 fazer um redimensionamento grande
        vala = round(a*0.2);
        valb = round(b*1.0);
      
    else
        vala = round(a*0.2);
        valb = round(b*0.2);
      
    end
    
      sub_im{i} = [ones( vala,length(sub_im{i}(1,:)));sub_im{i}; ones(vala,length(sub_im{i}(1,:)))];
      sub_im{i} = [ones(length(sub_im{i}(:,1)),valb),sub_im{i}, ones(length(sub_im{i}(:,1)),valb)];      
end
% idisp(sub_im)

end

