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

% [total,tree] = rollout(particleFiltObj,G,10,1);
% [total,tree] = rollout(particleFiltObj,tree,10,1);
% 
% cell_ = table2array(tree.Nodes(end,3));
% hold on
% image(cell_{1}.physicalMap,'CDataMapping','scaled')
% hold on
% plot(cell_{1}.robotPose(1),cell_{1}.robotPose(2),'r*')
% figure
% plot(tree)
% observationChildren = successors(tree,1);
% tree.Nodes{observationChildren,1}