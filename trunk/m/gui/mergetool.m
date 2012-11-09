%> @ingroup guigroup mainguis
%> @file
%> @brief Tool to merge several single-spectrum files into a dataset.
%> @image html Screenshot-mergetool.png
%>
%> <b>File type</b> - Currently supported types are:
%> @arg "Pirouette .DAT" text format
%> @arg OPUS binary format
%> @arg Wire TXT format
%>
%> <b>Directory containing multiple files</b> - directory containing multiple single-spectrum files.
%>
%> <b>File filter</b> - wildcard filter. Examples: <code>*.*</code>; <code>*.dat</code>; <code>*.DAT</code>
%>
%> <b>Sample code trimming dot (right-to-left)</b> - allows you control over trimming off part of the filename for the <b>group code</b> of each spectrum.
%> For example, you may have several files like:
%> @verbatim
%> sample1.000.dat
%> sample1.001.dat
%> sample1.002.dat
%>        ^   ^ 
%>        |   |
%>        |   1 first dot (left-to-right)
%>        |
%>        2 second dot
%> @endverbatim
%> All these are spectra from the same sample (named "sample1"). Specifying "2" for the trimming dot will get rid of
%> everything after the 2nd last dot counting from right to left. Thus, all spectra will have sample code "sample1".
%>
%>
%> <h3>Image building options</h3>
%> If <b>Build image is checked</b>, the image <b>height</b> needs to be informed. The width is automatically calculated as the number of files in the directory divided by the informed <b>height</b>.
%> @note To build an image, the files need to have a sequential numbering between dots, as above. 

%> @cond
function varargout = mergetool(varargin)
% Last Modified by GUIDE v2.5 16-Oct-2012 09:00:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mergetool_OpeningFcn, ...
                   'gui_OutputFcn',  @mergetool_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before mergetool is made visible.
function mergetool_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>

% Choose default command line output for mergetool
handles.output = hObject;

setup_load();
path_assert();
global PATH;
set(handles.editPath, 'String', PATH.data_spectra);

% Update handles structure
guidata(hObject, handles);

gui_set_position(hObject);


% --- Outputs from this function are returned to the command line.
function varargout = mergetool_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


%=======================================================================================================================

%==============================
function add_log(handles, s)
a = get(handles.editStatus2, 'String');
s = {s};
set(handles.editStatus2, 'String', [a; s]);

%==============================
function morasse_lah(handles, filename, idx1, idx2, msg)
add_log(handles, filename);
% SLASH = '/';
add_log(handles, [repmat(' ', 1, idx1-1), repmat('-', 1, idx2-idx1+1)]);
add_log(handles, [repmat(' ', 1, idx2-1), '|']);
add_log(handles, [repmat(' ', 1, idx2-1), msg]);

%==============================
function do_checks(handles)
set(handles.editStatus2, 'String', '');
add_log(handles, '==> Checking... ==>');
try
    try
        wild = get_wild(handles);
        trimdot = eval(get(handles.editTrimdot, 'String'));
        flag_image = get(handles.checkbox_flag_image, 'Value');
        height = eval(get(handles.edit_height, 'String'));
    catch ME
        irerror(['Error: ', ME.message]);
    end;

    if flag_image && trimdot < 1
        irerror('For image building, "Sample code trimming dot" needs be at least 1!');
    end;

    a = dir(wild);
    a([a.isdir]) = [];
    n = numel(a);
    add_log(handles, sprintf('Number of files found: %d', n));
    
    if n > 0
        filename = a(1).name;
        idxs = find([filename, '.'] == '.');
        if numel(idxs) < trimdot+1
            irerror(sprintf('File name such as "%s" has only %d dot%s, whereas "Sample code trimming dot" is %d!', filename, numel(idxs)-1, iif(numel(idxs)-1 > 1, 's', ''), trimdot));
        end;
        idx1 = 1;
        idx2 = idxs(end-trimdot)-1;
        code = filename(1:idx2);
        morasse_lah(handles, filename, idx1, idx2, ['Sample code ("', code, '")']);

        if flag_image
            idx1 = idxs(end-trimdot)+1;
            idx2 = idxs(end-trimdot+1)-1;
            sorderref = filename(idx1:idx2);
            morasse_lah(handles, filename, idx1, idx2, ['Sequence number for image pixels ("', sorderref, '")']);
            orderref = str2double(sorderref);
            if isnan(orderref)
                irerror(sprintf('File part "%s" should be a number!', sorderref));
            end;
            
            if flag_image
                if height <= 0
                    irerror('Please specify image height!');
                end;

                if n/height ~= floor(n/height)
                    irerror(sprintf('Invalid image height: %d not divisible by %d!', n, height));
                end;
                
                add_log(handles, sprintf('Image width: %d', n/height));
            end;
        end;
    else
        irerror('No files!');
    end;        

    [filenames, groupcodes] = resolve_dir(wild, trimdot, flag_image);
    
    add_log(handles, sprintf('Number of samples: %d', numel(unique(groupcodes))));
    
    add_log(handles, '===> ...Passed!');
catch ME
    add_log(handles, ['===> ...Checking error: ', ME.message]);
    send_error(ME);
end;


function path_ = get_wild(handles)

% handles    structure with handles and user data (see GUIDATA)

path_ = get(handles.editPath, 'String');
filter = get(handles.editFilter, 'String');
if isempty(path_)
    path_ = '.';
end;
if path_(end) ~= '/'
    path_ = [path_ '/'];
end;

path_ = [path_ filter];

%=======================================================================================================================






function editPath_Callback(hObject, eventdata, handles)
set(handles.textStatus, 'String', '?');
set(handles.editStatus2, 'String', '?');

% --- Executes during object creation, after setting all properties.
function editPath_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editTarget_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function editTarget_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonGo.
function pushbuttonGo_Callback(hObject, eventdata, handles)
set(handles.editStatus2, 'String', '');
do_checks(handles);
path_ = get_wild(handles);
a = dir(path_);
if length(a) == 0
    msgbox('No files found in specified directory!');
else
    try
        try
            trimdot = eval(get(handles.editTrimdot, 'String'));
            flag_image = get(handles.checkbox_flag_image, 'Value');
            height = eval(get(handles.edit_height, 'String'));
            type = get(handles.popupmenu_type, 'Value');
        catch ME
            irerror(['Error: ', ME.message]);
        end;
        name_new = find_varname('ds');

        
        stypes = {'pir', 'opus', 'wire'};
        evalin('base', sprintf('[%s, flag_error] = %s2data(''%s'', %d, %d, %d);', ...
            name_new, stypes{type}, path_, trimdot, flag_image, height));

        ds = evalin('base', [name_new ';']);
        flag_error = evalin('base', 'flag_error;');
        
        if flag_error
            ss = 'Finished with errors. Check MATLAB command window output.';
        else
            ss = 'Success!';
        end;
        add_log(handles, sprintf('%s! Variable name in workspace: %s; Number of rows: %d', ss, name_new, ds.no));
        
        path_assert();
        global PATH;
        PATH.data_spectra = get(handles.editPath, 'String');
        setup_write();
    catch ME
        send_error(ME);
    end;
end;


% --- Executes on button press in pushbuttonOpen.
function pushbuttonOpen_Callback(hObject, eventdata, handles)
o = uigetdir(get(handles.editPath, 'String'));

if ~(isnumeric(o) && o == 0)
    set(handles.editPath, 'String', o);
end;

function editFilter_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function editFilter_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editTrimdot_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function editTrimdot_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonLaunch.
function pushbuttonLaunch_Callback(hObject, eventdata, handles)
datatool();

function editStatus2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function editStatus2_CreateFcn(hObject, eventdata, handles)

% --- Executes on button press in checkbox_flag_image.
function checkbox_flag_image_Callback(hObject, eventdata, handles)

function edit_height_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_height_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_type.
function popupmenu_type_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu_type_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function pushbutton_check_Callback(hObject, eventdata, handles)
do_checks(handles);
%> @endcond
