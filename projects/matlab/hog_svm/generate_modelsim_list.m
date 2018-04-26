%% ��������modelsim�����õ�ͼƬlist�ļ�
file_dir = '../../../ref_papers/inria/INRIAPerson/Test/pos'; % ͼƬ���ڵ��ļ���
%% ��ȡ�ļ��б�
file_list = dir(file_dir);
file_list = file_list(3:size(file_list, 1));
file_list = file_list(randperm(size(file_list, 1)));
%% ����ͼ���ļ�
img = imread([file_dir, '/', file_list(1, 1).name]);
img = imresize(img, [600, 800]); % ת��ͼ��ߴ�
fp = fopen('../picture/source_rgb565.list', 'w');
% Ȼ��д�뵽�ļ���
img = double(img);
fp = fopen('../picture/source_rgb565.list', 'w');
fprintf(fp, '@%X\n', 0);
source = floor(floor(img(:,:,1)/8)*2^11 + floor(img(:,:,2)/4)*2^5 + floor(img(:,:,3)/8));
for i=1:size(source, 1)
    for j=1:size(source, 2)
        fprintf(fp, '%04X\n', source(i,j));
    end
end