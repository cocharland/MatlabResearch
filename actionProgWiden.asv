function [a,currentNode,nodeTree] = actionProgWiden(nodeTree,nodeNum)
%Controls the progressive widening of the tree
a = randsample([1 2 3 4],1);
suss = successors(nodeTree, nodeNum);
child = suss(find(cell2mat(nodeTree.Nodes(suss,:).actionObs) == a));
if isempty(child)
    nodeTmp = table(0,0,a,0,'VariableNames', { 'M' 'N', 'actionObs', 'Q'});
    nodeTree = addnode(nodeTree, nodeTmp);
    currentNode = max(size(nodeTree.Nodes));
    nodeTree = addedge(nodeTree, nodeNum,currentNode);

end


end

