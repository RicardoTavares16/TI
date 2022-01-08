function [h] = histograma(P, A)    

PP = double(reshape(P,[],1));
AA = double(A);
 
h = hist(PP,AA);

end