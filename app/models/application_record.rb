class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.find_all(search_data)
    param = search_data.keys.first
    value = search_data.values.first

    return [] if param.nil?

    if search_data[:name] || search_data[:description]
      where("#{param} ILIKE (?)", "%#{value}%")
    else
      where("#{param} = (?)", value)
    end
  end
end
