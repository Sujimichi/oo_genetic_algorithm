#This modual provides different starting points for intitial gene pool
#Module for use with Genome class 
module GeneInitializer

	def novel_genome config
		send(@gene_type)
	end

	def binary_random
		genome = Array.new(@gene_length) {|a| a = rand.round}
	end

	alias binary binary_random

	def zeros
		genome = Array.new(@gene_length) {|a| a = 0 }
	end

	def ones
		genome = Array.new(@gene_length) {|a| a = 1 }
	end

	def random
		genome = Array.new(@gene_length) {|a| a = rand}
	end

	def whole_random
		material = Array.new(@gene_length) {|a| a = rand}
		genome = []
		for m in material
			genome << ( (m * 20).round - 10 )
		end
		genome
	end

end
