#This class is a rather experimental class designed to gather information
#about the populations evolution during the running of the algorithm
class PopulationMonitor
  attr_accessor :stats, :history, :best, :mutations

  def initialize *args
    @args = *args.join(" ")
    @history = []
  end
  #=--------------Code Called During GA Run-Time--------------=#
  def process current_population
    @history << current_population.get_pop.clone
  end

  def record_mutation
    @mutations ||= 0
    @mutations += 1
  end
  #=--------------Code Called After GA Run-Time--------------=#		
  #
  ##=--------------Statistic Generating code----------------=#	

  def make
    @stats = []
    @history.each {|generation| make_stats(generation) } 
    when_best
    self
  end

  def make_stats population
    running_score = 0
    for individual in population
      f = individual.fitness
      running_score += f
      best ||= {:individual => individual, :fitness => f}
      best = {:individual => individual, :fitness => f} if f > best[:fitness]
    end
    @stats << {
      :gen_no => @stats.size + 1, 
      :best_individual => best[:individual],
      :mean_fit => (running_score / population.size)
    }
  end


  def when_best
    @best = @stats.first[:best_individual]
    @stats.each do |generation|
      if generation[:best_individual].fitness > @best.fitness
        @best = generation[:best_individual]
        @earliest_occurance = generation[:gen_no]
      end
    end
  end

  def calculate_genetic_convergence
    gene_length = @history.first.first.genome.sequence.size # Not gonna work with variable gene lengths
    genome_std = []
    @history.each do |generation|
      gene_score = []
      gene_length.times do |i|
        gene_score[i] = standard_deviation( generation.map {|indiv| indiv.genome.sequence[i] } )
      end
      genome_std << gene_score
    end
    genome_std.map {|gen| i=0; gen.each {|g| i+=g}; i/gen.size}
  end


  ##=--------------Data return functions----------------=#	
  def results
    results ={:stats => @stats, :best => @best}
    results.merge!({:mutations => @mutations}) if @mutations
    results.merge!({:offspring_wins => @offspring_wins}) if @off_spring_wins
    results
  end
  def best_individual
    @best
  end
  alias best best_individual

  def mean_fitness
    results[:stats].map{|s| s[:mean_fit] }
  end

  def genetic_convergence
    calculate_genetic_convergence
  end

  def converged_at
    g_conv = calculate_genetic_convergence
    i = g_conv.last
    until i != g_conv.last
      i = g_conv.pop
    end
    g_conv.size
  end

  #=--------------Code which outputs to screen----------------=#	
  def display_results
    make
    display_best
    display_mutations unless @mutations
  end

  def display_best
    when_best unless @earliest_occurance
    msg = "\n\nWinning Genome\nGenome:   #{@best.genome.sequence.join(", ")}"
    msg << "\nName:\t\t#{@best.name}"
    msg << "\nPhenotype:\t#{@best.phenotype.class == Array ? @best.phenotype.join(", ") : @best.phenotype}"
    msg << "\nFitness:\t#{@best.fitness}"
    msg << "\nGeneration:\t#{@earliest_occurance}"

    msg << "\n#{Array.new(20){"-"}.to_s}\n"
    puts msg
  end

  def show_genetic_convergence
    puts "population was geneticaly identical at generation #{converged_at}"
  end

  def display_mutations
    puts "Number of Mutations: #{@mutations}"
  end
  #=-----------------------------------------------------------=#



  def array_sum arr
    sum = 0
    arr.each {|a| sum+= a}
    sum
  end

  def variance(population)
    n = 0
    mean = 0.0
    s = 0.0
    population.each { |x|
      n = n + 1
      delta = x - mean
      mean = mean + (delta / n)
      s = s + delta * (x - mean)
    }
    # if you want to calculate std deviation
    # of a sample change this to "s / (n-1)"
    return s / n
  end

  # calculate the standard deviation of a population
  # accepts: an array, the population
  # returns: the standard deviation
  def standard_deviation(population)
    Math.sqrt(variance(population))
  end
end

