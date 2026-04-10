%% Washing Machine Fuzzy Logic Controller
% Simple code jo directly MATLAB Online mein chalega

clear all;
close all;
clc;

disp('=== WASHING MACHINE FUZZY CONTROLLER ===');
disp(' ');

% Step 1: Fuzzy System Create Karo
fis = mamfis('Name', 'WashingMachine');

% Step 2: Input Variable 1 - Dirt Level (Gandagi)
fis = addInput(fis, [0 100], 'Name', 'Dirt_Level');
fis = addMF(fis, 'Dirt_Level', 'trimf', [0 0 50], 'Name', 'Low');
fis = addMF(fis, 'Dirt_Level', 'trimf', [25 50 75], 'Name', 'Medium');
fis = addMF(fis, 'Dirt_Level', 'trimf', [50 100 100], 'Name', 'High');

% Step 3: Input Variable 2 - Load Size (Kapde ka load)
fis = addInput(fis, [0 100], 'Name', 'Load_Size');
fis = addMF(fis, 'Load_Size', 'trimf', [0 0 50], 'Name', 'Small');
fis = addMF(fis, 'Load_Size', 'trimf', [25 50 75], 'Name', 'Medium');
fis = addMF(fis, 'Load_Size', 'trimf', [50 100 100], 'Name', 'Large');

% Step 4: Output Variable - Wash Time (Minutes mein)
fis = addOutput(fis, [0 60], 'Name', 'Wash_Time');
fis = addMF(fis, 'Wash_Time', 'trimf', [0 0 20], 'Name', 'Short');
fis = addMF(fis, 'Wash_Time', 'trimf', [15 30 45], 'Name', 'Medium');
fis = addMF(fis, 'Wash_Time', 'trimf', [40 60 60], 'Name', 'Long');

% Step 5: Fuzzy Rules (Total 6 rules as required)
% Rule 1: Low dirt + Small load = Short time
rule1 = "if Dirt_Level is Low and Load_Size is Small then Wash_Time is Short";

% Rule 2: Low dirt + Medium load = Medium time
rule2 = "if Dirt_Level is Low and Load_Size is Medium then Wash_Time is Medium";

% Rule 3: Medium dirt + Small load = Medium time
rule3 = "if Dirt_Level is Medium and Load_Size is Small then Wash_Time is Medium";

% Rule 4: Medium dirt + Medium load = Medium time
rule4 = "if Dirt_Level is Medium and Load_Size is Medium then Wash_Time is Medium";

% Rule 5: High dirt + Medium load = Long time
rule5 = "if Dirt_Level is High and Load_Size is Medium then Wash_Time is Long";

% Rule 6: High dirt + Large load = Long time
rule6 = "if Dirt_Level is High and Load_Size is Large then Wash_Time is Long";

% Saare rules add karo
fis = addRule(fis, [rule1 rule2 rule3 rule4 rule5 rule6]);

disp('✅ Fuzzy system created successfully!');
disp(['📊 Total Rules: ' num2str(length(fis.Rules))]);

% Step 6: Membership Functions ke Graphs
figure('Name', 'Membership Functions', 'Position', [100 100 1000 800]);

subplot(2,2,1);
plotmf(fis, 'input', 1);
title('Dirt Level (Gandagi)', 'FontSize', 12);
xlabel('Dirt Level (%)');
ylabel('Membership Degree');
legend({'Low', 'Medium', 'High'}, 'Location', 'best');
grid on;

subplot(2,2,2);
plotmf(fis, 'input', 2);
title('Load Size (Kapde ka Load)', 'FontSize', 12);
xlabel('Load Size (%)');
ylabel('Membership Degree');
legend({'Small', 'Medium', 'Large'}, 'Location', 'best');
grid on;

subplot(2,2,3);
plotmf(fis, 'output', 1);
title('Wash Time (Minutes)', 'FontSize', 12);
xlabel('Wash Time (minutes)');
ylabel('Membership Degree');
legend({'Short', 'Medium', 'Long'}, 'Location', 'best');
grid on;

% Step 7: Test Cases - Check karo system sahi kaam kar raha hai ya nahi
disp(' ');
disp('=== TEST RESULTS ===');
disp('----------------------------------------');
disp('| Dirt | Load | Wash Time | Category |');
disp('----------------------------------------');

test_data = [
    10, 10;   % Low dirt, Small load
    20, 50;   % Low dirt, Medium load
    50, 20;   % Medium dirt, Small load
    50, 50;   % Medium dirt, Medium load
    80, 50;   % High dirt, Medium load
    90, 90;   % High dirt, Large load
    70, 70;   % High dirt, Large load
    30, 80;   % Low dirt, Large load
];

results = zeros(8,1);

for i = 1:8
    dirt_val = test_data(i,1);
    load_val = test_data(i,2);
    wash_time = evalfis(fis, [dirt_val, load_val]);
    results(i) = wash_time;
    
    % Category decide karo
    if wash_time < 20
        cat = 'Short';
    elseif wash_time < 40
        cat = 'Medium';
    else
        cat = 'Long';
    end
    
    fprintf('|  %2d  |  %2d  |   %5.1f   |   %s   |\n', dirt_val, load_val, wash_time, cat);
end
disp('----------------------------------------');

% Step 8: Surface Viewer (3D Graph - Assignment mein important hai)
figure('Name', 'Surface Viewer', 'Position', [150 150 800 600]);
[X, Y] = meshgrid(0:5:100, 0:5:100);
Z = zeros(size(X));

for i = 1:size(X,1)
    for j = 1:size(X,2)
        Z(i,j) = evalfis(fis, [X(i,j), Y(i,j)]);
    end
end

surf(X, Y, Z);
xlabel('Dirt Level (%)', 'FontSize', 12);
ylabel('Load Size (%)', 'FontSize', 12);
zlabel('Wash Time (minutes)', 'FontSize', 12);
title('Fuzzy Logic Controller - Wash Time Surface', 'FontSize', 14);
colorbar;
colormap('jet');
shading interp;
view(45, 30);
grid on;

% Step 9: Rule Viewer (Manual se bhi dekh sakte ho)
disp(' ');
disp('=== TO SEE RULE VIEWER ===');
disp('Command window mein ye type karo:');
disp('>> ruleview(fis)');
disp(' ');

% Step 10: FIS file save karo (Assignment submission ke liye)
writeFIS(fis, 'washing_machine.fis');
disp('✅ FIS file saved as: washing_machine.fis');

disp(' ');
disp('=== ASSIGNMENT COMPLETE ===');
disp('Ab tu ye kar sakta hai:');
disp('1. Screenshot le lo graphs ke');
disp('2. ruleview(fis) type karke rule viewer screenshot le lo');
disp('3. GitHub pe upload kar do');