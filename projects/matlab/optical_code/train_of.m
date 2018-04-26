function [frame, frameCnt, hfg_mask] = train_of(filename, NoiseThreshold)
	%% Ȼ���ȡ��Ƶ
	hsrc = vision.VideoFileReader(filename, ...
									'ImageColorSpace', 'RGB', ...
									'VideoOutputDataType', 'uint8');
    %% ������
     opticFlow = opticalFlowLK('NoiseThreshold',NoiseThreshold);
	%% ��������Ƶ����Ĳ���
	frameCnt = 1;
	while ~isDone(hsrc)
		% Read frame
        curr = step(hsrc);         % ԭʼ֡?
        frame(:, :, frameCnt) = curr(:, :, 1);
        % 
        if frameCnt>1
            frame_2=im2double(frame(:, :, frameCnt));
            flow = estimateFlow(opticFlow,frame_2);
            opFlow = sqrt(flow.Vx.^2 + flow.Vy.^2);
            hfg_mask(:, :, frameCnt) = uint8(floor(opFlow/max(opFlow(:))*255));
        end
        prev = curr;
        % �ݽ�
        frameCnt = frameCnt + 1;
	end
	frameCnt = frameCnt-1;
	
	%% ɾ������
	release(hsrc);

end