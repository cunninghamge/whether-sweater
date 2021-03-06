class ErrorSerializer
  def self.serialize(error)
    { errors: [error] }.to_json
  end
end
