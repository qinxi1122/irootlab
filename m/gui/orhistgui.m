%> @ingroup guigroup
%> @file
%> @brief GUI to preview the action outlier removal.
%> @image html Screenshot-orhistgui.png
%
%> @param block A @c blmisc_rowsout_uni block.
%> @param flag_modal=0 Whether to make the window modal or not.
function varargout = orhistgui(varargin)
% Last Modified by GUIDE v2.5 11-Feb-2011 15:10:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @orhistgui_OpeningFcn, ...
                   'gui_OutputFcn',  @orhistgui_OutputFcn, ...
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

%> @cond
% --- Executes just before orhistgui is made visible.
function orhistgui_OpeningFcn(hObject, eventdata, handles, varargin)
try
    if nargin < 4
        irerror('Block not passed! Please pass as parameter a block of class blmisc_rowsout_uni!');
    end;
    if ~isa(varargin{1}, 'blmisc_rowsout_uni')
        irerror('Block is not a blmisc_rowsout_uni!');
    end;
    if ~varargin{1}.flag_trained
        irerror('Block is not trained, needs to be trained!');
    end;
    if nargin < 5
        handles.flag_modal = 0;
    else
        handles.flag_modal = varargin{2};
    end;

    handles.output = hObject;
    handles.remover = varargin{1};
    guidata(hObject, handles);
    gui_set_position(hObject);
    cla(handles.axes1, 'reset');
    view1(handles);
    cla(handles.axes2, 'reset');
    refresh(handles);
catch ME
    send_error(ME);
end;

% --- Outputs from this function are returned to the command clae.
function orhistgui_OutputFcn(hObject, eventdata, handles) 
if handles.flag_modal
    uiwait(handles.figure1);
end;

%############################################

%#########
function view1(handles)
cla(handles.axes1, 'reset');
axes(handles.axes1);
o = handles.remover;
hold off;
o.draw_histogram();
set(handles.text_howmany, 'String', sprintf('%d of %d to be removed', o.no-length(o.map), o.no));

%#########
function view2(handles)
try
    sdata = listbox_get_selected_1stname(handles.popupmenu_data);
    if isempty(sdata)
        irerror('Dataset not specified!');
    end;
    data = evalin('base', [sdata, ';']);
    
    % Makes a dataset with the removed rows
    o = handles.remover;
    
    if data.no ~= o.no
        irerror(sprintf('Selected dataset has an incompatible number of rows: actual: %d; expected: %d', data.no, o.no));
    end;
    
    map_out = 1:data.no;
    map_out(o.map) = [];
    dsout = data.map_rows(map_out);
    
    ov = vis_alldata();
    axes(handles.axes2);
    hold off;
    global FONTSIZE;
    temp = FONTSIZE;
    FONTSIZE = 15;
    ov.use(dsout);
    title('');
    FONTSIZE = temp;
catch ME
    send_error(ME);
end;

%#########
function refresh(handles)
listbox_load_from_workspace('irdata', handles.popupmenu_data, 1);

%############################################
%############################################

% --- Executes on button press in pushbuttonView.
function pushbuttonView_Callback(hObject, eventdata, handles)
view2(handles);

function edit_idx_fea_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_idx_fea_CreateFcn(hObject, eventdata, handles)
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

% --- Executes on button press in pushbutton_refresh.
function pushbutton_refresh_Callback(hObject, eventdata, handles)
refresh(handles);

% --- Executes on button press in pushbutton_redraw.
function pushbutton_redraw_Callback(hObject, eventdata, handles)
view1(handles);
%> @endcond
