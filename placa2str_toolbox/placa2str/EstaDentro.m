function val = EstaDentro(box, point)
%EstaDentro 
%
% |val = EstaDentro(box, point)|
%
% Essa função analiza se os pontos passados estão dentro da box
% retorna um booleano se verdade;
%% 
if point(1)>box(1,1) && point(1)<box(1,2)
    if point(2)>box(2,1) && point(2)<box(2,2)
        val = true;
        return;
    end    
end
val = false;

end

