function [total,tree] = simulate(state,d,nodeTree, nodeNum)

%State must be a MCParticle object....

% C = list of node children
% B = The list of states associated with a node



if d == 0
    total = 0;
    tree = nodeTree;
    return
end
[a,currentNode,nodeTree] = actionProgWiden(nodeTree,nodeNum);
actionNode = currentNode;
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
        %Increment M
        nodeTree.Nodes{currentNode,1} = nodeTree.Nodes{currentNode,1}+1;
        mNode = currentNode;
        currentNode = newNodeID; %move down the tree
        %add state to the tree....
        nodeTmp = table(0,0,{newState},0,'VariableNames', { 'M' 'N', 'actionObs', 'Q'});
        nodeTree = addnode(nodeTree,nodeTmp);
        newNodeID = max(size(nodeTree.Nodes(:,1)));
        nodeTree = addedge(nodeTree, currentNode, newNodeID);
        currentNode = newNodeID; %move pointer to state node
    else
        %Increment M
        nodeTree.Nodes{currentNode,1} = nodeTree.Nodes{currentNode,1}+1;
        mNode = currentNode;
        currentNode = successors(currentNode); %move to state node
        
    end
    %Rollout and recursion vv
    if nodeTree.Nodes{mNode,1} == 1 %first time here, at bottom of tree...
       [total,nodeTree] = rollout(newState,nodeTree, d-1,currentNode);
       total = reward + gamma*total; 
    else %keep traversing the tree
        [total,nodeTree] = simulate(newState ,d-1,nodeTree,currentNode);
        total = reward + gamma*total;
    end
else
    
    %Grab a observation already there
    M_values = nodeTree.Nodes{observationChildren,1};
    M_weights = M_values./sum(M_values);
    newNodeID = randsample(observationChildren,1,true,M_weights);
    currentNode = newNodeID;
    %grab State
    stateNode = successors(nodeTree,currentNode);
    [~,r,~] = forwardSimulate(state,a);
    state = nodeTree.Nodes(stateNode,3);
    [total,nodeTree] = simulate(state{1},d-1,nodeTree,stateNode);
    
    total = r + gamma*total;
    %compute reward
    %recursion 
end
%Compute Q
currentQ = nodeTree.Nodes(actionNode,4);
tmpQ = currentQ + (total-currentQ)/N_ha;
nodeTree.Nodes(actionNode,4) = tmpQ;
end

