DO_TOY = false;
DO_BLEND = true;
DO_MIXED  = false;

if DO_TOY 
    toyim = im2double(imread('./images/toy_problem.png')); 
    % im_out should be approximately the same as toyim
    im_out = toyReconstruct(toyim);
    disp(['Error: ' num2str(sqrt(sum((toyim(:)-im_out(:)).^2)))])
end

if DO_BLEND
    % do a small one first, while debugging
    im_background = imresize(im2double(imread('./images/im2.jpg')), 0.25, 'bilinear');
    im_object = imresize(im2double(imread('./images/penguin-chick.jpeg')), 0.25, 'bilinear');

    % get source region mask from the user
    objmask = getMask(im_object);
    % align im_s and mask_s with im_background
    [im_s, mask_s] = alignSource(im_object, objmask, im_background);

    % blend
    im_blend = poissonBlend(im_s, mask_s, im_background);
    figure(3), hold off, imshow(im_blend)
end

if DO_MIXED
    % read images
    %...
    
    % blend
    im_blend = mixedBlend(im_s, mask_s, im_background);
    figure(3), hold off, imshow(im_blend);
end
