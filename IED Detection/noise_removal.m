% Remove erroneous noisy peaks in IED Detection by thresholding amplitude
% of raw signal 
% Naureen Ghani (2018) 

Rs = 1250; % sampling rate
windowSize = 2*Rs; % num of sampling points in 4 seconds

% Step 1: Load LFP
filename = dir('*.lfp');
[~, fbasename, ~] = fileparts(filename.name);
Rs = 1250;
num_CH = 128; 

% Step 2: Extract IEDs within windowSize for a single channel 
IED_times = IED(:,1); 
nEvs = length(IED_times);
evIdx = IED_times; 

data_Channel = cell(1);
amp = zeros(1); 

for i = 1:length(IED_times)
    time = round(IED_times(i,1))*Rs;  
    Data= Dat_tracker(filename.name, time, windowSize, num_CH);
    data_Channel{i} = Data(1,:); 
    [amp(i), ~] = min(data_Channel{1,i}); 
end

IED_vector = [IED_times amp']; 
noise_index = mean(amp); 
IED_wo_noise_index = IED_vector(:, 2) > noise_index;
IED_wo_noise = IED_vector(IED_wo_noise_index, :);
IED_sep = IED_wo_noise; 

IED = IED_sep(:,1);