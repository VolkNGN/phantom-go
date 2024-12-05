require 'open-uri'

# URLs des images de profil
profile_pictures = [
  "https://res.cloudinary.com/devmujjf6/image/upload/v1733394775/Elsa_sht6aa.webp",
  "https://res.cloudinary.com/devmujjf6/image/upload/v1733394997/sai___hikaru_no_go_by_a_key_hit_ddcgtdj-fullview_u8naaa.jpg"
]

# Seed des joueurs (Players)
players = [
  { username: "Elsa", email: "elsa@example.com", password: "password", first_name: "Elsa", last_name: "Arendelle" },
  { username: "Sai", email: "sai@example.com", password: "password", first_name: "Sai", last_name: "Fujiwara" }
]

puts "Creating players..."
players.each_with_index do |player_data, index|
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
end

# Seed des disponibilités (Availabilities)
puts "Creating availabilities..."
Player.all.each do |player|
  Availability.find_or_create_by!(player: player) do |availability|
    availability.status = "available"
  end
  puts "Availability for player '#{player.username}' created."
end

puts "2 joueurs fictifs (Elsa et Sai) créés avec succès avec leurs photos de profil !"
puts "Seeding complete!"
