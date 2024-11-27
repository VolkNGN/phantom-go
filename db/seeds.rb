require 'open-uri'

# URL d'exemple pour les images de profil Cloudinary
profile_pictures = [
  "https://res.cloudinary.com/devmujjf6/image/upload/v1732706519/1998-mulan-01_obl5u9.jpg",
  "https://res.cloudinary.com/devmujjf6/image/upload/v1732706725/latest_rystpk.png",
  "https://res.cloudinary.com/devmujjf6/image/upload/v1732706487/1989-ariel-001_nuptnt.jpg",
  "https://res.cloudinary.com/devmujjf6/image/upload/v1732706601/latest_z90jge.png",
  "https://res.cloudinary.com/devmujjf6/image/upload/v1732706788/latest_w2ngly.png"
]

# Données fictives pour les utilisateurs
users_data = [
  { first_name: "Mulan", last_name: "Fa", email: "Mulan.Fa@example.com" },
  { first_name: "Elsa", last_name: "Arendelle", email: "Elsa.Arendelle@example.com" },
  { first_name: "Ariel", last_name: "Triton", email: "Ariel.Triton@example.com" },
  { first_name: "Tarzan", last_name: "Greystoke", email: "Tarzan.Greystoke@example.com" },
  { first_name: "Miguel", last_name: "Rivera", email: "Miguel.Rivera@example.com" }
]

# Création des joueurs
users_data.each_with_index do |user, i|
  player = Player.create!(
    first_name: user[:first_name],
    last_name: user[:last_name],
    email: user[:email],
    password: "123456",
    password_confirmation: "123456"
  )

  # Associer une photo de profil via Active Storage
  player.avatar.attach(
    io: URI.open(profile_pictures[i]),
    filename: "profile_picture_#{i + 1}.jpg",
    content_type: "image/jpeg"
  )
end

puts "5 joueurs fictifs créés avec succès avec leurs photos de profil !"
