function [value] = simulate(state,d,nodeTree, nodeNum)

%State must be a MCParticle object....

% C = list of node children
% B = The list of states associated with a node

if d == 0
    value = 0;
    return
end
[a,currentNode,nodeTree] = actionProgWiden(nodeTree,nodeNum);

observationChildren = successors(nodeTree, currentNode);
N_ha = nodeTree.Nodes{currentNode,2}-1;
if length(observationChildren) <= k_0*N_ha^alpha_0 %Probably need workshoping
    
    [observation, reward, newState] = forwardSimulate(state,a);
    %Need to see if observation is unique or not
    
    %Add observation node to tree
    
    %Increment M
    
    %Add s to state tree
    
    %Rollout/recursion
    
else
    %Grab a observstion already there
    %Grab state
    %compute reward
    %recursion
    
    
    
    
    
end

end

