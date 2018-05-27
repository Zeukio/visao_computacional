function val = EstaDentro( box, point )
%ESTADENTRO Summary of this function goes here
%   Detailed explanation goes here
%% u
if point(1)>box(1,1) && point(1)<box(1,2)
    if point(2)>box(2,1) && point(2)<box(2,2)
        val = true;
        return;
    end    
end
val = false;

end

