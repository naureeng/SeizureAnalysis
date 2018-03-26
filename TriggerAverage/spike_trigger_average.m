function [avg] = spike_trigger_average(ref_times, CH_sel, windowSize, num_CH, Rs)
% SPIKE_TRIGGER_AVERAGE     Does spike-trigger average 
%
% INPUTS
%       ref_times:      time vector for event of interest [sec]
%       CH_sel:         channel for analysis
%       windowSize:     time window for analysis [sec]
%       num_CH:         number of channels
%       Rs:             sampling rate [Hz]
%
%       Note:           must be in path of .lfp file and -states.mat(from StateEditor)
%                       file
%
% OUTPUTS
%       avg:            vector of spike-trigger average
%
% Naureen Ghani (2018) 

filename = dir('*.lfp');
[~, ~ , ~] = fileparts(filename.name);

data_Channel = cell(1);

for i = 1:length(ref_times)
    time = round(ref_times(i,1)*Rs);  
    % round units of sample points, not time (sec) for precision
    Data= Dat_tracker(filename.name, time, windowSize, num_CH);
    data_Channel{i} = Data(CH_sel,:); 
    % i iterates through IED_times, but Data is a matrix of 
    % channels x windowSize (Correction: added input of CH_sel)
end

% Step 3: Average of waveform
data_final = data_Channel';
data_final = cell2mat(data_final);
[r,~] = size(data_final); 
avg = sum(data_final)./r;
% figure;
% plot(avg,'Linewidth',2); 
% title('Spike-Trigger Average'); 

end


