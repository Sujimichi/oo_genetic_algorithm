require 'os_path'
require 'population'
require 'individual'
require 'configs'
require 'population_monitor'

class GeneticAlgorithmBenchmarker

	def initialize
		@number_of_tests = 15
		@config = Configs.new.benchmark
	end

	def benchmark
		@results = []
		puts "Running GA Tests ..."
		@number_of_tests.times do |i|
			@config[:monitor_population] = true
			p = Population.new(@config)
			p.evolve :quiet => true
		
			@results.push p.get_monitor.get_results
			@config[:pop_moniter] = nil	
			puts  "test #{i+1} of #{@number_of_tests}"
		end
		puts "done"
	end

	def view_results
		count = @results.size.to_f
		found ={:ideal => 0, :good => 0, :close => 0, :poor => 0, :mean => 0}
		@results.each do |result|
			found = test_for_goal found, result[:best].fitness
		end
		found[:mean] = found[:mean]/count
		puts "Mean fitness was #{found[:mean]} over #{@results.size} trails"
		puts "A Perfect solution was found #{found[:ideal]} time(s)"
		puts "Good solutions found: #{found[:good]}"
		puts "Solutions which where close #{found[:close]}"
		puts_prob_of_sol "Probability of a GA Finding the Solution:", found, count
	end

	def linear_search
#		@range = decimal_range -10, 10, 1
		@range = 0..1
		dna = Array.new(@config[:gene_length]) {@range.min}
		stop = Array.new(@config[:gene_length]) {@range.max}
		@tests = []

		found ={:ideal => 0, :good => 0, :close => 0, :poor => 0, :mean => 0}
		done = false
		count = 0.00
		until done == true
			count += 1
			dna = inc dna, dna.size-1, 1 #inc will keep ticking the array values up counter style
			done = true if dna == stop
			i = Individual.new(@config, dna)
			found = test_for_goal found, i.fitness
		end
		found[:mean] = found[:mean]/count
		puts_prob_of_sol "Linear Search Results \nProbabilty of Solution", found, count
		puts "With a posible number of combinations = #{count}"
	end

	def puts_prob_of_sol title, found, count
		msg =  "\n#{title}\n"
		msg << "Ideal: #{found[:ideal]/count}\n"
		msg << "Good: #{found[:good]/count}\n"
		msg << "Close: #{found[:close]/count}\n"
		puts msg
	end
	
	def inc ar, i, factor = 1
		unless ar[i] == @range.max
			ar[i] += factor
		else
			ar[i] = @range.min
			inc ar, i-factor
		end
		ar
	end

	def test_for_goal found, fit
		found[:mean] += fit
		found[:ideal] += 1 if fit == @config[:fitness_goal]
		found[:good] += 1 if (fit - @config[:fitness_goal]).abs < 0.3
		found[:close] += 1 if (fit - @config[:fitness_goal]).abs < 1
		found
	end

	def decimal_range min, max, factor = 10
		out = []
		range = (min.to_i * factor)..(max.to_i * factor)
		range.each {|r| out << r.to_f/factor}
		out
	end


end

b = GeneticAlgorithmBenchmarker.new

b.benchmark
b.view_results

b.linear_search
