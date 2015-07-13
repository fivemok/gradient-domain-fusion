function im_out = toyReconstruct(toyim)

[imh, imw, nb] = size(toyim);
im2var = zeros(imh, imw);
im2var(1:imh*imw) = 1:imh*imw;

A = sparse([], [], []);
b = [];
e = 1;
% objective 1: min (v(x+1,y)-v(x,y)-(s(x+1,y)-x(x,y)))^2
for y = 1:imh
    for x = 1:imw-1
        A(e, im2var(y,x+1)) = 1;
        A(e, im2var(y,x)) = -1;
        b(e) = toyim(y,x+1) - toyim(y,x);
        e = e + 1;
    end
end
% objective 2: min (v(x,y+1)-v(x,y)-(s(x,y+1)-x(x,y)))^2
for y = 1:imh-1
    for x = 1:imw
        A(e, im2var(y+1,x)) = 1;
        A(e, im2var(y,x)) = -1;
        b(e) = toyim(y+1,x) - toyim(y,x);
        e = e + 1;
    end
end
% objective 3: min (v(1,1)-s(1,1))^2
A(e, im2var(1,1)) = 1;
b(e) = toyim(1,1);

b = b.'; % transpose
v = A\b;

im_out = zeros(imh, imw);
im_out(1:imh*imw) = v(1:imh*imw);
