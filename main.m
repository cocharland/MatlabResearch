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
robotPose = [10 10 1];
poseHist = robotPose;
particleFiltObj.robotPose = robotPose;
particleFiltObj.width = 100;
particleFiltObj.height = 100;
particleFiltObj.groundTruth = mapObj.groundTruth;
particleFiltObj.physicalMap = mapObj.physicalMap;
particleFiltObj.seenCells = ones(100,100);



for t = 1:50
    poseHist = [poseHist; robotPose]; 
    if robotPose(1) > 100 || robotPose(2) > 100 || robotPose(1) <= 0 || robotPose(2) <= 0
        break
    end
    u_t_tmp = [ 0 0 0];
    if mod(t,15) == 0
        particleFiltObj.robotPose(3) = randsample([1 2 3 4],1);
    end
    switch particleFiltObj.robotPose(3)
        case 1
            u_t_tmp = [0 1 0];
        case 2
            u_t_tmp = [1 0 0];
        case 3
            u_t_tmp = [0 -1 0];
        case 4
            u_t_tmp = [-1 0 0];
    end

    tmp_pose = particleFiltObj.robotPose + u_t_tmp;
    if (mapObj.groundTruth(tmp_pose(2),tmp_pose(1)) == 1)
        dir = randsample([-1 1],1);
        
            
        u_t_tmp = [0 0 dir];
        
        tmp_pose = particleFiltObj.robotPose + u_t_tmp;
        if tmp_pose(3) > 4
            tmp_pose(3) = 1;
        elseif tmp_pose(3) < 1
            tmp_pose(3) = 4;
        end
    end
    robotPose = tmp_pose;
    particleFiltObj.robotPose = tmp_pose;
    observation = generateObservation(particleFiltObj);

    particleFiltObj = particle_filter(particleFiltObj,u_t_tmp,observation);

    lines = buildLines(20,particleFiltObj);
    buildGif(lines, particleFiltObj,t);
    
end

figure
image(particleFiltObj.physicalMap,'Cdatamapping','scaled')
a = gca;
a.YDir = 'normal';
hold on
plot(poseHist(:,1),poseHist(:,2),'g--')



max_len = 0;

for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end

end

