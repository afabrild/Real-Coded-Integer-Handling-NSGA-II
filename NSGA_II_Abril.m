function Pareto = NSGA_II_Abril(NSGAparam)
global V M xl xu etac etam pop_size pm

%% Description

% 1. This is the main program of NSGA II. It requires only one input, which is test problem
%    index, 'p'. NSGA II code is tested and verified for 14 test problems.
% 2. This code defines population size in 'pop_size', number of design
%    variables in 'V', number of runs in 'no_runs', maximum number of 
%    generations in 'gen_max', current generation in 'gen_count' and number of objectives
%    in 'M'.
% 3. 'xl' and 'xu' are the lower and upper bounds of the design variables.
% 4. Final optimal Pareto soutions are in the variable 'pareto_rank1', with design
%    variables in the coumns (1:V), objectives in the columns (V+1 to V+M),
%    constraint violation in the column (V+M+1), Rank in (V+M+2), Distance in (V+M+3).
%% code starts
M =         NSGAparam.NumberObjM;
pop_size =  NSGAparam.PopSize;           % Population size
no_runs =   NSGAparam.Runs;              % Number of runs
gen_max =   NSGAparam.MaxGen;            % MAx number of generations - stopping criteria
fname =     NSGAparam.FunObj;      % Objective function and constraint evaluation
V =         NSGAparam.VarSize;
xl =        NSGAparam.LowerBound;            % lower bound vector
xu =        NSGAparam.UpperBound;            % upper bound vectorfor
IntVar =    NSGAparam.IntVar;                % Vector that contains the position of the integer variables
Const =     NSGAparam.ConstNumber;
InitialPop= NSGAparam.InitialPop;
PlotInterval = NSGAparam.PlotInterval;
etac =      NSGAparam.CrossIndex;                  % distribution index for crossover
%etam = 20;                  % distribution index for mutation / mutation constant
%etac = 20;                  % distribution index for crossover
etam =      NSGAparam.DistIndex;                 % distribution index for mutation / mutation constant
pm=         NSGAparam.MutationProb;                      % Mutation Probability
TruePF =    NSGAparam.TruePF;
no_runs =       NSGAparam.no_runs;
Q=[];
for run = 1:no_runs
    
%% Initial population 
xl_temp=repmat(xl, pop_size,1);
xu_temp=repmat(xu, pop_size,1);
x = xl_temp+((xu_temp-xl_temp).*rand(pop_size,V));
x(:, IntVar) = round(x(:,IntVar)); % Round Integer variables.

ff = zeros(pop_size, M);
err = zeros(pop_size, Const);
if ~isempty(NSGAparam.InitialPop)
    x = InitialPop; 
end
%% Evaluate objective function
for i =1:pop_size
[ff(i,:), err(i,:)] =feval(fname, x(i,:));
i
end
error_norm=normalisation(err);% Normalisation of the constraint violation
population_init=[x ff error_norm];
[population, front]=NDS_CD_cons(population_init);    % Non domination Sorting on initial population
    
%% Generation Starts
for gen_count=1:gen_max
% selection (Parent Pt of 'N' pop size)
parent_selected=tour_selection(population);                     % 10 Tournament selection
%% Reproduction (Offspring Qt of 'N' pop size)
child_offspring  = genetic_operator(parent_selected(:,1:V));    % SBX crossover and polynomial mutation
child_offspring(:, IntVar) = round(child_offspring(:,IntVar));  % Integer variables.

fff = zeros(size(child_offspring, 1), M);
err = zeros(size(child_offspring, 1), Const);
for ii = 1:pop_size
[fff(ii,:), err(ii,:)]=feval(fname, child_offspring(ii,:)); 
[ii, gen_count] %
end

error_norm=normalisation(err);
child_offspring=[child_offspring fff error_norm];

%% INtermediate population (Rt= Pt U Qt of 2N size)
population_inter=[population(:,1:V+M+1) ; child_offspring(:,1:V+M+1)];
[population_inter_sorted front]=NDS_CD_cons(population_inter);              % Non domination Sorting on offspring
%% Replacement - N
new_pop=replacement(population_inter_sorted, front);
population=new_pop;
No_Dom = population(population(:,V+M+2)==1, :);
PlotInterval_Ok = 0:PlotInterval:gen_max;
    for z =1:length(PlotInterval_Ok)
    if PlotInterval_Ok(z) == gen_count
    figure(1);
        if M==2
        if(~isempty(TruePF))
        plot(TruePF(:,1),TruePF(:,2),'.','color','b'); hold on;
        end
        plot(No_Dom(:,V+1),No_Dom(:,V+2),'ok', fff(:,1), fff(:,2), '.r');hold off;
        xlabel ('Objective 1');
        ylabel ('Objective 2');
        legend ('Non dominated', 'Repository');
        title( ['Generation: ' num2str( gen_count ) ' / ' num2str(gen_max) ] );
        elseif M ==3
        if(~isempty(TruePF))
        plot3(TruePF(:,1),TruePF(:,2),TruePF(:,3),'.','color','b'); hold on;
        end
        plot3(No_Dom(:,V+1),No_Dom(:,V+2),No_Dom(:,V+3),'ok', fff(:,1), fff(:,2), fff(:,3), '.r'); hold off
        xlabel ('Objective 1');
        ylabel ('Objective 2');
        zlabel ('Objective 3');
        %legend ('Non dominated', 'Repository');
        title( ['Generation: ' num2str( gen_count ) ' / ' num2str(gen_max) ] );           
        end
    end
    end
    if strcmp(NSGAparam.SaveResults,'yes')
    %save(['OUT_NSGAII_' datestr(now,30)],'new_pop'); %Results are saved
    save(sprintf('OUT_%d.mat',gen_count),'new_pop')
    end
end
new_pop=sortrows(new_pop,V+1);
paretoset(run).trial=new_pop(:,1:V+M+1);
Q = [Q; paretoset(run).trial];                      % Combining Pareto solutions obtained in each run
end

%% Result and Pareto plot
figure(2);
if run==1
PFront = paretoFront([new_pop(:,V+1), new_pop(:,V+2)]);
plot(new_pop(:,V+1),new_pop(:,V+2),'.k', PFront(:,1), PFront(:,2), 'xr');
xlabel ('Objective 1');
ylabel ('Objective 2');
legend('Final Gen', 'Pareto Front');
title('Final Pareto Front');
Pareto = new_pop;
else                                        
[pareto_filter front]=NDS_CD_cons(Q);               % Applying non domination sorting on the combined Pareto solution set
rank1_index=find(pareto_filter(:,V+M+2)==1);        % Filtering the best solutions of rank 1 Pareto
pareto_rank1=pareto_filter(rank1_index,1:V+M);
Pareto = pareto_rank1;
plot(pareto_rank1(:,V+1),pareto_rank1(:,V+2),'.r')   % Final Pareto plot
xlabel ('Objetive 1');
ylabel ('Objetive 2');
title('Final Pareto Front');
end
xlabel('objective function 1')
ylabel('objective function 2')
end