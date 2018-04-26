function [mask, frameCnt, u, v] = my_optical_flow(filename)
    %% Ȼ���ȡ��Ƶ
	hsrc = vision.VideoFileReader(filename, ...
									'ImageColorSpace', 'RGB', ...
									'VideoOutputDataType', 'uint8');
    
    %% ������
     opticFlow = opticalFlowLK('NoiseThreshold',1e-2);
    %% ��������Ƶ����Ĳ���
	frameCnt = 1;
    prev = double(step(hsrc));  % �ȶ�ȡһ֡
    prev = 0.257*prev(:, :, 1) + 0.504*prev(:, :, 2) + 0.098*prev(:, :, 3) + 16;
    threshold = 0;
    figure; 
	while ~isDone(hsrc)
		% Read frame
        curr = double(step(hsrc));         % ԭʼ֡?
		% RGB --> YUV
		curr = 0.257*curr(:, :, 1) + 0.504*curr(:, :, 2) + 0.098*curr(:, :, 3) + 16;
        % Ȼ�����Ix, Iy, It
        Ix = conv2(curr, [1, -1], 'full'); 
        Ix = Ix(:, 1:size(curr, 2));
        Iy = conv2(curr, [1, -1]', 'full'); 
        Iy = Iy(1:size(curr, 1), :);
        It = curr - prev;
        prev = curr;    % ����
        Ixx = Ix.^2;
        Iyy = Iy.^2;
        Ixy = Ix.*Iy;
        Ixt = Ix.*It;
        Iyt = Iy.*It;
        % Ȼ�������ͷϷ��
        u(:, :, frameCnt) = zeros(size(curr));
        v(:, :, frameCnt) = zeros(size(curr));
        % 5x5
        Width_Half = 2;
        for i=1+Width_Half:size(curr,1)-Width_Half
            for j=1+Width_Half:size(curr,2)-Width_Half
                Lambda = [sum(sum(Ixx(i-Width_Half:i+Width_Half, j-Width_Half:j+Width_Half))), sum(sum(Ixy(i-Width_Half:i+Width_Half, j-Width_Half:j+Width_Half)));...
                            sum(sum(Ixy(i-Width_Half:i+Width_Half, j-Width_Half:j+Width_Half))), sum(sum(Iyy(i-Width_Half:i+Width_Half, j-Width_Half:j+Width_Half)))];
                Gamma = -[sum(sum(Ixt(i-Width_Half:i+Width_Half, j-Width_Half:j+Width_Half))), sum(sum(Iyt(i-Width_Half:i+Width_Half, j-Width_Half:j+Width_Half)))]';
                Alpha = (Lambda + 1e-2*eye(2))^-1*Gamma;
                u(i, j, frameCnt) = Alpha(1);
                v(i, j, frameCnt) = Alpha(2);
            end
        end
        flow_matlab = estimateFlow(opticFlow,curr);
        flow_mine = opticalFlow(u(:, :, frameCnt), v(:, :, frameCnt));
        uv = sqrt(u(:, :, frameCnt).^2 + v(:, :, frameCnt).^2); 
        uv_filt = zeros(size(uv));
        uv_filt(find(uv>threshold)) = 255; % ����ģ
        mask(:, :, frameCnt) = uv_filt; % ���mask��Ĥ
        threshold = 6*mean(uv(:)); % ������ֵ
        skelton = bwmorph(bwmorph(uv_filt,'skel',Inf), 'spur'); % ��ȡ�Ǽ�
        if(size(find(uv_filt==255), 1)>0)
            [pts_row, pts_col] = find(uv_filt==255);  
            pts_weight_center = mean([pts_col, pts_row]);   % ��ȡ���е�LK�������㣬����������λ��
        end
        [hog_feature, hog_visual] = extractHOGFeatures(uint8((curr)), 'CellSize', [16, 16], 'BlockSize', [2, 2]);
%         subplot(2,3,1); imshow(uint8((curr)));
%         subplot(2,3,2); imshow(uint8(uv_filt)); hold on; plot(pts_weight_center(1), pts_weight_center(2), 'ro');
%         subplot(2,3,3); plot(hog_visual);
        % LK��������ϸ��
%         subplot(2,3,4); xlim([0,960]); ylim([0, 544]); plot((flow_matlab));
%         subplot(2,3,5); xlim([0,960]); ylim([0, 544]); plot((flow_mine));
     end
end