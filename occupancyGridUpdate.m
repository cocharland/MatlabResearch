function [updatedMap] = occupancyGridUpdate(robotPose,mapObj)

%For all cells
% TODO: 45 deg cone
pOcc = 0.95;
pFree = 0.01;
oldMap = mapObj.physicalMap;
x = robotPose(1);
y = robotPose(2);

for j = (x-2):(x+2)
    for k = (y-2):(y+2)
        if j <= 0 || j > mapObj.width
            continue;
        end
        if k <= 0 || k > mapObj.height
            continue;
        end
        %Now in section to be updated
        %Generate observation
        if mapObj.groundTruth(k,j) == 1 %is occupied 
            inverseModel = log(pOcc/(1-pOcc));
        else
            inverseModel = log(pFree/(1-pFree));
        end
        oldMap(k,j) = oldMap(k,j)+inverseModel;
    end
end

updatedMap = mapObj;
updatedMap.physicalMap = oldMap;

end

