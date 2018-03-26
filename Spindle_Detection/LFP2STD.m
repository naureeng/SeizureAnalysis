function [sd] = LFP2STD(fbasename, nchannels, channel, state, state_name, IED, passband)

lfp = LoadLfp(fbasename, nchannels, channel);
fil_sleep = FilterLFP([Range(Restrict(lfp,state),'s') Data(Restrict(lfp,state))], 'passband', passband); 
Rs = 1250;

if isempty(IED)==0 % IEDs are present
    IED_times = [floor((IED(:,1)-0.05)*Rs) floor((IED(:,1)+0.05)*Rs)]; % Extract IEDs
    IED_Is = intervalSet(IED_times(:,1), IED_times(:,2)); % start-peak IED timestamps
    sig_Is = intervalSet(fil_sleep(1,1)*Rs, fil_sleep(end,1)*Rs); % fil_sleep timestamps
    test = diff(sig_Is, IED_Is); % difference between IED and fil_sleep timestamps
    sig_tsd = tsd((fil_sleep(:,1)*Rs), fil_sleep(:,2)); % oop approach 
    restricted_sig = Restrict(sig_tsd, test); % excludes IED times in fil_sleep
    fil_noIED = [Range(restricted_sig) Data(restricted_sig)]; % creates lfp data without IEDs
else
    fil_noIED = fil_sleep; % no IEDs present
end

% Calculate the sd
windowLength = round(Rs/1250*11); % 11 [sec]
signal2 = fil_noIED(:,2); % 2-dim array (time vs voltage), extracts [mV]
squaredSignal2 = signal2.^2; 
window = ones(windowLength,1)/windowLength;
convol_sig2 = Filter0(window, sum(squaredSignal2,2));
sd = std(convol_sig2);

% Save file
sd_file = strcat(fbasename, state_name, num2str(channel), '_stdev');
save(sd_file, 'sd');
