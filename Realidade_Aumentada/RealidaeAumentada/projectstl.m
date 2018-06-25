function projectstl(camparam,squareSize,Nframes,stlfile,varargin)
% Esta função tem como objetivo plotar um os pontos de um arquivo stl em cima do tabuleiro da
% imagem capturada pela camera,
%
% projectstl(Parametros de calibação da câmera,tamanho do quadrado do tabuleiro,quantidade de frames a ser processdo, celula contendo as imagens das faces mdo cubo)
%
% pode ser plotado o objeto rotacionado em teta graus
% 
% projectstl(... 'rotation', teta) 
%
%
% pode ser plotado uma animação do objeto rodando em teta graus por frame
% 
% projectstl(... 'animate', teta)
%
%
% pode ser plotado alterado a posição inicial do objeto por um vetor de
% pontos, default [0 0 0] 
%
% projectstl(... 'initial', [x y z])
%
% pode ser alterado o tamanho do objeto, default 100
% 
% projectstl(... 'squaresize', valor)
%

cam = webcam;% -> abrindo a webcam;
CR = eye(3);
squaresize = 100;
initialpos = [100 100 0];
animate = false;

if nargin > 4
    
    if isa(varargin{1},'cell')
        
        comand = varargin{1};
        [~, buf] = size(varargin{1});
    else
        
        [~, buf] = size(varargin);
        for i = 1:buf
            
            comand{i} =  varargin{i};
        end
    end
    
    for i = 1 : buf
        if ischar(comand{i})
            if isequal(comand{i},'rotation')
                
                % se Size
                teta0 = comand{i+1};
                CR = rotz(teta0);
                i = i+1;
            
            elseif isequal(comand{i},'animate')
                
                % se Matches
                teta0 = comand{i+1};
                animate = true;
                i = i+1;
            elseif isequal(comand{i},'initial')
                
                % se Threshold
                initialpos = comand{i+1};
                i = i+1;
            elseif isequal(comand{i},'squaresize')
                
                squaresize = comand{i+1};
                
            else
                % Erro caso os comandos forem inválidos
                error('Invalid Input');
            end
        end
    end
end



%% imagens das faces do cubo

for idx = 1:Nframes
    
    % Acquire a single image.
    rgbImage = snapshot(cam);
    
    im_2 = rgb2gray(rgbImage);
    im_1 = im2double(im_2);
    [im,newOrigin] = undistortImage(im_1,camparam,'OutputView','full');
    
    %inicio da tentativa de leitura do xadrez
  try
        [imagePoints,boardSize,~] = detectCheckerboardPoints(im);        
        worldPoints = generateCheckerboardPoints(boardSize, squareSize);
        imagePoints = [imagePoints(:,1) + newOrigin(1),imagePoints(:,2) + newOrigin(2)];
        [rotationMatrix, translationVector] = extrinsics(imagePoints,worldPoints,camparam);
        
        if animate
         CR = rotz(teta0*idx);
        end
         H = cameraMatrix(camparam,rotationMatrix,translationVector);
             H = H';
       
        po = crazystl(stlfile,H,CR,initialpos)
       
        mask = im;
        

        imshow(mask);
        
        hold on;
        plot(po(:,1),po(:,2),'ro');
        drawnow
        hold off
     catch
%         
         imshow(im);
    end   
end

%% desligar camera no final;
clear cam

end

