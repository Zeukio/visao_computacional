function s_im = RecorteDaPlaca(im)
%RECORTEDAPLACA Summary of this function goes here
%   Detailed explanation goes here

im_sub_box = iblobs(im);

% Descobrindo a maior área externa da imagem
[~, idx] = max(im_sub_box.area);

% deve-se tentar descobrir se é uma placa de moto ou carro
    
    prop = (im_sub_box(idx).umax - im_sub_box(idx).umin)/(im_sub_box(idx).vmax - im_sub_box(idx).vmin);
    rect = [im_sub_box(idx).umin, im_sub_box(idx).umax; im_sub_box(idx).vmin, im_sub_box(idx).vmax];
    im = iroi(im,rect);
    if abs(prop-3) < 6e-1
        
        % Placa de carro
        temp = 'TempeMask\MaskCarro.jpg'; 
    elseif  abs(prop - 1.1) < 1e-1
        
        % Placa Moto
        temp = 'TempeMask\MaskMoto.jpg';
    else
        s_im = {im};
        warning('imagem fora da proporção')
        return;
    end   
    
mask = iread(temp, 'double', 'grey');


%figure, idisp(maskinv);
buf = imresize(mask, size(im));
% buf = iopen(buf,ones(20));
buf(buf > 0.8) = 1;
buf(buf ~= 1) = 0;


buf1 = 1 - buf;

 a = iblobs(buf1,'connect',8);
 box_a = [(a.umax' - a.umin').*(a.vmax'- a.vmin')];
 [~, i] = max(box_a);
 i =   a(i).children; 
 p = a(i);
 
 cid_box = [p(1).umin, p(1).umax;p(1).vmin, p(1).vmax];
 cod_box = [p(2).umin, p(2).umax;p(2).vmin, p(2).vmax];
 cidade = [];
 codigo = [];
 
 for i= 1:length(im_sub_box)     
     if EstaDentro(cid_box ,im_sub_box(i).p)
         
         cidade =[cidade im_sub_box(i)];    
     elseif EstaDentro(cod_box ,im_sub_box(i).p) && i~=idx
         
         codigo =[codigo im_sub_box(i)];
     end
 end
 
 
bufrect = [min(cidade.umin),max(cidade.umax),min(cidade.vmin),max(cidade.vmax) ;...
 min(codigo.umin),max(codigo.umax),min(codigo.vmin),max(codigo.vmax)];

for idx = 1:length(p)
    s_im_b = iroi(im,[bufrect(idx,1:2);bufrect(idx,3:4)]);    
    borda = round(30*size(s_im_b,1)/size(s_im_b,2))+1;
    % adicionando uma borda para melhorar o recorte
    s_im_b =  [ones( borda,length(s_im_b (1,:)));s_im_b ; ones(borda,length(s_im_b (1,:)))];
    s_im{idx} = [ones(length(s_im_b (:,1)),borda),s_im_b , ones(length(s_im_b (:,1)),borda)];

end



end

