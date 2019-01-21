%Homework 4
%balle improvements developed by Hunter Schofield - 214193627

%Answers to 3
%new maximum range when y=0m, v=50m/s, theta=45, tau=0.5s: 272.578 meters
%new time of flight for above input parameters: 7.70967 seconds
%percent improvement: 4.0279%

%new maximum range when y=0m, v=50m/s, theta=45, tau=0.05s: 256.61 meters
%new time of flight for above input parameters: 7.25802 seconds
%percent improvement: 0.5824%

%new maximum range when y=0m, v=50m/s, theta=45, tau=0.005s: 255.019 meters
%new time of flight for above input parameters: 7.21302 seconds
%percent improvement: 0.0275%

%Answers to 4
%Euler method max time step for 1% error: tau = 0.072 seconds
%Euler-Cromer method max time step for 1% error: tau = 0.072 seconds
%Midpoint method max time step for 1% error: tau = 1.475 seconds
%Since the midpoint method can have the greatest timestep for calculations
%within 1% of the theoretical value, then the midpoint method has the best
%performance of the three methods

%set method == 0 for Euler method, method == 1 for Euler-Cromer method,
%method == 2 for Midpoint method
function t = trajectory(y1, speed, theta, airFlag, tau, method)
    %% balle - Program to compute the trajectory of a baseball
    %         using the Euler method.
    help balle;  % Clear memory and print header

    %% * Set initial position and velocity of the baseball
    %y1 = input('Enter initial height (meters): ');   
    r1 = [0, y1];     % Initial vector position
    %speed = input('Enter initial speed (m/s): '); 
    %theta = input('Enter initial angle (degrees): '); 
    v1 = [speed*cos(theta*pi/180), ...
          speed*sin(theta*pi/180)];     % Initial velocity
    r = r1;  v = v1;  % Set initial position and velocity

    %% * Set physical parameters (mass, Cd, etc.)
    Cd = 0.35;      % Drag coefficient (dimensionless)
    area = 4.3e-3;  % Cross-sectional area of projectile (m^2)
    grav = 9.81;    % Gravitational acceleration (m/s^2)
    mass = 0.145;   % Mass of projectile (kg)
    %airFlag = input('Air resistance? (Yes:1, No:0): ');
    if( airFlag == 0 )
      rho = 0;      % No air resistance
    else
      rho = 1.2;    % Density of air (kg/m^3)
    end
    air_const = -0.5*Cd*rho*area/mass;  % Air resistance constant

    %% * Loop until ball hits ground or max steps completed
    %tau = input('Enter timestep, tau (sec): ');  % (sec)
    maxstep = 10000;   % Maximum number of steps
    for istep=1:maxstep

      %* Record position (computed and theoretical) for plotting
      xplot(istep) = r(1);   % Record trajectory for plot
      yplot(istep) = r(2);
      t = (istep-1)*tau;     % Current time
      xNoAir(istep) = r1(1) + v1(1)*t;
      yNoAir(istep) = r1(2) + v1(2)*t - 0.5*grav*t^2;

      %* Calculate the acceleration of the ball 
      accel = air_const*norm(v)*v;   % Air resistance
      accel(2) = accel(2)-grav;      % Gravity

      if(method == 0)
          %* Calculate the new position and velocity using Euler method
          r = r + tau*v;                 % Euler step
          v = v + tau*accel;
      elseif(method == 1)
          % calculate the new position and velocity using the Euler-Cromer
          % method
          v = v + tau*accel; %calculate v first because r_n+1 is calculated from v_n+1 in this method
          r = r + tau*v;
      else
          % calculate the new position and velocity using the midpoint
          % method
          r = r + tau*v + 0.5*(tau^2)*accel; %calculate midpoint
          v = v + tau*accel; %calculate next v
      end

      %* If ball reaches ground (y<0), break out of the loop
      if( r(2) < 0 )  
        xplot(istep+1) = r(1);  % Record last values computed
        yplot(istep+1) = r(2);
        break;                  % Break out of the for loop
      end 
    end
    
    %interpf implementation to better determine range
    lx = xplot(end:-1:length(xplot)-2); %get the last 3 x coordinates as a vector
    ly = yplot(end:-1:length(yplot)-2); %get the last 3 y coordinates as a vector
    
    r_new = intrpf(0, ly, lx); %switch x and y for interp function and use y = 0 to find range when ball hits the ground
    %when there is no air resistance, horizontal velocity is constant. So
    %the new time will be the time from the step previous, plus the
    %fraction of a time step from the second last point to the interpolated point 
    t_new = (istep-1)*tau + ((r_new - lx(2)) / (lx(1) - lx(2)))*tau;
    
    %determine maximum possible range and time
    x_max = ((2 * (speed^2)) / 9.81)*sind(theta)*cosd(theta);
    t_flight = ((2 * speed) / 9.81)*sind(theta);
    disp(100*abs(t_flight - t_new)/t_flight) %determine the percent error
    
    %determine the percent improvement by computing the difference in error
    r_diff_old = 100*abs(x_max - r(1))/x_max;
    r_diff_new = 100*abs(x_max - r_new)/x_max;
    r_improve = r_diff_old - r_diff_new; %get the percent improvement by calculating the difference in errors
    
    t_diff_old = 100*abs(t_flight - (istep*tau))/t_flight;
    t_diff_new = 100*abs(t_flight - t_new)/t_flight;
    t_improve = t_diff_old - t_diff_new; %this percentage improvement should be the same because t_new is calculated from r_new
    
    %% * Print maximum range and time of flight
    fprintf('Maximum range is %g meters\n',r_new);
    fprintf('Time of flight is %g seconds\n',t_new);

    %% * Graph the trajectory of the baseball
    figure(1); clf;    % Clear figure window #1 and bring it forward
    % Mark the location of the ground by a straight line
    xground = [0 max(xNoAir)];  yground = [0 0];
    % Plot the computed trajectory and parabolic, no-air curve
    plot(xplot,yplot,'+',xNoAir,yNoAir,'-',xground,yground,'-');
    legend('Euler method','Theory (No air)  ');
    xlabel('Range (m)');  ylabel('Height (m)');
    title('Projectile motion');
end