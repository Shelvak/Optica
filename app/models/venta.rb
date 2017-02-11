class Venta < ActiveRecord::Base

  def self.last_year_by_month
    dates = Historial.where(created_at: 1.year.ago..Time.now).map do |historial|
      [historial.created_at.year, historial.created_at.month].join('-')
    end.uniq.sort


    grouped.map do |date, historials|
      byebug
      glasses = historials.flotantes
      contacts = historials.contactos

      OpenStruct.new({
        date: Date.new(*date.split('-')),
        glasses: {
          count: glasses.count,
          amount: glasses.sum(:precio)
        },
        contacts: {
          count: contacts.count,
          amount: contacts.sum(:price)
        }
      })
    end
  end
end
