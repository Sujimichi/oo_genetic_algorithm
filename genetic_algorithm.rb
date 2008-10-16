class GeneticAlgorithm

	#path = '~/coding/j_projects/genetic_pogramming/genetic-algorithm-tool-kit/' 	#workpath}

	path = '~/programming/genetic-algorithm-tool-kit/'														#homepath}
	require path + 'os_path.rb'

	requires = ['configs.rb', 'modules/evolution_helper.rb','modules/population_helper.rb','modules/recombination.rb','modules/mutator.rb','modules/gene_initializer.rb','modules/simple_array_maths.rb','modules/fitness.rb','evolution.rb','individual.rb','population.rb','family_tree.rb', 'population_monitor.rb', 'genome.rb']

	requires.each do |item|
		require OSPath.path(path + item)
	end

	$verbose = false
	attr_accessor :population

	def initialize
		@config = Configs.new.binary_to_int
		reset
	end

	def run
		@evolution.full_cycle 
	end

	def tick
		@evolution.process_generation
	end

	def reset
		@population_monitor = PopulationMonitor.new
		@population = Population.new(@config)
		@evolution = Evolution.new(@config, @population,@population_monitor)
	end

	def results
		@evolution.get_monitor.make.results
	end

	def population_tree
		t = FamilyTree.new(results[:best])
		t.make_tree
		t.pp_tree
	end
	alias tree population_tree

	def mean_fit_data
		results[:stats].map{|s| s[:mean_fit] }
	end

end
