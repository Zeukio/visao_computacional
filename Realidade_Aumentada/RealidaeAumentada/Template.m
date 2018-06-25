
load ('ParamCamera\campramiters.mat')
squareSize = 23;
Nframes = 100;
%% exemplo STL
projectstl(camparam,squareSize,Nframes,'DatasetStl\tie_fighter.stl','animate',15);

%% exemplo Cubo
improject{1} = iread('DatasetCubo\ebra.jpg','double','grey');
improject{2} = iread('DatasetCubo\ebra2.jpg','double','grey');
improject{3} = iread('DatasetCubo\ebra3.jpg','double','grey');
improject{4} = iread('DatasetCubo\ebra4.jpg','double','grey');
improject{5} = iread('DatasetCubo\ebra5.jpg','double','grey');
improject{6} = iread('DatasetCubo\ebra6.jpg','double','grey');
projectcube(camparam,squareSize,Nframes,improject,'animate',15)

