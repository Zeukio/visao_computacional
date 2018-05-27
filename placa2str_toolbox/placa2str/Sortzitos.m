function vecfinal =  Sortzitos(sub_regioes,im_sub_box,varargin)

% Para manter a ordem das sub-imagens da esquerda pra direita usa-se a
% ordenação pela posição central de cada região.
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
                
                % Erro caso os comandos forem inválidos
                error('Invalid Input');
            end
        end
    end
end

if ~temp
    
    idxo = length(im_sub_box.('uc'));   
    p = im_sub_box.p;    
    % método de ordenação maluca (como os índices de uma matriz)
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
    
    [~,idx] = sort([im_sub_box.('uc')]);  
end

 %
     vecfinal = [];  
    for i = 1:length(idx)
        for j = 1:length(sub_regioes)
            if idx(i) == sub_regioes(j)
                vecfinal = [vecfinal sub_regioes(j)];
            end
        end
    end
end