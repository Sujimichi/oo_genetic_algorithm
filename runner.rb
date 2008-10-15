
require 'configs.rb'
require 'population.rb'
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
@config.merge!({:monitor_population => true})

p = Population.new(@config)
p.evolve :quiet => true
#stats = p.get_monitor.make.results[:stats]
#puts stats.size
#puts stats.map{|r| r[:mean_fit]}.inspect

#puts pm.best_individual




#@config.delete :monitor_population
if @config.has_key?(:monitor_population) && @config[:monitor_population] == true
	pm = p.get_monitor.make
	pm.display_results
	best = pm.best_individual

	puts "--------------------\n\n"
	t = FamilyTree.new(best)
	t.make_tree
	t.pp_tree
end

