# Panoramic Toolbox

![](https://github.com/Zeukio/visao_computacional/blob/master/Panoramic/html/Panoramic_Capa.png?raw=true)

A toolbox Panoramic adiciona a função **Panoramic.m** e a função **Panoramic_Adjust.m** ao *path* padrão do MATLAB. 
Esta toolbox necessita da biblioteca gratuita [*robotics vision and control*](http://petercorke.com/wordpress/books/book), desenvolvida pelo Peter Corke. 

## Panoramic.m
**Panoramic.m** é uma função em MATLAB que se propõe a montar uma imagem panoramica a partir de um dataset de imagens. 

*OBS: O dataset deve estar __ordenado__ da esquerda para a direita.* 

O exemplo a seguir servirá para demonstrar como usar a função. 

### Exemplo
O panorama será feito com o seguinte data set 

*obs: é necessario estar com a ToolBox intalada ou com as funções Panoramic.m e Panoramic_Adjust.m no path do MATLAB*
 
![](https://github.com/Zeukio/visao_computacional/blob/master/Panoramic/html/Panoramic_014.png?raw=true)
 

Primeiramente será criada uma variavel string com o caminho do arquivo do data set
```matlab
Dataset_path = 'C://.../.../Your_Data_Set';
```
Depois deve-se chamar a função Panoramic
```matlab
P1 = Panoramic(Dataset_path);
```
Irá ser usado o comando extra 'center', pois para esse dataset o resultado fica melhor.
Agora para mostrar na tela a imagem final deve-se usar o comando

```matlab
idisp(P1);
```
 E deverá aparecer a algo paracido com a seguinte imagem
 
 ![](https://github.com/Zeukio/visao_computacional/blob/master/Panoramic/html/Panoramic_Uncenter.png?raw=true)

### Configurações extras

É possível alterar alguns paramêtros do código usando alguns comandos específicos 

- Tamanho lido da imagem 

```matlab
P1 = Panoramic(Dataset_path,'size',[960,1280]);
```
 
- Número de pontos de matches usados para fazer a homografia 

```matlab
P1 = Panoramic(Dataset_path,'matches',200);
```

- Valor do filtro de threshold usada na função de decição de pontos de matches para o cálculo da homografia. 

```matlab
P1 = Panoramic(Dataset_path,'num_threshold',.5);
```

- Esses comandos podem ser usados em conjunto

```matlab
P1 = Panoramic(Dataset_path, 'center', 'num_threshold', .5, 'matches', 200, 'size', [960,1280]);
```

- Centralização do panorama, como a imagem inícial desse arquivo.

```matlab
P1 = Panoramic(Dataset_path,'center');
```
