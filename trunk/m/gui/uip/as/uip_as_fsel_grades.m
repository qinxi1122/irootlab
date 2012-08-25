%> @ingroup guigroup
%> @file uip_as_fsel_grades.m
%> @brief Properties Window for @ref fsel_grades_fsg
%> @image html Screenshot-uip_as_fsel_grades.png
%>
%> <b>Selection type</b> - see fsel_grades::type
%>
%> <b>Number of variables</b> - see fsel_grades::nf_select
%>
%> <b>Threshold</b> - see fsel_grades::threshold
%>
%> <b>Peak Detector</b> - see fsel_grades::peakdetector
%>
%> @sa fsel_grades_fsg

%> @cond
function varargout = uip_as_fsel_grades(varargin)
% Last Modified by GUIDE v2.5 07-Aug-2012 19:50:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_as_fsel_grades_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_as_fsel_grades_OutputFcn, ...
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

% --- Executes just before uip_as_fsel_grades is made visible.
function uip_as_fsel_grades_OpeningFcn(hObject, eventdata, handles, varargin)
if numel(varargin) < 3
    handles.input.flag_needs_fsg = 0;
else
    handles.input.flag_needs_fsg = varargin{3};
end;
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);
refresh(handles);

% --- Outputs from this function are returned to the command clae.
function varargout = uip_as_fsel_grades_OutputFcn(hObject, eventdata, handles) 
try
    uiwait(handles.figure1);
    handles = guidata(hObject);
    varargout{1} = handles.output;
    delete(gcf);
catch
    output.flag_ok = 0;
    output.params = {}
    varargout{1} = output;
end;

%############################################

%#########
function refresh(handles)
listbox_load_from_workspace('log_as_grades', handles.popupmenu_input, 0);
listbox_load_from_workspace('peakdetector', handles.popupmenuPeakdetector, 1);
listbox_load_from_workspace('fsg', handles.popupmenu_fsg, ~handles.input.flag_needs_fsg);

%############################################
%############################################


% --- Executes on button press in pushbuttonOk.
function pushbuttonOk_Callback(hObject, eventdata, handles)
try
    types = {'none', 'nf', 'threshold'};
    
    sortmodes = {'grade', 'index'};

    flag_optimize = get(handles.checkbox_flag_optimize, 'Value');
    
    sinput = listbox_get_selected_1stname(handles.popupmenu_input);
    if isempty(sinput)
        irerror('Input not specified!');
    end;

    sfsg = listbox_get_selected_1stname(handles.popupmenu_fsg);
    if isempty(sfsg)
        if handles.input.flag_needs_fsg
            irerror('FSG object not specified!');
        elseif flag_optimize
            irerror('FSG object needs to be specified to perform optimization of number of features!');
        else
            sfsg = '[]';
        end;
    end;

    spd = listbox_get_selected_1stname(handles.popupmenuPeakdetector);
    if isempty(spd)
        spd = '[]';
    end;
    
    other = uip_as_fsel();
    if other.flag_ok
        handles.output.params = [other.params, {...
        'input', sinput, ...
        'fsg', sfsg ...
        'type', ['''' types{get(handles.popupmenuType, 'Value')} ''''], ...
        'nf_select', int2str(eval(get(handles.editNf, 'String'))), ...
        'threshold', get(handles.editThreshold, 'String'), ...
        'peakdetector', spd, ...
        'flag_optimize', int2str(flag_optimize), ...
        'sortmode', ['''' sortmodes{get(handles.popupmenu_sortmode, 'Value')} ''''], ...
        }];
        handles.output.flag_ok = 1;
        guidata(hObject, handles);
        uiresume();
    end;
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;

function editVariables_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function editVariables_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenuType.
function popupmenuType_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenuType_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editNf_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function editNf_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editThreshold_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function editThreshold_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenuFsg_Callback(hObject, eventdata, handles)

function popupmenuFsg_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenuPeakdetector_Callback(hObject, eventdata, handles)

function popupmenuPeakdetector_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu_fsg_Callback(hObject, eventdata, handles)

function popupmenu_fsg_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function checkbox_flag_optimize_Callback(hObject, eventdata, handles)

function popupmenu_sortmode_Callback(hObject, eventdata, handles)

function popupmenu_sortmode_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu_input_Callback(hObject, eventdata, handles)
function popupmenu_input_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%> @endcond
