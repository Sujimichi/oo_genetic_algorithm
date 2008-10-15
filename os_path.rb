#Simple function to ease the use of paths in different opperating systems
#OSPath.path <my_path> will return my_path with the correct / \ 
#assuming given a linux style path
class OSPath
	def self.path input
		separator = File::ALT_SEPARATOR || File::SEPARATOR
		input.split(/\//).join(separator)
	end
end
