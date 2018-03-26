% Various Wavelet Operations

filename = dir('*.lfp');
[pathstr, fbasename, fileSuffix] = fileparts(filename.name);
num_CH = 140;
%test_CH = 83;
state = 'NREM';
res_file = 'Ch26SPI.mat';                                     % strcat(fbasename, 'riponly.mat');
frame_time = 1.5;             %3 for all analyses except 10 for pulses
offset = 0;              %1 or 0.5; for pre = 4;
frequency_vec = 1:1:200; %1:0.5:50; ripples = 1:1:500
Rs = 1250;
xaxis =1.5:1/Rs:3;                                          % 0.175:1/Rs:2.335;   -0.36:1/Rs:1.8;     -0.46:1/Rs:0.46;    -1.46:1/Rs:1.46; 0.0008:1/Rs:1
yaxis = 1:0.5:50;

% Calculate the wavelet for each timepoint in a selected res_file over a
% frame-time
figure;
k = 1;
for test_CH = [26]
[ S,f, wavavg_trials, var_name ] = Wav_res( res_file, num_CH, test_CH, frame_time, offset, frequency_vec );
S = abs(S);
%Sfilename = strcat(fbasename, state, '_S');
%save(Sfilename, 'S');

% wav_file = strcat(fbasename, num2str(test_CH), 'REM', 'wav');
% wavelet.S = S;
% wavelet.f = f;
% %save (wav_file, 'wavelet')
 %wavavg_file = strcat(fbasename, num2str(test_CH), state, var_name{1}, '_spiwavavg_final');
 subplot(1, 1, k)
 imagesc(wavavg_trials(:, 3:199)'); axis xy; colormap jet
 k = k+1;
end
 
% spectrum = mean(wavavg_trials);
% figure; plot(spectrum);
 
 %save (wavavg_file, 'wavavg_trials')
% 
% Rs = 1250;
figure1 = figure;
 new_xaxis = (-frame_time/2+offset):1/Rs:((frame_time/2 + offset)-1/Rs);
 new_yaxis = 2:0.5:50;
 imagesc (new_xaxis, new_yaxis, wavavg_trials(:, 3:99)')
     axis xy 

%print(figure1,'-depsc',cat (2, fbasename, 'Spiavgwav',num2str(test_CH), state, var_name{1}));
%saveas(figure1, strcat(fbasename, 'Spiavgwav',num2str(test_CH), state, var_name{1}, '.fig'));

 xaxis =1/Rs:1/Rs:1.5;                                          % 0.175:1/Rs:2.335;   -0.36:1/Rs:1.8;     -0.46:1/Rs:0.46;    -1.46:1/Rs:1.46; 0.0008:1/Rs:1
yaxis = 1:0.5:150;
 figure;
 imagesc(xaxis, yaxis, wavavg_trials'); axis xy; colormap jet 

%%
%individual wavelet spectrograms based on a timepoint

frame_time = 60;
offset = 0;
timepoint = 198;
num_CH = 140;
CH_select = 26;

filename = dir('*.lfp');
[pathstr, fbasename, fileSuffix] = fileparts(filename.name);

% extract the lfp at each timepoint of the res_file
Rs = 1250;
                                      
N = frame_time * Rs;
off = offset * Rs;                 
T= round(timepoint * Rs);   
frequency_vec = [2:0.5:50];

data=Dat_tracker(filename.name, T+off, N, num_CH);                                
data_CHsel = squeeze ( data(CH_select, :, :)  );

% calculate the wavelet 
[S,f,psi_array] = awt_freqlist(data_CHsel, Rs, frequency_vec,'Gabor');


S = abs(S);
new_xaxis = (-frame_time/2+offset):1/Rs:((frame_time/2 + offset)-1/Rs);
new_yaxis = 2:0.5:50;
figure1 = figure_ctrl(strcat(fbasename, 'TF_P1314'), 2000, 300);
% imagesc(new_xaxis, new_yaxis, log10(S)'); axis xy; colormap jet; caxis([0 3]);
imagesc(new_xaxis, new_yaxis, (S)'); axis xy; colormap jet;
% 
% printeps(figure1);
% printjpg(figure1);




%%
% Find frequency peaks in the wavelet traces and calculate the means of
% these peaks over trials in 3 specified frequency bands
% 
% low_f = 5;
% high_f = 16;
% SS = squeeze(mean(S(length(S)/2+250:length(S)/2+2500, :, :), 1));
% SS = abs(SS);
% [a b] = size (SS);
%  for jj = 1:length(b)
%      SS_peaks = Peak_finder_positive(SS(:, jj), 1, 1000);
%      SS_delta_ind = find(SS_peaks < low_f);
%      SS_delta(:, jj) = mean(SS_peaks(SS_delta_ind));
%      
%      SS_alpha_ind = find(SS_peaks >= low_f & SS_peaks <= high_f);
%      SS_alpha(:, jj) = mean(SS_peaks(SS_alpha_ind));
%     
%      SS_gamma_ind = find(SS_peaks > high_f);
%      SS_gamma(:, jj) = mean(SS_peaks(SS_gamma_ind));
%      
%      clear SS_peaks
%      clear SS_delta_ind
%      clear SS_alpha_ind
%      clear SS_gamma_ind
%  end
%  
% alpha_freq = SS_alpha(~isnan(SS_alpha));
% mean_alphaf = mean(alpha_freq);
%  
% delta_freq = SS_delta(~isnan(SS_delta));
% mean_deltaf = mean(delta_freq);
%  
% gamma_freq = SS_gamma(~isnan(SS_gamma));
% mean_gammaf = mean(gamma_freq);
% 
% meanfreq.a = mean_alphaf;
% meanfreq.d = mean_deltaf;
% meanfreq.g = mean_gammaf;
% meanfreq_file = strcat(fbasename, num2str(test_CH), var_name{1}, '_peakfreq');
% save (meanfreq_file, 'meanfreq');
% 
% %% Calculate power in various frequency bands over time
% 
% f_band = [17:2:33]; 
% dur = length(wavavg_trials);              %1000:3000;                      %length(wavavg_trials); 
% t_band = 1000:3000;           %dur/2:(dur/2 + 625);                  %1:dur
% 
% figure;
% for ii = f_band
% band_power = wavavg_trials(t_band, ii).^2;                             
% plot(t_band, band_power)
% pause
% hold on
% %line ([dur/2 dur/2], [min(band_power) max(band_power)])
% %b_power.(char(ii+64)) = band_power;
% clear band_power;
% end
% 
% b_power.f = f_band;
% %p_file = strcat(fbasename, num2str(test_CH), var_name{1}, '_band');
% %save (p_file, 'b_power')
%% To calculate baseline spindle power

filename = dir('*.lfp');
[pathstr, fbasename, fileSuffix] = fileparts(filename.name);
num_CH = 140;
test_CH = 26;
state = 'NREM';
res_file = 'Ch26SPI.mat';                                     % strcat(fbasename, 'riponly.mat');
frame_time = 3;             %3 for all analyses except 10 for pulses
offset = 0;              %1 or 0.5; for pre = 4;
frequency_vec = 1:0.5:50; %1:0.5:50; ripples = 1:1:500
Rs = 1250;


[ S,f, wavavg_trials, var_name ] = Wav_res( res_file, num_CH, test_CH, frame_time, offset, frequency_vec );
S = abs(S);

 figure; imagesc(wavavg_trials(:, 3:99)'); axis xy; colormap jet

temp = mean(wavavg_trials(:, 19:39), 2);
%mean_pow = mean(temp(1875:2430));  % for spi baseline
mean_pow = mean(temp(2145:3206));  % for IED-spi
