function [a,currentNode,nodeTree] = actionProgWiden(nodeTree,nodeNum)
%Controls the progressive widening of the tree

%c -tree explotation param
c = 5;
%--------------------------------------------------------------------------

newNode = false;
proposedAction = randsample([1 2 3],1);%,true,[.40 .15 .15 .30]);
suss = successors(nodeTree, nodeNum);
child = suss(find(cell2mat(nodeTree.Nodes(suss,:).actionObs) == proposedAction));
if isempty(child)
    nodeTmp = table(0,1,{proposedAction},0,false,'VariableNames', { 'M', 'N', 'actionObs', 'Q','free'});
    k = find(nodeTree.Nodes.free,1,'first');
    if isempty(k)
        nodeTree =  addnode(nodeTree,1);
        nodeToChange = max(size(nodeTree.Nodes(:,1)));
    else
        nodeToChange = k;
    end
    
    nodeTree.Nodes(nodeToChange,:) = nodeTmp;
    newNodeID = nodeToChange;%
    %nodeTree = addnode(nodeTree, nodeTmp);
    %newNodeID = max(size(nodeTree.Nodes(:,1)));
    nodeTree = addedge(nodeTree, nodeNum, newNodeID);
    newNode = true;
end

if newNode
    a = proposedAction;
    currentNode = newNodeID;
else
    %Now pick which node gives largest Q
    suss = successors(nodeTree, nodeNum);
    nodeInfo = nodeTree.Nodes(suss,:);
    
    Q_Matrix = table2array(nodeInfo(:,4)); %Q(ha)
    N_ha = table2array(nodeInfo(:,2)); %N(ha)
    N_h = table2array(nodeTree.Nodes(nodeNum,2)); %N(h)
    tmp = c.*sqrt(log(N_h)./N_ha);
    tmp = Q_Matrix + tmp;
    
    [~,index] = max(tmp);
    selectedNode = suss(index);
    a = table2array(nodeTree.Nodes(selectedNode,3));
    a = a{1};
    currentNode = selectedNode;
    nodeTree.Nodes{currentNode,2} = nodeTree.Nodes{currentNode,2}+1; %Increment N(ha)
    
end
nodeTree.Nodes{nodeNum,2} = nodeTree.Nodes{nodeNum,2}+1; %Increment N(h)
end

