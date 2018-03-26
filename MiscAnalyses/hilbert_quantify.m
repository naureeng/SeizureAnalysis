% Hilbert Transform 

% Step 1: Set-up bandpass filter 

fc= [60 80]; % narrow range 
n=5;
Rs = 1250; 
[b,a]=butter(n,2*fc/Rs, 'bandpass'); 

% Step 2: Process data (filter-> hilbert-> smooth-> maximum)
% pre-allocation
Data_fil = cell(1);
Data_hilbert = cell(1);
hil_smooth = cell(1); 
max_hil = cell(1); 

for i = 1:num_CH
    Data_fil{i} = filtfilt(b,a,squeeze(data(i,:)));  
end

for j = 1:num_CH
    Data_hilbert{j} = hilbert(squeeze(Data_fil{1,j})); 
end

for k = 1:num_CH
    hil_smooth{k} = smooth(squeeze(abs(Data_hilbert{1,k}))); 
end

for n = 1:num_CH
    max_hil{n} = max(hil_smooth{1,n});
end

dimensions = 1:128;

% Step 3: Plot Data
for n = 1:length(dimensions)     
    subaxis(dimensions(16),dimensions(8),n,'Spacing', 0.01, 'Padding', 0, 'Margin', 0.01);
    Xval = 1:1000; 
    hold on;
    plot(Xval,hil_smooth{1,n},'b','Linewidth',1)
    xlim([250 750]);  
    ylim([0 5]); 
    axis_cleaner;
end

data_hil = max_hil';
max_hil = cell2mat(data_hil); 




