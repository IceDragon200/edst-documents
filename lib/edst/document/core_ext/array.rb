class Array
  def choice_join
    tail = last
    slice(0, size - 1).join(', ') + " or #{tail}"
  end
end
