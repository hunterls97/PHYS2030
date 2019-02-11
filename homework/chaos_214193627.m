%% chaos_214193627.m - Program to plot chaotic voltage, current, and phase
%Developed by Hunter Schofield - 214193627

%To run this program, type chaos_214193627(state_vector, vc1_offset, timesteps)
%where state_vector is the initial state vector, vc1_offset is the offset
%voltage accross the first capacitor, and timesteps is the quantity of
%timesteps to run the program for.
%example: type chaos_214193627([(214193627/1e9), 0, -1], 0.1, 500) in the
%command line

%ii) as delta VC1 changes by factors of 10, the resultant space trajectory
%and vc1(t) plots for the two starting positions slowly converge, however,
%in order to see this convergance, we need to set the rk error tolerance
%to be 1e-6 instead of 1e-3. This convergance
%would make sense because as delta vc1 aproaches zero, then the two
%starting points are equal, and should result in the same graph.
%example: type chaos_214193627([(214193627/1e9), 0, -1], 0.01, 500) in the
%command line to see how the results change for an offset a factor of 10
%smaller.

%iii) to make the resistor into a linear resistor, I selected the constant
%value of m0 + m1 so that the linear resistor will be in the same order of
%magnitude as the locally active nonlinear one. For this value of a linear
%resistor, the circuit is a lot less chaotic. That is, the resultant plots
%were a lot similar in this case, and converge much quicker as delta VC1
%approaches 0. For the VC1(t) plot, the trend shows a damping sinusoidal
%function with both plots overlapping. This makes sense because the locally active nonlinear
%resistor was greatly dependent on the input paramenter vc1. By making it
%constant, the ODE's that govern the circuit become simpler, and the system
%becomes less chaotic.
function chaos = chaos_214193627(s, offset, timesteps)
    %define circuit parameters
    C1 = 1/9;
    C2 = 1;
    G = 0.7;
    L = 1/7;
    m0 = -0.5;
    m1 = -0.8;
    Bp = 1;
    
    %setup state variables for 2 starting points
    s1 = s; %[(214193627/1e9), 0, -1]; %starting point 1
    s2 = s1 + [offset 0 0]; %starting point 2
    
    time = 0;
    tau = 1; %initial timestep guess
    err = 1.e-3;   % Error tolerance, using 1e-6 instead of 1e-3 to show better convergance for small delta vc1
    for istep = 1:timesteps
       vc1_1 = s1(1); vc2_1 = s1(2); il_1 = s1(3); %state variables for position 1
       vc1_2 = s2(1); vc2_2 = s2(2); il_2 = s2(3); %state variables for position 2
       
       tplot(istep) = time; tauplot(istep) = tau; %for time plots
       vc1_plot_1(istep) = vc1_1;  vc2_plot_1(istep) = vc2_1;  il_plot_1(istep) = il_1;
       vc1_plot_2(istep) = vc1_2;  vc2_plot_2(istep) = vc2_2;  il_plot_2(istep) = il_2;
       
       %setup parameters, all are constant except ir
       param_1 = [G C1 C2 L m0 m1];
       param_2 = [G C1 C2 L m0 m1];
       
       %* Find new state using adaptive Runge-Kutta
       [s1, time, tau] = rka(s1,time,tau,err,@chaosrk,param_1);
       [s2, time, tau] = rka(s2,time,tau,err,@chaosrk,param_2);
    end
    
    %plot vc(t) 
    figure(1); clf; %start figure 1
    plot(tplot, vc1_plot_1, 'r-');
    hold on;
    plot(tplot, vc1_plot_2, 'b-');
    
    title('Vc1 vs. Time');
    xlabel('time');
    ylabel('Vc1');
    legend('initial point 1', 'initial point 2');
    
    %plot phase space trajectories
    figure(2); clf; %start figure 2
    plot3(vc1_plot_1, vc2_plot_1, il_plot_1);
    hold on;
    plot3(vc1_plot_2, vc2_plot_2, il_plot_2);
    
    title('Circuit chaotic voltage and current');
    xlabel('Voltage across capacitor 1');
    ylabel('Voltage across capacitor 2');
    zlabel('Current through inductor');
    legend('initial point 1', 'initial point 2');
return;