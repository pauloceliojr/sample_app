namespace :db do
  desc 'Fill database with sample data'
  task populate: :environment do
    puts 'Iniciando tarefa.'
    medir_tempo('Popular usuarios predefinidos') { popular_usuarios_predefinidos }
    medir_tempo('Popular outros usuarios') { popular_outros_usuarios }
    medir_tempo('Popular microposts') { popular_microposts }
    medir_tempo('Popular relationships') { popular_relationships }
    puts 'Tarefa finalizada com sucesso.'
  end
end

def popular_usuarios_predefinidos
  puts '-- Criando user Paulo Celio Junior.'
  User.create!(name: 'Paulo Célio Júnior',
               email: 'pauloceliojr@gmail.com',
               password: '123456',
               password_confirmation: '123456',
               admin: true)
  puts '-- User Paulo Celio Junior criado.'

  puts '-- Criando user Example User.'
  User.create!(name: 'Example User',
               email: 'example@railstutorial.org',
               password: '123456',
               password_confirmation: '123456',
               admin: true)
  puts '-- User Example User criado.'

end

def popular_outros_usuarios
  puts '-- Criando outros usuarios.'
  99.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password = '123456'
    User.create!(name: name,
                 email: email,
                 password: password,
                 password_confirmation: password)
  end
  puts '-- Outros usuarios criados.'
end

def popular_microposts
  puts '-- Criando microposts.'
  users = User.limit(7)
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.microposts.create!(content: content) }
  end
  puts '-- Microposts.'
end

def popular_relationships
  puts '-- Criando relationships.'
  users = User.all
  user = users.first
  followed_users = users[2..50]
  followers = users[3..50]
  followed_users.each { |followed| user.follow!(followed)}
  followers.each { |follower| follower.follow!(user) }
  puts '-- Relationships criados.'
end

def medir_tempo(nome_etapa="Nao identificada")
  puts "- Etapa '#{nome_etapa}' iniciada."
  inicio = Time.now
  yield
  puts "- Etapa '#{nome_etapa}' completada em #{Time.now - inicio} segundos."
end