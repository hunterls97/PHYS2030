function f = errintg_214193627(x,param)
    %% errintg_214193627.m - Error function integrand
    %Developed by Hunter Schofield - 214193627, version 3/14/2019
    %
    %Invoke as errintg_214193627(5) note: 5 is an arbitrary value
    %
    % Based on a program from Prof. Alejandro Garcia
    % https://github.com/AlejGarcia/NM4P/tree/master/MatlabRevised
    %
    %Description of Input Parameters:
    %x = value where integrand is evaluated
    %param = parameter list (not used)
    %help errintg_214193627; %commented out to avoid console spam
    f = (sin(8*x))^4;
return;