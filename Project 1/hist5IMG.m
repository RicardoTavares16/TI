function nOcorrFinal = hist5IMG(P)
    
    nOcorr = zeros(256); %cria matriz 256x256 de 0's      
    dims_P= size(P);
    
    for l = 1:1:dims_P(1)         %percorrer as linhas
        for c = 1:2:dims_P(2)     %percorrer as colunas
            nOcorr(P(l,c)+1, P(l,c+1)+1) = nOcorr(P(l,c)+1, P(l,c+1)+1) + 1;
        end
    end
    
    nOcorrFinal = reshape(nOcorr', 1, []);

end