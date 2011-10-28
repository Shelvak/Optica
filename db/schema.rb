# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111027172847) do

  create_table "clientes", :force => true do |t|
    t.string   "nombre"
    t.string   "apellido"
    t.string   "documento"
    t.string   "direccion"
    t.integer  "telefono"
    t.string   "celular"
    t.string   "email"
    t.date     "nacimiento"
    t.string   "ocupacion"
    t.text     "actividad"
    t.string   "recomendado"
    t.text     "salud"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clientes", ["documento"], :name => "index_clientes_on_documento", :unique => true

  create_table "historials", :force => true do |t|
    t.boolean  "tipolente",                                    :default => false
    t.string   "lente"
    t.string   "colorlente"
    t.string   "armazon"
    t.string   "cristales"
    t.text     "observaciones"
    t.text     "uso"
    t.text     "seguimiento"
    t.decimal  "precio",        :precision => 15, :scale => 2, :default => 0.0
    t.integer  "orden"
    t.integer  "cliente_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "receta", :force => true do |t|
    t.boolean  "ojo"
    t.decimal  "esferico"
    t.decimal  "cilindrico"
    t.integer  "eje"
    t.decimal  "diametro"
    t.decimal  "adicion"
    t.string   "av"
    t.boolean  "distancia"
    t.string   "receta"
    t.integer  "historial_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
