#This class, for use with the Population Class, is concerned
#with the higher level opperation of evolution.  This class essentially 
#just performs the main evolutionary loop and provides the fork between 
#standard and microbial evolution
class Evolution
	include EvolutionHelper

	def initialize config, population
		@config = config 
		@population = population
		@population_monitor = PopulationMonitor.new(@config[:monitor_population]) if @config[:monitor_population]
	end

	def full_cycle 
		@config[:generations].times do |generation|
			@generation = generation
			puts "\nGeneration: #{generation + 1}" if $verbose
			process_generation
		end
		puts "done"
	end

	def process_generation
		@population_monitor.process(@population) if @population_monitor
		if @config[:recomb_method].to_s =~ /microbial/
			old, new = lower_life_form_evolution
		else
			old, new = higher_life_form_evolution
		end
		@population.replace_individual( old, new ) unless old == new
		print "."
	end

	# Standard Evolution; 2 members produce an offspring which then has to win 
	# a competition with a random member to gain addmitance to the population
	def higher_life_form_evolution
		lover_1, lover_2 = @population.get_mates
		offspring = lover_1.mate lover_2
		offspring.dob = @generation
		contestant = @population.random_member
		winner = offspring.fight(contestant) # <- Competition step for standard evolution
		if @population_monitor
			@population_monitor.record_mutation if offspring.mutant?
		end
		puts_winner(offspring, winner, contestant) if $verbose  
		[contestant, winner]
	end

	# Microbial Evolution; 2 Members compete to partially overwrite the others DNA
	def lower_life_form_evolution
		lover_1, lover_2 = sort_by_fitness @population.get_mates
		raise "fitness sort fail #{lover_1.fitness}, #{lover_2.fitness}" if lover_1.fitness < lover_2.fitness
		offspring = lover_1.mate lover_2
		offspring.dob = @generation
		if @population_monitor
			@population_monitor.record_mutation if offspring.mutant?
		end
		puts_microbial_winner(lover_1, lover_2) if $verbose  
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
		
	def get_monitor
		@population_monitor
	end

end
