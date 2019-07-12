function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 12-Jul-2019 16:00:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

axes(handles.output_im0);
text(0.45, 0.5, 'Im0');
set(gca, 'Color', [0.5 0.5 0.5]);
set(handles.output_im0, 'XTick', []);
set(handles.output_im0, 'YTick', []);

axes(handles.output_im1);
text(0.45, 0.5, 'Im1');
set(gca, 'Color', [0.5 0.5 0.5]);
set(handles.output_im1, 'XTick', []);
set(handles.output_im1, 'YTick', []);

axes(handles.output_d_map);
text(0.35, 0.5, 'Disparity Map');
set(gca, 'Color', [0.5 0.5 0.5]);
set(handles.output_d_map, 'XTick', []);
set(handles.output_d_map, 'YTick', []);

set(handles.output_status, 'String', 'Status', 'HorizontalAlignment', 'center');
set(handles.output_status,'BackgroundColor', [0.7 0.7 0.7]);

set(handles.current_directory, 'String', 'no directory selected', 'HorizontalAlignment', 'center');
set(handles.current_directory,'BackgroundColor', [0.7 0.7 0.7]);

%set(handles.result_R, 'String', 'R not calculated', 'HorizontalAlignment', 'center');
set(handles.result_R,'BackgroundColor', [0.7 0.7 0.7]);

%set(handles.result_T, 'String', 'T not calculated', 'HorizontalAlignment', 'center');
set(handles.result_T,'BackgroundColor', [0.7 0.7 0.7]);

%set(handles.result_p, 'String', 'p not calculated', 'HorizontalAlignment', 'center');
set(handles.result_p,'BackgroundColor', [0.7 0.7 0.7]);


% axes(handles.output_status_axes);
% text(0.15, 0.5, 'Status');
% set(gca, 'Color', [0.5 0.5 0.5]);
% set(handles.output_status_axes, 'XTick', []);
% set(handles.output_status_axes, 'YTick', []);


% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in calculate_d_map.
function calculate_d_map_Callback(hObject, eventdata, handles)
% hObject    handle to calculate_d_map (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global directoryname;
global DisMap;
%addpath(directoryname);
path_im0 = [directoryname '\im0.png'];
path_im1 = [directoryname '\im0.png'];
if exist(path_im0, 'file') && exist(path_im1, 'file')
    %rmpath(directoryname);
    
    % Funktionsaufruf Calculate Disparity-Map
    %[R, T, p, D] = f_d_map(im0, im1);
    
    [R, T, p, DisMap] = GUI_main(directoryname);
    
    %R_title = 'R';
    R_line1 = [num2str(R(1,1), '%.2e'), '           ', num2str(R(1,2), '%.2e'), '           ', num2str(R(1,3), '%.2e')];
    R_line2 = [num2str(R(2,1), '%.2e'), '           ', num2str(R(2,2), '%.2e'), '           ', num2str(R(2,3), '%.2e')];
    R_line3 = [num2str(R(3,1), '%.2e'), '           ', num2str(R(3,2), '%.2e'), '           ', num2str(R(3,3), '%.2e')];
    
    set(handles.R_line1, 'String', R_line1, 'HorizontalAlignment', 'center');
    set(handles.R_line1,'Visible','on');
    set(handles.R_line2, 'String', R_line2, 'HorizontalAlignment', 'center');
    set(handles.R_line2,'Visible','on');
    set(handles.R_line3, 'String', R_line3, 'HorizontalAlignment', 'center');
    set(handles.R_line3,'Visible','on');
    
    T_line1 = num2str(T(1), '%.2e');
    T_line2 = num2str(T(2), '%.2e');
    T_line3 = num2str(T(3), '%.2e');
    
    set(handles.T_line1, 'String', T_line1, 'HorizontalAlignment', 'center');
    set(handles.T_line1,'Visible','on');
    set(handles.T_line2, 'String', T_line2, 'HorizontalAlignment', 'center');
    set(handles.T_line2,'Visible','on');
    set(handles.T_line3, 'String', T_line3, 'HorizontalAlignment', 'center');
    set(handles.T_line3,'Visible','on');
    
    set(handles.p_line1, 'String', num2str(p, '%.2e'), 'HorizontalAlignment', 'center');
    set(handles.p_line1,'Visible','on');
    
    axes(handles.output_d_map);
    imagesc(DisMap); axis image;
    %colormap gray;
    %im1 = imread('im1.png', 'png');
    %image(im1); axis image;
    axis off;
    title('Disparity Map');
    set(handles.show_D_Map,'Visible','on');
    
    set(handles.output_status,'BackgroundColor', [0 1 0]);
    set(handles.output_status, 'String', 'succesfull');
    
else
    set(handles.output_status,'BackgroundColor', [1 0 0]);
    set(handles.output_status, 'String', 'failed');
    
    set(handles.hint_no_directory, 'String', 'No Directory selected!', 'HorizontalAlignment', 'center');
    set(handles.hint_no_directory,'ForegroundColor', [1 0 0]);
    set(handles.hint_no_directory,'Visible','on');
    
    set(handles.show_D_Map,'Visible','off');
end


% --- Executes on button press in search_dir.
function search_dir_Callback(hObject, eventdata, handles)
% hObject    handle to search_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global directoryname; 
persistent first_time;
if isempty(first_time)  
    first_time = 1;
    directoryname = 0;
else
    first_time = 0;
end 

if logical(mean(directoryname)) ~= 0 && first_time == 0
    %rmpath(directoryname);  
    directoryname = 0;
end

directoryname = uigetdir;

if(ischar(directoryname) == 1)
    set(handles.hint_no_directory,'Visible','off');
    addpath(directoryname);
    if exist('im0.png', 'file')
        axes(handles.output_im0);
        im0 = imread('im0.png', 'png');
        image(im0); axis image;
        axis off;
        title('Image 0');
        
        set(handles.show_Im0,'Visible','on');
    else
        % Ausgabe Fehlerbild
    end

    if exist('im1.png', 'file')
        axes(handles.output_im1);
        im1 = imread('im1.png', 'png');
        image(im1); axis image;
        axis off;
        title('Image 1');
        
        set(handles.show_Im1,'Visible','on');
    else
        % Ausgabe Fehlerbild
    end

    if directoryname ~= 0
       set(handles.current_directory, 'String', convertCharsToStrings(directoryname));
    else
       set(handles.current_directory, 'String', 'no directory selected');
    end

    % Reset der vorangegagenen Ergebnisse der D-Map-Berechnung
    cla (handles.output_d_map,'reset');
    axes(handles.output_d_map);
    text(0.35, 0.5, 'Disparity Map');
    set(gca, 'Color', [0.5 0.5 0.5]);
    set(handles.output_d_map, 'XTick', []);
    set(handles.output_d_map, 'YTick', []);

    set(handles.output_status, 'String', 'Status', 'HorizontalAlignment', 'center');
    set(handles.output_status,'BackgroundColor', [0.7 0.7 0.7]);

    %set(handles.result_R, 'String', 'R not calculated', 'HorizontalAlignment', 'center');
    set(handles.result_R,'BackgroundColor', [0.7 0.7 0.7]);
    set(handles.R_line1,'BackgroundColor', [0.7 0.7 0.7]);
    set(handles.R_line2,'BackgroundColor', [0.7 0.7 0.7]);
    set(handles.R_line3,'BackgroundColor', [0.7 0.7 0.7]);

    %set(handles.result_T, 'String', 'T not calculated', 'HorizontalAlignment', 'center');
    set(handles.result_T,'BackgroundColor', [0.7 0.7 0.7]);
    set(handles.T_line1,'BackgroundColor', [0.7 0.7 0.7]);
    set(handles.T_line2,'BackgroundColor', [0.7 0.7 0.7]);
    set(handles.T_line3,'BackgroundColor', [0.7 0.7 0.7]);

    %set(handles.result_p, 'String', 'p not calculated', 'HorizontalAlignment', 'center');
    set(handles.result_p,'BackgroundColor', [0.7 0.7 0.7]);
    set(handles.p_line1,'BackgroundColor', [0.7 0.7 0.7]);

    rmpath(directoryname);
    
else
    set(handles.hint_no_directory, 'String', 'No Directory selected!', 'HorizontalAlignment', 'center');
    set(handles.hint_no_directory,'ForegroundColor', [1 0 0]);
    set(handles.hint_no_directory,'Visible','on');
    
    set(handles.show_Im0,'Visible','off');
    set(handles.show_Im1,'Visible','off');
end
% FORTSCHRITTSBALKEN, GLOBALE VARIABLE?!


% --- Executes on button press in show_Im0.
function show_Im0_Callback(hObject, eventdata, handles)
% hObject    handle to show_Im0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global directoryname;
if(ischar(directoryname) == 1)
    path_im0 = [directoryname '\im0.png'];

    figure(3);
    im0 = imread(path_im0, 'png');
    image(im0); axis image;
    axis off;
    title('Image 0');
end

% --- Executes on button press in show_Im1.
function show_Im1_Callback(hObject, eventdata, handles)
% hObject    handle to show_Im1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global directoryname;
if(ischar(directoryname) == 1)
    path_im1 = [directoryname '\im1.png'];

    figure(4);
    im1 = imread(path_im1, 'png');
    image(im1); axis image;
    axis off;
    title('Image 1');
end


% --- Executes on button press in show_D_Map.
function show_D_Map_Callback(hObject, eventdata, handles)
% hObject    handle to show_D_Map (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global DisMap;
if length(DisMap) > 1
    figure(5);
    imagesc(DisMap); axis image;
    axis off;
    title('Disparity Map');
end
