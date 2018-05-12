%% placa2str
%  
%  esse c�dogo tem como objetivo implementar uma fun��o que fa�a a leitura
%  de uma imagem contendo uma placa de carro, e deve retornar uma string
%  com o texto da placa
% 
% Para desenvolvimeto usaremos a vers�o script
%% limpando a mem�ria
clear all; close all ; clc

%% Header da fun��o 
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
letras_template = DivideLetters(template_path, threshold_value, 'template');

%% Lendo a imagem da placa
% Defindo o path da imagem da placa
% "Favor n�o colocar a imagem da placa dentro da pasta de fun��es"
placa_path = strcat(pwd, '\Dataset_Placas');
% definindo o valor do Threshold
threshold_value = 0.2;
% separando as letras da imagem
letras_placa = DivideLetters(placa_path, threshold_value, ones(2));

%% 
% Combinado cada letra do template com cada letra da placa
for i = 1:length(letras_placa)  
   for j = 1:length(letras_template)
        % redimencionando a letra da placa para ficar com o mesmo tamanho da
        % letra no template
        buf = imresize(letras_placa{i},size(letras_template{j}));
        % fazendo o zncc entre cada letra da placa com o template 
        vec(j,:) = [zncc(letras_template{j},buf)];
   end   
   % Separando o matching mais forte
   [val chara] = max(abs(vec));
   
   % Armazenado no vetor matching o valor do mathing e o index de cada
   % correspond�ncia
   match(i,:) =  [val chara i];
end    

%%
% display do resultado
Alfabeto_Numerico = ['ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890-'];
result = [];
for i = 1:length(match)
    if match(i,1) > 0.5
        result = [result Alfabeto_Numerico(match(i,2))];
    else
        warning('wrong match \n i: %d \n match: %d ',i, match(i,1));
    end    
end    

disp(result(1:2))
disp(result(3:end-7))

disp(result(end-6:end))



