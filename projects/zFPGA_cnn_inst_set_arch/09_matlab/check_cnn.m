%%
figure;
x = load('../05_modelsim/cnn-result-sp-204-label-1.txt');
y = load('../../python/NvDeCNN_TF/ver_compare/sp-204-label-1.txt');
error = abs(x-y)/2^16;
error_out = abs(x(size(x,1)-6+1:size(x,1))-y(size(y,1)-6+1:size(y,1)))/2^16;
subplot(2,1,1); plot(error); hold on; title('ÿһ���������ͳ��'); xlabel('�������'); ylabel('�������');
subplot(2,1,2); plot(error_out); hold on; title('����������ͳ��'); xlabel('���Ԫ���±�'); ylabel('�������');
%%
figure;
x = load('../05_modelsim/cnn-result-sp-205-label-2.txt');
y = load('../../python/NvDeCNN_TF/ver_compare/sp-205-label-2.txt');
error = abs(x-y)/2^16;
error_out = abs(x(size(x,1)-6+1:size(x,1))-y(size(y,1)-6+1:size(y,1)))/2^16;
subplot(2,1,1); plot(error); hold on; title('ÿһ���������ͳ��'); xlabel('�������'); ylabel('�������');
subplot(2,1,2); plot(error_out); hold on; title('����������ͳ��'); xlabel('���Ԫ���±�'); ylabel('�������');
%%
figure;
x = load('../05_modelsim/cnn-result-sp-208-label-4.txt');
y = load('../../python/NvDeCNN_TF/ver_compare/sp-208-label-4.txt');
error = abs(x-y)/2^16;
error_out = abs(x(size(x,1)-6+1:size(x,1))-y(size(y,1)-6+1:size(y,1)))/2^16;
subplot(2,1,1); plot(error); hold on; title('ÿһ���������ͳ��'); xlabel('�������'); ylabel('�������');
subplot(2,1,2); plot(error_out); hold on; title('����������ͳ��'); xlabel('���Ԫ���±�'); ylabel('�������');
%%
figure;
x = load('../05_modelsim/cnn-result-data_under_test.txt');
y = load('../../python/NvDeCNN_TF/ver_compare/data_under_test.tb.list');
error = abs(x-y)/2^16;
error_out = abs(x(size(x,1)-6+1:size(x,1))-y(size(y,1)-6+1:size(y,1)))/2^16;
subplot(2,1,1); plot(error); hold on; title('ÿһ���������ͳ��'); xlabel('�������'); ylabel('�������');
subplot(2,1,2); plot(error_out); hold on; title('����������ͳ��'); xlabel('���Ԫ���±�'); ylabel('�������');
