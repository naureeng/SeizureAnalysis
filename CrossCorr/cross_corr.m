% Cross-Correlation 
% Compare IED events in Channel 1 with those in other channels

window = [-0.1 0.1];
Rs = 1250; 
load('Ch1IED.mat'); 
res_ref = IED_times(:,1).*Rs;
res_ref_ms  = res_ref./1000; 
load('NY609_Day1_Part1_IED.mat'); 
IED_new = IED(~cellfun('isempty',IED));  

num_CH = length(IED_new); 
% pre-allocate
tsOffsets = cell(1);
ts1idx = cell(1);
ts2idx = cell(1); 

for i = 1:num_CH
    [tsOffsets{i}, ts1idx{i}, ts2idx{i}] = crosscorrelogram(res_ref_ms, IED_new{i,1}*Rs./1000, window);
end
