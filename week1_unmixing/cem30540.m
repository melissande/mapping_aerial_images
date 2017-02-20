fid = fopen('avirisBand','r');
X0 = fread(fid,'uint8');
fclose(fid);

nrows = 180;
ncols = 360;
nvars =  30;
%% Section 2

X0 = reshape(X0, ncols, nrows, nvars);

% for ii=1:nvars
%     X(:, :, ii) = X0(:, :, ii)';
% end
% or
X = permute(X0, [2 1 3]);
%% Section 3
clear X0

X = reshape(X, ncols*nrows, nvars);
X = X - repmat(mean(X), ncols*nrows, 1);
S = cov(X);
iS = inv(S);

figure(200)
X = reshape(X, nrows, ncols, nvars);
imshowrgb(X, [30 15 1])


% run code below for each desired spectrum
figure(200), [x y] = ginput(1);

%What are the colors? infrared



% desired spectrum 
% idx = (round(x-1))*nrows + round(y);
% d = X(idx, :)';
X = reshape(X, nrows, ncols, nvars);
d = squeeze(X(round(y), round(x), :));
X = reshape(X, ncols*nrows, nvars);

w = iS*d;
w = w/(d'*w);
abundance = reshape(X*w, nrows, ncols);
[yhi xhi] = hist(abundance(:), 100);
figure
bar(xhi, yhi);
title('Histogram')
% bar(xhi, log(yhi));
% title('Log of histogram')
figure(201)
imshow(abundance, [0 1])
% mean(abundance), var(abundance), abundance(idx)
mean(abundance(:)), var(abundance(:)), abundance(round(y), round(x))
