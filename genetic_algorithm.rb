class GeneticAlgorithm

path = '~/coding/j_projects/genetic_pogramming/genetic-algorithm-tool-kit/'
require path + 'os_path.rb'

requires = ['configs.rb', 'modules/evolution_helper.rb','modules/population_helper.rb','modules/recombination.rb','modules/mutator.rb','modules/gene_initializer.rb','modules/simple_array_maths.rb','modules/fitness.rb','evolution.rb','individual.rb','population.rb','family_tree.rb', 'population_monitor.rb', 'genome.rb']

requires.each do |item|
	require OSPath.path(path + item)
end



$verbose = false

attr_accessor :population

	def initialize
		@config = Configs.new.binary_to_int
		@config.merge!({:monitor_population => true})
		reset
		@evolution = Evolution.new(@config, @population)
	end

	def run
		@evolution.full_cycle 
	end

	def tick
		@evolution.process_generation
	end

	def reset
		@population = Population.new(@config)
	end

	def results
		pm = @evolution.get_monitor.make
		pm.results
	end

	def population_tree
		results = @evolution.get_monitor.make.results
		t = FamilyTree.new(results[:best])
		t.make_tree
		t.pp_tree
	end

end
