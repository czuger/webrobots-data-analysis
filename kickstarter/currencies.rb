class Currencies

  def self.value( currency )
    currency = currency.to_sym
    data = { "USD": 1.0, "GBP": 1.339594, "CAD": 0.7762, "AUD": 0.7563, "NZD": 0.6922, "EUR": 1.172656, "SEK": 0.114448, "DKK": 0.15743 }
    raise "#{currency} not found in #{data}" unless data[currency]
    data[currency]
  end
end