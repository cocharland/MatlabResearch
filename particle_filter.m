function [chi_t] = particle_filter(chi_t_minus_1, u_t, z_t)
    %Chit_t_minus_1 should be set of particles
    % a particle will end up being a theoretical map state + taget map
    % state rolled together!
    %Z_t is observation which should be a simple grid based around
    %robotpose + u_t
    numParticles = 300;
    localMapset = zeros(100,100,numParticles);
    chi_t_bar = [];
    chi_t = chi_t_minus_1;
    
    weight = zeros(1,numParticles);
%     numParticles = length(chi_t_minus_1);
currentParticle = chi_t_minus_1;
%Assuming A deterministic Update of robot pose
currentParticle.robotPose =  currentParticle.robotPose + u_t;
tmpOdds = 1-(1./(1+exp(currentParticle.physicalMap)));
% 
% localMapSet = binornd(1,tmpOdds);
% 
%     for j = 1:numParticles%length(chi_t_minus_1)
%         %Sample for next time step
% % 
% %         localMap = SampleFromMap(currentParticle);
% %         localMapSet(:,:,j) = localMap;
%         %Observation step:
%         localMap = localMapSet(:,:,j);
%         weight(j) = importanceFactor(z_t, localMap,currentParticle);
%     end
%     total = sum(weight);
%     weight = weight./total;
%     newParticles = randsample(numParticles,numParticles,true,weight);
%     tmpMap = currentParticle.physicalMap;
 tmpMap = tmpOdds;
    %below collapses the particles back to probabilities. 
%     for j = 1:currentParticle.height
%         for k = 1:currentParticle.width
    x = currentParticle.robotPose(1);
    y = currentParticle.robotPose(2);
    theta = currentParticle.robotPose(3);
    if theta == 1
        xObs = x +  currentParticle.observationXVector;
        yObs = y +  currentParticle.observationYVector;
    elseif theta == 2
        xObs = x + currentParticle.observationYVector;
        yObs = y + currentParticle.observationXVector;
    elseif theta == 3
        xObs = x + currentParticle.observationXVector;
        yObs = y - currentParticle.observationYVector;
    else
        xObs = x - currentParticle.observationYVector;
        yObs = y + currentParticle.observationXVector;
    end

    for j = 1:length(xObs)
        row = yObs(j);
        col = xObs(j);
        if (row <= 0 || row > currentParticle.height || col <= 0 || col > currentParticle.width)
            continue;
        end
        if z_t(row,col) == 0
            tmpMap(row,col) =  tmpMap(row,col)-.2;
        elseif z_t(row,col) == 1
            tmpMap(row,col) =  tmpMap(row,col)+.2;
        else
            continue;
        end
        if tmpMap(row,col) > 1
            tmpMap(row,col) = 1;
        elseif tmpMap(row,col) < 0
            tmpMap(row,col) = 0;
        end

        chi_t.physicalMap(row,col) = log(tmpMap(row,col)/(1-tmpMap(row,col)));
    end

end

