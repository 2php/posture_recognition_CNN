% clc; clear all;
%% �����·��
file_dir = '../../hog_svm_fpga/05_modelsim/';
filename = [file_dir, 'yuv_result.txt'];
%% ����������
H = 600; W = 800;
x = load(filename);
%% ����
x = x(1:H*W);
x = reshape(x', [W, H])';
imshow(uint8(x));