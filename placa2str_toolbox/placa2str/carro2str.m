
function str = carro2str(im,ths,w, otsuf,varargin)
%%
%  essa fun��o retorna uma string com as informa��es da placa do carro
% |carro2str(im, otsuf,varargin)|
%
%
%
%


display = false;

%% varargin
if nargin > 4
    
    if isa(varargin{1},'cell')
        
        comand = varargin{1};
        [~, buf] = size(varargin{1});
    else
        
        [~, buf] = size(varargin);
        for i = 1:buf
            
            comand{i} =  varargin{i};
        end
    end
    
    for i = 1 : buf
        if ischar(comand{i})
            if isequal(comand{i},'display')
                
                %se display
                display = true;
            else
                % Erro caso os comandos forem inv�lidos
                error('Invalid Input');
            end
        end
    end
end

%% 
% definido o Ths
t = otsu(im)/otsuf;

% Ajustar o THS, se colocar t ele aplica o ths adaptativo
im2 = niblack(im,-.5,1) < t;
% im2 = im1; %iopen(im1, ones(5));
% figure, idisp(im2)

bl = iblobs(im2, 'area', [100 Inf], 'touch', 0);

imt = zeros(size(im2,1), size(im2,2));

for i = 1:length(bl)
   imt(ceil(bl(i).vc), ceil(bl(i).uc)) = 1;
end

imt = idilate(imt, kcircle(3));

houghLines = Hough(imt, 'houghthresh', 0.25);
% idisp(imt);
p = houghLines.lines;
% p.plot;

%% Acha a equa��o da reta
for i = 1:numel(p)
    m(i) = atan(p(i).theta);
    c(i) = p(i).rho/cos(p(i).theta);
end

for i = 1:size(p,2)
    for j = 1:size(im2, 2)
        cu(i,j) = -m(i)*j + c(i);
    end   
end

% figure, idisp(imt);
% houghLines.plot;
% figure, idisp(im);

p1 = 1;

%% Pega todos que tiverem o centr�ide muito perto da linha de Hough
for ni=1:numel(p)
    for i=1:size(bl,2)
        if(abs(bl(i).vc - cu(ni,ceil(bl(i).vc))) < 100)
            if(median(abs(bl(:).theta))-(abs(bl(i).theta)) < 0.4) 
                bl1{ni}(1,p1) = bl(i);
                p1 = p1+1;
            end
        end
    end
    p1 = 1;
end

for ni=1:numel(bl1)
    if(size(bl1{ni}, 2) > 7)
        bl2{p1} = bl1{ni};
        taman(p1) = median(bl2{p1}.area);
        p1 = p1+1;        
    end
end

[~,tutu] = max(taman);

%% Organiza por distribui��o na placa, da esquerda para a direita
[bl1ord , I] = sort(bl2{tutu}.uc);

% Calcula a dist�ncia entre A e B
for i = 1:size(bl1ord,2)-1
   dis(i) = bl1ord(i+1) - bl1ord(i); 
end

% Separa os grupos por proximidade em X
paux_1 = [];
paux_1(1) = 1;
paux = 1;
pipi = 1;

for i = 2:size(dis,2)
   if( abs(median(dis) - dis(i)) < median(dis) && abs(median(dis) - dis(i-1)) < median(dis) ) 
       paux = paux + 1;
       paux_1(pipi) = paux;
   else
       pipi = pipi + 1;
       paux = 1;
       paux_1(pipi) = paux;
   end
end

[val1, ind1] = max(paux_1);
letra = 1;

%% Separa o grupo
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

pa = 1;

for nb=1:numel(bl3)
    if (abs(median(bl3.a) - bl3(nb).a) < 100)   
        bl4(pa) = bl3(nb);
        pa = pa + 1;
    end
end

% figure, idisp(im)
% bl3.plot_box
% bl.plot
% p.plot
%% arrumar isso aqui
% qual vamos usar???, aplaca toda sempre???????
% for i = 1:size(bl4,2)
%     
%     sub_im{i} = iroi(im, [bl4(i).umin, bl4(i).umax ; bl4(i).vmin , bl4(i).vmax])
%     %     figure, idisp(sub_im{i})
% end

squr = [min(bl4.umin)-(median(bl4.a)*0.8), max(bl4.umax)+(median(bl4.a)*0.5); min(bl4.vmin)-(median(bl4.a)*1.5), max(bl4.vmax)+(median(bl4.a)*0.5)];
sub_im = iroi(im,squr);
% figure, idisp(sub_im)

im2 = sub_im;
im2(im2>.7) = 0;
im2(im2<.4) = 0;
im2(im2>=.4) =1;
im2 = iopen(im2,ones(5));
im2 = iclose(im2,ones(10));
p = iblobs(im2);
[~,idx]=max(p.area);
p(idx).plot_box;
bufrect = [p(idx).umin',p(idx).umax';p(idx).vmin', p(idx).vmax'];
im3 = iroi(sub_im,bufrect);

if display
    
    str_cell = placa2str(im3,ths,w,'display');
else
    
    str_cell = placa2str(im3,ths,w);
end

str = [];

for i = 1:length(str_cell)
    
    str = [str, str_cell{i}, ' '];
end
end
% imt = iblobs(sub_im{i+1})
% imt.plot_box