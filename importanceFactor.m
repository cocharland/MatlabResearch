function [particleWeight] = importanceFactor(z_t, localMap, particle)
% Takes a observarion and local map and returns how well its explained. 
%Obs is full grid, but -1 where there are no updates
correleationMap = ones(particle.height, particle.width);
truePos = 0.9;
trueNeg = 0.95;
x = particle.robotPose(1);
y = particle.robotPose(2);
% for j = 1:particle.height
%     for k = 1:particle.width
z_t
for j = (y-2):y+2
    for k = (x-2):(x+2)
        if z_t(j,k) == -1
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
end
weight = 1;
% for j = 1:particle.height
%     for k = 1:particle.width
for j = (y-2):y+2
    for k = (x-2):(x+2)
        weight = weight*correleationMap(j,k);
    end
end
particleWeight = weight;

end

