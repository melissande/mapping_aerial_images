%% SVM

[X_svm,p,t] = freadenvit('igalmss');
nr=p(1,1);
nc=p(1,2);
nb=p(1,3);

X_svm_b3=X_svm(:,:,3);
X_svm_b3=X_svm_b3/255;

y=cell(2000,1);
X_resh=reshape(X_svm,nr*nc,nb);



%water
tr_water=1*roipoly(X_svm_b3);
id1=find(tr_water==1);
ind1 = id1(randperm(numel(id1), 1000)); % select one element out of numel(x) elements, with the probability of occurrence of the element in x
X_fin1=X_resh(ind1,:);
y(1:1000,1)={'water'};

%other area
tr_other=1*roipoly(X_svm_b3);
id2=find(tr_other==1);
ind2 = id2(randperm(numel(id2), 1000)); % select one element out of numel(x) elements, with the probability of occurrence of the element in x
X_fin2=X_resh(ind2,:);
y(1001:2000,1)={'remaining'};

X_fin=[X_fin1;X_fin2];

%% Plot SVM
svm_Mdl = fitcsvm(X_fin,y);
% 
sv = svm_Mdl.SupportVectors;
figure(1)
subplot(3,3,1)
gscatter(X_fin(:,1),X_fin(:,2),y)
hold on
plot(sv(:,1),sv(:,2),'ko','MarkerSize',10)
legend('water','remaining','Support Vector')
title('B1 vs B2')
hold off

subplot(3,3,2)
gscatter(X_fin(:,1),X_fin(:,3),y)
hold on
plot(sv(:,1),sv(:,3),'ko','MarkerSize',10)
legend('water','remaining','Support Vector')
title('B1 vs B3')
hold off


subplot(3,3,3)
gscatter(X_fin(:,1),X_fin(:,4),y)
hold on
plot(sv(:,1),sv(:,4),'ko','MarkerSize',10)
legend('water','remaining','Support Vector')
title('B1 vs B4')
hold off

subplot(3,3,4)
gscatter(X_fin(:,2),X_fin(:,3),y)
hold on
plot(sv(:,2),sv(:,3),'ko','MarkerSize',10)
legend('water','remaining','Support Vector')
title('B2 vs B3')
hold off


subplot(3,3,5)
gscatter(X_fin(:,2),X_fin(:,4),y)
hold on
plot(sv(:,2),sv(:,4),'ko','MarkerSize',10)
legend('water','remaining','Support Vector')
title('B2 vs B4')
hold off



subplot(3,3,6)
gscatter(X_fin(:,3),X_fin(:,4),y)
hold on
plot(sv(:,3),sv(:,4),'ko','MarkerSize',10)
legend('water','remaining','Support Vector')
title('B3 vs B4')
hold off

%% Kernel


svm_Mdl_ker = fitcsvm(X_fin,y,'Standardize',true,'KernelFunction','RBF',...
    'KernelScale','auto');
sv = svm_Mdl_ker.SupportVectors;

figure(2)
subplot(3,3,1)
gscatter(X_fin(:,1),X_fin(:,2),y)
hold on
plot(sv(:,1),sv(:,2),'ko','MarkerSize',10)
legend('water','remaining','Support Vector')
title('B1 vs B2')
hold off

subplot(3,3,2)
gscatter(X_fin(:,1),X_fin(:,3),y)
hold on
plot(sv(:,1),sv(:,3),'ko','MarkerSize',10)
legend('water','remaining','Support Vector')
title('B1 vs B3')
hold off


subplot(3,3,3)
gscatter(X_fin(:,1),X_fin(:,4),y)
hold on
plot(sv(:,1),sv(:,4),'ko','MarkerSize',10)
legend('water','remaining','Support Vector')
title('B1 vs B4')
hold off

subplot(3,3,4)
gscatter(X_fin(:,2),X_fin(:,3),y)
hold on
plot(sv(:,2),sv(:,3),'ko','MarkerSize',10)
legend('water','remaining','Support Vector')
title('B2 vs B3')
hold off


subplot(3,3,5)
gscatter(X_fin(:,2),X_fin(:,4),y)
hold on
plot(sv(:,2),sv(:,4),'ko','MarkerSize',10)
legend('water','remaining','Support Vector')
title('B2 vs B4')
hold off



subplot(3,3,6)
gscatter(X_fin(:,3),X_fin(:,4),y)
hold on
plot(sv(:,3),sv(:,4),'ko','MarkerSize',10)
legend('water','remaining','Support Vector')
title('B3 vs B4')
hold off


%% Prediction
map_2=[1,0,0;0,0,1];

label = predict(svm_Mdl,X_resh);
label_mat=reshape(label,nr,nc);

label_fin=strcmp(label_mat,'water');

figure(3);
imagesc(label_fin);
colormap(map_2);
colorbar;

%% Prediction with kernel

label = predict(svm_Mdl_ker,X_resh);
label_mat=reshape(label,nr,nc);

label_fin=strcmp(label_mat,'water');

figure(4);
imagesc(label_fin);
colormap(map_2);
colorbar;

figure(5)
imshow(X_svm_b3);
