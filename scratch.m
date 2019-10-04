close all
G = digraph(false);
G.Nodes.M = 0;
G.Nodes.N = 1;

G.Nodes.actionObs = {0};
G.Nodes.Q = 0;
NodeProps = table([0 1 2 3 4 5 6 7']', [0 1 2 3 4 5 6 7]', {4,5,1,4,1,2,3,1}',[0 0 0 0 0 0 0 0]', ...
    'VariableNames', { 'M' 'N', 'actionObs','Q'});

H = addnode(G,NodeProps);
H = rmnode(H, 1);
L = G;
H = addedge(H, [1 1 1 2 2 2 2], [2 3 4 5 6 7 8]);

plot(H,'NodeLabel',cell2mat(H.Nodes.actionObs))
figure
suss = successors(H, 2);
suss(find(cell2mat(H.Nodes(suss,:).actionObs) == 5));
max(size(H.Nodes));
H.Nodes


% [V,I] = max(table2array(nodeInfo(:,2)))
% 
% suss(I)
for k = 1:20
node = 1;
for n = 1:3
    [~,node,L] = actionProgWiden(L,node);
end
end

plot(L,'NodeLabel',cell2mat(L.Nodes.actionObs))
figure
plot(L,'NodeLabel',L.Nodes.N)
