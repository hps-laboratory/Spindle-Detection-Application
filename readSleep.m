function data = readSleep(filename)

data = readtable(filename, 'VariableNamingRule','preserve');

data.annotation = categorical(data.annotation);

end