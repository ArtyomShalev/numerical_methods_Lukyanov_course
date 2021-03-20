function [] = pyramid_square_base(l, w, h, x_pos, y_pos, z_pos, Ke2, Ek2)

for i=0:h
    EzKe(x_pos+i:x_pos+l-i, y_pos+i:y_pos+w-i, z_pos+i) = Ke2;
    ExKe(x_pos+i:x_pos+l-i, y_pos+i:y_pos+w-i, z_pos+i) = Ke2;
    EyKe(x_pos+i:x_pos+l-i, y_pos+i:y_pos+w-i, z_pos+i) = Ke2;
    
    EzEk(x_pos+i:x_pos+l-i, y_pos+i:y_pos+w-i, z_pos+i) = Ek2;
    ExEk(x_pos+i:x_pos+l-i, y_pos+i:y_pos+w-i, z_pos+i) = Ek2;
    EyEk(x_pos+i:x_pos+l-i, y_pos+i:y_pos+w-i, z_pos+i) = Ek2;
end