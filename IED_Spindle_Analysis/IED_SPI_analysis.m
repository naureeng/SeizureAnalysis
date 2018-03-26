% Find signal duration
state_mat = dir('*-states*');
load (state_mat.name);
StateIntervals = ConvertStatesVectorToIntervalSets(states);
time_signal = length(states);

% Load inputs
CH_key = dir('*_CH_key*');
load(CH_key.name);
num_CH = length(CH_key); 
goodCH = dir('*goodCH*');
load(goodCH.name); 

% Compute spindle time diffs in ref to IED evt
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






