Given(/^the input1 "([^"]*)" and input2 "([^"]*)"$/) do |input1,input2|
	@input1 = input1  # First digit for addition
    @input2 = input2  # Second digit for addition
end
When (/^the calculator is run$/) do
    puts "Sum of #{@input1} + #{@input2} is #{@input1.to_i+@input2.to_i}"
end
Then (/^the output should be "([^"]*)"$/) do |expected_output|
	expect(@output).equal?(expected_output)
end
