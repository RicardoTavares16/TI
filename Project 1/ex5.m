function [ output_args ] = ex5( input_args )

%% Lena.bmp %%
img = imread('Dados_TP1/Lena.bmp');
hist5 = hist5IMG(img);
ent5 = entropia5(img, hist5);
fprintf('Entropia Conjunta "Lena.bmp":\n');
disp(ent5/2);

%% CT1.bmp %%

img = imread('Dados_TP1/CT1.bmp');
hist5 = hist5IMG(img);
ent5 = entropia5(img, hist5);
fprintf('Entropia Conjunta "CT1.bmp":\n');
disp(ent5/2);

%% Binária.bmp %%

img = imread('Dados_TP1/Binaria.bmp');
hist5 = hist5IMG(img);
ent5 = entropia5(img, hist5);
fprintf('Entropia Conjunta "Binaria.bmp":\n');
disp(ent5/2);

%% Texto.txt %%

T = fopen('Dados_TP1/Texto.txt');
S = fread(T);
hist5 = hist5TXT(S);
ent5 = entropia5(S, hist5);
fprintf('Entropia Conjunta "Texto.txt"\n');
disp(ent5/2);

%% Saxriff.wav %%

%Erro a calcular entropia agrupada, deixámos comentado para não interromper
%execucao da main
[Y, ~] = audioread('Dados_TP1/saxriff.wav');
info = audioinfo('Dados_TP1/saxriff.wav');
%hist5 = hist5SOM(Y, info.BitsPerSample);
%ent5 = entropia5(Y, hist5);
%fprintf('Entropia Conjunta "saxriff.wav"\n');
%disp(ent5/2);

end