function [ ent ] = entropia5( P, hist )
    
    nOcorr = hist;
    
    probs = zeros(1, length(hist));
    
    s=size(P);
    length_P=s(1)*(s(2)/2);
    
    for i=1:length(nOcorr)
        probs(i)=nOcorr(i)/length_P;
    end
    
    x1=probs(probs>0);
    ent=-x1*log2(x1');
    
end
    



