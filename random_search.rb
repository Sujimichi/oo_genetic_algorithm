require 'os_path'
require OSPath.path("modules/fitness.rb")
require 'population_monitor.rb'

class Genome

	def initialize(genes)
		@genes = genes
	end

	def sequence
		@genes
	end
end


class RandomSearch
	include Fitness

	def initialize
		@config={
			:fitness_function => :sim_eq_1,
			:pop_monitor => PopulationMonitor.new
		}
	end

	def genome
		@genome
	end

	

	def random_search
		itterations = 100000
		gl = 3

		ideals_found = 0
		itterations.times do |i|
			@fitness = nil
			g = Array.new(3) {|j| j = (rand*20).round-10 }
			@genome = Genome.new(g)
			if fitness == 0 
				ideals_found += 1
			end
		end
		puts "found #{ideals_found} in #{itterations}"
		puts "Prob. of solution is 1 in #{itterations/ideals_found}"
		@config[:pop_monitor].show_fit_tests

	end


end


r = RandomSearch.new
r.random_search 
