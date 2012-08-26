%> @ingroup guigroup
%> @file uip_as_fsel_grades.m
%> @brief Properties Window for @ref as_fsel_grades
%> @image html Screenshot-uip_as_fsel_grades.png
%>
%> <b>Selection type</b> - see as_fsel_grades::type
%>
%> <b>Number of variables</b> - see as_fsel_grades::nf_select
%>
%> <b>Threshold</b> - see as_fsel_grades::threshold
%>
%> <b>Peak Detector</b> - see as_fsel_grades::peakdetector
%>
%> @sa as_fsel_grades

%> @cond
function varargout = uip_as_fsel_grades(varargin)
% Last Modified by GUIDE v2.5 26-Aug-2012 13:53:09

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
    output.params = {};
    varargout{1} = output;
end;

%############################################

%#########
function refresh(handles)
listbox_load_from_workspace('log_grades', handles.popupmenu_input, 0);
listbox_load_from_workspace('peakdetector', handles.popupmenuPeakdetector, 1);


%#########
function view1(handles)
cla(handles.axes1, 'reset');
axes(handles.axes1); %#ok<MAXES>
hold off;

sinput = listbox_get_selected_1stname(handles.popupmenu_input);

if isempty(sinput)
    msgbox('Cannot draw, input not specified!', 'Information');
else
    try
%         obj = evalin('base', [sinput, ';']); %#ok<NASGU>
%         eval([sinput, ' = obj;']); % Creates variable with same name as in base workspace, so that the next line is executed.
%         o = as_fsel_grades();
        evalin('base', ['global TEMP; TEMP = as_fsel_grades(); TEMP = TEMP.setbatch(', params2str(get_params(handles)), ');']);
        global TEMP; %#ok<*TLEV>
        log = TEMP.go();
        log.draw([], 1);
        clear TEMP;
    catch ME
%         irerrordlg(ME.message, 'Error');
rethrow(ME);
    end;
end;


%#########
function params = get_params(handles)

types = {'none', 'nf', 'threshold'};
sortmodes = {'grade', 'index'};


sinput = listbox_get_selected_1stname(handles.popupmenu_input);
if isempty(sinput)
    irerror('Input not specified!');
end;

spd = listbox_get_selected_1stname(handles.popupmenuPeakdetector);
if isempty(spd)
    spd = '[]';
end;
    
params = {...
'input', sinput, ...
'type', ['''' types{get(handles.popupmenuType, 'Value')} ''''], ...
'nf_select', int2str(eval(get(handles.editNf, 'String'))), ...
'threshold', get(handles.editThreshold, 'String'), ...
'peakdetector', spd, ...
'sortmode', ['''' sortmodes{get(handles.popupmenu_sortmode, 'Value')} ''''], ...
};




%############################################
function pushbuttonOk_Callback(hObject, eventdata, handles)
try
    handles.output.params = get_params(handles);
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
end;


function pushbutton_preview_Callback(hObject, eventdata, handles) %#ok<*INUSL>
view1(handles);

%############################################
%############################################




function editVariables_CreateFcn(hObject, eventdata, handles) %#ok<*DEFNU,*INUSD>
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenuType_Callback(hObject, eventdata, handles)
function popupmenuType_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function editNf_Callback(hObject, eventdata, handles)
function editNf_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function editThreshold_Callback(hObject, eventdata, handles)
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
