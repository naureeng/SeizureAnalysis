% Spike-Triggered Average of Spindle Events in one channel

function [avg] = spike_trigger_average_spindle(SPI, CH_sel)

Rs = 1250; % sampling rate
windowSize = 4*Rs; % num of sampling points in 4 seconds 

% Step 1: Load LFP
filename = dir('*.lfp');
[~, ~ , ~] = fileparts(filename.name);
Rs = 1250;
filename = dir('*.lfp');
fbasename = regexprep(filename.name,'.lfp','');
fbasename_SPI = strcat(fbasename,'_SPI');
load(fbasename_SPI); 
CH_key = dir('*_CH_key*');
load(CH_key.name);
num_CH = length(CH_key); 

% Step 2: Extract spindles within windowSize for a single channel 

SPI_times = SPI{CH_sel,1}(:,2); 

data_Channel = cell(1);

for i = 1:length(SPI_times)
    time = round(SPI_times(i,1)*Rs);  
    % round units of sample points, not time (sec) for precision
    Data= Dat_tracker(filename.name, time, windowSize, num_CH);
    data_Channel{i} = Data(CH_sel,:); 
    % i iterates through IED_times, but Data is a matrix of 
    % channels x windowSize (Correction: added input of CH_sel)
end

% Step 3: Average of waveform
data_SPI_final = data_Channel';
data_SPI_final = cell2mat(data_SPI_final);
[r,~] = size(data_SPI_final); 
avg = sum(data_SPI_final)./r;
% figure;
% plot(avg,'Linewidth',2); 
% title('Spindle-Trigger Average'); 

end






