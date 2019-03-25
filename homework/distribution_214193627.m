function result = distribution_214193627()
    %% distribution_214193627 - program to generate 10000 gaussian distributed random numbers in x and y
    % by Hunter Schofield - 214193627, version 3/14/2019
    %
    % Invoke as: distribution_214193627();
    help distribution_214193627;
    
    rng(214193627); %random seed with my student number
    x = randn(1, 10000); %generate 10000 x values
    y = randn(1, 10000); %generate 10000 y values
    
    z = 0;
    for i = 1:10000
        if(abs(x(i)) <= 1 && abs(y(i)) <= 1)
            z = z + 1; %determine how many points are in the square {(x,y)| -1 <= x <= 1, -1 <= y <= y}
        end
    end
    
    disp(z);
    %plot the distribution
    scatter(x,y, 'b+')
return
% 4660 +/- 69
% 4626