%> @brief Basic TXT loader/saver
%>
%> Description of the "basic" file type (Figure 1):
%> <ul>
%>   <li>Table of data with no header and last column containing the class index.</li>
%>   <li>Delimiters such as ';', ' ', or '\t' (Tab) are supported.</li>
%> </ul>
%>
%> Because class labels and x-axis are not stored in the file,
%> <ul>
%>   <li>Class labels are made up as "Class 0", "Class 1" etc</li>
%>   <li>Unless the x-axis range is passed to load(), the default value [1801.47, 898.81] (Bruker Tensor27-aquired spectra, then cut to
%> 1800-900 region in OPUS)</li>
%>
%> @image html dataformat_basic.png
%> <center>Figure 1 - basic TXT file type</center>
%> </ul>
classdef dataio_txt_basic < dataio
    methods
        function o = dataio_txt_basic()
            o.flag_xaxis = 0;
        end;

        
        
        %> Loader
        function data = load(o, range)

            [no_cols, delimiter] = get_no_cols_deli(o.filename);

            data = irdata();

            if nargin < 2 || isempty(range)
                data.fea_x = 1:no_cols-1;
            else
                data.fea_x = linspace(range(1), range(2), no_cols-1);
            end;



            % Mounts mask
            mask_data = [repmat('%f', 1, no_cols-1) '%q'];

            % Opens for the second time in order to actually read the file
            fid = fopen(o.filename);

            c_data = textscan(fid, mask_data, 'Delimiter', delimiter);
            fclose(fid);

            % Resolves easy one
            data.X = cell2mat(c_data(1:end-1));

            % Resolves classes
            clalpha = c_data{end};
            if ~iscell(clalpha)
                clalpha = cellfun(@num2str, num2cell(clalpha), 'UniformOutput', 0);
            end;
            data.classlabels = unique_appear(clalpha');
            
            no_obs = size(data.X, 1);
            data.classes(no_obs, 1) = -1; % pre-allocates
            for i = 1:no_obs
                data.classes(i) = find(strcmp(data.classlabels, clalpha{i}))-1;
            end;
            
            
            data.filename = o.filename;
            data.filetype = 'txt';
        end;

        
        
        
        
        
        
        %> Saver 
        function o = save(o, data)

            h = fopen(o.filename, 'w');
            if h < 1
                irerror(sprintf('Could not create file ''%s''!', o.filename));
            end;

            labels = classes2labels(data.classes, data.classlabels);
            
            for i = 1:data.no
                fwrite(h, [sprintf('%g\t', data.X(i, :)) labels{i} sprintf('\n')]);
            end;

            fclose(h);
            
            irverbose(sprintf('Just saved file "%s"', o.filename), 2);
        end;
    end
end