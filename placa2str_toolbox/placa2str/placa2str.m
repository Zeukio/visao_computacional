%% placa2str
%
%  esse códogo tem como objetivo implementar uma função que faça a leitura
%  de uma imagem contendo uma placa de carro, e deve retornar uma string
%  com o texto da placa
%
% Para desenvolvimeto usaremos a versão script

%% Modificar essa seção quando mudar para função
% limpando a memória
clear all; close all ; clc
% Input values for debug
path = strcat(pwd, '\Dataset_Placas');
ths = 0.2;
w = ones(2); %tamanho da janela - ídeia é de mudar o tipo
display = false;

%% Header da função
% function str = placa2str(path,ths,w)
%
% Put here possibles extra input arguments
% - display
% - ths
% - w 
%
% Put here possibles extra output arguments
% - valor dos mathes
% - imagem com a plicação dos tresholds
% -
%




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



% Definindo o path do template3
template_path = 'TemplateNumbers.jpg';
% Definindo o valor do Threshold
threshold_value = 0.2;
% Separando as letras do template3
NumerosTemplate = DivideLetters(template_path, threshold_value, 'template');



%% Lendo a imagem da placa
% Defindo o path da imagem da placa
% "Favor não colocar a imagem da placa dentro da pasta de funções"
placa_path = path;
% definindo o valor do Threshold
threshold_value = ths;
% separando as letras da imagem
Buf_letras_placa = DivideLetters(placa_path, threshold_value, w);

%%
% Combinado cada letra do template com cada letra da placa
for k = 1:length(Buf_letras_placa)
    letras_placa = Buf_letras_placa{k};
    match = [];
    for i = 1:length(letras_placa)
        
        if k == 2 && i>3;
            vec = [zeros(26,1)];
            for j = 1:length(NumerosTemplate{1})
                % redimencionando a letra da placa para ficar com o mesmo tamanho da
                % letra no template
                buf = imresize(letras_placa{i},size(NumerosTemplate{1}{j}));
                buf(buf > 0.1) = 1;
                % fazendo o zncc entre cada letra da placa com o template
                vec(j+26,:) = [zncc(NumerosTemplate{1}{j},buf)];
            end    
        else          
            for j = 1:length(LetrasTemplate{1})                
                % redimencionando a letra da placa para ficar com o mesmo tamanho da
                % letra no template                
                buf = imresize(letras_placa{i},size(LetrasTemplate{1}{j}));
                buf(buf > 0.1) = 1;
                % fazendo o zncc entre cada letra da placa com o template
                vec(j,:) = [zncc(LetrasTemplate{1}{j},buf)];
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
Alfabeto_Numerico = ['ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'];

for k = 1:length(m)
    result = [];
    match = m{k};
    result = [];
    for i = 1:length(match)
        if match(i,1) > 0.1
            result = [result Alfabeto_Numerico(match(i,2))];
        else
            result = [result '_'];
            warning('wrong match \n i: %d \n match: %d ',i, match(i,1));
        end
    end
    disp(result);
    str{k} = result;
end
% end





