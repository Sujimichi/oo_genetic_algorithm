#The Genome class forms the section of the alg in which the genetic operations occur.
#A Genome has DNA, an array of genes which can be recombined with 
#other genomes to make new ones and can under go mutation according to @config settings

class Genome
  include GeneInitializer
  include Mutator
  include Recombination

  def initialize config, dna = nil
    @gene_length = config[:gene_length]
    @gene_type = config[:gene_type]
    @mutate_type = config[:mutate_type]
    @shift_stength = config[:shift_strength] if config.has_key? :shift_strength
    @recomb_method = config[:recomb_method]
    @cross_over_rate = config[:cross_over_rate]
    @mutation_rate = config[:mutation_rate]

    new_random(config) unless dna 
    inherit(dna) if dna
    #in all cases other than population initialization dna will be inherited
    @dna.extend SimpleArrayMaths
  end

  def new_random(config)
    #get a new dna from GeneInitalizer according to @config[:gene_type]
    @dna = novel_genome(config)
  end

  def inherit dna
    #dna has come from a recombination of parents
    @dna = dna
  end

  def sequence
    @dna
  end

  def has_mutated?
    return @mutant if @mutant
    false
  end

  def apply_mutation?
    return true if rand < @mutation_rate
  end

end
