# rake db:populate
# rake db:add_guids
# rake input_names


namespace :db do
  desc "Erase and fill Data Tables"
  task :populate => :environment do

    include FactoryBot::Syntax::Methods

    # exception_deletes = [User]
    exception_deletes = []

    Rails.application.eager_load!
    ActiveRecord::Base.descendants.each do |m|
      begin
        m.delete_all unless exception_deletes.include?(m)
      rescue Exception => e
        #puts "Could not delete #{m.to_s} - #{e.message}"
      end
    end

    itg = Tenant.create({name: 'ITG', from_email: 'ch.walker@gmail.com'})

    # clients = [
    #     ["Elliott"],
    #     ["Another Client"],
    #     ["Pike Energy"],
    # ]
    clients = [
        ["Elliott"]
    ]

    customers = [
      ["Test Customer 1"], 
      ["Test Customer 2"]
    ]

    hotels = [
        ["DoublelTree By Hilton Hotel - Universal Studio", "5780 Major Blvd", "Orlando", "Florida", "32819", 66.0],
        ["Hilton Anatole", "2201 N Stemmons Fwy", "Dallas", "Texas", "75207", 86.0],
        ["Hampton Inn & Suites Montgomery-Downtown", "100 Commerce St", "Montgomery", "Alabama", "36104", 48.0],
        ["Hilton Atlanta", "255 Courtland St NE", "Atlanta", "Georgia", "30303", 55.0],
        ["Hilton Knoxville", "501 W Church Ave", "Knoxville", "Tennessee", "37902", 61.0],
        ["The Seelbach Hilton Louisville", "500 S 4th St", "Louisville", "Kentucky", "40202", 88.0],
        ["AC Hotel by Marriott Chapel Hill Downtown", "214 W Rosemary St", "Chapel Hill", "North Carolina", "27516", 68.0],
        ["Hilton Knoxville", "501 W Church Ave", "Knoxville", "Tennessee", "37902", 67.0],
    ]

    city_states = [
        ["Orlando","Florida"],
        ["Dallas","Texas"],
        ["Montgomery","Alabama"],
        ["Atlanta","Georgia"],
        ["Knoxville","Tennessee"],
        ["Lousiville","Kentucky"],
        ["Chapel Hill","North Carolina"],
        ["Knoxville","Tennessee"]
    ]

    date_ranges = [
        ["2020-11-30","2020-12-02"],
        ["2020-12-01","2020-12-01"],
        ["2020-12-02","2020-12-03"],
        ["2020-12-07","2020-12-10"],
        ["2020-12-08","2020-12-11"],
        ["2020-12-12","2020-12-17"],
        ["2020-12-17","2020-12-20"],
        ["2020-12-19","2020-12-23"]
    ]

    users = [
        ["Casey","Walker","casey@gmail.com"],
        ["Colt","Walker","colt@gmail.com"],
        ["Eli","Walker","eli@gmail.com"],
        ["Grace","Walker","grace@gmail.com"],
        ["Luke","Walker","luke@gmail.com"],
        ["Don","Walker","don@gmail.com"],
        ["Carol","Walker","carol@gmail.com"],
        ["Cade","Walker","cade@gmail.com"]
    ]

    staff = [
        ["Lee", "Howard", "lee@gmail.com"],
        ["Naresha", "Howard", "naresha@gmail.com"],
        ["Chris", "Walker", "ch.walker@gmail.com"],
        ["Matt", "Howard", "matt@gmail.com"]
    ]

    clients.each do |c|
      Client.create({name: c[0], tenant: itg})
    end

    # customers.each do |c|
    #   Customer.create({c[0], client: Client.find_by_name('Elliott')})
    # end
    Customer.create({name: 'Test Customer 1', client: Client.find_by_name('Elliot')})


    users.each do |u|
      user_email = u[2]
      user = User.find_by_email(user_email)
      User.create({first: u[0], last: u[1], email: user_email, password:'123123123', password_confirmation: '123123123', client: Client.find_by_name(clients[rand(0..clients.length-1)])}) if user.nil?
    end

    staff.each do |u|
      user_email = u[2]
      user = User.find_by_email(user_email)
      User.create({first: u[0], last: u[1], email: user_email, password:'123123123', password_confirmation: '123123123', tenant: itg, confirmed_at: DateTime.now}) if user.nil?
    end

    chris = User.find_by_email('ch.walker@gmail.com')
    chris.is_foreman = true
    chris.save
    

    # User.create({first: u[0], last: u[1], email: user_email, password:'123123123', password_confirmation: '123123123', tenant: itg, confirmed_at: DateTime.now}) if user.nil?
    hotels.each do |h|
      Hotel.create({tenant: itg, name: h[0], address: h[1], city: h[2], state: h[3], zip: h[4], rate: h[5]})
    end

    # Create a few requests
    100.times.each do |a|
      i = rand(0..city_states.length-1)
      i2 = rand(0..city_states.length-1)
      i3 = rand(0..city_states.length-1)

      dates = date_ranges[i]
      city_state = city_states[i2]
      user_hash = users[i3]
      hotel = hotels[i2]

      user = User.find_by_email(user_hash[2])

      br = BookingRequest.create({tenant: itg, requestor: user, client: user.client, date_from: dates[0], date_to: dates[1], city: city_state[0], state: city_state[1], customer: Customer.find_by_name('Test Customer 1')})

      if i < city_states.length-2
        confirmation_number = '123'
        assignee = User.find_by_email(staff[rand(0..2)][2])
        br.update({assignee: assignee})
        hotel = Hotel.find_by_name(hotel[0])

        Booking.create({
          confirmation_number: confirmation_number,
          booking_request: br,
          client: user.client,
          hotel: hotel,
          assignee: assignee,
          rate: hotel.rate,
          tax: hotel.rate * 0.15
        })
      end
    end


  end
end