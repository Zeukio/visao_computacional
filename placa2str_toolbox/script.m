
% limpando a memória
clear all; close all; clc
% Input values for debug
%%

path = strcat(pwd, '\Dataset_Placas');
im =  iread(path,'grey','double');
ths = 0.2;
w = ones(2);
str = placa2str(im,ths,w,'display');

%%

path = strcat(pwd, '\Dataset_Placas');
im =  iread(path,'grey','double');
ths = 0.2;
w = ones(2,3);
str = placa2str(im,ths,w,'display');

%%

path = strcat(pwd, '\Placas_Carro_Inteiro');
im =  iread(path,'grey','double');
ths = 0.4;
w = ones(2); %tamanho da janela - ideia é de mudar o tipo
otsuf = 1;
str = carro2str(im,ths, w,otsuf,'display');

%%

path = strcat(pwd, '\Placas_Carro_Inteiro');
im =  iread(path,'grey','double');
ths = 0.3;
w = ones(2); %tamanho da janela - ideia é de mudar o tipo
otsuf = 1;
str = carro2str(im,ths, w,otsuf,'display');
