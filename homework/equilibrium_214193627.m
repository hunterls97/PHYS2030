function result = equilibrium_214193627()
    %% equilibrium_214193627.m - Program to compute and plot the equilibrium position of a spring-mass system
    %Developed by Hunter Schofield - 214193627, version 2/11/2019
    %
    %Invoke as equilibrium_214193627()
    help equilibrium_214193627;
    
    k1 = 1; %set a default value of k1 to 1
    
    ratios = [];
    length = [];
    i = 1;
    %for each ratio step k1/k2
    for k2 = 1000:-0.001:0.001
        ratios(i) = k1/k2;
        
        %determine matrix K
        K = [(-k2 - 2*k1) k1 k2;
             k1 (-k2 - 2*k1) k1;
             k2 k1 (-k2 -k1)];
        
         %determine vector b
        b = [k2; -k2; (-k2 -k1)];
        
        x = K\b; %solve the system
        length(i) = x(3); %The total length of the system will be the position of the third mass
        i = i + 1;
    end

    plot(ratios, length);
    set(gca, 'XScale', 'log');
    xlim([1e-3 1e3]);
    title('Total System length vs stiffess ratio k1/k2');
    xlabel('Stiffness ratio k1/k2');
    ylabel('Total system length');
return;