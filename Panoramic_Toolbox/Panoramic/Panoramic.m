

function Im_panoramic = Panoramic( path, varargin )
%% PANORAMIC
% Panoramic esta fun��o retorna a uma imagem panoramica formada pelas
% imagens do dataset que est�o na pasta do _path_.
%
% *As Imagens devem estar em sequncia para que a fun��o funcione corretamente*
%
% |Im = Panoramic( path )|
%
% onde
% |Im  = imagem|
% |path = string do diret�rio do data set|
%
% pode se alterar o tamanho processado da imagem usando:
%
% |Im = Panoramic( path, 'size', [U V])|
%
% Default [480 640]
%
% pode se mostrar parte do processamento na tela usando:
%
% |Im = Panoramic( path, 'display')|
%
% Default false
%
% Mudar o numero de matches:
%
% |Im = Panoramic( path, 'matches', num_matches)|
%
% Default 300
%
% Mudar o par�metro do filtro threshold usado na para criar a matriz de homografia
%
% |Im = Panoramic( path, 'threshold', num_threshold)|
%
% Default 0.3
%
% Centralizar o panorama 
%
% |Im = Panoramic( path, 'center')|
%
% Default false
%
% Tamb�m pode se usar mais de um comando (*n�o importa a ordem*);
%
% |Im = Panoramic( path,'display','size', size_vec,'threshold', num_threshold, 'matches', num_maches)|
%


%%
% Valores default
num_threshold = 0.5;
num_matches = 300;
imreadsize = [480 640];
dispim = false;
center = false; 

%%
% Novos valores
comand = {};

%%
% Manipular as diferentes possiveis entradas da fun��o
if nargin > 1
    
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
            if isequal(comand{i},'display')
                
                %se display
                dispim = true;
            elseif isequal(comand{i},'size')
                
                % se Size
                imreadsize = comand{i+1};
                i = i+1;
            elseif isequal(comand{i},'matches')
                
                % se Matches
                num_matches = comand{i+1};
                i = i+1;
            elseif isequal(comand{i},'threshold')
                
                % se Threshold
                num_threshold = comand{i+1};
                i = i+1;
            elseif isequal(comand{i},'center')
                
                % se Center
                center = true;
            else
                % Erro caso os comandos forem inv�lidos
                error('Invalid Input');
            end
        end
    end
end

%% 
% Verifica��o do Caminho
try
    
    buildingScene = imageSet(path);
    if dispim
        
        disp('reading images')
        montage(buildingScene.ImageLocation);
    end
    
catch ME
    
    disp('Wrong path');
    rethrow(ME)
end

%%
% Leitura da Imagem 1 do Data set

I{1} = imresize(iread(buildingScene.ImageLocation{1}, 'double'), imreadsize);
% Busca das features de superf�cie da imagem 1
Sf = isurf(I);
% Matriz de homografia da imagem 1 � identidade j� que ela n�o sera distorcida
H{1} = eye(3);
% Matriz de homografia acumulada inicial
tforms{1} = eye(3);
% Imagem 1 distorcida ser� igual a imagem 1 sem a distor��o, visto que ela
% sera a base para todas as outras
newim{1} = I{1};
% Pontos de offset da imagem 1 na figura final
points{1} = [0 0];

%%
% Procura de features e a rela��o entre as imagens
if dispim
    
    disp('finding features and matches');
end

for i = 2:buildingScene.Count
    
    % Atualiza as variaveis para o proximo loop
    Iant = I{i-1};
    Sfant = Sf{i-1};
    % Abrir Imagem n
    I{i} = imresize(iread(buildingScene.ImageLocation{i}, 'double'),imreadsize);
    % Procurar fetures na Imagem n
    Sf{i} = isurf(I{i});
    % Faz o match entre as features da imagem anterior, e a atual -> I(n)
    m{i} = Sf{i}.match(Sfant, 'top', num_matches);
    % Calcula a matriz de homografia etre os pontos das duas imagens
    [H{i} val{i} val2{i}] = ransac(@homography,[m{i}.xy_], num_threshold, 'maxTrials', 25000);
end

%%

if center
    
    %imagem central
    nuim = buildingScene.Count/2;
    if nuim ~= round(nuim)
        
        nuim = round(nuim);
    end
    
    % Arrumando a ordem das matrizes de homografia
    H(1:nuim-1) = H(2:nuim);
    H{nuim} = eye(3);    
    newim{nuim} = I{nuim};
    tforms{nuim} = eye(3);
    
    % Calculo da matriz de homografia acumulada pra esquerda
    for i = nuim:-1:2
        
        tforms{i-1} = H{i-1}^-1*tforms{i};
    end   
    
    % Calculo da matriz de homografia acumulada pra direita
    for i =  nuim+1:buildingScene.Count
        
        tforms{i} = tforms{i-1}*H{i};
    end 
else
    
    for i = 2:buildingScene.Count
        
        % Atualiza a Matriz de homografia acumulada
        tforms{i} = tforms{i-1} * H{i};        
    end
end

% Transformando as imagens
for i = 1:buildingScene.Count
    % Faz a homografia da imagem I(n) -> newim(n)
    [bufim points{i}] = homwarp(tforms{i},I{i},'full');
    % Tira o NaN das imagens distorcidas
    bufim(isnan(bufim)) = 0;
    newim{i} = bufim;
end

if  dispim
    
    % Display das imagens finais
    figure, idisp(newim);
end
%%
% Setando o Tamanho da imagem final

% Calcula o tamanho da imagem inserida no alogoritmo
[u1,v1,~] = size(I{end});
% Retorna o tamanho de todas as novas imagens, ap�s realizada a homografia 
[y,x,~] = cellfun(@size, newim);
% Retorna os pontos calculados na fun��o homwarp, em forma de vetores
temp = cell2mat(points);

% Definir o ponto inicial do panorama
if center
    
    % Caso a imagem do centro seja a refer�ncia para as homografias, sua
    % posi��o em X � ser� a soma das larguras das imagens j� rotacionadas
    % subtra�do dos pontos de intersec��o entre as imagens dividos por 2,
    % j� que se deseja que a imagem de centro fique no centro. J� Y ser� o
    % tamanho em Y da maior imagem ap�s a homografia subtraido
    % do tamanho da imagem inserida;
    off = [ (sum(x - temp(1:2:end))/2) - v1/2, (max(y) - u1)];
    
    % O tamanho do panorama em X ser� igual ao offset para quando a imagem
    % do centro for a refer�ncia por�m n�o divido por 2, pois s� queremos a
    % largura m�xima do panorama. Y ser� a soma do maior Y p�s
    % homografia com o offset em Y;
    Panoramic1 = zeros( 2*max(y) - u1, sum(x - temp(1:2:end)) );
else
    
    % Caso a primeira imagem seja a refer�ncia para as homografias, sua
    % posi��o em X � 1, ou seja na lateral esquerda do panorama. J� Y ser�
    % o mesmo do caso anterior;
    off = [1, (max(y) - u1) + 500];
    
    % O tamanho do panorama em X ser� igual ao offset para quando a imagem
    % do centro for a refer�ncia por�m n�o divido por 2, pois s� queremos a
    % largura m�xima do panorama.  Y ser� a soma do maior Y p�s
    % homografia com o offset em Y;
    Panoramic1 = zeros( 2*max(y) - u1 , sum(x - temp(1:2:end)) );
end
%%
% Montagem do panorana

for i = 1:buildingScene.Count
    
    % Calcula a m�scara de todas as imagens com a homografia
    mask{i} = homwarp(tforms{i},ones(u1, v1),'full');
    % Transforma os NaN em 0;
    mask{i} = mask{i} >= 1;
    mask{i} = 1.2.*mask{i};
end

for i = 2:buildingScene.Count
    
    % Cola a imagem i no Panorama com o devido offset;
    Panoramic1 = ipaste(Panoramic1, newim{i}, points{i}+off, 'add');
    % Cola a m�scara da imagem i-1, pois vai deixar o espa�o para colar;
    Panoramic1 = ipaste(Panoramic1, mask{i-1}, points{i-1}+off, 'add');
    % Esta fun��o pega os pontos brancos da imagem e transforma em 0 para
    % poder usar o add;
    Panoramic1 = Panoramic_Adjust(Panoramic1);
    % Cola a imagem i-1
    Panoramic1 = ipaste(Panoramic1, newim{i-1}, points{i-1}+off, 'add');
end

if dispim
    
    figure, idisp(Panoramic1);
    
end

Im_panoramic = Panoramic1;



end

