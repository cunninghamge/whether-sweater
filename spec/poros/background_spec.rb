require 'rails_helper'

RSpec.describe Background do
  it 'exists and has attributes' do
    null = nil
    location = 'portland,or'
    data = {
      "id": "pbr1-8LmvMg",
      "created_at": "2018-07-06T12:10:37-04:00",
      "updated_at": "2021-03-06T00:03:54-05:00",
      "promoted_at": null,
      "width": 2400,
      "height": 4267,
      "color": "#d9c0c0",
      "blur_hash": "LfFsGSa}R*of~XoKj[WC^PkCayoL",
      "description": "This is the view from the Pittock Mansion in Portland, Oregon. Right before the sunset, the city’s skyline is at its absolute best with Mount Hood with all its glory. I know there are many many versions of the same photo on the internet but who cares. It is a beautiful view that deserves the fame.",
      "alt_description": "aerial photo of high rise buildings",
      "urls": {
        "raw": "https://images.unsplash.com/photo-1530891671629-3a053324e4f7?ixid=MXwyMTI3ODZ8MHwxfHNlYXJjaHwxfHxwb3J0bGFuZCxvcnxlbnwwfHx8&ixlib=rb-1.2.1",
        "full": "https://images.unsplash.com/photo-1530891671629-3a053324e4f7?crop=entropy&cs=srgb&fm=jpg&ixid=MXwyMTI3ODZ8MHwxfHNlYXJjaHwxfHxwb3J0bGFuZCxvcnxlbnwwfHx8&ixlib=rb-1.2.1&q=85",
        "regular": "https://images.unsplash.com/photo-1530891671629-3a053324e4f7?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwyMTI3ODZ8MHwxfHNlYXJjaHwxfHxwb3J0bGFuZCxvcnxlbnwwfHx8&ixlib=rb-1.2.1&q=80&w=1080",
        "small": "https://images.unsplash.com/photo-1530891671629-3a053324e4f7?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwyMTI3ODZ8MHwxfHNlYXJjaHwxfHxwb3J0bGFuZCxvcnxlbnwwfHx8&ixlib=rb-1.2.1&q=80&w=400",
        "thumb": "https://images.unsplash.com/photo-1530891671629-3a053324e4f7?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwyMTI3ODZ8MHwxfHNlYXJjaHwxfHxwb3J0bGFuZCxvcnxlbnwwfHx8&ixlib=rb-1.2.1&q=80&w=200"
      },
      "links": {
        "self": "https://api.unsplash.com/photos/pbr1-8LmvMg",
        "html": "https://unsplash.com/photos/pbr1-8LmvMg",
        "download": "https://unsplash.com/photos/pbr1-8LmvMg/download",
        "download_location": "https://api.unsplash.com/photos/pbr1-8LmvMg/download"
      },
      "categories": [],
      "likes": 391,
      "liked_by_user": false,
      "current_user_collections": [],
      "sponsorship": null,
      "user": {
        "id": "KQfA_y8mqrc",
        "updated_at": "2021-03-03T23:45:24-05:00",
        "username": "umit1010",
        "name": "Umit Aslan",
        "first_name": "Umit",
        "last_name": "Aslan",
        "twitter_username": null,
        "portfolio_url": null,
        "bio": "chicago, stuff. ig: @umit.1010 ",
        "location": "Chicago, IL",
        "links": {
          "self": "https://api.unsplash.com/users/umit1010",
          "html": "https://unsplash.com/@umit1010",
          "photos": "https://api.unsplash.com/users/umit1010/photos",
          "likes": "https://api.unsplash.com/users/umit1010/likes",
          "portfolio": "https://api.unsplash.com/users/umit1010/portfolio",
          "following": "https://api.unsplash.com/users/umit1010/following",
          "followers": "https://api.unsplash.com/users/umit1010/followers"
        },
        "profile_image": {
          "small": "https://images.unsplash.com/profile-1530824346059-6bbaf872c287?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=32&w=32",
          "medium": "https://images.unsplash.com/profile-1530824346059-6bbaf872c287?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=64&w=64",
          "large": "https://images.unsplash.com/profile-1530824346059-6bbaf872c287?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=128&w=128"
        },
        "instagram_username": "umit.1010",
        "total_collections": 0,
        "total_likes": 88,
        "total_photos": 5,
        "accepted_tos": true,
        "for_hire": false
      },
      "tags": []
    }
    background = Background.new(data, location, BackgroundService.source_info)

    expect(background).to be_a(Background)
    expect(background).to have_attributes(
      location: 'portland,or',
      image_url: data[:urls][:raw],
      credit: {
        source: 'Unsplash',
        source_url: "https://unsplash.com/?utm_source=weather-sweater&utm_medium=referral",
        photographer: data[:user][:name],
        photographer_url: "#{data[:user][:links][:html]}?utm_source=weather-sweater&utm_medium=referral"
      }
    )
  end
end
