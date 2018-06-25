function projectcube(camparam,squareSize,Nframes,imimproject,varargin)
%% projectcube
% Esta função tem como objetivo plotar um cubo em cima do tabuleiro da
% imagem capturada pela camera.
%
% projectcube(Parametros de calibação da câmera,tamanho do quadrado do tabuleiro,quantidade de frames a ser processdo, celula contendo as imagens das faces mdo cubo)
%
% pode ser plotado o cubo rotacionado em teta graus
% 
% projectcube(... 'rotation', teta) 
%
%
% pode ser plotado uma animação do cubo rodando em teta graus por frame
% 
% projectcube(... 'animate', teta)
%
%
% pode ser plotado alterado a posição inicial  do cubo por um vetor de
% pontos, default [0 0 0] 
%
% projectcube(... 'initial', [x y z])
%
% pode ser alterado o tamanho do cubo, default 100
% 
% projectcube(... 'squaresize', valor)
%

cam = webcam;% abrindo a webcam;
%% default paramamiters
CR = eye(3);
squaresize = 100;
initialpos = [100 100 0];
animate = false;

%% 1ª snapshot
im = snapshot(cam);
im_2 = rgb2gray(im);
[im_2 ~] = undistortImage(im_2,camparam,'OutputView','full');

%% Alternative inputs
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
% caso tenha menos de 6 imagens
if length(imimproject)<6
    for i = length(imimproject):6
        imimproject{i} = imimproject{randi(length(imimproject),1,1)}
    end
end

% distorção do tamanho da imagem
for e = 1:length(imimproject)
    imimproject{e} = imresize(imimproject{e},size(im_2));
end

for idx = 1:Nframes
    
    % Acquire a single image.
    rgbImage = snapshot(cam);
    % Transfor to GreyScale
    im_2 = rgb2gray(rgbImage);
    % Transfor to Double
    im_1 = im2double(im_2);
    % Undistorting image
    [im,newOrigin] = undistortImage(im_1,camparam,'OutputView','full');
    
    % if thers no checker board the script do not stop running
    try
        % detectndo o tabuleiro
        [imagePoints,boardSize,imagesUsed] = detectCheckerboardPoints(im);
        % criando tabuleiro virtual 
        worldPoints = generateCheckerboardPoints(boardSize, squareSize);
        % redefinindo a origem do pontos 
        imagePoints = [imagePoints(:,1) + newOrigin(1),imagePoints(:,2) + newOrigin(2)];
        % criando as matrizes de rotação e translação
        [rotationMatrix, translationVector] = extrinsics(imagePoints,worldPoints,camparam);
        
        % definido matriz da camera
        H = cameraMatrix(camparam,rotationMatrix,translationVector);
        H = H';
        loc1 = -(rotationMatrix^-1*translationVector')
 
        % se for animado ele roda entorno do eixo Z
        if animate
            CR = rotz(teta0*idx);
        end
        
        % criando o cubo e retornando os pontos das faces do cubo
        [faces,order]=crazycube(H,loc1,squaresize,initialpos,CR);
        
        mask = im;
        
        % disp faces cubo
        for i = order
            mask =  applyimface(mask,imimproject{i}, faces{i});
        end
        imshow(mask);
        

        hold on;

        drawnow
        hold off
     catch
       
         imshow(im);
    end   
end

%% desligar camera no final;
clear cam

end

