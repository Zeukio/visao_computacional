% limpando a mem�ria
clear all; close all; clc
% Input values for debug
path = strcat(pwd, '\Dataset_Placas2');

im =  iread(path,'grey','double');
ths = 0.4;
w = ones(2,3); %tamanho da janela - ideia � de mudar o tipo

% str = placa2str(im,ths,w,'display');

str = placa_com_carro(im,ths);
