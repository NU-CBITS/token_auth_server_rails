# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Participant tokens", type: :feature do
  scenario "User creates a configuration token" do
    visit "/token_auth/entities/1/tokens"

    within "#config-token" do
      click_on "Create"
    end

    expect(page).to have_content("Successfully saved Configuration token")

    within "#config-token" do
      expect(page).not_to have_button "Create"
      expect(page).to have_button "Destroy"
    end
  end

  scenario "User destroys a configuration token" do
    TokenAuth::ConfigurationToken.create entity_id: 1
    visit "/token_auth/entities/1/tokens"

    within "#config-token" do
      click_on "Destroy"
    end

    expect(page).to have_content("Successfully destroyed Configuration token")

    within "#config-token" do
      expect(page).not_to have_button "Destroy"
      expect(page).to have_button "Create"
    end
  end

  scenario "User disables an authentication token" do
    TokenAuth::AuthenticationToken.create entity_id: 1, client_uuid: 415
    visit "/token_auth/entities/1/tokens"

    within "#auth-token" do
      click_on "Disable"
    end

    expect(page).to have_content("Successfully saved Authentication token")

    within "#auth-token" do
      expect(page).not_to have_button "Disable"
      expect(page).to have_button "Enable"
    end
  end

  scenario "User enables an authentication token" do
    TokenAuth::AuthenticationToken.create(entity_id: 1,
                                          client_uuid: 415,
                                          is_enabled: false)
    visit "/token_auth/entities/1/tokens"

    within "#auth-token" do
      click_on "Enable"
    end

    expect(page).to have_content("Successfully saved Authentication token")

    within "#auth-token" do
      expect(page).not_to have_button "Enable"
      expect(page).to have_button "Disable"
    end
  end

  scenario "User destroys an authentication token" do
    TokenAuth::AuthenticationToken.create entity_id: 1, client_uuid: 415
    visit "/token_auth/entities/1/tokens"

    within "#auth-token" do
      click_on "Destroy"
    end

    expect(page).to have_content("Successfully destroyed Authentication token")
    expect(page).not_to have_selector "#auth-token"
  end
end
