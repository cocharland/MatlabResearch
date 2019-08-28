function MC_POMDP()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
done = False;
Q = [];
numParticles = 100;
u = [1 0; -1 0; 0 1; 0 -1; 0 0];
while ~done
    for k = 1:length(u)
        Q(k) = 0;
        for j = 1:n
            %Pick random particle set
            %sample x' = p(x'|u,x)
            %sample z = p(z|x')
            %
            
            %Chi' = Particle filter(X,u,z)
            %Q(u) = 1/n *gamma*[r(x,u)+V(Chi')]
            
        end
    end
end
end

