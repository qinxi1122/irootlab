%> @ingroup guigroup
%> @file
%> @brief Rater (@ref rater) Properties Window
%> @image html Screenshot-uip_rater.png
%>
%> <b>Classifier</b> - see rater::clssr
%>
%> <b>Decider</b> - see rater::decider
%>
%> <b>SGS</b> - see rater::sgs
%>
%> <b>Estimation Log</b> - see rater::ttlog
%>
%> <b>Dataset</b> - see rater::data
%>
%> @sa @ref rater


%> @cond
function varargout = uip_rater(varargin)
% Last Modified by GUIDE v2.5 25-Jun-2011 19:39:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_rater_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_rater_OutputFcn, ...
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


% --- Executes just before uip_rater is made visible.
function uip_rater_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);
refresh(handles);

% --- Outputs from this function are returned to the command clae.
function varargout = uip_rater_OutputFcn(hObject, eventdata, handles) 
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
listbox_load_from_workspace('irdata', handles.popupmenu_data, 0);
listbox_load_from_workspace('sgs', handles.popupmenu_sgs, 1);
listbox_load_from_workspace('ttlog', handles.popupmenu_estlog, 1);
listbox_load_from_workspace('decider', handles.popupmenu_decider, 1);
listbox_load_from_workspace({'clssr', 'block_cascade_base'}, handles.popupmenu_clssr, 1);


%############################################
%############################################

% --- Executes on button press in pushbuttonOK.
function pushbuttonOK_Callback(hObject, eventdata, handles)
try
    sclssr = listbox_get_selected_1stname(handles.popupmenu_clssr);
    if isempty(sclssr)
        sclssr = '[]';
    end;
    sdecider = listbox_get_selected_1stname(handles.popupmenu_decider);
    if isempty(sdecider)
        sdecider = '[]';
    end;
    ssgs = listbox_get_selected_1stname(handles.popupmenu_sgs);
    if isempty(ssgs)
         ssgs = '[]';
    end;
    sestlog = listbox_get_selected_1stname(handles.popupmenu_estlog);
    if isempty(sestlog)
        sestlog = '[]';
    end;
    sdata = listbox_get_selected_1stname(handles.popupmenu_data);
    if isempty(sdata)
        error('Dataset not specified!');
    end;
    
    handles.output.params = {...
    'clssr', sclssr, ...
    'decider', sdecider, ...
    'sgs', ssgs, ...
    'ttlog', sestlog, ...
    'data', sdata ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;


% --- Executes on selection change in popupmenu_estlog.
function popupmenu_estlog_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu_estlog_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_data.
function popupmenu_data_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu_data_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_sgs.
function popupmenu_sgs_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu_sgs_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_decider.
function popupmenu_decider_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function popupmenu_decider_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_clssr.
function popupmenu_clssr_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function popupmenu_clssr_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%> @endcond
