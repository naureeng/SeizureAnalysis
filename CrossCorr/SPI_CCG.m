function [] = SPI_CCG(window,Bin_ms)
% Cross-Correlation of IED Events
% INPUTS:
% window     [sec]
% Bin_ms     [millisec] 
%
%% load inputs
filename = dir('*.lfp');
[~, ~, ~] = fileparts(filename.name);
load('NY609_Day4_Part2_SPI.mat'); 
SPI_new = SPI(~cellfun('isempty',SPI));  

SPI_rev = cell(1);
for i = 1:length(SPI_new)
    SPI_rev{i} = SPI_new{i,1}(:,1);
end

SPI_new = SPI_rev'; 

res_file = dir('*Ch1SPI*');
load(res_file.name);
load('regionCH.mat');
load('goodCH.mat');
Dev_ECoG_map = 1:length(SPI_new);
dimensions = [8 length(SPI_new)./8];
Rs = 1250; % sampling rate
Wn = window*2; % Wn = window 

refied_time = SPI_1(:,1); 
res_ref = refied_time.*Rs; 
    
%% generate the H for all channels
% CROSSCORR_MS
% INPUTS
%       t1:         time-series 1 (res_ref/Rs*1e3)
%       t2:         time-series 2 (res_spi/Rs*1e3)
%       Bin_ms:     binsize for cross corr histogram (msec)
%       Win/Bin_ms: number of bins 
% OUTPUTS
%       H:          cross-correlation histogram
%       B:          vector of bin times

window = 21;                %number of bins for convolution 
alpha = 0.05;


for j = 1:length(SPI_new)
    res_chan = SPI_new{j,1}.*Rs;
    [H(j,:),B]= CrossCorr_ms( res_ref/Rs*1e3,res_chan/Rs*1e3, Bin_ms, (Wn*1000)/Bin_ms); % [millisec]
    cchEvt(j,:) = (H(j,:).*length(res_ref)*Bin_ms/1000)'; % [sec]
    pred(j,:) = cch_conv_rev(round(cchEvt(j,:)),window); % [sec] statistics
end

% CCH_CONV
% INPUTS
%       cchEvt:     counts 
%       window:     window width (samples) 
% OUTPUTS
%       pred:       predictor values for CCH

hiBound = poissinv( 1 - alpha, pred); % [sec]
loBound = poissinv( alpha, pred); % [sec]

hiB = hiBound/(length(res_ref)*Bin_ms/1000); % [sec]
loB = loBound/(length(res_ref)*Bin_ms/1000); % [sec]


%% order the channels
H_ordered = H(Dev_ECoG_map, :);
loB_ordered = loB(Dev_ECoG_map, :);
hiB_ordered = hiB(Dev_ECoG_map, :);

%% plot CCG of SPIs
         
figure_ctrl('CCG_SPI',1000,1000);
for CH =1:length(Dev_ECoG_map)
    subaxis(dimensions(2),dimensions(1),CH, 'Spacing', 0.01, 'Padding', 0, 'Margin', 0.01);
    bar(B,H_ordered(CH,:));
    hold on;
    plot(B,hiB_ordered(CH,:),'r--');
    plot(B,loB_ordered(CH,:),'r--');
    axis([-Wn/2 Wn/2 0 10]);
    axis_cleaner;
end

end

