function outString = SpindleTimeconvertToString(celldata)

if (isnan(celldata))
    outString = "";
else
    outString = string(celldata(1)) ;

    if (numel(celldata) >1)
        for i =2:numel(celldata)
            outString = outString +" ; " + string(celldata(i));
        end
    end
end
end