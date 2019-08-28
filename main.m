function main()
%Main Driver function for mapping splashing

%TODO:
%Build physical map 
%Build Robot to traverse
%Observation Step
close all
mapObj = buildOccupancyMap(10,10,0.1);
particleFiltObj = MCParticle;

image(mapObj.groundTruth,'Cdatamapping','scaled')
a = gca;
a.YDir = 'normal';
cMap = [1 1 1; 0 0 0;];
colormap(cMap)
robotPose = [10 10];
poseHist = robotPose;
particleFiltObj.robotPose = robotPose;
particleFiltObj.width = 100;
particleFiltObj.height = 100;
particleFiltObj.groundTruth = mapObj.groundTruth;
particleFiltObj.physicalMap = mapObj.physicalMap;
particleFiltObj.seenCells = ones(100,100);
figure
robotPoses = [ones(1,19).*4; 4:5:95]';

for k = 6:5:95
    robotPoses = vertcat(robotPoses, [ones(1,19).*k; 4:5:95]');
end
robotPoses = [robotPoses; robotPoses];
%robotPoses = [10 10; 10 11; 10 12; 10 13; 10 14; 10 15; 10 16; 10 17; 10 18; 10 19; 10 20; 10 21; 10 22; 10 23;];
size(robotPoses)
hold on
for t = 2%:721
    %mapObj = occupancyGridUpdate(robotPose,mapObj);
    robotPose = robotPoses(t,:);%moveRobot(mapObj,robotPose);
    poseHist = [poseHist; robotPose]; 
    if robotPose(1) > 100 || robotPose(2) > 100 || robotPose(1) <= 0 || robotPose(2) <= 0
        break
    end
    particleFiltObj.robotPose = robotPose;
    observation = generateObservation(particleFiltObj);
    particleFiltObj = particle_filter(particleFiltObj,robotPose-poseHist(t,:),observation);

    t/722*100
    
end

figure
image(particleFiltObj.physicalMap,'Cdatamapping','scaled')
a = gca;
a.YDir = 'normal';
hold on
plot(poseHist(1,:),poseHist(2,:),'r--')
plot(particleFiltObj.observationXVector+50,particleFiltObj.observationYVector+50,'k*')
figure 
image(mapObj.physicalMap,'Cdatamapping','scaled')


end

