#Individuals in this GA are the vessels for Genomes and provide extra, evolutionary non-essential functions.
#The Genome of the individual will govern the indiviudals effectivness
#The Individual is able to have interaction with other individuals e.g. mate, fight

class Individual
  include Fitness
  attr_accessor :genome, :parents, :name, :dob
	attr_reader :victories

  def initialize config, dna = nil
    @config = config
    @name = (Array.new(3) { ( (rand*(25)).round + 97).chr }).to_s #self.object_id
    init_genome dna
  end

  #Evolution Essential Functions
  def init_genome dna = nil
    @genome = Genome.new @config, dna
  end

  def fight opponent
    return self.victorious if (self.fitness > opponent.fitness)
    return opponent.victorious
  end

  def mate partner
    zygote = self.genome.recombine(partner.genome) 
    offspring = Individual.new(@config, zygote)
    offspring.genome.mutate if offspring.genome.apply_mutation? 
    offspring.parents= [self, partner]
    offspring
  end
  alias fuck mate

  def mutant?
    self.genome.has_mutated?
  end

  #Non Essential Functions (allow for gathering information about an individual)

  def victorious
    @victories ||= 0
    @victories += 1
    self
  end

end
