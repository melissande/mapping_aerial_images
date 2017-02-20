%% Reading data

[X,p,t] = freadenvit('igalmss');
nr=p(1,1);
nc=p(1,2);
nb=p(1,3);
%% Plotting Data images

figure(1);
subplot(1,4,1);
imagesc(X(:,:,1));
title('Gray Scale Image Band 1')
colormap gray;

subplot(1,4,2);
imagesc(X(:,:,2));
title('Gray Scale Image Band 2')
colormap gray;

subplot(1,4,3);
imagesc(X(:,:,3));
title('Gray Scale Image Band 3')
colormap gray;

subplot(1,4,4);
imagesc(X(:,:,4));
title('Gray Scale Image Band 4')
colormap gray;
%% Plotting histograms

X_1=X(:,:,1);
X_1_vec=reshape(X_1,nr*nc,1);


X_2=X(:,:,2);
X_2_vec=reshape(X_2,nr*nc,1);


X_3=X(:,:,3);
X_3_vec=reshape(X_3,nr*nc,1);


X_4=X(:,:,4);
X_4_vec=reshape(X_4,nr*nc,1);

figure(2);
subplot(1,4,1);
histogram(X_1_vec);
title('Histogram Band 1')
xlabel('Pixel value')
ylabel('Counts')

subplot(1,4,2);
histogram(X_2_vec);
title('Histogram Band 2')
xlabel('Pixel value')
ylabel('Counts')

subplot(1,4,3);
histogram(X_3_vec);
title('Histogram Band 3')
xlabel('Pixel value')
ylabel('Counts')

subplot(1,4,4);
histogram(X_4_vec);
title('Histogram Band 4')
xlabel('Pixel value')
ylabel('Counts')

%% mean and covariance
X_vec = reshape(X,nr*nc,nb);
X_cc_vec = column_centering(X_vec); %substracted mean from each
X_mean_vec = mean(X_vec);
covmat = cov(X_cc_vec);     %variance-covariance matrix

X_std1 = std(X_vec(:,1));   %standard deviatons
X_std2 = std(X_vec(:,2));
X_std3 = std(X_vec(:,3));
X_std4 = std(X_vec(:,4));

min1 = X_mean_vec(1,1) - 2*X_std1; max1 = X_mean_vec(1,1) + 2*X_std1;   %min & max
min2 = X_mean_vec(1,2) - 2*X_std2; max2 = X_mean_vec(1,2) + 2*X_std2;
min3 = X_mean_vec(1,3) - 2*X_std3; max3 = X_mean_vec(1,3) + 2*X_std3;
min4 = X_mean_vec(1,4) - 2*X_std4; max4 = X_mean_vec(1,4) + 2*X_std4;

x_str1 = (X_vec(:,1) - min1) / (max1 - min1);   %stretching
x_str2 = (X_vec(:,2) - min2) / (max2 - min2);
x_str3 = (X_vec(:,3) - min3) / (max3 - min3);
x_str4 = (X_vec(:,4) - min4) / (max4 - min4);

X_str1 = reshape(x_str1, nr, nc);   %back to matrix
X_str2 = reshape(x_str2, nr, nc);   
X_str3 = reshape(x_str3, nr, nc);   
X_str4 = reshape(x_str4, nr, nc);

%% Plotting Data images

figure(3);
subplot(1,4,1);
imagesc(X_str1);
title('Gray Scale Streched Image Band 1')
colormap gray;

subplot(1,4,2);
imagesc(X_str2);
title('Gray Scale Streched Image Band 2')
colormap gray;

subplot(1,4,3);
imagesc(X_str3);
title('Gray Scale Streched Image Band 3')
colormap gray;

subplot(1,4,4);
imagesc(X_str4);
title('Gray Scale Streched Image Band 4')
colormap gray;

%% RGB
p_1 = prctile(X_vec,1,1);
p_99 = prctile(X_vec,99,1);

X_vec_rgb_str = (X_vec - repmat(p_1,nr*nc,1)) ./ (repmat(p_99,nr*nc,1) - repmat(p_1,nr*nc,1));

X_rgb = reshape(X_vec_rgb_str,nr,nc,nb);

X_red = X_rgb(:,:,4); X_green = X_rgb(:,:,2); X_blue = X_rgb(:,:,1); 

figure(4)
imshow(cat(3, X_red, X_green, X_blue));
%% RGB str

x_vec_str=cat(2,x_str4,x_str2,x_str1);

p_1_str = prctile(x_vec_str,1,1);
p_99_str = prctile(x_vec_str,99,1);

X_vec_rgb_2_str = (x_vec_str - repmat(p_1_str,nr*nc,1)) ./ (repmat(p_99_str,nr*nc,1) - repmat(p_1_str,nr*nc,1));

X_rgb_2 = reshape(X_vec_rgb_2_str,nr,nc,nb-1);
X_red_2 = X_rgb_2(:,:,1); X_green_2 = X_rgb_2(:,:,2); X_blue_2 = X_rgb_2(:,:,3);

figure(5)
imshow(cat(3, X_red_2, X_green_2, X_blue_2));


%% MFA

% Computing the shited Correlation Matrix
X_t=reshape(X,nr*nc,nb);
 
% Horizontal shift
X_sh=X(:,2:end,:);
X_h=X(:,1:end-1,:);
diff_X_h=X_h-X_sh; %difference of the images (horizo shift and orginal )
diff_X_h_vec=reshape(diff_X_h,nr*(nc-1),nb);

diff_X_h_cc=column_centering(diff_X_h_vec);
cov_diff_h=cov(diff_X_h_cc); % correlation mat

%Vertical shift

X_sv=X(2:end,:,:);
X_v=X(1:end-1,:,:);
diff_X_v=X_v-X_sv;
diff_X_v_vec=reshape(diff_X_v,(nr-1)*nc,nb);

diff_X_v_cc=column_centering(diff_X_v_vec);
cov_diff_v=cov(diff_X_v_cc);

%Pooled shifted correlation matrix
cov_shift=(cov_diff_h+cov_diff_v)/2;

%PCA on covariance matrix on original data

[ PC, P, L ] = pca_function( X_cc_vec );
check=cov(PC)-L;

%Definition of the transpose of the transformation matrix
T_t=P*L^(-1/2);

cov_shift_trans=T_t'*cov_shift*T_t;

%PCA on shifted transformed correlation mat
[P_shift,L_shift]=eig(cov_shift_trans);
[L_shift,I_shift] = sort(diag(L_shift),'descend');
L_shift=diag(L_shift);
P_shift=P_shift(:,I_shift);
check2=cov(P_shift)-L_shift;

%Column centering of original data

X_t_cc=column_centering(X_t);

%MFA
P_fin=T_t*P_shift; %final eigen vector
L_fin=L_shift;%final eigen value
PC_fin=X_t_cc*P_fin;%final principal component



%% Display results PCA

figure(6);
subplot(1,3,1);
plot([1:4],diag(L),'o');
title('PCA Scree Plot')
xlabel('Order')
ylabel('Eigen Values')

subplot(1,3,2);
plot([1:4],P(:,1),'o');
title('PCA Loading Plot - Eigen Vector 1')
xlabel('Pixels')
ylabel('Eigen Vectors')

PC_mat=reshape(PC,nr,nc,nb);
subplot(1,3,3);
imagesc(PC_mat(:,:,1));
title('PCA Score Plot - PC 1')
colormap gray;


figure(7);
subplot(1,3,1);
plot([1:4],diag(L),'o');
title(' PCA Scree Plot')
xlabel('Order')
ylabel('Eigen Values')

subplot(1,3,2);
plot([1:4],P(:,2),'o');
title('PCA  Loading Plot - Eigen Vector 2')
xlabel('Pixels')
ylabel('Eigen Vectors')

subplot(1,3,3);
imagesc(PC_mat(:,:,2));
title('PCA Score Plot - PC 2')
colormap gray;


figure(8);
subplot(1,3,1);
plot([1:4],diag(L),'o');
title('PCA Scree Plot')
xlabel('Order')
ylabel('Eigen Values')

subplot(1,3,2);
plot([1:4],P(:,3),'o');
title('PCA Loading Plot - Eigen Vector 3')
xlabel('Pixels')
ylabel('Eigen Vectors')

subplot(1,3,3);
imagesc(PC_mat(:,:,3));
title('PCA Score Plot - PC 3')
colormap gray;

figure(9);
subplot(1,3,1);
plot([1:4],diag(L),'o');
title('PCA Scree Plot')
xlabel('Order')
ylabel('Eigen Values')

subplot(1,3,2);
plot([1:4],P(:,4),'o');
title('PCA Loading Plot - Eigen Vector 4')
xlabel('Pixels')
ylabel('Eigen Vectors')

subplot(1,3,3);
imagesc(PC_mat(:,:,4));
title('PCA Score Plot - PC 4')
colormap gray;






%% Histogram MFA

p_1_MFA = prctile(PC_fin,1,1);
p_90_MFA = prctile(PC_fin,90,1);

PC_str_MFA = (PC_fin - repmat(p_1_MFA,nr*nc,1)) ./ (repmat(p_90_MFA,nr*nc,1) - repmat(p_1_MFA,nr*nc,1));

figure(10)
subplot(1,4,1);
histogram(PC_fin(:,1));
title('Histo MFA1');
xlabel('Pixel value')
ylabel('Counts')

subplot(1,4,2);
histogram(PC_fin(:,2));
title('Histo MFA2');
xlabel('Pixel value')
ylabel('Counts')

subplot(1,4,3);
histogram(PC_fin(:,3));
title('Histo MFA3');
xlabel('Pixel value')
ylabel('Counts')

subplot(1,4,4);
histogram(PC_fin(:,4));
title('Histo MFA4');
xlabel('Pixel value')
ylabel('Counts')



%% Display results MFA

%
figure(11);
subplot(1,3,1);
plot([1:4],diag(L_fin),'o');
title('Scree Plot')
xlabel('Order')
ylabel('MFA Eigen Values')

subplot(1,3,2);
plot([1:4],P_fin(:,1),'o');
title('Loading Plot - Eigen Vector 1')
xlabel('Pixels')
ylabel('MFA Eigen Vectors')


PC_str_MFA_str=reshape(PC_str_MFA,nr,nc,nb);

subplot(1,3,3);
imagesc(PC_str_MFA_str(:,:,1));
title('MFA Score Plot 1')
colormap gray;



figure(12);
subplot(1,3,1);
plot([1:4],diag(L_fin),'o');
title('MFA Scree Plot')
xlabel('Order')
ylabel('Eigen Values')

subplot(1,3,2);
plot([1:4],P_fin(:,2),'o');
title('MFA Loading Plot - Eigen Vector 2')
xlabel('Pixels')
ylabel('Eigen Vectors')



subplot(1,3,3);
imagesc(PC_str_MFA_str(:,:,2));
title('MFA Score Plot  2')
colormap gray;



figure(13);
subplot(1,3,1);
plot([1:4],diag(L_fin),'o');
title('MFA Scree Plot')
xlabel('Order')
ylabel('Eigen Values')

subplot(1,3,2);
plot([1:4],P_fin(:,3),'o');
title('MFA Loading Plot - Eigen Vector 3')
xlabel('Pixels')
ylabel('Eigen Vectors')



subplot(1,3,3);
imagesc(PC_str_MFA_str(:,:,3));
title('MFA Score Plot 3')
colormap gray;


figure(14);
subplot(1,3,1);
plot([1:4],diag(L_fin),'o');
title('MFA Scree Plot')
xlabel('Order')
ylabel('Eigen Values')

subplot(1,3,2);
plot([1:4],P_fin(:,4),'o');
title('MFA Loading Plot - Eigen Vector 4')
xlabel('Pixels')
ylabel('Eigen Vectors')



subplot(1,3,3);
imagesc(PC_str_MFA_str(:,:,4));
title('MFA Score Plot  4')
colormap gray;

