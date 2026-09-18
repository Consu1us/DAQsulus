% define variables

function matlabTest(materials, ks, Ls, T_in, T_outs)
    % materials = {'Concrete', 'Fiberglass', 'Brick'};
    % ks = {1.7, 0.04, 0.72}; % W/m*k
    % Ls = {0.2, 0.15, 0.35}; % m


    % T_in = 21; % C
    % T_outs = {-5, 25}; % Winter, Summer

    if ~iscell(ks), ks = num2cell(ks); end
    if ~iscell(Ls), Ls = num2cell(Ls); end
    if ~iscell(T_outs), T_outs = num2cell(T_outs); end
   
    seasons = {"Winter", "Summer"};


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
end
