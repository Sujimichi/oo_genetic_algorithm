class PopulationMonitor


	def initialize *args
		@args = *args.join(" ")
		@generation_stats = []
		
	end

	def process current_population
		@current_population = current_population.get_pop
		make_generation_stats
		@current_population = nil
	end
	
	def view_results
		#puts @generation_stats
		#mean_over_gens
		show_best
		show_mutations unless @muations
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

	def record_mutation
		@mutations ||= 0
		@mutations += 1
	end

	def show_mutations
		puts "Number of Mutations: #{@mutations}"
	end

	def make_generation_stats
		running_score = 0
		for individual in @current_population
			f = individual.fitness
			running_score += f
			best ||= {:individual => individual, :fitness => f}
			best = {:individual => individual, :fitness => f} if f > best[:fitness]
		end
		@generation_stats << {
			:gen_no => @generation_stats.size+1, 
			:best_individual => best[:individual], 
			:mean_fit => (running_score / @current_population.size)
		}
	end

	def who_best?
		@best
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


end

