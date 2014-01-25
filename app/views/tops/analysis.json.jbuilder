json.array!(@nodes.mincost_path) do |node|
  json.extract! node.word, :surface
  json.extract! node.word.left, :text
end
