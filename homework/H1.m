%Homework 1
%Developed by Hunter Schofield - 214193627

clc; %clear console window

%plot the top left graph
subplot(2,2,1); %prepare the first subplot
x = linspace(0, 19); %only to 19 because the image in the text only goes to x = 19
F = exp(-x/4).*sin(x); %define the funtion F
plot(x, F); %plot F w.r.t x
axis([0 20 -0.4 1]); %set the axis for the graph

%set the axis labels and tick markers
xlabel('x');
ylabel('f(x)');
xticks(0:5:20);
yticks(-0.4:0.2:1);

grid on; % turn on gridlines
title('f(x) = exp(-x/4)*sin(x)'); %Display a title

%plot the top right graph
subplot(2,2,2);
G = exp(-x/4); 
plot(x, F);
hold on;
plot(x, G);
text(6, 0.3, 'exp(-x/4)'); % add text to the second function
axis([0 20 -0.4 1]);
xlabel('x');
ylabel('f(x)');
xticks(0:5:20);
yticks(-0.4:0.2:1);
title('f(x) = exp(-x/4)*sin(x)');

%plot the bottom left graph
subplot(2,2,3);
H = exp(-x).*(sin(x).^2); 
scatter(x, H, 5, '+'); %plot a scatter plot
xlim([0 19]);
xlabel('x');
ylabel('f(x)');
set(gca, 'YScale', 'log');
grid on;
title('f(x) = exp(-x)*sin(x)^{2}');

%plot the bottom right graph
subplot(2,2,4);
x = linspace(0, 2*pi);
I = 0.5 + 0.5*sin(6*(x - pi/12));
polarplot(x, I); %plot the function in polar coordinates
rticks(0:0.5:1)
grid on;