require 'open-uri'

# URLs des images de profil
profile_pictures = [
  "https://res.cloudinary.com/devmujjf6/image/upload/v1733328386/1998-mulan-01_huefet.jpg",
  "https://res.cloudinary.com/devmujjf6/image/upload/v1733328386/Elsa_lezciz.webp",
  "https://res.cloudinary.com/devmujjf6/image/upload/v1733328387/Ariel_iwjkds.webp",
  "https://res.cloudinary.com/devmujjf6/image/upload/v1733328386/Profile_-_Tarzan_iiivph.webp",
  "https://res.cloudinary.com/devmujjf6/image/upload/v1733328386/Profile_-_Miguel_Rivera_wdj76a.webp"
]

# Seed des joueurs (Players)
players = [
  { username: "Mulan", email: "mulan@example.com", password: "password", first_name: "Mulan", last_name: "Fa" },
  { username: "Elsa", email: "elsa@example.com", password: "password", first_name: "Elsa", last_name: "Arendelle" },
  { username: "Ariel", email: "ariel@example.com", password: "password", first_name: "Ariel", last_name: "Triton" },
  { username: "Tarzan", email: "tarzan@example.com", password: "password", first_name: "Tarzan", last_name: "Greystoke" },
  { username: "Miguel", email: "miguel@example.com", password: "password", first_name: "Miguel", last_name: "Rivera" }
]

puts "Creating players..."
players = players.each_with_index.map do |player_data, index|
  player = Player.find_or_create_by!(email: player_data[:email]) do |p|
    p.username = player_data[:username]
    p.first_name = player_data[:first_name]
    p.last_name = player_data[:last_name]
    p.password = player_data[:password]
  end

  # Attacher une photo de profil si non attachée
  unless player.avatar.attached?
    player.avatar.attach(
      io: URI.open(profile_pictures[index]),
      filename: "profile_picture_#{index + 1}.jpg",
      content_type: "image/jpeg"
    )
    puts "Avatar attached for '#{player.first_name} #{player.last_name}'."
  end

  puts "Player '#{player.username}' created with profile picture."
  player
end

# Seed des badges
badges = [
  { name: "Beginner", description: "Completed the first game." },
  { name: "Strategist", description: "Won 10 games." },
  { name: "Master", description: "Won 50 games." }
]

puts "Creating badges..."
badges.each do |badge_data|
  badge = Badge.find_or_create_by!(name: badge_data[:name]) do |b|
    b.description = badge_data[:description]
  end
  puts "Badge '#{badge.name}' created."
end

# Seed des achievements
puts "Creating achievements..."
Player.all.each_with_index do |player, index|
  badge = Badge.find_by(name: badges[index % badges.length][:name])
  Achievement.find_or_create_by!(player: player, badge: badge)
  puts "Achievement for player '#{player.username}' with badge '#{badge.name}' created."
end

# Seed des disponibilités (Availabilities)
puts "Creating availabilities..."
Player.all.each do |player|
  Availability.find_or_create_by!(player: player) do |availability|
    availability.status = "available"
  end
  puts "Availability for player '#{player.username}' created."
end

puts "5 joueurs fictifs créés avec succès avec leurs photos de profil !"

# Seed des parties (Games)
puts "Creating games..."
game1 = Game.find_or_create_by!(black_player: players[0], white_player: players[1]) do |game|
  game.status = "ongoing"
end
game2 = Game.find_or_create_by!(black_player: players[2], white_player: players[3]) do |game|
  game.status = "finished"
  game.winner_id = players[2].id
end
puts "Game 1 created with #{game1.black_player.username} vs #{game1.white_player.username}."
puts "Game 2 created with #{game2.black_player.username} vs #{game2.white_player.username}. Winner: #{game2.white_player.username}."

puts "Seeding complete!"
