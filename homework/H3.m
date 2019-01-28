%Homework 3
%Developed by Hunter Schofield - 214193627

%Answers to Friday's content outline
%A1) 7.2574e+306
%A2) Infinity, this is not actually correct.
%A3) for log(170!) = 706.5731, log(171) = 711.7147
%A4) 4.487604e+5834
%A5.i) 9.7656e-04
%A5.ii) 7.979e-03
%B1) 2.2204e-16

%factorial functions developed for parts in A
%{
function nf = newfac(n)
    lf = logfac(n); %get log(n!)
    exponent = fix(lf*log10(exp(1))); %determine the exponential component
    mantissa = 10^(lf*log10(exp(1)) - exponent); %determine the mantissa component
    
    fprintf('%1.6fe+%0.0f', mantissa, exponent); %display the result
end

function lf = logfac(n)
    lf = (1/2)*log(2*n*pi) + n*log(n) - n + log(1 + (1/(12*n)) + (1/(288*n^2)));
end
%}

%Exercise 1.26
%The approximation is better with the identity because the summation with
%the identity converges to e faster for positive values. This means the 
%absolute fractional error goes to zero faster using this method.
clc;

n = [1:60]; 
e = s(-10, Inf); %setup summation for part a
e_inv = 1/s(10, Inf); %setup summation identity for part b
y = [];
y2 = [];

for i = 1:1:60
    y(i) = abs(s(-10,i) - e)/e; %part a, determine y without identity
    y2(i) = abs((1/s(10, i)) - e_inv)/e_inv; %part b, determine y with identity
end

scatter(n,y); %plot part a
hold on;
scatter(n,y2, 5, '+'); %plot part b
set(gca, 'YScale', 'log');

%Simple function to approximate e as a summation
function e = s(x,n)
    syms k
    e = vpa(symsum((x^k)/(factorial(k)), k, 0, n), 6);
end