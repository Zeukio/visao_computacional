% limpando a mem�ria
clear all; close all; clc
% Input values for debug
path = strcat(pwd, '\Dataset_Placas');

im =  iread(path,'grey','double');
ths = 0.2;
w = ones(2); %tamanho da janela - ideia � de mudar o tipo

% str = placa2str(im,ths,w,'display');

str = placa_com_carro(im,ths);
