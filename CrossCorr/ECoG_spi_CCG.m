function [ spi_CCG ] = ECoG_spi_CCG( num_CH, regionCH_mat, goodCH_mat, ECoGinfo_mat, Win, Bin_ms)
% Calculate how correlated different channels are for spindle occurrence

filename = dir('*.lfp');
[pathstr, fbasename, fileSuffix] = fileparts(filename.name);
spidetect_name = strcat(fbasename, '_spidetect.mat');
load(spidetect_name);

load(regionCH_mat);
regionCH_used = region_CH + 1;
load(goodCH_mat);
goodCH_used = good_CH + 1;
load(ECoGinfo_mat);
Dev_ECoG_map = Dev_ECoG_info.map;
dimensions = Dev_ECoG_info.dim;

Rs = 1250;
Win = Win*2;

for ii = regionCH_used
    initialVars = who;
    refspi_name = strcat('CH_', num2str(ii));
    refspi_time = Spi_detect.(refspi_name);
    res_ref = refspi_time(:,1).*Rs;
    H = zeros(length(Dev_ECoG_map), Win/Bin_ms+1); %pre-allocating matrices
    loB = zeros(length(Dev_ECoG_map), Win/Bin_ms+1);
    hiB = zeros(length(Dev_ECoG_map), Win/Bin_ms+1);
%% generate the H for all channels
        for kk = 1:num_CH
            spi_name = strcat('CH_', num2str(kk));
            if isfield(Spi_detect, spi_name) == 1
                spi_time = Spi_detect.(spi_name);
                res_spi = spi_time(:,1).*Rs;
                [H(kk,:),B ]= CrossCorr_ms( res_ref/Rs*1e3,res_spi/Rs*1e3   ,Bin_ms  ,Win/Bin_ms); %cross-correlation function
                cchEvt = (H(kk,:).*length(res_ref)*Bin_ms/1000)';
                window = 21;                %number of bins for convolution
                alpha = 0.05;

                [dumy, pred, dumy ] = cch_conv(round(cchEvt),window);
                hiBound = poissinv( 1 - alpha, pred);
                loBound = poissinv( alpha, pred);

                hiB(kk,:) = hiBound/(length(res_ref)*Bin_ms/1000);
                loB(kk,:) = loBound/(length(res_ref)*Bin_ms/1000);
            else
                H(kk, :) = zeros(1, Win/Bin_ms+1);
                hiB(kk, :) = zeros(1, Win/Bin_ms+1);
                loB(kk, :) = zeros(1, Win/Bin_ms+1);
            end
        end
        
%% select only the good channels
       for mm = 1:num_CH
           if sum(ismember(goodCH_used,mm)) == 1
               H(mm, :) = H(mm, :);
               loB(mm, :) = loB(mm, :);
               hiB(mm, :) = hiB(mm, :);
           else
               H(mm, :) = NaN;
               loB(mm, :) = NaN;
               hiB(mm, :) = NaN;
           end
       end 
        
       %% order the channels
        H_ordered = H(Dev_ECoG_map, :);
        loB_ordered = loB(Dev_ECoG_map, :);
        hiB_ordered = hiB(Dev_ECoG_map, :);

     %% plot CCG of IED and spindles
         
        figure2 = figure_ctrl('CCG_IED_SPI',1000,1000);
         for CH=1:length(Dev_ECoG_map)       

                subaxis(dimensions(2),dimensions(1),CH, 'Spacing', 0.01, 'Padding', 0, 'Margin', 0.01);
                bar(B,H_ordered(CH,:));
                 hold on 
                 plot(B,hiB_ordered(CH,:),'r--')
                 plot(B,loB_ordered(CH,:),'r--')
                axis([-Win/2 Win/2 0 max(max(H))]);
                axis_cleaner;

         end

     %%
%      width_for_sum = 100;                                   % length in ms to sum
%      bins_to_sum = [round(length(B)/2)-(width_for_sum/(2*Bin_ms)) round(length(B)/2)+(width_for_sum/(2*Bin_ms))];
     middle_bin = round(length(B)/2);
     sig_corr = H(:, middle_bin) - hiB(:, middle_bin);
     %sig_corr = sum(H(:, bins_to_sum(1):bins_to_sum(2)), 2) - sum(hiB(:, bins_to_sum(1):bins_to_sum(2)), 2);
     %sig_corr = sum(H(:, bins_to_sum(1):bins_to_sum(2)) - hiB(:, bins_to_sum(1):bins_to_sum(2)), 2);
     sigcorr_ordered = sig_corr(Dev_ECoG_map, :);
     grid = (reshape(sigcorr_ordered', dimensions(1), dimensions(2)))';
     figure1 = figure; imagesc(grid); colormap jet
     
     %%
     spi_CCG.bin = Bin_ms;
     spi_CCG.B = B;
     spi_CCG.H = H;
     spi_CCG.loB = loB;
     spi_CCG.hiB = hiB;
     spi_CCG.scorr = sig_corr;
     spi_CCG.grid = grid;
     Spi_CCG_name = strcat(fbasename, '_CH', num2str(ii), '_spiCCG_', num2str(Bin_ms), 'msbin');
     save(Spi_CCG_name, 'spi_CCG');
     
     figure1_name = strcat(fbasename, '_CH', num2str(ii), 'sigcorr_', num2str(Bin_ms), 'msbin.fig');
     figure2_name = strcat(fbasename, '_CH', num2str(ii), 'raw_CCG_', num2str(Bin_ms), 'msbin.fig');
     savefig(figure1, figure1_name);
     savefig(figure2, figure2_name);
    
%% clear the space

    clearvars('-except',initialVars{:}, 'spi_CCG')
    close all

end

end
