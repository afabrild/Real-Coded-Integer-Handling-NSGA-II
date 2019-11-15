function err_norm  = normalisation(error_pop)
  
%% Description
% 1. This function normalises the constraint violation of various individuals, since the range of 
%    constraint violation of every chromosome is not uniform.
% 2. Input is in the matrix error_pop with size [pop_size, number of constraints].
% 3. Output is a normalised vector, err_norm of size [pop_size,1]
 
%% Error Nomalisation
[N,nc]=size(error_pop);
 con_max=0.001+max(error_pop);
 con_maxx=repmat(con_max,N,1);
 cc=error_pop./con_maxx;
 err_norm=sum(cc,2);                % finally sum up all violations
 

 