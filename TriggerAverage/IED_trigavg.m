function [ Spi_hil ] = IED_trigavg(num_CH, regionCH, goodCH, state, ECoGinfo )

% IED_TRIGAVG Plots IED trigger-averaged events in LFP file  
%       IED = IED_DETECT(NUM_CH, IED_CH) uses default parameters
%       IED = IED_DETECT(NUM_CH, IED_CH, passband, state, med_thresh,
%       ied_int, minburstInt, mean_thresh) uses specified parameters 
%
% REQUIREMENTS
%       NUM_CH: total number of channels
%       REGIONCH_MAT: channels for IED_TRIGAVG analysis
%       GOODCH_MAT: excludes channels with noise
%       STATE:
%       ECoGinfo_MAT: vector (order-sensitive) that represents spatial
%       information about the electrode orientation 
%       Note:   must be in path of .lfp file and -states.mat(from StateEditor)
%                   file
%       Convention: channel number begins with 1 and ends with
%       length(CH_key)
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
load('regionCH.mat'); 
load('goodCH.mat'); 
load('ECoGinfo.mat'); 
num_CH = 128; 

% Step 2: Extract IED peak times for channels of interest (regionCH)
IED_filename = strcat(fbasename,'_IED.mat');
load(IED_filename); 

IED_times = cell(1); 
for i = 1:length(regionCH)
    IED_times{i} = IED{regionCH(i),1}(:,2);
end

IED_times = IED_times';

% Step 3: Extract LFP data in total channels (goodCH) in each IED peak time
% in fiftieth channel of interest ( regionCH(50) )
duration = 2.*Rs; 

for j = 1:length(goodCH_mat) 
    time = round(IED_times{36,1}*Rs);  
    Data= Dat_tracker(filename.name, time, duration, num_CH);
    dimensions = size(Data);

% Step 4: Filtering and Hilbert

    fc= [25 80]; 
    n=5;
    Wn=fc;
    [b,a]=butter(n,abs(2*Wn/Rs));
        for CH = 1:num_CH
           Data_fil(CH,:,:)=filtfilt(b,a,squeeze(Data(CH,:,:)));
           Data_hilbert(CH,:,:)=hilbert(squeeze(Data_fil(CH,:,:)));
           for k = 1:dimensions(:,3)
                hil_smooth(CH, :, k) = smooth(squeeze(abs(Data_hilbert(CH, :, k))), 500);
           end
        end

        for CH = 1:num_CH
           mean_window(CH, :) = sum(hil_smooth(CH, 1:2500, :), 3);          
           max_hil(CH, :) = max(mean_window(CH, :), [], 2);
        end
end

% Step 5: Reshape Matrix 
      
    dimensions = size(ECoGinfo);          
        for kk = 1:num_CH                   
           if sum(ismember(goodCH_mat,kk)) == 1
               max_hil(kk) = max_hil(kk);
           else
               max_hil(kk) = NaN;
           end
        end
    max_hil_ordered = max_hil(ECoGinfo, :); 
    grid=(reshape(max_hil_ordered,dimensions(:,1), dimensions(:,2))); 
    figure; imagesc(grid); colormap jet 
       
end
