function sub_im = DivideLetters(im_path, ths, varagin)
%DivideLetters:
%This function divide the first layer of childs from de image sent in 
%the path, using the threshold ths
% 
%   spread_letters(im_path, ths)
%   
%It's possible to aplay the iopen operation by sending the window as the
%tird paramiter
%  

    temp = false;
% Lendo imagem(s) do(s) template(s)
    im = iread(im_path,'grey','double');
    
    if strcmp(varagin, 'template') == 0
        mask = iread('mask.jpg', 'double', 'grey');
        mask(mask > 0.8) = 1;
        maskinv = 1 - mask;
        figure, idisp(maskinv);
        buf = imresize(mask, size(im));
        buf1 = imresize(maskinv, size(im));
        im = buf.*im;
        im = buf1+im;
    end
    
    figure, idisp(im);

% Aplicando o threshold no template
    im(im > ths) = 1;
    figure, idisp(im);

    if nargin > 2 
        if isnumeric(varagin) && ismatrix(varagin)
            % varagin =  Janela do iopen
            im = iopen(im, varagin);
%             im = ierode(idilate(im, ones(2)), ones(3));
            figure, idisp(im);
        elseif isequal(varagin,'template')
            temp = true;
        else
            warning('Erro, verifique os parâmetros da função');
        end
    end

% Separando cada caracter do template
    im_sub_box = iblobs(im);
 
% Descobrindo a maior área externa da imagem
    [~, i] = max(im_sub_box.area);

% Descobrindo as regiões filhas da area externa
    sub_regioes = im_sub_box(i).children;
    
    for i = 1:length(sub_regioes)

        if im_sub_box(sub_regioes(i)).area > 20
            sub_regioes1(i) = sub_regioes(i);
        end

    end

% Coloca o vetor de sub-regiões na ordem correta
    if ~temp
        sub_regioes = Sortzitos(sub_regioes1, im_sub_box);
    else
        sub_regioes = SortzitosTemp(sub_regioes1, im_sub_box);
    end

% Separa cada sub-imagem e as coloca em uma célula
    
    % Selecionando a sub-região correta
    p = im_sub_box(sub_regioes);
    
    p.plot_box;
    
    % Definindo o tamanho da região de corte
    bufrect = [p.umin',p.umax',p.vmin', p.vmax'];
    
    % Aplicando o corte
    for i = 1:length(bufrect)
        sub_im{i} = iroi(im,[bufrect(i,1:2);bufrect(i,3:4)]);
    end

end

