function im = RecorteDaPlaca(im, str)
%RECORTEDAPLACA Summary of this function goes here
%   Detailed explanation goes here

if isequal(str,'carro')
    
    temp = 'MaskCarro.jpg';    
elseif isequal(str,'moto')
    
     temp = 'MaskMoto.jpg';
else 
    
    error('%s non evaluated command', str);    
end    

mask = iread(temp, 'double', 'grey');

mask(mask > 0.8) = 1;
maskinv = 1 - mask;
%figure, idisp(maskinv);
buf = imresize(mask, size(im));
buf1 = imresize(maskinv, size(im));
im = buf.*im;
im = buf1+im;

end

