function results=dftcsPBH1Df_214193627(tau,N,nstep,nplots)
    % Modified by Hunter Schofield - 214193627, version 3/22/2019
    %
    % dftcsPBH1Df - Alejandro L. Garcia code modified by Patrick B. Hall 2019
    % Solves diffusion equation using Forward Time Centered Space (FTCS) scheme
    % Invoke as dftcsPBH1Df_214193627(0.1,33,300,50)
    %tau = input('Enter time step: ');
    %N = input('Enter the number of grid points: ');
    %nstep = 300;               % Maximum number of iterations
    %nplots = 50;               % Number of snapshots (plots) to take
    help dftcsPBH1Df;  
    %% * Initialize parameters
    L = 32.;  % The system extends from x=-L/2 to x=L/2
    h = L/(N-1);  % Grid spacing
    kappa = 1.;   % Diffusion coefficient
    coeff = kappa*tau/h^2;
    if( coeff < 0.5 )
      disp('Solution is expected to be stable');
    else
      disp('WARNING: Solution is expected to be unstable');
    end

    %% * Set initial and boundary conditions.
    tt = zeros(N,1);          % Initialize function value to zero at all points
    tt(round(N/2)) = 1/h;     % Initial cond. is delta function in center

    %% * Set up loop and plot variables.
    xplot = (0:N-1)*h - L/2;   % Record the x scale for plots
    yplot = (0:N-1)*h - L/2;
    iplot = 1;                 % Counter used to count plots
    plot_step = nstep/nplots;  % Number of time steps between plots

    %% * Loop over the desired number of time steps.
    for istep=1:nstep  %% MAIN LOOP %%
      % PBH: compute edges as temp. variables to not affect interior computation
      tt1 = tt(1) + coeff*(tt(2) - tt(1));
      ttN = tt(N) + coeff*(tt(N-1) - tt(N));
      % PBH: Now compute interior as in original AJC program dftcs.m
      tt(2:(N-1)) = tt(2:(N-1)) + ...
          coeff*(tt(3:N) + tt(1:(N-2)) - 2*tt(2:(N-1)));
      % PBH: Now replace the edge values with the temporary variables
      tt(1) = tt1; tt(N) = ttN; % comment out for alternate boundary conditions

      %* Periodically record function value for plotting.
      if( rem(istep,plot_step) < 1 )   % Every plot_step steps
        ttplot(:,N) = tt(:);       % record tt(i) for plotting
        tplot(iplot) = istep*tau;      % Record time for plots
        iplot = iplot+1;
      end
    end
    
    %calculate diffusion along x and y, and get average
    finaltt = ttplot + ttplot.';
    for i = 33:-1:1
        for j = 33:-1:1
            %only doing 33 steps in x and y because the enclosed boundary
            %is between -16 and +16 for both x and y
            finaltt(i,j) = (finaltt(i, 33) + finaltt(33, j))/2;
        end
    end
     
    finaltt(33,:) = finaltt(32,:);
    finaltt(:,33) = finaltt(:,32);
    
    %% * Plot function value versus x and t as wire-mesh and contour plots.
    figure(1); clf;
    mesh(xplot, yplot, finaltt);  % Wire-mesh surface plot
    xlabel('x');  ylabel('y');  zlabel('\rho(x,y)');
    title('Diffusion of a delta spike in x and y');
    ylim([-16 16]); zlim([0 max(max(ttplot))]);
return;
% This plot is similar to the plot in question 1 only when a low value for
% the number of steps (i.e. less than 40) are used for question 1. Once
% there are a substantial amount of steps used in the 2d random walk
% program, the plots look very different.