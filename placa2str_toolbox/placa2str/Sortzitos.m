function idx_final =  Sortzitos(idx_vec,blobs_vec,varargin)
%% Sortzitos
%   |idx_final =  Sortzitos(idx_vec,blobs_vec,varargin)|
% Esta fun��o retorna os indices ordenados de acordo com suas posi��es
% Para isso:
% - idx_vec deve ser um vetor com os indices que ser�o ordenados
% - blobs_vec � o vetor completo de todos os blobs
%
%% Chamanda da fun��o
% se a ordena��o deve ser feita linha a linha (como a ordena��o dos indices de uma matriz)
%   |Sortzitos(idx_vec,blobs_vec)|
% 
% ou se a ordena��o deve ser feita s� considerando que � uma linha 
%   |Sortzitos(idx_vec,blobs_vec, 'template')|idx_final =  Sortzitos(idx_vec,blobs_vec,varargin)
%


temp = false;

if nargin > 2    
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
            if isequal(comand{i},'template')
                
                temp = true;
            else
                
                % Erro caso os comandos forem inv�lidos
                error('Invalid Input');
            end
        end
    end
end

if ~temp
    % m�todo de ordena��o como os �ndices de uma matriz 
    % [a11 a12 a13
    %  a21 22 a23]   
    idxo = length(blobs_vec.('uc'));   
    p = blobs_vec.p;     
    p = [[1:idxo]' p'];
    [~, idxX]= sort(p(:,2));
    pxo = p(idxX,:);
    [~, idxY] = sort(p(:,3));
    pyo = p(idxY,:);
    pori = [];
    porf = [];
    medy = mean(p(:,3));
    
    for i = 1:length(pxo)
        
        buf = pxo(i,:);
        
        if pxo(i,3) > medy
            
            porf = [porf;buf];
        else
            
            pori = [pori;buf];
        end
    end
    
    por = [pori;porf];    
    idx = por(:,1);  
    
else
    
    [~,idx] = sort([blobs_vec.('uc')]);  
end

%
    idx_final = [];  
    for i = 1:length(idx)
        for j = 1:length(idx_vec)
            if idx(i) == idx_vec(j)
                
                idx_final = [idx_final idx_vec(j)];
            end
        end
    end
end