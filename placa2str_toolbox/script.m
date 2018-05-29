% limpando a memória
clear all; close all; clc
% Input values for debug
path = strcat(pwd, '\Placas_Carro_Inteiro');
% path = strcat(pwd, '\Dataset_Placas');

im =  iread(path,'grey','double');
ths = 0.4;
w = ones(2); %tamanho da janela - ideia é de mudar o tipo

%  str = placa2str(im,ths,w,'display');
otsuf = 1;

str = carro2str(im,ths, w,otsuf,'display');
