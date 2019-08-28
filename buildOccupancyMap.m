function [mapOut] = buildOccupancyMap(width,height,gridDimension)
%10mx10m @ 10cm/box resolution
mapOut = mapSet;
mapOut.width = width/gridDimension;
mapOut.height = height/gridDimension;

mapOut.physicalMap = zeros(height/gridDimension,width/gridDimension);
mapOut.groundTruth = imread('map.bmp');

end

