%% Trabalho Prático 1 - TI %%

% João Moreira - 2015230374
% Pedro Gonçalves - 2013150557
% Ricardo Tavares - 2014230130

%% Ex 1,2,3,4
disp('Ex 1, 2, 3 e 4:');

ex3

fprintf('Premir para continuar');
pause;
clc;

%% Ex 5
disp('Ex 5:');

ex5

fprintf('Premir para continuar');
pause;
clc;
%% Ex 6 a)
disp('Ex 6a:');

query = [2 6 4 10 5 9 5 8 0 8];
target = [6 8 9 7 2 4 9 9 4 9 1 4 8 0 1 2 2 6 3 2 0 7 4 9 5 4 8 5 2 7 8 0 7 4 8 5 7 4 3 2 2 7 3 5 2 7 4 9 9 6];
alfabeto = 0 : 10; 
step = 1;

InfoMutua = ex6a(query, target, alfabeto, step); 
disp(InfoMutua);

fprintf('Premir para continuar');
pause;
clc;
%% Ex 6 b)
disp('Ex 6b:');

%Query -> Saxriff.wav
[Y, fs] = audioread('Dados_TP1/saxriff.wav');
info = audioinfo('Dados_TP1/saxriff.wav');
d = 2/(2.^info.BitsPerSample);   
alf = (-1:d:1-d);   

query = Y;

%Target1 -> Saxriff a repetir 3x
[Y, fs] = audioread('Dados_TP1/target01 - repeat.wav');
target1 = Y;

%Target2 -> Saxriff a repetir 3x com a 1ª e ultima c/ruido
[Y, fs] = audioread('Dados_TP1/target02 - repeatNoise.wav');
target2 = Y;

%step = 1/4 valor query
stepini = round(length(query) / 4);

b1 = ex6a(query, target1, alf, stepini);
b2 = ex6a(query, target2, alf, stepini);

%Apresentar Gráficos
figure(6);
plot(1:length(b1),b1);
xlabel('Janelas');
ylabel('Informação Mutua');
title('Informação Mutua entre "saxriff.wav" e "target01 - repeat.wav"');

figure(7);
plot(1:length(b2),b2);
xlabel('Janelas');
ylabel('Informação Mutua');
title('Informação Mutua entre "saxriff.wav" e "target02 - repeatNoise.wav"');

fprintf('Premir para continuar');
pause;
clc;

%% Ex 6 c)
disp('Ex 6c:');

ex6c;

fprintf('Premir para continuar');
pause;
clc;
