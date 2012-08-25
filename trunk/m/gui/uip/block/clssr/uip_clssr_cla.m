%> @ingroup guigroup
%> @file
%> @brief Properties Window for @ref clssr_cla
%> @image html Screenshot-uip_clssr_cla.png
%>
%> <b>Classifier type</b> - see clssr_cla::type
%>
%> @sa @ref clssr_cla

%> @cond
function varargout = uip_clssr_cla(varargin)
% Last Modified by GUIDE v2.5 04-Feb-2011 14:41:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_clssr_cla_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_clssr_cla_OutputFcn, ...
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


% --- Executes just before uip_clssr_cla is made visible.
function uip_clssr_cla_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);



% --- Outputs from this function are returned to the command clae.
function varargout = uip_clssr_cla_OutputFcn(hObject, eventdata, handles) 
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



function editReg_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function editReg_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pushbuttonCreate.
function pushbuttonCreate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonCreate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    handles.output.params = {...
    'type', sprintf('''%s''', fel(get(handles.popupmenuType, 'String'), get(handles.popupmenuType, 'Value'))), ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;


% --- Executes on selection change in popupmenuType.
function popupmenuType_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenuType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuType


% --- Executes during object creation, after setting all properties.
function popupmenuType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%>@endcond
