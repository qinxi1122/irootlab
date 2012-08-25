%>@file
%>@ingroup guigroup
%>@brief Properties Window for @ref blmisc_split_classes
%>
%>@image html Screenshot-uip_blmisc_split_classes.png
%>
%> <b>...</b>...
%> @sa blmisc_split_classes

%>@cond
function varargout = uip_blmisc_split_classes(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_blmisc_split_classes_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_blmisc_split_classes_OutputFcn, ...
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


% --- Executes just before uip_blmisc_split_classes is made visible.
function uip_blmisc_split_classes_OpeningFcn(hObject, eventdata, handles, varargin)
if nargin > 4
    % Dataset is expected as parameter
    ds = varargin{2};
    set(handles.text_caption, 'String', [get(handles.text_caption, 'String'), sprintf(' (number of levels in dataset: %d)', ds.get_no_levels)]);
end;
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);


% --- Outputs from this function are returned to the command clae.
function varargout = uip_blmisc_split_classes_OutputFcn(hObject, eventdata, handles) 
try
    uiwait(handles.figure1);
    handles = guidata(hObject);
    varargout{1} = handles.output;
    delete(gcf);
catch
    output.flag_ok = 0;
    varargout{1} = output;
end;



function editReg_Callback(hObject, eventdata, handles)
% hObject    handle to editReg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editReg as text
%        str2double(get(hObject,'String')) returns contents of editReg as a double


% --- Executes during object creation, after setting all properties.
function editReg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editReg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pushbuttonOk.
function pushbuttonOk_Callback(hObject, eventdata, handles)


try
    idxs = eval(get(handles.edit_hierarchy, 'String'));

    if ~isnumeric(idxs)
        irerror('Please type in a numerical vector!');
    end;

    
%     if ~handles.input.flag_all && isempty(idxs)
%         irerrordlg('Empty vector not allowed!', 'Invalid input');
%         flag_error = 1;
%     end;

    % Does not check if levels are valid, maybe that's too much, let error occur

    handles.output.params = {...
    'hierarchy', mat2str(idxs) ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');   
end;


function edit_hierarchy_Callback(hObject, eventdata, handles)

function edit_hierarchy_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%>@endcond
