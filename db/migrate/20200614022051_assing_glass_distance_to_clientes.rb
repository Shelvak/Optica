class AssingGlassDistanceToClientes < ActiveRecord::Migration[5.0]
  def change
    result = Historial.joins(:recetes).group('recetes.distancia').select('array_agg(cliente_id) as client_ids', 'recetes.distancia as dist')

    type = {
      'Bifocal' => [],
      'Ambos'   => [],
      'Cerca'   => [],
      'Lejos'   => []
    }

    result.each do |d|
      type[d.dist] = d.client_ids.uniq.reject(&:blank?)
    end

    type['Bifocal'] = type['Ambos']

    type.delete('Ambos')

    # Metemos en Ambos los que estan en ambos grupos
    type['Ambos']  = (type['Cerca'] & type['Lejos']) - type['Bifocal']
    type['Cerca'] -= type['Ambos']
    type['Cerca'] -= type['Bifocal']
    type['Lejos'] -= type['Ambos']
    type['Lejos'] -= type['Bifocal']

    type.each do |distance, ids|
      Cliente.where(id: ids.uniq).update_all glass_distance: distance
    end
  end
end
