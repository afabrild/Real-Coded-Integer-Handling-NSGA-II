function [xl, xu, Const, IntVar] = TestProblemBounds(p)             

if p<=9     % Unconstrained test functions
tV=[2;30;3;1;30;4;30;10;10];
V=tV(p);
Const = 1;
txl=[-5*ones(1,V);zeros(1,V);-5*ones(1,V);-1000*ones(1,V);zeros(1,V);-1/sqrt(V)*ones(1,V);zeros(1,V); 0 -5*ones(1,V-1);zeros(1,V)]; 
txu=[10*ones(1,V); ones(1,V);5*ones(1,V);1000*ones(1,V);ones(1,V);1/sqrt(V) *ones(1,V);ones(1,V);1 5*ones(1,V-1);ones(1,V)];
xl=(txl(p,1:V));            % lower bound vector
xu=(txu(p,1:V));            % upper bound vectorfor 
elseif  p>9 && p<20       % Constrained test functions
p1=p-9;
tV=[2;2;2;6;2];
Const = [2, 2, 2, 6, 2,];
Const = Const(p1);
V=tV(p1);
txl=[0 0 0 0 0 0;-20 -20 0 0 0 0;0 0 0 0 0 0;0 0 1 0 1 0;0.1 0 0 0 0 0]; 
txu=[5 3 0 0 0 0;20 20 0 0 0 0;pi pi 0 0 0 0;10 10 5 6 5 10;1 5 0 0 0 0];
xl=(txl(p1,1:V));           % lower bound vector
xu=(txu(p1,1:V));           % upper bound vectorfor i=1:NN
elseif p == 20
    Const = 1;
    xl=-5;           % lower bound vector
    xu=5;           % upper bound vectorfor i=1:NN
elseif p == 21
    Const = 1;
    xl=-5.*ones(1,3);           % lower bound vector
    xu=5.*ones(1,3);           % upper bound vectorfor i=1:NN
elseif p == 22
    Const = 1;
    xl=-pi.*ones(1,2);           % lower bound vector
    xu=pi.*ones(1,2);           % upper bound vectorfor i=1:NN
elseif p ==23
    Const = 1;
    xl = zeros(1,12);
    xu = ones(1,12);
elseif p ==24
    Const = 1;
    xl = 0.*ones(1,30);
    xu = 1.*ones(1,30);
elseif p ==25
    Const = 1;
    xl = [-3, -10];
    xu = [10, 3];
end
IntVar = [];
end
