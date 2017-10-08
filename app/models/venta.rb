class Venta < ActiveRecord::Base

  def self.recalculate_all_history
    Venta.transaction do
      Cliente.all.update_all(gastado: 0.0)
      Historial.all.map(&:assign_to_global_sales)
      Bill.all.map(&:assign_to_global_sales)
      # CreditNote.all.map(&:assign_to_global_sales)
    end
  end

  def increase_by_type(sell_type, amount)
    case sell_type
      when :contact
        self.contact_quantity += 1
        self.contact_amount += amount
      when :floating
        self.floating_quantity += 1
        self.floating_amount += amount
      else
        self.others_quantity += 1
        self.others_amount += amount
    end
  end

  def decrease_by_type(sell_type, amount)
    case sell_type
      when :contact
        self.contact_quantity -= 1
        self.contact_amount -= amount
      when :floating
        self.floating_quantity -= 1
        self.floating_amount -= amount
      else
        self.others_quantity -= 1
        self.others_amount -= amount
    end
  end

  def total_amount
    [self.contact_amount, self.floating_amount, self.others_amount].sum
  end

  def total_quantity
    [self.contact_quantity, self.floating_quantity, self.others_quantity].sum
  end
end
