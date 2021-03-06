require 'method_source'
require 'byebug'

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

  def initialize
    @cycles = 0
  end
  
  def test_select
    puts "--------------------

    Pick a method to test:
    1. range 
    2. sum (recursive and iterative) 
    3. exponent_1 | 4. exponent_2 
    5. deep_dup 
    6. fibonacci 
    7. bsearch 
    8. merge_sort 
    9. subsets 
    10. shuffle_permutations 
    11. calc_permutations 
    12. greedy_make_change
    13. make_better_change
    0. Exit this program
    
    Please enter a selection below:"
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

  def bsearch(array, target)
    return nil if !array.include?(target)
    midpoint_idx = (array.length / 2.0).ceil
    left_arr, right_arr = array[0...midpoint_idx], array[midpoint_idx..-1]
    return (left_arr.length - 1) if left_arr.last == target
    if left_arr.last > target
      bsearch(left_arr, target)
    elsif left_arr.last < target
      (left_arr.length - 1) + (bsearch(right_arr, target) + 1)
    end
  end

  def merge_sort(array)
    return array if array.length <= 1
    left_slice, right_slice = slice(array)[0], slice(array)[1]
    return merge(left_slice, right_slice) if left_slice.length <= 1 && right_slice.length <= 1
    merge(merge_sort(left_slice), merge_sort(right_slice))
  end

  def slice(array)
    array.each_slice( (array.length/2.0).ceil ).to_a
  end

  def merge(left_arr, right_arr, merged = Array.new([]))
    return merged if left_arr.empty? && right_arr.empty?
    if right_arr.empty? || (!left_arr.empty? && left_arr.first <= right_arr.first)
      merged << left_arr.shift
      merge(left_arr, right_arr, merged)
    elsif left_arr.empty? || left_arr.first > right_arr.first
      merged << right_arr.shift
      merge(left_arr, right_arr, merged)
    end
  end

  def subsets(array)
    return [array] if array.empty?
    last_ele = [array.pop]
    inductor = subsets(array)
    return inductor + (inductor.map { |ele| ele + last_ele })
  end

  def shuffle_permutations(array)
    array = [array] if !array[0].is_a?(Array)
    return array.sort if array.length == factorial(array.first.length)
    array << array[0].shuffle
    permutations(array.uniq)
  end

  def calc_permutations(array)
    output = []
    array = [array] if !array[0].is_a?(Array)
    return array.sort if array.first.empty? || array.first.any? && array.length == factorial(array.first.length)
    if array.first.length <= 2
      array << [array.first[1], array.first[0]]
      return array
    end
    array.first.each do |perm_ele|
      inductor = calc_permutations(array.map { |sub_arr| sub_arr.reject { |ele| ele == perm_ele } })
      output += inductor.map { |ele| [perm_ele] + ele }
    end
    output
  end

  def factorial(num)
    return 1 if num <= 1
    num * factorial(num - 1)
  end

  def greedy_make_change(num, coins = [50, 20, 10, 5, 1])
    output = []
    return output if num == 0
    if num >= coins.first
      output << coins.first
      num -= coins.first
      output += greedy_make_change(num, coins)
    end
    until coins.empty?
      coins.shift
      output += greedy_make_change((num), coins)
    end
    output
  end

  def make_better_change(num, coins = [50, 20, 10, 5, 1])
    output = []
    return output if num == 0
    rem = num
    best_coin = coins.first
    coins.each do |coin|
      c_factor = (num % coin) + (num - coin)
      if c_factor < rem
        rem, best_coin = c_factor, coin
      end
    end
    if num >= best_coin
      output << best_coin
      num -= best_coin
      output += make_better_change(num, coins)
    end
    until coins.empty?
      coins.shift
      output += make_better_change((num), coins)
    end
    output.sort.reverse

  end

  def test(method)
    system("clear")
    @cycles = 0
    case method
    when "1" # => Range method
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
    when "2" # => Sum of Array (Recursive and Iterative)
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
    when "3" # => Exponent_1
      puts "Method source code:"
      puts "--------------------"
      RecursiveFunctions.instance_method(:exponent_1).source.display
      puts "--------------------"
      puts
      puts "Test outputs"
      p exponent_1(2, 2)
      p exponent_1(2, 6)
      p exponent_1(3, 3)
    when "4" # => Exponent_2
      puts "Method source code:"
      puts "--------------------"
      RecursiveFunctions.instance_method(:exponent_2).source.display
      puts "--------------------"
      puts
      puts "Test outputs"
      p exponent_2(2, 2)
      p exponent_2(2, 100)
      p exponent_2(3, 3)
    when "5" # => Deep dup
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
    when "6" # => Fibonacci
      puts "Method source code:"
      puts "--------------------"
      RecursiveFunctions.instance_method(:fibonacci).source.display
      puts "--------------------"
      puts
      puts "Test outputs"
      p fibonacci(2)
      p fibonacci(5)
      p fibonacci(7)
    when "7" # => Binary search
      puts "Method source code:"
      puts "--------------------"
      RecursiveFunctions.instance_method(:bsearch).source.display
      puts "--------------------"
      puts
      puts "Test outputs"
      p bsearch([1, 2, 3], 1) # => 0
      p bsearch([2, 3, 4, 5], 3) # => 1
      p bsearch([2, 4, 6, 8, 10], 6) # => 2
      p bsearch([1, 3, 4, 5, 9], 5) # => 3
      p bsearch([1, 2, 3, 4, 5, 6], 6) # => 5
      p bsearch([1, 2, 3, 4, 5, 6], 0) # => nil
      p bsearch([1, 2, 3, 4, 5, 7], 6) # => nil
    when "8" # => Merge sort
      puts "Method source code:"
      puts "--------------------"
      RecursiveFunctions.instance_method(:merge_sort).source.display
      puts
      RecursiveFunctions.instance_method(:merge).source.display
      puts "--------------------"
      puts
      puts "Test outputs"
      p merge_sort([16, 5, 2, 9, 18, 15, 6]) # => [2, 5, 6, 9, 15, 16, 18]
      p merge_sort([5, 18, 12, 1, 11, 2, 3]) # => [1, 2, 3, 5, 11, 12, 18]
      p merge_sort([16, 20, 7, 9, 15, 4, 19]) # => [4, 7, 9, 15, 16, 19, 20]
      p merge_sort([10, 18, 16, 5, 7, 6, 19]) # => [5, 6, 7, 10, 16, 18, 19]
      p merge_sort([19, 20, 3, 17, 6, 9, 18]) # => [3, 6, 9, 17, 18, 19, 20]
      p merge_sort([3, 15, 18, 7, 2, 9, 16]) # => [2, 3, 7, 9, 15, 16, 18]
      p merge_sort([3, 14, 6, 16, 5, 9, 1]) # => [1, 3, 5, 6, 9, 14, 16]
    when "9" # => Subsets
      puts "Method source code:"
      puts "--------------------"
      RecursiveFunctions.instance_method(:subsets).source.display
      puts "--------------------"
      puts
      puts "Test outputs:"
      p subsets([]) # => [[]]
      p subsets([1]) # => [[], [1]]
      p subsets([1, 2]) # => [[], [1], [2], [1, 2]]
      p subsets([1, 2, 3]) # => [[], [1], [2], [1, 2], [3], [1, 3], [2, 3], [1, 2, 3]]
      # p subsets([16, 5, 2, 9, 18, 15, 6])
    when "10" # => Shuffle Permutations
      puts "Method source code:"
      puts "--------------------"
      RecursiveFunctions.instance_method(:shuffle_permutations).source.display
      puts "--------------------"
      puts
      puts "Test outputs:"
      p shuffle_permutations([]) # => [[]]
      p shuffle_permutations([1]) # => [[], [1]]
      p shuffle_permutations([1, 2]) # => [[], [1], [2], [1, 2]]
      p shuffle_permutations([1, 2, 3]) # => [[], [1], [2], [1, 2], [3], [1, 3], [2, 3], [1, 2, 3]]
      p shuffle_permutations([16, 5, 2, 9])
    when "11" # => Calculated Permutations
      puts "Method source code:"
      puts "--------------------"
      RecursiveFunctions.instance_method(:calc_permutations).source.display
      puts "--------------------"
      puts
      puts "Test outputs:"
      p calc_permutations([]) # => [[]]
      p calc_permutations([1]) # => [[1]]
      p calc_permutations([1, 2]) # => [[1, 2], [2, 1]]
      p calc_permutations([1, 2, 3]) # => [[1, 2, 3], [1, 3, 2], [2, 1, 3], [2, 3, 1], [3, 1, 2], [3, 2, 1]]
      p calc_permutations([1, 2, 3, 4]) # => [[1, 2, 3, 4], [1, 2, 4, 3], [1, 3, 2, 4], [1, 3, 4, 2], [1, 4, 2, 3], [1, 4, 3, 2], [2, 1, 3, 4], [2, 1, 4, 3], [2, 3, 1, 4], [2, 3, 4, 1], [2, 4, 1, 3], [2, 4, 3, 1], [3, 1, 2, 4], [3, 1, 4, 2], [3, 2, 1, 4], [3, 2, 4, 1], [3, 4, 1, 2], [3, 4, 2, 1], [4, 1, 2, 3], [4, 1, 3, 2], [4, 2, 1, 3], [4, 2, 3, 1], [4, 3, 1, 2], [4, 3, 2, 1]]
      # p calc_permutations([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]) # => DANGER! DO NOT RUN! 3.6 million permutations!
    when "12" # => Greedy Make Change
      puts "Method source code:"
      puts "--------------------"
      RecursiveFunctions.instance_method(:greedy_make_change).source.display
      puts "--------------------"
      puts
      puts "Test outputs:"
      p greedy_make_change(100)
      p greedy_make_change(37)
      p greedy_make_change(134, [25, 10, 5, 1])
      p greedy_make_change(21, [12, 7, 1])
      p greedy_make_change(24, [10, 7, 1])
      p greedy_make_change(6, [1, 3, 4])
    when "13" # => Make Better Change
      puts "Method source code:"
      puts "--------------------"
      RecursiveFunctions.instance_method(:make_better_change).source.display
      puts "--------------------"
      puts
      puts "Test outputs:"
      p make_better_change(100)
      p make_better_change(37)
      p make_better_change(134, [25, 10, 5, 1])
      p make_better_change(21, [12, 7, 1])
      p make_better_change(24, [10, 7, 1])
      p make_better_change(6, [1, 3, 4])
    when "0"
      puts "Thanks!"
      # sleep(1)
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