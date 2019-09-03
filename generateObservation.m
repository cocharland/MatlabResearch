function [obsMap] = generateObservation(mapIn)

    obsMap = ones(mapIn.height,mapIn.width).*-1;
    x = mapIn.robotPose(1);
    y = mapIn.robotPose(2);
    theta = mapIn.robotPose(3);
    
    truePos = 0.9;
    trueNeg = 0.95;
    %Set observation direction
    if theta == 1
        xObs = x +  mapIn.observationXVector;
        yObs = y +  mapIn.observationYVector;
    elseif theta == 2
        xObs = x + mapIn.observationYVector;
        yObs = y + mapIn.observationXVector;
    elseif theta == 3
        xObs = x + mapIn.observationXVector;
        yObs = y - mapIn.observationYVector;
    else
        xObs = x - mapIn.observationYVector;
        yObs = y + mapIn.observationXVector;
    end

    for j = 1:length(xObs)
        row = yObs(j);
        col = xObs(j);
       % for k = yObs
            
            if row <= 0 || row > mapIn.width
                continue;
            end
            if col <= 0 || col > mapIn.height
                continue;
            end
            if mapIn.groundTruth(row,col) == 1
                obsMap(row,col) = binornd(1,truePos);
                %obsMap(row,col) = 1;
            else
                obsMap(row,col) = binornd(1,1-trueNeg);
                %obsMap(row,col) = 0;
            end
        %end
    end

end

