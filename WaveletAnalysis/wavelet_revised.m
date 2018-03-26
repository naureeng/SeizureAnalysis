% Various Wavelet Operations

filename = dir('*.lfp');
[pathstr, fbasename, fileSuffix] = fileparts(filename.name);
num_CH = 128;
%test_CH = 83;
state = 'NREM';
res_file = 'Ch1IED.mat';                                     % strcat(fbasename, 'riponly.mat');
frame_time = 1.5;             %3 for all analyses except 10 for pulses
offset = 0;              %1 or 0.5; for pre = 4;
frequency_vec = 1:1:200; %1:0.5:50; ripples = 1:1:500
Rs = 1250;
% xaxis =1.5:1/Rs:3;                                          % 0.175:1/Rs:2.335;   -0.36:1/Rs:1.8;     -0.46:1/Rs:0.46;    -1.46:1/Rs:1.46; 0.0008:1/Rs:1
% yaxis = 1:0.5:50;

% Calculate the wavelet for each timepoint in a selected res_file over a

for test_CH = 1:num_CH
    [ S,f, wavavg_trials, var_name ] = Wav_res( res_file, num_CH, test_CH, frame_time, offset, frequency_vec );
    S = abs(S);
end
 