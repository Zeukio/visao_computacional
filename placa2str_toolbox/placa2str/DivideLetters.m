function [sub_im, varagout] = DivideLetters(im, ths, varargin)
%% DivideLetters:
%Esta fun��o separa cada uma das letras da placa da imagem im, usando o
%threshold ths.
%
%   spread_letters(im_path, ths)
%
% � possivel mandar parametros extras de entradas para a fun��o sendo que:
% 1 -  se o parametro extra for uma matriz numerica, ela ser� interpretada
% como uma janela usada na fun��o do iopen
%
%  DivideLetters(im_path, ths, iopen_window)
%
% 2 - se for mandado a string 'template', a fun��o n�o aplicar� mascaras de recorte
%
%  DivideLetters(im_path, ths, 'template')
%
%
%
% *LIMITA��ES:*
% *A fun��o necessita que a imagem contenha s�mente a placa e ja com a
% distor��o corrigida.*
%


%%
% arrumar varagin
%





%%
temp = false;
moto = false;
cod = false;
codigo_placa = false;
% Lendo imagem(s) do(s) template(s)

% imagens para o display
stepbystep = {};
stepbystep = [stepbystep im];
% Aplicando o threshold no template
im(im > ths) = 1;



if nargin > 2
    
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
            if isequal(comand{i},'alfanum')
                
                cod = comand{i+1};
                i = i+1;
            elseif isequal(comand{i},'window')
                
                im = iopen(im, comand{i+1});
                i = i+1;
            elseif isequal(comand{i},'template')
                
                temp = true;
            else
                % Erro caso os comandos forem inv�lidos
                error('Invalid Input');
            end
        end
    end
end



stepbystep = [stepbystep im];
%%
% [u v] = size(im);
% im = [ones(u,3),im, ones(u,3)];
% [u v] = size(im);
% im = [ones(3,v); im; ones(3,v)];
% Separando cada caracter do template
im_sub_box = iblobs(im,'connect',8);

% Descobrindo a maior �rea externa da imagem
[~, i] = max(im_sub_box.area);

% Se a imagem n�o for o template deve-se descobrir se � moto ou carro
if ~temp
    
    prop = (im_sub_box(i).umax - im_sub_box(i).umin)/(im_sub_box(i).vmax - im_sub_box(i).vmin);
    if abs(prop-3) < 4e-1
        
        % Placa de carro
        new_im = RecorteDaPlaca(im, 'carro');
    elseif  abs(prop - 1.1) < 1e-1
        
        % Placa Moto
        new_im = RecorteDaPlaca(im, 'moto');
        moto = true;
    elseif cod || temp
        new_im  = {im};
    else
        new_im  = {im};
        warning('Modelo de placa n�o detectado \n prop: %d',prop);
    end
else
    new_im  = {im};
end
% figure, idisp(im);
stepbystep = [stepbystep new_im];

for i = 1:length(new_im)
    if i>1 && moto
        codigo_placa = true;
    end
    sub_im{i} = CutLetters(new_im{i}, temp,codigo_placa);
    
    
end



% Mostrando o passo a passo

varagout = iconcat(stepbystep,'v'); %% display


end

