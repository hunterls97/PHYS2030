%% interp - Program to interpolate data using Lagrange 
% polynomial to fit quadratic to three data points
clear all; help interp;  % Clear memory and print header
%% * Initialize the data points to be fit by quadratic
disp('Enter data points as x,y pairs (e.g., [1 2])');
x = []; %define x
y = []; %define y
for i=1:3
  temp = input('Enter data point: ');
  
  %determines if a point already exists and exits if it does
  if(ismember(temp(1), x) && ismember(temp(2), y))
       disp('this point already exists');
       return;
  end
  
  x(i) = temp(1);
  y(i) = temp(2);
end

%determines if all points lie on the same vertical and returns if they do
if(x(1) == x(2) && x(2) == x(3))
    disp('all points like on the same vertical, please enter different values');
    return;
end

%% * Establish the range of interpolation (from x_min to x_max)
xr = input('Enter range of x values as [x_min x_max]: ');
%% * Find yi for the desired interpolation values xi using
%  the function intrpf
nplot = 100;     % Number of points for interpolation curve
for i=1:nplot
  xi(i) = xr(1) + (xr(2)-xr(1))*(i-1)/(nplot-1);
  yi(i) = intrpf(xi(i),x,y);  % Use intrpf function to interpolate
end
%% * Plot the curve given by (xi,yi) and mark original data points
plot(x,y,'*',xi,yi,'-');
xlabel('x');
ylabel('y');
title('Three point interpolation');
legend('Data points','Interpolation  ');