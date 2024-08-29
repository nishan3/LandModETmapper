function varargout = LandMODETMapper(varargin)
% LANDMODETMAPPER MATLAB code for LandMODETMapper.fig
%      LANDMODETMAPPER, by itself, creates a new LANDMODETMAPPER or raises the existing
%      singleton*.
%
%      H = LANDMODETMAPPER returns the handle to a new LANDMODETMAPPER or the handle to
%      the existing singleton*.
%
%      LANDMODETMAPPER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LANDMODETMAPPER.M with the given input arguments.
%
%      LANDMODETMAPPER('Property','Value',...) creates a new LANDMODETMAPPER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LandMODETMapper_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LandMODETMapper_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LandMODETMapper

% Last Modified by GUIDE v2.5 01-Feb-2019 17:15:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LandMODETMapper_OpeningFcn, ...
                   'gui_OutputFcn',  @LandMODETMapper_OutputFcn, ...
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


% --- Executes just before LandMODETMapper is made visible.
function LandMODETMapper_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LandMODETMapper (see VARARGIN)

% Choose default command line output for LandMODETMapper
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
mainPath = pwd;
inputPath = fullfile(mainPath,'Inputs');
outPath = fullfile(mainPath,'Outputs','Landsat');
if ~exist(outPath)
    mkdir(fullfile(mainPath,'Outputs','Landsat'))
end
cd(mainPath);
set(handles.edit_outputpath,'String',outPath)

%defaultfile=fullfile(pwd,'Inputs','lst_l5_2011277.tif');
set(handles.popupmenu_satallite_type,'Value',1)
set(handles.edit_yeardoy,'String',num2str(2006215))
set(handles.edit_landsattype,'String', num2str(5))
set(handles.edit_b,'String', num2str(90-61.66628785))
set(handles.edit_imghr,'String', num2str(10))
set(handles.edit_imgmm,'String', num2str(55))

yeardoy=str2num(get(handles.edit_yeardoy,'string'));
defaultfile=fullfile(inputPath,'RS',strcat('lst_',int2str(yeardoy),'_Landsat.tif'));
set(handles.edit_lst,'String',defaultfile)
defaultfile=fullfile(inputPath,'RS',strcat('albedo_', int2str(yeardoy),'_Landsat.tif'));
set(handles.edit_albedo,'String',defaultfile)
defaultfile=fullfile(inputPath,'RS',strcat('emiss_', int2str(yeardoy),'_Landsat.tif'));
set(handles.edit_emiss,'String',defaultfile)
defaultfile=fullfile(inputPath,'RS',strcat('ndvi_', int2str(yeardoy),'_Landsat.tif'));
set(handles.edit_ndvi,'String',defaultfile)

defaultfile=fullfile(inputPath,'Derived',strcat('z0m_', int2str(yeardoy),'_Landsat.tif'));
set(handles.edit_z0m,'String',defaultfile)
defaultfile=fullfile(inputPath,'Derived',strcat('Igood_', int2str(yeardoy),'_Landsat.tif'));
set(handles.edit_Igood,'String',defaultfile)
defaultfile=fullfile(inputPath,'Derived',strcat('Iwater_', int2str(yeardoy),'_Landsat.tif'));
set(handles.edit_Iwater,'String',defaultfile)
defaultfile=fullfile(mainPath,'Agbinary_landsat.tif');
set(handles.edit_Ag_filter,'String',defaultfile)

defaultfile=fullfile(inputPath,'Weather',strcat('rhinst_awdn_', int2str(yeardoy),'_Landsat.tif'));
set(handles.edit_rh_inst,'String',defaultfile)
defaultfile=fullfile(inputPath,'Weather',strcat('TinstK_awdn_', int2str(yeardoy),'_Landsat.tif'));
set(handles.edit_TinstK,'String',defaultfile)
defaultfile=fullfile(inputPath,'Weather',strcat('uinst_awdn_', int2str(yeardoy),'_Landsat.tif'));
set(handles.edit_u_inst,'String',defaultfile)
defaultfile=fullfile(inputPath,'Weather',strcat('solarinst_awdn_', int2str(yeardoy),'_Landsat.tif'));
set(handles.edit_solar_i,'String',defaultfile)
defaultfile=fullfile(inputPath,'Weather',strcat('Tmaxd_awdn_', int2str(yeardoy),'_Landsat.tif'));
set(handles.edit_TmaxdailyK,'String',defaultfile)
defaultfile=fullfile(inputPath,'Weather',strcat('Tmeand_awdn_', int2str(yeardoy),'_Landsat.tif'));
set(handles.edit_TmeandailyK,'String',defaultfile)
defaultfile=fullfile(inputPath,'Weather',strcat('Tmind_awdn_', int2str(yeardoy),'_Landsat.tif'));
set(handles.edit_TmindailyK,'String',defaultfile)
defaultfile=fullfile(inputPath,'Weather',strcat('s24d_awdn_', int2str(yeardoy),'_Landsat.tif'));
set(handles.edit_solar24,'String',defaultfile)
defaultfile=fullfile(inputPath,'Weather',strcat('rhd_awdn_', int2str(yeardoy),'_Landsat.tif'));
set(handles.edit_rh_daily,'String',defaultfile)
defaultfile=fullfile(inputPath,'Weather',strcat('ud_awdn_', int2str(yeardoy),'_Landsat.tif'));
set(handles.edit_u_daily,'String',defaultfile)

set(handles.popupmenu_computeK,'Value',2)
set(handles.edit_p_year,'String','Null')
set(handles.edit_et0_year,'String','Null')
set(handles.edit_soil,'String','Null')

yeardoy_str = num2str(yeardoy);
year = str2num(yeardoy_str(1:4));
defaultfile=fullfile(inputPath,'Weather',strcat('Pstacked_',int2str(year),'.tif'));
%set(handles.edit_p_year,'String',defaultfile)

fullname_et0_year=fullfile(inputPath,'Weather',strcat('ETostacked_',int2str(year),'.tif'));
%set(handles.edit_et0_year,'String',fullname_et0_year)
fullname_soil=fullfile(mainPath,'soil_ras_landsat.tif');
%set(handles.edit_soil,'String',fullname_soil)
set(handles.edit_kr,'String','0')
set(handles.edit_kr_max,'String','0.15')
set(handles.edit_z_st_veg,'String','0.15')
set(handles.edit_zref,'String','2')
set(handles.edit_t_interval,'String','1')
set(handles.edit_lapse,'String','0.0065')
set(handles.edit_zb,'String','200')

set(handles.edit_dem,'String',fullfile(mainPath,'dem_landsat.tif'))

load defaults_hotcold_param_landsat;

set(handles.edit_ff_open,'String',num2str(ff_open))
set(handles.edit_lstlowerlimit,'String',num2str(lstlowerlimit))
set(handles.edit_lststep,'String',num2str(lststep))
set(handles.edit_lstupperlimit,'String',num2str(lstupperlimit))
set(handles.edit_lstwindow,'String',num2str(lstwindow))
set(handles.edit_ndvilowerlimit,'String',num2str(ndvilowerlimit))
set(handles.edit_ndvistep,'String',num2str(ndvistep))
set(handles.edit_ndviupperlimit,'String',num2str(ndviupperlimit))
set(handles.edit_ndviwindow,'String',num2str(ndviwindow))
set(handles.edit_pixellimit_bins,'String',num2str(pixellimit_bins))
set(handles.edit_pixellimit_counts,'String',num2str(pixellimit_counts))
set(handles.edit_Kadj,'String',num2str(1.05))
set(handles.edit_k,'String',num2str(0.41))
set(handles.checkbox_saveGeoTIFFS,'value',1);
set(handles.checkbox_saveMATS,'value',1);
set(handles.checkbox_saveRn_MATS,'value',1);
set(handles.checkbox_saveG_MATS,'value',1);
set(handles.checkbox_saveRn_GeoTIFFS,'value',1);
set(handles.checkbox_saveG_GeoTIFFS,'value',1);
set(handles.checkbox_makeFig_LE,'value',0);
set(handles.checkbox_makeFig_DailyETs,'value',0);
set(handles.checkbox_runMETRIC,'value',1);
set(handles.checkbox_runSEBAL,'value',1);

% --- Outputs from this function are returned to the command line.
function varargout = LandMODETMapper_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function edit_yeardoy_Callback(hObject, eventdata, handles)
% hObject    handle to edit_yeardoy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_yeardoy as text
%        str2double(get(hObject,'String')) returns contents of edit_yeardoy as a double


% --- Executes during object creation, after setting all properties.
function edit_yeardoy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_yeardoy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_landsattype_Callback(hObject, eventdata, handles)
% hObject    handle to edit_landsattype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_landsattype as text
%        str2double(get(hObject,'String')) returns contents of edit_landsattype as a double


% --- Executes during object creation, after setting all properties.
function edit_landsattype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_landsattype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_b_Callback(hObject, eventdata, handles)
% hObject    handle to edit_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_b as text
%        str2double(get(hObject,'String')) returns contents of edit_b as a double


% --- Executes during object creation, after setting all properties.
function edit_b_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_imghr_Callback(hObject, eventdata, handles)
% hObject    handle to edit_imghr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_imghr as text
%        str2double(get(hObject,'String')) returns contents of edit_imghr as a double


% --- Executes during object creation, after setting all properties.
function edit_imghr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_imghr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_imgmm_Callback(hObject, eventdata, handles)
% hObject    handle to edit_imgmm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_imgmm as text
%        str2double(get(hObject,'String')) returns contents of edit_imgmm as a double


% --- Executes during object creation, after setting all properties.
function edit_imgmm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_imgmm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_lst_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lst as text
%        str2double(get(hObject,'String')) returns contents of edit_lst as a double


% --- Executes during object creation, after setting all properties.
function edit_lst_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_albedo_Callback(hObject, eventdata, handles)
% hObject    handle to edit_albedo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_albedo as text
%        str2double(get(hObject,'String')) returns contents of edit_albedo as a double


% --- Executes during object creation, after setting all properties.
function edit_albedo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_albedo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ndvi_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ndvi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ndvi as text
%        str2double(get(hObject,'String')) returns contents of edit_ndvi as a double


% --- Executes during object creation, after setting all properties.
function edit_ndvi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ndvi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_emiss_Callback(hObject, eventdata, handles)
% hObject    handle to edit_emiss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_emiss as text
%        str2double(get(hObject,'String')) returns contents of edit_emiss as a double


% --- Executes during object creation, after setting all properties.
function edit_emiss_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_emiss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_z0m_Callback(hObject, eventdata, handles)
% hObject    handle to edit_z0m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_z0m as text
%        str2double(get(hObject,'String')) returns contents of edit_z0m as a double


% --- Executes during object creation, after setting all properties.
function edit_z0m_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_z0m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Igood_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Igood (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Igood as text
%        str2double(get(hObject,'String')) returns contents of edit_Igood as a double


% --- Executes during object creation, after setting all properties.
function edit_Igood_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Igood (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Iwater_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Iwater (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Iwater as text
%        str2double(get(hObject,'String')) returns contents of edit_Iwater as a double


% --- Executes during object creation, after setting all properties.
function edit_Iwater_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Iwater (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Ag_filter_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Ag_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Ag_filter as text
%        str2double(get(hObject,'String')) returns contents of edit_Ag_filter as a double


% --- Executes during object creation, after setting all properties.
function edit_Ag_filter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Ag_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_rh_inst_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rh_inst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rh_inst as text
%        str2double(get(hObject,'String')) returns contents of edit_rh_inst as a double


% --- Executes during object creation, after setting all properties.
function edit_rh_inst_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rh_inst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_TinstK_Callback(hObject, eventdata, handles)
% hObject    handle to edit_TinstK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_TinstK as text
%        str2double(get(hObject,'String')) returns contents of edit_TinstK as a double


% --- Executes during object creation, after setting all properties.
function edit_TinstK_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_TinstK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_u_inst_Callback(hObject, eventdata, handles)
% hObject    handle to edit_u_inst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_u_inst as text
%        str2double(get(hObject,'String')) returns contents of edit_u_inst as a double


% --- Executes during object creation, after setting all properties.
function edit_u_inst_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_u_inst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_solar_i_Callback(hObject, eventdata, handles)
% hObject    handle to edit_solar_i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_solar_i as text
%        str2double(get(hObject,'String')) returns contents of edit_solar_i as a double


% --- Executes during object creation, after setting all properties.
function edit_solar_i_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_solar_i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_TmaxdailyK_Callback(hObject, eventdata, handles)
% hObject    handle to edit_TmaxdailyK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_TmaxdailyK as text
%        str2double(get(hObject,'String')) returns contents of edit_TmaxdailyK as a double


% --- Executes during object creation, after setting all properties.
function edit_TmaxdailyK_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_TmaxdailyK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_TmeandailyK_Callback(hObject, eventdata, handles)
% hObject    handle to edit_TmeandailyK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_TmeandailyK as text
%        str2double(get(hObject,'String')) returns contents of edit_TmeandailyK as a double


% --- Executes during object creation, after setting all properties.
function edit_TmeandailyK_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_TmeandailyK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_TmindailyK_Callback(hObject, eventdata, handles)
% hObject    handle to edit_TmindailyK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_TmindailyK as text
%        str2double(get(hObject,'String')) returns contents of edit_TmindailyK as a double


% --- Executes during object creation, after setting all properties.
function edit_TmindailyK_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_TmindailyK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_solar24_Callback(hObject, eventdata, handles)
% hObject    handle to edit_solar24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_solar24 as text
%        str2double(get(hObject,'String')) returns contents of edit_solar24 as a double


% --- Executes during object creation, after setting all properties.
function edit_solar24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_solar24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_rh_daily_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rh_daily (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rh_daily as text
%        str2double(get(hObject,'String')) returns contents of edit_rh_daily as a double


% --- Executes during object creation, after setting all properties.
function edit_rh_daily_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rh_daily (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_u_daily_Callback(hObject, eventdata, handles)
% hObject    handle to edit_u_daily (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_u_daily as text
%        str2double(get(hObject,'String')) returns contents of edit_u_daily as a double


% --- Executes during object creation, after setting all properties.
function edit_u_daily_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_u_daily (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_rh_inst.
function pushbutton_rh_inst_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_rh_inst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
yeardoy=str2num(get(handles.edit_yeardoy,'string'));

mainPath = pwd;
inputPath = fullfile(mainPath,'Inputs');
defaultfile=fullfile(inputPath,'Weather',strcat('rhinst_awdn_', int2str(yeardoy),'_Landsat.tif'));
[FileName,PathName,FilterIndex] = uigetfile(defaultfile,'Select rh_inst file');
fullname_rh_inst=fullfile(PathName,FileName);
set(handles.edit_rh_inst,'String',fullname_rh_inst)


% --- Executes on button press in pushbutton_TinstK.
function pushbutton_TinstK_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_TinstK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
yeardoy=str2num(get(handles.edit_yeardoy,'string'));

mainPath = pwd;
inputPath = fullfile(mainPath,'Inputs');
defaultfile=fullfile(inputPath,'Weather',strcat('TinstK_awdn_', int2str(yeardoy),'_Landsat.tif'));
[FileName,PathName,FilterIndex] = uigetfile(defaultfile,'Select rh_inst file');
fullname_TinstK=fullfile(PathName,FileName);
set(handles.edit_TinstK,'String',fullname_TinstK)


% --- Executes on button press in pushbutton_u_inst.
function pushbutton_u_inst_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_u_inst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
yeardoy=str2num(get(handles.edit_yeardoy,'string'));

mainPath = pwd;
inputPath = fullfile(mainPath,'Inputs');
defaultfile=fullfile(inputPath,'Weather',strcat('uinst_awdn_', int2str(yeardoy),'_Landsat.tif'));
[FileName,PathName,FilterIndex] = uigetfile(defaultfile,'Select u_inst file');
fullname_u_inst=fullfile(PathName,FileName);
set(handles.edit_u_inst,'String',fullname_u_inst)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
yeardoy=str2num(get(handles.edit_yeardoy,'string'));

mainPath = pwd;
inputPath = fullfile(mainPath,'Inputs');
defaultfile=fullfile(inputPath,'Weather',strcat('solarinst_awdn_', int2str(yeardoy),'_Landsat.tif'));
[FileName,PathName,FilterIndex] = uigetfile(defaultfile,'Select u_inst file');
fullname_solar_i=fullfile(PathName,FileName);
set(handles.edit_solar_i,'String',fullname_solar_i)


% --- Executes on button press in pushbutton_TmaxdailyK.
function pushbutton_TmaxdailyK_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_TmaxdailyK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
yeardoy=str2num(get(handles.edit_yeardoy,'string'));
mainPath = pwd;
inputPath = fullfile(mainPath,'Inputs');
defaultfile=fullfile(inputPath,'Weather',strcat('Tmaxd_awdn_', int2str(yeardoy),'_Landsat.tif'));
[FileName,PathName,FilterIndex] = uigetfile(defaultfile,'Select TmaxdailyK file');
fullname_TmaxdailyK=fullfile(PathName,FileName);
set(handles.edit_TmaxdailyK,'String',fullname_TmaxdailyK)


% --- Executes on button press in pushbutton_TmeandailyK.
function pushbutton_TmeandailyK_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_TmeandailyK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
yeardoy=str2num(get(handles.edit_yeardoy,'string'));
mainPath = pwd;
inputPath = fullfile(mainPath,'Inputs');
defaultfile=fullfile(inputPath,'Weather',strcat('Tmeand_awdn_', int2str(yeardoy),'_Landsat.tif'));
[FileName,PathName,FilterIndex] = uigetfile(defaultfile,'Select TmeandailyK file');
fullname_TmeandailyK=fullfile(PathName,FileName);
set(handles.edit_TmeandailyK,'String',fullname_TmeandailyK)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
yeardoy=str2num(get(handles.edit_yeardoy,'string'));
mainPath = pwd;
inputPath = fullfile(mainPath,'Inputs');
defaultfile=fullfile(inputPath,'Weather',strcat('Tmind_awdn_', int2str(yeardoy),'_Landsat.tif'));
[FileName,PathName,FilterIndex] = uigetfile(defaultfile,'Select TmindailyK file');
fullname_TmindailyKK=fullfile(PathName,FileName);
set(handles.edit_TmindailyK,'String',fullname_TmindailyKK)


% --- Executes on button press in pushbutton_solar24.
function pushbutton_solar24_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_solar24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
yeardoy=str2num(get(handles.edit_yeardoy,'string'));
mainPath = pwd;
inputPath = fullfile(mainPath,'Inputs');
defaultfile=fullfile(inputPath,'Weather',strcat('s24d_awdn_', int2str(yeardoy),'_Landsat.tif'));
[FileName,PathName,FilterIndex] = uigetfile(defaultfile,'Select TmindailyK file');
fullname_solar24=fullfile(PathName,FileName);
set(handles.edit_TmindailyK,'String',fullname_solar24)


% --- Executes on button press in pushbutton_rh_daily.
function pushbutton_rh_daily_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_rh_daily (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
yeardoy=str2num(get(handles.edit_yeardoy,'string'));
mainPath = pwd;
inputPath = fullfile(mainPath,'Inputs');
defaultfile=fullfile(inputPath,'Weather',strcat('rhd_awdn_', int2str(yeardoy),'_Landsat.tif'));
[FileName,PathName,FilterIndex] = uigetfile(defaultfile,'Select TmindailyK file');
fullname_rh_daily=fullfile(PathName,FileName);
set(handles.edit_rh_daily,'String',fullname_rh_daily)


% --- Executes on button press in pushbutton_u_daily.
function pushbutton_u_daily_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_u_daily (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
yeardoy=str2num(get(handles.edit_yeardoy,'string'));
mainPath = pwd;
inputPath = fullfile(mainPath,'Inputs');
defaultfile=fullfile(inputPath,'Weather',strcat('ud_awdn_', int2str(yeardoy),'_Landsat.tif'));
[FileName,PathName,FilterIndex] = uigetfile(defaultfile,'Select TmindailyK file');
fullname_u_daily=fullfile(PathName,FileName);
set(handles.edit_u_daily,'String',fullname_u_daily)


% --- Executes on button press in pushbutton_lst.
function pushbutton_lst_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_lst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
yeardoy=str2num(get(handles.edit_yeardoy,'string'));
mainPath = pwd;
inputPath = fullfile(mainPath,'Inputs');
defaultfile=fullfile(inputPath,'RS',strcat('lst_',int2str(yeardoy),'_Landsat.tif'));
[FileName,PathName,FilterIndex] = uigetfile(defaultfile,'Select LST file');
fullname_lst=fullfile(PathName,FileName);
set(handles.edit_lst,'String',fullname_lst)


% --- Executes on button press in pushbutton_albedo.
function pushbutton_albedo_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_albedo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
yeardoy=str2num(get(handles.edit_yeardoy,'string'));
mainPath = pwd;
inputPath = fullfile(mainPath,'Inputs');
defaultfile=fullfile(inputPath,'RS',strcat('albedo_', int2str(yeardoy),'_Landsat.tif'));
[FileName,PathName,FilterIndex] = uigetfile(defaultfile,'Select LST file');
fullname_albedo=fullfile(PathName,FileName);
set(handles.edit_albedo,'String',fullname_albedo)


% --- Executes on button press in pushbutton_ndvi.
function pushbutton_ndvi_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ndvi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
yeardoy=str2num(get(handles.edit_yeardoy,'string'));
mainPath = pwd;
inputPath = fullfile(mainPath,'Inputs');
defaultfile=fullfile(inputPath,'RS',strcat('ndvi_', int2str(yeardoy),'_Landsat.tif'));
[FileName,PathName,FilterIndex] = uigetfile(defaultfile,'Select LST file');
fullname_ndvi=fullfile(PathName,FileName);
set(handles.edit_ndvi,'String',fullname_ndvi)


% --- Executes on button press in pushbutton_emiss.
function pushbutton_emiss_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_emiss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
yeardoy=str2num(get(handles.edit_yeardoy,'string'));
mainPath = pwd;
inputPath = fullfile(mainPath,'Inputs');
defaultfile=fullfile(inputPath,'RS',strcat('emiss_', int2str(yeardoy),'_Landsat.tif'));
[FileName,PathName,FilterIndex] = uigetfile(defaultfile,'Select emiss file');
fullname_emiss=fullfile(PathName,FileName);
set(handles.edit_emiss,'String',fullname_emiss)


% --- Executes on button press in pushbutton_imghr.
function pushbutton_imghr_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_imghr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
yeardoy=str2num(get(handles.edit_yeardoy,'string'));
mainPath = pwd;
inputPath = fullfile(mainPath,'Inputs');
defaultfile=fullfile(inputPath,'RS',strcat('imghr_', int2str(yeardoy),'_Modis.tif'));
[FileName,PathName,FilterIndex] = uigetfile(defaultfile,'Select emiss file');
fullname_imghr=fullfile(PathName,FileName);
set(handles.edit_imghr,'String',fullname_imghr)


% --- Executes on button press in pushbutton_imgmm.
function pushbutton_imgmm_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_imgmm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
yeardoy=str2num(get(handles.edit_yeardoy,'string'));
mainPath = pwd;
inputPath = fullfile(mainPath,'Inputs');
defaultfile=fullfile(inputPath,'RS',strcat('imgmm_', int2str(yeardoy),'_Modis.tif'));
[FileName,PathName,FilterIndex] = uigetfile(defaultfile,'Select imgmm file');
fullname_imgmm=fullfile(PathName,FileName);
set(handles.edit_imgmm,'String',fullname_imgmm)


% --- Executes on button press in pushbutton_b.
function pushbutton_b_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
yeardoy=str2num(get(handles.edit_yeardoy,'string'));
mainPath = pwd;
inputPath = fullfile(mainPath,'Inputs');
defaultfile=fullfile(inputPath,'RS',strcat('b_', int2str(yeardoy),'_Modis.tif'));
[FileName,PathName,FilterIndex] = uigetfile(defaultfile,'Select imgmm file');
fullname_b=fullfile(PathName,FileName);
set(handles.edit_b,'String',fullname_b)


% --- Executes on button press in pushbutton_z0m.
function pushbutton_z0m_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_z0m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
yeardoy=str2num(get(handles.edit_yeardoy,'string'));
mainPath = pwd;
inputPath = fullfile(mainPath,'Inputs');
defaultfile=fullfile(inputPath,'Derived',strcat('z0m_', int2str(yeardoy),'_Landsat.tif'));
[FileName,PathName,FilterIndex] = uigetfile(defaultfile,'Select imgmm file');
fullname_z0m=fullfile(PathName,FileName);
set(handles.edit_z0m,'String',fullname_z0m)


% --- Executes on button press in pushbutton_Igood.
function pushbutton_Igood_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Igood (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
yeardoy=str2num(get(handles.edit_yeardoy,'string'));
mainPath = pwd;
inputPath = fullfile(mainPath,'Inputs');
defaultfile=fullfile(inputPath,'Derived',strcat('Igood_', int2str(yeardoy),'_Landsat.tif'));
[FileName,PathName,FilterIndex] = uigetfile(defaultfile,'Select imgmm file');
fullname_Igood=fullfile(PathName,FileName);
set(handles.edit_Igood,'String',fullname_Igood)


% --- Executes on button press in pushbutton_Iwater.
function pushbutton_Iwater_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Iwater (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
yeardoy=str2num(get(handles.edit_yeardoy,'string'));
mainPath = pwd;
inputPath = fullfile(mainPath,'Inputs');
defaultfile=fullfile(inputPath,'Derived',strcat('Iwater_', int2str(yeardoy),'_Landsat.tif'));
[FileName,PathName,FilterIndex] = uigetfile(defaultfile,'Select imgmm file');
fullname_Iwater=fullfile(PathName,FileName);
set(handles.edit_Iwater,'String',fullname_Iwater)


% --- Executes on button press in pushbutton_Ag_filter.
function pushbutton_Ag_filter_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Ag_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
yeardoy=str2num(get(handles.edit_yeardoy,'string'));
mainPath = pwd;
defaultfile=fullfile(mainPath,'Agbinary_landsat.tif');
[FileName,PathName,FilterIndex] = uigetfile(defaultfile,'Select imgmm file');
fullname_Ag_filter=fullfile(PathName,FileName);
set(handles.edit_Ag_filter,'String',fullname_Ag_filter)



function edit_computeKr_Callback(hObject, eventdata, handles)
% hObject    handle to edit_computeKr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_computeKr as text
%        str2double(get(hObject,'String')) returns contents of edit_computeKr as a double


% --- Executes during object creation, after setting all properties.
function edit_computeKr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_computeKr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_p_year.
function pushbutton_p_year_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_p_year (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
yeardoy=str2num(get(handles.edit_yeardoy,'string'));
mainPath = pwd;
inputPath = fullfile(mainPath,'Inputs');
yeardoy_str = num2str(yeardoy);
year = str2num(yeardoy_str(1:4));
defaultfile=fullfile(inputPath,'Weather',strcat('Pstacked_',int2str(year),'.tif'));
[FileName,PathName,FilterIndex] = uigetfile(defaultfile,'Select p_year file');
fullname_p_year=fullfile(PathName,FileName);
set(handles.edit_p_year,'String',fullname_p_year)


function edit_p_year_Callback(hObject, eventdata, handles)
% hObject    handle to edit_p_year (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_p_year as text
%        str2double(get(hObject,'String')) returns contents of edit_p_year as a double


% --- Executes during object creation, after setting all properties.
function edit_p_year_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_p_year (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_et0_year.
function pushbutton_et0_year_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_et0_year (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
yeardoy=str2num(get(handles.edit_yeardoy,'string'));
mainPath = pwd;
inputPath = fullfile(mainPath,'Inputs');
yeardoy_str = num2str(yeardoy);
year = str2num(yeardoy_str(1:4));
defaultfile=fullfile(inputPath,'Weather',strcat('ETostacked_',int2str(year),'.tif'));
[FileName,PathName,FilterIndex] = uigetfile(defaultfile,'Select p_year file');
fullname_et0_year=fullfile(PathName,FileName);
set(handles.edit_et0_year,'String',fullname_et0_year)


function edit_et0_year_Callback(hObject, eventdata, handles)
% hObject    handle to edit_et0_year (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_et0_year as text
%        str2double(get(hObject,'String')) returns contents of edit_et0_year as a double


% --- Executes during object creation, after setting all properties.
function edit_et0_year_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_et0_year (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_computeK.
function popupmenu_computeK_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_computeK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_computeK contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_computeK
popupmenu_computeK=get(handles.popupmenu_computeK,'Value');
if popupmenu_computeK==1
    mainPath = pwd;
inputPath = fullfile(mainPath,'Inputs');
    yeardoy=str2num(get(handles.edit_yeardoy,'string'));
    yeardoy_str = num2str(yeardoy);
    year = str2num(yeardoy_str(1:4));
    defaultfile=fullfile(inputPath,'Weather',strcat('Pstacked_',int2str(year),'.tif'));
    set(handles.edit_p_year,'String',defaultfile)

    fullname_et0_year=fullfile(inputPath,'Weather',strcat('ETostacked_',int2str(year),'.tif'));
    set(handles.edit_et0_year,'String',fullname_et0_year)
    fullname_soil=fullfile(mainPath,'soil_ras_landsat.tif');
    set(handles.edit_soil,'String',fullname_soil)
else
    set(handles.edit_p_year,'String','Null')
    set(handles.edit_et0_year,'String','Null')
    set(handles.edit_soil,'String','Null')

end

% --- Executes during object creation, after setting all properties.
function popupmenu_computeK_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_computeK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_soil.
function pushbutton_soil_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_soil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
yeardoy=str2num(get(handles.edit_yeardoy,'string'));
mainPath = pwd;
inputPath = fullfile(mainPath,'Inputs');
yeardoy_str = num2str(yeardoy);
year = str2num(yeardoy_str(1:4));
defaultfile=fullfile(mainPath,'soil_ras_landsat.tif');
[FileName,PathName,FilterIndex] = uigetfile(defaultfile,'Select soil file');
fullname_soil=fullfile(PathName,FileName);
set(handles.edit_soil,'String',fullname_soil)


function edit_soil_Callback(hObject, eventdata, handles)
% hObject    handle to edit_soil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_soil as text
%        str2double(get(hObject,'String')) returns contents of edit_soil as a double


% --- Executes during object creation, after setting all properties.
function edit_soil_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_soil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_kr_Callback(hObject, eventdata, handles)
% hObject    handle to edit_kr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_kr as text
%        str2double(get(hObject,'String')) returns contents of edit_kr as a double


% --- Executes during object creation, after setting all properties.
function edit_kr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_kr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_kr_max_Callback(hObject, eventdata, handles)
% hObject    handle to edit_kr_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_kr_max as text
%        str2double(get(hObject,'String')) returns contents of edit_kr_max as a double


% --- Executes during object creation, after setting all properties.
function edit_kr_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_kr_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_z_st_veg_Callback(hObject, eventdata, handles)
% hObject    handle to edit_z_st_veg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_z_st_veg as text
%        str2double(get(hObject,'String')) returns contents of edit_z_st_veg as a double


% --- Executes during object creation, after setting all properties.
function edit_z_st_veg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_z_st_veg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_zref_Callback(hObject, eventdata, handles)
% hObject    handle to edit_zref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_zref as text
%        str2double(get(hObject,'String')) returns contents of edit_zref as a double


% --- Executes during object creation, after setting all properties.
function edit_zref_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_zref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_t_interval_Callback(hObject, eventdata, handles)
% hObject    handle to edit_t_interval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_t_interval as text
%        str2double(get(hObject,'String')) returns contents of edit_t_interval as a double


% --- Executes during object creation, after setting all properties.
function edit_t_interval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_t_interval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_lapse_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lapse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lapse as text
%        str2double(get(hObject,'String')) returns contents of edit_lapse as a double


% --- Executes during object creation, after setting all properties.
function edit_lapse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lapse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_zb_Callback(hObject, eventdata, handles)
% hObject    handle to edit_zb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_zb as text
%        str2double(get(hObject,'String')) returns contents of edit_zb as a double


% --- Executes during object creation, after setting all properties.
function edit_zb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_zb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton27.
function pushbutton27_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
yeardoy=str2num(get(handles.edit_yeardoy,'string'));
mainPath = pwd;
inputPath = fullfile(mainPath,'Inputs');
yeardoy_str = num2str(yeardoy);
year = str2num(yeardoy_str(1:4));
defaultfile=fullfile(mainPath,'dem_landsat.tif');
[FileName,PathName,FilterIndex] = uigetfile(defaultfile,'Select dem file');
fullname_dem=fullfile(PathName,FileName);
set(handles.edit_dem,'String',fullname_dem)



function edit_dem_Callback(hObject, eventdata, handles)
% hObject    handle to edit_dem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dem as text
%        str2double(get(hObject,'String')) returns contents of edit_dem as a double


% --- Executes during object creation, after setting all properties.
function edit_dem_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function edit_ff_open_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ff_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ff_open as text
%        str2double(get(hObject,'String')) returns contents of edit_ff_open as a double


% --- Executes during object creation, after setting all properties.
function edit_ff_open_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ff_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_lstlowerlimit_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lstlowerlimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lstlowerlimit as text
%        str2double(get(hObject,'String')) returns contents of edit_lstlowerlimit as a double


% --- Executes during object creation, after setting all properties.
function edit_lstlowerlimit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lstlowerlimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_lststep_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lststep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lststep as text
%        str2double(get(hObject,'String')) returns contents of edit_lststep as a double


% --- Executes during object creation, after setting all properties.
function edit_lststep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lststep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_lstupperlimit_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lstupperlimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lstupperlimit as text
%        str2double(get(hObject,'String')) returns contents of edit_lstupperlimit as a double


% --- Executes during object creation, after setting all properties.
function edit_lstupperlimit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lstupperlimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_lstwindow_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lstwindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lstwindow as text
%        str2double(get(hObject,'String')) returns contents of edit_lstwindow as a double


% --- Executes during object creation, after setting all properties.
function edit_lstwindow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lstwindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ndvilowerlimit_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ndvilowerlimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ndvilowerlimit as text
%        str2double(get(hObject,'String')) returns contents of edit_ndvilowerlimit as a double


% --- Executes during object creation, after setting all properties.
function edit_ndvilowerlimit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ndvilowerlimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ndvistep_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ndvistep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ndvistep as text
%        str2double(get(hObject,'String')) returns contents of edit_ndvistep as a double


% --- Executes during object creation, after setting all properties.
function edit_ndvistep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ndvistep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ndviupperlimit_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ndviupperlimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ndviupperlimit as text
%        str2double(get(hObject,'String')) returns contents of edit_ndviupperlimit as a double


% --- Executes during object creation, after setting all properties.
function edit_ndviupperlimit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ndviupperlimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ndviwindow_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ndviwindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ndviwindow as text
%        str2double(get(hObject,'String')) returns contents of edit_ndviwindow as a double


% --- Executes during object creation, after setting all properties.
function edit_ndviwindow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ndviwindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_pixellimit_bins_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pixellimit_bins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_pixellimit_bins as text
%        str2double(get(hObject,'String')) returns contents of edit_pixellimit_bins as a double


% --- Executes during object creation, after setting all properties.
function edit_pixellimit_bins_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_pixellimit_bins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_pixellimit_counts_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pixellimit_counts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_pixellimit_counts as text
%        str2double(get(hObject,'String')) returns contents of edit_pixellimit_counts as a double


% --- Executes during object creation, after setting all properties.
function edit_pixellimit_counts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_pixellimit_counts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Kadj_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Kadj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Kadj as text
%        str2double(get(hObject,'String')) returns contents of edit_Kadj as a double


% --- Executes during object creation, after setting all properties.
function edit_Kadj_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Kadj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_k_Callback(hObject, eventdata, handles)
% hObject    handle to edit_k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_k as text
%        str2double(get(hObject,'String')) returns contents of edit_k as a double


% --- Executes during object creation, after setting all properties.
function edit_k_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_outputpath_Callback(hObject, eventdata, handles)
% hObject    handle to edit_outputpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_outputpath as text
%        str2double(get(hObject,'String')) returns contents of edit_outputpath as a double


% --- Executes during object creation, after setting all properties.
function edit_outputpath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_outputpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton28.
function pushbutton28_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mainPath = pwd;
outPath = fullfile(mainPath,'Outputs','Landsat');

defaultfile=outPath;
PathName= uigetdir(defaultfile,'Select output path');
fullname_outpath=PathName;
set(handles.edit_outputpath,'String',fullname_outpath)


% --- Executes on button press in pushbutton29.
function pushbutton29_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
yeardoy=str2num(get(handles.edit_yeardoy,'string'));

lst_path=get(handles.edit_lst,'string');
[lst, Rsub] = geotiffread(lst_path); % Jiménez?Muñoz et al., 2003; Sobrino et al. 2004, (http://onlinelibrary.wiley.com/doi/10.1029/2003JD003480/full)
info_sub = geotiffinfo(lst_path);
albedo_path=get(handles.edit_albedo,'string');
albedo = geotiffread(albedo_path);
ndvi_path=get(handles.edit_ndvi,'string');
ndvi = geotiffread(ndvi_path);
emiss_path=get(handles.edit_emiss,'string');
emiss=geotiffread(emiss_path);

z0m_path=get(handles.edit_z0m,'string');
z0m=geotiffread(z0m_path);

Igood_path=get(handles.edit_Igood,'string');
Igood=geotiffread(Igood_path);
Iwater_path=get(handles.edit_Iwater,'string');
Iwater=geotiffread(Iwater_path);
Ag_filter_path=get(handles.edit_Ag_filter,'string');
Ag_filter=geotiffread(Ag_filter_path);
Ag_filter = double(Ag_filter);

rh_inst_path=get(handles.edit_rh_inst,'string');
rh_inst=geotiffread(rh_inst_path);

TinstK_path=get(handles.edit_TinstK,'string');
TinstK=geotiffread(TinstK_path);

u_inst_path=get(handles.edit_u_inst,'string');
u_inst=geotiffread(u_inst_path);

solar_i_path=get(handles.edit_solar_i,'string');
solar_i=geotiffread(solar_i_path);

TmaxdailyK_path=get(handles.edit_TmaxdailyK,'string');
TmaxdailyK=geotiffread(TmaxdailyK_path);

TmeandailyK_path=get(handles.edit_TmeandailyK,'string');
TmeandailyK=geotiffread(TmeandailyK_path);

TmindailyK_path=get(handles.edit_TmindailyK,'string');
TmindailyK=geotiffread(TmindailyK_path);

solar24_path=get(handles.edit_solar24,'string');
solar24=geotiffread(solar24_path);

rh_daily_path=get(handles.edit_rh_daily,'string');
rh_daily=geotiffread(rh_daily_path);

u_daily_path=get(handles.edit_u_daily,'string');
u_daily=geotiffread(u_daily_path);

computeKr=get(handles.popupmenu_computeK,'Value');

if computeKr ==1
    yeardoy_str = num2str(yeardoy);
    year = str2num(yeardoy_str(1:4));
    
    % vector- one column
%     load ([inputPath,'Weather\P_',int2str(year),'.mat']);
%     load ([inputPath,'Weather\et0_',int2str(year),'.mat']);
    
    %     % 365/366 days of stacked daily P and et0
    p_year_path=get(handles.edit_p_year,'string');
    p_year=geotiffread(p_year_path);
    et0_year_path=get(handles.edit_et0_year,'string');
    et0_year=geotiffread(et0_year_path);
    soil_path=get(handles.edit_soil,'string');
    soil=geotiffread(soil_path);
    % also load soil type map.
    
end

kr=str2num(get(handles.edit_kr,'string'));
kr_max=str2num(get(handles.edit_kr_max,'string'));
z_st_veg=str2num(get(handles.edit_z_st_veg,'string'));
zref=str2num(get(handles.edit_zref,'string'));
t_interval=str2num(get(handles.edit_t_interval,'string'));
lapse=str2num(get(handles.edit_lapse,'string'));
zb=str2num(get(handles.edit_zb,'string'));
dem_path=get(handles.edit_dem,'string');
dem=geotiffread(dem_path);
dem= double(dem);


ff_open=str2num(get(handles.edit_ff_open,'string'));
lstlowerlimit=str2num(get(handles.edit_lstlowerlimit,'string'));
lststep=str2num(get(handles.edit_lststep,'string'));
lstupperlimit=str2num(get(handles.edit_lstupperlimit,'string'));
lstwindow=str2num(get(handles.edit_lstwindow,'string'));
ndvilowerlimit=str2num(get(handles.edit_ndvilowerlimit,'string'));
ndvistep=str2num(get(handles.edit_ndvistep,'string'));
ndviupperlimit=str2num(get(handles.edit_ndviupperlimit,'string'));
ndviwindow=str2num(get(handles.edit_ndviwindow,'string'));
pixellimit_bins=str2num(get(handles.edit_pixellimit_bins,'string'));
pixellimit_counts=str2num(get(handles.edit_pixellimit_counts,'string'));

landsattype=str2num(get(handles.edit_landsattype,'string'));

satellite_type=get(handles.popupmenu_satallite_type,'Value');
if satellite_type==1
    b=str2num(get(handles.edit_b,'string'));
    imghr=str2num(get(handles.edit_imghr,'string'));
    imgmm=str2num(get(handles.edit_imgmm,'string'));
    
else
    b_path=get(handles.edit_b,'string');
    b=geotiffread(b_path);
    imghr_path=get(handles.edit_imghr,'string');
    imghr=geotiffread(imghr_path);
    imgmm_path=get(handles.edit_imgmm,'string');
    imgmm=geotiffread(imgmm_path);
end

tic;
yeardoy=str2num(get(handles.edit_yeardoy,'string'));
yeardoy_str = num2str(yeardoy);
doy = str2num(yeardoy_str(5:7));
Kadj=str2num(get(handles.edit_Kadj,'string'));
k=str2num(get(handles.edit_k,'string'));
bbmain= info_sub.BoundingBox;
pixelsize = info_sub.PixelScale(1);
% %main image cornerx and cornery and subimage cornerx and corney y;
mainCx = bbmain(1,1); mainCy = bbmain(2,2);

m = info_sub.Height;
n = info_sub.Width;
[imglon,imglat] = MakeLatLongridsFromGeotiffInfo(info_sub,m,n);


% computing reference weather info

%  for reference ET and atm tswimage
lon_vec = imglon(:,1);
lz = zeros(size(lon_vec));
lm = zeros(size(lon_vec));
for loni =1:size(lon_vec,1)
    lon = lon_vec(loni,1);
    if lon >0
        lz(loni,1) = 360-round(lon,0);
        lm(loni,1) = 360-round(lon,0);

    else
        lz(loni,1) = round(lon,0);
        lm(loni,1) = round(lon,0);
    end

    while rem(lz(loni,1),15)~=0
        lz(loni,1)=lz(loni,1)+1;
    end

end

lz = repmat(lz,1,n);
lm = repmat(lm,1,n);

imgtime = imghr + imgmm/60;

f = waitbar(0,'Data processing started...');
pause(1)

% reference imagetime ETr
[etr_inst,~] = hourlyREF_ET_image(doy,TinstK-273.15,TinstK-273.15,dem,solar_i,rh_inst,u_inst,zref,imgtime,lz,imglat,lm,t_interval);
% Daily ETr and 24hr net radiation
[etr_d, ~, Q24] = DailyREF_ET_image(doy, TmindailyK-273.15, TmaxdailyK-273.15,dem,solar24,rh_daily,u_daily,zref,imglat);
%DEM correct LST
lst_dem = lst + lapse .*dem;
%% HOT AND COLD PIXEL SELECTION
%1.1 binary image of ag and non ag
[bw_1] = FindCandidate_Ag_pixels(lst_dem, ndvi, albedo, Ag_filter, Igood,landsattype,lstupperlimit,lstlowerlimit,ff_open);
% figure,imagesc(bw_1);
%2.2. Select hot and cold pixel


[lsthotx,lsthoty,lstcoldx,lstcoldy,lstcold,lsthot,cent_counts_l1,cent_counts_n1,coldrow,coldcol,hotrow,hotcol,...
    per_conLcold, per_conNcold,per_conLhot, per_conNhot,count_lstcold_len,count_lsthot_len,...
    min_lstmean,max_ndvimean, max_lstmean,min_ndvimean] = FindHotColdPixelsImage(bw_1,mainCx,mainCy,pixelsize,...
    lst_dem,ndvi,lstupperlimit,lstlowerlimit,ndviupperlimit,ndvilowerlimit,pixellimit_bins,pixellimit_counts,lstwindow, ndviwindow,lststep, ndvistep);

waitbar(.25,f,'Hot and Cold pixel selected Completed.');
pause(1)

%% 2. NOW RUN THE SEBAL and METRIC MODELS
% [m,n] = size(lst);
% tinstC in degree C
TinstC = TinstK - 273.15;

%computeKr=get(handles.popupmenu_computeK,'Value');

if computeKr ==1
    if length(size(soil)) >1 % if 3 diemensional
        soil_t_hot = soil(hotrow,hotcol);
        
    end
    
end
hot_lon = imglon(hotrow,hotcol);
hot_lat = imglat(hotrow,hotcol);

if computeKr ==1
    if length(size(p_year)) >2 % if 3 diemensional
        if size(p_year,3) < 365
            error('missing P for all doys in the year, check this input')
        elseif size(p_year,3) >= 365
                            p_year_path=get(handles.edit_et0_year,'string');

            info_p = geotiffinfo(p_year_path);
            [imglon_p,imglat_p] = MakeLatLongridsFromGeotiffInfo(info_p,info_p.Height, info_p.Width);
            bbmain_p= info_p.BoundingBox;
            pixelsize_p = info_p.PixelScale(1);
            mainCx_p = bbmain_p(1,1); mainCy_p = bbmain_p(2,2);
            %find location of hot pixel
            hotcol_p = ceil((abs(mainCx_p-hot_lon))/pixelsize_p)+1;
            hotrow_p= ceil((abs(mainCy_p-hot_lat))/pixelsize_p)+1;
            p_year_vec = p_year(hotrow_p,hotcol_p,1:end);
            p_year = p_year_vec(:);
            
        end
    end
    
    if length(size(et0_year)) >2  % if 3 diemensional
        if size(et0_year,3) < 365
            error('missing ET0 for all doys in the year, check this input')
        elseif size(et0_year,3) >= 365
                et0_year_path=get(handles.edit_et0_year,'string');
              % et0_year=geotiffread(et0_year_path);
            info_p = geotiffinfo(et0_year_path);
            [imglon_p,imglat_p] = MakeLatLongridsFromGeotiffInfo(info_p,info_p.Height, info_p.Width);
            bbmain_p= info_p.BoundingBox;
            pixelsize_p = info_p.PixelScale(1);
            mainCx_p = bbmain_p(1,1); mainCy_p = bbmain_p(2,2);
            %find location of hot pixel
            hotcol_p = ceil((abs(mainCx_p-hot_lon))/pixelsize_p)+1;
            hotrow_p= ceil((abs(mainCy_p-hot_lat))/pixelsize_p)+1;
            
            et0_year_vec = et0_year(hotrow_p,hotcol_p,1:end);
            et0_year = et0_year_vec(:);
            
        end
    end
    
    kr  = Skin_evapAllen(p_year,et0_year,soil_t_hot,doy);
    kr = min(kr,kr_max);
    
end

%% Compute Net radiation and soil heat flux durin gimage hour
% cd(codePath);
% Use same method to compute Rn and G in all models
[m,n] = size(lst);
Isnow = zeros(m,n);
Isnow(ndvi < 0 & albedo > 0.47) = 1;
ind = find(Iwater ==1|Isnow ==1);
Rn = NetImageTimeSolarRadiation(solar_i,TinstK,rh_inst, albedo, emiss, lst);
GbyRn = ((lst-273.16) ./ albedo .* (0.0038 * albedo + 0.0074 * albedo .^2)) .* (1 - 0.98 * ndvi .^4);
G = round(Rn .*GbyRn);
clear ('GbyRn');
G(Iwater ==1|Isnow ==1) = 0.5 * Rn(Iwater ==1|Isnow ==1); % G of water and snow

Igood(isnan(G)==1)=0;
Igood(isnan(Rn)==1)=0;



runSEBAL=get(handles.checkbox_runSEBAL,'value');
runMETRIC=get(handles.checkbox_runMETRIC,'value');
if runSEBAL ==1  && runMETRIC~=1
    %% 2.1 SEBAL MODEL
%     tic;
    waitbar(.50,f,'Running Automated SEBAL model.....');
    pause(1)
%     disp('Running Automated SEBAL.........');
    [~, ~, ~, ~,~,~, ~,~,~, ~,efcold,efhot, ~,...
        h_sebal,lamdaet_sebal,inset_sebal, ef_sebal, det_sebal, ~, lamda24et_sebal,Lamda24] = SEBAL(Rn, G,zref,zb,Q24,...
        lst,TinstK,TmeandailyK,coldrow,coldcol,hotrow,hotcol,z0m,dem,z_st_veg,u_inst, lapse);
%     toc;
end

if runMETRIC ==1 && runSEBAL~=1
    %% 2.1 METRIC MODEL
%     tic;
    waitbar(.50,f,'Running Automated METRIC model.....');
    pause(1)
    [lstcold, lsthot, countiter, ~,~,~, ~,~,~, ~,~,~, ~,...
    h_metric,lamdaet_metric,inset_metric, etrf_metric,det_metric, ~, lamda24et_metric] = METRIC(Rn, G,...
    lst,coldrow,coldcol,hotrow,hotcol,kr, z0m, zref,dem,z_st_veg,u_inst,zb,TinstK,etr_inst,etr_d, Q24,Kadj, lapse);
%     toc;
    % figure, imagesc(lamdaet_metric);caxis([0 400]);colorbar;title('lamdaet_metric');
% figure, imagesc(det_metric);caxis([0 8]);colorbar;title('Daily ET metric');
end


if runSEBAL ==1 && runMETRIC==1
    waitbar(.50,f,'Running Automated SEBAL and METRIC models.....');
    pause(1)
%     tic;
    [~, ~, ~, ~,~,~, ~,~,~, ~,efcold,efhot, ~,...
        h_sebal,lamdaet_sebal,inset_sebal, ef_sebal, det_sebal, ~, lamda24et_sebal,Lamda24] = SEBAL(Rn, G,zref,zb,Q24,...
        lst,TinstK,TmeandailyK,coldrow,coldcol,hotrow,hotcol,z0m,dem,z_st_veg,u_inst, lapse);
    
        [lstcold, lsthot, countiter, ~,~,~, ~,~,~, ~,~,~, ~,...
    h_metric,lamdaet_metric,inset_metric, etrf_metric,det_metric, ~, lamda24et_metric] = METRIC(Rn, G,...
    lst,coldrow,coldcol,hotrow,hotcol,kr, z0m, zref,dem,z_st_veg,u_inst,zb,TinstK,etr_inst,etr_d, Q24,Kadj, lapse);
%     toc;
    
end


if runMETRIC ~=1 && runSEBAL~=1
    %% 2.1 METRIC MODEL
%     tic;
    waitbar(.50,f,'Please select a Model to run.....');
    pause(1)
    
%     toc;
    % figure, imagesc(lamdaet_metric);caxis([0 400]);colorbar;title('lamdaet_metric');
% figure, imagesc(det_metric);caxis([0 8]);colorbar;title('Daily ET metric');
end



makeFig_LE=get(handles.checkbox_makeFig_LE,'value');
makeFig_DailyETs=get(handles.checkbox_makeFig_DailyETs,'value');
saveMATS=get(handles.checkbox_saveMATS,'value');
saveGeoTIFFS=get(handles.checkbox_saveGeoTIFFS,'value');
%% Give Options to save output as geotiff or mats
outPath=get(handles.edit_outputpath,'String');
%% Make Figure
% [imglon,imglat] = MakeLatLongridsFromGeotiffInfo(info_sub,m,n);
%% Click to visualize location of hot and cold pixel
% figure,imagesc(lst .*bw_1);caxis([lstcold-5 lsthot+5]);colorbar;title('LST from candidate pixels');
% text(hotcol,hotrow,'* Hot pixel','Color','r','FontWeight','Bold','FontSize',16)
% text(coldcol,coldrow,'* Cold pixel','Color','r','FontWeight','Bold','FontSize',16)

% [FigHandle] = graph_img(lst .*bw_1,imglat,imglon, 'Tentative location of hot and cold pixels in the image',  lstcold-5, lsthot+5,1,'LST from candidate pixels (K)');
% text(imglon(hotrow,hotcol),imglat(hotrow,hotcol),'* Hot pixel','Color','r','FontWeight','Bold','FontSize',16)
% text(imglon(coldrow,coldcol),imglat(coldrow,coldcol),'* Cold pixel','Color','r','FontWeight','Bold','FontSize',16)
%
% % figure, imagesc(det_sebal); caxis([0 8]);colorbar;
%
% %% Click to visualize Latent heat flux from SEBAL and METRIC


%% SEBAL MODEL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if runSEBAL ==1  && runMETRIC~=1
    
    if makeFig_LE==1
        figure,
        %         subplot(1,2,1)
        [FigHandle] = graph_img(lamdaet_sebal,imglat,imglon, 'LE from SEBAL',  0, min(nanmax(nanmax(lamdaet_sebal)),500),1,'Instantaneous LE (W m ^{-2})');
        %         subplot(1,2,2)
        %         [FigHandle1] = graph_img(lamdaet_metric,imglat,imglon, 'LE from METRIC',  0, min(nanmax(nanmax(lamdaet_metric)),500),1,'Instantaneous LE (W m ^{-2})');
    end
    %
    %
    %% Click to visualize daily ET from SEBAL and METRIC
    if makeFig_DailyETs==1
        figure,
        %         subplot(1,2,1)
        [FigHandle] = graph_img(det_sebal,imglat,imglon, 'Daily from SEBAL',  0, min(nanmax(nanmax(det_sebal)),8),1,'Daily ET (mm day^{-1})');
        %         subplot(1,2,2)
        %         [FigHandle1] = graph_img(det_metric,imglat,imglon, 'Daily ET from METRIC',  0, min(nanmax(nanmax(det_metric)),8),1,'Daily ET (mm day^{-1})');
    end
    
    %% Give Options to save output as geotiff or mats
    %saveGeoTIFFS=1; % USE YES or NO button (Save model outputs as GeoTIFFS)
    %saveMATS=1;%(Save model outputs as MATS)
    
    if saveMATS ==1
        
        % SEBAL
        save (fullfile(outPath,strcat('le_sebal_',int2str(yeardoy),'.mat')),'lamdaet_sebal');
        save (fullfile(outPath,strcat('h_sebal_',int2str(yeardoy),'.mat')),'h_sebal');
        save (fullfile(outPath,strcat('ef_sebal_',int2str(yeardoy),'.mat')),'ef_sebal');
        save (fullfile(outPath,strcat('inset_sebal_',int2str(yeardoy),'.mat')),'inset_sebal');
        save (fullfile(outPath,strcat('det_sebal_',int2str(yeardoy),'.mat')),'det_sebal');
    end
    
    if  saveGeoTIFFS==1
        %SEBAL
        geotiffwrite(fullfile(outPath,strcat('le_sebal_',int2str(yeardoy),'.tif')),  lamdaet_sebal,Rsub,'GeoKeyDirectoryTag', info_sub.GeoTIFFTags.GeoKeyDirectoryTag);
        geotiffwrite(fullfile(outPath,strcat('h_sebal_',int2str(yeardoy),'.tif')),  h_sebal,Rsub,'GeoKeyDirectoryTag', info_sub.GeoTIFFTags.GeoKeyDirectoryTag);
        geotiffwrite(fullfile(outPath,strcat('ef_sebal_',int2str(yeardoy),'.tif')),  ef_sebal,Rsub,'GeoKeyDirectoryTag', info_sub.GeoTIFFTags.GeoKeyDirectoryTag);
        geotiffwrite(fullfile(outPath,strcat('inset_sebal_',int2str(yeardoy),'.tif')),  inset_sebal,Rsub,'GeoKeyDirectoryTag', info_sub.GeoTIFFTags.GeoKeyDirectoryTag);
        geotiffwrite(fullfile(outPath,strcat('det_sebal_',int2str(yeardoy),'.tif')),  det_sebal,Rsub,'GeoKeyDirectoryTag', info_sub.GeoTIFFTags.GeoKeyDirectoryTag);
    end
    
    
    
    
end


%% METRIC MODEL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if runMETRIC ==1 && runSEBAL~=1
    
    
    if makeFig_LE==1
        figure,
        
        [FigHandle1] = graph_img(lamdaet_metric,imglat,imglon, 'LE from METRIC',  0, min(nanmax(nanmax(lamdaet_metric)),500),1,'Instantaneous LE (W m ^{-2})');
    end
    %
    %
    %% Click to visualize daily ET from SEBAL and METRIC
    if makeFig_DailyETs==1
        figure,
        [FigHandle1] = graph_img(det_metric,imglat,imglon, 'Daily ET from METRIC',  0, min(nanmax(nanmax(det_metric)),8),1,'Daily ET (mm day^{-1})');
    end
    
    %% Give Options to save output as geotiff or mats
    %saveGeoTIFFS=1; % USE YES or NO button (Save model outputs as GeoTIFFS)
    %saveMATS=1;%(Save model outputs as MATS)
    
    if saveMATS ==1
        
        % METRIC
        save (fullfile(outPath,strcat('le_metric_',int2str(yeardoy),'.mat')),'lamdaet_metric');
        save (fullfile(outPath,strcat('h_metric_',int2str(yeardoy),'.mat')),'h_metric');
        save (fullfile(outPath,strcat('etrf_metric_',int2str(yeardoy),'.mat')),'etrf_metric');
        save (fullfile(outPath,strcat('inset_metric_',int2str(yeardoy),'.mat')),'inset_metric');
        save (fullfile(outPath,strcat('det_metric_',int2str(yeardoy),'.mat')),'det_metric');
    end
    
    if  saveGeoTIFFS==1
        % METRIC
        geotiffwrite(fullfile(outPath,strcat('le_metric_',int2str(yeardoy),'.tif')),  lamdaet_metric,Rsub,'GeoKeyDirectoryTag', info_sub.GeoTIFFTags.GeoKeyDirectoryTag);
        geotiffwrite(fullfile(outPath,strcat('h_metric_',int2str(yeardoy),'.tif')),  h_metric,Rsub,'GeoKeyDirectoryTag', info_sub.GeoTIFFTags.GeoKeyDirectoryTag);
        geotiffwrite(fullfile(outPath,strcat('etrf_metric_',int2str(yeardoy),'.tif')),  etrf_metric,Rsub,'GeoKeyDirectoryTag', info_sub.GeoTIFFTags.GeoKeyDirectoryTag);
        geotiffwrite(fullfile(outPath,strcat('inset_metric_',int2str(yeardoy),'.tif')),  inset_metric,Rsub,'GeoKeyDirectoryTag', info_sub.GeoTIFFTags.GeoKeyDirectoryTag);
        geotiffwrite(fullfile(outPath,strcat('det_metric_',int2str(yeardoy),'.tif')),  det_metric,Rsub,'GeoKeyDirectoryTag', info_sub.GeoTIFFTags.GeoKeyDirectoryTag);
    end
    
    
    
    
end


%% BOTH MODELS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if runSEBAL ==1 && runMETRIC==1
    
    
    if makeFig_LE==1
        figure,
        subplot(1,2,1)
        [FigHandle] = graph_img(lamdaet_sebal,imglat,imglon, 'LE from SEBAL',  0, min(nanmax(nanmax(lamdaet_sebal)),500),1,'Instantaneous LE (W m ^{-2})');
        subplot(1,2,2)
        [FigHandle1] = graph_img(lamdaet_metric,imglat,imglon, 'LE from METRIC',  0, min(nanmax(nanmax(lamdaet_metric)),500),1,'Instantaneous LE (W m ^{-2})');
    end
    %
    %
    %% Click to visualize daily ET from SEBAL and METRIC
    if makeFig_DailyETs==1
        figure,
        subplot(1,2,1)
        [FigHandle] = graph_img(det_sebal,imglat,imglon, 'Daily from SEBAL',  0, min(nanmax(nanmax(det_sebal)),8),1,'Daily ET (mm day^{-1})');
        subplot(1,2,2)
        [FigHandle1] = graph_img(det_metric,imglat,imglon, 'Daily ET from METRIC',  0, min(nanmax(nanmax(det_metric)),8),1,'Daily ET (mm day^{-1})');
    end
    
    %% Give Options to save output as geotiff or mats
    %saveGeoTIFFS=1; % USE YES or NO button (Save model outputs as GeoTIFFS)
    %saveMATS=1;%(Save model outputs as MATS)
    
    if saveMATS ==1
        % METRIC
        save (fullfile(outPath,strcat('le_metric_',int2str(yeardoy),'.mat')),'lamdaet_metric');
        save (fullfile(outPath,strcat('h_metric_',int2str(yeardoy),'.mat')),'h_metric');
        save (fullfile(outPath,strcat('etrf_metric_',int2str(yeardoy),'.mat')),'etrf_metric');
        save (fullfile(outPath,strcat('inset_metric_',int2str(yeardoy),'.mat')),'inset_metric');
        save (fullfile(outPath,strcat('det_metric_',int2str(yeardoy),'.mat')),'det_metric');
        
        % SEBAL
        save (fullfile(outPath,strcat('le_sebal_',int2str(yeardoy),'.mat')),'lamdaet_sebal');
        save (fullfile(outPath,strcat('h_sebal_',int2str(yeardoy),'.mat')),'h_sebal');
        save (fullfile(outPath,strcat('ef_sebal_',int2str(yeardoy),'.mat')),'ef_sebal');
        save (fullfile(outPath,strcat('inset_sebal_',int2str(yeardoy),'.mat')),'inset_sebal');
        save (fullfile(outPath,strcat('det_sebal_',int2str(yeardoy),'.mat')),'det_sebal');
    end
    
    if  saveGeoTIFFS==1
        % METRIC
        geotiffwrite(fullfile(outPath,strcat('le_metric_',int2str(yeardoy),'.tif')),  lamdaet_metric,Rsub,'GeoKeyDirectoryTag', info_sub.GeoTIFFTags.GeoKeyDirectoryTag);
        geotiffwrite(fullfile(outPath,strcat('h_metric_',int2str(yeardoy),'.tif')),  h_metric,Rsub,'GeoKeyDirectoryTag', info_sub.GeoTIFFTags.GeoKeyDirectoryTag);
        geotiffwrite(fullfile(outPath,strcat('etrf_metric_',int2str(yeardoy),'.tif')),  etrf_metric,Rsub,'GeoKeyDirectoryTag', info_sub.GeoTIFFTags.GeoKeyDirectoryTag);
        geotiffwrite(fullfile(outPath,strcat('inset_metric_',int2str(yeardoy),'.tif')),  inset_metric,Rsub,'GeoKeyDirectoryTag', info_sub.GeoTIFFTags.GeoKeyDirectoryTag);
        geotiffwrite(fullfile(outPath,strcat('det_metric_',int2str(yeardoy),'.tif')),  det_metric,Rsub,'GeoKeyDirectoryTag', info_sub.GeoTIFFTags.GeoKeyDirectoryTag);
        
        %SEBAL
        geotiffwrite(fullfile(outPath,strcat('le_sebal_',int2str(yeardoy),'.tif')),  lamdaet_sebal,Rsub,'GeoKeyDirectoryTag', info_sub.GeoTIFFTags.GeoKeyDirectoryTag);
        geotiffwrite(fullfile(outPath,strcat('h_sebal_',int2str(yeardoy),'.tif')),  h_sebal,Rsub,'GeoKeyDirectoryTag', info_sub.GeoTIFFTags.GeoKeyDirectoryTag);
        geotiffwrite(fullfile(outPath,strcat('ef_sebal_',int2str(yeardoy),'.tif')),  ef_sebal,Rsub,'GeoKeyDirectoryTag', info_sub.GeoTIFFTags.GeoKeyDirectoryTag);
        geotiffwrite(fullfile(outPath,strcat('inset_sebal_',int2str(yeardoy),'.tif')),  inset_sebal,Rsub,'GeoKeyDirectoryTag', info_sub.GeoTIFFTags.GeoKeyDirectoryTag);
        geotiffwrite(fullfile(outPath,strcat('det_sebal_',int2str(yeardoy),'.tif')),  det_sebal,Rsub,'GeoKeyDirectoryTag', info_sub.GeoTIFFTags.GeoKeyDirectoryTag);
    end
    
    
end




% Options to save Rn and G
saveRn_MATS=get(handles.checkbox_saveRn_MATS,'value');
saveG_MATS =get(handles.checkbox_saveG_MATS,'value');
saveRn_GeoTIFFS =get(handles.checkbox_saveRn_GeoTIFFS,'value');
saveG_GeoTIFFS =get(handles.checkbox_saveG_GeoTIFFS,'value');
if saveRn_MATS ==1
    
    save(fullfile(outPath,strcat('Rn_',int2str(yeardoy),'.mat')), 'Rn');
end

if saveG_MATS ==1
    save(fullfile(outPath,strcat('G_',int2str(yeardoy),'.mat')), 'G');
end


if saveRn_GeoTIFFS ==1
   geotiffwrite(fullfile(outPath,strcat('Rn_',int2str(yeardoy),'.tif')),  Rn,Rsub,'GeoKeyDirectoryTag', info_sub.GeoTIFFTags.GeoKeyDirectoryTag);
end

if saveG_GeoTIFFS ==1
    geotiffwrite(fullfile(outPath,strcat('G_',int2str(yeardoy),'.tif')),  G,Rsub,'GeoKeyDirectoryTag', info_sub.GeoTIFFTags.GeoKeyDirectoryTag);
end


if (saveRn_GeoTIFFS==1|| saveRn_GeoTIFFS) ==1 && (runSEBAL ==1||runMETRIC==1) 
    waitbar(1,f,'Finished. Outputs are saved. Please close this message box');
    
elseif runSEBAL ~=1 && runMETRIC~=1
    waitbar(1,f,'Please close this message box. No model selected');
    
else
     waitbar(1,f,'Finished. Please close this message box');
end

pause(1)

toc;

% --- Executes on button press in checkbox_saveGeoTIFFS.
function checkbox_saveGeoTIFFS_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_saveGeoTIFFS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_saveGeoTIFFS


% --- Executes on button press in checkbox_saveSEBAL_GeoTIFFS.
function checkbox_saveSEBAL_GeoTIFFS_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_saveSEBAL_GeoTIFFS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_saveSEBAL_GeoTIFFS


% --- Executes on button press in checkbox_saveMETRIC_MATS.
function checkbox_saveMETRIC_MATS_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_saveMETRIC_MATS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_saveMETRIC_MATS


% --- Executes on button press in checkbox_saveMATS.
function checkbox_saveMATS_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_saveMATS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_saveMATS


% --- Executes on button press in checkbox_saveRn_MATS.
function checkbox_saveRn_MATS_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_saveRn_MATS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_saveRn_MATS


% --- Executes on button press in checkbox_saveG_MATS.
function checkbox_saveG_MATS_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_saveG_MATS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_saveG_MATS


% --- Executes on button press in checkbox_saveRn_GeoTIFFS.
function checkbox_saveRn_GeoTIFFS_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_saveRn_GeoTIFFS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_saveRn_GeoTIFFS


% --- Executes on button press in checkbox_saveG_GeoTIFFS.
function checkbox_saveG_GeoTIFFS_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_saveG_GeoTIFFS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_saveG_GeoTIFFS


% --- Executes on button press in radiobutton1.


%--- Executes on selection change in popupmenu_satallite_type.
function popupmenu_satallite_type_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_satallite_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_satallite_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_satallite_type
satellite_type=get(handles.popupmenu_satallite_type,'Value');
if satellite_type==1
        mainPath = pwd;
    inputPath = fullfile(mainPath,'Inputs');
    outPath = fullfile(mainPath,'Outputs','Landsat');
    if ~exist(outPath)
        mkdir(fullfile(mainPath,'Outputs','Landsat'))
    end
    cd(mainPath);

    %defaultfile=fullfile(pwd,'Inputs','lst_l5_2011277.tif');
    set(handles.popupmenu_satallite_type,'Value',1)
    set(handles.edit_yeardoy,'String',num2str(2006215))
    set(handles.edit_landsattype,'String', num2str(5))
    set(handles.edit_b,'String', num2str(90-61.66628785))
    set(handles.edit_imghr,'String', num2str(10))
    set(handles.edit_imgmm,'String', num2str(55))

    yeardoy=str2num(get(handles.edit_yeardoy,'string'));
    defaultfile=fullfile(inputPath,'RS',strcat('lst_',int2str(yeardoy),'_Landsat.tif'));
    set(handles.edit_lst,'String',defaultfile)
    defaultfile=fullfile(inputPath,'RS',strcat('albedo_', int2str(yeardoy),'_Landsat.tif'));
    set(handles.edit_albedo,'String',defaultfile)
    defaultfile=fullfile(inputPath,'RS',strcat('emiss_', int2str(yeardoy),'_Landsat.tif'));
    set(handles.edit_emiss,'String',defaultfile)
    defaultfile=fullfile(inputPath,'RS',strcat('ndvi_', int2str(yeardoy),'_Landsat.tif'));
    set(handles.edit_ndvi,'String',defaultfile)

    defaultfile=fullfile(inputPath,'Derived',strcat('z0m_', int2str(yeardoy),'_Landsat.tif'));
    set(handles.edit_z0m,'String',defaultfile)
    defaultfile=fullfile(inputPath,'Derived',strcat('Igood_', int2str(yeardoy),'_Landsat.tif'));
    set(handles.edit_Igood,'String',defaultfile)
    defaultfile=fullfile(inputPath,'Derived',strcat('Iwater_', int2str(yeardoy),'_Landsat.tif'));
    set(handles.edit_Iwater,'String',defaultfile)
    defaultfile=fullfile(mainPath,'Agbinary_landsat.tif');
    set(handles.edit_Ag_filter,'String',defaultfile)
    
    
    defaultfile=fullfile(inputPath,'Weather',strcat('rhinst_awdn_', int2str(yeardoy),'_Landsat.tif'));
    set(handles.edit_rh_inst,'String',defaultfile)
    defaultfile=fullfile(inputPath,'Weather',strcat('TinstK_awdn_', int2str(yeardoy),'_Landsat.tif'));
    set(handles.edit_TinstK,'String',defaultfile)
    defaultfile=fullfile(inputPath,'Weather',strcat('uinst_awdn_', int2str(yeardoy),'_Landsat.tif'));
    set(handles.edit_u_inst,'String',defaultfile)
    defaultfile=fullfile(inputPath,'Weather',strcat('solarinst_awdn_', int2str(yeardoy),'_Landsat.tif'));
    set(handles.edit_solar_i,'String',defaultfile)
    defaultfile=fullfile(inputPath,'Weather',strcat('solarinst_awdn_', int2str(yeardoy),'_Landsat.tif'));
    set(handles.edit_solar_i,'String',defaultfile)
    defaultfile=fullfile(inputPath,'Weather',strcat('Tmaxd_awdn_', int2str(yeardoy),'_Landsat.tif'));
    set(handles.edit_TmaxdailyK,'String',defaultfile)
    defaultfile=fullfile(inputPath,'Weather',strcat('Tmeand_awdn_', int2str(yeardoy),'_Landsat.tif'));
    set(handles.edit_TmeandailyK,'String',defaultfile)
    defaultfile=fullfile(inputPath,'Weather',strcat('Tmind_awdn_', int2str(yeardoy),'_Landsat.tif'));
    set(handles.edit_TmindailyK,'String',defaultfile)
    defaultfile=fullfile(inputPath,'Weather',strcat('s24d_awdn_', int2str(yeardoy),'_Landsat.tif'));
    set(handles.edit_solar24,'String',defaultfile)
    defaultfile=fullfile(inputPath,'Weather',strcat('rhd_awdn_', int2str(yeardoy),'_Landsat.tif'));
    set(handles.edit_rh_daily,'String',defaultfile)
    defaultfile=fullfile(inputPath,'Weather',strcat('ud_awdn_', int2str(yeardoy),'_Landsat.tif'));
    set(handles.edit_u_daily,'String',defaultfile)
    set(handles.popupmenu_computeK,'Value',2)
    set(handles.edit_p_year,'String','Null')
    set(handles.edit_et0_year,'String','Null')
    set(handles.edit_soil,'String','Null')
    yeardoy_str = num2str(yeardoy);
    year = str2num(yeardoy_str(1:4));
    defaultfile=fullfile(inputPath,'Weather',strcat('Pstacked_',int2str(year),'.tif'));
    %set(handles.edit_p_year,'String',defaultfile)

    fullname_et0_year=fullfile(inputPath,'Weather',strcat('ETostacked_',int2str(year),'.tif'));
    %set(handles.edit_et0_year,'String',fullname_et0_year)
    fullname_soil=fullfile(mainPath,'soil_ras_landsat.tif');
    %set(handles.edit_soil,'String',fullname_soil)
    set(handles.edit_kr,'String','0')
    set(handles.edit_kr_max,'String','0.15')
    set(handles.edit_z_st_veg,'String','0.15')
    set(handles.edit_zref,'String','10')
    set(handles.edit_t_interval,'String','1')
    set(handles.edit_lapse,'String','0.0065')
    set(handles.edit_zb,'String','200')

    set(handles.edit_dem,'String',fullfile(mainPath,'dem_landsat.tif'))

    load defaults_hotcold_param_landsat;
   
    set(handles.edit_ff_open,'String',num2str(ff_open))
    set(handles.edit_lstlowerlimit,'String',num2str(lstlowerlimit))
    set(handles.edit_lststep,'String',num2str(lststep))
    set(handles.edit_lstupperlimit,'String',num2str(lstupperlimit))
    set(handles.edit_lstwindow,'String',num2str(lstwindow))
    set(handles.edit_ndvilowerlimit,'String',num2str(ndvilowerlimit))
    set(handles.edit_ndvistep,'String',num2str(ndvistep))
    set(handles.edit_ndviupperlimit,'String',num2str(ndviupperlimit))
    set(handles.edit_ndviwindow,'String',num2str(ndviwindow))
    set(handles.edit_pixellimit_bins,'String',num2str(pixellimit_bins))
    set(handles.edit_pixellimit_counts,'String',num2str(pixellimit_counts))

    set(handles.edit_Kadj,'String',num2str(1.05))
    set(handles.edit_k,'String',num2str(0.41))

    set(handles.checkbox_saveGeoTIFFS,'value',1);
    set(handles.checkbox_saveMATS,'value',1);

    set(handles.checkbox_saveRn_MATS,'value',1);
    set(handles.checkbox_saveG_MATS,'value',1);
    set(handles.checkbox_saveRn_GeoTIFFS,'value',1);
    set(handles.checkbox_saveG_GeoTIFFS,'value',1);
    
    set(handles.checkbox_makeFig_LE,'value',0);
    set(handles.checkbox_makeFig_DailyETs,'value',0);
    set(handles.checkbox_runMETRIC,'value',1);
    set(handles.checkbox_runSEBAL,'value',1);
elseif satellite_type==2
     mainPath=pwd;
     inputPath = fullfile(mainPath,'Inputs');
%     outPath = fullfile(mainPath,'Outputs','Landsat');
%     if ~exist(outPath)
%         mkdir(fullfile(mainPath,'Outputs','Landsat'))
%     end
%     cd(mainPath);
% 
%     %defaultfile=fullfile(pwd,'Inputs','lst_l5_2011277.tif');
%     set(handles.popupmenu_satallite_type,'Value',1)
%     set(handles.edit_yeardoy,'String',num2str(2006215))
     yeardoy=str2num(get(handles.edit_yeardoy,'string'));
%     set(handles.edit_landsattype,'String', num2str(0))
     set(handles.edit_b,'String', fullfile(inputPath,'RS',strcat('b_', int2str(yeardoy),'_Modis.tif')))
     set(handles.edit_imghr,'String', fullfile(inputPath,'RS',strcat('imghr_', int2str(yeardoy),'_Modis.tif')))
     set(handles.edit_imgmm,'String', fullfile(inputPath,'RS',strcat('imgmm_', int2str(yeardoy),'_Modis.tif')))
% 
    defaultfile=fullfile(inputPath,'RS',strcat('lst_', int2str(yeardoy),'_Modis.tif'));
    set(handles.edit_lst,'String',defaultfile)
    defaultfile=fullfile(inputPath,'RS',strcat('albedo_', int2str(yeardoy),'_Modis.tif'));
    set(handles.edit_albedo,'String',defaultfile)
    defaultfile=fullfile(inputPath,'RS',strcat('emiss_', int2str(yeardoy),'_Modis.tif'));
    set(handles.edit_emiss,'String',defaultfile)
    defaultfile=fullfile(inputPath,'RS',strcat('ndvi_', int2str(yeardoy),'_Modis.tif'));
    set(handles.edit_ndvi,'String',defaultfile)
% 
    defaultfile=fullfile(inputPath,'Derived',strcat('z0m_', int2str(yeardoy),'_Modis.tif'));
    set(handles.edit_z0m,'String',defaultfile)
    defaultfile=fullfile(inputPath,'Derived',strcat('Igood_', int2str(yeardoy),'_Modis.tif'));
    set(handles.edit_Igood,'String',defaultfile)
    defaultfile=fullfile(inputPath,'Derived',strcat('Iwater_', int2str(yeardoy),'_Modis.tif'));
    set(handles.edit_Iwater,'String',defaultfile)
    defaultfile=fullfile(mainPath,'Agbinary_Modis.tif');
    set(handles.edit_Ag_filter,'String',defaultfile)
%     
%     
    defaultfile=fullfile(inputPath,'Weather',strcat('rhinst_awdn_', int2str(yeardoy),'_Modis.tif'));
    set(handles.edit_rh_inst,'String',defaultfile)
    defaultfile=fullfile(inputPath,'Weather',strcat('TinstK_awdn_', int2str(yeardoy),'_Modis.tif'));
    set(handles.edit_TinstK,'String',defaultfile)
    defaultfile=fullfile(inputPath,'Weather',strcat('uinst_awdn_', int2str(yeardoy),'_Modis.tif'));
    set(handles.edit_u_inst,'String',defaultfile)
    defaultfile=fullfile(inputPath,'Weather',strcat('solarinst_awdn_', int2str(yeardoy),'_Modis.tif'));
    set(handles.edit_solar_i,'String',defaultfile)
    defaultfile=fullfile(inputPath,'Weather',strcat('TmaxdK_awdn_', int2str(yeardoy),'_Modis.tif'));
    set(handles.edit_TmaxdailyK,'String',defaultfile)
    defaultfile=fullfile(inputPath,'Weather',strcat('TmeandK_awdn_', int2str(yeardoy),'_Modis.tif'));
    set(handles.edit_TmeandailyK,'String',defaultfile)
    defaultfile=fullfile(inputPath,'Weather',strcat('TmindK_awdn_', int2str(yeardoy),'_Modis.tif'));
    set(handles.edit_TmindailyK,'String',defaultfile)
    defaultfile=fullfile(inputPath,'Weather',strcat('s24d_awdn_', int2str(yeardoy),'_Modis.tif'));
    set(handles.edit_solar24,'String',defaultfile)
    defaultfile=fullfile(inputPath,'Weather',strcat('rhd_awdn_', int2str(yeardoy),'_Modis.tif'));
    set(handles.edit_rh_daily,'String',defaultfile)
    defaultfile=fullfile(inputPath,'Weather',strcat('ud_awdn_', int2str(yeardoy),'_Modis.tif'));
    set(handles.edit_u_daily,'String',defaultfile)
    
    set(handles.popupmenu_computeK,'Value',2)
    set(handles.edit_p_year,'String','Null')
    set(handles.edit_et0_year,'String','Null')
    set(handles.edit_soil,'String','Null')
    
    yeardoy_str = num2str(yeardoy);
    year = str2num(yeardoy_str(1:4));
    defaultfile=fullfile(inputPath,'Weather',strcat('Pstacked_',int2str(year),'.tif'));
    %set(handles.edit_p_year,'String',defaultfile)

    fullname_et0_year=fullfile(inputPath,'Weather',strcat('ETostacked_',int2str(year),'.tif'));
    %set(handles.edit_et0_year,'String',fullname_et0_year)
    fullname_soil=fullfile(mainPath,'soil_ras_modis.tif');
    %set(handles.edit_soil,'String',fullname_soil)
    set(handles.edit_kr,'String','0')
    set(handles.edit_kr_max,'String','0.15')
    set(handles.edit_z_st_veg,'String','0.15')
    set(handles.edit_zref,'String','10')
    set(handles.edit_t_interval,'String','1')
    set(handles.edit_lapse,'String','0.0065')
    set(handles.edit_zb,'String','200')
% 
    set(handles.edit_dem,'String',fullfile(mainPath,'dem4Modis.tif'))
% 
     load defaults_hotcold_param_modis;

    set(handles.edit_ff_open,'String',num2str(ff_open))
    set(handles.edit_lstlowerlimit,'String',num2str(lstlowerlimit))
    set(handles.edit_lststep,'String',num2str(lststep))
    set(handles.edit_lstupperlimit,'String',num2str(lstupperlimit))
    set(handles.edit_lstwindow,'String',num2str(lstwindow))
    set(handles.edit_ndvilowerlimit,'String',num2str(ndvilowerlimit))
    set(handles.edit_ndvistep,'String',num2str(ndvistep))
    set(handles.edit_ndviupperlimit,'String',num2str(ndviupperlimit))
    set(handles.edit_ndviwindow,'String',num2str(ndviwindow))
    set(handles.edit_pixellimit_bins,'String',num2str(pixellimit_bins))
    set(handles.edit_pixellimit_counts,'String',num2str(pixellimit_counts))
    set(handles.edit_Kadj,'String',num2str(1.05))
    set(handles.edit_k,'String',num2str(0.41))
    set(handles.checkbox_saveGeoTIFFS,'value',1);
    set(handles.checkbox_saveMATS,'value',1);
    set(handles.checkbox_saveRn_MATS,'value',1);
    set(handles.checkbox_saveG_MATS,'value',1);
    set(handles.checkbox_saveRn_GeoTIFFS,'value',1);
    set(handles.checkbox_saveG_GeoTIFFS,'value',1);
    set(handles.checkbox_makeFig_LE,'value',0);
    set(handles.checkbox_makeFig_DailyETs,'value',0);
    set(handles.checkbox_runMETRIC,'value',1);
    set(handles.checkbox_runSEBAL,'value',1);
end

% --- Executes during object creation, after setting all properties.
function popupmenu_satallite_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_satallite_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_makeFig_LE.
function checkbox_makeFig_LE_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_makeFig_LE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_makeFig_LE


% --- Executes on button press in checkbox_makeFig_DailyETs.
function checkbox_makeFig_DailyETs_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_makeFig_DailyETs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_makeFig_DailyETs


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6


% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_runSEBAL.
function checkbox_runSEBAL_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_runSEBAL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_runSEBAL


% --- Executes on button press in checkbox_runMETRIC.
function checkbox_runMETRIC_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_runMETRIC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_runMETRIC
