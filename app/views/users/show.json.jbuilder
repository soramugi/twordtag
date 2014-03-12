json.array!(@tags) do |j,(word,count)|
  j.word word
  j.count count
end
