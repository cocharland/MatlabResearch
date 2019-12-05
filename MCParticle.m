classdef MCParticle

    properties
        physicalMap
        houghDataMask
        groundTruth
        beliefMap
        width
        height
        robotPose %[x,y,dir] dir [north east south west]
        seenCells % 0 if seen, 1 if unseen
        observationYVector = [1,1,1,2,2,2,2,2,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5, ...
            6,6,6,6,6,6,6];
        observationXVector = [-1,0,1,-2,-1,0,1,2,-3,-2,-1,0,1,2,3,-4,-3,-2,-1,0,1,2,3,4,-5,-4,-3,-2,-1,0,1,2,3,4,5, ...
            -3,-2,-1,0,1,2,3];
            
    end
    
end

