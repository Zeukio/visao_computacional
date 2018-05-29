function str = placa2str(im,ths,w,varargin)
%% placa2str
%
%   |str = placa2str(im,ths,w,varargin)|
%
%  Essa função tem como objetivo implementar uma função que faça a leitura de uma imagem contendo uma placa de carro, e deve retornar uma string com o texto da placa
% 
% <<placacarro.pdf>>
% 
% chamada padrão
%   |str = placa2str(im,ths,w)|
%
% chamada com o display do step-by-step dos Threshold's
%   |str = placa2str(im,ths,w,'display')| 
%
% chamada informando que a imagem tem só o código da placa 
%   |str = placa2str(im,ths,w,'codigo')| 

%%
% variavais de comando
display = false;
cod = false;

% detecção dos comandos extras
if nargin > 3
    
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
            elseif isequal(comand{i},'codigo')
                
                cod = true;           
            else
                % Erro caso os comandos forem inválidos
                error('Invalid Input');
            end
        end
    end
end


%% Lendo a(s) imagem(s) do(s) template(s)
% Definindo o path do template letras
template_path = 'TempeMask\TemplateLetters.jpg';
LetrasTemplate = iread(template_path,'grey','double');
% Definindo o valor do Threshold
threshold_value = 0.2;
% Separando as letras do template letras
LetrasTemplate = DivideLetters(LetrasTemplate, threshold_value, 'template');



% Definindo o path do template numeros
template_path = 'TempeMask\TemplateNumbers.jpg';
NumerosTemplate = iread(template_path,'grey','double');
% Separando as letras do template numeros
NumerosTemplate= DivideLetters(NumerosTemplate, threshold_value, 'template');



%% Lendo a imagem da placa
% Defindo o path da imagem da placa
% "Favor não colocar a imagem da placa dentro da pasta de funções"

% definindo o valor do Threshold
threshold_value = ths;
% separando as letras da imagem
if ~display
    Buf_letras_placa = DivideLetters(im, threshold_value,'window', w,'alfanum',cod);
else
    [Buf_letras_placa disp_im] = DivideLetters(im, threshold_value,'window', w,'alfanum',cod);
    idisp(disp_im, 'nogui');
end
%%
% Combinado cada letra do template com cada letra da placa
for k = 1:length(Buf_letras_placa)
    letras_placa = Buf_letras_placa{k};
    match = [];
    if k == length(Buf_letras_placa)&& ~cod && length(letras_placa)==7 
        
        cod = true;
    end    
    for i = 1:length(letras_placa)
        
        if  i>3 && cod
            vec = zeros(26,1);
            for j = 1:length(NumerosTemplate{1})
                % redimencionando a letra da placa para ficar com o mesmo tamanho da
                % letra no template
                buf = imresize(letras_placa{i},size(NumerosTemplate{1}{j}));
%                 buf(buf > 0.5) = 1;
%                 buf(buf <= 0.5) = 0;
                % fazendo o zncc entre cada letra da placa com o template
                vec(j+26,:) = zncc(NumerosTemplate{1}{j},buf);
            end
        else
            for j = 1:length(LetrasTemplate{1})
                % redimencionando a letra da placa para ficar com o mesmo tamanho da
                % letra no template
                buf = imresize(letras_placa{i},size(LetrasTemplate{1}{j}));
%                 buf(buf > 0.5) = 1;
%                 buf(buf <= 0.5) = 0;
                % fazendo o zncc entre cada letra da placa com o template
                vec(j,:) = zncc(LetrasTemplate{1}{j},buf);
            end
            
            
        end
        % Separando o matching mais forte
        [val chara] = max(abs(vec));
        
        % Armazenado no vetor matching o valor do mathing e o index de cada
        % correspondência
        match(i,:) =  [val chara i];
        vec = [];
    end
    m{k} = match;
    
    
end

%%
% gerando string do resultado

% template das letras e numeros
Alfabeto_Numerico = ['ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'];

for k = 1:length(m)
    
    result = [];
    match = m{k};
    result = [];
    for i = 1:length(match(:,1))
        if match(i,1) > 0.1
            
            result = [result Alfabeto_Numerico(match(i,2))];
        else
            
            result = [result '_'];
            warning('wrong match \n i: %d \n match: %d ',i, match(i,1));
        end
    end
    if display        
        disp(result);       
    end
     str_cell{k} = result;
end
%% concatenando saída
str =[];
for i = 1:length(str_cell)
    
    str = [str, str_cell{i}, ' '];
end
end





