# Placa2Str_toolbox

A toolbox  Placa2Str_toolbox adiciona as funções **placa2str.m** e a função **carro2str.m** ao *path* padrão do MATLAB, bem como algumas outras funções auxiliares e algumas imagens de template. 
Esta toolbox necessita da biblioteca gratuita [*robotics vision and control*](http://petercorke.com/wordpress/books/book), desenvolvida pelo Peter Corke. 

## *carro2str.m*
***carro2str.m*** é uma função em MATLAB que se propõe a identificar os caracteres de uma placa de um carro, partindo de uma **imagem contendo objetos além da placa** e alguns outros paramêtros de entrada.
No exmplo será mostrado como
### Exemplo
A identificação da placa será feito com a seguinte imagem

*obs: é necessario estar com a ToolBox intalada ou com as funções da toolbox no path do MATLAB*
 
![](https://github.com/Zeukio/visao_computacional/blob/master/placa2str_toolbox/Placas_Carro_Inteiro/placa13.jpg?raw=true)

Primeiramente será criada uma variavel com a imagem desejada, usando o comando iread da toolbox [*robotics vision and control*](http://petercorke.com/wordpress/books/book), a imagem dever ser lida em escala de cinza e precisão dupla.

```matlab
im = iread('.../Your_Data_Image','grey','double');
```
Depois deve-se escolher os valores dos pârametros de entrada
```matlab
th = 0.4;
w = ones(3);
otsuf = 1;
```
por fim deve ser chamada a função ***carro2str***.
```matlab
carro2str(im,ths,w,otsuf)
```
Sendo assim a saida do programa deve ser algo assim
```matlab
'SCBLUMENAU QIA3345'
```
A função possibilita usar um comando extra o display, que mostra o passo a passo da função. 

## *placa2str.m*
***placa2str.m*** é uma função em MATLAB que se propõe a identificar os caracteres de uma placa de um carro, partindo de alguns paramêtros de entrada e de uma **imagem contendo somente a placa do carro**.
No exmplo será mostrado como
### Exemplo
A identificação da placa será feito com a seguinte imagem

*obs: é necessario estar com a ToolBox intalada ou com as funções da toolbox no path do MATLAB*
 
![](https://github.com/Zeukio/visao_computacional/blob/master/placa2str_toolbox/Resultados/sub_im.png?raw=true)

Primeiramente será criada uma variavel com a imagem desejada, usando o comando iread da toolbox [*robotics vision and control*](http://petercorke.com/wordpress/books/book), a imagem dever ser lida em escala de cinza e precisão dupla.

```matlab
im = iread('.../Your_Data_Image','grey','double');
```
Depois deve-se escolher os valores dos pârametros de entrada
```matlab
th = 0.4;
w = ones(3);
```
por fim deve ser chamada a função ***carro2str***.
```matlab
placa2str(im,ths,w)
```
Sendo assim a saida do programa deve ser algo assim
```matlab
'SCBLUMENAU QIA3345'
```
A função possibilita usar um comando extra o display, que mostra o passo a passo da função. 
```matlab
placa2str(im,ths,w,'display')
```
A imagem do passo a passo é algo assim

![](https://github.com/Zeukio/visao_computacional/blob/master/placa2str_toolbox/Resultados/placacarro.jpg?raw=true)
