require 'population.rb'
require 'configs.rb'
require 'family_tree.rb'

#Runner: This is just a little stub to set options and launch the GA.
#Simply by comenting in and out different @config lines different GA behaviour can be had.

#@config = Configs.new.variable_genelength
#@config = Configs.new.binary_basic
#@config = Configs.new.string
#@config = Configs.new.benchmark
#@config = Configs.new.integer_basic
@config = Configs.new.binary_to_int
#@config = Configs.new.encode_string

p = Population.new(@config)
p.evolve :quiet => true

if @config.has_key? :monitor_population
	population_monitor = p.get_monitor
	population_monitor.view_results
	best = population_monitor.who_best?
	population_monitor.graph_mean_fit
	population_monitor.graph_genetic_convergence



	puts "--------------------\n\n"
	t = FamilyTree.new(best)
	t.make_tree
	t.pp_tree

end

