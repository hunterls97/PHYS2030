function result = noise_214193627
    %% noise_214193627.m - Program to perform fast Fourier transform on noise
    %Developed by Hunter Schofield - 214193627, version 3/11/2019
    %
    %Invoke as noise_214193627()
    help noise_214193627;
    
    n = 1024; %length of random dataset  
    %s = 0.2*sin((1:1024)/3); %discritized sine wave with frequency approximately 20 datapoints   
    
    figure(2); clf;
    for i = 1:4
        rng(i); %initialize random number generator with seed i (will always be 1-4)
        random_vector = randn(1, n); %random dataset
        %random_vector = random_vector + s; %used to add sine wave to random dataset

        yt = fft(random_vector); %compute fft
        P = abs(yt).^2; %determine 2 sided spectrum
        P2 = P(1:1:(n/2)+1); %reconstruct for frequencies below nyquist
        P2(2:end - 1) = 2*P2(2:end - 1); %multiply by 2   
        f = [0:1/(n/2):1]; %frequency f_k+1 = k/(tN), for t = 1, the frequency = k/N
        
        %plot power series
        subplot(2,2,i) %2x2 arrange subplots in 2x2 grid 
        plot(f, P2, '-'); %plot the currently computed power series
        title(sprintf('Power Series for Seed=%d%', i));
        xlabel('Frequency');
        ylabel('Magnitude');
    end
return;