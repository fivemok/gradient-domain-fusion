function im_blend = poissonBlend(im_s, mask_s, im_background)

[imh, imw, nb] = size(im_s);
im2var = zeros(imh, imw);
im2var(1:imh*imw) = 1:imh*imw;
im_blend = zeros(imh, imw, nb);
A = sparse([], [], []);
b = zeros([], 3);



