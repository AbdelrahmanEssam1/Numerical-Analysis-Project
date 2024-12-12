function newton_raphson_gui
    % Main function to run the Newton-Raphson GUI
    fig = figure('Name', 'Newton-Raphson Method', 'NumberTitle', 'off', ...
                 'Position', [200, 200, 600, 450], 'Color', [0.9, 0.9, 0.9]);

    % Welcome header with adjusted spacing and color
    uicontrol(fig, 'Style', 'text', 'Position', [100, 380, 400, 40], ...
              'String', 'Welcome', 'FontSize', 14, ...
              'FontWeight', 'bold', 'ForegroundColor', 'black', ...
              'BackgroundColor', [0.9, 0.9, 0.9], 'HorizontalAlignment', 'center');

    % Adjusted input section to leave more space after the Welcome header
    % Equation input
    uicontrol('Style', 'text', 'Position', [100, 320, 120, 30], ...
              'String', 'Equation f(r):', 'FontSize', 10, 'HorizontalAlignment', 'center', ...
              'BackgroundColor', [0.8, 0.8, 0.8]);
    eqnInput = uicontrol(fig, 'Style', 'edit', 'Position', [230, 320, 250, 30]);

    % First row: G and M inputs
    uicontrol(fig, 'Style', 'text', 'Position', [50, 280, 100, 30], ...
              'String', 'G:(m^3/kg/s^2):', 'FontSize', 10, 'HorizontalAlignment', 'center', ...
              'BackgroundColor', [0.8, 0.8, 0.8]);
    gInput = uicontrol(fig, 'Style', 'edit', 'Position', [160, 280, 100, 30], 'String', '6.67430e-11');

    uicontrol(fig, 'Style', 'text', 'Position', [320, 280, 100, 30], ...
              'String', 'M:(kg)', 'FontSize', 10, 'HorizontalAlignment', 'center', ...
              'BackgroundColor', [0.8, 0.8, 0.8]);
    mInput = uicontrol(fig, 'Style', 'edit', 'Position', [430, 280, 100, 30], 'String', '1.989e30');

    % Second row: C and J inputs
    uicontrol(fig, 'Style', 'text', 'Position', [50, 240, 100, 30], ...
              'String', 'C:(m/s)', 'FontSize', 10, 'HorizontalAlignment', 'center', ...
              'BackgroundColor', [0.8, 0.8, 0.8]);
    cInput = uicontrol(fig, 'Style', 'edit', 'Position', [160, 240, 100, 30], 'String', '3e8');

    uicontrol(fig, 'Style', 'text', 'Position', [320, 240, 100, 30], ...
              'String', 'J:(kg·m^2 or J)', 'FontSize', 10, 'HorizontalAlignment', 'center', ...
              'BackgroundColor', [0.8, 0.8, 0.8]);
    jInput = uicontrol(fig, 'Style', 'edit', 'Position', [430, 240, 100, 30], 'String', '1e43');

    % Third row: Initial Guess and Tolerance
    uicontrol(fig, 'Style', 'text', 'Position', [50, 200, 100, 30], ...
              'String', 'Initial Guess:', 'FontSize', 10, 'HorizontalAlignment', 'center', ...
              'BackgroundColor', [0.8, 0.8, 0.8]);
    guessInput = uicontrol(fig, 'Style', 'edit', 'Position', [160, 200, 100, 30], 'String', '1');

    uicontrol(fig, 'Style', 'text', 'Position', [320, 200, 100, 30], ...
              'String', 'Tolerance:', 'FontSize', 10, 'HorizontalAlignment', 'center', ...
              'BackgroundColor', [0.8, 0.8, 0.8]);
    tolInput = uicontrol(fig, 'Style', 'edit', 'Position', [430, 200, 100, 30], 'String', '1e-6');

    % Fourth row: Max Iterations
    uicontrol(fig, 'Style', 'text', 'Position', [50, 160, 150, 30], ...
              'String', 'Max Iterations:', 'FontSize', 10, 'HorizontalAlignment', 'center', ...
              'BackgroundColor', [0.8, 0.8, 0.8]);
    maxIterInput = uicontrol(fig, 'Style', 'edit', 'Position', [210, 160, 100, 30], 'String', '100');

    % Run button centered at the bottom
    uicontrol(fig, 'Style', 'pushbutton', 'Position', [250, 80, 100, 40], ...
              'String', 'Run', 'FontSize', 12, ...
              'BackgroundColor', [0.7, 0.7, 0.7], ...
              'Callback', @(~, ~) run_newton_raphson(eqnInput, gInput, mInput, cInput, jInput, guessInput, tolInput, maxIterInput));
end



function run_newton_raphson(eqnInput, gInput, mInput, cInput, jInput, guessInput, tolInput, maxIterInput)
  % Extract user inputs
  eqn_str = get(eqnInput, 'String');
  G_str = get(gInput, 'String');
  M_str = get(mInput, 'String');
  C_str = get(cInput, 'String');
  J_str = get(jInput, 'String');
  r0_str = get(guessInput, 'String');
  tol_str = get(tolInput, 'String');
  max_iter_str = get(maxIterInput, 'String');

  % Validate inputs
  if isempty(eqn_str)
      msgbox('Please enter a function before running the calculation.', 'Input Required', 'error');
      return;
  end
  if isempty(G_str) || isnan(str2double(G_str))
      msgbox('Please enter a valid numeric value for G.', 'Input Required', 'error');
      return;
  end
  if isempty(M_str) || isnan(str2double(M_str))
      msgbox('Please enter a valid numeric value for M.', 'Input Required', 'error');
      return;
  end
  if isempty(C_str) || isnan(str2double(C_str))
      msgbox('Please enter a valid numeric value for C.', 'Input Required', 'error');
      return;
  end
  if isempty(J_str) || isnan(str2double(J_str))
      msgbox('Please enter a valid numeric value for J.', 'Input Required', 'error');
      return;
  end
  if isempty(r0_str) || isnan(str2double(r0_str))
      msgbox('Please enter a valid numeric value for the Initial Guess.', 'Input Required', 'error');
      return;
  end
  if isempty(tol_str) || isnan(str2double(tol_str))
      msgbox('Please enter a valid numeric value for Tolerance.', 'Input Required', 'error');
      return;
  end
  if isempty(max_iter_str) || isnan(str2double(max_iter_str))
      msgbox('Please enter a valid numeric value for Max Iterations.', 'Input Required', 'error');
      return;
  end

  % Convert validated inputs
  G = vpa(G_str);
  M = vpa(M_str);
  C = vpa(C_str);
  J = vpa(J_str);
  r0 = str2double(r0_str);
  tol = str2double(tol_str);
  max_iter = str2double(max_iter_str);

  % Check if C is zero and show an error if it is
  if C == 0
      msgbox('C cannot be zero. Division by zero is not allowed.', 'Exception', 'error');
      return;
  end

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
    msgbox('Did not converge within the maximum number of iterations.', 'Warning', 'warn');
  else
    msgbox(sprintf('Root: %.6f\nFinal Error: %.6f%%', r0, error), 'Result');
  end

  % Plotting
  figure('Name', 'Newton-Raphson Results', 'NumberTitle', 'off', 'Color', 'w'); % White background for better contrast
  scale_factor = 1e11;
  scaled_r_values = r_values / scale_factor;
  % Root vs Iterations
  subplot(3, 1, 1);
  plot(1:iter, scaled_r_values, '-o', 'Color', [0.2, 0.6, 0.8], 'LineWidth', 2, 'MarkerFaceColor', [0.1, 0.4, 0.6]); % Teal blue
  title('Root vs Iterations', 'FontWeight', 'bold');
  xlabel('Iteration', 'FontWeight', 'bold');
  ylabel(['Root (×10^{', num2str(log10(scale_factor)), '})'], 'FontWeight', 'bold');
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

  % Create Error History Window
  errorFig = figure('Name', 'Newton-Raphson Error History', 'NumberTitle', 'off', ...
      'Position', [1200, 200, 400, 400], 'Color', [0.9, 0.9, 0.9]);

  % Create a uitable to display iteration and error values
  columnNames = {'Iteration', 'Error %'};
  data = [(1:iter)' errors']; % Combine iteration numbers and error percentages
  uitable('Parent', errorFig, 'Data', data, ...
      'ColumnName', columnNames, ...
      'Position', [20, 20, 360, 360], ...
      'FontSize', 10, ...
      'ColumnWidth', {80, 260}); % Adjust column width

  % Create Root History Window
  rootHistoryFig = figure('Name', 'Newton-Raphson Root History', 'NumberTitle', 'off', ...
      'Position', [1200, 600, 400, 400], 'Color', [0.9, 0.9, 0.9]);

  % Create a uitable to display iteration and root values
  columnNames = {'Iteration', 'Root Value'};
  data = [(1:iter)', r_values']; % Combine iteration numbers and root values
  uitable('Parent', rootHistoryFig, 'Data', data, ...
      'ColumnName', columnNames, ...
      'Position', [20, 20, 360, 360], ...
      'FontSize', 10, ...
      'ColumnWidth', {80, 260}); % Adjust column widths

end
