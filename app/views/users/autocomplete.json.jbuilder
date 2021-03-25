json.users do
    json.array(@users) do |user|
        json.name = user.full_name
        json.id = user.id
    end
end