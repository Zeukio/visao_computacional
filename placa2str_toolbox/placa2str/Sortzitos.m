function vecfinal =  Sortzitos(vec,temp)

vecfinal = [];

for i = 1:length(temp)
    for j = 1:length(vec)
        if temp(i) == vec(j)
            
            vecfinal = [vecfinal vec(j)];
        end
    end
end
end