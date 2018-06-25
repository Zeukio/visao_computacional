function Im_e  = imresizergb( Im1, Im_mod )
% imresize para imagens RGB
%






Im_e(:,:,1) = imresize(Im1(:,:,1),size(Im_mod(:,:,1)));
Im_e(:,:,2) = imresize(Im1(:,:,2),size(Im_mod(:,:,1)));
Im_e(:,:,3) = imresize(Im1(:,:,3),size(Im_mod(:,:,1)));
end

