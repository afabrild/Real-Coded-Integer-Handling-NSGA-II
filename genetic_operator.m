function child_offspring  = genetic_operator(parent_selected)
global V xl xu etac 
%% Description
% 1. Crossover followed by mutation
% 2. Input is in 'parent_selected' matrix of size [pop_size,V].
% 3. Output is also of same size in 'child_offspring'. 

%% Reference 
% Deb & samir agrawal,"A Niched-Penalty Approach for Constraint Handling in Genetic Algorithms". 
%% SBX cross over operation incorporating boundary constraint
[N] = size(parent_selected,1);
xl1=xl';
xu1=xu';
rc=randperm(N);
for i=1:(N/2)
    parent1=parent_selected((rc(2*i-1)),:);
    parent2=parent_selected((rc(2*i)),:);
    if (isequal(parent1,parent2))==1 & rand(1)>0.5
        child1=parent1;
        child2=parent2;
    else 
        for j = 1: V  
            if parent1(j)<parent2(j)
               beta(j)= 1 + (2/(parent2(j)-parent1(j)))*(min((parent1(j)-xl1(j)),(xu1(j)-parent2(j))));
            else
               beta(j)= 1 + (2/(parent1(j)-parent2(j)))*(min((parent2(j)-xl1(j)),(xu1(j)-parent1(j))));
            end   
        end
         u=rand(1,V);
         alpha=2-beta.^-(etac+1);
         betaq=(u<=(1./alpha)).*(u.*alpha).^(1/(etac+1))+(u>(1./alpha)).*(1./(2 - u.*alpha)).^(1/(etac+1));
        child1=0.5*(((1 + betaq).*parent1) + (1 - betaq).*parent2);
        child2=0.5*(((1 - betaq).*parent1) + (1 + betaq).*parent2);
    end
    child_offspring((rc(2*i-1)),:)=poly_mutation(child1);           % polynomial mutation
    child_offspring((rc(2*i)),:)=poly_mutation(child2);             % polynomial mutation
end
