module Gmap
  extend ActiveSupport::Concern

  included do

    def build_markers(microposts)
      Gmaps4rails.build_markers(microposts) do |micropost, marker|
        marker.lat micropost.latitude
        marker.lng micropost.longitude
        marker.infowindow micropost.content
        marker.json({ picture: { url: ApplicationController.helpers.gravatar_url(micropost.user, 32), width: 32, height: 32 } })
      end
    end

  end
end
