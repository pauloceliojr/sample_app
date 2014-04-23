namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name: "Paulo Célio Júnior",
                 email: "pauloceliojr@gmail.com",
                 password: "123456",
                 password_confirmation: "123456",
                 admin: true)
    User.create!(name: "Example User",
                 email: "example@railstutorial.org",
                 password: "123456",
                 password_confirmation: "123456",
                 admin: true)
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "123456"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end

    users = User.limit(7)
    50.times do
      content = Faker::Lorem.sentence(5)
      users.each { |user| user.microposts.create!(content: content) }
    end
  end
end