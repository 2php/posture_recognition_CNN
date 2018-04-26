%% ����
clc; clear all;
figure;
R = 5; C = 2;
%% ������ADDָ��
modelsim = load('../05_modelsim/cnn_result-add.txt');
python = load('../07_python/fp_add_test.txt');
error = modelsim - python;
error_abs = abs(error);
error_ratio = abs(error./python);
subplot(R, C, 1); hold on;
title('add inst');
plot(error_ratio, 'o');
[~,idx]=max(error_ratio);
%% ������ADDiָ��
modelsim = load('../05_modelsim/cnn_result-addi.txt');
python = load('../07_python/fp_addi_test.txt');
error = modelsim - python;
error_abs = abs(error);
error_ratio = abs(error./python);
subplot(R, C, 2); hold on;
title('addi inst');
plot(error_ratio, 'o');
[~,idx]=max(error_ratio);
%% ������tanhָ��
modelsim = load('../05_modelsim/cnn_result-tanh.txt');
python = load('../07_python/fp_tanh_test.txt');
error = modelsim - python;
error_abs = abs(error);
error_ratio = abs(error./python);
subplot(R, C, 3); hold on;
title('tanh inst');
plot(error_ratio, 'o');
[~,idx]=max(error_ratio);
%% ������dotָ��
modelsim = load('../05_modelsim/cnn_result-dot.txt');
python = load('../07_python/fp_dot_test.txt');
error = modelsim - python;
error_abs = abs(error);
error_ratio = abs(error./python);
subplot(R, C, 4); hold on;
title('dot inst');
plot(error_ratio, 'o');
[~,idx]=max(error_ratio);
%% ������convָ��
modelsim = load('../05_modelsim/cnn_result-conv.txt');
python = load('../07_python/fp_conv_test.txt');
error = modelsim - python;
error_abs = abs(error);
error_ratio = abs(error./python);
subplot(R, C, 5); hold on;
title('conv inst');
plot(error_ratio, 'o');
[~,idx]=max(error_ratio);
%% ������poolָ��
modelsim = load('../05_modelsim/cnn_result-pool.txt');
python = load('../07_python/fp_pool_test.txt');
error = modelsim - python;
error_abs = abs(error);
error_ratio = abs(error./python);
subplot(R, C, 6); hold on;
title('pool inst');
plot(error_ratio, 'o');
[~,idx]=max(error_ratio);
%% ������multָ��
modelsim = load('../05_modelsim/cnn_result-mult.txt');
python = load('../07_python/fp_mult_test.txt');
error = modelsim - python;
error_abs = abs(error);
error_ratio = abs(error./python);
subplot(R, C, 7); hold on;
title('mult inst');
plot(error_ratio, 'o');
[~,idx]=max(error_ratio);
%% ������tranָ��
modelsim = load('../05_modelsim/cnn_result-tran.txt');
python = load('../07_python/fp_tran_test.txt');
error = modelsim - python;
error_abs = abs(error);
error_ratio = abs(error./python);
subplot(R, C, 8); hold on;
title('tran inst');
plot(error_ratio, 'o');
[~,idx]=max(error_ratio);
%% ������grayָ��
modelsim = load('../05_modelsim/cnn_result-gray.txt');
python = load('../07_python/fp_gray_test.txt');
modelsim = modelsim / 2^16;
error = modelsim - python;
error_abs = abs(error);
error_ratio = abs(error./python);
subplot(R, C, 9); hold on;
title('gray inst');
plot(error_ratio, 'o');
[~,idx]=max(error_ratio);
%% ������ADDsָ��
modelsim = load('../05_modelsim/cnn_result-adds.txt');
python = load('../07_python/fp_adds_test.txt');
error = modelsim - python;
error_abs = abs(error);
error_ratio = abs(error./python);
subplot(R, C, 10); hold on;
title('adds inst');
plot(error_ratio, 'o');
[~,idx]=max(error_ratio);