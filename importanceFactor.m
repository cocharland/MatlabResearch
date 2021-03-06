function [particleWeight] = importanceFactor(z_t, localMap, particle)
% Takes a observarion and local map and returns how well its explained. 
%Obs is full grid, but -1 where there are no updates
correleationMap = ones(particle.height, particle.width);
truePos = 0.9;
trueNeg = 0.95;
x = particle.robotPose(1);
y = particle.robotPose(2);
theta = particle.robotPose(3);
% for j = 1:particle.height
%     for k = 1:particle.width
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
for index = 1:length(xObs)
        j = yObs(index);
        k = xObs(index);
        if ( j <= 0 || j > particle.height || k <= 0 || k > particle.width)
            continue;
        end
        if (z_t(j,k) == -1 )
            continue;
        end
        if z_t(j,k) == 1 && localMap(j,k) == 1
            correleationMap(j,k) = truePos;
        elseif z_t(j,k) == 0 && localMap(j,k) == 1
            correleationMap(j,k) = 1-truePos;
        elseif z_t(j,k) == 0 && localMap(j,k) == 0
            correleationMap(j,k) = trueNeg;
        elseif z_t(j,k) == 1 && localMap(j,k) == 0
            correleationMap(j,k) = 1-trueNeg;
        end     
end

weight = 1;
% for j = 1:particle.height
%     for k = 1:particle.width
for j = 1:length(xObs)
    row = yObs(j);
    col = xObs(j);
    if row <= 0 || row > particle.width
        continue;
    end
    if col <= 0 || col > particle.height
        continue;
    end
    weight = weight*correleationMap(row,col);
    
end
particleWeight = weight;

end

