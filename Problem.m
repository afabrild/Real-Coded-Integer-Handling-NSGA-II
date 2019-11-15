function truePF = Problem(p)
    try
    if p== 1         % Schaffer
        load('Schaffer.mat');
        truePF = PF;
    elseif p== 3           % Kursawe 
        load('Kursawe.mat');
        truePF = PF;
    elseif p== 2            % ZDT1 (convex)
        load('ZDT1.mat');
        truePF = PF;
    elseif p== 5            % ZDT2 (non-convex)
        load('ZDT2.mat');
        truePF = PF;
    elseif p==24          % ZDT3 (discrete)
        load('ZDT3.mat');
        truePF = PF;
    elseif p==25          % Vinnet 3
        load('Viennet3.mat');
        truePF = PF;
    elseif p== 9            % ZDT6 (non-uniform)
        load('ZDT6.mat');
        truePF = PF;
    elseif p== 10            % BNH
        load('BNH.mat');
        truePF = PF;
    elseif p== 11            % SRN
        load('SRN.mat');
        truePF = PF;
    elseif p== 12            % TNK
        load('TNK.mat');
        truePF = PF;
    elseif p==14
        load('CONT.mat');
        truePF = PF;
    elseif p==13
        load('OSY.mat');
        truePF = PF;
    elseif p==20
        load('Schaffer.mat');
        truePF = PF;
    elseif p == 'UF1'
        load('UF1.mat');
        truePF = UF1;
    %elseif p == 'UF2'
    %    load('ParetoFronts/UF2.mat');
    %    truePF = UF2;
    elseif p == 'UF10'
        load('UF10.mat');
        truePF = UF10;
    else
        truePF = [];
    end
        catch
        truePF =[];
    end
end


    