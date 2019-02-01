%% ChaosRK.m - uses rk method to calculate derivatives

function deriv = chaosrk(s, t, params)
    %get the state variables
    vc1 = s(1);
    vc2 = s(2);
    il = s(3);
    
    %get the circuit parameters
    G = params(1);
    C1 = params(2);
    C2 = params(3);
    L = params(4);
    ir = params(5);
    
    %calculate the derivatives
    deriv(1) = (G / C1)*(vc2 - vc1) - (ir / C1);
    deriv(2) = (G / C2)*(vc1 - vc2) + (il / C2);
    deriv(3) = (-1)*(vc2 / L);
    
return;