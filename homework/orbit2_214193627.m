function result = orbit2_214193627(rx, ry, vx, vy, tau, nStep)
    %% orbit2_214193627 - Program to compute the periapsis point of an orbit.
    %By Hunter Schofield - 214193627 Version 2/11/2019
    %
    %Invoke as: orbit2_214193627(0, 9, 214193627/1e8, 214193627/1e8, 0.05, 5000);
    %Description of input parameters:
    %rx - the initial x component of position
    %ry - the initial y component of position
    %vx - the initial x component of velocity
    %vy - the initial y component of velocity
    %tau - the specified time step
    %nStep - the quantity of time steps
    help orbit2_214193627;

    %% * Set initial position and velocity of the comet.
    r = [rx ry];  v = [vx vy]; %set the initial states as required
    state = [ r(1) r(2) v(1) v(2) ];   % Used by R-K routines
    
    %if the magnitude of r increases after 1 time step, invert the timestep
    if(norm(r) + norm(v)*tau > norm(r))
        tau = -tau;
    end

    %% * Set physical parameters (mass, G*M)
    GM = 4*pi^2;      % Grav. const. * Mass of Sun (au^3/yr^2)
    mass = 1.;        % Mass of comet 
    adaptErr = 1.e-3; % Error parameter used by adaptive Runge-Kutta
    time = 0;
    
    for iStep=1:nStep  
      %* Calculate new position and velocity using rk4 method.    
      r_old = r; %set the old value of r
      state = rk4(state,time,tau,@gravrk,GM);
      r = [state(1) state(2)];   % 4th order Runge-Kutta
      v = [state(3) state(4)];
      time = time + tau;
      
      %If the radial vector magnitude goes from decreasing to increasing,
      %then the periapsis point has been found.
      if(norm(r_old) < norm(r))
          break;
      end;
    end
    
    %print out the closest approach distance using the average between the
    %last 2 determined values of r.  
    fprintf('At the closest approach, the comet is %0.2f AU from the sun.', (norm(r) + norm(r_old))/2);
return;