function [ent] = entropia(P, A)
    
    h = histograma(P, A);
    
    prob = zeros(1, length(A));
    
    s = size(P);
    length_P = s(1)*s(2);
    
    for i = 1 : length(h)
        prob(i) = h(i)/length_P;
    end
    
    x1 = prob(prob>0);
    ent = -x1*log2(x1');


end

