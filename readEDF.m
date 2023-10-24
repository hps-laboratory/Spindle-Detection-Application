function data = readEDF(filename, params)

arguments
    filename ;  % data file name 
    params struct;  % parameter structure
end

disp(filename)
data  = ConvertEDF(filename,'EEG');%読み込むEDFファイルによってチャンネル名のへんこうが必須

% EEG にローパスフィルタを掛ける
data.EEG=lowpass(data.EEG,60,params.Fs);

end  