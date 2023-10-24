function [UnderSampledDataset,UnderSampledTarget] = UnderSampling_ne(Dataset,Targets,ratio,Num_pos)
%UNTITLED2 この関数の概要をここに記述
%   詳細説明をここに記述
    PositiveSample = Dataset(Targets==1,:);
    NegativeSample = Dataset(Targets==0,:);
    N_pos = sum(Targets==1);
    N_ne = sum(Targets==0);
    Num_pos = min(N_pos,Num_pos);
    N_sample = min(ratio*Num_pos,N_ne);
    Ind_pos=randperm(N_pos,Num_pos);
    Ind_ne = randperm(N_ne,N_sample);
    NegativeSample = NegativeSample(Ind_ne,:);
    PositiveSample = PositiveSample(Ind_pos,:);
    UnderSampledDataset = vertcat(PositiveSample,NegativeSample);
    UnderSampledTarget  = vertcat(ones(Num_pos,1),zeros(N_sample,1));
end

