function [ output_args ] = ex3( input_args )

%% Lena.bmp %%
disp('1 - Lena.bmp');
img = imread('Dados_TP1/Lena.bmp');

alf = linspace(0, 255, 256); %definir alfabeto, controlo directo
hist = histograma(img, alf); %calcula histograma
ent = entropia(img, alf); %calcula entropia

%Apresenta histograma
figure(1);
bar(alf, hist);
title('Histograma Lena.bmp');
xlabel('Símbolos do alfabeto');
ylabel('Nº Ocurrências');
xlim([0 256]);

%Calcula nº medio de bits (ex4)
[m,n] = size(img);
prob = hist/ (m*n);
nmb = sum(hufflen(hist).*prob);

%Imprime valores
fprintf('Entropia Lena.bmp:\n');
disp(ent);
fprintf('Nº médio de bits por simbolo:\n');
disp(nmb);

%% CT1.bmp %%
disp('2 - CT1.bmp');
img=imread('Dados_TP1/CT1.bmp');

alf = linspace(0, 255, 256);
hist = histograma(img, alf);
ent = entropia(img, alf);

%Apresenta histograma
figure(2);
bar(alf, hist);
title('Histograma CT1.bmp');
xlabel('Símbolos do alfabeto');
ylabel('Nº Ocurrências');
xlim([0 256]);

%Calcula nº medio de bits (ex4)
[m,n] = size(img);
prob = hist/ (m*n);
nmb = sum(hufflen(hist).*prob);

%Imprime valores
fprintf('Entropia CT1:\n');
disp(ent);
fprintf('Nº médio de bits por simbolo:\n');
disp(nmb);

%% Binária.bmp %%
disp('3 - Binaria.bmp');
img = imread('Dados_TP1/Binaria.bmp');
alf = 0:1:255;
hist = histograma(img, alf);
ent = entropia(img, alf);

%Apresenta histograma
figure(3);
%bar(alf, hist);
ocurr = histc(img, alf);
bar(ocurr);
title('Histograma Binaria.bmp');
xlabel('Símbolos do alfabeto');
ylabel('Nº Ocurrências');
xlim([-10 265]);

%Calcula nº medio de bits (ex4)
[m,n] = size(img);
prob = hist/ (m*n);
nmb = sum(hufflen(hist).*prob);

%Imprime valores
fprintf('Entropia Binaria:\n');
disp(ent);
fprintf('Nº médio de bits por simbolo:\n');
disp(nmb);

%% Saxriff.wav %%
disp('4 - Saxriff.wav');
[Y, ~] = audioread('Dados_TP1/saxriff.wav');
info = audioinfo('Dados_TP1/saxriff.wav');
d = 2/(2.^info.BitsPerSample);   %define o tam. dicionario
alf = (-1:d:1-d);   %cria o dicionario
hist = histograma(Y, alf);
ent = entropia(Y, alf);

%Apresenta histograma
figure(4);
bar(alf, hist);
title('Histograma Saxriff.wav');
xlabel('Símbolos do alfabeto');
ylabel('Nº Ocurrências');
xlim([-1.1 1.1]);

%Calcula nº medio de bits (ex4)
[m,n] = size(Y);
prob = hist/ (m*n);
nmb = sum(hufflen(hist).*prob);

%Imprime valores
fprintf('Entropia Saxriff:\n');
disp(ent);
fprintf('Nº médio de bits por simbolo:\n');
disp(nmb);

%% Texto.txt %%
disp('5 - Texto.txt');
T = fopen('Dados_TP1/Texto.txt');
alf = ['A':'Z','a':'z']; %define dicionario
S = fscanf(T, '%s');
hist = histograma(S, alf);
ent = entropia(S, alf);

%Apresenta histograma
figure(5);
bar(hist);
title('Histograma Texto.txt');
xlabel('Símbolos do alfabeto');
ylabel('Nº Ocurrências');
xlim ([0 63]);

%Calcula nº medio de bits (ex4)
[m,n] = size(S);
prob = hist/ (m*n);
nmb = sum(hufflen(hist).*prob);

%Imprime valores
fprintf('Entropia Texto:\n');
disp(ent);
fprintf('Nº médio de bits por simbolo:\n');
disp(nmb);

end