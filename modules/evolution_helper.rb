#Provides non-evolutionary functions to the Evolution Module
#e.g print to screen of gene pool
module EvolutionHelper
	def    puts_pop g
		puts "Population at Generation #{g}"
		for individual in @population
			puts "Individual no #{@population.index individual}'s Genome:\t #{genome_for_print individual.genome}"
		end
	end


	def puts_winner offspring, winner, contestant
		if offspring == winner
			puts "New genome Wins \t#{genome_for_print winner.genome} beats #{genome_for_print contestant.genome}"
		else
			puts "Old genome Wins \t#{genome_for_print winner.genome} beats #{genome_for_print offspring.genome}"
		end
		puts "The Winning Fitness was #{winner.fitness}"
	end


	def puts_microbial_winner(microb_1, microb_2)
		puts "microb gene: #{genome_for_print microb_1.genome} beats #{genome_for_print microb_2.genome}"
	end



	def genome_for_print genome
		genome.sequence.join(", ")
	end
end
