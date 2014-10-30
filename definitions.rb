require './define_me.rb'

define 'process' do
	can_be_launched? do |exe, &block|
		_, code = run_shell "nohup #{exe}", '.'
		
		return block.call unless code == 127
	end

	parse_output do |exe, regex, &block|
		out = ""
		success, code = run_shell_parse_output "#{exe}", '.' do |pipe|
			pipe.each_char do |c|
				out << c
			end
		end
		
		success and Value.new(regex.match(out)).instance_eval &block
	end
end

define 'Java' do
	is_a 'process'
	
	installed? do
		can_be_launched? 'java' do
			parse_output 'nohup java -version', /java version \"1\.(\d)\./ do
				ver, _ = @value.captures
				
				'7' == ver
			end			
		end		
	end	

	has_JAVA_HOME_set? do
		env_set? 'JAVA_HOME' do
			
			Dir.exists? @value			
		end
	end
end
