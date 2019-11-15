%% Description
% 1. This function is to perform Deb's fast elitist non-domination sorting and crowding distance assignment. 
% 2. Input is in the variable 'population' with size: [size(popuation), V+M+1]
% 3. This function returns 'chromosome_NDS_CD' with size [size(population),V+M+3]
% 4. A flag 'problem_type' is used to identify whether the population is fully feasible (problem_type=0) or fully infeasible (problem_type=1) 
%    or partly feasible (problem_type=0.5). 

%% Reference:
%Kalyanmoy Deb, Amrit Pratap, Sameer Agarwal, and T. Meyarivan, " A Fast and Elitist Multiobjective Genetic Algorithm: NSGA-II", 
%IEEE TRANSACTIONS ON EVOLUTIONARY COMPUTATION, VOL. 6, No. 2, APRIL 2002. 


%% function begins
function [chromosome_NDS_CD front] = NDS_CD_cons(population)
global V M problem_type 

%% Initialising structures and variables
chromosome_NDS_CD1=[];
infpop=[];
front.fr=[];
struct.sp=[];
rank=1;


%% Segregating feasible and infeasible solutions

if all(population(:,V+M+1)==0)
    problem_type=0;
    chromosome=population(:,1:V+M);                         % All Feasible chromosomes;    
    pop_size1=size(chromosome,1);
elseif all(population(:,V+M+1)~=0)
    problem_type=1;
    pop_size1=0;
    infchromosome=population;                               % All InFeasible chromosomes;       
else
    problem_type=0.5;
    feas_index=find(population(:,V+M+1)==0);
    chromosome=population(feas_index,1:V+M);                % Feasible chromosomes;    
    pop_size1=size(chromosome,1);
    infeas_index=find(population(:,V+M+1)~=0);
    infchromosome=population(infeas_index,1:V+M+1);         % infeasible chromosomes;    
end

%% Handling feasible solutions 
if problem_type==0 | problem_type==0.5
    pop_size1 = size(chromosome,1);
    f1 = chromosome(:,V+1);   % objective function values
    f2 = chromosome(:,V+2);
%Non- Domination Sorting 
% First front
for p=1:pop_size1
    struct(p).sp=find(((f1(p)-f1)<0 &(f2(p)-f2)<0) | ((f2(p)-f2)==0 &(f1(p)-f1)<0) | ((f1(p)-f1)==0 &(f2(p)-f2)<0)); 
    n(p)=length(find(((f1(p)-f1)>0 &(f2(p)-f2)>0) | ((f2(p)-f2)==0 &(f1(p)-f1)>0) | ((f1(p)-f1)==0 &(f2(p)-f2)>0)));
end

front(1).fr=find(n==0);
% Creating subsequent fronts
while (~isempty(front(rank).fr))
    front_indiv=front(rank).fr;
    n(front_indiv)=inf;
    chromosome(front_indiv,V+M+1)=rank;
    rank=rank+1;
    front(rank).fr=[];
   for i = 1:length(front_indiv)
        temp=struct(front_indiv(i)).sp;
        n(temp)=n(temp)-1;
   end 
        q=find(n==0);
        front(rank).fr=[front(rank).fr q];
   
end
chromosome_sorted=sortrows(chromosome,V+M+1);    % Ranked population  

%Crowding distance Assignment
rowsindex=1;
for i = 1:length(front)-1
 l_f=length(front(i).fr);

 if l_f > 2
     
  sorted_indf1=[];
  sorted_indf2=[];
  sortedf1=[];
  sortedf2=[];
  % sorting based on f1 and f2;
[sortedf1 sorted_indf1]=sortrows(chromosome_sorted(rowsindex:(rowsindex+l_f-1),V+1));
[sortedf2 sorted_indf2]=sortrows(chromosome_sorted(rowsindex:(rowsindex+l_f-1),V+2));

f1min=chromosome_sorted(sorted_indf1(1)+rowsindex-1,V+1);
f1max=chromosome_sorted(sorted_indf1(end)+rowsindex-1,V+1);

chromosome_sorted(sorted_indf1(1)+rowsindex-1,V+M+2)=inf;
chromosome_sorted(sorted_indf1(end)+rowsindex-1,V+M+2)=inf;

f2min=chromosome_sorted(sorted_indf2(1)+rowsindex-1,V+2);
f2max=chromosome_sorted(sorted_indf2(end)+rowsindex-1,V+2);

chromosome_sorted(sorted_indf2(1)+rowsindex-1,V+M+3)=inf;
chromosome_sorted(sorted_indf2(end)+rowsindex-1,V+M+3)=inf;

 for j = 2:length(front(i).fr)-1
     if  (f1max - f1min == 0) | (f2max - f2min == 0)
         chromosome_sorted(sorted_indf1(j)+rowsindex-1,V+M+2)=inf;
         chromosome_sorted(sorted_indf2(j)+rowsindex-1,V+M+3)=inf;
     else
         chromosome_sorted(sorted_indf1(j)+rowsindex-1,V+M+2)=(chromosome_sorted(sorted_indf1(j+1)+rowsindex-1,V+1)-chromosome_sorted(sorted_indf1(j-1)+rowsindex-1,V+1))/(f1max-f1min);
         chromosome_sorted(sorted_indf2(j)+rowsindex-1,V+M+3)=(chromosome_sorted(sorted_indf2(j+1)+rowsindex-1,V+2)-chromosome_sorted(sorted_indf2(j-1)+rowsindex-1,V+2))/(f2max-f2min);
     end
 end

  else
    chromosome_sorted(rowsindex:(rowsindex+l_f-1),V+M+2:V+M+3)=inf;
  end
 rowsindex = rowsindex + l_f;
end
chromosome_sorted(:,V+M+4) = sum(chromosome_sorted(:,V+M+2:V+M+3),2); 
chromosome_NDS_CD1 = [chromosome_sorted(:,1:V+M) zeros(pop_size1,1) chromosome_sorted(:,V+M+1) chromosome_sorted(:,V+M+4)]; % Final Output Variable
end

%% Handling infeasible solutions
if problem_type==1 | problem_type==0.5
infpop=sortrows(infchromosome,V+M+1);
infpop=[infpop(:,1:V+M+1) (rank:rank-1+size(infpop,1))' inf*(ones(size(infpop,1),1))];
for kk = (size(front,2)):(size(front,2))+(length(infchromosome))-1;
 front(kk).fr= pop_size1+1;
end
end
chromosome_NDS_CD = [chromosome_NDS_CD1;infpop]; 

