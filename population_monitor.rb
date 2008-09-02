#This class is a rather experimental class designed to gather information
#about the populations evolution during the running of the algorithm
class PopulationMonitor
	require 'rubygems'
	require 'gruff'

	def initialize *args
		@args = *args.join(" ")
		@generation_stats = []
		@pop_store = []

	end
	#=--------------Code Called During GA Run-Time--------------=#
	def process current_population
		@pop_store << current_population.get_pop.clone
		#@current_population = current_population.get_pop
		#make_generation_stats
		#@current_population = nil
	end

	def record_mutation
		@mutations ||= 0
		@mutations += 1
	end
	#=--------------Code Called After GA Run-Time--------------=#		

	def make_generation_stats population
		running_score = 0
		for individual in population
			f = individual.fitness
			running_score += f
			best ||= {:individual => individual, :fitness => f}
			best = {:individual => individual, :fitness => f} if f > best[:fitness]
		end
		@generation_stats << {
			:gen_no => @generation_stats.size + 1, 
			:best_individual => best[:individual], 
			:mean_fit => (running_score / population.size)
		}
	end

	def view_results
		for pop in @pop_store
			make_generation_stats(pop)
		end
		show_best
		show_mutations unless @muations
	end

	def when_best
		@generation_stats.first[:best_individual].fitness_target ||= 5000
		fitness_target = @generation_stats.first[:best_individual].fitness_target + 0.00
		earliest_occurance = 0
		print "Checking for earliest occurance of Fittest Genome"
		for generation in @generation_stats
			dif = (fitness_target - generation[:best_individual].fitness).abs
			best_dif ||= dif

			if dif < best_dif
				best_dif = dif
				earliest_occurance = generation[:gen_no]
				print "*"
			end
			print "."

		end
		puts "Done"
		@best = @generation_stats[earliest_occurance-1][:best_individual]
		earliest_occurance
	end

	def get_results
		when_best
		results = {
			:mutations => @mutaions,
			:offspring_wins => @offspring_wins,
			:generation_stats => @generation_stats,
			:best => @best
		}
	end

	#=--------------Code which outputs to screen----------------=#	

	def show_best
		earliest_occurance = when_best
		msg = "\n\nWinning Genome\nGenome:   #{@best.genome.sequence.join(", ")}"
		msg << "\nName:\t\t#{@best.name}"
		msg << "\nPhenotype:\t#{@best.phenotype.class == Array ? @best.phenotype.join(", ") : @best.phenotype}"
		msg << "\nFitness:\t#{@best.fitness}"
		msg << "\nGeneration:\t#{earliest_occurance}"

		msg << "\n#{Array.new(20){"-"}.to_s}\n"
		puts msg
	end	

	def show_mutations
		puts "Number of Mutations: #{@mutations}"
	end

	#=--------------------Graph Functions------------------------=#	
	def graph_mean_fit
		mean_fit = @generation_stats.map {|gs| gs[:mean_fit]}
		g = Gruff::Line.new
		g.title = "Mean Fitness Over Time" 
		g.data("Mean Fitness", mean_fit)
		g.write('mean_fit_over_time.png')
	end

	def graph_genetic_convergence
		gene_length = @pop_store.first.first.genome.sequence.size
		genome_std = []
		@pop_store.each do |generation|
			gene_score = []
			gene_length.times do |i|
				gene_score[i] = standard_deviation( generation.map {|indiv| indiv.genome.sequence[i] } )
			end
			genome_std << gene_score
		end
#		g = Gruff::Line.new
#		g.data("Mean Fitness", genome_std)
#		g.write('std_over_time.png')
		puts genome_std.inspect

	end


	#=-----------------------------------------------------------=#


	def who_best?
		@best
	end

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



	#=-Obsolete-=#
=begin
	def mean_over_gens
		mean = []
		for gens in @generation_stats

			mean << round_to_dp(gens[:mean_fit], 2)
		end
		puts mean
	end

	def round_to_dp f, dp
		f = f.to_f if f.class.inspect == "Fixnum"
		(raise 'not float') if f.class.inspect != "Float"
		s = f.to_s.split("")
		p_pos = s.index(".")
		if s.size - (p_pos+1) <= dp
			return f
		end
		out = s[0..p_pos+dp+1]
		r = out.pop
		if r.to_i > 5
			unless out[out.size] == "."
				out[out.size-1] = (out[out.size-1].to_i + 1).to_s
			else
				out[out.size-2] = (out[out.size-2].to_i + 1).to_s
			end
		end
	out = out.join.to_f
	return out
	end
=end

end

