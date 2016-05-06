json.array!(@scripts) do |script|
  json.extract! script, :id, :nom
  json.url script_url(script, format: :json)
end
