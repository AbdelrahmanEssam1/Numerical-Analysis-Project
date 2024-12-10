function newton_raphson_gui
  % Main function to run the Newton-Raphson GUI
  fig = figure('Name', 'Newton-Raphson Method', 'NumberTitle', 'off', 'Position', [200, 200, 600, 400]);

  % Input fields
  uicontrol(fig, 'Style', 'text', 'Position', [50, 340, 100, 20], 'String', 'Equation (f(r)):');
  eqnInput = uicontrol(fig, 'Style', 'edit', 'Position', [150, 340, 300, 25]);

  uicontrol(fig, 'Style', 'text', 'Position', [50, 300, 100, 20], 'String', 'G:');
  gInput = uicontrol(fig, 'Style', 'edit', 'Position', [150, 300, 100, 25], 'String', '6.67430e-11');

  uicontrol(fig, 'Style', 'text', 'Position', [270, 300, 100, 20], 'String', 'M:');
  mInput = uicontrol(fig, 'Style', 'edit', 'Position', [350, 300, 100, 25], 'String', '1.989e30');

  uicontrol(fig, 'Style', 'text', 'Position', [50, 260, 100, 20], 'String', 'C:');
  cInput = uicontrol(fig, 'Style', 'edit', 'Position', [150, 260, 100, 25], 'String', '3e8');

  uicontrol(fig, 'Style', 'text', 'Position', [270, 260, 100, 20], 'String', 'J:');
  jInput = uicontrol(fig, 'Style', 'edit', 'Position', [350, 260, 100, 25], 'String', '1e43');

  uicontrol(fig, 'Style', 'text', 'Position', [50, 220, 100, 20], 'String', 'Initial Guess:');
  guessInput = uicontrol(fig, 'Style', 'edit', 'Position', [150, 220, 100, 25], 'String', '1');

  uicontrol(fig, 'Style', 'text', 'Position', [270, 220, 100, 20], 'String', 'Tolerance:');
  tolInput = uicontrol(fig, 'Style', 'edit', 'Position', [350, 220, 100, 25], 'String', '1e-6');

  uicontrol(fig, 'Style', 'text', 'Position', [50, 180, 150, 20], 'String', 'Max Iterations:');
  maxIterInput = uicontrol(fig, 'Style', 'edit', 'Position', [200, 180, 100, 25], 'String', '100');

  % Run button
  uicontrol(fig, 'Style', 'pushbutton', 'Position', [250, 120, 100, 40], 'String', 'Run', ...
            'Callback', @(~,~) run_newton_raphson(eqnInput, gInput, mInput, cInput, jInput, guessInput, tolInput, maxIterInput));
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
    msgbox('Did not converge within the maximum number of iterations.', 'Warning', 'warn');
  else
    msgbox(sprintf('Root: %.6f\nFinal Error: %.6f%%', r0, error), 'Result');
  end

  % Plotting
  figure('Name', 'Newton-Raphson Results');
  subplot(3, 1, 1);
  plot(1:iter, r_values, '-o');
  title('Root vs Iterations');
  xlabel('Iteration');
  ylabel('Root');

  subplot(3, 1, 2);
  semilogy(1:iter, abs(double(subs(f, r, r_values))), '-o'); % Corrected convergence plot
  title('Newton-Raphson Convergence');
  xlabel('Iteration');
  ylabel('|f(r)|');

  subplot(3, 1, 3);
  plot(1:iter, errors, '-o');
  title('Error % vs Iterations');
  xlabel('Iteration');
  ylabel('Error %');
end



