close all
G = graph(1);
G.Nodes.M = 0
G.Nodes.N = 0;

G.Nodes.actionObs = {[0 0 0 0; 0 0 0 0]}

NodeProps = table(0, 2, 4, ...
    'VariableNames', {'M' 'N', 'actionObs'});

H = addnode(G,NodeProps)