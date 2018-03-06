Rs=512; % sampling rate [Hz] 
lfp_check = dir('*.lfp');
f_in = dir('*.edf');
path = pwd;
slash_index=find(path=='/');
currentFolder=path(slash_index(end)+1:end);
f_out_lfp= cat(2,currentFolder,'.lfp');
fid_lfp=fopen(f_out_lfp,'w+');


for file_num=1:length(f_in)
       duration=60*Rs;
       %s_time=30*Rs;
       [f_duration_samppts , ~] = size (data_CHsel); 
       f_duration_sec = f_duration_samppts./Rs;
       f_duration_sec = round(f_duration_sec); 
       
       if  f_duration_sec <( duration/Rs)

            duration=f_duration_sec*Rs;
            stream=round(duration/2);
            Data_edf= data_CHsel;
            Data_lfp= resample(Data_edf,Rs,1250);
            Data_size_lfp=  size(Data_lfp);
            fwrite(fid_lfp,int16(reshape(Data_lfp',1,Data_size_lfp(1)*Data_size_lfp(2))),'int16'); %Check whether we need this tranpose!
            
       else
           stream2=1:duration:f_duration_sec*Rs;
           for stream=stream2(1:end-1)      %1:duration:f_duration_sec*Rs;
               alltimes = [stream:stream+(duration-1)];
               Data_edf= data_CHsel(alltimes, :);
               Data_lfp=  resample(Data_edf,1250, Rs);
               Data_size_lfp=  size(Data_lfp);
               fwrite(fid_lfp,int16(reshape(Data_lfp',1,Data_size_lfp(1)*Data_size_lfp(2))),'int16');
               process_time = strcat('stream', num2str(stream), 'out of', num2str(f_duration_sec*Rs), 'complete');
               disp(process_time)
           end
       end
       %%
       remaining_duration= f_duration_sec*Rs - (stream + (duration-1));
       if remaining_duration>0
           Data_edf= data_CHsel((stream + duration):end, :);
           Data_lfp= resample(Data_edf,1250, Rs);
           Data_size_lfp=  size(Data_lfp);
           fwrite(fid_lfp,int16(reshape(Data_lfp',1,Data_size_lfp(1)*Data_size_lfp(2))),'int16');
       else
            disp('Remainder of file written');
       end
end