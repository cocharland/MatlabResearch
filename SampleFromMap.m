function [localMapInstance] = SampleFromMap(MCObj)

%localMapInstance = zeros(MCObj.height, MCObj.width);

% x = MCObj.robotPose(1);
% y = MCObj.robotPose(2);
% theta = MCObj.robotPose(3);
% if theta == 1
%     xObs = x +  MCObj.observationXVector;
%     yObs = y +  MCObj.observationYVector;
% elseif theta == 2
%     xObs = x + MCObj.observationYVector;
%     yObs = y + MCObj.observationXVector;
% elseif theta == 3
%     xObs = x + MCObj.observationXVector;
%     yObs = y - MCObj.observationYVector;
% else
%     xObs = x - MCObj.observationYVector;
%     yObs = y + MCObj.observationXVector;
% end


% for j = 1:length(xObs)
%     row = yObs(j);
%     col = xObs(j);
%     if (row <= 0 || row > MCObj.height || col <= 0 || col > MCObj.width)
%         continue;
%     end
%     %Convert from log odds to normal probs:
%     tmpOdds = 1-(1/(1+exp(MCObj.physicalMap(row,col))));
%     localMapInstance(row,col) = binornd(1,tmpOdds);
% end
tmpOdds = 1-(1./(1+exp(MCObj.physicalMap)));
localMapInstance = binornd(1,tmpOdds);

end

