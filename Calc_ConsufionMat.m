function [Conf_mat,Spindle_num,spindleToT] = Calc_ConsufionMat(TestData,predicted_label,params,sample_per_epoch,filename)
Conf_mat = zeros(2);
% Spindle_num_sum=0;

% Spindle_num = zeros(length(predicted_label)/sample_per_epoch,2);
Spindle_num = cell(length(predicted_label)/sample_per_epoch,4);
spindleToT =0;
for i =  1 :length(predicted_label)/sample_per_epoch
    tempLabel = predicted_label((i-1)*sample_per_epoch+1:i*sample_per_epoch,:);
    spindle_auto = Label2Duration_Y(tempLabel,params);
%     spindle_(i).spindle_auto = spindle_auto;
    Fs = params.Fs;
    t = 0 : 1/Fs : params.T-1/Fs;
    
    spindle_E1 = vertcat(0,spindle_auto(:,1),0);
    SpindleStartE1 = find(diff(spindle_E1)==1);
    SpindleEndE1   = find(diff(spindle_E1)==-1)-1;
    
    if (isempty(SpindleStartE1))
        SpindleStartE1 = NaN;
        
        countSpindle = 0;
    else
        countSpindle = length(SpindleStartE1);
    end

    if (isempty(SpindleEndE1))
        SpindleEndE1 =NaN;
    end
    
    if nargin == 5
        figure('visible','off')
        subplot(4,1,1)
         ColorSpindleArea4MASS(TestData(i).EEG(:,1),spindle_auto,200);
        
        subplot(4,1,2)
        plot(t(1:size(TestData(i).SI,2)),TestData(i).SI)
        ylabel('SI')
        
        subplot(4,1,3)
        plot(t(1:end-2*Fs),TestData(i).SR)
        ylabel('SR')
        
        subplot(4,1,4)
        plot(t(2:end-1),TestData(i).Teager)
        ylabel('TE')
        xlabel('time [s]')
%         saveas(gcf,strcat(filename,string(i),'.png'))
        exportgraphics(gcf,strcat(filename,'_',string(i),'.png'),'Resolution',300)
        %savefig(strcat(filename,string(i),'.fig'))
%         close all
    end
%     Spindle_num_sum = Spindle_num_sum + length(SpindleStartE1);
disp(i)
    Spindle_num{i,1} = i;
    Spindle_num{i,2} = countSpindle;
    Spindle_num{i,3} = SpindleStartE1;
    Spindle_num{i,4} = SpindleEndE1;
    spindleToT = spindleToT + countSpindle;
    
end

 Spindle_num = array2table(Spindle_num, ...
    'VariableNames',{'FrameNumber','spindleNum','SpindleStartE1','SpindleEndE1'});

end