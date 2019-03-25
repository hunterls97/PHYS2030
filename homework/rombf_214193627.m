function R = rombf_214193627(a,b,N,func,param)
    %% rombf_214193627.m - Error function integrand
    %Developed by Hunter Schofield - 214193627, version 3/14/2019
    %
    %Invoke as rombf_214193627(0, 2*pi, 8, 'errintg_214193627', [])
    %
    % Based on a program from Prof. Alejandro Garcia
    % https://github.com/AlejGarcia/NM4P/tree/master/MatlabRevised
    %
    %Description of Input Parameters:
    %a = lower bound of integral
    %b = upper bound of integral
    %N = NxN Romberg table
    %func = Name of integrand function as a string
    %param = Set of parameters passed to this function
    %
    %Answer to roundoff error question:
    %For small values of i, the error doesn't decrease because the sine
    %term is 0 for all multiples of pi, it isn't until h is small enough to
    %produce a pi/4 term when multiplied by 8 that the Romberg solutions
    %returns a non-zero value. The first column where roundoff error can be
    %seen is column 15 where the error grows from 1.131e-13% in column 14
    %to 2.073e-13% in column 15.
 
    %* Compute the first term R(1,1)
    h = b - a;           % This is the coarsest panel size
    np = 1;              % Current number of panels
    f = str2func(func);  % Convert name into function handle
    R(1,1) = h/2 * (f(a,param) + f(b,param));
    
    actual = 2.356194490192345; %the actual value of the integral (from symbolab)
    error(1) = 100*abs((actual - R(1,1))/actual); %compute the error ar R(1,1)

    %* Loop over the desired number of rows, i = 2,...,N
    for i=2:N

      %* Compute the summation in the recursive trapezoidal rule
      h = h/2;          % Use panels half the previous size
      np = 2*np;        % Use twice as many panels
      sumT = 0;
      
      for k=1:2:np-1    % This for loop goes k=1,3,5,...,np-1
        sumT = sumT + f(a + k*h, param);
      end

      %* Compute Romberg table entries R(i,1), R(i,2), ..., R(i,i)
      R(i,1) = 1/2 * R(i-1,1) + h * sumT;   
      m = 1;
      for j=2:i
        m = 4*m;
        R(i,j) = R(i,j-1) + (R(i,j-1) - R(i-1,j-1))/(m-1);
      end
      
      error(i) = 100*abs((actual - R(i,i))/actual); %compute the error at R(i,i)
    end
    
    %plot the error
    figure(1); clf;
    semilogy([1:N], error, 'b-');
    title('Hunter Schofield - Romberg Percentage error vs Number of Columns');
    xlabel('Row');
    ylabel('Percent Error');
    ylim([-100 100]);
return;