def ensure_dir(path, &code)
	dir = Dir.pwd
	begin
		Dir.chdir path
		code.call
	ensure
		Dir.chdir dir
	end
end

def run_shell_parse_output(cmd, path, &parser)
	ensure_dir(path) do
		puts "-> Changed wdir to #{Dir.pwd}"
		puts "-> Running command '#{cmd}'"

		pipe = IO.popen cmd	do | pp |
			
			parser.call(pp)		
		end
		
	end

	puts "!> Process PID #{$?.pid} exited with status code #{$?.exitstatus}" unless $?.success?
	return $?.success?, $?.exitstatus		
end

def run_shell(cmd, path)
	ensure_dir(path) do
		puts "-> Changed wdir to #{Dir.pwd}"
		puts "-> Running command '#{cmd}'"

		system cmd
	end


	puts "!> Process PID #{$?.pid} exited with status code #{$?.exitstatus}" unless $?.success?
	return $?.success?, $?.exitstatus		
end

def exit_with_error(message, code)

	puts message unless message.empty?
	puts :'==========================================='
	exit code
end