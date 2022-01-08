function nOcorrFinal=hist5TXT(P)
    %P - fonte de informação
    
    temp=['a':'z' 'A':'Z'];
    
    nOcorr = zeros(length(temp));
    dims_P = size(P);
    
    for l=1:2:(dims_P(1)*dims_P(2))-1       
        l_t=find(temp==P(l));
        c_t=find(temp==P(l+1));
        nOcorr(l_t,c_t) = nOcorr(l_t,c_t) + 1;
    end
    
    nOcorrFinal = reshape(nOcorr', 1, []);

end