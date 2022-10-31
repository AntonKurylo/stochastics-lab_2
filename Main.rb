require 'benchmark'
require_relative "Tools"
require_relative "IntegralModules"
include Tools
include DirectIntegration
include RectangleIntegration
include SimpleMonteCarlo
include GeometricMonteCarlo

# Область інтегрування0
bottom_limit = 0
upper_limit = 1

puts "Calculation of integrals."
puts "\nEnter function parameters and calculation step:"
func_param_hash = Tools.input_function_parameters
puts "\nFunction parameters and calculation step:"
func_param_hash.keys.each { |key| print(" #{key}: #{func_param_hash.dig(key)}") }
step = func_param_hash.dig(:step)

func_1 = -> x { func_param_hash.dig(:a) * (1 - x) * x }
func_2 = -> y { Math.exp(-func_param_hash.dig(:m) * y) }
func_3 = -> z { Math.sin(Math::PI * func_param_hash.dig(:k) * z) }

direct_time = Benchmark.measure { DirectIntegration.direct_integration(bottom_limit, upper_limit, func_param_hash) }.real
rectangle_time = Benchmark.measure { [func_1, func_2, func_3]
                                       .map { |f| RectangleIntegration.rectangle_integration(bottom_limit, upper_limit, step, f) }.inject(:*) }.real
simple_monte_carlo_time = Benchmark.measure { [func_1, func_2, func_3]
                                                .map { |f| SimpleMonteCarlo.simple_monte_carlo(bottom_limit, upper_limit, step, f) }.inject(:*) }.real
geometric_monte_carlo_time = Benchmark.measure { [func_1, func_2, func_3]
                                                   .map { |f| GeometricMonteCarlo.geometric_monte_carlo(bottom_limit, upper_limit, step, f) }.inject(:*) }.real

direct_integration = DirectIntegration.direct_integration(bottom_limit, upper_limit, func_param_hash)

rectangle_integration =
  [func_1, func_2, func_3].map { |f| RectangleIntegration.rectangle_integration(bottom_limit, upper_limit, step, f) }.inject(:*)
runge_uncertainty = ([func_1, func_2, func_3]
                       .map { |f| RectangleIntegration.rectangle_integration(bottom_limit, upper_limit, step, f) -
                         RectangleIntegration.rectangle_integration(bottom_limit, upper_limit, 2 * step, f) }
                       .sum / 3).abs

simple_monte_carlo_integration =
  [func_1, func_2, func_3].map { |f| SimpleMonteCarlo.simple_monte_carlo(bottom_limit, upper_limit, step, f) }.inject(:*)
simple_monte_carlo_uncertainty =
  ([func_1, func_2, func_3].map { |f| simple_monte_carlo_uncertainty(bottom_limit, upper_limit, step, f) }.sum / 3).abs
simple_monte_carlo_laboriousness =
  ([func_1, func_2, func_3].map { |f| simple_monte_carlo_laboriousness(bottom_limit, upper_limit, step, f) }.sum / 3).abs

geometric_monte_carlo =
  [func_1, func_2, func_3].map { |f| GeometricMonteCarlo.geometric_monte_carlo(bottom_limit, upper_limit, step, f) }.inject(:*)
geometric_monte_carlo_uncertainty =
  ([func_1, func_2, func_3].map { |f| GeometricMonteCarlo.geometric_monte_carlo_uncertainty(bottom_limit, upper_limit, step, f) }.sum / 3).abs
geometric_monte_carlo_laboriousness =
  ([func_1, func_2, func_3].map { |f| GeometricMonteCarlo.geometric_monte_carlo_laboriousness(bottom_limit, upper_limit, step, f) }.sum / 3).abs

i_1 = 0
i_2 = 0
i_3 = 0

puts "Direct integration: #{direct_integration}"
puts "Direct calculation time: #{direct_time} seconds"

puts ""
[func_1, func_2, func_3].map { |f| RectangleIntegration.rectangle_integration(bottom_limit, upper_limit, step, f) }.map { |el| puts "func_#{i_1 += 1}_res #{el}" }
puts "Rectangle integration: #{rectangle_integration}"
puts "Runge uncertainty: #{runge_uncertainty}"
puts "Rectangle error: #{(direct_integration - rectangle_integration).abs}"
puts "Rectangle calculation time: #{rectangle_time} seconds"

puts ""
[func_1, func_2, func_3].map { |f| SimpleMonteCarlo.simple_monte_carlo(bottom_limit, upper_limit, step, f) }.map { |el| puts "func_#{i_2 += 1}_res #{el}" }
puts "Simple Monte Carlo integration: #{simple_monte_carlo_integration}"
puts "Simple Monte Carlo uncertainty: #{simple_monte_carlo_uncertainty}"
puts "Simple Monte Carlo error: #{(direct_integration - simple_monte_carlo_integration).abs}"
puts "Simple Monte Carlo calculation time: #{simple_monte_carlo_time} seconds"
puts "Simple Monte Carlo laboriousness: #{simple_monte_carlo_laboriousness} seconds"

puts ""
[func_1, func_2, func_3].map { |f| GeometricMonteCarlo.geometric_monte_carlo(bottom_limit, upper_limit, step, f) }.map { |el| puts "func_#{i_3 += 1}_res #{el}" }
puts "Geometric Monte Carlo integration: #{geometric_monte_carlo}"
puts "Geometric Monte Carlo uncertainty: #{geometric_monte_carlo_uncertainty}"
puts "Geometric Monte Carlo error: #{(direct_integration - geometric_monte_carlo).abs}"
puts "Geometric Monte Carlo calculation time: #{geometric_monte_carlo_time} seconds"
puts "Geometric Monte Carlo laboriousness: #{geometric_monte_carlo_laboriousness} seconds"
