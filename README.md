# Panoramic Toolbox

![](https://github.com/Zeukio/visao_computacional/blob/master/Panoramic/html/Panoramic_Capa.png?raw=true)

A tollbox Panoramic adicona a função **Panoramic.m** e a função **Panoramic_Adjust.m** ao *path* padão do MATLAB. 
Esta ToolBox necessita da bibloteca gratuita [*robotics vision and control*](http://petercorke.com/wordpress/books/book), feita pelo Peter Corke. 

## Panoramic.m
**Panoramic.m** é uma função em MATLAB que se propõe a montar uma imagem panoramica apartir de um dataset de imagens. 
*obs: O dataset deve estar __ordenado__.* 

O exemplo a seguir servirá para explicar o funcionamento da função. 

### Exemplo
O panorama será feito com o seguinte dataset. Para isso deve-se fazer o download da pasta [Dataset4]() e da pasta [Panoramic]()
 
![full](https://github.com/Zeukio/visao_computacional/blob/master/Panoramic/html/Panoramic_01.png?raw=true)


Primeiramente a chamada da função:
```matlab
Dataset_path = 'C://.../.../Dataset4';
P1 = Panoramic(Dataset_path,'center');
```
Irá ser usado o comando extra 'center', pois para esse dataset o resultado fica melhor

