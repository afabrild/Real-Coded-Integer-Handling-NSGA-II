
global p
%Selection of Problem. 
p =22; % Open @test_case for see benchmarks problems. #2 ---> ZDT1
[xl, xu, Const, IntVar] = TestProblemBounds(p);
TruePF = Problem(p);
NSGAparam.NumberObjM = 2;
NSGAparam.PopSize = 100;         % Population size
NSGAparam.Runs = 1;              % Number of runs
NSGAparam.MaxGen = 100;       % MAx number of generations - stopping criteria
NSGAparam.FunObj = @test_case;   % Objective function and constraint evaluation
NSGAparam.VarSize = length(xl);
NSGAparam.LowerBound = xl;            % lower bound vector
NSGAparam.UpperBound = xu;            % upper bound vectorfor
NSGAparam.IntVar = IntVar;                % Vector that contains the position of the integer variable
NSGAparam.InitialPop = [];
NSGAparam.SaveResults = 'no';
NSGAparam.PlotInterval = 1;
NSGAparam.ConstNumber = Const;
NSGAparam.CrossIndex = 20;
NSGAparam.DistIndex = 20;
NSGAparam.MutationProb = 0.5;
NSGAparam.TruePF = TruePF;
NSGAparam.no_runs = 1;

Resultados = NSGA_II_Abril(NSGAparam);
