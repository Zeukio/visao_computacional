function sub_im = DivideLetters(im_path, ths, varagin)
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


stepbystep = {};
temp = false;
moto = false;
codigo_placa = false;
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
        
        warning('Erro, verifique os par�metros da fun��o');
    end
end

% Separando cada caracter do template
im_sub_box = iblobs(im);

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
        moto = true
    else
        new_im  = {im};
        warning('Modelo de placa n�o detectado \n prop: %d',prop);
    end
else
    new_im  = {im};
end
% figure, idisp(im);
stepbystep = [stepbystep im]; 

for i = 1:length(new_im)
    if i>1 && moto
    codigo_placa = true;
    end
    sub_im{i} = CutLetters(new_im{i}, temp,codigo_placa)
 
    
end
    


% Mostrando o passo a passo
iconcat(stepbystep,'v')

end

