function [sub_im, varagout] = DivideLetters(im, ths, varargin)
%% DivideLetters:
%Esta função separa cada uma das letras da placa da imagem im, usando o
%threshold ths.
%
%   DivideLetters(im, ths)
%
% É possivel mandar parametros extras de entradas para a função sendo que:
% 1 -  se o parametro extra for uma matriz numerica, ela será interpretada
% como uma janela usada na função do iopen
%
%  DivideLetters(im, ths, iopen_window)
%
% 2 - se for mandado a string 'template', a função não aplicará mascaras de recorte
%
%  DivideLetters(im, ths, 'template')
%
% *LIMITAÇÕES:*
% *A função necessita que a imagem contenha sómente a placa*
%



%%
temp = false;
moto = false;
cod = false;
codigo_placa = false;

% imagens para o display
stepbystep = {};
stepbystep = [stepbystep im];
% Aplicando o threshold 

im(im > ths) = 1;
im(im <= ths) = 0;

% analisando os parametros extras
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
                
                % Erro caso os comandos forem inválidos
                error('Invalid Input');
            end
        end
    end
end



stepbystep = [stepbystep im];
if ~temp
new_im = RecorteDaPlaca(im); 
else
    new_im = {im};
end
% figure, idisp(im);
stepbystep = [stepbystep new_im];

%cortando as letras de cada uma das partes da imagem
for i = 1:length(new_im)
    if i>1 && moto
        
        codigo_placa = true;        
    end 
    
    sub_im{i} = CutLetters(new_im{i}, temp,codigo_placa); 
    stepbystep = [stepbystep iconcat(sub_im{i}, 'h')];
end

% saída do passa a passo

varagout = iconcat(stepbystep,'v'); %


end

