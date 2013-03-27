function varargout = smfishgui_viewer1(varargin)
% SMFISHGUI_VIEWER1 MATLAB code for smfishgui_viewer1.fig
%      SMFISHGUI_VIEWER1, by itself, creates a new SMFISHGUI_VIEWER1 or raises the existing
%      singleton*.
%
%      H = SMFISHGUI_VIEWER1 returns the handle to a new SMFISHGUI_VIEWER1 or the handle to
%      the existing singleton*.
%
%      SMFISHGUI_VIEWER1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SMFISHGUI_VIEWER1.M with the given input arguments.
%
%      SMFISHGUI_VIEWER1('Property','Value',...) creates a new SMFISHGUI_VIEWER1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before smfishgui_viewer1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to smfishgui_viewer1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help smfishgui_viewer1

% Last Modified by GUIDE v2.5 27-Mar-2013 16:35:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @smfishgui_viewer1_OpeningFcn, ...
                   'gui_OutputFcn',  @smfishgui_viewer1_OutputFcn, ...
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


% --- Executes just before smfishgui_viewer1 is made visible.
function smfishgui_viewer1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to smfishgui_viewer1 (see VARARGIN)

% Choose default command line output for smfishgui_viewer1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes smfishgui_viewer1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
handles.impath = 'C:\Users\kk128\Documents\MATLAB\fish\20120712_p21_66hr_12_w2Cy5_s1_t1_ff.TIF';
IM = importZstackFromTIFF(handles.impath);
imshow(IM(:,:,34),'Parent',handles.axes1,'DisplayRange',[]);
disp('hi')

% --- Outputs from this function are returned to the command line.
function varargout = smfishgui_viewer1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on slider movement.
function sliderZ_Callback(hObject, eventdata, handles)
% hObject    handle to sliderZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function sliderZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
