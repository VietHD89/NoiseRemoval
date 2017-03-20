function F = median(I,w)
s=size(I);
for i=floor(w/2)+1:s(1)-floor(w/2)
    for j=floor(w/2)+1:s(2)-floor(w/2)
        for k=1:w
            for l=1:w
                vect(w*(k-1)+l)=I(i-floor(k/2)+2,j-floor(l/2)+2);
            end
        end
        B=sort(vect);
        I(i,j)=B(floor(size(B,2)/2)+1);
    end
end

figure;
imshow(I);
