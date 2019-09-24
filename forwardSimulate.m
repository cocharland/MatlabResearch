function [observation,reward, newState] = forwardSimulate(state, action)
newState = state;
x = state.robotPose(1);
y = state.robotPose(2);
theta = state.robotPose(3);
u_t_tmp = [ 0 0 0];
dist = 0;
switch action
    case 1
        dist = 1;
    case 2
        theta = theta -1;
    case 3
        theta = theta + 1;
    case 4
        dist = 2;
end
if theta > 4
    theta = 1;
elseif theta < 1
    theta = 4;
end
switch theta
    case 1
        u_t_tmp = [0 dist 0];
    case 2
        u_t_tmp = [dist 0 0];
    case 3
        u_t_tmp = [0 -dist 0];
    case 4
        u_t_tmp = [-dist 0 0];
end
newState.robotPose = state.robotPose + u_t_tmp;

%TODO Progrssive Widen Observation Space::
observation = generateObservation(newState);

%Reward Mapping:
visionReward = sum(newState.seenCells(find(observation >= 0))); 
if state.physicalMap(y,x) > 0.3
    impactReward = -100;
else
    impactReward = 0;
end
reward = visionReward+impactReward;



end
