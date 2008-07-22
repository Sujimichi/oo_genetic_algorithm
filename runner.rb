require 'population.rb'
require 'configs.rb'
require 'family_tree.rb'





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
end


puts "--------------------\n\n"
t = FamilyTree.new(best)
t.make_tree
t.pp_tree


