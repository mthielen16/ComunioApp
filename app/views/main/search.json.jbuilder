json.movies do
  json.array!(@movies) do |movie|
    json.name movie.name
    json.url movie_path(movie)
  end
end

json.players do
  json.array!(@players) do |player|
    json.name player.name
    json.url player_path(player)
  end
end

