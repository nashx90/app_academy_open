require 'method_source'

class Array
  
  def deep_dup
    output = []
    self.each do |ele|
      output.push(ele.deep_dup) if ele.is_a?(Array)
      output << ele
    end
  end

end

class RecursiveFunctions

  def test_select
    puts "Pick a method to test: 1. range | 2. sum (recursive and iterative) | 3. exponent_1 | 4. exponent_2 | 5. deep_dup | 6. fibonacci | 0. Exit this program"
    test(gets.chomp)
  end

  private
  
  def range(startnum, endnum)
    return [] if startnum >= endnum
    [startnum] + range((startnum + 1), endnum)
  end
  
  def sum_of_array_recursive(array)
    return array.first if array.length <= 1
    array.first + sum_of_array_recursive(array[1..-1])
  end
  
  def sum_of_array_iterative(array)
    sum = 0
    array.each { |num| sum += num }
    sum
  end

  def exponent_1(base, exponent)
    return 1 if exponent == 0
    base * exponent_1(base, (exponent - 1))
  end

  def exponent_2(base, exponent)
    return 1 if exponent == 0
    return base if exponent == 1
    if exponent.even?
      inductor = exponent_2(base, (exponent / 2))
      return inductor * inductor 
    elsif exponent.odd?
      inductor = exponent_2(base, ((exponent - 1) / 2))
      return base * (inductor * inductor)
    end
  end

  def fibonacci(n)
    return [1] if n == 1
    return [1, 1] if n == 2
    fibonacci(n - 1) + [fibonacci(n - 1).last + fibonacci(n - 2).last]
  end

  def test(method)
    system("clear")
    case method
    when "1"
      puts "Method source code:"
      puts "--------------------"
      RecursiveFunctions.instance_method(:range).source.display
      puts "--------------------"
      puts
      puts "Test outputs"
      p range(1, 5)  # => returns 15
      p range(2, 11)  # => returns 1
      p range(-4, 9)  # => returns 45
      p range(-3, -8)  # => returns nil
    when "2"
      puts "Method source code:"
      puts "--------------------"
      RecursiveFunctions.instance_method(:sum_of_array_recursive).source.display
      RecursiveFunctions.instance_method(:sum_of_array_iterative).source.display
      puts "--------------------"
      puts
      puts "Test outputs"
      arr = [1, 2, 3, 4, 5, 6, 7]
      p sum_of_array_recursive(arr)
      p sum_of_array_iterative(arr)
      p sum_of_array_recursive([1, 2, 3, 4])
      p sum_of_array_iterative([2, 3, 4, 5, 6, 7, 8, 9, 10])
      p sum_of_array_recursive([-4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8])
    when "3"
      puts "Method source code:"
      puts "--------------------"
      RecursiveFunctions.instance_method(:exponent_1).source.display
      puts "--------------------"
      puts
      puts "Test outputs"
      p exponent_1(2, 2)
      p exponent_1(2, 6)
      p exponent_1(3, 3)
    when "4"
      puts "Method source code:"
      puts "--------------------"
      RecursiveFunctions.instance_method(:exponent_2).source.display
      puts "--------------------"
      puts
      puts "Test outputs"
      p exponent_2(2, 2)
      p exponent_2(2, 100)
      p exponent_2(3, 3)
    when "5"
      puts "Method source code:"
      puts "--------------------"
      Array.instance_method(:deep_dup).source.display
      puts "--------------------"
      puts
      puts "Test outputs"
      arr = [1, 2, 3, 4, 5, [6, [3, 2, [2, 2]], 2], 7]
      arr2 = [1, [2], [3, [4]]]
      p arr.deep_dup
      p arr2.deep_dup
    when "6"
      puts "Method source code:"
      puts "--------------------"
      RecursiveFunctions.instance_method(:fibonacci).source.display
      puts "--------------------"
      puts
      puts "Test outputs"
      p fibonacci(2)
      p fibonacci(5)
      p fibonacci(7)
    when "0"
      puts "Thanks!"
      sleep(1)
      return true
    else
      puts "#{method} is not a valid selection."
    end
    puts
    test_select
  end

end


recursor = RecursiveFunctions.new
recursor.test_select