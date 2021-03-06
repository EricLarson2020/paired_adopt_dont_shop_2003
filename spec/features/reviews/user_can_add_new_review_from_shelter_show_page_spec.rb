require 'rails_helper'

RSpec.describe "Shelter Show Page", type: :feature do
  it "Can display reviews from shelters show page" do

    shelter = Shelter.create(name: "Kitty Shelter",
                             address: "12888 Kitty Drive",
                             city: "Kitty Vale",
                             state: "Kitty Twon",
                             zip: 73429)

  visit "shelters/#{shelter.id}"
  click_link('New Review')
  expect(current_path).to eql("/shelters/#{shelter.id}/reviews/new")
  fill_in :title, with: "Great Shelter"
  fill_in :rating, with: 5
  fill_in :content, with: "Great experience friendly staff"

  click_on 'Submit Review'
  expect(current_path).to eql("/shelters/#{shelter.id}")
  expect(page).to have_content("Great Shelter")
  expect(page).to have_content(5)
  expect(page).to have_content("Great experience friendly staff")
end

  it "Can display error message if review not created" do
    shelter = Shelter.create(name: "Kitty Shelter",
                             address: "12888 Kitty Drive",
                             city: "Kitty Vale",
                             state: "Kitty Twon",
                             zip: 73429)
    visit "shelters/#{shelter.id}"
    click_link('New Review')
    expect(current_path).to eql("/shelters/#{shelter.id}/reviews/new")
    fill_in :title, with: "Horrible"
    fill_in :rating, with: 1
    click_on 'Submit Review'
    expect(current_path).to eql("/shelters/#{shelter.id}/reviews/new")
    expect(page).to have_content("Please Fill In Title, Rating, and Content")
  end
  it "Will display error message if review is not between 1 and 5" do
    shelter = Shelter.create(name: "Kitty Shelter",
                             address: "12888 Kitty Drive",
                             city: "Kitty Vale",
                             state: "Kitty Twon",
                             zip: 73429)
    visit "shelters/#{shelter.id}"
    click_link('New Review')
    expect(current_path).to eql(("/shelters/#{shelter.id}/reviews/new"))
    fill_in :title, with: "Best Place Ever"
    fill_in :rating, with: 100
    click_on 'Submit Review'
    expect(current_path).to eql("/shelters/#{shelter.id}/reviews/new")
    expect(page).to have_content("Please select a rating between 1 and 5")
  end
end


#   As a visitor,
# When I visit a shelter's show page
# I see a link to add a new review for this shelter.
# When I click on this link, I am taken to a new review path
# On this new page, I see a form where I must enter:
# - title
# - rating
# - content
# I also see a field where I can enter an optional image (web address)
# When the form is submitted, I should return to that shelter's show page
# and I can see my new review
