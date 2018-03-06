% IED detection in loop for all channels
% Naureen Ghani (2018) 

% Step 1: Detect IEDs in all channels

CH_key = dir('*_CH_key*');
load(CH_key.name);
filename = dir('*.lfp');
fbasename = regexprep(filename.name,'.lfp','');
fbasename = strcat(fbasename,'_IED');
goodCH = dir('*goodCH*');
load(goodCH.name); 

IED = cell(1);
for i = goodCH_mat
    IED{i} = IED_Detect(length(CH_key),i);
end
IED = IED';
save(fbasename, 'IED');

% Step 2: Find signal duration

state_mat = dir('*-states*');
load (state_mat.name);
StateIntervals = ConvertStatesVectorToIntervalSets(states);
time_signal = length(find(states==3));

% Step 3: Extract IED Characteristics

IED_rate = cell(1);
% power = cell(1);
for j = 1:length(IED)
    [r,~] = size(IED{j,1});
    IED_rate{j} = r./time_signal;
    % power{j} = IED{j,1}(:,4);
end
IED_rate = IED_rate';
% power = power';
% analysis = [IED_rate power];
analysis_name = strcat(fbasename, '_Analysis');
save(analysis_name, 'analysis');
