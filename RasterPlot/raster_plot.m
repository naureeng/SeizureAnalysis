ntrials = length(CH_key);
for jj = 1:ntrials
    t = find(spikeMat(jj,:)==1);
    nspikes = numel(t);
    for ii = 1:nspikes
        line([t(ii) t(ii)], [jj-0.5 jj+0.5],'Color','k');
    end
end

xlabel('Time (s)');
ylabel('Trial number'); 