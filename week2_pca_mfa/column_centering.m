function [ X_cc ] = column_centering( X )
%COLUMN_CENTERING Summary of this function goes here
%   Detailed explanation goes here
m=mean(X);
[n,p]=size(X);

X_cc=X-repmat(m,n,1);
end

