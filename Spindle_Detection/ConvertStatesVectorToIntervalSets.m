function StateIntervals = ConvertStatesVectorToIntervalSets(states)
% Function to take "states" from -states.mat file from StateEditor to 
% convert them to TStoolbox-style interval sets
%
% Input: states: variable stored in basename-states.mat by StateEditor, is
% a vector of the assigned state at each second in the recording
% 
% Output: StateIntervals is a cell array, each element contains the full
% interval set for one of the states (0 through 5) in StateEditor.  As of
% this writing: 
% State 1 = Wake
% State 2 = Drowsy
% State 3 = SWS
% State 4 = Intermediate Sleep
% State 5 = REM
% State 6 = No label
% Brendon Watson January 2014

StateIntervals = cell(1); 

for a = 1:6 %for each of 6 states in StateEditor
    if a~=6
        statetype = a;
    else
	    statetype = 0;%no label case
    end
    
	thesestarts = find(diff(states == statetype)>0);%basic function here and next line
    thesestops = find(diff(states == statetype)<0);
    
    if states(1) == statetype%account for states that begin at start of file
        thesestarts=cat(2,1,thesestarts);
    end
    if states(end) == statetype%account for states that finsh at end of file
        thesestops=cat(2,thesestops,length(states));
    end
    
    StateIntervals{a} = intervalSet(thesestarts*10000,thesestops*10000);%store results
    
end



