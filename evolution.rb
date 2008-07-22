#This Modual for use with the Population Class is concerned
#with the higher level opperation of evolution.  This modual essentially 
#just performs the main evolutionary loop and provides the fork between 
#standard and microbial evolution

require "os_path"
require OSPath.path("modules/evolution_helper.rb")
class Evolution
	include EvolutionHelper

	def evolve arg_hash = {}
		@args = (arg_hash.class.inspect == "Hash") ? arg_hash : {}
		@config[:generations].times do |generation|
			@generation = generation
			puts "\nGeneration: #{@generation + 1}" unless @args[:quiet]  
			@population_monitor.process(self) if @population_monitor
			
			if @config[:recomb_method].to_s =~ /microbial/
				old, new = lower_life_form_evolution
			else
				old, new = higher_life_form_evolution
			end
		
			self.replace_individual( old, new ) unless old == new
		end
	end

	# Standard Evolution; 2 members produce an offspring which then has to win 
	# a competition with a random member to gain addmitance to the population
	def higher_life_form_evolution
		lover_1, lover_2 = self.get_mates
		offspring = lover_1.mate lover_2
		offspring.dob = @generation
		contestant = self.random_member
		winner = offspring.fight(contestant) # <- Competition step for standard evolution
		if @population_monitor
			@population_monitor.record_mutation if offspring.mutant?
		end
		puts_winner(offspring, winner, contestant) unless @args[:quiet]  
		[contestant, winner]
	end

	# Microbial Evolution; 2 Members compete to partially overwrite the others DNA
	def lower_life_form_evolution
		lover_1, lover_2 = sort_by_fitness self.get_mates
		raise "fitness sort fail #{lover_1.fitness}, #{lover_2.fitness}" if lover_1.fitness < lover_2.fitness
		offspring = lover_1.mate lover_2
		offspring.dob = @generation
		if @population_monitor
			@population_monitor.record_mutation if offspring.mutant?
		end
		puts_microbial_winner(lover_1, lover_2) unless @args[:quiet]  
		[lover_2, offspring]
	end

	def sort_by_fitness memb_array
		#In microbial evolution this represents the competion phase
		sort_func = []
		memb_array.each {|i| sort_func << [i.fitness, memb_array.index(i)] }
		sort_func.sort!.reverse!
		new = []
		sort_func.each {|f| new << memb_array[f.last] }
		new		
	end

end
