require './definitions.rb'

describe 'Java'.def do
	it 'is installed' do		
		'Java'.def.should be_installed
	end

	it 'has JAVA_HOME set' do
		'Java'.def.should have_JAVA_HOME_set
	end
end