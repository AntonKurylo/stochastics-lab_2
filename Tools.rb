module Tools

  def input_function_parameters
    a = m = k = step = ""

    begin
      while true do
        if a.empty?
          puts("a: ")
          a = STDIN.gets.chomp
          Float(a)
        elsif m.empty?
          puts("m: ")
          m = STDIN.gets.chomp
          Float(a)
        elsif k.empty?
          puts("k: ")
          k = STDIN.gets.chomp
          Float(a)
        elsif step.empty?
          puts("step: ")
          step = STDIN.gets.chomp
          tmp = Float(step)
          unless tmp > 0 and tmp < 1
            step = ""
            puts "\e[31mError: step must be non-inclusive from 0 to 1.\e[0m"
          end
        else
          break
        end
      end
    rescue ArgumentError
      puts "\e[31mError: Non-numeric used.\e[0m"
      exit(-1)
    end

    { a: a.to_f, m: m.to_f, k: k.to_f, step: step.to_f }
  end
end
