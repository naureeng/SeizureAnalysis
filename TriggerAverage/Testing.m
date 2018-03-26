function [ Spi_hil ] = IED_trigavg( num_CH, regionCH_mat, goodCH_mat, state, ECoGinfo_mat )

% IED_TRIGAVG Plots IED trigger-averaged events in LFP file  
%       IED = IED_DETECT(NUM_CH, IED_CH) uses default parameters
%       IED = IED_DETECT(NUM_CH, IED_CH, passband, state, med_thresh,
%       ied_int, minburstInt, mean_thresh) uses specified parameters 
%
% REQUIREMENTS
%       NUM_CH: total number of channels
%       REGIONCH_MAT: channels for IED_TRIGAVG analysis
%       GOODCH_MAT: excludes channels with noise
%       S
%       Note:   must be in path of .lfp file and -states.mat(from StateEditor)
%                   file
%
% OUTPUT
%      
%
% EXAMPLES:
% [IED] = IED_Detect(128,94)
% [IED] = IED_DETECT(128,94, [25 80], 'NREM', 5, 0.2, 1, 4);

% Step 1: Load LFP
filename = dir('*.lfp');
[~, fbasename, ~] = fileparts(filename.name);
Rs = 1250;
load(regionCH_mat); % select CH of interest; vector of CH numbers saved as a .mat
regionCH_used = region_CH + 1; %neuroscope vs. matlab numbering - stay consistent!
load(goodCH_mat); % only run the analysis on good CH; vector of CH numbers
goodCH_used = good_CH + 1; 
load(ECoGinfo_mat); % gives the spatial information about the electrode orientation
spidetect_name = strcat(fbasename, '_spidetect.mat'); % spindle detection times (column 1 = start; column 2 = peak; column 3 = end) on all the good CH
load(spidetect_name);

for ii = regionCH_used
    initialVars = who; % getting the spindles times of the region_CH being analyzed into a variable
    spi_name = strcat('CH_', num2str(ii));
    spindles = Spi_detect.(spi_name);
        if length(spindles) > 100 % consider going up to 500
            valrange = length(spindles);
            randspi_index = randi(valrange, [1 100]);
            spindles = spindles(randspi_index', :);
        end
    time=round(spindles(:, 1)*Rs); % selecting the time points to use for analysis, in sample points (time is the middle of the window)
    duration=8.*Rs; % selects the duration of data to extract for analysis in seconds
    Data= Dat_tracker(filename.name, time, duration, num_CH); %extract the raw data around each of the timepoints, for the duration specified
    disp('Data is loaded !!') % check that the IED is centred in the window of data
% filtering and Hilbert

    fc= [8 25]; % this part is good!
    filter_type='bandpass';
    n=5;
    Wn=fc;
    [b,a]=butter(n,2*Wn/Rs);
        for CH = 1:num_CH;
           Data_fil(CH,:,:)=filtfilt(b,a,squeeze(Data(CH,:,:)));
           Data_hilbert(CH,:,:)=hilbert(squeeze(Data_fil(CH,:,:)));
           for jj = 1:length(spindles)
           hil_smooth(CH, :, jj) = smooth(squeeze(abs(Data_hilbert(CH, :, jj))), 500);
           end
            clc
           disp(cat(2,'filtering and hilberting channel #',num2str(CH)));
        end
%
    for CH = 1:num_CH; % selecting the specific data that you want to plot
    mean_window(CH, :) = sum(hil_smooth(CH, 5000:7500, :), 3);          %3435:4065
    max_hil(CH, :) = max(mean_window(CH, :), [], 2);
    end
%
    Dev_ECoG_map = Dev_ECoG_info.map;        %  load the correct map/transpose
    dimensions = Dev_ECoG_info.dim;          
        for kk = 1:num_CH                   % only plotting the good CH
           if sum(ismember(goodCH_used,kk)) == 1
               max_hil(kk) = max_hil(kk);
           else
               max_hil(kk) = NaN;
           end
        end
    max_hil_ordered = max_hil(Dev_ECoG_map, :); % re-ordering to match the map
    grid=(reshape(max_hil_ordered,dimensions(1), dimensions(2)))'; % reshaping to the grid
    figure1 = figure; imagesc(grid); colormap jet %plot
    test = inpaint_nans(grid, 1); % optional smoothing to adjust for bad data points (not recommended at present)
    figure2 = figure; imagesc(test); colormap jet
% Save variables and figures
    Spi_hil.mean = mean_window;
    Spi_hil.max = max_hil;
    Spi_hil.grid = grid;
    Spihil_name = strcat(fbasename, '_CH', num2str(ii), state, '_spihil');
    save(Spihil_name, 'Spi_hil');
    
    figure1_name = strcat(fbasename, '_CH', num2str(ii), state, 'spipow_raw.fig');
    figure2_name = strcat(fbasename, '_CH', num2str(ii), state, 'spipow_smooth.fig');
    savefig(figure1, figure1_name);
    savefig(figure2, figure2_name);
    
% clear the space

    clearvars('-except',initialVars{:})
    close all

end         %regionCH end

end         %function end