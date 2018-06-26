# Realidade Aumentada usando MATLAB

A toolbox **RealidadeAumentada** adiciona as funções **projectcube** e a função **projectstl.m** ao *path* padrão do MATLAB, bem como algumas outras funções auxiliares. 
Esta toolbox necessita da biblioteca gratuita [*robotics vision and control*](http://petercorke.com/wordpress/books/book), desenvolvida pelo Peter Corke e a toolbox de visão computacional do MATLAB

## *projectcube.m*
***projectcube.m*** é uma função em MATLAB que se propõe a ler uma imagem da webcam e projetar um cubo em um padrão xadrez. 

### Exemplo
As imagens a serem projetadas no cubo serão.

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
Primeiramente será feita a calibração da camera usando o APP de MATLAB **CameraCalibrator** , para isso é necessário imprimir o xadrez de calibração e deverá ser exportado o objeto da calibração para o workspace.
*obs: Mais informações de como fazer a calibração no link [https://mathworks.com/help/vision/ug/single-camera-calibrator-app.html](https://mathworks.com/help/vision/ug/single-camera-calibrator-app.html)*

com a calibração feita é necessário definir o tamnho dos quadrados do tabuleio 
e a quantidade de frames que será processado na imagem 

```matlab
squareSize = 23;
Nframes = 100;
```
Depois devera ser criada uma celula com todas as imagens desejada, usando o comando *iread* da toolbox [*robotics vision and control*](http://petercorke.com/wordpress/books/book), a imagem dever ser lida em escala de cinza e precisão dupla.

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
Sendo assim a saida do programa deve ser algo assim
![](https://github.com/Zeukio/visao_computacional/blob/master/Realidade_Aumentada/Resultados/ebra.png?raw=true)

A função possibilita usar vários comandos extras como  'animate', faz o cubo rodar entorno do eixo z. Esse e outros comandos extras podem ser visros no help da função 

## *projectstl.m*
***projectstl.m*** é uma função em MATLAB que se propõe a fazer a mesma coisa da função ***projectcube***, porem ao inves de projetar um cubo ele projeta os pontos de um arquivo stl

### Exemplo
Assim com na ***projectcube*** é necessário fazer a calibração da câmera, definir o tamnho dos quadrados e definir a quantidade de frames a serem processados 

Aseguir deve-se declarar em uma string o path do arquivo stl desejado

```matlab
str = 'DatasetStl\tie_fighter.stl'
```
Por fim deve ser chamada a função ***projectstl***.
```matlab
projectstl(camparam,squareSize,Nframes,str);
```
A saida deve ser algo assim
![](https://github.com/Zeukio/visao_computacional/blob/master/Realidade_Aumentada/Resultados/tie.png?raw=true)

Assim como a ***projectcube*** essa função também posui a possibilidade de entradas extras que podem ser vistas no help da função.
