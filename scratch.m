close all

mapObj = buildOccupancyMap(10,10,0.1);
particleFiltObj = MCParticle;


robotPose = [10 10 1];

poseHist = robotPose;
particleFiltObj.robotPose = robotPose;
particleFiltObj.width = 100;
particleFiltObj.height = 100;
particleFiltObj.groundTruth = mapObj.groundTruth;
particleFiltObj.physicalMap = mapObj.physicalMap-.1;
particleFiltObj.seenCells = ones(100,100);
particleFiltObj.houghDataMask = zeros(100,100);
G = digraph(false);
G.Nodes.M = 0;
G.Nodes.N = 1;

G.Nodes.actionObs = {particleFiltObj};
G.Nodes.Q = 0;
tree = G;
state = particleFiltObj;
stateHist = 
for t = 1
    
    for j = 1:200
        [total, tree] = simulate(particleFiltObj,2,tree,1);
    end
    succs = successors(tree,1);
    Q_val = table2array(tree.Nodes(succs,4));
    [val,ind] = max(Q_val);
    node = succs(ind);
    action = table2array(tree.Nodes(node,3));
    [obs,~,state] = forwardSimulate(state,action);
    
end
plot(tree)