function [Panoramic] = adjust(im)

    d = im(:,:,1) >= 1 & im(:,:,2) >= 1 & im(:,:,3) >= 1;
    
    for i = 1:3
    
        imtemp{1} = im(:,:,i);
        imtemp{1}(d) = 0;
        Panoramic(:,:,i) = imtemp{1};
       
    end


end