def markdownFromBase(path)
  return Kramdown::Document.new(File.read(path + ".md")).to_html
end
