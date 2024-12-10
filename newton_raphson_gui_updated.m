function newton_raphson_gui
  % Main function to run the Newton-Raphson GUI
  fig = figure('Name', 'Newton-Raphson Method', 'NumberTitle', 'off', ...
               'Position', [200, 200, 600, 400], 'Color', [0.9, 0.9, 0.9]);

  % Equation input at the top center
  uicontrol('Style', 'text', 'Position', [100, 350, 120, 30], ...
            'String', 'Equation f(r):', 'FontSize', 10, 'HorizontalAlignment', 'center', ...
            'BackgroundColor', [0.8, 0.8, 0.8]);
  eqnInput = uicontrol(fig, 'Style', 'edit', 'Position', [230, 350, 250, 30]);

  % First row: G and M inputs
  uicontrol(fig, 'Style', 'text', 'Position', [50, 300, 105, 30], ...
            'String', 'G (m^3/kg/s^2):', 'FontSize', 10, 'HorizontalAlignment', 'center', ...
            'BackgroundColor', [0.8, 0.8, 0.8]);
  gInput = uicontrol(fig, 'Style', 'edit', 'Position', [160, 300, 100, 30], 'String', '6.67430e-11');

  uicontrol(fig, 'Style', 'text', 'Position', [320, 300, 105, 30], ...
            'String', 'M (kg):', 'FontSize', 10, 'HorizontalAlignment', 'center', ...
            'BackgroundColor', [0.8, 0.8, 0.8]);
  mInput = uicontrol(fig, 'Style', 'edit', 'Position', [430, 300, 100, 30], 'String', '1.989e30');

  % Second row: C and J inputs
  uicontrol(fig, 'Style', 'text', 'Position', [50, 260, 105, 30], ...
            'String', 'C (m/s):', 'FontSize', 10, 'HorizontalAlignment', 'center', ...
            'BackgroundColor', [0.8, 0.8, 0.8]);
  cInput = uicontrol(fig, 'Style', 'edit', 'Position', [160, 260, 100, 30], 'String', '3e8');

  uicontrol(fig, 'Style', 'text', 'Position', [320, 260, 105, 30], ...
            'String', 'J (kg·m^2 or J):', 'FontSize', 10, 'HorizontalAlignment', 'center', ...
            'BackgroundColor', [0.8, 0.8, 0.8]);
  jInput = uicontrol(fig, 'Style', 'edit', 'Position', [430, 260, 100, 30], 'String', '1e43');

  % Third row: Initial Guess and Tolerance
  uicontrol(fig, 'Style', 'text', 'Position', [50, 220, 105, 30], ...
            'String', 'Initial Guess:', 'FontSize', 10, 'HorizontalAlignment', 'center', ...
            'BackgroundColor', [0.8, 0.8, 0.8]);
  guessInput = uicontrol(fig, 'Style', 'edit', 'Position', [160, 220, 100, 30], 'String', '2224.666667');

  uicontrol(fig, 'Style', 'text', 'Position', [320, 220, 105, 30], ...
            'String', 'Tolerance:', 'FontSize', 10, 'HorizontalAlignment', 'center', ...
            'BackgroundColor', [0.8, 0.8, 0.8]);
  tolInput = uicontrol(fig, 'Style', 'edit', 'Position', [430, 220, 100, 30], 'String', '1e-6');

  % Fourth row: Max Iterations
  uicontrol(fig, 'Style', 'text', 'Position', [50, 180, 150, 30], ...
            'String', 'Max Iterations:', 'FontSize', 10, 'HorizontalAlignment', 'center', ...
            'BackgroundColor', [0.8, 0.8, 0.8]);
  maxIterInput = uicontrol(fig, 'Style', 'edit', 'Position', [210, 180, 100, 30], 'String', '100');

  % Run button centered at the bottom
  uicontrol(fig, 'Style', 'pushbutton', 'Position', [250, 100, 100, 40], ...
            'String', 'Run', 'FontSize', 12, ...
            'BackgroundColor', [0.7, 0.7, 0.7], ...
            'Callback', @(~, ~) run_newton_raphson(eqnInput, gInput, mInput, cInput, jInput, guessInput, tolInput, maxIterInput));
end



function run_newton_raphson(eqnInput, gInput, mInput, cInput, jInput, guessInput, tolInput, maxIterInput)

  % Extract user inputs
  eqn_str = get(eqnInput, 'String');

  G = vpa(get(gInput, 'String'));

  M = vpa(get(mInput, 'String'));

  C = vpa(get(cInput, 'String'));

  J = vpa(get(jInput, 'String'));

  r0 = str2double(get(guessInput, 'String'));

  tol = str2double(get(tolInput, 'String'));

  max_iter = str2double(get(maxIterInput, 'String'));

  % Replace constants in the equation
  eqn_str = strrep(eqn_str, 'G', char(G));

  eqn_str = strrep(eqn_str, 'M', char(M));

  eqn_str = strrep(eqn_str, 'C', char(C));

  eqn_str = strrep(eqn_str, 'J', char(J));

  % Convert to symbolic equation
  syms r;

  f = eval(eqn_str);  % f(r)

  df = diff(f, r);    % Derivative f'(r)

  % Newton-Raphson Method
  iter = 0;

  error = Inf;

  r_values = [];

  errors = [];

  while error > tol && iter < max_iter

    iter = iter + 1;

    f_r = double(subs(f, r, r0));

    df_r = double(subs(df, r, r0));

    if df_r == 0

      msgbox('Derivative is zero. Newton-Raphson fails.', 'Error', 'error');

      return;
    end

    r_next = r0 - f_r / df_r;

    error = abs((r_next - r0) / r_next) * 100;

    r_values = [r_values, r_next];

    errors = [errors, error];

    r0 = r_next;
  end

  % Results
  if iter == max_iter && error > tol

    msgbox('Did not reach the tolerance within the maximum number of iterations.', 'Warning', 'warn');

  else

    msgbox(sprintf('Root in meters: %.6f\nFinal Error: %.6f%%', r0, error), 'Result');

  end

  % Plotting
figure('Name', 'Newton-Raphson Results', 'NumberTitle', 'off', 'Color', 'w'); % White background for better contrast

% Root vs Iterations
subplot(3, 1, 1);
plot(1:iter, r_values, '-o', 'Color', [0.2, 0.6, 0.8], 'LineWidth', 2, 'MarkerFaceColor', [0.1, 0.4, 0.6]); % Teal blue
title('Root vs Iterations', 'FontWeight', 'bold');
xlabel('Iteration', 'FontWeight', 'bold');
ylabel('Root', 'FontWeight', 'bold');
grid on;

% Convergence Plot |f(r)|
subplot(3, 1, 2);
semilogy(1:iter, abs(double(subs(f, r, r_values))), '-o', ...
    'Color', [0.5, 0.2, 0.7], 'LineWidth', 2, 'MarkerFaceColor', [0.4, 0.1, 0.6]); % Deep Purple
title('Newton-Raphson Convergence', 'FontWeight', 'bold');
xlabel('Iteration', 'FontWeight', 'bold');
ylabel('|f(r)|', 'FontWeight', 'bold');
grid on;


% Error % vs Iterations
subplot(3, 1, 3);
plot(1:iter, errors, '-o', 'Color', [0.2, 0.8, 0.4], 'LineWidth', 2, 'MarkerFaceColor', [0.1, 0.6, 0.3]); % Soft green
title('Error % vs Iterations', 'FontWeight', 'bold');
xlabel('Iteration', 'FontWeight', 'bold');
ylabel('Error %', 'FontWeight', 'bold');
grid on;

end



