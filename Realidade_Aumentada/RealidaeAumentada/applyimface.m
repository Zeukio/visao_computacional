function [ mask ] = applyimface(Im1,Im2, pic)
% cola a im2 na face definida pelos pontos pic na imagem Im1
[Ue, Ve, ~] = size(Im2);
Bords = [0,0;Ve,0;Ve,Ue;0,Ue];

H = homography(Bords',pic');
imebra = homwarp(H,Im2);
imebra(isnan(imebra))= 0;
invebra = 1-imebra;
invebra(invebra<1) = 0;


mask = Im1.*invebra+imebra;


end

