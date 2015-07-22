function im_blend = poissonBlend(im_s, mask_s, im_background)
% input
% -----
% im_s : the aligned source image to be blended onto a new image
% mask_s : a binary image specifying the pixels in the new image to be
%         blended
% im_background : the image that im_s will be blended onto
% 
% output
% -----
% im_blend : im_background with im_s blended onto

s = im_s;
t = im_background;
m = mask_s;
[imh, imw, nb] = size(s);
[yy xx] = find(m > 0);
var = sum(sum(m)); % number of variables to be solved
im2var = zeros(imh, imw); % matrix that maps each pixel to a variable number
i = 1;
for j=1:var
    im2var(yy(j),xx(j)) = i;
    i = i + 1;
end
im_blend = im_background; 
A = sparse([], [], []);
b = zeros(var, 3);
e = 1;

% create a linear system of equations; only loop through the pixels in the 
% area of the image to be blended
% note: the sparse matrix A needs only be calculated once for all
%       rgb channels
for j=1:var
    y = yy(j);
    x = xx(j);
    % set up coefficients for A; 4(center)-1(left)-1(right)-1(up)-1(down)
    A(e,im2var(y,x)) = 4;
    if (m(y-1,x) == 1)
        % if pixel is within the mask, take the gradient from the source image
        A(e,im2var(y-1,x)) = -1;
        % can't write b(e,:) = b(e,:) - (s(y-1,x,:) - s(y,x,:)); 
        % unfortunately because of dimension issues 
        for i = 1:3
            b(e,i) = b(e,i) - (s(y-1,x,i) - s(y,x,i));
        end
    else
        % otherwise, directly take the pixel value from the target image
        for i = 1:3
            b(e,i) = b(e,i) + t(y-1,x,i);
        end
    end
    if (m(y+1,x) == 1)
        A(e,im2var(y+1,x)) = -1;
        for i = 1:3
            b(e,i) = b(e,i) - (s(y+1,x,i) - s(y,x,i));
        end
    else
        for i = 1:3
            b(e,i) = b(e,i) + t(y+1,x,i);
        end
    end
    if (m(y,x-1) == 1)
        A(e,im2var(y,x-1)) = -1;
        for i = 1:3
            b(e,i) = b(e,i) - (s(y,x-1,i) - s(y,x,i));
        end
    else
        for i = 1:3
            b(e,i) = b(e,i) + t(y,x-1,i);
        end
    end
    if (m(y,x+1) == 1)
        A(e,im2var(y,x+1)) = -1;
        for i = 1:3
            b(e,i) = b(e,i) - (s(y,x+1,i) - s(y,x,i));
        end
    else
        for i = 1:3
            b(e,i) = b(e,i) + t(y,x+1,i);
        end
    end
    e = e + 1;
end

% solve v for each rgb channel
vr = A\b(:,1);
vg = A\b(:,2);
vb = A\b(:,3);
% clamp negative values
vr(vr < 0) = 0;
vg(vg < 0) = 0;
vb(vb < 0) = 0;

e = 1;
% copy the values over to the target image to the area to be blended
for i=1:var
    y = yy(i);
    x = xx(i);
    im_blend(y,x,1) = vr(e);
    im_blend(y,x,2) = vg(e);
    im_blend(y,x,3) = vb(e);
    e = e + 1;
end
