function main()
%Main Driver function for mapping splashing

%TODO:
%Build physical map 
%Build Robot to traverse
%Observation Step
close all
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



for t = 1:1000
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
    if mod(t,20) == 0
        numlines = round(t/10);
        if numlines > 10
            numlines = 10;
        end
        particleFiltObj.physicalMap = particleFiltObj.physicalMap - particleFiltObj.houghDataMask;
        lines = buildLines(numlines,particleFiltObj);
        buildGif(lines, particleFiltObj,t-19);
        particleFiltObj.houghDataMask = zeros(100,100)-.2;
        for line = 1:numlines %Time to wieght the map for walls
           %grab point+angle
           current_point = lines(line).point1;
           secondary_point = lines(line).point2;
           lineTheta = lines(line).theta;
           lineRho = lines(line).rho;
           over = 0;
           for range = -25:.5:25 %find intersections
               u = (current_point-secondary_point)/norm(current_point-secondary_point);
               xy = current_point+range.*u;
               %yy = (lineRho-xx*cosd(lineTheta))/sind(lineTheta);
               yy = xy(2);
               xx = xy(1);
               if yy > 100 || yy < 1 || xx > 100 || xx < 1
                   continue;
               end
               
               particleFiltObj.houghDataMask(round(yy),round(xx)) =  particleFiltObj.houghDataMask(round(yy),round(xx))+0.25;
           end
 
        end
        particleFiltObj.physicalMap = particleFiltObj.physicalMap + particleFiltObj.houghDataMask;
    end
    t/1000
end
figure(69)
xlim([0 100])
ylim([0 100])
figure(2)
image(particleFiltObj.physicalMap,'Cdatamapping','scaled')
a = gca;
a.YDir = 'normal';
hold on
plot(poseHist(:,1),poseHist(:,2),'g--')

save testMap.mat particleFiltObj
figure

image(mapObj.groundTruth,'Cdatamapping','scaled')
a = gca;
a.YDir = 'normal';
cMap = [1 1 1; 0 0 0;];
colormap(cMap)
% max_len = 0;
% 
% for k = 1:length(lines)
%    xy = [lines(k).point1; lines(k).point2];
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% 
%    % Plot beginnings and ends of lines
%    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
% 
%    % Determine the endpoints of the longest line segment
%    len = norm(lines(k).point1 - lines(k).point2);
%    if ( len > max_len)
%       max_len = len;
%       xy_long = xy;
%    end
% end

end

