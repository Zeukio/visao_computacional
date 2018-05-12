function sub_im = DivideLetters(im_path, ths, varagin)
%% DivideLetters:
%Esta função separa cada uma das letras da placa da imagem im, usando o
%threshold ths.
%
%   spread_letters(im_path, ths)
%
% É possivel mandar parametros extras de entradas para a função sendo que:
% 1 -  se o parametro extra for uma matriz numerica, ela será interpretada
% como uma janela usada na função do iopen
%
%  DivideLetters(im_path, ths, iopen_window)
%
% 2 - se for mandado a string 'template', a função não aplicará mascaras de recorte  
%
%  DivideLetters(im_path, ths, 'template')
%
% 
%
% *LIMITAÇÕES:*
% *A função necessita que a imagem contenha sómente a placa e ja com a
% distorção corrigida.*
% 


stepbystep = {};
temp = false;
% Lendo imagem(s) do(s) template(s)
im = iread(im_path,'grey','double');
figure, idisp(im);
stepbystep = [stepbystep im]; 

% Aplicando o threshold no template
im(im > ths) = 1;
% figure, idisp(im);
stepbystep = [stepbystep im]; 

if nargin > 2    
    
    if isnumeric(varagin) && ismatrix(varagin)
        
        % varagin =  Janela do iopen
        im = iopen(im, varagin);
        %             im = ierode(idilate(im, ones(2)), ones(3));
        figure, idisp(im);
    elseif isequal(varagin,'template')
        
        temp = true;
    else
        
        warning('Erro, verifique os parâmetros da função');
    end
end

% Separando cada caracter do template
im_sub_box = iblobs(im);

% Descobrindo a maior área externa da imagem
[~, i] = max(im_sub_box.area);

% Se a imagem não for o template deve-se descobrir se é moto ou carro
if ~temp
    
    prop = (im_sub_box(i).umax - im_sub_box(i).umin)/(im_sub_box(i).vmax - im_sub_box(i).vmin);
    if abs(prop-3) < 1e-1
        
        % Placa de carro
       im = RecorteDaPlaca(im, 'carro');
    elseif  abs(prop - 1.1) < 1e-1
        
        % Placa Moto
        im = RecorteDaPlaca(im, 'moto');
    else
        
        warning('Modelo de placa não detectado \n prop: %d',prop);
    end
end
% figure, idisp(im);
stepbystep = [stepbystep im]; 

% Descobrindo as regiões filhas da area externa
sub_regioes = im_sub_box(i).children;

% Filtrando as regioes
for i = 1:length(sub_regioes)
    
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

p.plot_box;

% Definindo o tamanho da região de corte
bufrect = [p.umin',p.umax',p.vmin', p.vmax'];

% Aplicando o corte
for i = 1:length(bufrect)
    sub_im{i} = iroi(im,[bufrect(i,1:2);bufrect(i,3:4)]);
end

% Mostrando o passo a passo
iconcat(stepbystep,'v')

end

