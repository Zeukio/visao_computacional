%% placa2str
%
%  esse códogo tem como objetivo implementar uma função que faça a leitura
%  de uma imagem contendo uma placa de carro, e deve retornar uma string
%  com o texto da placa
%
% Para desenvolvimeto usaremos a versão script
%% limpando a memória
clear all; close all ; clc

%% Header da função
% function str = placa2str(im,varagin)
%
% Put here possibles extra input arguments
% - display
% -
% -
%
% Put here possibles extra output arguments
% -
% -
% -
%

display = true;


%% Lendo a(s) imagem(s) do(s) template(s)
% Definindo o path do template
template_path = 'Template.jpg';
% Definindo o valor do Threshold
threshold_value = 0.2;
% Separando as letras do template
LetraseNumerosTemplate = DivideLetters(template_path, threshold_value, 'template');

% Definindo o path do template2
template_path = 'TemplateLetters.jpg';
% Definindo o valor do Threshold
threshold_value = 0.2;
% Separando as letras do template2
LetrasTemplate = DivideLetters(template_path, threshold_value, 'template');



%% Lendo a imagem da placa
% Defindo o path da imagem da placa
% "Favor não colocar a imagem da placa dentro da pasta de funções"
placa_path = strcat(pwd, '\Dataset_Placas');
% definindo o valor do Threshold
threshold_value = 0.3;
% separando as letras da imagem
Buf_letras_placa = DivideLetters(placa_path, threshold_value, ones(2));

%%
% Combinado cada letra do template com cada letra da placa
for k = 1:length(Buf_letras_placa)
    letras_placa = Buf_letras_placa{k};
    match = [];
    for i = 1:length(letras_placa)
        if k == 1
            for j = 1:length(LetrasTemplate{1})                
                % redimencionando a letra da placa para ficar com o mesmo tamanho da
                % letra no template
                buf = imresize(letras_placa{i},size(LetrasTemplate{1}{j}));
                % fazendo o zncc entre cada letra da placa com o template
                vec(j,:) = [zncc(LetrasTemplate{1}{j},buf)];
            end
        else
            for j = 1:length(LetraseNumerosTemplate{1})
                % redimencionando a letra da placa para ficar com o mesmo tamanho da
                % letra no template
                buf = imresize(letras_placa{i},size(LetraseNumerosTemplate{1}{j}));
                % fazendo o zncc entre cada letra da placa com o template
                vec(j,:) = [zncc(LetraseNumerosTemplate{1}{j},buf)];
            end
        end
        % Separando o matching mais forte
        [val chara] = max(abs(vec));
        
        % Armazenado no vetor matching o valor do mathing e o index de cada
        % correspondência
        match(i,:) =  [val chara i];
    end
    m{k} = match;
    
    
end

%%
% display do resultado
Alfabeto_Numerico = ['ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890-'];
result = [];
for k = 1:length(m)
    match = m{k};
    result = [];
    for i = 1:length(match)
        if match(i,1) > 0.3
            result = [result Alfabeto_Numerico(match(i,2))];
        else
            warning('wrong match \n i: %d \n match: %d ',i, match(i,1));
        end
    end
    disp(result);
end





