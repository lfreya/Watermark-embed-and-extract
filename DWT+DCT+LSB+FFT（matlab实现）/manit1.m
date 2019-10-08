function varargout = manit1(varargin)
% MANIT1 M-file for manit1.fig
%      MANIT1, by itself, creates a new MANIT1 or raises the existing
%      singleton*.
%
%      H = MANIT1 returns the handle to a new MANIT1 or the handle to
%      the existing singleton*.
%
%      MANIT1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MANIT1.M with the given input arguments.
%
%      MANIT1('Property','Value',...) creates a new MANIT1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before manit1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to manit1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help manit1

% Last Modified by GUIDE v2.5 03-Oct-2019 16:04:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @manit1_OpeningFcn, ...
                   'gui_OutputFcn',  @manit1_OutputFcn, ...
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


% --- Executes just before manit1 is made visible.
function manit1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to manit1 (see VARARGIN)

% Choose default command line output for manit1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes manit1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = manit1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in browsecoverimg.
function browsecoverimg_Callback(hObject, eventdata, handles)
% hObject    handle to browsecoverimg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile({'*.jpg';'*.bmp';'*.gif';'*.*'}, 'Pick an Image File');
S1 = imread([pathname,filename]);
S=imresize(S1,[512,512]);
axes(handles.axes1)
imshow(S)
title('Cover Image')
set(handles.text3,'string',filename)
setappdata(0,'cImage',S)
cImage=imshow(S);
set(cImage,'ButtonDownFcn',@sCallback)
handles.S=S;
guidata(hObject,handles)

% not use
function axes1_CreateFcn(hObject, eventdata, handles)

% click picture ,popping a figure(source picture)
function sCallback(hObject, eventdata, handles) 
figure(1);
S=getappdata(0,'cImage');
imshow(S);

% --- Executes on button press in browsemsg.
function browsemsg_Callback(hObject, eventdata, handles)
% hObject    handle to browsemsg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile({'*.bmp';'*.jpg';'*.gif';'*.*'}, 'Pick an Image File');
msg = imread([pathname,filename]);
axes(handles.axes2)
imshow(msg)
title('Input Message')
set(handles.text4,'string',filename)
setappdata(0,'msgImage',msg)
msgImage=imshow(msg);
set(msgImage,'ButtonDownFcn',@mCallback);
handles.msg=msg;
guidata(hObject,handles)

% click picture ,popping a figure(source picture)
function mCallback(hObject, eventdata, handles) 
figure(2);
msg=getappdata(0,'msgImage');
imshow(msg);

% --- Executes on button press in DWT.
function DWT_Callback(hObject, eventdata, handles)
% hObject    handle to DWT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
message=handles.msg;
cover_object=handles.S;
var=get(handles.popupmenu1,'Value');
[watermrkd_img,PSNR,NCC,MSSIM,recmessage,attack_image,attack_message,PSNR_a, NCC_a, MSSIM_a]=dwt(cover_object,message,var);
axes(handles.axes3)
imshow(watermrkd_img)
title('Watermarked Image')
setappdata(0,'wImage',watermrkd_img)
wImage=imshow(watermrkd_img);
set(wImage,'ButtonDownFcn',@wCallback)
axes(handles.axes4)
imshow(recmessage)
title('Recovered Message')
setappdata(0,'recMsg',recmessage)
recMsg=imshow(recmessage);
set(recMsg,'ButtonDownFcn',@rmCallback)
axes(handles.axes5)
imshow(attack_image)
title('Attack Image')
setappdata(0,'aImage',attack_image)
aImage=imshow(attack_image);
set(aImage,'ButtonDownFcn',@aCallback)
axes(handles.axes6)
imshow(attack_message)
title('Attack Message')
setappdata(0,'aMsg',attack_message)
aMsg=imshow(attack_message);
set(aMsg,'ButtonDownFcn',@amCallback)
a=[PSNR,PSNR_a]';
b=[NCC,NCC_a]';
c=[MSSIM,MSSIM_a]';
t=table1;
set(t,'Visible','on');
setappdata(0,'Data',[a b c]);
guidata(hObject,handles)


% --- Executes on button press in DWTDCT.
function DWTDCT_Callback(hObject, eventdata, handles)
% hObject    handle to DWTDCT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
message=handles.msg;
cover_object=handles.S;
k=10;
var=get(handles.popupmenu1,'Value');
[watermrkd_img,recmessage,PSNR,NCC1,MSSIM,attack_image,attack_message,PSNR_a, NCC_a, MSSIM_a] = dwtdct(cover_object,message,k,var);
axes(handles.axes3)
imshow(watermrkd_img)
title('DWT+DCT Watermarked Image')
setappdata(0,'wImage',watermrkd_img)
wImage=imshow(watermrkd_img);
set(wImage,'ButtonDownFcn',@wCallback)
axes(handles.axes4)
imshow(recmessage)
title('Recovered Message')
setappdata(0,'recMsg',recmessage)
recMsg=imshow(recmessage);
set(recMsg,'ButtonDownFcn',@rmCallback)
axes(handles.axes5)
imshow(attack_image)
title('Attack Image')
setappdata(0,'aImage',attack_image)
aImage=imshow(attack_image);
set(aImage,'ButtonDownFcn',@aCallback)
axes(handles.axes6)
imshow(attack_message)
title('Attack Message')
setappdata(0,'aMsg',attack_message)
aMsg=imshow(attack_message);
set(aMsg,'ButtonDownFcn',@amCallback)
a=[PSNR,PSNR_a]';
b=[NCC1,NCC_a]';
c=[MSSIM,MSSIM_a]';
setappdata(0,'Data',[a b c]);
t=table1;
set(t,'Visible','on');
guidata(hObject,handles)

% --- Executes on button press in DCT.
function DCT_Callback(hObject, eventdata, handles)
% hObject    handle to DCT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
message=handles.msg;
cover_object=handles.S;
var=get(handles.popupmenu1,'Value');
[watermrkd_img,recmessage,PSNR,NCC,MSSIM,attack_image,attack_message,PSNR_a, NCC_a, MSSIM_a] = dct(cover_object,message,var);
axes(handles.axes3)
imshow(watermrkd_img)
title('DCT Watermarked Image')
setappdata(0,'wImage',watermrkd_img)
wImage=imshow(watermrkd_img);
set(wImage,'ButtonDownFcn',@wCallback)
axes(handles.axes4)
imshow(recmessage)
title('Recovered Message')
setappdata(0,'recMsg',recmessage)
recMsg=imshow(recmessage);
set(recMsg,'ButtonDownFcn',@rmCallback)
axes(handles.axes5)
imshow(attack_image)
title('Attack Image')
setappdata(0,'aImage',attack_image)
aImage=imshow(attack_image);
set(aImage,'ButtonDownFcn',@aCallback)
axes(handles.axes6)
imshow(attack_message)
title('Attack Message')
setappdata(0,'aMsg',attack_message)
aMsg=imshow(attack_message);
set(aMsg,'ButtonDownFcn',@amCallback)
a=[PSNR,PSNR_a]';
b=[NCC,NCC_a]';
c=[MSSIM,MSSIM_a]';
setappdata(0,'Data',[a b c]);
t=table1;
set(t,'Visible','on');
guidata(hObject,handles)



% --- Executes on button press in LSB.
function LSB_Callback(hObject, eventdata, handles)
% hObject    handle to LSB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
message=handles.msg;
cover_object=handles.S;
var=get(handles.popupmenu1,'Value');
[watermrkd_img,recmessage,PSNR,NCC,MSSIM,attack_image,attack_message,PSNR_a, NCC_a, MSSIM_a] =lsb(cover_object,message,var);
axes(handles.axes3)
imshow(watermrkd_img)
title('LSB Watermarked Image')
setappdata(0,'wImage',watermrkd_img)
wImage=imshow(watermrkd_img);
set(wImage,'ButtonDownFcn',@wCallback)
axes(handles.axes4)
imshow(recmessage)
title('Recovered Message')
setappdata(0,'recMsg',recmessage)
recMsg=imshow(recmessage);
set(recMsg,'ButtonDownFcn',@rmCallback)
axes(handles.axes5)
imshow(attack_image)
title('Attack Image')
setappdata(0,'aImage',attack_image)
aImage=imshow(attack_image);
set(aImage,'ButtonDownFcn',@aCallback)
axes(handles.axes6)
imshow(attack_message)
title('Attack Message')
setappdata(0,'aMsg',attack_message)
aMsg=imshow(attack_message);
set(aMsg,'ButtonDownFcn',@amCallback)
a=[PSNR,PSNR_a]';
b=[NCC,NCC_a]';
c=[MSSIM,MSSIM_a]';
setappdata(0,'Data',[a b c]);
t=table1;
set(t,'Visible','on');
guidata(hObject,handles)


% --- Executes on button press in FFT.
function FFT_Callback(hObject, eventdata, handles)
% hObject    handle to FFT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
message=handles.msg;
cover_object=handles.S;
var=get(handles.popupmenu1,'Value');
[watermrkd_img,recmessage,PSNR,NCC,MSSIM,attack_image,attack_message,PSNR_a, NCC_a, MSSIM_a]=dft_fft(cover_object,message,var);
axes(handles.axes3)
imshow(watermrkd_img)
title('FFT Watermarked Image')
setappdata(0,'wImage',watermrkd_img)
wImage=imshow(watermrkd_img);
set(wImage,'ButtonDownFcn',@wCallback)
axes(handles.axes4)
imshow(recmessage)
title('Recovered Message')
setappdata(0,'recMsg',recmessage)
recMsg=imshow(recmessage);
set(recMsg,'ButtonDownFcn',@rmCallback)
axes(handles.axes5)
imshow(attack_image)
title('Attack Image')
setappdata(0,'aImage',attack_image)
aImage=imshow(attack_image);
set(aImage,'ButtonDownFcn',@aCallback)
axes(handles.axes6)
imshow(attack_message)
title('Attack Message')
setappdata(0,'aMsg',attack_message)
aMsg=imshow(attack_message);
set(aMsg,'ButtonDownFcn',@amCallback)
a=[PSNR,PSNR_a]';
b=[NCC,NCC_a]';
c=[MSSIM,MSSIM_a]';
setappdata(0,'Data',[a b c]);
t=table1;
set(t,'Visible','on');
guidata(hObject,handles)



% --- Executes on key press with focus on uitable1 and none of its controls.
function uitable1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu1.
function attack_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
global var;
var=get(handles.popupmenu1,'Value');



% --- Executes during object creation, after setting all properties.
function attack_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function wCallback(hObject, eventdata, handles) 
figure(3);
wImage=getappdata(0,'wImage');
imshow(wImage);

function rmCallback(hObject, eventdata, handles) 
figure(4);
recMsg=getappdata(0,'recMsg');
imshow(recMsg);

function aCallback(hObject, eventdata, handles) 
figure(5);
aImage=getappdata(0,'aImage');
imshow(aImage);

function amCallback(hObject, eventdata, handles) 
figure(6);
aMsg=getappdata(0,'aMsg');
imshow(aMsg);
