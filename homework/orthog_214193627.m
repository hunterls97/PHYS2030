%% orthog - Program to test if a pair of vectors 
% is orthogonal.  Assumes vectors are in Rn space
clear all;  help orthog;   % Clear the memory and print header
%% * Initialize the vectors a and b
a = input('Enter the first vector: ');
b = input('Enter the second vector: ');

%check to ensure vectors are same size
if(ne(size(a,2),size(b,2)))
    disp('vectors must be the same size or dot product is undefined');
    return;
end;

%% * Evaluate the dot product as sum over products of elements
a_dot_b = 0;
for i=1:length(a) %iterate for every element in a to determine dot product for vectors in any dimension
  a_dot_b = a_dot_b + a(i)*b(i);
end

%% * Print dot product and state whether vectors are orthogonal
if( a_dot_b == 0 && not(all(a == 0) || all(b == 0))) %check if the dot product is zero AND both input vectors are nonzero vectors
  disp('Vectors are orthogonal');
else
  disp('Vectors are NOT orthogonal');
  fprintf('Dot product = %g \n',a_dot_b);
end