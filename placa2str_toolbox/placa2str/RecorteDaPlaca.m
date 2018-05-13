function s_im = RecorteDaPlaca(im, str)
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


%figure, idisp(maskinv);
buf = imresize(mask, size(im));
% buf = iopen(buf,ones(20));
buf(buf > 0.8) = 1;
buf(buf ~= 1) = 0;


buf1 = 1 - buf;

 a = iblobs(buf1);
 box_a = [(a.umax' - a.umin').*(a.vmax'- a.vmin')];
 [~, i] = max(box_a);
 idx =   a(i).children; 
 p = a(idx);
 

bufrect = [p.umin',p.umax',p.vmin', p.vmax'];
for i = 1:length(p)
    s_im{i} = iroi(im,[bufrect(i,1:2);bufrect(i,3:4)]);
end

end

