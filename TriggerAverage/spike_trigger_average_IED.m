% Spike-Triggered Average of IED Events in one channel

function [avg] = spike_trigger_average_IED(IED, CH_sel)

Rs = 1250; % sampling rate
windowSize = 0.8*Rs; % num of sampling points in 1.6 seconds (1000 points)

% Step 1: Load LFP
filename = dir('*.lfp');
[~, ~ , ~] = fileparts(filename.name);
Rs = 1250;
filename = dir('*.lfp');
fbasename = regexprep(filename.name,'.lfp','');
fbasename_IED = strcat(fbasename,'_IED');
load(fbasename_IED); 
CH_key = dir('*_CH_key*');
load(CH_key.name);
num_CH = length(CH_key); 

% Step 2: Extract IEDs within windowSize for a single channel 

IED_times = IED{CH_sel,1}; 

data_Channel = cell(1);

for i = 1:length(IED_times)
    time = round(IED_times(i,1)*Rs);  
    % round units of sample points, not time (sec) for precision
    Data= Dat_tracker(filename.name, time, windowSize, num_CH);
    data_Channel{i} = Data(CH_sel,:); 
    % i iterates through IED_times, but Data is a matrix of 
    % channels x windowSize (Correction: added input of CH_sel)
end

% Step 3: Average of waveform
data_IED_final = data_Channel';
data_IED_final = cell2mat(data_IED_final);
[r,~] = size(data_IED_final); 
avg = sum(data_IED_final)./r;
% figure;
% plot(avg,'Linewidth',2); 
% title('IED-Trigger Average'); 

end






