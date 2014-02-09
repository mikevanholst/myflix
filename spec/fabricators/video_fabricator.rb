Fabricator(:video)  do
  title { Faker::Lorem.words(5).join(" ") }    
  description { Faker::Lorem.paragraph(2)} 
end

Fabricator(:video_with_category, from: :video) do
  category
end
