function result = linfit_214193627()
    %% linfit_214193627 - Program to plot a linear fit to a dataset
    %By: Hunter Schofield
    %
    %Invoke as: linfit_214193627()
    help linfit_214193627;
    format long;
    
    data = load('Barrow.txt').'; %load the data and transpose it
    err = 0.27*ones(1, 230);
    time = [1981:9/229:1990]; %230 points in the data, use 1990-1981/N-1 to determine step size
    [fit_params, fit_err, fit_curve, fit_chi] = linreg(time, data, err);
    fit = (fit_params(2).*time) + fit_params(1); %determine fit
    
    %calculate when the co2 concentration is 10% higher than in 1981
    increase_date = floor(1981 + (data(1)*1.1 - data(1)) / fit_params(2));
    
    %a) For Barrow, Alaska, the Rate of increase of CO2 is approximately
    %1.5103 parts per million per year. 
    %b) The CO2 will be 10% higher than the 1981 concentration in the year
    %2003.
    
    data2 = load('Mauna.txt').'; %load the data and transpose it
    err2 = 0.16*ones(1, 230);
    time2 = [1981:9/229:1990]; %230 points in the data, use 1990-1981/N-1 to determine step size
    [fit_params2, fit_err2, fit_curve2, fit_chi2] = linreg(time, data, err);
    fit2 = (fit_params(2).*time) + fit_params(1); %determine fit
    
    %calculate when the CO2 concentration is 10% higher than in 1981
    increase_date2 = floor(1981 + (data2(1)*1.1 - data2(1)) / fit_params2(2));
    
    %a) For Mauna Loa, Hawaii, the rate of increase of CO2 is approximately
    %1.510305042034722 parts per million per year.
    %b) The CO2 will be 10% higher than the 1981 concentration in the year
    %2003.
    
    %reduced chi^2 = chi^2 / N-M = chi^2/228
    disp(fit_chi2);
    disp(fit_chi2/228);
    
    %c) The reduced chi-squared value is approximately 424.559 and the
    %value of chi-squared is approximately 9679.935. Inspecting the plot,
    %the linear fit seems really good. It shows the path of the trend and
    %gives good insight on what the future values of the carbon dioxide
    %will be. However, the textbook defines a good fit if the chi-squared
    %value is much less than N - M (i.e chi^2 << N-M) and a poor fit if the
    %chi-squared value is much greater than N - M (i.e chi^2 >> N-M). The
    %reduced chi-square value is greater than N - M, however, it is not
    %greater by any order of magnitude. I would say that this is not a good
    %fit, but an okay fit according to the reduced chi-squared value. This
    %is likely because instead of providing an error for each individual
    %data point, the same general error was used for every single data
    %point, which results in a less optimal fit.
    
    figure(1); clf;
    hold on;
    plot(time, data, 'b+');
    plot(time, fit, 'r-');
    title('CO_{2} concentration in Barrow, Alaska');
    xlabel('Year');
    xlim([1980 1991]); %set xlim a bit past dataset to better view the data
    ylabel('CO_{2} (ppm)');
    
    figure(2); clf;
    hold on;
    plot(time2, data2, 'b+');
    plot(time2, fit2, 'r-');
    title('CO_{2} concentration in Mauna Loa, Hawaii');
    xlabel('Year');
    xlim([1980 1991]); %set xlim a bit past dataset to better view the data
    ylabel('CO_{2} (ppm)');
return;