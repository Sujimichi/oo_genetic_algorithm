#Configs; The function of this class return hashes of configuration settings
#for use in the GA.  By simply changing which config is called changes the 
#running of the GA.

class Configs
	def binary_basic
		{
			:gene_length => 20,
			:gene_type => :binary,
			:mutate_type => :bit_flip,
			:population_size => 30,
			:mutation_rate => 0.1,
			:cross_over_rate => 0.7,
			:recomb_method => :standard_microbial,
			:generations => 500,
			:fitness_function => :max_ones,
			:fitness_goal => 20
		}
	end

	def variable_genelength
		{
			:gene_length => 8,
			:gene_type => :whole_random,
			:mutate_type => :decimal_shift,
			:population_size => 30,
			:mutation_rate => 0.1,
			:cross_over_rate => 0.5,
			:recomb_method => :variable_genelengths_with_mutation,
			:generations => 50000,
			:fitness_function => :max_ones
		}
	end

	def integer_basic
		{
			:gene_length => 3,
			:gene_type => :whole_random,
			:mutate_type => :integer_shift,
			:shift_strength => 1,
			:population_size => 30,
			:mutation_rate => 0.2,
			:cross_over_rate => 0.5,
			:recomb_method => :rand_point,
			:generations => 1000,
			:fitness_function => :sim_eq_1,
			:monitor_population => true
		}
	end

	def binary_to_int
		{
			:gene_length => 12,
			:gene_type => :binary,
			:mutate_type => :bit_flip,
			:population_size => 30,
			:mutation_rate => 0.2,
			:cross_over_rate => 0.5,
			:recomb_method => :rand_point,
			:generations => 1000,
			:fitness_function => :bin_sim_eq_1,
			#:monitor_population => false
		}
	end

	def string
		{
			:gene_length => 6,
			:gene_type => :whole_random,
			:mutate_type => :integer_shift,
			:shift_strength => 1,
			:population_size => 30,
			:mutation_rate => 0.2,
			:cross_over_rate => 0.5,
			:recomb_method => :rand_point,
			:generations => 10000,
			:fitness_function => :equation,
			:monitor_population => true
		}
	end

	def benchmark
		conf = binary_to_int
		conf.merge({:fitness_goal => 0})
	end


	def encode_string
		{
			:gene_length => 9,
			:gene_type => :binary_random,
			:mutate_type => :bit_flip,
			:population_size => 30,
			:mutation_rate => 0.3,
			:cross_over_rate => 0.5,
			:recomb_method => :variable_genelengths_with_mutation,
			:generations => 5000,
			:fitness_function => :bin_string,
			:fitness_goal => 0,
			:monitor_population => true
		}
	end

end


