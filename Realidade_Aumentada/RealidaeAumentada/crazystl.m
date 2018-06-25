function [ projected ] = crazystl( str,H,R,inic  )
%% crazystl
% Esta função tem como objetivo abrir o arquivo STL e retornar os pontos ja
% transformados para o plano da imagem.
%
% [ Pontos projetados ] = crazystl( Path do arquivo stl, Matriz da câmera, Posição inicial, Matriz de rotação) 
%
%
   [f v] = stlread(str);
   if length(inic) == 2
       ini = [inic 0];
   else
       ini = inic;
   end
   v = R*v';
   for i = 1:length(v);
       v(:,i) = v(:,i)+inic';
   end    
  [projected, valid] = projectPoints(v', H, [], [],[2 2],[]);
end

