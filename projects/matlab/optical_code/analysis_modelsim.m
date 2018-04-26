% clc; clear all;
%% �����·��
file_dir = '../../lk_optical_flow/05_modelsim/';
filename = [file_dir, 'optical_result.txt'];
%% ����������
H = 544; W = 960;
% [optical_flow_ux, optical_flow_vy] = read_usb_data(filename, H, W);
%%
ux = zeros(H, W); vy = zeros(H, W); uv = zeros(H, W);
for frame = 1 : size(optical_flow_ux, 3)
    ux = double(optical_flow_ux(: ,:, frame));
    vy = double(optical_flow_vy(: ,:, frame));
    flow_mine = opticalFlow(flipud(ux)/1024, flipud(vy)/1024);  % Ϊ�˱��ڹ۲죬����1024��
    uv = sqrt(ux.^2 + vy.^2);
    uv(find(uv>200)) = 255; uv(find(uv<=200)) = 0;
    % Ȼ����Ҫ��������
    M = 5; filter = 1/(M^2)*ones(M, M); uv_filt = conv2(uv, filter, 'same');
    uv_filt(find(uv_filt>50)) = 255; uv_filt(find(uv_filt<=50)) = 0;
    % ����ͼ
    subplot(1,3,1); plot(flow_mine);
    subplot(1,3,2); image(uint8(uv));
    subplot(1,3,3); image(uint8(uv_filt));
end