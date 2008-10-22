class GeneticAlgorithm

  path = '~/programming/genetic_algorithm/' #homepath
  require path + 'os_path.rb'
  requires = ['configs.rb', 'modules/evolution_helper.rb','modules/population_helper.rb','modules/recombination.rb','modules/mutator.rb','modules/gene_initializer.rb','modules/simple_array_maths.rb','modules/fitness.rb','evolution.rb','individual.rb','population.rb','family_tree.rb', 'population_monitor.rb', 'genome.rb']
  requires.each do |item|
    require OSPath.path(path + item)
  end

  $verbose = false
  attr_accessor :population

  def initialize config = Configs.new.binary_to_int
    @config = config
    reset
  end

  def reset
    @population_monitor = PopulationMonitor.new
    @population = Population.new(@config)
    @evolution = Evolution.new(@config, @population,@population_monitor)
  end

  def run
    @evolution.full_cycle 
  end

  def tick
    @evolution.process_generation
  end

  def results
    examine.display_results
  end

  def examine
    return @evolution.get_monitor.make
  end

  def population_tree
    t = FamilyTree.new(examine.results[:best])
    t.make_tree
    t.pp_tree
  end
  alias tree population_tree

end
