%w{world kitty}.each { |word| Article.create(title: word.titleize).index("hello #{word}") }
