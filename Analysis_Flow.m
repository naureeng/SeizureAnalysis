% Analysis for IED-Spindle Coupling 
%
% Required to be in path with the following files:
%       goodCH.mat:   excludes noise channels 
%      -states.mat:   manual sleep scoring with TheStateEditor.m
%       CH_key:       channel key
%       .lfp:         original recording (sampling rate: 1250 Hz)

%% Step 1: Load Parameters

CH_key = dir('*_CH_key*');
load(CH_key.name);
num_CH = length(CH_key); 
filename = dir('*.lfp');
fbasename = regexprep(filename.name,'.lfp','');
noiseCH = dir('*noiseCH*');
load(noiseCH.name); 
goodCH = dir('*goodCH*');
load(goodCH.name); 
Rs = 1250; 

%% Step 2: Detect IEDs in all channels

fbasename_IED = strcat(fbasename,'_IED');
IED = cell(1);
for i = goodCH_mat
    IED{i} = IED_Detect(length(CH_key),i);
end
IED = IED';
save(fbasename_IED, 'IED');

%% Step 3: Detect spindles in all channels

fbasename_SPI = strcat(fbasename,'_SPI');
SPI = cell(1);
for i = goodCH_mat
    SPI{i} = Spindle_Detect(length(CH_key),i);
end
SPI = SPI';
save(fbasename_SPI, 'SPI');

%% Step 4: Identify channels with >=100 IEDs
load(fbasename_IED);

test_CH_all = cell(1);
for i = 1:length(IED)
    if length(IED{i,1}) >= 100 
        test_CH_all{i} = i;
    else
        test_CH_all{i} = [];
    end
end

test_CH_all = cell2mat(test_CH_all);

%% Step 4: Identify channels with >=200 spindles
load(fbasename_SPI);

spi_CH_all = cell(1);
for i = 1:length(SPI)
    if length(SPI{i,1}) >= 200 
        spi_CH_all{i} = i;
    else
        spi_CH_all{i} = [];
    end
end

spi_CH_all = cell2mat(spi_CH_all);

%% Step 5: Trigger-Average IED Events 

avg_IED = cell(1);
windowSize_IED = 0.8*Rs; 

for i = 1:length(test_CH_all)
    avg_IED{i} = spike_trigger_average(IED{test_CH_all(i),1}, test_CH_all(1,i), windowSize_IED, num_CH, Rs); 
end

%% Step 6: Trigger-Average Spindle Events
load(fbasename_SPI);

avg_SPI = cell(1); 
windowSize_SPI = 4*Rs; 

for i = 1:length(test_CH_all)
    avg_SPI{i} = spike_trigger_average(SPI{test_CH_all(i),1}(:,2), test_CH_all(1,i), windowSize_SPI, num_CH, Rs);
end

%% Step 8: Select reference channel
test_CH = test_CH_all(12); % first channel in test_CH_all 

%% Step 9: Trigger-Average all channels against one IED channel

ref_IEDtime = IED{test_CH,1}; 
avg_matrix_IED = cell(1); 
for i = 1:num_CH
    avg_matrix_IED{i} = spike_trigger_average(ref_IEDtime, i, windowSize_IED, num_CH, Rs);
end

sta_overall(avg_matrix_IED, num_CH); 

%% Step 9: Trigger-Average all channels against one SPI channel 

ref_SPI_time = SPI{test_CH,1}; % first channel in test_CH_all
avg_matrix_SPI = cell(1); 
for i = 1:num_CH
    avg_matrix_SPI{i} = spike_trigger_average(ref_SPI_time, i, windowSize_SPI, num_CH, Rs);
end

sta_overall(avg_matrix_SPI, num_CH); 

%% Step 10: Wavelet analysis to determine regionCH for one reference channel

ref_times = ref_IEDtime; % use sparser IED events as reference 
S_mean = cell(1);
S_max = cell(1); 

for i = 1:num_CH
    [S_mean{i}, S_max{i}] = wavelet_quantify(i, num_CH, ref_times);
end

S_max = cell2mat(S_max)';
S_max(noiseCH_mat) = 0; % zero out noise channels 
X = S_max; 
[idx,C] = kmeans(X, 3); % k-means cluster analysis (k = 3) 
figure; 
plot(X(idx==1,1), 'r.', 'MarkerSize', 12);
hold on;
plot(X(idx==2,1), 'b.', 'MarkerSize', 12);
plot(X(idx==3,1), 'g.', 'MarkerSize', 12); 

idx_interest = idx(test_CH); 
region_CH = find(idx==idx_interest);
save('regionCH','region_CH'); 

%% Step 11: Cross-Correlation 

ref_SPItime = SPI{test_CH,1}(:,1);     % reference spindle start times in channel of interest 
spi = cell(1);
for i = 1:length(SPI)
    if isempty(SPI{i,1})==1
        spi{i} = [];
    else
        spi{i} = SPI{i,1}(:,1);
    end
end

spi = spi'; % spi contains only start times of detected spindles 

CCG_Analysis(IED, 10, 5, ref_IEDtime); % IED-IED cross-corr
CCG_Analysis(spi, 10, 5, ref_SPItime); % SPI-SPI cross-corr
CCG_Analysis(IED, 10, 5, ref_SPItime); % IED-SPI cross-corr

%% Step 12: Search for IED-Spindle Coupling

spindle_pre = cell(1);
spindle_post = cell(1); 

for i = test_CH_all
    [spindle_pre{i}, spindle_post{i}] = IED_SPI_dist(i);
end

% Spindle Ratios
spi_pre_perc = cell(1);
spi_post_perc = cell(1); 

for i = test_CH_all
    num_IED = length(IED{i,1});
    spi_pre = length(spindle_pre{1,i});
    spi_post = length(spindle_post{1,i}); 
    spi_pre_perc{i} = (spi_pre./num_IED).*100;
    spi_post_perc{i} = (spi_post./num_IED).*100; 
end

spi_pre_perc = spi_pre_perc(~cellfun(@isempty, spi_pre_perc));
spi_post_perc = spi_post_perc(~cellfun(@isempty, spi_post_perc)); 

%% 









