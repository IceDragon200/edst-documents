class Array
  # Joins the contents of the Array, the last element will be or ELEMENT,
  # instead of a comma.
  #
  # @return [String]
  def choice_join
    tail = last
    slice(0, size - 1).join(', ') + " or #{tail}"
  end
end
