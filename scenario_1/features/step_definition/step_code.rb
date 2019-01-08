#require 'rspec'
Given(/^the input1 "([^"]*)" and input2 "([^"]*)" are digits$/) do |input1,input2|
	@input1 = input1  # First digit for addition
    @input2 = input2  # Second digit for addition
    expect(@input1).to match(/\A[-+]?[0-9]*\.?[0-9]+\Z/)
    expect(@input2).to match(/\A[-+]?[0-9]*\.?[0-9]+\Z/)
end
When (/^the calculator is run$/) do
    @output=@input1.to_i+@input2.to_i
    puts "\nSum of #{@input1} + #{@input2} is #{@output}"
end
Then (/^the output should be "([^"]*)"$/) do |expected_output|
    expect(@output).to eq(expected_output.to_i)
end
