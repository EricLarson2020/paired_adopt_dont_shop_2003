require 'rails_helper'

describe "Application Show Page" do
  it "can revoke an approved application" do
    shelter = Shelter.create({name: "Happy Shelter",
                          address: "12980 Grover Drive",
                          city: "Doggy Vale",
                          state: "Colorado",
                          zip: 74578})

    pet1 = shelter.pets.create(image: "cat.jpg", name: "Garfield", approximate_age: 1, sex: "Male", description: "Cute cat!")
    pet2 = shelter.pets.create(image: "cute.jpg", name: "Spot", approximate_age: 2, sex: "Male", description: "Spotted Puppy!")
    pet3 = shelter.pets.create(image: "kitten.jpg", name: "Kitty", approximate_age: 2, sex: "Female", description: "Adorable kitten")

    application1 = Application.create({
        name: "Bob",
        address: "222 Bob Road",
        city: "Bob City",
        state: "Bob State",
        zip: "39233",
        phone: "30332432",
        description: "Love, pets have lots of space for them"
      })

    application2 = Application.create({
      name: "Chris",
      address: "222 Chris Road",
      city: "Chris City",
      state: "Chris State",
      zip: "33233",
      phone: "3033897987",
      description: "Likes pets"
    })

    application3 = Application.create({
        name: "Jim",
        address: "222 Jim Road",
        city: "Jim City",
        state: "Jim State",
        zip: "23423",
        phone: "452343222",
        description: "Pet lover"
      })
    application1.pets << pet1
    application1.pets << pet2
    application2.pets << pet1
    application3.pets << pet1
    visit "/applications/#{application1.id}"
    check(pet1.id)
    click_button("Approve Application for All Selected Pets")

    visit "/applications/#{application1.id}"

    within ".pet-#{pet1.id}" do
      expect(page).to_not have_link("Approve Pet")
      click_link("Unapprove This Pet's Application")
    end

    expect(current_path).to eq("/applications/#{application1.id}")

    within ".pet-#{pet1.id}" do
      expect(page).to have_link("Approve Pet")
    end

    visit "/pets/#{pet1.id}"
    expect(page).to_not have_content("On Hold")
    expect(page).to have_content("adoptable")
  end
end
