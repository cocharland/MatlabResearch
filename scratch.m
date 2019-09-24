close all
G = digraph(true);
G.Nodes.M = 0;
G.Nodes.N = 0;

G.Nodes.actionObs = {[0 0 0 0; 0 0 0 0]};

NodeProps = table([0 1 2 3 4 5 6 7']', [0 1 2 3 4 5 6 7]', {4,5,1,4,1,2,3,1}', ...
    'VariableNames', { 'M' 'N', 'actionObs'});

H = addnode(G,NodeProps);
H = rmnode(H, 1);
H = addedge(H, [1 1 1 2 2 2 2], [2 3 4 5 6 7 8]);

plot(H)
suss = successors(H, 2);
suss(find(cell2mat(H.Nodes(suss,:).actionObs) == 5))
max(size(H.Nodes))