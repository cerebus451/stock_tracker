class Stock < ActiveRecord::Base
  
  has_many :user_stocks
  has_many :users, through: :user_stocks

  def self.find_by_ticker(ticker_symbol)
    return where(ticker: ticker_symbol).first
  end
  
  def self.new_from_lookup(ticker_symbol)
    lookup_stock = StockQuote::Stock.quote(ticker_symbol)
    return nil unless lookup_stock.name
    new_stock = new(ticker: lookup_stock.symbol, name: lookup_stock.name)
    new_stock.last_price = new_stock.price
    return new_stock
  end
  
  def price
    closing_price = StockQuote::Stock.quote(ticker).close
    return "#{closing_price} (Closing)" if closing_price
    
    opening_price = StockQuote::Stock.quote(ticker).open
    return "#{opening_price} (Opening)" if opening_price
    
    return "Unavailable"
  end
  
end
