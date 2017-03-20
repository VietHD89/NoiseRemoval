function F = gaussian(I) 
s=size(I);
F_G=[1,2,1;2,4,2;1,2,1];%sum of coefficient=16
F=double(zeros(s(1),s(2)));
for i=2:s(1)-1
    for j=2:s(2)-1
        for k=1:3
            for l=1:3
                F(i,j)=F(i,j)+double(I(i+k-2,j+l-2)*F_G(k,l));
            end;
        end;
        F(i,j)=round(F(i,j)/(16));
    end;
end;
F=uint8(F);
figure;
imshow(F)