clc;
clear all;

file = '../News.mp4';
folder = 'keyframe';
video = VideoReader(file);
total = video.NumberOfFrames
frames = read(video, [1 Inf]);

% Calculate dct coefficient
dcts = zeros(total, 16, 16);
for i = 1:total
    freq = dct2(imresize(rgb2gray(frames(:,:,:,i)), [64, 64]));
    dcts(i,:,:) = freq(1:16, 1:16);
end

% Calculate dct difference between two frames 
differences = zeros(total - 1, 1);
for i = 1:total-1
    temp = imabsdiff(squeeze(dcts(i,:,:)), squeeze(dcts(i+1,:,:)));
    differences(i) = sum(temp(:));
end

% Calculate mean and standard deviation
meanValue = mean(differences)
stdValue = std(differences)
threshold = meanValue + stdValue*3

% Check folder exist
if ~exist(folder, 'dir')
	mkdir(folder);
end

% First frame is always keyframe
imwrite(frames(:,:,:,1), sprintf('%s/frame_%05d.jpg', folder, 0));

% Greater than threshold select as a key frame
for i = 1:total-1
    if (differences(i) > threshold)
        imwrite(frames(:,:,:,i+1), sprintf('%s/frame_%05d.jpg', folder, i));
    end 
end 
   