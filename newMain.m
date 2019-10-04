mapObj = buildOccupancyMap(10,10,0.1);
particleFiltObj = MCParticle;


robotPose = [10 10 1];
figure
poseHist = robotPose;
particleFiltObj.robotPose = robotPose;
particleFiltObj.width = 100;
particleFiltObj.height = 100;
particleFiltObj.groundTruth = mapObj.groundTruth;
particleFiltObj.physicalMap = mapObj.physicalMap;
particleFiltObj.seenCells = ones(100,100);
particleFiltObj.houghDataMask = zeros(100,100);
