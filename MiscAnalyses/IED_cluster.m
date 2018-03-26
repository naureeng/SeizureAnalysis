% Obtain IED_rate
IED_rate = analysis_corrected(:,1);
IED_rate = cell2mat(IED_rate);

% Obtain IED_power
IED_power = analysis_corrected(:,2);

% Obtain IED_avgpower per channel
IED_avgpower = cell(1);
for i = 1:length(IED_power)
    IED_avgpower{i} = mean(IED_power{i,1});
end

% Replace NaN with -1
IED_avgpower = cell2mat(IED_avgpower');
IED_avgpower(isnan(IED_avgpower)) = 0; 

% Replace noise channels with 0
noise_channels = [94 112:1:123] + 1;
IED_avgpower(noise_channels,:) = 0;
IED_rate(noise_channels,:) = 0;

% Add channel numbers
IED_CH = 1:1:128;
IED_summary = [IED_rate IED_avgpower IED_CH'];

% Remove rows with zero
IED_summary(all(~IED_summary,2),:) = [];

% Remove columns with zero
IED_summary(:,all(~IED_summary,1)) = [];

% Remove rows with high power
idx = IED_summary(:,2)>=100;
IED_summary(idx,:)=[];
