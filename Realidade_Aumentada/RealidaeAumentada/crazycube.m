function [faces, order] = crazycube(H, loc1,lado, inic,R)
%% crazycube
% Esta função tem como objetivo criar os pontos de um cubo e aplicar a
% transformação para o plano da imgem, aplicando também parametros de
% localisação inicial e rotação
%
% [faces, order] = crazycube(Matriz da camera, Localisação da camera, Tamanho do lado do cubo, Posição inicial, Matriz de rotação)
%
% retorna um vetor de com os pontos das faces e a ordem na qual eles devem
% ser imprimidos 
%
%
 

 l_ = lado/2;
 if length(inic) == 2
 ini = [inic 0]+l_;
 else
  ini = inic+l_;   
 end
 
 x = [];
 y = [];
 
 ph = [];
 cf = [];
 for i = -1:1:1
     for j = -1:1:1
         for k = -1:1:1
              poin_o = [i*l_, j*l_, -k*l_];
              poin_o = R*poin_o';
              poin_d = poin_o+inic';
              poin = [poin_d;1];
              p  = H*poin ; 
             
             if k==0 || j==0 || i==0
                if (k==0 && j==0 && i ~=0)|| (i==0 && j==0 && k ~=0)||(k==0 && i==0 && j ~=0)   
                  cf = [cf; poin_d' ];% face center
                elseif  k==0 && j==0 && i==0
                    center  = poin_o ;   % cube center
                end                 
             else   
             ph = [ph ; poin_d']  ;   
             x = [x p(1)/p(3)];
             y = [y p(2)/p(3)];            
             end
         end
     end     
 end
 

 
 
p = [x' y'];


 faces{1} = [p(2,:);p(4,:);p(3,:);p(1,:)];
 faces{2} = [p(6,:);p(2,:);p(1,:);p(5,:)]; 
 faces{3} = [p(1,:);p(3,:);p(7,:);p(5,:)];
 faces{4} = [p(2,:);p(4,:);p(8,:);p(6,:)]; 
 faces{5} = [p(4,:);p(8,:);p(7,:);p(3,:)];
 faces{6} = [p(8,:);p(6,:);p(5,:);p(7,:)];
 center = center+inic';
 center = [center;1];
 center  = H*center ;
 
 loc = [loc1;1];
 loc = H*loc ;
 [~, order,ncor] = orderfaces( loc , cf, center',ph,inic );
 
 end


