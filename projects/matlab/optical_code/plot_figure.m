N = frameCnt;
figure('units','inches');  hold on;
pos = get(gcf,'pos'); 
set(gcf,'pos',[pos(1)-6 pos(2)-3 12 6]);


t = 10;
% View results
% subplot(1,2,1); hold on; title('ԭʼ��Ƶ'); imshow(frame(:, :, t));
% subplot(1,2,2); hold on; title('BGSЧ��'); imshow(total_mask(:, :, t));
% subplot(1,2,2); hold on; title('GMM-BGSЧ��'); imshow(gmm_mask(:, :, t));
% subplot(1,2,2); hold on; title('������-BGSЧ��'); imshow(of_mask(:, :, t));
% subplot(1,2,2); hold on; title('ViBe-BGSЧ��'); imshow(vibe_mask(:, :, t));
% subplot(1,2,2); hold on; title('֡��-BGSЧ��'); imshow(fd_mask(:, :, t));

% weight = [0.3; 0.4; 0.3];
% vibe_fd_mask = uint8(255*round(weight(1)*im2double(gmm_mask) + weight(2)*im2double(vibe_mask) + weight(3)*im2double(fd_mask)));
% subplot(1,2,2); hold on; title('�Ľ���֡��-GMM-ViBeЧ��'); imshow(vibe_fd_mask(:, :, t));
SE = strel('disk',1); 
subplot(1,5,1); hold on; title('ԭʼ��Ƶ'); imshow(frame(:, :, t),'InitialMagnification','fit');
% ����BGS��Ч��
subplot(1,5,2); hold on; title('GMM-BGSЧ��'); imshow(imdilate(gmm_mask(:, :, t), SE),'InitialMagnification','fit');
subplot(1,5,3); hold on; title('ViBe-BGSЧ��'); imshow(imdilate(vibe_mask(:, :, t), SE),'InitialMagnification','fit');
subplot(1,5,4); hold on; title('֡��-BGSЧ��'); imshow(imdilate(fd_mask(:, :, t), SE),'InitialMagnification','fit');
subplot(1,5,5); hold on; title('������-BGSЧ��'); imshow(imdilate(of_mask(:, :, t), SE),'InitialMagnification','fit');
