%%
D_MIN = 2;

%%
x1 = 0:0.01:2;
x2 = 2:0.01:5;

%%
y1 = exp( -2*(x1-D_MIN) ) - 1;
y2 = zeros(size(x2));

% plot
figure; plot(x1, y1, 'b'); 
hold on; plot(x2, y2, 'b');
grid on;

%% 
y1 = ones(size(x1));
y2 = zeros(size(x2));

% plot
figure; plot(x1, y1, 'b'); 
hold on; plot(x2, y2, 'b');
grid on;


%% 
close all; clear all; clc;
D_MIN = 2;
X_MAX = 5;
NND = 0:0.01:X_MAX;

fit_repel = zeros(size(NND));
for idx =  1:length(NND)
    % collision avoidance function
    if NND(idx) <= D_MIN
        fit_repel(idx) = exp( -2*( NND(idx)-D_MIN ) );
    else 
        fit_repel(idx) = 1;
    end
    % END if NND(idx) <= D_MIN
end
% END for idx =  1:size(NND)

figure; plot(NND, fit_repel);grid on;
xlabel('NND'); ylabel('f_{repel} = e^{-2\cdot(NND - D_{min})}');