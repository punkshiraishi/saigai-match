module Gmap
  extend ActiveSupport::Concern

  included do
    def build_markers(microposts)
      Gmaps4rails.build_markers(microposts) do |micropost, marker|
        marker.lat micropost.latitude
        marker.lng micropost.longitude
        # marker.infowindow "<div class='map_user_name'>#{micropost.user.name}</div>
        #                    <br>欲しい物資：#{micropost.content}
        #                    <br>#{micropost.created_at}"
        marker.infowindow render_to_string(partial: 'microposts/micropost_in_map', locals: {micropost: micropost})
        marker.picture url: ApplicationController.helpers.gravatar_url(micropost.user, 32), width: 32, height: 32
      end
    end
  end
end
