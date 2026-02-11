class AddFechafinToTarea < ActiveRecord::Migration[5.1]
  def change
    add_column :tareas, :fechafin, :date
    add_column :tareas, :fecha_finalizado, :date
  end
end
