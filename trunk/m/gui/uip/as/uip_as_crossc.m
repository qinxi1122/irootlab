%> @ingroup guigroup
%> @file
%> @brief Properties Window for Loadings Plot visualization
%> @image html Screenshot-uip_as_crossc.png
%> <p>Options:</p>
%> <p><b>Indexes of loadings to plog</b> - vector</p>
%> <p><b>Dataset for x-axis and hint curve</b> - loadings coefficients are the y-axis values, so the x-axis values need
%> to be taken from somewhere else. The hint curve is drawn first in a dashed thin line. It is calculated as the average
%> spectrum in the dataset. This curve helps interpretation of the loadings curves.</p>
%> <p><b>Peak detector</b> - This is a @c peakdetector object, If specified, peaks will be detected and drawn.</p>
%> <p><b>Trace "minimum altitude" line from peak detector</b> - If checked, the minimum altitude threshold lines will be drawn.</p>
%> <p><b>Flip negative values</b> - If checked, the absolute values of the loadings will be taken before doing the drawing.</p>
%> @cond
function varargout = uip_as_crossc(varargin)
% Last Modified by GUIDE v2.5 25-Sep-2011 20:21:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_as_crossc_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_as_crossc_OutputFcn, ...
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


% --- Executes just before uip_as_crossc is made visible.
function uip_as_crossc_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);
refresh(handles);

% --- Outputs from this function are returned to the command clae.
function varargout = uip_as_crossc_OutputFcn(hObject, eventdata, handles) 
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
%############################################

%#########
function refresh(handles)
listbox_load_from_workspace({'fcon_linear', 'block_cascade_base'}, handles.popupmenu_mold, 0);
listbox_load_from_workspace('sgs', handles.popupmenu_sgs, 1);
listbox_load_from_workspace('irdata', handles.popupmenu_data, 0);

%############################################
%############################################

% --- Executes on button press in pushbuttonOK.
function pushbuttonOK_Callback(hObject, eventdata, handles)
try
    smold = listbox_get_selected_1stname(handles.popupmenu_mold);
    if isempty(smold)
        irerror('Mold Block not specified!');
    end;
    ssgs = listbox_get_selected_1stname(handles.popupmenu_sgs);
    if isempty(ssgs)
        ssgs = '[]';
    end;
    sdata = listbox_get_selected_1stname(handles.popupmenu_data);
    if isempty(sdata)
        error('Dataset not specified!');
    end;

    handles.output.params = {...
    'mold', smold, ...
    'sgs', ssgs, ...
    'data', sdata ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;

% --- Executes on selection change in popupmenu_sgs.
function popupmenu_sgs_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu_sgs_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_mold.
function popupmenu_mold_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu_mold_CreateFcn(hObject, eventdata, handles)
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
%> @endcond