function [watermrkd_img,recmessage,PSNR,NCC,MSSIM,attack_image,attack_message,PSNR_a, NCC_a, MSSIM_a] = dft_fft(cover_object,message,var)
h=msgbox('Processing');
blocksize=8;
 message1 =message;
% determine size of watermarked image
Mc=size(cover_object,1);    %Height
Nc=size(cover_object,2);    %Width
Oc=size(cover_object,3);	%Width 
max_message=Mc*Nc/(blocksize^2);

if (length(message) > max_message)
    error('Message too large to fit in Cover Object')
end
 
% Mm=size(message,1);                         %Height
% Nm=size(message,2);                         %Width
% message=round(reshape(message,Mm*Nm,1)./256);
% message_vector=ones(1,max_message);
% % message_vector(1:length(message))=message;
%  message_vector=round(reshape(message,Mm*Nm,1)./256);
% % read in key for PN generator
% file_name='_key.bmp';
% key=double(imread(file_name))./256;
 
% % reset MATLAB's PN generator to state "key"
% j = 1;
% for i =1:length(key)
% rand('state',key(i,j));
% end

%% 嵌入水印
%Original image
origin=double(cover_object)/255;
mark=double(message)/255;
F=origin;

markM=size(mark,1);
markN=size(mark,2);

alpha=0.01;
for p=1:markM
    for q=1:markN
        BLOCK=fft2(origin(p,q,:))+alpha*mark(p,q,:);
        BLOCK=ifft2(BLOCK);
        F(p,q,:)=BLOCK;
    end
end
watermrkd=uint8(F);
watermrkd_img=im2uint8(F);

%% 提取水印
for p=1:markM
    for q=1:markN
        f1=fft2(F(p,q,:));
        f2=fft2(origin(p,q,:));
        w(p,q,:)=(f1-f2)/alpha;
    end
end

recmessage=im2uint8(w);


%% 攻击
attack_image=attack(watermrkd_img,var);

%提取攻击后的水印
attack_image1=double(attack_image)/255;
for p=1:markM
    for q=1:markN
        f3=fft2(attack_image1(p,q,:));
        f4=fft2(origin(p,q,:));
        v(p,q,:)=(f3-f4)/alpha;
    end
end

attack_message=im2uint8(v);



%% calculate the PSNR
I0     = double(cover_object);
I1     = double(watermrkd_img);
Id     = (I0-I1);
signal = sum(sum(I0.^2));
noise  = sum(sum(Id.^2));
MSE  = noise./numel(I0);
peak = max(I0(:));
PSNR = 10*log10(peak^2/MSE(:,:,1));
% PSNR_a
A0=double(watermrkd_img);
A1=double(attack_image);
Ad=(A0-A1);
signal_a = sum(sum(A0.^2));
noise_a  = sum(sum(Ad.^2));
MSE_a  = noise_a./numel(A0);
peak_a = max(A0(:));
PSNR_a = 10*log10(peak_a^2/MSE_a(:,:,1));


%% Normalized Cross Correlation
NCC=nc(message1,recmessage);
% NCC_a
NCC_a=nc(message1,attack_message);

%% calculate the SSIM
MSSIM=ssim(cover_object,watermrkd_img);
% MSSIM_a
MSSIM_a=ssim(watermrkd_img,attack_image);

close(h) 
end

