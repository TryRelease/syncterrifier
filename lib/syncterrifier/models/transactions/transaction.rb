class Syncterrifier::Transaction < Syncterrifier::Model
  endpoint :transactions

  def self.posted(**options)
    self.all(path: 'posted', **options)
  end

  def self.pending(**options)
    self.all(path: 'pending', **options)
  end
end
