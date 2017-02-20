function [ PC, P, L ] = pca_function( X_cc )
%PCA_FUNCTION Summary of this function goes here
%   Detailed explanation goes here
S=cov(X_cc);
% [P,L]=eigs(S,size(S,1));
[P,L]=eig(S);
[L,I] = sort(diag(L),'descend');
L=diag(L);
P=P(:,I);
PC=X_cc*P;

end

