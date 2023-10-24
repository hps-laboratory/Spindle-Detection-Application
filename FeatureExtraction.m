function [Data_integrated,Data] = YAMAHA_FeatureExtraction3(SST,params,EEG_epoch)
%  YAMAHA_FEATUREEXTRACTION 特徴抽出
%パラメータ
% --- Parameters settings --- %

win_len   = params.win_len;
slide_len = params.slide_len;
T = params.T;


% --- Initializeation --- %
Fs = params.Fs;
t1 = 0 : 1/Fs : params.T - 1/Fs;
win_len   = win_len*Fs;
slide_len = slide_len*Fs;

tic
Data = struct;
Data_integrated = [];
count = 1;

for i = 1:length(EEG_epoch) %epochごとに計算
    test_Matrix_temp  = [];
    X = EEG_epoch{i,1};
    sst = SST{i,1};
    f = SST{i,2};
    
    StartIndex =1 + Fs;
    EndIndex   = StartIndex + win_len;
    
    Low_ind = f >= 4 & f <= 10;
    High_ind= f >= 20& f <= 40;
    Spindle_ind = f >= 11 & f <= 16;
    ind=0;
    % --- window sliding と feature extraction--- %
    while EndIndex <= (T-1)*Fs
        % --- sigma index(max)の計算 --- %
        LowRange     = max(mean(sst(Low_ind,:)),0.01);
        HighRange    = max(mean(sst(High_ind,:)),0.01);
        SpindleRange1= max(sst(Spindle_ind,:));
        
        %指標1　sst係数
        sigma_index = SpindleRange1./(LowRange+HighRange);
        t = 0:1/params.Fs:22-1/params.Fs;
        ind = 0;
        R = sigma_index;
        R_ = R(:,1:end -2*params.Fs);
        R__= R(:,2*Fs+1:end);
        R  = R(:,Fs + 1:end -Fs);
        sR = max(R_ + R__,0.01);
        %指標2 Rがいる
        Rat = max(R ./sR,0.1);
        %指標3　EEGデータのみ
        teager_energy = X(2:end-1,1).^2-X(1:end-2,1).*X(2:end-1,1);
        
        %お試しプロット
        if i == 5
            subplot(4,1,1)
            plot(t1,EEG_epoch{(i), 1}(:,1))
            ylabel('[μV]')
            ylim([-60 60])
            
            subplot(4,1,2)
            plot(t1,sigma_index)
            
            subplot(4,1,3)
            plot(t1(1:end-2*Fs),Rat)
            
            subplot(4,1,4)
            plot(t1(2:end-1),teager_energy)
            xlabel('time [s]')
        end
        % --- window sliding と feature extraction--- %
        while EndIndex <= (T-1)*Fs
            Rat_temp = Rat(StartIndex-Fs:EndIndex-Fs);
            sigma_ratio1 = max(Rat_temp);
            sigma_ratio2 = median(Rat_temp);
            sigma_ratio4 = mean(Rat_temp);
            sigma_temp = sigma_index(StartIndex:EndIndex);
            sigma_index1 = max(sigma_temp);
            sigma_index2 = median(sigma_temp);
            sigma_index3 = mean(sigma_temp);
            
            tempFeature   = [sigma_index1,...
                             sigma_index2,...
                             sigma_index3,...
                             sigma_ratio1,...
                             sigma_ratio2,...
                             sigma_ratio4];
            teager        = teager_energy(StartIndex+1:EndIndex-1,1);
            test_Matrix_temp = vertcat(test_Matrix_temp,[tempFeature,mean(teager),median(teager),std(teager)]);
            
            % --- renew Start and End Index --- %
            StartIndex = StartIndex + slide_len;
            EndIndex   = EndIndex   + slide_len;
            ind = ind+1;
        end
        test_Matrix_temp(:,1:6) = log(test_Matrix_temp(:,1:6));
        Data(i).EEG = EEG_epoch{(i), 1}(:,1);
        Data(i).SI  = sigma_index;
        Data(i).SR  = Rat;
        Data(i).Teager = teager_energy;
        Data_integrated = vertcat(Data_integrated,test_Matrix_temp);
        count = count + 1;
    end
    
end
end