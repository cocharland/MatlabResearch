function [obsMap] = generateObservation(particle)

    obsMap = ones(particle.height,particle.width).*-1;
    x = particle.robotPose(1);
    y = particle.robotPose(2);
    theta = particle.robotPose(3);
    
    truePos = 0.975;
    trueNeg = 0.975;
    %Set observation direction
    if theta == 1
        xObs = x +  particle.observationXVector;
        yObs = y +  particle.observationYVector;
    elseif theta == 2
        xObs = x + particle.observationYVector;
        yObs = y + particle.observationXVector;
    elseif theta == 3
        xObs = x + particle.observationXVector;
        yObs = y - particle.observationYVector;
    else
        xObs = x - particle.observationYVector;
        yObs = y + particle.observationXVector;
    end

    for j = 1:length(xObs)
        row = yObs(j);
        col = xObs(j);
       % for k = yObs
            
            if row <= 0 || row > particle.width
                continue;
            end
            if col <= 0 || col > particle.height
                continue;
            end
            if particle.groundTruth(row,col) == 1
                obsMap(row,col) = binornd(1,truePos);

            else
                obsMap(row,col) = binornd(1,1-trueNeg);

            end
        %end
    end

end

