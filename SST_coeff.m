function [sst_coeff,f] = SST_coeff(Stage2PSGData,Fs)

% --- Input --- %
% EEGfilepath : the path of Stage segmented EEG file 
% 
% --- Output --- %
% sst_coeff : struct data 
% f : frequency vector


% --- 1のイテレータだけ --- %
[tempsst_coeff,f] = wsst(Stage2PSGData,Fs,'amor');
sst_coeff   = abs(tempsst_coeff);

end