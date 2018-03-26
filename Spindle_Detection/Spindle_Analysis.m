% Spindle detection in loop for all channels
% Naureen Ghani (2018) 

% Detect spindles in all channels

CH_key = dir('*_CH_key*');
load(CH_key.name);
filename = dir('*.lfp');
fbasename = regexprep(filename.name,'.lfp','');
fbasename = strcat(fbasename,'_SPI');
goodCH = dir('*goodCH*');
load(goodCH.name); 

SPI = cell(1);
for i = goodCH_mat
    SPI{i} = Spindle_Detect(length(CH_key),i);
end
SPI = SPI';
save(fbasename, 'SPI');
