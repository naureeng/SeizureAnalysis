function [] = sta_overall(avg_matrix, num_CH)  

data = avg_matrix';
data = cell2mat(data); 
[r,c] = size(data); 

% Step 1: High-Pass Filter Data
data_filt = cell(1);
[b,a] = butter(3, 1/(1250/1),'high'); 
% 5th order Butterworth high-pass filter to extract signal above 1 Hz
for m = 1:r
    data_filt{m} = filtfilt(b,a,data(m,:));
end

data_filt = data_filt';
data_final = cell2mat(data_filt); 

dimensions = 1:num_CH;

% Step 2: Plot Data
for n = 1:length(dimensions)     
    subaxis(dimensions(14),dimensions(10),n,'Spacing', 0.01, 'Padding', 0, 'Margin', 0.01);
    Xval = 1:c; 
    hold on;
    plot(Xval,data_final(n,:),'b','Linewidth',1)
    axis([250 750 -600 400]); 
    axis_cleaner;
end


