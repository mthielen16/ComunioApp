json.movies do
  json.array!(@movies) do |movie|
    json.name movie.name
    json.url movie_path(movie)
  end
end

