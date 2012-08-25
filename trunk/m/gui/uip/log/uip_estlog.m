%> @ingroup guigroup
%> @file
%> @brief Properties Window for @ref estlog
%> @image html Screenshot-uip_estlog.png
%>
%> <b>Record supports</b> - Whether or not to record the "supports" (confidence levels issued by classifiers). See estlog::flag_support
%>
%> @sa estlog

%>@cond
function varargout = uip_estlog(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_estlog_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_estlog_OutputFcn, ...
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


% --- Executes just before uip_estlog is made visible.
function uip_estlog_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);


% --- Outputs from this function are returned to the command clae.
function varargout = uip_estlog_OutputFcn(hObject, eventdata, handles) 
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

% --- Executes on button press in pushbuttonOK.
function pushbuttonOK_Callback(hObject, eventdata, handles)
try
    handles.output.params = {...
    'flag_support', int2str(get(handles.checkbox_flag_support, 'Value')) ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;

% --- Executes on button press in checkbox_flag_support.
function checkbox_flag_support_Callback(hObject, eventdata, handles)
%> @endcond
