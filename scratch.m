close all
clear all;
mapObj = buildOccupancyMap(10,10,0.1);
particleFiltObj = MCParticle;


robotPose = [10 10 1];

poseHist = robotPose;
particleFiltObj.robotPose = robotPose;
particleFiltObj.width = 100;
particleFiltObj.height = 100;
particleFiltObj.groundTruth = mapObj.groundTruth;
particleFiltObj.physicalMap = mapObj.physicalMap;
particleFiltObj.seenCells = ones(100,100);
particleFiltObj.houghDataMask = zeros(100,100);
numNodes = 13000;
M = zeros(numNodes,1);
N = ones(numNodes,1);
Q = M;
actionObs = cell(numNodes,1);
edges = false(numNodes,numNodes);
free = true(numNodes,1);
free(1) = false;
nodes = table(M,N,actionObs,Q,free,'VariableNames', { 'M', 'N', 'actionObs', 'Q','free'});
G = digraph(edges,nodes);


tree = G;
state = particleFiltObj;
stateHist = [10 10 0];

for t = 1:10
    t
    tree = G;
    for j = 1:250
        [total, tree] = simulate(state,5,tree,1);
    end
    succs = successors(tree,1);
    Q_val = table2array(tree.Nodes(succs,4))
    [val,ind] = max(Q_val);
    node = succs(ind);
    action = table2array(tree.Nodes(node,3));
    action = action{1};
    [obs,~,state] = forwardSimulate(state,action);
    dist = 0;
    theta = state.robotPose(3);
    switch action
        case 1
            dist = 1;
        case 2
            theta = theta -1;
            
        case 3
            theta = theta + 1;
            
        case 4
            dist = 1;
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
    newState = state;
    %newState.robotPose = state.robotPose + u_t_tmp;
    %newState.robotPose(3) =  theta;
    newState = particle_filter(newState,u_t_tmp,obs);
    
    stateHist = [stateHist; newState.robotPose]; 
    state = newState;

end

image(state.physicalMap,'CDataMapping','scaled')
hold on
plot(stateHist(:,1),stateHist(:,2),'r*')
figure
plot(tree)