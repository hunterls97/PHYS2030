function results=EXrandomWalk2dRho_214193627(method,Nwalkers,Nsteps,Nshow)
    % Modified by Hunter Schofield - 214193627, version 3/20/2019
    %
    % Invoke as: EXrandomWalk2dRho_214193627(4,1936,40,3)
    % Calculates positions for a group of independent 2-D random walkers,
    % including reflective boundaries at abs(x)=16.5 and abs(y)=16.5
    % appropriate for density diffusion on a grid -16<x<16 and -16<y<16.
    % o Method 1 - simply equal probability one step up/down (U/D) and left/right (L/R)
    % o Method 2 - U/D and L/R steps are sampled from a uniform distribution over [-1,1]
    % o Method 3 - U/D and L/R steps are sampled from a Gaussian distribution
    % o Method 4 - one step U/D _or_ one step L/R, with all probabilities equal
    % Source: Kevin Berwick (re 'Computational Physics', Giordano & Nakanishi);
    % modified by C. Bergevin 11.16.14; further modified by P. Hall 2019
    %
    % --- Set up the parameters
    help EXrandomWalk2dRho_214193627;
    N=Nwalkers; % Total # of (independent) walkers (each starts at x,y=0,0)
    M=Nsteps; % Total # of steps for each walker (try 40, 61, 100, 301)
    K=Nshow; % # of walkers to show individual traces for
    rng(214193627); %set seed to student number
    % --- Step through the N walkers
    for r= 1:N
        x=0; y=0;   % initialize positions for r'th walker
        positionX(r,1)= 0;  positionY(r,1)= 0;
        % --- loop to go through M steps for r'th walker
        for nn=1:M;
            if method==1
                if (rand<0.5),  x=x+1;  % conditional for left or right
                else    x=x-1;  end;
                if (rand<0.5),  y=y+1;  % conditional for up or down
                else    y=y-1;  end;
            elseif method==2
                x= x+2*rand(1)-1;   y= y+2*rand(1)-1;
            elseif method==3
                x= x+randn(1);   y= y+randn(1);
            elseif method==4
                temp = rand;
                
                %25% chance for movement in any of the 4 directions
                if(temp <= 0.25)
                    x = x+1;
                elseif(temp > 0.25 && temp <= 0.5)
                    x = x-1;
                elseif(temp > 0.5 && temp <= 0.75)
                    y = y+1;
                else
                    y = y-1;
                end
            end
    % --- Enforce reflective boundaries at x=+-16 and y=+16:
            if (x>16), x=15;
            elseif (x<-16), x=-15;
            elseif (y>16), y=15;
            elseif (y<-16), y=-15;
            end
            positionX(r,nn+1)= x; % store displacments for each walker and step
            positionY(r,nn+1)= y;
        end
    end

    %---Plot a subset of individual walker traces
    figure(1); clf; hold on; grid on;
    for nn=1:K
        shade= 1-0.9*(nn-1)/K;
        plot(positionX(nn,:),positionY(nn,:),'Color',[1 1 1]-shade);
    end
    xlabel('x'); ylabel('y'); title('Representative traces');

    %---Histogram plot
    steprange=linspace(-M,M,2*M+1);
    figure(2);
    hold off;
    histogram(positionX(:,M),'DisplayStyle','stairs','FaceColor','none')
    hold on;
    histogram(positionY(:,M),'DisplayStyle','stairs','FaceColor','none')
    if method==1
        sigma=sqrt(M); N=2*N; % walkers only on either odd or even-numbered pixels
    elseif method==2
        sigma=sqrt(M); % Not correct; included just to avoid program crash
    elseif method==3
        sigma=sqrt(M); % Not correct; included just to avoid program crash
    elseif method==4
        sigma= sqrt(M/2); % REPLACE with your solution for sigma in Method 4
    end
    plot(steprange,(N/(sigma*sqrt(2*pi)))*exp(-(steprange/(sqrt(2)*sigma)).^2))
    hold off;
    title('Random Walker Histogram');
    xlabel('Distance (1 Dimensional)');
    ylabel('Quantity of Walkers');
    legend('Ending X Position', 'Ending Y Position', 'Gaussian Curve');

    % --- Mesh plot
    figure(3);
    % --- Count the number of points in bins with edges from -M-0.5 to +M+0.5, 3 units wide in x and y
    [cvals,Xedges,Yedges] = histcounts2(positionX(:,M),positionY(:,M),-M-0.5:3:M+0.5,-M-0.5:3:M+0.5);
    % --- Create a grid of X,Y bin centers spaced every 3 units
    [X,Y] = meshgrid(-M-0.5+1.5:3:M+0.5-1.5,-M-0.5+1.5:3:M+0.5-1.5);
    % --- Create mesh plot
    mesh(X,Y,cvals);
    title('Random Walk Mesh');
    xlabel('X');
    ylabel('Y');
    zlabel('Quantity of Walkers')
    % --- Set limits matching bin centers within the 2-D boundaries 
    xlim([-15,15]); ylim([-15,15]);
    
    nonzerovals = cvals(cvals>0);
    
    %calculate mean
    mean = sum(nonzerovals)/121;
    
    %calculate standard deviation
    sd = 0;
    for i = 1:length(nonzerovals)
        sd = sd + (nonzerovals(i) - mean)^2;
    end;
    sd = sqrt(sd / N);
    
    disp(mean);
    disp(sd);
return;
% Mean: 16, standard deviation: 1.2381
% Mean: 16, standard deviation: 1.3016