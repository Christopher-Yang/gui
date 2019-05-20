function varargout = phasor_gui(varargin)
% PHASOR_GUI MATLAB code for phasor_gui.fig
%      PHASOR_GUI, by itself, creates a new PHASOR_GUI or raises the existing
%      singleton*.
%
%      H = PHASOR_GUI returns the handle to a new PHASOR_GUI or the handle to
%      the existing singleton*.
%
%      PHASOR_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PHASOR_GUI.M with the given input arguments.
%
%      PHASOR_GUI('Property','Value',...) creates a new PHASOR_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before phasor_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to phasor_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help phasor_gui

% Last Modified by GUIDE v2.5 20-May-2019 14:01:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @phasor_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @phasor_gui_OutputFcn, ...
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


% --- Executes just before phasor_gui is made visible.
function phasor_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to phasor_gui (see VARARGIN)

% Choose default command line output for phasor_gui
handles.output = hObject;
sigma = str2double(get(handles.noise,'String'));
handles.ratio = make_phasor(handles.uitable1.Data,sigma);
plot_ratio(handles)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes phasor_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = phasor_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in replot.
function replot_Callback(hObject, eventdata, handles)
% hObject    handle to replot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

L = get(handles.uitable1,'Data');
sigma = str2double(get(handles.noise,'String'));
handles.ratio = make_phasor(handles.uitable1.Data, sigma);
plot_ratio(handles)

function plot_ratio(handles)

col1 = [1 0.83 0.33];
col2 = [1 0 0];
colors = [linspace(col1(1),col2(1),7)', linspace(col1(2),col2(2),7)', linspace(col1(3),col2(3),7)'];

axes(handles.XX_plot)
cla
plot([-1.5 1.5],[0 0],'k')
hold on
plot([0 0],[-1.5 1.5],'k')
axis([-1.5 1.5 -1.5 1.5])
for i = 1:7
    plot(handles.ratio.x(:,i),'.','Color',colors(i,:))
end

axes(handles.YY_plot)
cla
plot([-1.5 1.5],[0 0],'k')
hold on
plot([0 0],[-1.5 1.5],'k')
axis([-1.5 1.5 -1.5 1.5])
for i = 1:7
    plot(handles.ratio.y(:,i),'.','Color',colors(i,:))
end

axes(handles.XY_plot)
cla
plot([-1.5 1.5],[0 0],'k')
hold on
plot([0 0],[-1.5 1.5],'k')
axis([-1.5 1.5 -1.5 1.5])
for i = 1:7
    plot(handles.ratio.xy(:,i),'.','Color',colors(i,:))
end

axes(handles.YX_plot)
cla
plot([-1.5 1.5],[0 0],'k')
hold on
plot([0 0],[-1.5 1.5],'k')
axis([-1.5 1.5 -1.5 1.5])
for i = 1:7
    plot(handles.ratio.yx(:,i),'.','Color',colors(i,:))
end



function noise_Callback(hObject, eventdata, handles)
% hObject    handle to noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noise as text
%        str2double(get(hObject,'String')) returns contents of noise as a double


% --- Executes during object creation, after setting all properties.
function noise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in optimal_L.
function optimal_L_Callback(hObject, eventdata, handles)
% hObject    handle to optimal_L (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load L
set(handles.uitable1,'Data',L)
