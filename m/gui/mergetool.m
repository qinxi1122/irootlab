%> @ingroup guigroup mainguis
%> @file
%> @brief Tool to merge several files into a new dataset in the workspace.
%> @image html Screenshot-mergetool.png
%> <b>Directory containing multiple files</b> - directory where your are stored.
%> These were probably generated through the pre-processing OPUS macro.
%>
%> <b>File filter</b> - usually "*.dat" or "*.DAT"
%>
%> <b>Sample code trimming dot (right-to-left)</b> - allows you control over trimming off part of the filename for the <b>group code</b>.
%> For example, you may have several files like:
%> @code
%> sample1.0.dat
%> sample1.1.dat
%> sample1.2.dat
%> @endcode
%> All these are replicates of the same sample (named "sample1"). Specifying "2" for the trimming dot will get rid of
%> everything after the 2nd last dot counting from right to left. Thus, all spectra will have sample code "sample1".
%>
%> <h3>Image building options</h3>
%> If <b>Build image is checked</b>, the image <b>height</b> needs to be informed. The width is automatically calculated as the number of files in the directory divided by the informed <b>height</b>.

%> @cond
function varargout = mergetool(varargin)
% Last Modified by GUIDE v2.5 07-Nov-2011 21:54:49

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
set(handles.editStatus2, 'ForegroundColor', [0, 0, 0]);
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
            irerror(['Error reading window fields: ', ME.message]);
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
        set(handles.editStatus2, 'String', sprintf('%s! Variable name in workspace: %s; Number of rows: %d', ss, name_new, ds.no));
        if flag_error
            set(handles.editStatus2, 'ForegroundColor', [1, 0, 0]);
        else
            set(handles.editStatus2, 'ForegroundColor', [0, 0, 1]);
        end;
        
        path_assert();
        global PATH;
        PATH.data_spectra = get(handles.editPath, 'String');
        setup_write();
    catch ME
        send_error(ME);
    end;
end;



% --- Executes on button press in pushbuttonCheck.
function pushbuttonCheck_Callback(hObject, eventdata, handles)
set(handles.textStatus, 'String', 'Checking...');
try
    try
        wild = get_wild(handles);
        trimdot = eval(get(handles.editTrimdot, 'String'));
        flag_image = get(handles.checkbox_flag_image, 'Value');
        [filenames, groupcodes] = resolve_dir(wild, trimdot, flag_image);
    catch ME
        irerror(['Error reading window fields: ', ME.message]);
    end;
    
    n = numel(filenames);
    if n == 1
        splural = '';
    else
        splural = 's';
    end;
    s1 = '';
    if n > 0
        s1 = [' Group code example: ', groupcodes{1}];
    end;
    set(handles.textStatus, 'String', [int2str(n), ' file' splural ' found.', s1]);
catch ME
    set(handles.textStatus, 'String', 'Error occured');
    send_error(ME);
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
%> @endcond
