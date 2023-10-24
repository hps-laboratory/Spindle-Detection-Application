function spindle = SpindleDurations(EventTable,SignalLength,Fs)
%---------------------------------------------------------- 
% ---INPUT---
% EventTable
% SignalLength
% 
% ---OUTPUT---
% spindle
% ---------------------------------------------------------

% EN:EventName
% EST:EventStartTime
% ED:EventDulation
% N :data length
%---
if nargin < 3; Fs = 200;end

EN  = EventTable.Annotation;
EST = EventTable.Onset;
ED  = EventTable.Duration;


%---Index of start time of spindle---
 x = find(strncmp('spindle',EN,7));
 w = find(strncmp('C3-spindle',EN,8));
%  v = find(strncmp('C4-spindle',EN,8));
 z = find(strncmp('spindleS/O',EN,8));
 
%---Spindle Duration---
 spindle   = CalcEachLabel(x,EST,ED,SignalLength,Fs);
 spindleC3 = CalcEachLabel(w,EST,ED,SignalLength,Fs);
%  spindleC4 = CalcEachLabel(v,EST,ED,SignalLength,Fs);
 spindleSO = CalcEachLabel(z,EST,ED,SignalLength,Fs);
 
 spindleC3 = spindle |spindleSO |spindleC3;
%  spindleC4 = spindle |spindleSO |spindleC4;

%  spindle   = horzcat(spindleC3,spindleC4);
 spindle = spindleC3;
end

%%
function spindle = CalcEachLabel(x,EST,ED,SignalLength,Fs)
     SpindleStart    = EST(x);
     SpindleDuration = ED(x);
     
     IndexStart = round(SpindleStart*Fs);
     IndexEnd   = IndexStart + round(SpindleDuration*Fs);
    
    spindle = zeros(SignalLength,1);
    for i = 1: length(IndexStart)
        spindle(IndexStart(i):IndexEnd(i),1) = 1 ;
    end
end




