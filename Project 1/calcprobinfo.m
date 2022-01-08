function [info] = calcprobinfo(query, alf, temp)

ocorr = zeros(length(alf),length(alf));

for index=1:length(query)
    index1 = find(alf == query(index));
    index2 = find(alf == temp(index));
    ocorr(index1,index2) = ocorr(index1,index2) + 1/length(query);
    
end

ocorr(ocorr==0) = [];
 
e12 = -sum(ocorr .* log2(ocorr));

e1 = entropia(query,alf);

e2 = entropia(temp,alf);

info = e1+e2-e12;


end