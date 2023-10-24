function EEG_epoch = splitData(EEG , Stage, param)

Fs_Y=param.Fs_Y;
TimeRange_Y= param.TimeRange_Y;

%StageTableのデータは'annnotation'のカラムに睡眠段階が記載
 N2_num = find((Stage.("annotation")== 'N2'));
 
EpochNum=numel(N2_num) ;  %epoch数
    EEG_epoch = cell(EpochNum-1,1);

    for j=1:numel(N2_num)
        StartSample=TimeRange_Y*(N2_num(j)-1)*Fs_Y+1;
        EndSample=TimeRange_Y*N2_num(j)*Fs_Y;
        EEG_epoch{j,1} = EEG(StartSample:EndSample,:);
    end
    
    
  end