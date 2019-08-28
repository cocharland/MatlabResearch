function [newRobotPose] = moveRobot(mapObj, robotPose)

x = robotPose(1);
y = robotPose(2);
moveDist = 2;
motionPrim = [1 0; -1 0; 0 1; 0 -1; 0 0];
bestMove = 5;
bestValue = -500;
depth = 5;

% lowest = repmat(1:4,1,64);
% middle = repmat([repmat(1,1,4) repmat(2,1,4) repmat(3,1,4) repmat(4,1,4)],1,16);
% high   = repmat([repmat(1,1,16) repmat(2,1,16) repmat(3,1,16)  repmat(4,1,16)],1,4);
% highest = [repmat(1,1,64) repmat(2,1,64) repmat(3,1,64)  repmat(4,1,64)];
% output = [highest;high;middle;lowest];
% for 
% 
for j = 1:length(motionPrim)
    prospectiveMove = motionPrim(j,:);

    value = -500;
    pose = [x y];
    checkPose = pose + (moveDist+2).*motionPrim(j,:);
    if checkPose(1) < 1 || checkPose(2) < 1 || checkPose(1) >= mapObj.width || checkPose(2) >= mapObj.height 
        continue;
    end
    for k = 1:moveDist+2
       pose = pose + prospectiveMove;
       if mapObj.physicalMap(pose(2),pose(1)) == 0 
           value = value + 2;
       elseif mapObj.physicalMap(pose(2),pose(1)) < 0 
           value = value + 0.1;
       else 
           value = value - 100;
       end
    end
    if value > bestValue
        bestMove = j;
        bestValue = value;
    end
end
startPose = [x y];
newRobotPose = startPose + moveDist.*motionPrim(bestMove,:);

end

