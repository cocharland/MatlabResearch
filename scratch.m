close all
load('testMap.mat')
image(particleFiltObj.physicalMap,'Cdatamapping','scaled')
a = gca;
a.YDir = 'normal';

globalMap = mat2gray(particleFiltObj.physicalMap,[0 255]);
figure
image(globalMap,'Cdatamapping','scaled')
a = gca;
a.YDir = 'normal';

[H,T,R] = hough(globalMap);
P  = houghpeaks(H,20,'threshold',ceil(0.3*max(H(:))));

lines = houghlines(globalMap,T,R,P,'FillGap',25,'MinLength',3);
figure
image(particleFiltObj.physicalMap,'Cdatamapping','scaled')
a = gca;
a.YDir = 'normal';
hold on
for line = 1:20
    %grab point+angle
    current_point = lines(line).point1;
    secondary_point = lines(line).point2;
    lineTheta = lines(line).theta;
    lineRho = lines(line).rho;
    edges = [-250 250];
    
    u = (current_point-secondary_point)/norm(current_point-secondary_point);
    xy1 = current_point-250.*u;
    xy2 = current_point+250.*u;
    %yy = (lineRho-xx*cosd(lineTheta))/sind(lineTheta);
    xx = [xy1(1) xy2(1)];
    yy = [xy1(2) xy2(2)];
    
    plot(xx,yy, 'r--')
    
        

    
end

