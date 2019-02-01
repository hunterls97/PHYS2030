%% chaos_214193627.m - Program to plot chaotic voltage, current, and phase
%to run this program, type chaos_214193627(state_vector, vc1_offset, timesteps)
%where state_vector is the initial state vector, vc1_offset is the offset
%voltage accross the first capacitor, and timesteps is the quantity of
%timesteps to run the program for.
%example: type chaos_214193627([(214193627/1e9), 0, -1], 0.1, 500) in the
%command line
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
    err = 1.e-3;   % Error tolerance
    for istep = 1:timesteps
       vc1_1 = s1(1); vc2_1 = s1(2); il_1 = s1(3); %state variables for position 1
       vc1_2 = s2(1); vc2_2 = s2(2); il_2 = s2(3); %state variables for position 2
       
       tplot(istep) = time; tauplot(istep) = tau; %for time plots
       vc1_plot_1(istep) = vc1_1;  vc2_plot_1(istep) = vc2_1;  il_plot_1(istep) = il_1;
       vc1_plot_2(istep) = vc1_2;  vc2_plot_2(istep) = vc2_2;  il_plot_2(istep) = il_2;
       
       %determine ir(vc1)
       ir_1 = solve(vc1_1, Bp, m0, m1);
       ir_2 = solve(vc1_2, Bp, m0, m1);
       
       %setup parameters, all are constant except ir
       param_1 = [G C1 C2 L ir_1];
       param_2 = [G C1 C2 L ir_2];
       
       %* Find new state using adaptive Runge-Kutta
       [s1, time, tau] = rka(s1,time,tau,err,@chaosrk,param_1);
       [s2, time, tau] = rka(s2,time,tau,err,@chaosrk,param_2);
    end
    
    figure(1); clf; %start figure 1
    plot(tplot, vc1_plot_1, 'r-');
    hold on;
    plot(tplot, vc1_plot_2, 'b-');
    
    title('Vc1 vs. Time');
    xlabel('time');
    ylabel('Vc1');
    
    figure(2); clf; %start figure 2
    plot3(vc1_plot_1, vc2_plot_1, il_plot_1);
    hold on;
    plot3(vc1_plot_2, vc2_plot_2, il_plot_2);
    
    title('Circuit chaotic voltage and current');
    xlabel('Voltage across capacitor 1');
    ylabel('Voltage across capacitor 2');
    zlabel('Current through inductor');
    
    function current = solve(vc, Bp, m0, m1)
       if( vc <= -1*Bp)
           current = (-1)*m1*Bp + m0*(vc + Bp);
       elseif( abs(vc) <= Bp )
           current = m1*vc;
       else
           current = m1*Bp + m0*(vc - Bp);
       end 
    return;
return;