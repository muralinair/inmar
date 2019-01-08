Feature: Adding of two numbers 
    Scenario Outline: Add two numbers
    Given the input1 "<input1>" and input2 "<input2>" are digits
    When the calculator is run 
    Then the output should be "<output>"
    Examples:
    | input1 | input2 | output |
    | 2      |   2    |   4    |
    | 98     |   1    |   98   |