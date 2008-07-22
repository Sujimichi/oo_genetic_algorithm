#This Module provides different methods for performing recombination
#for use with the Genome class
#recombination functions work on the asssumtion that there is a @genomes array in scope
#which contains the genomes for recombination, and will return with a new_genome
module Recombination

#-------------- Recombination Caller Function -------------- #

	def recombine partner_genome 
		genomes = [@dna,partner_genome.sequence]
		send(@recomb_method, genomes)
	end

#----------------- Recombination Functions ----------------- #

	def variable_genelengths_with_mutation genomes
		new_genome = variable_genelengths genomes
		r = rand
		index = (r * new_genome.size).round
		if @mutation_rate > r
			if coin_toss
				new_genome.insert( index, (index == 0 ? new_genome[1] : new_genome[index -1]) )
			else
				new_genome.delete_at index
			end
		end
		new_genome	
	end

	def variable_genelengths genomes
		new_gene_length = 0
		genomes.each {|g| new_gene_length += g.size}
		new_gene_length = (new_gene_length / genomes.size).round
		new_genome = Array.new(new_gene_length)
		new_genome.size.times do |i|
			new_genome[i] = get_gene i, genomes
		end
		new_genome
	end

	def standard_microbial genomes
		new_genome = []
		@gene_length.times do |gene|
			@cross_over_rate >= rand ? new_genome[gene] = genomes[0][gene] : new_genome[gene] = genomes[1][gene]
		end
		new_genome
	end
	
	alias rand_point standard_microbial
	alias microbial standard_microbial

#-------------- Recombination Helper Functions ------------- #
	#
	def get_gene i, genomes
		@fate = coin_toss ? 1 : 0
		if i > (genomes[@fate].size - 1) #the -1 is needed as [0,1,2].size = 3 but index range is 0..2
			change_fate
		end
		gene = genomes[@fate][i]
	end

	def change_fate
		@fate = (@fate - 1).abs
	end

	def coin_toss
		return true if rand >= 0.5
		return false
	end

end
