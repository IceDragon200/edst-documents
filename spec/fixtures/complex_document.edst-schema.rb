div :user do
  tag :name, type: 'string'
  # everything in edst is a String, there are no integer
  tag :age, type: 'string'
  tag :gender, enum: ['Male', 'Female', 'Unknown']
  div :likes, type: 'list:string'
  div :dislikes, type: 'list:string'
  div :things do
    schema 'thing', multiple: true
  end
  div :notes do
    div :note, variant: true
  end
end
