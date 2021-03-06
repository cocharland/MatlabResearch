function [totalReward] = SingleRun(~)
%clear all;
params = [ 6 1000 6;  1/5 1 1/5];
particleDeaths = zeros(length(params),2);
drawLines_param = [0 0 1];

mapObj = buildOccupancyMap(10,10,0.1);
particleFiltObj = MCParticle;


robotPose = [10 10 1];

poseHist = robotPose;
particleFiltObj.robotPose = robotPose;
particleFiltObj.width = 100;
particleFiltObj.height = 100;
particleFiltObj.groundTruth = mapObj.groundTruth;
particleFiltObj.physicalMap = mapObj.physicalMap-.15;
particleFiltObj.seenCells = ones(100,100);
particleFiltObj.houghDataMask = zeros(100,100);
numNodes = 15000;
M = zeros(numNodes,1);
N = ones(numNodes,1);
Q = M;
actionObs = cell(numNodes,1);
edges = false(numNodes,numNodes);
free = true(numNodes,1);
free(1) = false;
nodes = table(M,N,actionObs,Q,free,'VariableNames', { 'M', 'N', 'actionObs', 'Q','free'});
G = digraph(edges,nodes);

state = particleFiltObj;
stateHist = [10 10 0];
rootNode = 1;
tree = G;
mapEntropy = [];
%-------------------------------------------Params
k_0 = 600;
alpha_0 = 1/5;
drawLines = 0;
%------------------------------------------------
nodesBefore_after = [];
totalReward = [];
for t = 1:250
    %t/100
    for j = 1:25
        [total, tree] = simulate(state,30,tree,rootNode,k_0,alpha_0);
    end
    succs = successors(tree,rootNode);
    Q_val = table2array(tree.Nodes(succs,4));
    [val,ind] = max(Q_val);
    node = succs(ind);
    rootNode = node;
    action = table2array(tree.Nodes(node,3));
    action = action{1};
    [obs,reward,state] = forwardSimulate(state,action);
    totalReward(t) = reward;
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
    
    newState = state;
    %newState.robotPose = state.robotPose + u_t_tmp;
    %newState.robotPose(3) =  theta;
    newState = particle_filter(newState,u_t_tmp,obs);
    
    stateHist = [stateHist; newState.robotPose];
    state = newState;
    obsNodes = successors(tree,rootNode);
    matched = false;
    
    
    for j = 1:length(obsNodes)
        candidateObs = cell2mat(table2array(tree.Nodes(obsNodes(j),3)));
        testMat = obs == candidateObs;
        if sum(testMat,'all') == numel(obs)
            tree = rmedge(tree,rootNode,obsNodes(j));
            oldRoot = rootNode;
            rootNode = obsNodes(j);
            matched = true;
            break;
        end
    end
    if matched
        
        %extract nodes we care about
        tree = rmedge(tree,oldRoot,rootNode);
        nodesTokeep = conncomp(tree,'Type','weak');
        binThatMatters = nodesTokeep(rootNode);
        subTree = subgraph(tree,nodesTokeep==binThatMatters);
        nodesBefore_after = [nodesBefore_after; sum(table2array(tree.Nodes(:,5))) numnodes(subTree)];
        rootNode = 1;
        while ~isempty(predecessors(subTree,rootNode))
            rootNode = predecessors(subTree,rootNode);
        end
        rootNode = successors(subTree,rootNode);
        numNodes2 = numNodes - numnodes(subTree);
        M = zeros(numNodes2,1);
        N = ones(numNodes2,1);
        Q = M;
        actionObs = cell(numNodes2,1);
        %edges = false(numNodes,numNodes);
        free = true(numNodes2,1);
        nodes = table(M,N,actionObs,Q,free,'VariableNames', { 'M', 'N', 'actionObs', 'Q','free'});
        tree = addnode(subTree,nodes);
        
    else
        nodesBefore_after = [nodesBefore_after; sum(table2array(tree.Nodes(:,5))) 0];
        tree = G;
        rootNode = 1;
        
        numnodes(tree);
        
    end
    % Now hough transform
    if mod(t,5) == 0 && drawLines
        numlines = 10;
        state.physicalMap = state.physicalMap - state.houghDataMask;
        lines = buildLines(numlines,state);
        state.houghDataMask = zeros(100,100)-.2;
        for line = 1:length(lines) %Time to wieght the map for walls
            %grab point+angle
            current_point = lines(line).point1;
            secondary_point = lines(line).point2;
            lineTheta = lines(line).theta;
            lineRho = lines(line).rho;
            over = 0;
            for range = -15:.5:15 %find intersections
                u = (current_point-secondary_point)/norm(current_point-secondary_point);
                xy = current_point+range.*u;
                %yy = (lineRho-xx*cosd(lineTheta))/sind(lineTheta);
                yy = xy(2);
                xx = xy(1);
                if yy > 100 || yy < 1 || xx > 100 || xx < 1
                    continue;
                end
                
                state.houghDataMask(round(yy),round(xx)) =  state.houghDataMask(round(yy),round(xx))+0.15;
            end
            
        end
        state.physicalMap = state.physicalMap + state.houghDataMask;
        %image(state.physicalMap,'CDataMapping','scaled')
        %buildGif(lines,state,length(lines))
        %pause(0.1)
    end
    tmp = 1-(1./(1+exp(state.physicalMap)));
    tmp(tmp == 0) = 0.0001;
    mapEntropy(t) =  -1*sum(tmp.*log(tmp),'all');

    
end
figure
image(state.physicalMap,'CDataMapping','scaled')
hold on
for j = 1:numnodes(tree)
    nodeClass = class(tree.Nodes{:,3}{j});
    if strcmp('MCParticle',nodeClass)
       poses = tree.Nodes{j,3}{1}.robotPose;
       plot(poses(1),poses(2),'r.')
       hold on
    end
end

end
%hold on
%plot(stateHist(:,1),stateHist(:,2),'r*')
%
% image(state.physicalMap,'CDataMapping','scaled')
% hold on
% plot(stateHist(:,1),stateHist(:,2),'r*')
% figure
% plot(tree)
%save run_end1.mat
