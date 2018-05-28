function str = im2str(im, ths, varargin)
%% im2str
%
%   |str = im2str(im, ths, varargin)|
%
% essa função compara a imagem mandada com o template das letras _mandatory_
% retornando o caracter comparado
%
% Comparando qual quer caracter
%   |im2str(im, ths)|
%
% Comparando especificamente com numeros
%   |im2str(im, ths, 'numero')|
%
% Comparando especificamente com letras
%   |im2str(im, ths, 'letra')|
%

%% Lendo a(s) imagem(s) do(s) template(s)
% detecção dos comandos extras

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
            if isequal(comand{i},'numero')
                
                % Definindo o path do template numeros
                template_path = 'TempeMask\TemplateNumbers.jpg';         
                match_str_vec = ['1234567890'];           
            elseif isequal(comand{i},'letra')
                
                % Definindo o path do template letras
                template_path = 'TempeMask\TemplateLetters.jpg'; 
                match_str_vec = ['ABCDEFGHIJKLMNOPQRSTUVWXYZ'];
            else
                % Erro caso os comandos forem inválidos
                error('Invalid Input');
            end
        end
    end
else
    % Definindo o path do template letras e numeros
    template_path = 'TempeMask\Template.jpg'; 
    match_str_vec = ['ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'];
end
%IM2STR Summary of this function goes here
%   Detailed explanation goes here

Template = iread(template_path,'grey','double');
% Definindo o valor do Threshold
threshold_value = 0.2;
% Separando as letras do template letras
Template_im = DivideLetters(Template, threshold_value, 'template');
%% tratamento da im
im(im > ths) = 1;
im(im <= ths) = 0;
borda = 5 ;
% adicionando uma borda para melhorar o recorte
im = [ones( borda,length(im(1,:)));im; ones(borda,length(im(1,:)))];
im = [ones(length(im(:,1)),borda),im, ones(length(im(:,1)),borda)];


for j = 1:length(Template_im{1})
    % redimencionando a letra da placa para ficar com o mesmo tamanho da
    % letra no template
    buf = imresize(im,size(Template_im{1}{j}));   
    % fazendo o zncc entre cada letra da placa com o template
    vec(j,:)= [zncc(Template_im{1}{j},buf)];
end
% Separando o matching mais forte
[val, chara] = max(abs(vec));
% Armazenado no vetor matching o valor do mathing e o index de cada
% correspondência

if val > 0.1
    
    str = match_str_vec(chara);
else
    
    str = '_';
    warning('wrong match');
end






end

