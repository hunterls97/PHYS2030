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
    m0 = params(5);
    m1 = params(6);
    ir = solve_ir(vc1, 1, m0, m1); %calculate ir %use m0 + m1 for iii)
    
    %calculate the derivatives
    deriv(1) = (G / C1)*(vc2 - vc1) - (ir / C1);
    deriv(2) = (G / C2)*(vc1 - vc2) + (il / C2);
    deriv(3) = (-1)*(vc2 / L);
    
    %simple helper function to determine current through resistor
    function current = solve_ir(vc, Bp, m0, m1)
       if( vc <= -1*Bp)
           current = (-1)*m1*Bp + m0*(vc + Bp);
       elseif( abs(vc) <= Bp )
           current = m1*vc;
       elseif( vc >= Bp)
           current = m1*Bp + m0*(vc - Bp);
       end 
    return;
return;