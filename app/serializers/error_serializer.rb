class ErrorSerializer
  def self.serialize(error)
    { errors: [error].flatten }.to_json
  end
end
