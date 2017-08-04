
json.players do
  json.array!(@players) do |player|
    json.name player.name
    json.verein player.verein
    
    json.url player_path(player)
  end
end



