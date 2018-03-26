load fish10000.mat

% Input is binary vector, 1 ms bins
bspike = rho; 
stimulus = stim;
% number of 0.5 ms time steps to go back
n = 400; 

% discard spikes occuring prior to n ms
bspike(1:n-1) = 0;
% make vector of all spike times in ms
spiketimes = find(bspike >0);

for i = 0:n-1
    shift = spiketimes-i; % all the times i 1/2 ms shifted back from the spike times
    STA(i+1) = mean(stim(shift)); % mean value of the stimulus at the shifted times
end

% flip the STA vector so we can show it from past to future
STAplot = fliplr(STA);

% calculate appropriate time vector
tVec = -((n/2)-.5):.5:0;

% figure
plot(tVec,STAplot); 
