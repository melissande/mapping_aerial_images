function [image,p,t] = freadenvit(fname,varargin);

% freadenvit - read ENVI image (V. Guissard, Apr 29, 2004)
%
% 				Reads an image of ENVI standard type 
%				to a [lines x samples x bands] MATLAB array
% and transposes all bands (Allan A. Nielsen)
%
% Syntax
%
% image = freadenvit(fname);
% [image,p] = freadenvit(fname);
% [image,p,t] = freadenvit(fname);
%
% INPUT :
%
% fname	string	giving the full pathname of the ENVI image to read
%
% OUTPUT :
%
% image	lines by samples by bands array containing the ENVI image values organised in
%				(lines x samples) x bands.
% p		1 by 3	vector that contains (1) the number of samples, (2) the
%       number of liness and (3) the number of bands of the opened image.
%
% t		string	describing the image data type in MATLAB convention.
%
% NOTE : freadenvi needs the corresponding image header file generated
%		 automatically by ENVI. The ENVI header file must have the same name
%		 as the ENVI image file + the '.hdr' extension.

% Modified for reading BSQ, BIL and BIP
% col index before row index
% little and big endian
% by
% Allan Aasbjerg Nielsen
% aa@imm.dtu.dk
% Dec 2008 - Mar 2013

endian = 'l'; % little endian: 'l' (typically on PC systems)
if nargin>1
    endian = 'b'; % big endian: 'b' (typically on UNIX systems)
end

% Parameters initialization
elements = {'samples ' 'lines   ' 'bands   ' 'data type ' 'interleave '};
%     1       2       3       4         5         12       13       14      15
d = {'uint8' 'int16' 'int32' 'float32' 'float64' 'uint16' 'uint32' 'int64' 'uint64'};
%d = {'*uint8' 'int16' 'int32' 'float32' 'float64' 'uint16' 'uint32' 'int64' 'uint64'};
% Check user input
if ~ischar(fname)
    error('fname should be a char string');
end

% Open ENVI header file to retreive s, l, b & d variables
rfid = fopen(strcat(fname,'.hdr'),'r');

% Check if the header file is correctely opened
if rfid == -1
    error('Input header file does not exist');
end;

% Read ENVI image header file and get p(1) : nb samples,
% p(2) : nb lines, p(3) : nb bands and t : data type
while 1
    tline = fgetl(rfid);
    if ~ischar(tline), break, end
    [first,second] = strtok(tline,'=');
    
    switch first
        case elements(1)
            [f,s] = strtok(second);
            p(1) = str2num(s);
        case elements(2)
            [f,s] = strtok(second);
            p(2) = str2num(s);
        case elements(3)
            [f,s] = strtok(second);
            p(3) = str2num(s);
        case elements(4)
            [f,s] = strtok(second);
            t = str2num(s);
            switch t
                case 1
                    t = d(1);
                case 2
                    t = d(2);
                case 3
                    t = d(3);
                case 4
                    t = d(4);
                case 5
                    t = d(5);
                case 12
                    t = d(6);
                case 13
                    t = d(7);
                case 14
                    t = d(8);
                case 15
                    t = d(9);
                otherwise
                    error('Unknown image data type');
            end
        case elements(5)
            [f,interleave] = strtok(second);
%             if ~strcmp(interleave,' bsq')
%                 error('''interleave'' in .hdr file  must be '' bsq''')
%             end
    end
end
fclose(rfid); 

t = t{1,1};
disp(['Input is (', num2str(p(2)),' lines) x (', ...
    num2str(p(1)),' samples) x (', num2str(p(3)), ' bands) ' ...
    t, interleave, (' image ...')]);
% Open the ENVI image and store it in the 'image' MATLAB array
fid = fopen(fname,'r',endian);
if fid==-1
    warning(strcat(fname,' not found'));
    fid = fopen(strcat(fname,'.img'),'r',endian);
    if fid==-1
        error(strcat(fname,' not found'));
    end
end
[image,count] = fread(fid,t);
fclose(fid);
if count~=(p(2)*p(1)*p(3))
    error('data in fname do not match nrows, ncols, nbands');
end
if strcmp(interleave,' bsq')
    image = reshape(image,[p(1),p(2),p(3)]);
    image = permute(image, [2 1 3]);
elseif strcmp(interleave,' bil')
    image = reshape(image,[p(1),p(3),p(2)]);
    image = permute(image, [3 1 2]);
elseif strcmp(interleave,' bip')
    image = reshape(image,[p(3),p(1),p(2)]);
    image = permute(image, [3 2 1]);
else
    error('wrong specification of ''interleave''');
end
