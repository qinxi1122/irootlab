%>@brief carried a histogram
classdef log_hist < log_grades
    properties
        %> [number of selected features]x[nf (total number of features dataset)]. Individual hits.
        hitss;
        %> Accumulated histogram
        grades;
        %> Calculates number of features to compose grades
        nf4grades_calculated;
        
        %> Extracted from data
        fea_x;
        %> Extracted from data
        xname;
        %> Extracted from data
        xunit;
    end;
end