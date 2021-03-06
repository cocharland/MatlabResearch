function [total,tree] = simulate(state,d,nodeTree, nodeNum,k_0,alpha_0)

%State must be a MCParticle object....

% C = list of node children
% B = The list of states associated with a node
%k_0 = 15;
%alpha_0 = 1/6;
gamma = 0.95;


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
        candidateObs = cell2mat(table2array(nodeTree.Nodes(observationChildren(j),3)));
        testMat = observation == candidateObs;
        if sum(testMat,'all') == numel(observation)
           %Then obs are the same

           %What to do here?
           matched = true;
           currentNode = observationChildren(j);
           nodeTree.Nodes{currentNode,2} = nodeTree.Nodes{currentNode,2}+1; 
           break;
        end
        
    end
    if ~matched
        %Add observation node to tree
        k = find(nodeTree.Nodes.free,1,'first');
        if isempty(k)
           nodeTree =  addnode(nodeTree,1);
           nodeToChange = max(size(nodeTree.Nodes(:,1)));
        else
            nodeToChange = k;
        end
      
        nodeTmp = table(0,0,{observation},0,false,'VariableNames', { 'M', 'N', 'actionObs', 'Q','free'});
        nodeTree.Nodes(nodeToChange,:) = nodeTmp;
        %nodeTree = addnode(nodeTree,nodeTmp);
        newNodeID = nodeToChange;%
        nodeTree = addedge(nodeTree, currentNode, newNodeID);
        %Increment M
        currentNode = newNodeID; %move down the tree
        nodeTree.Nodes{currentNode,1} = nodeTree.Nodes{currentNode,1}+1;
        mNode = currentNode;

        %add state to the tree....
         k = find(nodeTree.Nodes.free,1,'first');
        if isempty(k)
           nodeTree =  addnode(nodeTree,1);
           nodeToChange = max(size(nodeTree.Nodes(:,1)));
        else
            nodeToChange = k;
        end
        nodeTmp = table(0,0,{newState},0,false,'VariableNames', { 'M', 'N', 'actionObs', 'Q', 'free'});
        nodeTree.Nodes(nodeToChange,:) = nodeTmp;
        newNodeID = nodeToChange;%
        %nodeTree = addnode(nodeTree,nodeTmp);
        %newNodeID = max(size(nodeTree.Nodes(:,1)));
        nodeTree = addedge(nodeTree, currentNode, newNodeID);
        currentNode = newNodeID; %move pointer to state node
    else
        %Increment M
        nodeTree.Nodes{currentNode,1} = nodeTree.Nodes{currentNode,1}+1;
        mNode = currentNode;
        currentNode = successors(nodeTree,currentNode); %move to state node
        
    end
    %Rollout and recursion vv
    if nodeTree.Nodes{mNode,1} == 1 %first time here, at bottom of tree...
       [total,nodeTree] = rollout(newState,nodeTree, d-1,currentNode);
       total = reward + gamma*total; 

    else %keep traversing the tree
        [total,nodeTree] = simulate(newState ,d-1,nodeTree,currentNode,k_0,alpha_0);
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
    state = table2array(nodeTree.Nodes(stateNode,3));
    [total,nodeTree] = simulate(state{1},d-1,nodeTree,stateNode,k_0,alpha_0);
    
    total = r + gamma*total;
    %compute reward
    %recursion 
end
%Compute Q
currentQ = table2array(nodeTree.Nodes(actionNode,4));
tmpQ = currentQ + (total-currentQ)/(N_ha+1);
nodeTree.Nodes(actionNode,4) = table(tmpQ);
tree = nodeTree;

end

