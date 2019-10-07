function [total,tree] = rollout(state,nodeTree,d,currentNode)
gamma = 0.95;
if d == 0
    total = 0;
    tree = nodeTree;
    return;
end
action =  randsample([1 2 3 4],1);
[observation,reward,newState] = forwardSimulate(state,action);

nodeTmp = table(0,1,{action},0,'VariableNames', { 'M' 'N', 'actionObs', 'Q'});
nodeTree = addnode(nodeTree, nodeTmp);
newNodeID = max(size(nodeTree.Nodes(:,1)));
nodeTree = addedge(nodeTree, currentNode, newNodeID);
currentNode = newNodeID;
    
nodeTmp = table(0,0,{observation},0,'VariableNames', { 'M' 'N', 'actionObs', 'Q'});
nodeTree = addnode(nodeTree,nodeTmp);
newNodeID = max(size(nodeTree.Nodes(:,1)));
nodeTree = addedge(nodeTree, currentNode, newNodeID);
currentNode = newNodeID; %move down the tree

nodeTmp = table(0,0,{newState},0,'VariableNames', { 'M' 'N', 'actionObs', 'Q'});
nodeTree = addnode(nodeTree,nodeTmp);
newNodeID = max(size(nodeTree.Nodes(:,1)));
nodeTree = addedge(nodeTree, currentNode, newNodeID);
currentNode = newNodeID; %move down the tree
tree = nodeTree;


[total,tree] = rollout(newState,nodeTree,d-1,currentNode);

total = reward+gamma*total;


end
