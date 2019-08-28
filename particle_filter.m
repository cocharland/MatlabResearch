function [chi_t] = particle_filter(chi_t_minus_1, u_t, z_t)
    %Chit_t_minus_1 should be set of particles
    % a particle will end up being a theoretical map state + taget map
    % state rolled together!
    %Z_t is observation which should be a simple grid based around
    %robotpose + u_t
    numParticles = 1000;
    localMapset = [];
    chi_t_bar = [];
    chi_t = chi_t_minus_1;
    
    weight = zeros(1,numParticles);
%     numParticles = length(chi_t_minus_1);
    for j = 1:numParticles%length(chi_t_minus_1)
        %Sample for next time step
        currentParticle = chi_t_minus_1;
        %Assuming A deterministic Update of robot pose
        currentParticle.robotPose =  currentParticle.robotPose + u_t;
        localMap = SampleFromMap(currentParticle);
        localMapSet(:,:,j) = localMap;
        %Observation step:
        weight(j) = importanceFactor(z_t, localMap,currentParticle);
    end
    total = sum(weight);
    weight = weight./total;
    %plot(weight,'*')
    newParticles = randsample(numParticles,numParticles,true,weight);
    tmpMap = currentParticle.physicalMap;
    %tmpMap = zeros(currentParticle.height,currentParticle.width);
    %below collapses the particles back to probabilities. 
%     for j = 1:currentParticle.height
%         for k = 1:currentParticle.width
    x = currentParticle.robotPose(1);
    y = currentParticle.robotPose(2);
    for j = (y-2):y+2
        for k = (x-2):(x+2)
            tmpMap(j,k) = sum(localMapSet(j,k,newParticles))/numParticles;
            chi_t.physicalMap(j,k) = log(tmpMap(j,k)/(1-tmpMap(j,k)));
%             if chi_t.physicalMap(j,k) == Inf || chi_t.physicalMap(j,k) == -Inf
%                 chi_t.physicalMap(j,k) = 0;
%             end
        end
    end

end

