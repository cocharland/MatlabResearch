close all
mapObj = buildOccupancyMap(10,10,0.1);
particleFiltObj = MCParticle;

image(mapObj.groundTruth,'Cdatamapping','scaled')
a = gca;
a.YDir = 'normal';
cMap = [1 1 1; 0 0 0;];
colormap(cMap)
robotPose = [10 10 1];
poseHist = robotPose;
particleFiltObj.robotPose = robotPose;
particleFiltObj.width = 100;
particleFiltObj.height = 100;
particleFiltObj.groundTruth = mapObj.groundTruth;
particleFiltObj.physicalMap = mapObj.physicalMap;
particleFiltObj.seenCells = ones(100,100);

hold = binornd(1,particleFiltObj.physicalMap);
figure 

image(hold,'Cdatamapping','scaled')
a = gca;
a.YDir = 'normal';