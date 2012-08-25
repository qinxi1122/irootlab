%> @ingroup guigroup
%> @file
%> @brief Asks user whether to use x-axis range from file or a custom one.
%> @image html Screenshot-datatool_fearange.png
%
%> @cond
function varargout = datatool_fearange(varargin)
% Last Modified by GUIDE v2.5 26-Aug-2011 20:24:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @datatool_fearange_OpeningFcn, ...
                   'gui_OutputFcn',  @datatool_fearange_OutputFcn, ...
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


% --- Executes just before datatool_fearange is made visible.
function datatool_fearange_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to datatool_fearange (see VARARGIN)

% Choose default command line output for datatool_fearange
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global ATRTOOL_LOAD_OK ATRTOOL_LOAD_RANGE;
ATRTOOL_LOAD_OK = 0;
ATRTOOL_LOAD_RANGE = [];

% UIWAIT makes datatool_fearange wait for user response (see UIRESUME)
uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = datatool_fearange_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

% This was giving an error because I delete the figure when the user clicks on "Load file!"
% varargout{1} = handles.output;




% --- Executes on button press in pushbuttonOk.
function pushbuttonOk_Callback(hObject, eventdata, handles)
   
global ATRTOOL_LOAD_OK ATRTOOL_LOAD_RANGE;
ATRTOOL_LOAD_OK = 1;
ATRTOOL_LOAD_RANGE = [eval(get(handles.editFrom, 'String')), eval(get(handles.editTo, 'String'))];
    
delete(gcf);



function editTo_Callback(hObject, eventdata, handles)
% hObject    handle to editTo1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTo1 as text
%        str2double(get(hObject,'String')) returns contents of editTo1 as a double


% --- Executes during object creation, after setting all properties.
function editFrom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTo1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editFrom_Callback(hObject, eventdata, handles)
% hObject    handle to editTo1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTo1 as text
%        str2double(get(hObject,'String')) returns contents of editTo1 as a double


% --- Executes during object creation, after setting all properties.
function editTo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTo1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%>@endcond
