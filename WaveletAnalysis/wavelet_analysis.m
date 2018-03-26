% Wavelet Analysis

channel_num = dir('*CH_key*'); 
load(channel_num.name); 
num_CH = length(CH_key); 
S_mean = cell(1);
S_max = cell(1); 

for i = 1:num_CH
    [S_mean{i}, S_max{i}] = wavelet_quantify(i, num_CH, ref_times);
end


