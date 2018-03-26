% Loop for Spike-Trigger Average Analysis

avg_final = cell(1); 
CH_sel = 1:124; % 124 channels with IEDs Detected 

for i = 1:length(IED_final)
    for j = 1:length(CH_sel)
        if length(IED_final{i,1})<=1
            disp('IED-Average not possible');
        else
            avg_final{i} = spike_trigger_average(IED_final{i,1}, j);
        end
    end
end

avg_final = avg_final';
avg_results = avg_final(~cellfun('isempty',avg_final));

for i = 1:length(avg_results)
    avg_results{i} = avg_results{i}(~isnan(avg_results{i}(:,1)),:) ;
end

