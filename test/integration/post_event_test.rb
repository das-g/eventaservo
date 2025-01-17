# frozen_string_literal: true

require "test_helper"

class PostEventTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in create(:uzanto, :admin)
    @brazilo = Country.find_by(code: "br")
    @bejo    = create(:organization, :bejo)
    @tejo    = create(:organization, :tejo)
    @evento  = create(:evento)
  end

  test "kreas novan eventon" do
    get "/e/new"
    assert_response :success

    assert_difference("Event.count", 1) do
      post "/e",
           params: {
             event: {
               title: Faker::Book.title, description: Faker::Lorem.sentence, content: Faker::Lorem.paragraph,
               city: "Ĵoan-Pesoo", country_id: @brazilo.id, site: Faker::Internet.url,
               date_start: "17/07/2019", date_end: "17/07/2019"
             },
             time_start: "14:00", time_end: "16:00"
           }
      assert_response :redirect
      follow_redirect!
      assert_response :success
      assert_select "div.flash-alert-box", /Evento sukcese kreita/
    end

    evento = Event.last
    assert_equal "Ĵoan-Pesoo", evento.city
    assert_equal "America/Fortaleza", evento.time_zone
    assert_equal "17/07/2019", evento.komenca_tago
    assert_equal "14:00", evento.komenca_horo
    assert_equal "17/07/2019", evento.fina_tago
    assert_equal "16:00", evento.fina_horo
  end

  test "aldonas_organizon_al_evento" do
    get edit_event_path(@evento.code)
    patch event_path(@evento.code),
          params: {
            event: { title: Faker::Book.title },
            organization_ids: [@bejo.id, @tejo.id], code: @evento.code
          }
    assert_equal 2, @evento.reload.organizations.count
  end

  test "forvishas_organizon_el_evento" do
    get edit_event_path(@evento.code)
    patch event_path(@evento.code),
          params: {
            event: { title: Faker::Book.title },
            organization_ids: nil, code: @evento.code
          }

    assert_equal 0, @evento.reload.organizations.count
  end
end
