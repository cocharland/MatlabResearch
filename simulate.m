function [value] = simulate(state,h,d,C,B)
%h = history cell array in [b, {a} {o}] order
%C = list of node children
% B = The list of states associated with a node
if d == 0
    value = 0;
    return
end
a = randsample([1 2 3 4],1);
C{length(C)+1} = a;
if length(C) <= k_0*N(ha)^alpha_0 %Probably need workshoping
    
    [observation, reward, newState] = forwardSimulate(state,a);
    C{length(C)+1} = observation;
    
    
    
    
end

end

