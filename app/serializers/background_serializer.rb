class BackgroundSerializer
  include FastJsonapi::ObjectSerializer
  set_id { nil }
  set_type :image
  attributes :location, :image_url, :credit
end
