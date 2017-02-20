%% Read data

[X,p,t] = freadenvit('igalmss');
nr=p(1,1);
nc=p(1,2);
nb=p(1,3);


X_vec=reshape(X,nr*nc,nb);
%% K means algo

rng('default');  % For reproducibility
eva = evalclusters(X_vec,'kmeans','CalinskiHarabasz','KList',[1:6])

K=eva.OptimalK;

[ix_class_k,C_k]= kmeans(X_vec,K);

idx_class_mat= reshape(ix_class_k,nr,nc);
figure(1)
imagesc(idx_class_mat)
title('K means results K=5')
colormap jet



%% PCA

X_vec_cc=column_centering(X_vec);

[ PC, P, L ] = pca_function( X_vec_cc );
PC_2=PC(:,1:2);
%% K means algo on PCA


rng('default');  % For reproducibility
eva = evalclusters(X_vec,'kmeans','CalinskiHarabasz','KList',[1:6])

K=eva.OptimalK;



ix_class_k_pc= kmeans(PC_2,K);

idx_class_mat_pc= reshape(ix_class_k_pc,nr,nc);

figure(2)
imagesc(idx_class_mat_pc)
title('K means results K=5 with the 2 first PCA')
colormap jet


figure(3);

plot(X_vec(ix_class_k==1,1),X_vec(ix_class_k==1,2),'r.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==2,1),X_vec(ix_class_k==2,2),'b.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==3,1),X_vec(ix_class_k==3,2),'g.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==4,1),X_vec(ix_class_k==4,2),'y.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==5,1),X_vec(ix_class_k==5,2),'m.','MarkerSize',12)

plot(C_k(:,1),C_k(:,2),'kx',...
     'MarkerSize',15,'LineWidth',3)
legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Cluster 5','Centroids')
title 'Cluster Assignments and Centroids'
hold off

%% GMM

% % eva = evalclusters(X_vec,'gmdistribution','CalinskiHarabasz','KList',[1:6])
% % K=eva.OptimalK;
K=2;

GMModel = fitgmdist(X_vec,K);

%% Plotting GMM
figure


    h1 = scatter(X_vec(:,3),X_vec(:,4),'.g');
    h = gca;
    hold on
    fcontour(@(x1,x2)pdf(GMModel,[x1 x2]),[h.XLim h.YLim])
    title(sprintf('GM Model - %i Component(s)',K));
    xlabel('1st principal component');
    ylabel('2nd principal component');
    
    hold off




%% GMM on PCA


% eva = evalclusters(PC_2,'gmdistribution','CalinskiHarabasz','KList',[1:6])
% K=eva.OptimalK;

K=3;
GMModel = fitgmdist(PC_2,K);

%% PLot GMM over PCA



figure


    h1 = scatter(PC_2(:,1),PC_2(:,2),'.g');
    h = gca;
    hold on
    fcontour(@(x1,x2)pdf(GMModel,[x1 x2]),...
        [h.XLim h.YLim])
    title(sprintf('GM Model - %i Component(s)',K));
    xlabel('1st principal component');
    ylabel('2nd principal component');
    
    hold off
%% Display All bands K means


figure(7)
subplot(4,3,1);
plot(X_vec(ix_class_k==1,1),X_vec(ix_class_k==1,2),'r.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==2,1),X_vec(ix_class_k==2,2),'b.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==3,1),X_vec(ix_class_k==3,2),'g.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==4,1),X_vec(ix_class_k==4,2),'y.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==5,1),X_vec(ix_class_k==5,2),'m.','MarkerSize',12)

plot(C_k(:,1),C_k(:,2),'kx',...
     'MarkerSize',15,'LineWidth',3)
legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Cluster 5','Centroids')
title 'Cluster Assignments and Centroids B12'
hold off

subplot(4,3,2);
plot(X_vec(ix_class_k==1,1),X_vec(ix_class_k==1,3),'r.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==2,1),X_vec(ix_class_k==2,3),'b.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==3,1),X_vec(ix_class_k==3,3),'g.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==4,1),X_vec(ix_class_k==4,3),'y.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==5,1),X_vec(ix_class_k==5,3),'m.','MarkerSize',12)

plot(C_k(:,1),C_k(:,2),'kx',...
     'MarkerSize',15,'LineWidth',3)
legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Cluster 5','Centroids')
title 'Cluster Assignments and Centroids B13'
hold off

subplot(4,3,3);
plot(X_vec(ix_class_k==1,1),X_vec(ix_class_k==1,4),'r.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==2,1),X_vec(ix_class_k==2,4),'b.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==3,1),X_vec(ix_class_k==3,4),'g.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==4,1),X_vec(ix_class_k==4,4),'y.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==5,1),X_vec(ix_class_k==5,4),'m.','MarkerSize',12)

plot(C_k(:,1),C_k(:,2),'kx',...
     'MarkerSize',15,'LineWidth',3)
legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Cluster 5','Centroids')
title 'Cluster Assignments and Centroids B14'
hold off


subplot(4,3,4);
plot(X_vec(ix_class_k==1,2),X_vec(ix_class_k==1,1),'r.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==2,2),X_vec(ix_class_k==2,1),'b.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==3,2),X_vec(ix_class_k==3,1),'g.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==4,2),X_vec(ix_class_k==4,1),'y.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==5,2),X_vec(ix_class_k==5,1),'m.','MarkerSize',12)

plot(C_k(:,1),C_k(:,2),'kx',...
     'MarkerSize',15,'LineWidth',3)
legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Cluster 5','Centroids')
title 'Cluster Assignments and Centroids B21'
hold off

subplot(4,3,5);
plot(X_vec(ix_class_k==1,2),X_vec(ix_class_k==1,3),'r.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==2,2),X_vec(ix_class_k==2,3),'b.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==3,2),X_vec(ix_class_k==3,3),'g.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==4,2),X_vec(ix_class_k==4,3),'y.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==5,2),X_vec(ix_class_k==5,3),'m.','MarkerSize',12)

plot(C_k(:,1),C_k(:,2),'kx',...
     'MarkerSize',15,'LineWidth',3)
legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Cluster 5','Centroids')
title 'Cluster Assignments and Centroids B23'
hold off

subplot(4,3,6);
plot(X_vec(ix_class_k==1,2),X_vec(ix_class_k==1,4),'r.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==2,2),X_vec(ix_class_k==2,4),'b.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==3,2),X_vec(ix_class_k==3,4),'g.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==4,2),X_vec(ix_class_k==4,4),'y.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==5,2),X_vec(ix_class_k==5,4),'m.','MarkerSize',12)

plot(C_k(:,1),C_k(:,2),'kx',...
     'MarkerSize',15,'LineWidth',3)
legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Cluster 5','Centroids')
title 'Cluster Assignments and Centroids B24'
hold off

subplot(4,3,7);
plot(X_vec(ix_class_k==1,3),X_vec(ix_class_k==1,1),'r.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==2,3),X_vec(ix_class_k==2,1),'b.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==3,3),X_vec(ix_class_k==3,1),'g.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==4,3),X_vec(ix_class_k==4,1),'y.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==5,3),X_vec(ix_class_k==5,1),'m.','MarkerSize',12)

plot(C_k(:,1),C_k(:,2),'kx',...
     'MarkerSize',15,'LineWidth',3)
legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Cluster 5','Centroids')
title 'Cluster Assignments and Centroids B31'
hold off

subplot(4,3,8);
plot(X_vec(ix_class_k==1,3),X_vec(ix_class_k==1,2),'r.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==2,3),X_vec(ix_class_k==2,2),'b.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==3,3),X_vec(ix_class_k==3,2),'g.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==4,3),X_vec(ix_class_k==4,2),'y.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==5,3),X_vec(ix_class_k==5,2),'m.','MarkerSize',12)

plot(C_k(:,1),C_k(:,2),'kx',...
     'MarkerSize',15,'LineWidth',3)
legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Cluster 5','Centroids')
title 'Cluster Assignments and Centroids B32'
hold off

subplot(4,3,9);
plot(X_vec(ix_class_k==1,3),X_vec(ix_class_k==1,4),'r.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==2,3),X_vec(ix_class_k==2,4),'b.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==3,3),X_vec(ix_class_k==3,4),'g.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==4,3),X_vec(ix_class_k==4,4),'y.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==5,3),X_vec(ix_class_k==5,4),'m.','MarkerSize',12)

plot(C_k(:,1),C_k(:,2),'kx',...
     'MarkerSize',15,'LineWidth',3)
legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Cluster 5','Centroids')
title 'Cluster Assignments and Centroids B34'
hold off


subplot(4,3,10);
plot(X_vec(ix_class_k==1,4),X_vec(ix_class_k==1,1),'r.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==2,4),X_vec(ix_class_k==2,1),'b.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==3,4),X_vec(ix_class_k==3,1),'g.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==4,4),X_vec(ix_class_k==4,1),'y.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==5,4),X_vec(ix_class_k==5,1),'m.','MarkerSize',12)

plot(C_k(:,1),C_k(:,2),'kx',...
     'MarkerSize',15,'LineWidth',3)
legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Cluster 5','Centroids')
title 'Cluster Assignments and Centroids B41'
hold off


subplot(4,3,11);
plot(X_vec(ix_class_k==1,4),X_vec(ix_class_k==1,2),'r.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==2,4),X_vec(ix_class_k==2,2),'b.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==3,4),X_vec(ix_class_k==3,2),'g.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==4,4),X_vec(ix_class_k==4,2),'y.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==5,4),X_vec(ix_class_k==5,2),'m.','MarkerSize',12)

plot(C_k(:,1),C_k(:,2),'kx',...
     'MarkerSize',15,'LineWidth',3)
legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Cluster 5','Centroids')
title 'Cluster Assignments and Centroids B42'
hold off

subplot(4,3,12);
plot(X_vec(ix_class_k==1,4),X_vec(ix_class_k==1,3),'r.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==2,4),X_vec(ix_class_k==2,3),'b.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==3,4),X_vec(ix_class_k==3,3),'g.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==4,4),X_vec(ix_class_k==4,3),'y.','MarkerSize',12)
hold on
plot(X_vec(ix_class_k==5,4),X_vec(ix_class_k==5,3),'m.','MarkerSize',12)

plot(C_k(:,1),C_k(:,2),'kx',...
     'MarkerSize',15,'LineWidth',3)
legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Cluster 5','Centroids')
title 'Cluster Assignments and Centroids B43'
hold off