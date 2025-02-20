class Syncterrifier::Document < Syncterrifier::Model
  endpoint :documents

  def contents
    client.get_file("#{url}/#{id}/contents")
  end
end
