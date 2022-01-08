function [MutualInfo] = ex6a(query, target, alf, stepini)

numjanelas = floor((length(target)-length(query)) / stepini+1); %arredondar

MutualInfo = zeros(1, numjanelas); %criar matriz

step = 1;
for index = 1:numjanelas
    
    temp = target(step : (step+length(query)-1));
    
    info = calcprobinfo(query, alf, temp);
    
    MutualInfo(index) = info;
    
    step = step + stepini; %incrementar step
    
end

end