function MSE = myMSE(distImg, origImg)

    origImg = double(origImg);
    distImg = double(distImg);

    [M N] = size(origImg);
    error = (origImg - distImg).^2;
    MSE = mean2(error) / (M * N);

   

end