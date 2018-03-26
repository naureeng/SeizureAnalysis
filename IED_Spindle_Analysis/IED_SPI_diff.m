% IED-SPI Analysis
% Find how similar two spike trains (IED events and Spindle Events) are for
% a single channel

% Find signal duration
state_mat = dir('*-states*');
load (state_mat.name);
StateIntervals = ConvertStatesVectorToIntervalSets(states);
time_signal = length(states);

function [spindle_pre, spindle_post] = IED_SPI_diff(test_CH)

IED_times = IED{test_CH,1};
IED_times = round(IED_times);
SPI_times = SPI{test_CH,1}(:,1);
SPI_times = round(SPI_times); 

% for s = 1:time_signal % [sec]
%     TimeScale(s) = .001 * 1.5^(s-1); % [sec]
%     
%     % Calc J.Victor distance
%     cost = 1/TimeScale(s) ; % per [sec]
%     dVictor(s) = spkd(IED_times,SPI_times,cost) ;
%      
% end

% Computing nearest spindle before and after each IED (time diffs) [sec]
if min(IED_times) < min(SPI_times)
    IED_int = IED_times >= min(SPI_times);
    IED_int = IED_times(IED_int);
    
    for i = 1:length(IED_int)
        time_diff = SPI_times-IED_int(i);
        post_spindle(i) = min(time_diff( time_diff > 0 ));
        pre_spindle(i) = max(time_diff( time_diff < 0 ));
    end
    
spindle_ref = [pre_spindle', post_spindle'];
spindle_pre = find(pre_spindle >= -5); % within 5 sec before IED
spindle_post = find(post_spindle <= 5); % within 5 sec after IED 

else
end

end


    
    
    