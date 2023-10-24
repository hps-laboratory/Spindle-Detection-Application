function spindle_auto = Label2Duration_Y(spindle_label_auto,params)

%EVALUATE_SPINDLE 睡眠紡錘波のラベルからdurationデータへの変換
%   詳細説明をここに記述

    Fs = params.Fs;
    T  = params.T;
    win_len = params.win_len*Fs;
    slide_len = params.slide_len*Fs;
   
    spindle_auto = zeros(Fs*T,1);
    spindle_auto_ind = find(spindle_label_auto==1);
    
    for j = 1 :length(spindle_auto_ind)
         StartIndex = Fs + spindle_auto_ind(j)*slide_len;
         EndIndex   = StartIndex + win_len;
%          spindle_auto(StartIndex:EndIndex,1) = spindle_auto(StartIndex:EndIndex,1) + spindle_prob(spindle_auto_ind(j),1);
         spindle_auto(StartIndex:EndIndex,1) = spindle_auto(StartIndex:EndIndex,1)+1;
    end
    spindle_auto(end-Fs:end,1) = 0;
    spindle_auto(:,1) = spindle_auto(:,1) >= 2;
    
    auto_Start = find(diff([0;spindle_auto;0])==1);
    auto_End   = find(diff([0;spindle_auto;0])==-1);
    auto_duration = find(auto_End - auto_Start <= 0.4*Fs);
    if isempty(auto_duration) == 0
        for jj = 1 :length(auto_duration)
            spindle_auto(auto_Start(auto_duration(jj))-1:auto_End(auto_duration(jj))+1,1) = 0;
        end
    end
    
end

