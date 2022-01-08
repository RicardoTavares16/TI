function [] = ex6c()

[Y, ~] = audioread('Dados_TP1/saxriff.wav');
info = audioinfo('Dados_TP1/saxriff.wav');
d = 2/(2.^info.BitsPerSample);   
alf = (-1:d:1-d);
stepini = round(length(Y)/4);
query = Y;

%Para cada fich song, obter inf mutua com saxriff
maximo = zeros(1,7);
for i=1:7
    
    fich = strcat('Dados_TP1/Song0',num2str(i));
    fich = strcat(fich,'.wav');
    [Y, ~] = audioread(fich);
    target = Y;
    im = ex6a(query, target, alf, stepini);
    maximo(i) = max(im); %guardar em array cada inf mutua
    
end

fprintf('Informações Mútuas Máximas de "Song01.wav" a "Song07.wav": \n');
disp(maximo);
    
fprintf('Informações Mútuas Máximas ordenadas: \n');
disp(sort(maximo, 'descend'));

% [Target1, ~] = audioread('Dados_TP1/Song01.wav');       
% [Target2, ~] = audioread('Dados_TP1/Song02.wav');      
% [Target3, ~] = audioread('Dados_TP1/Song03.wav');       
% [Target4, ~] = audioread('Dados_TP1/Song04.wav');       
% [Target5, ~] = audioread('Dados_TP1/Song05.wav');      
% [Target6, ~] = audioread('Dados_TP1/Song06.wav');       
% [Target7, ~] = audioread('Dados_TP1/Song07.wav');       
% 
% Im1 = ex6a(query, Target1, alf, stepini);
% Im2 = ex6a(query, Target2, alf, stepini);
% Im3 = ex6a(query, Target3, alf, stepini);
% Im4 = ex6a(query, Target4, alf, stepini);
% Im5 = ex6a(query, Target5, alf, stepini);
% Im6 = ex6a(query, Target6, alf, stepini);
% Im7 = ex6a(query, Target7, alf, stepini);
% 
% maximo = zeros(1, 7);
% maximo(1) = max(Im1);
% maximo(2) = max(Im2);
% maximo(3) = max(Im3);
% maximo(4) = max(Im4);
% maximo(5) = max(Im5);
% maximo(6) = max(Im6);
% maximo(7) = max(Im7);
end

