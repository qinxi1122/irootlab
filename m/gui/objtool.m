%>@ingroup guigroup mainguis
%>@file
%>@brief Object browser
%> @image html Screenshot-objtool.png

%> @param classname='block'
function varargout = objtool(varargin)
% Last Modified by GUIDE v2.5 22-Aug-2012 11:13:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @objtool_OpeningFcn, ...
                   'gui_OutputFcn',  @objtool_OutputFcn, ...
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
% --- Executes just before objtool is made visible.
function objtool_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to objtool (see VARARGIN)

% Choose default command line output for datatool
handles.output = hObject;

% Default parameters
if nargin < 3+1
    varargin{1} = 'block';
end;

% Initializes classes list
handles.classes = {'block', 'pre', 'fcon', 'fsel', 'clssr', 'block_cascade_base', 'sgs', 'fsg', 'peakdetector', 'irlog', 'as', 'vectorcomp', 'soitem', 'irdata'};
handles.flag_new = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0]; % Only irdata cannot be created here
for i = 1:length(handles.classes)
    o = eval([handles.classes{i} ';']);
    handles.classtitles{i} = o.classtitle;
end;
[handles.classtitles, ii] = sort(handles.classtitles);
handles.classes = handles.classes(ii);
handles.flag_new = handles.flag_new(ii);

global handles_objtool;
handles_objtool = handles;

idx = get_class_index(varargin{1}); % Calls this asap to test asap.

handles.input.rootclassname = varargin{1};
handles.input.flag_modal = 0;
% handles.input.prefix_behaviour = prefix_behaviour;

refresh_listbox_classes();
move_popup(idx);
set_class(idx);
colors_markers();
gui_set_position(hObject);
guidata(hObject, handles);
setup_load();

toggle_actions();




% --- Outputs from this function are returned to the command line.
function varargout = objtool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.input.flag_modal
    try
        uiwait(handles.figure1);
        handles = guidata(hObject);
        varargout{1} = handles.output;
        delete(gcf);
    catch
        output.flag_ok = 0;
        varargout{1} = output;
    end;
else
    % Get default command line output from handles structure
    varargout{1} = handles.output;
end;




%##########################################################################
%##########################################################################
% Auxiliary functions


%######################################
function a = get_selected_names()
global handles_objtool;
a = listbox_get_selected_names(handles_objtool.listboxObjects);


%######################################
function s = get_selected_1stname()
global handles_objtool;
s = listbox_get_selected_1stname(handles_objtool.listboxObjects);


%######################################
function load_from_workspace()
global handles_objtool;
listbox_load_from_workspace(handles_objtool.rootclassname, handles_objtool.listboxObjects);


%######################################
function refresh()
refresh_listbox_classes();
refresh_listbox_objects();


%######################################
function refresh_listbox_objects()
load_from_workspace();
objtool_show_description();


%######################################
function refresh_listbox_classes()
global handles_objtool;
a = handles_objtool.classtitles;
% Adds number of objects in workspace
oldcounts = [];
if isfield(handles_objtool, 'classcounts')
    oldcounts = handles_objtool.classcounts;
end;
aa = get_varnames2(handles_objtool.classes);
for i = 1:numel(a)
    counts(i) = numel(aa{i});
    s = iif(~isempty(oldcounts) && oldcounts(i) < counts(i), ' **', '');
    a{i} = [a{i}, ' (', s, int2str(counts(i)), s, ')'];
end;

set(handles_objtool.listbox_classes, 'String', a);
handles_objtool.classcounts = counts;
guidata(handles_objtool.figure1, handles_objtool);



%######################################
function objtool_show_description()
global handles_objtool;
show_description(handles_objtool.listboxObjects, handles_objtool.editHistory);
populate_moreactions();
populate_visualize();


%######################################
function idx = get_class_index(s)
global handles_objtool;
idx = find(strcmp(s, handles_objtool.classes));
if isempty(idx)
    irerror(sprintf('Class ''%s'' not in list!', s));
end;


%######################################
function set_class(idx)
global handles_objtool;
onoff = {'off', 'on'};
s = handles_objtool.classes{idx};
o = eval([s ';']);
set(handles_objtool.figure1, 'Color', o.color);
set(handles_objtool.pushbuttonNew, 'Enable', onoff{handles_objtool.flag_new(idx)+1});
handles_objtool.rootclassname = s;
guidata(handles_objtool.figure1, handles_objtool);
refresh_listbox_objects();

%######################################
function move_popup(idx)
global handles_objtool;
set(handles_objtool.listbox_classes, 'Value', idx);



%######################################
function populate_visualize()
global handles_objtool;
objname = get_selected_1stname();
if ~isempty(objname)
    obj= evalin('base', [objname, ';']);
    list = classmap_get_list('vis', class(obj));
    a = itemlist2cell(list);
else
    list = [];
    a = {'(none)'};
end;
handles_objtool.vislist = list;
guidata(handles_objtool.figure1, handles_objtool);
if get(handles_objtool.listbox_visualize, 'Value') > numel(a)
    set(handles_objtool.listbox_visualize, 'Value', 1);
end;
set(handles_objtool.listbox_visualize, 'String', a);



%######################################
function populate_moreactions()
global handles_objtool;
blockname = get_selected_1stname();
ma = {};
if ~isempty(blockname)
    block = evalin('base', [blockname, ';']);
    ma = unique(block.moreactions);
    la = ma;
end;
if isempty(ma)
    la = [];
    ma = {'(none)'};
end;
handles_objtool.moreactionslist = la; % Keeps list of methods for reference
guidata(handles_objtool.figure1, handles_objtool);
if get(handles_objtool.listbox_moreactions, 'Value') > numel(ma)
    set(handles_objtool.listbox_moreactions, 'Value', 1);
end;
set(handles_objtool.listbox_moreactions, 'String', ma);

%######################################
function do_moreactions()
global handles_objtool;


if ~isempty(handles_objtool.moreactionslist)
    v = get(handles_objtool.listbox_moreactions, 'Value');
    if v > 0
        s_action = handles_objtool.moreactionslist{v};
        blockname = get_selected_1stname();
        try
            og = gencode();
            og.blockname = blockname;
            og.flag_leave_block = 0;
            og = og.start();
            og = og.m_generic(s_action);
            og = og.finish();
            refresh();
        catch ME
            refresh();
            send_error(ME);
        end;
    end;
end;

%######################################
function do_visualize()
global handles_objtool;


if ~isempty(handles_objtool.vislist)
    v = get(handles_objtool.listbox_visualize, 'Value');
    if v > 0
        item = handles_objtool.vislist(v);
        if ~item.flag_final
            msgbox('Please select a deepest-level option!');
        else
            objnames = get_selected_names();
            if ~isempty(objnames)
                objs = cellfun(@(objname) (evalin('base', [objname, ';'])), objnames, 'UniformOutput', 0);

                classname = handles_objtool.vislist(v).name;
                try
                    vis = eval([classname, ';']);
                    result = vis.get_params(objs);

                    if result.flag_ok
                        og = gencode();
                        og.classname = classname;
                        og.dsnames = objnames;
                        og.params = result.params;
                        og.flag_leave_block = 0;

                        try
                            og = og.start();
                            og = og.m_create();
                            og = og.m_use();
                            og = og.finish(); %#ok<NASGU>
                            % There is no need to refresh, because we don't expect the workspace to change out of visualization 
                        catch ME
                            % refresh();
                            rethrow(ME);
                        end;
                    end;
                catch ME
                    send_error(ME);
                end;
            end;
        end;
    end;
end;



%######################################
function toggle_actions()
global handles_objtool;
set(handles_objtool.togglebutton_actions, 'Value', 1);
set(handles_objtool.togglebutton_properties, 'Value', 0);
set(handles_objtool.uipanel_actions, 'Visible', 'on');
set(handles_objtool.uipanel_properties, 'Visible', 'off');

%######################################
function toggle_properties()
global handles_objtool;
set(handles_objtool.togglebutton_actions, 'Value', 0);
set(handles_objtool.togglebutton_properties, 'Value', 1);
set(handles_objtool.uipanel_actions, 'Visible', 'off');
set(handles_objtool.uipanel_properties, 'Visible', 'on');

%##########################################################################
%##########################################################################






% --- Executes during object creation, after setting all properties.
function listboxObjects_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editHistory_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function editHistory_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in listboxObjects.
function listboxObjects_Callback(hObject, eventdata, handles)
objtool_show_description();

% --- Executes on button press in pushbuttonRefreshMS.
function pushbuttonRefreshMS_Callback(hObject, eventdata, handles)
refresh();

% --- Executes on button press in pushbuttonRename.
function pushbuttonRename_Callback(hObject, eventdata, handles)
s = get_selected_1stname();
if ~isempty(s)
    try
        rename_object(s);
        refresh_listbox_objects();
    catch ME
        refresh_listbox_objects();
        send_error(ME);
    end;

end;


% --- Executes on button press in pushbuttonClear.
function pushbuttonClear_Callback(hObject, eventdata, handles)
names = get_selected_names();
if ~isempty(names)
    try
        code = sprintf('clear %s;', sprintf('%s ', names{:}));
        ircode_eval(code, 'Clearing objects');
        refresh();
    catch ME
        refresh();
        send_error(ME);
    end;
end;    


% --- Executes on button press in pushbuttonNew.
function pushbuttonNew_Callback(hObject, eventdata, handles)
global handles_objtool;
r = do_blockmenu(handles_objtool.rootclassname, [], 1);
if r.flag_ok
    try
        og = r.og;
        og = og.start();
        og = og.m_create();
        og = og.finish();
        refresh();
    catch ME
        refresh();
        send_error(ME);
    end;
end;


% --- Executes on selection change in listbox_classes.
function listbox_classes_Callback(hObject, eventdata, handles) 
set_class(get(handles.listbox_classes, 'Value'));

% --- Executes during object creation, after setting all properties.
function listbox_classes_CreateFcn(hObject, eventdata, handles) %#ok<*INUSD,*DEFNU>
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton_actions.
function togglebutton_actions_Callback(hObject, eventdata, handles)
toggle_actions();

function togglebutton_properties_Callback(hObject, eventdata, handles)
toggle_properties();

function listbox_visualize_Callback(hObject, eventdata, handles)
if strcmp(get(handles.figure1, 'SelectionType'), 'open') % This is how you detect a double-click in MATLAB
    do_visualize();
end;
function listbox_visualize_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function listbox_moreactions_Callback(hObject, eventdata, handles)
if strcmp(get(handles.figure1, 'SelectionType'), 'open') % This is how you detect a double-click in MATLAB
    do_moreactions();
end;

function listbox_moreactions_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function pushbutton_go_visualize_Callback(hObject, eventdata, handles)
do_visualize();

function pushbutton_go_moreactions_Callback(hObject, eventdata, handles)
do_moreactions();
function pushbutton_create_defaults_Callback(hObject, eventdata, handles)
create_default_objects();
refresh();

%> @endcond
