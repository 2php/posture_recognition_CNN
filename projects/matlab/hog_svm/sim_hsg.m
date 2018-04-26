%% ���ط��������
A = imread('test.png');
img = imresize(A, [600, 800]);% ת�ɻҶ�ͼ

%% ����ѵ���Ĳ���
R = 150; C = 70;
CellSize = [10, 10]; BlockSize = [2, 2]; NumBins = 9;
NP = 2000; NN = 2000;
sR = 100; sC = 60;
dR = CellSize(1); dC = CellSize(2);
%% ת�ɻҶ�ͼ
img_y = uint8(0.257*img(:, :, 1) + 0.504*img(:, :, 2) + 0.098*img(:, :, 3) + 16);
figure; hold on; imshow(img_y); 
%% ������HSG������ӡ���ļ���ȥ
fp = fopen('hsg_feature.txt', 'w');
%% ��������
for i=1:dR:size(img_y, 1)-R+1
    for j=1:dC:size(img_y, 2)-C+1
        detect_img = img_y(i:i+R-1, j:j+C-1);
        hog_feature(:,1) = extractHOGFeatures(detect_img, 'CellSize', CellSize, 'BlockSize', BlockSize, 'BlockOverlap', BlockSize-1, 'NumBins', NumBins);
        % �ĳ�HSG
        for t=1:floor(size(hog_feature, 1)/NumBins)
            hog_feature(NumBins*(t-1)+1:NumBins*t, 1) = sign(hog_feature(NumBins*(t-1)+1:NumBins*t, 1)-sum(hog_feature(NumBins*(t-1)+1:NumBins*t), 1)/(2^floor(log2(NumBins)))) / 2 + 1/2;
        end
        % �Լ���
        my_hsg_feature = my_extractHOGFeatures(detect_img, CellSize, BlockSize, BlockSize-1, NumBins);
        % ������ı��ļ���
        for t=1:4:size(my_hsg_feature, 1)
            fprintf(fp, '%01X', uint8(my_hsg_feature(t)*8+my_hsg_feature(t+1)*4+my_hsg_feature(t+2)*2+my_hsg_feature(t+3)*1));
        end
        % SVM Ԥ��
%                     [pred_label, pred_score] = predict(SVMModel, hog_feature');
%         [pred_label, pred_score] = predict(SVMModel, my_hsg_feature');
%         % �����⵽���ˣ���Ҫ���
%         if(pred_label==1 && pred_score(1)<0)
%             rectangle('Position', [j, i, C, R], 'EdgeColor','r', 'LineWidth',3);
%             % Ȼ�����score
%             text(j, i, [num2str(j), ',', num2str(i), ',', num2str(pred_score(1))]);
%         end
    end
end
%%
fclose(fp);