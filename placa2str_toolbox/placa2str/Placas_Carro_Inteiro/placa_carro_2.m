clear all, close all

im = iread('placa12.jpg', 'grey', 'double');

t = otsu(im)/2;

% Ajustar o THS, se colocar t ele aplica o ths adaptativo
im1 = niblack(im,-.5,1) < 0.3;
im2 = im1;%iopen(im1, ones(20));
figure, idisp(im2)

bl = iblobs(im2, 'area', [100 Inf]);

imt = zeros(size(im2,1), size(im2,2));

for i = 1:length(bl)
   imt(ceil(bl(i).vc), ceil(bl(i).uc)) = 1;
end

imt = idilate(imt, kcircle(25));

houghLines = Hough(imt);
idisp(imt);
p = houghLines.lines;
p.plot;

% Acha a equação da reta
for i = 1:numel(p)
    m(i) = atan(p(i).theta);
    c(i) = p(i).rho/cos(p(i).theta);
end

for i = 1:size(p,2)
    for j = 1:size(im1, 2)
        cu(i,j) = -m(i)*j + c(i);
    end   
end

% Desenha a reta
% for i = 1:size(im1,2)
%    im(ceil(abs(cu(1,i))), i) = 1;   
% end

figure, idisp(imt);
houghLines.plot;

figure, idisp(im);

p1 = 1;

% Pega todos que tiverem o centróide muito perto da linha de Hough
for ni=1:numel(p)
    for i=1:size(bl,2)
        if(abs(bl(i).vc - cu(ni,ceil(bl(i).vc))) < 40)
            if(median(abs(bl(:).theta))-(abs(bl(i).theta)) < 0.9) 
                bl1{ni}(1,p1) = bl(i);
                p1 = p1+1;
            end
        end
    end
    p1 = 1;
end

for ni=1:numel(bl1)
    if(size(bl1{ni},2) > 7)
        bl2{p1} = bl1{ni};
        taman(p1) = median(bl2{p1}.area);
        p1 = p1+1;        
    end
end

[~,tutu] = max(taman)

% Organiza por distribuição na placa, da esquerda para a direita
[bl1ord , I] = sort(bl2{tutu}.uc);

% Calcula a distância entre A e B
for i = 1:size(bl1ord,2)-1
   dis(i) = bl1ord(i+1) - bl1ord(i); 
end

% Separa os grupos por proximidade em X
paux_1 = [];
paux_1(1) = 1;
paux = 1;
pipi = 1;

for i = 2:size(dis,2)
   if( abs(median(dis) - dis(i)) < median(dis) && abs(median(dis) - dis(i-1)) < median(dis)) 
       paux = paux + 1;
       paux_1(pipi) = paux;
   else
       pipi = pipi + 1;
       paux = 1;
       paux_1(pipi) = paux;
   end
end

[val1, ind1] = max(paux_1)
letra = 1;

% Separa o grupo
if(ind1 ~= 1)
    for i=1:ind1-1
        letra = paux_1(i) + letra; 
    end
end

pa = 1;

for i=letra:val1+letra
    bl3(pa) = bl2{tutu}(I(i));
    pa = pa + 1;
end

figure, idisp(im1)
bl3.plot_box
p.plot

for i = 1:size(bl3,2)
    sub_im{i} = iroi(im, [bl3(i).umin, bl3(i).umax ; bl3(i).vmin , bl3(i).vmax])
%     figure, idisp(sub_im{i})
end

sub_im{i+1} = iroi(im, [min(bl3.umin), max(bl3.umax); min(bl3.vmin), max(bl3.vmax)])
figure, idisp(sub_im{i+1})

% imt = iblobs(sub_im{i+1})
% imt.plot_box