function str = placa_com_carro(im,ths)
%%
% Escrever Help
%
t = otsu(im)/2;

% Ajustar o THS, se colocar t ele aplica o ths adaptativo
im1 = niblack(im,-.5,1) < ths;

bl = iblobs(im1, 'area', [100 Inf], 'touch',0);

imt = zeros(size(im1,1), size(im1,2));

for i = 1:length(bl)
   imt(ceil(bl(i).vc), ceil(bl(i).uc)) = 1;
end
imt = iconvolve(imt,kgauss(3));
houghLines = Hough(imt);

p = houghLines.lines;

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

figure, idisp(im);
for  i = 1:numel(p)
    if p(i).strength >= 1
        p(i).plot
        i
    end
end
bl.plot_box;

% figure, idisp(im);

p1 = 1;

% Pega todos que tiverem o centróide muito perto da linha de Hough
for i=1:size(bl,2)
    if(abs(bl(i).vc - cu(1,ceil(bl(i).vc))) < 40)
        if(median(abs(bl(:).theta))-(abs(bl(i).theta)) < 0.9) 
            bl1(1,p1) = bl(i);
            p1 = p1+1;
        end
    end
end

% Organiza por distribuição na placa, da esquerda para a direita
[bl1ord , I] = sort(bl1.uc);

% Calcula a distância entre A e B
for i = 1:size(bl1,2)-1
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
    bl2(pa) = bl1(I(i));
    pa = pa + 1;
end

% figure, idisp(im1)
bl1.plot_box

for i = 1:size(bl2,2)
    sub_im{i} = iroi(im, [bl2(i).umin, bl2(i).umax ; bl2(i).vmin , bl2(i).vmax])
%     figure, idisp(sub_im{i})
end

sub_im{i+1} = iroi(im, [min(bl2.umin), max(bl2.umax) ; min(bl2.vmin) , max(bl2.vmax)])
% figure, idisp(sub_im{i+1})

ths = 0.3;
w = ones(3);
str = placa2str(sub_im{end},ths,w,'display');

% imt = iblobs(sub_im{i+1})
% imt.plot_box

end
