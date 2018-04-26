%% ���
clc; clear all;
%% ����ѵ���Ĳ���
R = 140; C = 80;
CellSize = [10, 10]; BlockSize = [2, 2]; NumBins = 9;
NP = 2000; NN = 12000;
sR = 100; sC = 150;
%% ����������
file_dir = '../../../ref_papers/inria/INRIAPerson/96X160H96/Train/pos';
[pos_sample, ~, pos_hog_feature] = get_samples(file_dir, NP, R, C, CellSize, BlockSize, NumBins, 0, 0);
%% ���ظ�����
file_dir = '../../../ref_papers/inria/INRIAPerson/Train/neg';
[neg_sample, ~, neg_hog_feature] = get_samples(file_dir, NN, R, C, CellSize, BlockSize, NumBins, sR, sC);
%% ��ʾ�����������
fprintf(1, 'sample loaded...\n');
%% �ָ�����
train_ratio = 0.7; 
rand_perm_pos = randperm(NP);
rand_perm_neg = randperm(NN);
train_data = [pos_hog_feature(:, rand_perm_pos(1:floor(NP*train_ratio))), neg_hog_feature(:, rand_perm_neg(1:floor(NN*train_ratio)))];
train_label = [ones(1, floor(NP*train_ratio)), zeros(1, floor(NN*train_ratio))];
test_data = [pos_hog_feature(:, rand_perm_pos(floor(NP*train_ratio)+1 : NP)), neg_hog_feature(:, rand_perm_neg(floor(NN*train_ratio)+1 : NN))];
test_label = [ones(1, floor(NP - NP*train_ratio)), zeros(1, floor(NN - NN*train_ratio))];
%% ʹ��SVMѵ��
% BoostingNum = 1;
% SVMModel = run_boosting_svm_training(train_data, train_label, BoostingNum);
SVMModel = fitcsvm(train_data', train_label', 'KernelFunction','linear');
%% ��ʾѵ�����
fprintf(1, 'training completed...\n');
% ����SVM�Ĳ���
save('../mat_files/SVMModel.mat', 'SVMModel');
% ����mif�ļ�
svm2mif('../mat_files/SVMModel.mif', SVMModel, R, C, CellSize, BlockSize, NumBins);
svm2mif('../../hog_svm_fpga/04_scripts/SVMModel.mif', SVMModel, R, C, CellSize, BlockSize, NumBins);
svm2mif('../../DE10_NANO_SoC_GHRD_ip_create/04_scripts/SVMModel.mif', SVMModel, R, C, CellSize, BlockSize, NumBins);
%% Ԥ��
[pred_label, pred_score] = predict(SVMModel, test_data');
pred_label = pred_label';
plotroc(test_label, pred_label);
%% ��ʾ�������
fprintf(1, 'testing completed...\n');
%% Ȼ��Ҫ�������˼��
load('../mat_files/SVMModel.mat');
% file_dir = '../../DE10_NANO_SoC_GHRD/10_cpp_files/image';
file_dir = '../../../ref_papers/inria/INRIAPerson/Test/pos';
% file_dir = '../picture/test_hog_svm';
dR = CellSize(1)*4; dC = CellSize(2)*4; tR = 600; tC = 800;
run_detection(file_dir, SVMModel, 1, R, C, dR, dC, tR, tC, CellSize, BlockSize, NumBins, 1);