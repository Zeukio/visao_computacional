% limpando a memória
clear all; close all; clc
% Input values for debug
path = strcat(pwd, '\Dataset_Placas');

im =  iread(path,'grey','double');
ths = 0.2;
w = ones(2); %tamanho da janela - ideia é de mudar o tipo

% str = placa2str(im,ths,w,'display');

str = placa_com_carro(im,ths);
