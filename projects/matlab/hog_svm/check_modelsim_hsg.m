% ����HSG������ȡ����ȷ��
% ���ݲ�ͬ��H/W�趨��ִ�в�ͬ���������
%% ����ͼ��
file_dir = '../../hog_svm_fpga/05_modelsim/';
filename = [file_dir, 'yuv_result.txt'];
H = 150; W = 200;
fp = fopen(filename, 'r');
x = zeros(H*W, 1);
for n=1:H*W
    num_str = fgetl(fp);
    if(size(str2num(num_str), 1)>0)
        x(n, 1) = str2num(num_str);
    end
end
fclose(fp);
%%
x = imresize(reshape(x', [W, H])', [H, W]);
img_y = uint8(x);
R = 140; C = 80;
CellSize = [10, 10]; BlockSize = [2, 2]; NumBins = 9;

%% ��������λ�õĴ��ڵ�HSG����
bias_c = 0; bias_r = 1;   % ƫ�����½ǵĴ���
i = H-R+1-bias_r*CellSize(1); j = W-C+1-bias_c*CellSize(2);
detect_img = img_y(i:i+R-1, j:j+C-1);
my_hsg_feature = my_extractHOGFeatures(detect_img, CellSize, BlockSize, BlockSize-1, NumBins);
%% Ȼ����verilog�Ľ��
% ����modelsim�������е�HSG����
fp = fopen('../../hog_svm_fpga/05_modelsim/my_hsg_feature.txt', 'r');
load('../mat_files/SVMModel.mat');
line_num = 0;
while(~feof(fp) && line_num<(H/CellSize(1) * W/CellSize(2))-bias_c-W/CellSize(2)*bias_r)
    str = fgetl(fp);
    line_num = line_num + 1;
end
str = fgetl(fp);
% �ָ��ַ���
str_cut = regexp(str, '[,]', 'split');
svm_res_ver = str2num(str_cut{1,2});
% ����鿴
L = length(str_cut{1,1});
hsg_feature = zeros(4*L, 1);
for l=1:L
    char = str_cut{1,1}(1, l);
    bin = dec2bin(hex2dec(char), 4);
    hsg_feature(4*(l-1)+1, 1) = str2num(bin(1, 1));
    hsg_feature(4*(l-1)+2, 1) = str2num(bin(1, 2));
    hsg_feature(4*(l-1)+3, 1) = str2num(bin(1, 3));
    hsg_feature(4*(l-1)+4, 1) = str2num(bin(1, 4));
end
% Ȼ����svmԤ��
check_value = round(SVMModel.Beta*2^14)'*hsg_feature + round(SVMModel.Bias*2^14);
check_value_fp = ((SVMModel.Beta)'*hsg_feature + (SVMModel.Bias));
% ��ӡ��Ϣ
if(svm_res_ver~=check_value)
    fprintf(1, '[error] verilog:%d, matlab:%d\n', svm_res_ver, check_value);  
%         else
%             fprintf(1, 'right!.\n');
end
if(check_value_fp>0)
    fprintf(1, '[float] verilog:%d, matlab:%d @<%d, %d>\n', svm_res_ver, check_value_fp, ceil(line_num/20)*10-140, mod(line_num, 20)*10-80);  
end
fclose(fp);
% ���ݱȶ�
error = (hsg_feature~=my_hsg_feature);
mean(error)