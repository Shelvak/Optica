class AssingGlassDistanceToClientes < ActiveRecord::Migration[5.0]
  def change
    result = Historial.joins(:recetes).group('recetes.distancia').select('array_agg(cliente_id) as client_ids', 'recetes.distancia as dist')

    type = {
      'Multifocal' => [],
      'Ambos'   => [],
      'Cerca'   => [],
      'Lejos'   => []
    }

    result.each do |d|
      type[d.dist] = d.client_ids.uniq.reject(&:blank?)
    end

    type['Multifocal'] = type['Ambos']

    type.delete('Ambos')

    # Metemos en Ambos los que estan en ambos grupos
    type['Ambos']  = (type['Cerca'] & type['Lejos']) - type['Multifocal']
    type['Cerca'] -= type['Ambos']
    type['Cerca'] -= type['Multifocal']
    type['Lejos'] -= type['Ambos']
    type['Lejos'] -= type['Multifocal']

    type.each do |distance, ids|
      Cliente.where(id: ids.uniq).update_all glass_distance: distance
    end
  end
end
