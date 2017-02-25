%% Read the data
clear all;
close all;

X1=imread('udsnit_2005_08_18_band453.tiff');
X2=imread('udsnit_2005_08_18_farve.tiff');


X1=X1(340:904,718:1644,:);
X2=X2(340:904,718:1644,:);

%% Convert the data

X1=double(X1)/255;
X2=double(X2)/255;


%% Display 

X=cat(3,X1,X2);
size_X=size(X);
X_resh=reshape(X,size_X(1,1)*size_X(1,2),size_X(1,3));

%Display X1
figure;
imshow(X1);

%Display X2

figure;
imshow(X2);

%% Classification with PCA


X_vec_cc=column_centering(X_resh);

[ PC, P, L ] = pca_function( X_vec_cc );

PC_mat=reshape(PC,size_X(1,1),size_X(1,2),size_X(1,3));
figure;
for i=1:size_X(1,3)
    subplot(1,size_X(1,3),i);
    imagesc(PC_mat(:,:,i));
    str=strcat('PCA ',int2str(i));
    title(str);
end

PC_2=PC(:,1:2);


%% Select class



figure;


nb_clus=8;
id=[];
max_likeli=zeros(size_X(1,1)*size_X(1,2),nb_clus);

sum_tr= zeros(size_X(1,1),size_X(1,2));

max_likeli_pc2=zeros(size_X(1,1)*size_X(1,2),nb_clus);
size_pc2=size(PC_2);



for i=1:nb_clus
    tr=i*roipoly(X1);
    sum_tr=sum_tr+tr;
%     filename=strcat('tr_out',num2str(i),'.mat');
%     save(filename,'tr','-v7.3');
    
    id=find(tr==i);
    X_ref=X_resh(id,:);
    sigma=cov(X_ref);
    max_likeli(:,i)=log(1/nb_clus)-1/2*log(det(sigma))-1/2*mahal(X_resh,X_ref);
    
    %For PCA
    PC2_ref=PC_2(id,:);
    sigma=cov(PC2_ref);
    max_likeli_pc2(:,i)=log(1/nb_clus)-1/2*log(det(sigma))-1/2*mahal(PC_2,PC2_ref);
 
end
% 
 [~,class_final]=max(max_likeli,[],2);
% 
class_final_resh=reshape(class_final,size_X(1,1),size_X(1,2));


 [~,class_final_pc2]=max(max_likeli_pc2,[],2);
% 
class_final_resh_pc2=reshape(class_final_pc2,size_X(1,1),size_X(1,2));


%% Create colormap

map_8=[1,0,0;0,1,0;0,0,1;0.5,0.5,0.5;1,1,0;1,0,1;0.5,0.5,1;0,0.5,0.5];
%% Plot
figure;
subplot(1,2,1)
imagesc(class_final_resh);
colormap(map_8);
title('Classification Full 6 Bands')
colorbar;

subplot(1,2,2)
imagesc(class_final_resh_pc2);
colormap(map_8);
title('Classification after PCA')
colorbar;

%% Confusion Matrix

sum_tr_vec=reshape(sum_tr,size_X(1,1)*size_X(1,2),1);
[C,order] = confusionmat(sum_tr_vec,class_final);
[C_pc2,order_pc2] = confusionmat(sum_tr_vec,class_final_pc2);

%% Accept/reject

max_maxlik=max(max_likeli');

keep=max_maxlik>-5;%% value found with histogram
keep_resh=reshape(keep,size_X(1,1),size_X(1,2));

final_class_with_reject=keep_resh.*class_final_resh;

%After PCA


max_maxlik_pc2=max(max_likeli_pc2');

keep=max_maxlik_pc2>-5;%% value found with histogram
keep_resh=reshape(keep,size_X(1,1),size_X(1,2));

final_class_with_reject_pc2=keep_resh.*class_final_resh_pc2;

map_9=[0,0,0;1,0,0;0,1,0;0,0,1;0.5,0.5,0.5;1,1,0;1,0,1;0.5,0.5,1;0,0.5,0.5];



figure;
subplot(1,2,1)
imagesc(final_class_with_reject);
title('Classification Full 6 Bands with rejects')
colormap(map_9);
colorbar;

subplot(1,2,2)
imagesc(final_class_with_reject_pc2);
title('Classification after PCA with rejects')
colormap(map_9);
colorbar;





