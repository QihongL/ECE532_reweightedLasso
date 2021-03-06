clear all; close all; clc
%% simulate beta difference as a function of sparsity and noise level 
% pre-set some parameters that I want to try
NOISE_LEVEL = 0:0.2:2;
PROP_USEFUL_VOX = 0.05:0.05:1;

out = cell(numel(PROP_USEFUL_VOX),numel(NOISE_LEVEL));
% check difference between raw lasso vs. normalized lasso
for i = 1 : numel(PROP_USEFUL_VOX)
    for j = 1: numel(NOISE_LEVEL)
        out{i,j} = simNormVsRaw_u(PROP_USEFUL_VOX(i), NOISE_LEVEL(j));
    end
end

%% build the beta difference matrix 
diff.raw_norm = nan(numel(PROP_USEFUL_VOX),numel(NOISE_LEVEL));
betaDev.raw = nan(numel(PROP_USEFUL_VOX),numel(NOISE_LEVEL));
betaDev.norm = nan(numel(PROP_USEFUL_VOX),numel(NOISE_LEVEL));
yDev.raw = nan(numel(PROP_USEFUL_VOX),numel(NOISE_LEVEL));
yDev.norm = nan(numel(PROP_USEFUL_VOX),numel(NOISE_LEVEL));
for i = 1 : numel(PROP_USEFUL_VOX)
    for j = 1: numel(NOISE_LEVEL)
        diff.raw_norm(i,j) = norm(out{i,j}.beta.raw - out{i,j}.beta.normal,2);
        betaDev.raw(i,j) = out{i,j}.betaDevation.raw;
        betaDev.norm(i,j) = out{i,j}.betaDevation.norm;
        yDev.raw(i,j) = out{i,j}.yDevation.raw;
        yDev.norm(i,j) = out{i,j}.yDevation.norm;
    end
end

%% plot the heat map 
colormap jet
subplot(2,3,1)
imagesc(diff.raw_norm)
colorbar 
xlabel('Increasing noise magnitude', 'fontsize', 16)
ylabel('Increasing percent of nnz features', 'fontsize', 16)
title('beta diff: raw vs. normalized', 'fontsize', 16)
% conclusion: 
% when there are more nz beta, estimation difference increases  

subplot(2,3,2)
imagesc(betaDev.raw)
colorbar 
xlabel('Increasing noise magnitude', 'fontsize', 16)
title('beta dev from truth - raw', 'fontsize', 16)

subplot(2,3,3)
imagesc(betaDev.norm)
colorbar 
xlabel('Increasing noise magnitude', 'fontsize', 16)
title('beta dev from truth - normalized', 'fontsize', 16)

subplot(2,3,5)
imagesc(yDev.raw)
colorbar 
ylabel('Increasing percent of nnz features', 'fontsize', 16)
xlabel('Increasing noise magnitude', 'fontsize', 16)
title('y dev from truth - raw', 'fontsize', 16)

subplot(2,3,6)
imagesc(yDev.raw)
colorbar 
xlabel('Increasing noise magnitude', 'fontsize', 16)
title('y dev from truth - normalized', 'fontsize', 16)