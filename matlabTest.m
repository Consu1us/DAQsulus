% define variables
materials = {'Concrete', 'Fiberglass', 'Brick'};
ks = {1.7, 0.04, 0.72}; % W/m*k
Ls = {0.2, 0.15, 0.35}; % m


T_in = 21; % C
T_outs = {-5, 25}; % Winter, Summer

seasons = {"Winter", "Summer"};

% part 1A
figure('Name', "Seasonal Temperature Distributions");

for i = 1:2
    T_out = T_outs{i};
    season = seasons{i};

    for j = 1:3
        mat = materials{j};
        k = ks{j};
        L = Ls{j};
        x = linspace(0, L, 100);
        T_x = T_in - (T_in - T_out) * (x/L);

        subplot(2,3,(i-1)*3 + j);
        plot(x, T_x);
        title(sprintf("%s - %s", season, mat));
        xlabel("Position within wall (m)");
        ylabel("Temperature (C)");
        grid on;
    end


end

% 1B

% Which material has the steepest line?

% Fiberglass has the steepest line.

% Explain why this material is visually steeper than the others

% The slope of the temperature distribution depends solely on
% T_in, T_out, and L. Specifically, it depends on T_in - T_out
% which is the same for all three materials.
% Since fiberglass is the thinnest material, the
% temperature drops over a shorter distance which results in a steeper
% slope.

% Write the algebraic equation that describes the slope of these lines

% Slope = -(T_in - T_out) / L

% 2A

figure("Name", "Heat Flux vs Outside Temperature");
hold on;
line1 = animatedline('Color', 'r', 'DisplayName', materials{1});
line2 = animatedline('Color', 'g', 'DisplayName', materials{2});
line3 = animatedline('Color', 'b', 'DisplayName', materials{3});

yline(0, '--k', 'q'''' = 0', "HandleVisibility","off");

xlabel("Outside Temperature T_{out} (C)");
ylabel("Heat Flux q'' (W/m^2)");
legend();
grid on;

T_range = -20:1:40;

for T_out = T_range
    q_conc = ks{1} * (T_in - T_out) / Ls{1};
    addpoints(line1, T_out, q_conc);

    q_fiber = ks{2} * (T_in - T_out) / Ls{2};
    addpoints(line2, T_out, q_fiber);

    q_brick = ks{3} * (T_in - T_out) / Ls{3};
    addpoints(line3, T_out, q_brick);

    drawnow;
    pause(0.05);
end

% 2B

% From a thermal standpoint, which material is more advantageous and why?

% Fiberglass is more advantageous since it has the lowest slope and
% therefore the smallest heat flux per outdoor temperature change

% Write the algebraic equation that describes the slope of these lines
% Slope = -k/L

% What is the physical significance of the moment in your animation when the heat flux
% q'' = 0?

% This is the moment the system reaches thermal equilibrium, when T_out =
% T_in. At this moment, no heat is flowing since there is no temperature
% difference.