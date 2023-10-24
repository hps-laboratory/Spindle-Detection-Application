function [Data,Target,Data_st,Index] = createDataset(filepath,filelist,scale_flag)
    if nargin < 3; scale_flag = false;end
    
% ----- Load training Data ----- %  
    Data  = [];
    Target= [];
    Data_st = [];
    Index   = []; 
    for i = 1 : length(filelist)
        filename = fullfile(filepath,filelist(i).name);
        load(filename,'Features','SubData','targets','SubIndex')
        R = [Features,targets];
        R = rmmissing(R);
        inf_ind = isinf(R);
        inf_ind = inf_ind(:,1) + inf_ind(:,2) + inf_ind(:,3) > 0;
        N1 = size(R,2);
        Features = R(:,1:N1-1);
        targets = R(:,N1);
        if scale_flag
            Features = zscore(Features);
        end
        % --- auto scale --- %
        Data   = vertcat(Data,Features);
        Target = vertcat(Target,targets);
        Data_st= vertcat(Data_st,SubData);
        Index  = vertcat(Index,SubIndex);
    end
end