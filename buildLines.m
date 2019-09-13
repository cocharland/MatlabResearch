function [lines] = buildLines(numLines, particle)
globalMap = mat2gray(particle.physicalMap,[0 255]);
[H,T,R] = hough(globalMap);
P  = houghpeaks(H,numLines,'threshold',ceil(0.3*max(H(:))));

lines = houghlines(globalMap,T,R,P,'FillGap',25,'MinLength',3);

end

