%% pendul - Program to compute the motion of a simple pendulum
% using the Euler or Verlet method
clear all;  help pendul      % Clear the memory and print header

%% * Select the numerical method to use: Euler or Verlet
NumericalMethod = menu('Choose a numerical method:', ...
                       'Euler','Verlet');
					   
%% * Set initial position and velocity of pendulum
theta0 = input('Enter initial angle (in degrees): ');
theta = theta0*pi/180;   % Convert angle to radians
omega = 0;               % Set the initial velocity

%% * Set the physical constants and other variables
g_over_L = 1;            % The constant g/L
time = 0;                % Initial time
irev = 0;                % Used to count number of reversals
period = [];             % Used to record period estimates
tau = input('Enter time step: ');

%% * Take one backward step to start Verlet
accel = -g_over_L*sin(theta);    % Gravitational acceleration
theta_old = theta - omega*tau + 0.5*tau^2*accel;    

%% * Loop over desired number of steps with given time step
%    and numerical method
%nstep = input('Enter number of time steps: ');

tf = 0; %turning flag
istep = 1;
while tf < 2  

  %* Record angle and time for plotting
  t_plot(istep) = theta;            
  th_plot(istep) = omega;   % Convert angle to degrees
  time = time + tau;

  %* Compute new position and velocity using 
  %    Euler or Verlet method
  accel = -g_over_L*sin(theta);    % Gravitational acceleration
  if( NumericalMethod == 1 )
    theta_old = theta;               % Save previous angle
    theta = theta + tau*omega;       % Euler method
    omega = omega + tau*accel; 
  else
    omega_old = omega; %store the old value of omega
    omega = omega + tau*accel;
    
    theta_new = 2*theta - theta_old + tau^2*accel;
    theta_old = theta;			   % Verlet method
    
    theta = theta_new;  
  end

  %* Test if the pendulum has passed through theta = 0;
  %    if yes, use time to estimate period
  
  %this condition checks to see if the sign is different between two
  %integers omega and omega_old. Roundoff error does not affect the sign
  %since it is stored in a separate byte
  if( omega*omega_old < 0 ) % Test position for sign change
    fprintf('Turning point at time t= %f \n',time);
    tf = tf + 1;

    if( irev == 0 )          % If this is the first change,
      time_old = time;       % just record the time
    else
      period(irev) = 2*(time - time_old);
      time_old = time;
    end
    irev = irev + 1;       % Increment the number of reversals
  end
  
  istep = istep + 1; %increment istep
end

%% * Estimate period of oscillation, including error bar
AvePeriod = mean(period);
ErrorBar = std(period)/sqrt(irev);
fprintf('Average period = %g +/- %g\n', AvePeriod,ErrorBar);

%% * Graph the oscillations as theta versus time
figure(1); clf;    % Clear figure window #1 and bring it forward
plot(t_plot,th_plot,'+');
xlabel('\theta (radians)');  ylabel('\omega (rad/s)');
title('Space Phase plot of pendulum with {\theta_0}=27^{\circ}')

%iv) For the Verlet plot, a time step of 0.1 is not percise enough to
%accurately display the space-phase plot. As a result, the plot records that
%the maximum angular velocity of the pendulum occurs slightly before/after
%the angle is 0. This is incorrect, however, using a more percise time step
%of 0.01 fixes this precision issue.

%v) At low initial angles such as theta = 10, the phase space plot is
%circular. At higher angles such as theta = 170, the upper and lower
%sections of the phase space plot appears to form a more distored shape,
%making a figure in a similar shape to an eye.