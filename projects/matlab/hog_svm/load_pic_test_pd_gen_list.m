% Ȼ��Ҫ�������˼��
% �������ͼ��Ȼ�����HOG+SVM
% ����Ҫ����ͼ���list�ļ�
R = 140; C = 80;
CellSize = [10, 10]; BlockSize = [2, 2]; NumBins = 9;
load('../mat_files/SVMModel.mat');
% file_dir = '../../DE10_NANO_SoC_GHRD/10_cpp_files/image';
file_dir = '../../../ref_papers/inria/INRIAPerson/Test/pos';
% file_dir = '../picture/test_hog_svm';
dR = CellSize(1)*4; dC = CellSize(2)*4; tR = 600; tC = 800;
run_detection(file_dir, SVMModel, 1, R, C, dR, dC, tR, tC, CellSize, BlockSize, NumBins, 1);