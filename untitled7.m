lowest = repmat(1:4,1,64)
middle = repmat([repmat(1,1,4) repmat(2,1,4) repmat(3,1,4) repmat(4,1,4)],1,16);
high   = repmat([repmat(1,1,16) repmat(2,1,16) repmat(3,1,16)  repmat(4,1,16)],1,4);
highest = [repmat(1,1,64) repmat(2,1,64) repmat(3,1,64)  repmat(4,1,64)]
output = [highest;high;middle;lowest]