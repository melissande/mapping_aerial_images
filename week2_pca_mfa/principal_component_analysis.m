%% Data set created during class

x0=load('doc.txt');

X_cc0=column_centering(x0);
[ PC0, P0, L0 ] = pca_function( X_cc0 );
check=cov(PC0)-L0;

[U0,S0,V0]=svd(X_cc0);
[n0,p0]=size(X_cc0);
D0=S0(1:p0,:);
test01=P0+V0;
test02=(D0)^2-(n0-1)*L0;

%% Data set provided in campusnet

x_globe=dlmread('ssh.dat');
[x_gr,x_gc]=size(x_globe);
x1=x_globe(:,3:x_gc);
long=x_globe(:,1);
lat=x_globe(:,2);

X_cc1=column_centering(x1);
[ PC1, P1, L1 ] = pca_function( X_cc1 );
check=cov(PC1)-L1;

[U1,S1,V1]=svd(X_cc1, 'econ');
[n1,p1]=size(X_cc1);
D1=S1(1:p1,:);
test11=P1+V1;
test12=(D1)^2-(n1-1)*L1;

%% Plot SSH

figure(1);
hist(PC1(:,1));

PC11_str=(PC1(:,1)-(-50))/(55-(-50));

figure(2);
scatter(long,lat,15,PC11_str,'filled');
title('Principal component 1')
xlabel('latitude')
ylabel('longitude')

figure(3);
hist(PC1(:,2));

PC12_str=(PC1(:,2)-(-45))/(45-(-45));

figure(4);
scatter(long,lat,15,PC12_str,'filled');
title('Principal component 2')
xlabel('latitude')
ylabel('longitude')

figure(5);
hist(PC1(:,3));

PC13_str=(PC1(:,3)-(-30))/(32-(-30));

figure(6);
scatter(long,lat,15,PC13_str,'filled');
title('Principal component 3')
xlabel('latitude')
ylabel('longitude')

%% Plotting P ssh

figure(7);
plot([1:24]',P1(:,1));
title('Eigen Vector 1 in function of time');
xlabel('Time in months');
ylabel('Eigen Vector component');


figure(8);
plot([1:24]',P1(:,2));
title('Eigen vector 2 in function of time');
xlabel('Time in months');
ylabel('Eigen Vector component');



figure(9);
plot([1:24]',P1(:,3));
title('Eigen vector  3 in function of time');
xlabel('Time in months');
ylabel('Eigen Vector component');

