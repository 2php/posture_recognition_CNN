% ���modelsim����SVM�ķ��������û������
% ���ִ���һ����������/���㣩
fp = fopen('../../hog_svm_fpga/05_modelsim/my_hsg_feature-400x300.txt', 'r');
load('../mat_files/SVMModel.mat');
line_num = 0;
while(~feof(fp))
    str = fgetl(fp);
    line_num = line_num + 1;
    % �ָ��ַ���
    str_cut = regexp(str, '[,]', 'split');
    % ����ѭ��
    if(size(str_cut, 2)~=2)
        break;
    end
    % �ж��ǲ��ǿ������������ַ���
    if(size(str2num(str_cut{1,2}), 1)==0)
        continue;
    else
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
            fprintf(1, '[float] verilog:%d, matlab:%d @<row:%d, col:%d>\n', svm_res_ver, check_value_fp, ceil(line_num/20)*10-140, mod(line_num, 20)*10-80);  
        end
    end
end

fclose(fp);

%% Ȼ�󻹿��Ժ�matlab��ȡ����HSG������һ�±Ƚ�
A = imread('test.png');
H = 150; W = 200;
img = imresize(A, [H, W]);% ת�ɻҶ�ͼ
img_y = uint8(66.0*double(img(:, :, 1))/256 + 129.0*double(img(:, :, 2))/256 + 25.0*double(img(:, :, 3))/256 + 16);
imshow(img_y); hold on; axis on; xlabel('column'); ylabel('row'); title('my matlab cell hog');
%% ��modelsim�����������ĻҶ�ͼ
file_dir = '../../hog_svm_fpga/05_modelsim/';
filename = [file_dir, 'yuv_result.txt'];
H = 150; W = 200;
x = load(filename);
x = x(1:H*W);
x = reshape(x', [W, H])';
img_y = uint8(x);
%% Ȼ�����м��
CellSize = [10, 10]; BlockSize = [2, 2]; NumBins = 9;
[hog_feature, visual] = extractHOGFeatures(img_y, 'CellSize', CellSize, 'BlockSize', BlockSize, 'BlockOverlap', BlockSize-1, 'NumBins', NumBins);
my_hsg_feature = my_extractHOGFeatures(img_y, CellSize, BlockSize, BlockSize-1, NumBins);
% �ĳ�HSG
hog_feature = hog_feature';
for t=1:floor(size(hog_feature, 1)/NumBins)
    hog_feature(NumBins*(t-1)+1:NumBins*t, 1) = sign(hog_feature(NumBins*(t-1)+1:NumBins*t, 1)-sum(hog_feature(NumBins*(t-1)+1:NumBins*t), 1)/(2^floor(log2(NumBins)))) / 2 + 1/2;
end
figure;  title('matlab cell hog');
imshow(img_y); hold on; plot(visual);
% Ȼ��������
R = 140; C = 80;
CellSize = [10, 10]; BlockSize = [2, 2]; NumBins = 9;
dR = CellSize(1); dC = CellSize(2);
% ��������
for i=1:dR:size(img_y, 1)-R+1
    for j=1:dC:size(img_y, 2)-C+1
        detect_img = img_y(i:i+R-1, j:j+C-1);
        hog_feature = extractHOGFeatures(detect_img, 'CellSize', CellSize, 'BlockSize', BlockSize, 'BlockOverlap', BlockSize-1, 'NumBins', NumBins);
        % �ĳ�HSG
        for t=1:floor(size(hog_feature, 1)/NumBins)
            hog_feature(NumBins*(t-1)+1:NumBins*t) = sign(hog_feature(NumBins*(t-1)+1:NumBins*t)-sum(hog_feature(NumBins*(t-1)+1:NumBins*t))/(2^floor(log2(NumBins)))) / 2 + 1/2;
        end
        % �Լ���
        my_hsg_feature = my_extractHOGFeatures(detect_img, CellSize, BlockSize, BlockSize-1, NumBins);
        % SVM Ԥ��
%         [pred_label, pred_score] = predict(SVMModel, hog_feature);
        [pred_label, pred_score] = predict(SVMModel, my_hsg_feature');
        % �����⵽���ˣ���Ҫ���
        if(pred_label==1 && pred_score(1)<-1)
            rectangle('Position', [j, i, C, R], 'EdgeColor','r', 'LineWidth',3);
            % Ȼ�����score
            text(j, i, [num2str(j), ',', num2str(i), ',', num2str(pred_score(1))]);
        end
    end
end