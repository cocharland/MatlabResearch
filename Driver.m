%Driver
close all
runs = 25;
lengtht = 250; 
rewardRes = zeros(runs,lengtht);
parfor j = 1:runs
    j
    rewardRes(j,:) = SingleRun;
end
figure
hold on

plot(sum(rewardRes)./runs)
save('reward3.mat','rewardRes')