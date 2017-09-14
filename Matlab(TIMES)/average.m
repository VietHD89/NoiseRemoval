function F=average(I)
s=size(I);
F_size=7;
F=double(zeros(s(1),s(2)));
for i=floor(F_size/2)+1:s(1)- floor(F_size/2)
    for j=floor(F_size/2)+1:s(2)- floor(F_size/2)
        for k=1:F_size
            for l=1:F_size
                F(i,j)=F(i,j)+double(I(i+k-(floor(F_size/2)+1),j+l-(floor(F_size/2)+1)));
            end;
        end;
        F(i,j)=round(F(i,j)/(F_size*F_size));
    end;
end;
F=uint8(F);
figure;
imshow(F);
%subplot(2,1,1);
%f=fft2(F);
%f=fftshift(f);
%subplot(2,1,2);imshow(log(f),[]);