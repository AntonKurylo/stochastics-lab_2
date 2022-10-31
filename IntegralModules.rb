module DirectIntegration

  def func_1_integration(a, x)
    ((a * (x ** 2)) / 2) - ((a * (x ** 3)) / 3)
  end

  def func_2_integration(m, y)
    -(1 / (m * Math.exp(m * y)))
  end

  def func_3_integration(k, z)
    -((Math.cos(Math::PI * k * z)) / (Math::PI * k))
  end

  def direct_integration(bottom_limit, upper_limit, func_param)
    func_1_res = func_1_integration(func_param.dig(:a), upper_limit) - func_1_integration(func_param.dig(:a), bottom_limit)
    func_2_res = func_2_integration(func_param.dig(:m), upper_limit) - func_2_integration(func_param.dig(:m), bottom_limit)
    func_3_res = func_3_integration(func_param.dig(:k), upper_limit) - func_3_integration(func_param.dig(:k), bottom_limit)

    puts "\n\nfunc_1_res #{func_1_res}"
    puts "func_2_res #{func_2_res}"
    puts "func_3_res #{func_3_res}"
    func_1_res * func_2_res * func_3_res
  end
end

module RectangleIntegration
  def rectangle_integration(bottom_limit, upper_limit, step, func)
    sum = 0

    (bottom_limit..upper_limit).step(step) do |var|
      sum += func.call(var + step / 2)
    end

    (upper_limit - bottom_limit) * sum / ((upper_limit - bottom_limit) / step)
  end
end

module SimpleMonteCarlo
  def simple_monte_carlo(bottom_limit, upper_limit, step, func)
    sum = 0
    n_splits = (upper_limit - bottom_limit) / step

    (0...n_splits).each do
      t = bottom_limit + (upper_limit - bottom_limit) * rand

      sum += func.call(t)
    end

    (upper_limit - bottom_limit) * sum / n_splits
  end

  def simple_monte_carlo_uncertainty(bottom_limit, upper_limit, step, func)
    func_sum = 0
    func_sum_squared = 0
    n_splits = (upper_limit - bottom_limit) / step

    (0...n_splits).each do
      rand_var = rand
      var = bottom_limit + (upper_limit - bottom_limit) * rand_var

      func_sum += func.call(var)
      func_sum_squared += (func.call(var) ** 2)
    end

    func_mean = func_sum / n_splits
    dispersion = (func_sum_squared / n_splits) - (func_mean ** 2)

    (upper_limit - bottom_limit) * Math.sqrt(dispersion / n_splits)
  end

  def simple_monte_carlo_laboriousness(bottom_limit, upper_limit, step, func)
    func_sum = 0
    func_sum_squared = 0
    n_splits = (upper_limit - bottom_limit) / step

    start_time = Time.now.to_f

    (0...n_splits).each do
      rand_var = rand
      var = bottom_limit + (upper_limit - bottom_limit) * rand_var

      func_sum += func.call(var)
      func_sum_squared += (func.call(var) ** 2)
    end

    finish_time = Time.now.to_f

    func_mean = func_sum / n_splits
    dispersion = (func_sum_squared / n_splits) - (func_mean ** 2)
    total_time = (finish_time - start_time) / 1000000.0
    time = total_time / n_splits

    # puts "Time #{time} seconds"
    # puts "dispersion * time #{dispersion * time}"
    dispersion * time
  end

end

module GeometricMonteCarlo

  def geometric_monte_carlo(bottom_limit, upper_limit, step, func)
    n_points = 0
    n_splits = (upper_limit - bottom_limit) / step
    f_min_max_hash = min_max_function(bottom_limit, upper_limit, step, func)
    f_min = f_min_max_hash.dig(:f_min)
    f_max = f_min_max_hash.dig(:f_max)

    (0..n_splits).each do
      x = bottom_limit + (upper_limit - bottom_limit) * rand
      y = f_min + (f_max - f_min) * rand

      if func.call(x) > y
        n_points += 1
      end
    end

    (upper_limit - bottom_limit) * ((f_max - f_min) * (n_points / n_splits) + f_min)
  end

  def geometric_monte_carlo_uncertainty(bottom_limit, upper_limit, step, func)
    n_points = 0
    n_splits = (upper_limit - bottom_limit) / step
    f_min_max_hash = min_max_function(bottom_limit, upper_limit, step, func)
    f_min = f_min_max_hash.dig(:f_min)
    f_max = f_min_max_hash.dig(:f_max)

    (0..n_splits).each do
      x = bottom_limit + (upper_limit - bottom_limit) * rand
      y = f_min + (f_max - f_min) * rand

      if func.call(x) >= y
        n_points += 1
      end
    end

    e_n = n_points / n_splits
    dispersion = e_n * (1 - e_n)
    s_r = (upper_limit - bottom_limit) * (f_max - f_min)

    s_r * Math.sqrt(dispersion / n_splits)
  end

  def geometric_monte_carlo_laboriousness(bottom_limit, upper_limit, step, func)
    n_points = 0
    n_splits = (upper_limit - bottom_limit) / step
    f_min_max_hash = min_max_function(bottom_limit, upper_limit, step, func)
    f_min = f_min_max_hash.dig(:f_min)
    f_max = f_min_max_hash.dig(:f_max)

    start_time = Time.now.to_f

    (0..n_splits).each do
      x = bottom_limit + (upper_limit - bottom_limit) * rand
      y = f_min + (f_max - f_min) * rand

      if func.call(x) >= y
        n_points += 1
      end
    end

    finish_time = Time.now.to_f

    e_n = n_points / n_splits
    dispersion = e_n * (1 - e_n)
    total_time = (finish_time - start_time) / 1000000.0
    time = total_time / n_splits

    # puts "Time #{time} seconds"
    # puts "dispersion * time #{dispersion * time}"
    dispersion * time
  end

  def min_max_function(bottom_limit, upper_limit, step, func)
    f_min = Float::MAX
    f_max = Float::MIN

    (bottom_limit..upper_limit).step(step) do |var|
      temp = func.call(var)

      if temp > f_max
        f_max = temp
      end
      if temp < f_min
        f_min = temp
      end
    end
    # puts "\nf_min #{f_min}, f_max #{f_max}"

    { f_min: f_min, f_max: f_max }
  end
end
