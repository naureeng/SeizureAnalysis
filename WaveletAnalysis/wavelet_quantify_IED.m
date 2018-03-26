% Objective: Sum powers in 40-80 frequency band

function [S_mean, S_max] = wavelet_quantify_IED(test_CH)

filename = dir('*.lfp');
[~, ~, ~] = fileparts(filename.name);
channel_num = dir('*CH_key*'); 
load(channel_num.name); 
num_CH = length(CH_key); 

% provide matrix of IED times in Channel 1 to analyze data of all channels
% at these times only 
% res_file = dir('*Ch1IED*');
load(res_file.name);
IED_times = IED; 

Rs = 1250; 
if length(IED_times) > 200
    res = floor (IED_times(1:200, 1) *Rs);
else
    res = floor ((IED_times(1:end-5, 1)) *Rs);
end

frame_time = 1.5;
offset = 0;
frequency_vec = 1:200; % analyze 40-80 Hz range
% res = floor ((IED_times(1:end-5, 1)) *Rs); 

N = frame_time * Rs;
off = offset * Rs;                 
T=res(1:end);                          

% extract data from each channel
data=Dat_tracker(filename.name, T+off, N, num_CH); 
data_CHsel = squeeze(data(test_CH,:,:)); 

% calculate the wavelet  
for ii = 1:length(T)
    [S(:,:,ii),~,~] = awt_freqlist(data_CHsel(:, ii), Rs, frequency_vec,'Gabor');
end
 
 % Output
 % S            time x freq x trials 
 % f            list of freq
 % psi_array    array of analysis functions (complex values) 

%  
% matrix operation version
% S = abs(S);
% S_summed = sum(S(:, 40:80, :), 2);
% S_summed = squeeze(S_summed);
% S_summed_mean = mean(S_summed, 2);
% S_max(CH,:) = max(S_summed_mean(800:1100, :));

S = S(:,40:80,:);
S = abs(S);
S_sum = sum(S,2); 
S_sum = squeeze(S_sum); 
S_mean = mean(S_sum'); 
S_max = max(S_mean(800:1100)); 


 

 


