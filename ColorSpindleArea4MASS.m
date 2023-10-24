function  ColorSpindleArea4MASS(EEG,SpindleSegment_E1,Fs_old)
%----------------------------------------------------------
% spindle‹æŠÔ‚ğ’…F‚·‚é‚½‚ß‚ÌŠÖ”
% Auto:ÔF
%----------------------------------------------------------

N  = size(EEG,1);
T  = N/Fs_old;

t  = 0:1/Fs_old:T-1/Fs_old;
spindle_E1 = vertcat(0,SpindleSegment_E1(:,1),0);


SpindleStartE1 = find(diff(spindle_E1)==1);
SpindleEndE1   = find(diff(spindle_E1)==-1)-1;



plot(t,EEG(:,1))
ylabel('EEG [ƒÊV]')
ylim([-80 80])
for i = 1 :length(SpindleStartE1)
    Square_coloring([t(SpindleStartE1(i)) t(SpindleEndE1(i))],'red');
end
hold on

end