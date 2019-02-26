function result = freqdomain_214193627
    %% freqdomain_214193627 - Plots power series and filtered time series
    %By: Hunter Schofield
    %
    %Invoke as: freqdomain_214193627()
    help freqdomain_214193627;
    
    data = load('Mauna.txt').'; %load the data and transpose it
    err = 0.16*ones(1, 230);
    time = [1981:9/229:1990]; %230 points in the data, use 1990-1981/N-1 to determine step size
    yt = fft(data);
    N = length(data); %get the length of the dataset
    freq = (9/229)*[1:1:N]; %calculate the frequencies
    
    P = abs(yt).^2; %determine 2 sided spectrum
    P2 = P(1:1:(N/2)+1); %reconstruct for frequencies below nyquist
    P2(2:end - 1) = 2*P2(2:end - 1); %multiply by 2
    freq2 = (9/229)*[1:(N/2) + 1];
    
    %plot power series
    figure(1); clf;
    semilogy(freq2 * (229/9), P2, '-');
    title('Power Series');
    xlabel('Frequency'); %note this is the specific index of the frequency in P.
    ylabel('Power Series Magnitude');
    
    P3 = yt.^2; %get the results without abs value
    P3(2:8) = 0; %remove aliasing
    P3(10:19) = 0; %remove everything between 6 months and 1 year
    P3(30:32) = 0; %remove aliasing
    data2 = ifft(sqrt(P3)); %inverse fast fourier, need to divide by 2 and take root to get back to original
    
    %plot unfiltered time series
    figure(2); clf;
    hold on;
    plot(time, data, 'b-');
    plot(time, data2, 'r-');
    title('Time Series');
    xlabel('Year');
    ylabel('CO_{2} ppm');
    legend('Unfiltered Time Series', 'Filtered Time Series');
return;