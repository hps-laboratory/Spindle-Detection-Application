function PSGdata = ConvertEDF(filename,datatype) 
%-------------------------------------------------- 
% EDFファイルをmat形式に変換してstructデータに変換するための関数
% 
% 
%-------------------------------------------------- 
if nargin < 2; datatype = 'EEG_notnecessary';end

    [hdr,sighdr,data] = blockEdfLoad(filename);

if strcmp('EEG',datatype)
    for i = 1 : length(sighdr)
        %%読み込むEDFファイルのチャンネルを指定
        if strcmp(sighdr(i).signal_labels,'EEG C3-A2')
            C3_index = i;
        elseif strcmp(sighdr(i).signal_labels,'EEG C4-A1')
            C4_index = i;
        elseif strcmp(sighdr(i).signal_labels,'EEG O1-A2')
            O1_index = i;
        elseif strcmp(sighdr(i).signal_labels,'EEG O2-A1')
            O2_index = i;
        elseif strcmp(sighdr(i).signal_labels,'EMG Chin')
            EMG_index = i;
        elseif contains(sighdr(i).signal_labels,'ECG')
            ECG_index = i;
        elseif contains(sighdr(i).signal_labels,'EOG Right')
            EOG_R_index = i;
        elseif contains(sighdr(i).signal_labels,'EOG Left')
            EOG_L_index = i;
        end
    end
    C3 = data{1,C3_index};
    C4 = data{1,C4_index};
    O1 = data{1,O1_index};
    O2 = data{1,O2_index};
    EEG = horzcat(C3,C4,O1,O2);

    EMGchin = data{1,EMG_index};
    ECG = data{1,ECG_index};
    
    try
        LEOG = data{1,EOG_L_index};
        REOG = data{1,EOG_R_index};
        EOG = horzcat(LEOG,REOG);
    catch
        EOG = zeros(length(data{i}),2);
    end
     
    
   
else
    C3 = data{1,1};
    C4 = data{1,2};
    O1 = data{1,3};
    O2 = data{1,4};
    EEG = horzcat(C3,C4,O1,O2);
    LEOG = data{1,5};
    REOG = data{1,6};
    EOG = horzcat(LEOG,REOG);
    
    EMGchin = data{1,7};
    ECG = data{1,8};
end
    PSGdata = struct('EEG',EEG,'EOG',EOG,'EMGchin',EMGchin,'ECG',ECG);
end