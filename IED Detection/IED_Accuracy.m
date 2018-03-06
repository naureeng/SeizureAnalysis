% Quantify IED Detection Algorithm Accuracy
% Selects random NREM intervals to determine IED accuracy against human eye
% Naureen Ghani (2018) 

% Step 1: Obtain NREM Intervals 
state_mat = dir('*-states*');
load (state_mat.name);
[~,ind] = find(states==3);
transition = cell(1);
for i = 1:length(ind)-1
    if ind(i+1)-ind(i) ~= 1
        transition{i} = [ind(i) ind(i+1)];
    else      
    end
end
transition = transition(~cellfun(@isempty, transition));
transition = horzcat(ind(1),cell2mat(transition),ind(end));

NREM_start = transition(1:2:end);
NREM_end = transition(2:2:end);
[val,~] = min(NREM_end-NREM_start);
NREM_mat = [NREM_start', NREM_end'];       

for i = 1:length(NREM_mat)
    NREM_epoch{i} = NREM_mat(i,1):1:NREM_mat(i,2);
end

NREM_epoch = NREM_epoch';

% Step 3: Obtain random NREM intervals
test_length = floor(val); 
for i = 1:length(NREM_epoch)
   a = NREM_epoch{i,1};
   numelements = round(length(a));
   indices = randperm(length(a),test_length);
   indices = indices(1:test_length);
   b = a(indices);
   NREM_rand_start(i) = b(1);
   NREM_rand_end(i) = b(end); 
end

NREM_rand = [NREM_rand_start; NREM_rand_end]; 
NREM_rand = sort(NREM_rand(:));

% Step 4: Make random NREM event file
filename = dir('*.lfp');
[~, fbasename, ~] = fileparts(filename.name);
NREM_rand = NewEvents(NREM_rand, 'NREM event'); 
NREM_name = strcat(fbasename,'.tst.evt');
SaveEvents(NREM_name, NREM_rand); 
