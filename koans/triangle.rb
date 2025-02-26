# Triangle Project Code.

# Triangle analyzes the lengths of the sides of a triangle
# (represented by a, b and c) and returns the type of triangle.
#
# It returns:
#   :equilateral  if all sides are equal
#   :isosceles    if exactly 2 sides are equal
#   :scalene      if no sides are equal
#
# The tests for this method can be found in
#   about_triangle_project.rb
# and
#   about_triangle_project_2.rb
#
def triangle(a, b, c)
  # Check for negative or zero values
  if a <= 0 || b <= 0 || c <= 0
    raise TriangleError, "Sides must be positive"
  # Check for triangle inequality violations
  elsif a + b <= c || a + c <= b || b + c <= a
    raise TriangleError, "Invalid triangle sides"
  elsif
    (a == b && a != c) || (a == c && a != b) || (b == c && b != a)
    puts "Two of the values are equal, and one is different."
    :isosceles
  else
    if a == b && b == c
      puts "All are equal"
      :equilateral
    else
      puts "None are equal."
      :scalene
    end
  end
end

# Error class used in part 2.  No need to change this code.
class TriangleError < StandardError
end
