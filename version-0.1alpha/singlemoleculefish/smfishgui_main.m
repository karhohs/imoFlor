function varargout = smfishgui_main(varargin)
% SMFISHGUI_MAIN MATLAB code for smfishgui_main.fig
%      SMFISHGUI_MAIN, by itself, creates a new SMFISHGUI_MAIN or raises the existing
%      singleton*.
%
%      H = SMFISHGUI_MAIN returns the handle to a new SMFISHGUI_MAIN or the handle to
%      the existing singleton*.
%
%      SMFISHGUI_MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SMFISHGUI_MAIN.M with the given input arguments.
%
%      SMFISHGUI_MAIN('Property','Value',...) creates a new SMFISHGUI_MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before smfishgui_main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to smfishgui_main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help smfishgui_main

% Last Modified by GUIDE v2.5 27-Mar-2013 20:20:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @smfishgui_main_OpeningFcn, ...
                   'gui_OutputFcn',  @smfishgui_main_OutputFcn, ...
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


% --- Executes just before smfishgui_main is made visible.
function smfishgui_main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to smfishgui_main (see VARARGIN)

% Choose default command line output for smfishgui_main
handles.output = hObject;

% UIWAIT makes smfishgui_main wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% This gui set requires relative indexing into folders with the source
% images. _mfilepath_ is the variable that will contain the root directory
% for the relative indexing.
[handles.mfilepath,~,~] = fileparts(mfilename('fullpath')); %finds the path to this script

% |smfishgui_main| is designed to be the parent gui. Communication between
% the parent gui and the children gui happens below.
handles.viewer1 = smfishgui_viewer1('main',hObject);

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = smfishgui_main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_path2FluorescenceImages.
function pushbutton_path2FluorescenceImages_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_path2FluorescenceImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Choose the path to the directory that contains the smFISH fluorescent
% images
handles.path2FluorescenceImages = uigetdir(handles.mfilepath,'Choose the directory that contains your fluorescence images.');
set(handles.text_path2FluorescenceImages,'String',handles.path2FluorescenceImages);

% Identify fluorescent images and show these as options in a drop down
% menu.

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton_path2BrightfieldImages.
function pushbutton_path2BrightfieldImages_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_path2BrightfieldImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.path2BrightfieldImages = uigetdir(handles.mfilepath,'Choose the directory that contains your Phase/DIC/Brightfield images.');
set(handles.text_path2BrightfieldImages,'String',handles.path2BrightfieldImages);
% Update handles structure
guidata(hObject, handles);
