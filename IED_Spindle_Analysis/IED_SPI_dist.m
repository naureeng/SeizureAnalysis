% IED-SPI Analysis
% Find how similar two spike trains (IED events and Spindle Events) are for
% a single channel

function [spindle_pre, spindle_post] = IED_SPI_dist(test_CH)

filename = dir('*.lfp');
fbasename = regexprep(filename.name,'.lfp','');
fbasename_IED = strcat(fbasename,'_IED');
fbasename_SPI = strcat(fbasename,'_SPI');
load(fbasename_IED);
load(fbasename_SPI);

IED_times = IED{test_CH,1};
IED_times = round(IED_times);
SPI_times = SPI{test_CH,1}(:,1);
SPI_times = round(SPI_times); 


% Computing nearest spindle before and after each IED (time diffs) [sec]
if min(IED_times) < min(SPI_times)
    IED_int = IED_times >= min(SPI_times);
    IED_int = IED_times(IED_int);
    
    % pre-allocate
    pre_spindle = zeros(1);
    post_spindle = zeros(1); 
    
    for i = 1:length(IED_int)
        time_diff = SPI_times-IED_int(i);
        post_spindle(i) = min(time_diff( time_diff > 0 ));
        pre_spindle(i) = max(time_diff( time_diff <= 0 ));
        
        if isempty(pre_spindle)==1 || isempty(post_spindle)==1
            pre_spindle(i) = 0;
            post_spindle(i) = 0;
        else
        end
    end
    
spindle_pre = find(pre_spindle >= -5); % within 5 sec before IED
spindle_post = find(post_spindle <= 5); % within 5 sec after IED 

else
    spindle_pre = 0;
    spindle_post = 0;
end

end


    
    
    