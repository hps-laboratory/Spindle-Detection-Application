%スピンドルを検出したいEDFファイルを保存している場所
EDF_folder   = '..\EDF\';
filelist_edf = dir(EDF_folder);     filelist_edf(1:2) = [];
EEG_mat_dir = '..\data_saved\mat_file\';

params.T  = 30;
params.Fs = 200;%読み込むEDFファイルのサンプリングレートに変更
params.win_len = 0.5;
params.slide_len = 0.25;
params.rate = 0.75;
sample_per_30s = 110;

for i = 1 : length(filelist_edf)
    
    filename_edf  = strcat(EDF_folder,filelist_edf(i).name);
    PSGData  = ConvertEDF(filename_edf,'EEG');%読み込むEDFファイルによってチャンネル名のへんこうが必須
    signallength = size(PSGData.EEG,1);
    PSGData.EEG=lowpass(PSGData.EEG,60,params.Fs);
    filecell =  strsplit(filelist_edf(i).name,'.');
    savefilename = strcat(EEG_mat_dir,filecell{1},'.mat');
    Num_spindle  = zeros(1,2);
    close all
    
    disp(i)
    save(savefilename,'PSGData')
end

% 睡眠段階データの変換
%スピンドルを検出したいデータの睡眠段階を保存している場所
%睡眠段階のファイル名はEDFのものと一致させる
Stage_csv = '..\SleepStage\';
filelist_stage = dir(Stage_csv); filelist_stage(1:2) = [];
Stage_mat = '..\data_saved\SleepStage_mat\';

for i = 1 : length(filelist_stage)
    name_cell = strsplit(filelist_stage(i).name,'.');
    filename = strcat(Stage_csv,filelist_stage(i).name);
    StageTable = readtable(filename);
    save(strcat(Stage_mat,name_cell{1},'.mat'),'StageTable');
end

%%
% EEGデータの分割とSST
%%

Stage_mat = '..\\data_saved\SleepStage_mat\';
filelist_EEG = dir(EEG_mat_dir); filelist_EEG(1:2) = [];
filelist_stage = dir(Stage_mat); filelist_stage(1:2) = [];


%%前処理の途中過程を順々に保存
%保存先
SegmentedEEG_dir  = '..\\data_saved\SegmentedEEG\';%全EEGからN2部分のみ切り出したEEG
SST_coeff_dir = '..\\data_saved\SST-coeff\';%SST係数
Feature_dir   = '..\\data_saved\FeatureMatrix\';%


for i = 1 : length(filelist_EEG)
    disp(i)
    load(strcat(EEG_mat_dir,filelist_EEG(i).name))
    load(strcat(Stage_mat,filelist_stage(i).name))
    
    Stage=StageTable;
    
    %------C3_chanel------%
    EEG=PSGData.EEG(:,1);
    %睡眠段階データからN2を見つける
    N2=contains(Stage.("annotation"),'N2');%StageTableのデータは'annnotation'のカラムに睡眠段階が記載
    z=[1:numel(Stage.("onset"))];%'annnotation'のカラムにEpochが記載
    N2_num=z(N2);

    %N2が存在する部分のEEGを30秒窓で切り出し
    Fs_Y=200;
    TimeRange_Y=30;
    EpochNum=numel(N2_num) ;  %epoch数
    EEG_epoch = cell(EpochNum-1,1);

    for j=1:numel(N2_num)
        StartSample=TimeRange_Y*(N2_num(j)-1)*Fs_Y+1;
        EndSample=TimeRange_Y*N2_num(j)*Fs_Y;
        EEG_epoch{j,1} = EEG(StartSample:EndSample,:);
    end
    
    
    savefilename  = strcat(SegmentedEEG_dir,filelist_EEG(i).name);
    save(savefilename,'EEG_epoch');
    
    % ----- SST係数の計算 ------ %
    SST = cell(EpochNum,2);
    for k = 1:EpochNum
        X = EEG_epoch{k,1};
        X = X(:,1);
        [SST{k,1},SST{k,2}] = SST_coeff(X,params.Fs);
        sst_coeff=SST{k,1};
        
        f=SST{k,2};
    end
    savefilename  = strcat(SST_coeff_dir,filelist_EEG(i).name);
    save(savefilename,'sst_coeff','f','-v7.3');
    load(savefilename)
    
    
    % ------- SST係数を用いた特徴抽出 --------- %
    [Features,SubData] = FeatureExtraction(SST,params,EEG_epoch);
    savefilename = strcat(Feature_dir,'\',filelist_EEG(i).name);
    save(savefilename,'Features','SubData','-v7.3');

    disp(filelist_EEG(i).name)
end

%%
%%モデルの構築
%-----アンダーサンプリングの比率を決めるパラメータの設定-------%
%今回はスピンドル10000件、ノンスピンドル70000件に不均衡を調整
Num = 10000;
u = 7;
%-----------------------------------------------------
%学習データパス
file_path = '..\\FeatureMatrix_learn\';
filelist = dir(file_path);filelist(1:2) = [];
filelist(3:4) = [];
N_sub = length(filelist);
%実際にスピンドルを検出するデータの読み込み
file_path2 = '..\\data_saved\FeatureMatrix\';
filelist_2 = dir(file_path2);filelist_2(1:2) = [];

fig_savedir = '..\\code\';
rng('default');

% ==== Load Data ==== %
index  = (1:1:N_sub);


% ------ create dataset and under sampling (Traindata and validation Data)
[TrainData,TrainTarget,~,~] = createDataset(file_path,filelist(index),false);
[TrainData,TrainTarget] = UnderSampling_ne(TrainData,TrainTarget,u,Num);%アンダーサンプリング

% --- RUSBoostモデルの構築 --- %
parameterlist = hyperparameters('fitcensemble',TrainData,TrainTarget,'Tree');
parameterlist = parameterlist(2:4);
parameterlist(3,1).Range = [1,300];
Optimize_options = struct('Optimizer','bayesopt','AcquisitionFunctionName','expected-improvement-per-second-plus',...
    'MaxObjectiveEvaluations',15,'UsePArallel',false,'Holdout',0.3);
Models.RUSB_model = fitcensemble(TrainData,TrainTarget,'Method','RUSBoost',...
    'Learners','tree','RatioToSmallest',3,'OptimizeHyperparameters',parameterlist,...
    'HyperparameterOptimizationOptions',Optimize_options);
% ---

close all


% ---スピンドルの検出--- %
for m=1:length(filelist_2)
    TestSub2 = m;
    %テストデータの作成
    [TestData_Y,TestData_st_Y] = createDataset_Y(file_path2,filelist_2(TestSub2),false);
    
    params.T  = 30;
    params.Fs = 200;
    params.win_len = 0.5;
    params.slide_len = 0.25;
    params.rate = 0.75;
    sample_per_30s = 110;
    
    RUSB_estimation = predict(Models.RUSB_model,TestData_Y);



     %---------figureの保存先のディレクトリの作成----------%
    filecell =  strsplit(filelist_edf(m).name,'.');
    dirname = filecell(1);
    dirname = string(strcat('Figure\',dirname));
    mkdir(dirname)
   
    %スピンドルの検出結果の可視化
   [~,Spindle_num]= Calc_ConsufionMat(TestData_st_Y,RUSB_estimation,params,sample_per_30s,strcat(fig_savedir,dirname,'\'));

end

%モデルの保存
savefilename = strcat('..\\Model\','models.mat');
save(savefilename,'Models','-v7.3')
