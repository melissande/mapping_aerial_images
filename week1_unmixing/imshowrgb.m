function imshowrgb(img, rgb, varargin)

%
% imshowrgb(img, rgb, nstd, magn)
%
% img   - 3-D (or 2-D) matrix
% rgb   - order of bands shown as R, G and B, e.g. [4 -2 1] (or one band);
%         optional, defaults to [1 2 3]
%         if <0: negate band
% nstd  - strech between mean -/+ nstd stddevs of image bands;
%         optional, defaults to 2
% magn  - magnification in %

% (c) Copyright 2008-2013
% Allan Aasbjerg Nielsen
% aa@space.dtu.dk, www.imm.dtu.dk/~aa
% 11 Mar 2011

if nargin < 1, error('imshowrgb: wrong input specification'), end
% if ndims(img)~=3, error('imshowrgb: input image must be 3-D'); end

nstd = 2;
magn = 100;
if nargin == 1, rgb = [1 2 3]; end
if nargin > 2, nstd = varargin{1}; end
if nargin > 3, magn = varargin{2}; end
[nr nc nf] = size(img);
sizergb = size(rgb,2);
if nf == 1
    sizergb = 1;
end
if sizergb == 1 % only one band specified
    sgn = sign(rgb);
    img = img(:, :, abs(rgb));
    img = cast(reshape(img, nc*nr, 1), 'single');
    img = img-repmat(mean(img), nr*nc, 1);
    stdvar = std(img);
    img = reshape(img, nr, nc);
    %stds = sqrt(1/2997); stdvar = [stds stds stds];
    r = sgn(1)*img/(2*nstd*stdvar)+0.5; r(r<0)=0; r(r>1)=1;
    imshow(r, 'InitialMagnification', magn)
elseif sizergb == 3 % 3-band image
    sgn = sign(rgb);
    img = img(:, :, abs(rgb));
    nf = 3;
    img = cast(reshape(img, nc*nr, nf), 'single');
    img = img-repmat(mean(img), nr*nc, 1);
    stdvar = std(img);
    img = reshape(img, nr, nc, nf);
    % stds = sqrt(1/2997); stdvar = [stds stds stds];
    r = sgn(1)*img(:,:,1)/(2*nstd*stdvar(1))+0.5; r(r<0)=0; r(r>1)=1;
    g = sgn(2)*img(:,:,2)/(2*nstd*stdvar(2))+0.5; g(g<0)=0; g(g>1)=1;
    b = sgn(3)*img(:,:,3)/(2*nstd*stdvar(3))+0.5; b(b<0)=0; b(b>1)=1;
    imshow(cat(3,r,g,b), 'InitialMagnification', magn)
else
    error('wrong specification of rgb');
end
