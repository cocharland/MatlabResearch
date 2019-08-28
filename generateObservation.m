function [obsMap] = generateObservation(mapIn)

    obsMap = ones(mapIn.height,mapIn.width).*-1;
    x = mapIn.robotPose(1);
    y = mapIn.robotPose(2);
    truePos = 0.9;
    trueNeg = 0.95;
    for j = (x-2):(x+2)
        for k = (y-2):(y+2)
            if j <= 0 || j > mapIn.width
                continue;
            end
            if k <= 0 || k > mapIn.height
                continue;
            end
            if mapIn.groundTruth(k,j) == 1
                obsMap(k,j) = binornd(1,truePos);
                %obsMap(k,j) = 1;
            else 
                obsMap(k,j) = binornd(1,1-trueNeg);
                %obsMap(k,j) = 0;
            end
            
        end
    end
end

