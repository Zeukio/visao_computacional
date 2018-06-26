# Realidade Aumentada usando MATLAB

A *toolbox* de **RealidadeAumentada** adiciona as funções **projectcube** e a função **projectstl.m** ao *path* padrão do MATLAB, bem como algumas outras funções auxiliares. 
Esta toolbox necessita da biblioteca gratuita [*robotics vision and control*](http://petercorke.com/wordpress/books/book), desenvolvida pelo Peter Corke e da *toolbox* de visão computacional do MATLAB.

## Função *projectcube.m*
A ***projectcube.m*** é uma função em MATLAB que tem por objetivo ler uma imagem da *webcam* e projetar um cubo em um padrão xadrez. 

### Exemplo
As imagens a serem projetadas no cubo serão:

*obs: É necessário estar com a toolbox instalada ou com as funções da toolbox no path do MATLAB*
 <p float="left">
 <img src="https://github.com/Zeukio/visao_computacional/blob/master/Realidade_Aumentada/DatasetCubo/ebra.jpg?raw=true" width="200" height="200" />
 <img src="https://github.com/Zeukio/visao_computacional/blob/master/Realidade_Aumentada/DatasetCubo/ebra2.jpg?raw=true" width="200" height="200" />
 <img src="https://github.com/Zeukio/visao_computacional/blob/master/Realidade_Aumentada/DatasetCubo/ebra3.jpg?raw=true" width="200" height="200" />
</p>
 <p float="left">
 <img src="https://github.com/Zeukio/visao_computacional/blob/master/Realidade_Aumentada/DatasetCubo/ebra4.jpg?raw=true" width="200" height="200" />
 <img src="https://github.com/Zeukio/visao_computacional/blob/master/Realidade_Aumentada/DatasetCubo/ebra5.jpg?raw=true" width="200" height="200" />
 <img src="https://github.com/Zeukio/visao_computacional/blob/master/Realidade_Aumentada/DatasetCubo/ebra6.jpg?raw=true" width="200" height="200" />
 </p>
 
 **Observação**: As imagens padrão são mostradas acima, porém o usuário tem liberdade de escolher suas próprias imagens.
 
Primeiramente será realizada a calibração da câmera usando o APP de MATLAB **CameraCalibrator**, para isso é necessário imprimir o xadrez de calibração. O objeto da calibração deverá ser exportado para o *workspace*.
**Observação**: Mais informações de como fazer a calibração no link [https://mathworks.com/help/vision/ug/single-camera-calibrator-app.html](https://mathworks.com/help/vision/ug/single-camera-calibrator-app.html) 

Com a calibração realizada é necessário definir o tamanho dos quadrados do tabuleiro e a quantidade de *frames* que será processado na imagem: 

```matlab
squareSize = 23;
Nframes = 100;
```
Depois deve ser criada uma célula com todas as imagens desejadas, usando o comando *iread* da toolbox [*robotics vision and control*](http://petercorke.com/wordpress/books/book). **A imagem deve ser lida em escala de cinza e precisão dupla**.

```matlab
improject{1} = iread('DatasetCubo\ebra.jpg','double','grey');
improject{2} = iread('DatasetCubo\ebra2.jpg','double','grey');
improject{3} = iread('DatasetCubo\ebra3.jpg','double','grey');
improject{4} = iread('DatasetCubo\ebra4.jpg','double','grey');
improject{5} = iread('DatasetCubo\ebra5.jpg','double','grey');
improject{6} = iread('DatasetCubo\ebra6.jpg','double','grey');
```
Por fim deve ser chamada a função ***projectcube***.
```matlab
projectcube(camparam,squareSize,Nframes,improject)
```
Resultando em uma imagem como esta: 
![](https://github.com/Zeukio/visao_computacional/blob/master/Realidade_Aumentada/Resultados/ebra.png?raw=true)

A função possibilita usar vários comandos extras como  **animate**, que faz o cubo rotacionar entorno do eixo z. Esse e outros comandos extras podem ser visros no *help* da função. 

## Função *projectstl.m*
A ***projectstl.m*** é uma função em MATLAB que tem por objetivo fazer a mesma coisa da função ***projectcube***, porém ao invés de projetar um cubo, ele projeta os pontos de um arquivo STL.

### Exemplo
Assim com na ***projectcube*** é necessário fazer a calibração da câmera, definir o tamanho dos quadrados e definir a quantidade de frames a serem processados. 

A seguir deve-se declarar em uma *string*, o *path* do arquivo STL desejado:

```matlab
str = 'DatasetStl\tie_fighter.stl'
```
Por fim deve ser chamada a função ***projectstl***.
```matlab
projectstl(camparam,squareSize,Nframes,str);
```
Resultando em uma imagem como esta:
![](https://github.com/Zeukio/visao_computacional/blob/master/Realidade_Aumentada/Resultados/tie.png?raw=true)

Assim como a ***projectcube*** essa função também possui a possibilidade de entradas extras que podem ser vistas no *help* da função.
