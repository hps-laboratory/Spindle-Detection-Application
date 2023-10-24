function [SST,sst_coeff,f] = computeSSTcoef(EEG_epoch, params)


EpochNum = size(EEG_epoch,1);

SST = cell(EpochNum,2);


for k = 1:EpochNum
    X = EEG_epoch{k,1};
    X = X(:,1);
    [SST{k,1},SST{k,2}] = SST_coeff(X,params.Fs);
    sst_coeff=SST{k,1};
    
    f=SST{k,2};
end
  
end