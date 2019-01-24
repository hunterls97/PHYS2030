%% orbit - Program to compute the orbit of a comet.
clear all;  help orbit;  % Clear memory and print header

%% * Set initial position and velocity of the comet.
r0 = input('Enter initial radial distance (AU): ');  
v0 = input('Enter initial tangential velocity (AU/yr): ');
r = [r0 0];  v = [0 v0];
state = [ r(1) r(2) v(1) v(2) ];   % Used by R-K routines

%% * Set physical parameters (mass, G*M)
GM = 4*pi^2;      % Grav. const. * Mass of Sun (au^3/yr^2)
mass = 1.;        % Mass of comet 
adaptErr = 1.e-3; % Error parameter used by adaptive Runge-Kutta
time = 0;

%calculate the force exerted on the comet by the distant mass
F = 0.01 * GM * mass / (r0^2); %external force

%% * Loop over desired number of steps using specified
%  numerical method.
nStep = input('Enter number of steps: ');
tau = input('Enter time step (yr): '); 
NumericalMethod = menu('Choose a numerical method:', ...
       'Euler','Euler-Cromer','Runge-Kutta','Adaptive R-K');
for iStep=1:nStep  

  %* Record position and energy for plotting.
  rplot(iStep) = norm(r);           % Record position for polar plot
  thplot(iStep) = atan2(r(2),r(1));
  tplot(iStep) = time;
  kinetic(iStep) = .5*mass*norm(v)^2;   % Record energies
  potential(iStep) = - GM*mass/norm(r);
  
  %* Calculate new position and velocity using desired method.
  if( NumericalMethod == 1 )
    accel = -GM*r/norm(r)^3;   
    r = r + tau*v;             % Euler step
    v = v + tau*accel; 
    time = time + tau;   
  elseif( NumericalMethod == 2 )
    accel = -GM*r/norm(r)^3;   
    v = v + tau*accel; 
    r = r + tau*v;             % Euler-Cromer step
    time = time + tau;     
  elseif( NumericalMethod == 3 )
    state = rk4(state,time,tau,@gravrk,GM);
    
    %%update the velocity by computing the acceleration (a = F/m) due to the 
    %third body and adding it to the veloctiy of the comet. Need to
    %multiply by tau to scale the acceleration to be over one time step
    state(3) = state(3) + (F/mass)*cosd(30)*tau;
    state(4) = state(4) + (F/mass)*sind(30)*tau;
    
    r = [state(1) state(2)];   % 4th order Runge-Kutta
    v = [state(3) state(4)];
    time = time + tau; 
  else
    [state time tau] = rka(state,time,tau,adaptErr,@gravrk,GM);
    r = [state(1) state(2)];   % Adaptive Runge-Kutta
    v = [state(3) state(4)];
  end
  
end

%% * Graph the trajectory of the comet.
figure(1); clf;  % Clear figure 1 window and bring forward
polar(thplot,rplot);  % Use polar plot for graphing orbit
hold on;
quiver(0, 0, 2*r0*cosd(30), 2*r0*sind(30)); %plot a vector in the same direction as the external force
xlabel('Distance (AU)');  grid;
title('Skewed Orbit due to Third Body at 30^{\circ}');
legend('orbit', 'external force vector')
pause(1)   % Pause for 1 second before drawing next plot

%% * Graph the energy of the comet versus time.
figure(2); clf;   % Clear figure 2 window and bring forward
totalE = kinetic + potential;   % Total energy
plot(tplot,kinetic,'-.',tplot,potential,'--',tplot,totalE,'-')
legend('Kinetic','Potential','Total');
xlabel('Time (yr)'); ylabel('Energy (M AU^2/yr^2)');