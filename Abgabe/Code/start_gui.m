function varargout = start_gui(varargin)
% start_gui MATLAB code for start_gui.fig
%      start_gui, by itself, creates a new start_gui or raises the existing
%      singleton*.
%
%      H = start_gui returns the handle to a new start_gui or the handle to
%      the existing singleton*.
%
%      start_gui('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in start_gui.M with the given input arguments.
%
%      start_gui('Property','Value',...) creates a new start_gui or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the start_gui before start_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to start_gui_OpeningFcn via varargin.
%
%      *See start_gui Options on GUIDE's Tools menu.  Choose "start_gui allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help start_gui

% Last Modified by GUIDE v2.5 16-Jul-2019 18:22:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @start_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @start_gui_OutputFcn, ...
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


% --- Executes just before start_gui is made visible.
function start_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to start_gui (see VARARGIN)

% Choose default command line output for start_gui
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


% UIWAIT makes start_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = start_gui_OutputFcn(hObject, eventdata, handles) 
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


path_im0 = [directoryname '\im0.png'];
path_im1 = [directoryname '\im1.png'];
if exist(path_im0, 'file') && exist(path_im1, 'file')
    %[R, T, p, DisMap] = challenge('directoryname', directoryname);
    challenge;
    
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
    
    set(handles.hint_no_directory, 'String', 'No Directory selected, or Image Im0 or Im1 not found!', 'HorizontalAlignment', 'center');
    set(handles.hint_no_directory,'ForegroundColor', [1 0 0]);
    set(handles.hint_no_directory,'Visible','on');
    
    set(handles.show_D_Map,'Visible','off');
end


% --- Executes on button press in search_dir.
function search_dir_Callback(hObject, eventdata, handles)
% hObject    handle to search_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Globale Variable directoryname, in der das directory gespeichert wird
global directoryname; 

% beständige Variable first_time, ob das erste mal auf den Button gedrückt
% wird
persistent first_time;
if isempty(first_time)  
    first_time = 1;
    directoryname = 0;
else
    first_time = 0;
end 

% wenn vom vorherigen start_gui-Durchlauf ein directory gespeichert ist,
% lösche es
if logical(mean(directoryname)) ~= 0 && first_time == 0
    %rmpath(directoryname);  
    directoryname = 0;
end

% öffnet Benutzeroberfläche zur Pfadauswahl und gibt Pfad als Char zurück
directoryname = uigetdir;

% Prüft, ob der Rückgabewert wie erwartet ein char ist und öffnet die
% vorhandenen Bilder, deaktiviert Hinweise, dass kein Pfad ausgewählt ist
% und löscht die Ergebnisse aus der vorherigen Disparity-Map-Berechnung
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
        Im0_existing = 1;
    else
        Im0_existing = 0;
        % reset des Im0-Axes
        cla (handles.output_im0,'reset');
        axes(handles.output_im0);
        text(0.45, 0.5, 'Im0');
        set(gca, 'Color', [0.5 0.5 0.5]);
        set(handles.output_im0, 'XTick', []);
        set(handles.output_im0, 'YTick', []);
        % Ausblenden des Push-Buttons zum Öffnen der Bilder in Figure
        set(handles.show_Im0,'Visible','off');
    end

    if exist('im1.png', 'file')
        axes(handles.output_im1);
        im1 = imread('im1.png', 'png');
        image(im1); axis image;
        axis off;
        title('Image 1');
        
        set(handles.show_Im1,'Visible','on');
        Im1_existing = 1;
    else
        Im1_existing = 0;
        % reset des Im1-Axes
        cla (handles.output_im1,'reset');
        axes(handles.output_im1);
        text(0.45, 0.5, 'Im1');
        set(gca, 'Color', [0.5 0.5 0.5]);
        set(handles.output_im1, 'XTick', []);
        set(handles.output_im1, 'YTick', []);
        % Ausblenden des Push-Buttons zum Öffnen der Bilder in Figure
        set(handles.show_Im1,'Visible','off');
    end
    
    % Ausgabe des Hinweises, dass eines oder mehrere Bilder nicht gefunden
    % wurden
    if exist('im1.png', 'file') == 0 || exist('im0.png', 'file') == 0
        
        if Im0_existing == 0
            Hinweis_Bilder_nicht_vorhanden = 'Im0';
            if Im1_existing == 0
                Hinweis_Bilder_nicht_vorhanden = [Hinweis_Bilder_nicht_vorhanden ' and Im1 not found!'];
            else
                Hinweis_Bilder_nicht_vorhanden = [Hinweis_Bilder_nicht_vorhanden ' not found!'];
            end
        else
            Hinweis_Bilder_nicht_vorhanden = 'Im1 not found!';
        end
 
        set(handles.hint_no_directory, 'String', Hinweis_Bilder_nicht_vorhanden, 'HorizontalAlignment', 'center');
        set(handles.hint_no_directory,'ForegroundColor', [1 0 0]);
        set(handles.hint_no_directory,'Visible','on');
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
    % wird ausgeführt, wenn die Pfadauswahl vorzeitig abgebrochen wird
    
    % 1. zurücksetzen der Bildvorschauen Im0 und Im1 auf Grau
    cla (handles.output_im0,'reset');
    axes(handles.output_im0);
    text(0.45, 0.5, 'Im0');
    set(gca, 'Color', [0.5 0.5 0.5]);
    set(handles.output_im0, 'XTick', []);
    set(handles.output_im0, 'YTick', []);

    cla (handles.output_im1,'reset');
    axes(handles.output_im1);
    text(0.45, 0.5, 'Im1');
    set(gca, 'Color', [0.5 0.5 0.5]);
    set(handles.output_im1, 'XTick', []);
    set(handles.output_im1, 'YTick', []);
    
    % Anzeige current_directory = '---'
    set(handles.current_directory, 'String', '---', 'HorizontalAlignment', 'center');
    
    % Einblenden des Hinweises, dass kein Directory ausgewählt wurde
    set(handles.hint_no_directory, 'String', 'No Directory selected!', 'HorizontalAlignment', 'center');
    set(handles.hint_no_directory,'ForegroundColor', [1 0 0]);
    set(handles.hint_no_directory,'Visible','on');
    
    % Ausblenden der beiden Push-Buttons zum Öffnen der Bilder in Figure
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
