class OSPath
	SPLIT_REXP = /\//
	def self.path input
		separator = File::ALT_SEPARATOR || File::SEPARATOR
		input.split(SPLIT_REXP).join(separator)
	end
end
