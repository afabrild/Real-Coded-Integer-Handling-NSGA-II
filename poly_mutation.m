function mutated_child = poly_mutation(y)
global V xl xu etam pm

%% Description
% 1. Input is the crossovered child of size (1,V) in the vector 'y' from 'genetic_operator.m'.
% 2. Output is in the vector 'mutated_child' of size (1,V).
%% Polynomial mutation including boundary constraint
del=min((y-xl),(xu-y))./(xu-xl);
t=rand(1,V);
loc_mut=t<pm;        
u=rand(1,V);
delq=(u<=0.5).*((((2*u)+((1-2*u).*((1-del).^(etam+1)))).^(1/(etam+1)))-1)+(u>0.5).*(1-((2*(1-u))+(2*(u-0.5).*((1-del).^(etam+1)))).^(1/(etam+1)));
c=y+delq.*loc_mut.*(xu-xl);
mutated_child=c;
    
