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


%% lendo a(s) imagem(s) do(s) template(s)
% defindo o path do template
template_path = 'Template.jpg';
% definindo o valor do treshold
threshold_value =  0.2;
% separando as letras do template
letras_template = DivideLetters(template_path, threshold_value);
%% lendo a imagem da placa
% defindo o path da imagem da placa
% "favor n�o colocar a imagem da placa dentro da pasta de fun��es"
placa_path = 'C:\Users\steph\OneDrive\Documentos\GitHub\visao_computacional\placa2str_toolbox\Dataset_Placas\placa_carro2.jpg';
% definindo o valor do treshold
threshold_value =  0.5;
% separando as letras da imagem
letras_placa = DivideLetters(placa_path, threshold_value, ones(9));
%% 
% Combinado cada letra do template com cada letra da placa
for i = 1:length(letras_placa)  
   for j = 1:length(letras_template)
       
        % redimencionando a letra da placa para ficar com o mesmo tamnho da
        % letra no template
        buf = imresize(letras_placa{i},size(letras_template{j}));
        % fazendo o zncc entre cada letra da placa com o template 
        vec(j,:) = [zncc(letras_template{j},buf)];
   end   
   % separando o matching mais forte
   [val chara] = max(abs(vec));
   % armazenado no vetor matching o valor do mathing e o index de cada
   % correspond�ncia
   match(i,:) =  [val chara i];
end    

%%
% display do resultado
result = {};
for i = 1:length(match)
    if match(i,1) ~= 0
    result = [result letras_template(match(i,2))];
    else
        warning('wrong match')
    end    
end    
idisp(result)



