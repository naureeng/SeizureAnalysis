% Raster Plot of IED occurrence

IED_times = cell(1);
for i = 1:length(IED)
    IED_times{i} = IED{i,1}(:,1);
end
IED_times = IED_times';

IED_round = cell(1);
for j = 1:length(IED_times)
    IED_round{j} = round(IED_times{j,:});
end
IED_round = IED_round';

spikeMat_trial = cell(1);
for i = 1:length(CH_key)
    spikeMat = zeros(1,length(states));
    spikeMat(IED_round{i,1})=1;
    spikeMat_trial{i} = spikeMat;
end
spikeMat_trial = spikeMat_trial';
spikeMat = cell2mat(spikeMat_trial); 
noise_channels = [3 9 11 12 13 28 60 61 124 125 126 127 132 134 136 137 138 139]+1;
spikeMat(noise_channels,:)=0;
spikeMat = logical(spikeMat);
tVec = 1:1:length(states);

plotRaster(spikeMat,tVec); 
xlim([0 length(tVec)+10]);
xlabel('Time (s)');
ylabel('Channel Number');




