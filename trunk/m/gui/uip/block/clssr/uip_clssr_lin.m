%> @ingroup guigroup
%> @file
%> @brief Properties Window for Least-Squares Classifier
%>
%> Currently there is no Least-Squares Classifier implemented.
%>
%> @image html Screenshot-uip_clssr_lin.png
%>
%> @sa

%> @cond
function varargout = uip_clssr_lin(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_clssr_lin_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_clssr_lin_OutputFcn, ...
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


% --- Executes just before uip_clssr_lin is made visible.
function uip_clssr_lin_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);


% --- Outputs from this function are returned to the command line.
function varargout = uip_clssr_lin_OutputFcn(hObject, eventdata, handles) 
try
    uiwait(handles.figure1);
    handles = guidata(hObject);
    varargout{1} = handles.output;
    delete(gcf);
catch
    output.flag_ok = 0;
    varargout{1} = output;
end;




function editPenalty_Callback(hObject, eventdata, handles)
% hObject    handle to editPenalty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editPenalty as text
%        str2double(get(hObject,'String')) returns contents of editPenalty as a double


% --- Executes during object creation, after setting all properties.
function editPenalty_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editPenalty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pushbuttonCreate.
function pushbuttonCreate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonCreate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    params = {...
        'reg', get(handles.editPenalty, 'String'), ...
        'flag_class2mo', sprintf('%d', get(handles.checkboxFlagClass2MO, 'Value') ~= 0) ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;

% --- Executes on button press in checkboxFlagClass2MO.
function checkboxFlagClass2MO_Callback(hObject, eventdata, handles)
%>@endcond
