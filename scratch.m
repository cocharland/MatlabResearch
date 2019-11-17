close all
clear all;
params = [3 4 5 6 7 3 4 5 6 7; 1/6 1/6 1/6 1/6 1/6 1/8 1/8 1/8 1/8 1/8];
particleDeaths = zeros(length(params),2);
parfor m = 1:length(params)
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
numNodes = 5000;
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

    k_0 = params(1,m);
    alpha_0 = params(2,m);
    nodesBefore_after = [];
    for t = 1:50
        t
        
        for j = 1:50
            [total, tree] = simulate(state,20,tree,rootNode,k_0,alpha_0);
        end
        succs = successors(tree,rootNode);
        Q_val = table2array(tree.Nodes(succs,4));
        [val,ind] = max(Q_val);
        node = succs(ind);
        rootNode = node;
        tree.Nodes(node,:)
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
                tree.Nodes(rootNode,:)
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
            fprintf('matched')
        else
            nodesBefore_after = [nodesBefore_after; sum(table2array(tree.Nodes(:,5))) 0];
            tree = G;
            rootNode = 1;
            
            numnodes(tree);
            
        end
        
    end
    particleDeaths(m,:) =   mean(nodesBefore_after);
end

% image(state.physicalMap,'CDataMapping','scaled')
% hold on
% plot(stateHist(:,1),stateHist(:,2),'r*')
% figure
% plot(tree)
save run_end.mat