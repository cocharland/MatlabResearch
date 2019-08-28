classdef MCParticle

    properties
        physicalMap
        groundTruth
        beliefMap
        width
        height
        robotPose %[x,y,dir] 
        seenCells
        observationYVector = [1,2,2,2,3,3,3,3,3,4,4,4,4,4,4,4,5,5,5,5,5,5,5, ...
            6,6,6,6,6];
        observationXVector = [0,-1,0,1,-2,-1,0,1,2,-3,-2,-1,0,1,2,3,-3,-2,-1,0,1,2,3, ...
            -2,-1,0,1,2];
            
    end
    
%     methods
%         function obj = untitled9(inputArg1,inputArg2)
%             %UNTITLED9 Construct an instance of this class
%             %   Detailed explanation goes here
%             obj.Property1 = inputArg1 + inputArg2;
%         end
%         
%         function outputArg = method1(obj,inputArg)
%             %METHOD1 Summary of this method goes here
%             %   Detailed explanation goes here
%             outputArg = obj.Property1 + inputArg;
%         end
%     end
end

