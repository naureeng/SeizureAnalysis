%% Convert .edf into matlab cell array

parent = dir('*.edf');
for ii =  1:length(parent)
    cfg = [];
    cfg.dataset = parent(ii).name;
    cfg.channel = 'all';
    cfg.continuous = 'yes';
    cont_data = ft_preprocessing(cfg);
    

    %% array to .mat

    data_CHsel = cont_data.trial{1, 1};
    data_CHsel = data_CHsel';
    data_CHsel = data_CHsel(logical(data_CHsel(:,2)),:); 
    save (strcat(parent(ii).name(1:end-4), '_mat'), 'data_CHsel');

    CH_key = cont_data.label;
    save (strcat(parent(ii).name(1:end-4), '_CH_key'), 'CH_key');

    
end

% %% view data to verify process
% figure;
% cfg = [];
% cfg.viewmode = 'vertical';
% cfg.continuous = 'yes';
% cfg.channel = 'gui';
% ft_databrowser(cfg, cont_data);