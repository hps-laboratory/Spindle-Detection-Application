function [Data,Data_st] = createDataset_Y(filepath,filelist,scale_flag)
if nargin < 3; scale_flag = false;end
% ----- Load training Data ----- %
Data  = [];
Data_st = [];
for i = 1 : length(filelist)
    load(fullfile(filepath,filelist(i).name),'Features','SubData');
    R = Features;
    R = rmmissing(R);
    inf_ind = isinf(R);
    inf_ind = inf_ind(:,1) + inf_ind(:,2) + inf_ind(:,3) > 0;
    N1 = size(R,2);
    Features = R;
    if scale_flag
        Features = zscore(Features);
    end
    % --- auto scale --- %
    Data   = vertcat(Data,Features);
    Data_st= vertcat(Data_st,SubData);
end
end