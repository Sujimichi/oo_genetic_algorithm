class GeneticAlgorithm

require '~/programming/genetic-algorithm-tool-kit/os_path.rb'
require '~/programming/genetic-algorithm-tool-kit/configs.rb'
require OSPath.path('~/programming/genetic-algorithm-tool-kit/modules/evolution_helper.rb')
require OSPath.path('~/programming/genetic-algorithm-tool-kit/modules/population_helper.rb')
require OSPath.path('~/programming/genetic-algorithm-tool-kit/modules/recombination.rb')
require OSPath.path('~/programming/genetic-algorithm-tool-kit/modules/mutator.rb')
require OSPath.path('~/programming/genetic-algorithm-tool-kit/modules/gene_initializer.rb')
require OSPath.path('~/programming/genetic-algorithm-tool-kit/modules/simple_array_maths.rb')
require OSPath.path('~/programming/genetic-algorithm-tool-kit/modules/fitness.rb')

require '~/programming/genetic-algorithm-tool-kit/evolution.rb'
require '~/programming/genetic-algorithm-tool-kit/individual.rb'
require '~/programming/genetic-algorithm-tool-kit/population.rb'
require '~/programming/genetic-algorithm-tool-kit/family_tree.rb'
require '~/programming/genetic-algorithm-tool-kit/population_monitor.rb'
require '~/programming/genetic-algorithm-tool-kit/genome.rb'



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
