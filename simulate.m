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
    numChildren = length(observationChildren);
    matched = false;
    for j = 1:numChildren
        %Extract observation
        candidateObs = cell2mat(table2array(nodeTree.Nodes(observationChildren,3)));
        testMat = observation == candidateObs;
        if sum(testMat,'all') == numel(observation)
           %Then obs are the same
           fprintf('obs same')
           %What to do here?
           matched = true;
           currentNode = observationChildren(j);
           nodeTree.Nodes{currentNode,2} = nodeTree.Nodes{currentNode,2}+1; 
        end
        
    end
    if ~matched
        %Add observation node to tree
        nodeTmp = table(0,0,{observation},0,'VariableNames', { 'M' 'N', 'actionObs', 'Q'});
        nodeTree = addnode(nodeTree,nodeTmp);
        newNodeID = max(size(nodeTree.Nodes(:,1)));
        nodeTree = addedge(nodeTree, currentNode, newNodeID);
        currentNode = newNodeID; %move down the tree
        %add state to the tree....
        nodeTmp = table(0,0,{newState},0,'VariableNames', { 'M' 'N', 'actionObs', 'Q'});
        nodeTree = addnode(nodeTree,nodeTmp);
        newNodeID = max(size(nodeTree.Nodes(:,1)));
        nodeTree = addedge(nodeTree, currentNode, newNodeID);
    else
        currentNode = successors(currentNode); %move to state node
        
    end
    %Increment M
    nodeTree.Nodes{currentNode,1} = nodeTree.Nodes{currentNode,1}+1; 
    if nodeTree.Nodes{currentNode,1} == 1
       total = reward + gamma*rollout(newState,nodeTree, d-1); 
    end
    
    %Rollout/recursion
    
else
    %Grab a observstion already there
    %Grab state
    %compute reward
    %recursion
    
    
    
    
    
end

end

