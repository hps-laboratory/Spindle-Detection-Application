function Eventtable = csv2mat_mass(csvfilename)
    Annotation = readtable(csvfilename);
    Duration   = Annotation.duration;
    Onset  = Annotation.start;
    Annotation  = {};
    for i = 1 : length(Duration)
        Annotation = vertcat(Annotation,'C3-spindle');
    end
    Eventtable = table(Annotation,Onset,Duration);
end