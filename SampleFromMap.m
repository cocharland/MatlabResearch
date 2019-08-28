function [localMapInstance] = SampleFromMap(MCObj)

localMapInstance = zeros(MCObj.height, MCObj.width);

x = MCObj.robotPose(1);
y = MCObj.robotPose(2);
% for j = 1:MCObj.width
%     for k = 1:MCObj.width
for j = (x-2):(x+2)
    for k = (y-2):(y+2)
        %Convert from log odds to normal probs:
        tmpOdds = 1-(1/(1+exp(MCObj.physicalMap(k,j))));
        localMapInstance(k,j) = binornd(1,tmpOdds);
        
    end
end


end

