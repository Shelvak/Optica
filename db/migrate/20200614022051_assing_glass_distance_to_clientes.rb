class AssingGlassDistanceToClientes < ActiveRecord::Migration[5.0]
  def change
    result = Historial.joins(:recetes).group('recetes.distancia').select('array_agg(cliente_id) as client_ids', 'recetes.distancia as dist')

    type = {
      'Ambos' => [],
      'Cerca' => [],
      'Lejos' => []
    }

    result.each do |d|
      type[d.dist] = d.client_ids.uniq
    end

    # Metemos en Ambos los que estan en ambos grupos
    type['Ambos'] += (type['Cerca'] & type['Lejos'])
    type['Cerca'] -= type['Ambos'] # Borramos los que ya estan en ambos
    type['Lejos'] -= type['Ambos']

    type.each do |distance, ids|
      Cliente.where(id: ids.uniq).update_all glass_distance: distance
    end
  end
end
