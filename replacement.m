function new_pop=replacement(population_inter_sorted, front)
global pop_size 
%% Description
% The next generation population is formed by appending each front subsequently until the
% population size exceeds the current population size. If When adding all the individuals
% of any front, the population exceeds the population size, then the required number of 
% remaining individuals alone are selected from that particular front based
% on crowding distance.
%% code starts
index=0;
ii=1;
while index < pop_size
    l_f=length(front(ii).fr);
    if index+l_f < pop_size 
        new_pop(index+1:index+l_f,:)= population_inter_sorted(index+1:index+l_f,:);
        index=index+l_f;
    else
            temp1=population_inter_sorted(index+1:index+l_f,:);
            temp2=sortrows(temp1,size(temp1,2));
            new_pop(index+1:pop_size,:)= temp2(l_f-(pop_size-index)+1:l_f,:);
            index=index+l_f;
    end
    ii=ii+1;
end
