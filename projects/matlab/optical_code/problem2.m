clc; clear all;
%% �����·��
file_dir = '../video/';
% filename = [file_dir, 'weizmann/run/daria_run.avi'];
filename = [file_dir, 'smardorn/input.avi'];
%% Ȼ��ѵ��������
[frame, frameCnt, u, v] = my_optical_flow(filename);
%% ������ֵ�Ķ����255
of_mask(find(of_mask>mean(of_mask(of_mask>0)))) = 255;
%% ����
total_mask = of_mask;
%% ��BGS�Ľ��������
SE = strel('disk',3); 
% ���浽avi�ļ�
obj_gray = VideoWriter([filename, '.avi']);   %��ת���ɵ���Ƶ����
open(obj_gray);
for t=1:frameCnt
    [m, n] = size(total_mask(:, :, t)); L = 1;
    % �ٸ���˲�
    H=fspecial('gaussian', 5, 5);
    total_mask(:, :, t) = imfilter(total_mask(:, :, t),H,'replicate');  
    % ����
    total_mask_exp(:, :, t) = imdilate(total_mask(:, :, t), SE);
    writeVideo(obj_gray, total_mask_exp(:, :, t));
end
close(obj_gray);
%% ѵ�����
disp('training complete!');
%% ����
N = frameCnt;
figure('units','inches');  hold on;
pos = get(gcf,'pos'); 
set(gcf,'pos',[pos(1)-6 pos(2)-3 12 6]);
for frameCnt=1:N
	% View results
	subplot(1,2,1); hold on; title('ԭʼ��Ƶ'); imshow(frame(:, :, frameCnt),'InitialMagnification','fit');
	subplot(1,2,2); hold on; title('������Ч��'); imshow(of_mask(:, :, frameCnt),'InitialMagnification','fit');
    pause(0.1);
end


