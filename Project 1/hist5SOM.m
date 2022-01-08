function nOcorrFinal = hist5SOM(P, nbits)
  
    temp = 2/(2.^nbits);   %define o tam. dicionario
    dic = (-1:temp:1-temp);   %cria o dicionario
    
    nOcorr = zeros(length(dic.^2));      
    dims_P = size(P);
    
    for c = 1:1:dims_P(2)         %percorrer as colunas
        for l = 1:2:dims_P(1)     %percorrer as linhas
            l_t = find(dic==P(l,c), 1);
            c_t = find(dic==P(l+1,c),1);
            nOcorr(l_t,c_t) = nOcorr(l_t,c_t) + 1;
        end
    end
    
    nOcorrFinal = reshape(nOcorr', 1, []);

end