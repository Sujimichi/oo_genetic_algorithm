#Individuals in this GA are the vessels for Genomes and provide extra, evolutionary non-essential functions.
#The Genome of the individual will govern the indiviudals effectivness
#The Individual is able to have interaction with other individuals e.g. mate, fight
require 'os_path'
require 'genome.rb'
require OSPath.path("modules/fitness.rb")

class Individual
	include Fitness

	def initialize config, dna = nil
		@config = config
		@name = (Array.new(3) { ( (rand*(25)).round + 97).chr }).to_s #self.object_id
		init_genome dna
	end

	#Evolution Essential Functions
	def init_genome dna
		@genome = Genome.new @config, dna
	end

	def genome
		@genome
	end

	def mutant?
		self.genome.has_mutated?
	end
		
	def mate partner
		zygote = self.genome.recombine(partner.genome) 
		offspring = Individual.new(@config, zygote)
		offspring.genome.mutate if apply_mutation? 
		offspring.parents= [self, partner]
		offspring
	end

	alias fuck mate

	def apply_mutation?
		return true if rand < @config[:mutation_rate]
	end

	def fight opponent
		return self.victorious if (self.fitness > opponent.fitness)
		return opponent.victorious
	end

	#Non Essential Functions (allow for gathering information about an individual)

	def victorious
		@victories ||= 0
		@victories += 1
		self
	end
		
	def parents= parents
		@parents = parents
	end

	def parents
		@parents
	end

	def name
		@name
	end

	def dob= dob
		@dob = dob
	end

	def dob
		@dob
	end

end
