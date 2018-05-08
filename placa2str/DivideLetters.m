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


% Lendo imagem(s) do(s) template(s)
im = iread(im_path,'grey','double');

% Aplicando o threshold no template
im_pb = SimpleThrash(im,ths);

if nargin > 2 && isnumeric(varagin) && ismatrix(varagin)
    
   im_pb = iopen(im_pb,varagin);    
end    
% Seplarando cada caracter do template
im_sub_box = iblobs(im_pb);

% Descobrindo a area externa da imagem
[~, i] = max(im_sub_box.area);

% Descobrindo as regiões filhas da area externa  
sub_regioes = im_sub_box(i).children;

% Para manter a ordem das subimagens da esquerda pra direita usa-se a
%ordenação pela posção central de cada região. 
[~,idx] = sort([im_sub_box.('uc')]);

% coloca o vetor de subregioens na ordem correta
sub_regioes = Sortzitos(sub_regioes, idx);

% Separa cada sub imagem e as colocas em uma celula
for i =1:length(sub_regioes)
    
    % Selecionando a sub_região correta
    p = im_sub_box(sub_regioes(i));
    % Definindo o tamanho da região de corte
    bufrect = [p.umin,p.umax;p.vmin p.vmax];
    % Aplicando o corte
    sub_im{i} = iroi(im_pb,bufrect);
end


end

