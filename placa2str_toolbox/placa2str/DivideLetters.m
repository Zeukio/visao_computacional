function sub_im = DivideLetters(im_path, ths, varagin)
%DivideLetters:
%This function divide the first layer of childs from de image sent in 
%the path, using the threshold ths
% 
%   spread_letters(im_path, ths)
%   
%It's possible to aplay the iopen operation by sending the window as the
%tird paramiter
%  

temp = false;
% Lendo imagem(s) do(s) template(s)
im = iread(im_path,'grey','double');

% Aplicando o threshold no template
[U,V] = size(im);
im_pb = zeros(U,V);
im_pb(im<ths) = 1;

if nargin > 2 
    if isnumeric(varagin) && ismatrix(varagin)
    % varagin =  janela do iopen
   im_pb = iopen(im_pb,varagin);
    elseif isequal(varagin,'template')
        temp = true;
    else
        warning('error');
    end
end

% Seplarando cada caracter do template
im_sub_box = iblobs(im_pb);
 
% Descobrindo a maior area externa da imagem
[~, i] = max(im_sub_box.area);

% Descobrindo as regiões filhas da area externa
sub_regioes = im_sub_box(i).children;


% coloca o vetor de subregioens na ordem correta
if ~temp
sub_regioes = Sortzitos(sub_regioes, im_sub_box);
else
    sub_regioes = SortzitosTemp(sub_regioes, im_sub_box);
end    
% Separa cada sub imagem e as colocas em uma celula

    
    % Selecionando a sub_região correta
    p = im_sub_box(sub_regioes);
    % Definindo o tamanho da região de corte
    bufrect = [p.umin',p.umax',p.vmin', p.vmax'];
    % Aplicando o corte
    for i = 1: length(bufrect)
    sub_im{i} = iroi(im_pb,[bufrect(i,1:2);bufrect(i,3:4)]);
    end



end

