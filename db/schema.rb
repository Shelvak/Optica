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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130716203026) do

  create_table "clientes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "nombre"
    t.string   "apellido"
    t.string   "documento"
    t.string   "direccion"
    t.integer  "telefono"
    t.string   "celular"
    t.string   "email"
    t.date     "nacimiento"
    t.string   "ocupacion"
    t.text     "actividad",     limit: 65535
    t.string   "recomendado"
    t.text     "salud",         limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cantidadrecom",                                        default: 0
    t.decimal  "gastado",                     precision: 15, scale: 2, default: "0.0"
    t.string   "lente"
    t.index ["documento"], name: "index_clientes_on_documento", unique: true, using: :btree
  end

  create_table "historials", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.boolean  "tipolente",                                            default: false
    t.string   "lente"
    t.string   "colorlente"
    t.string   "armazon"
    t.string   "cristales"
    t.text     "observaciones", limit: 65535
    t.text     "uso",           limit: 65535
    t.text     "seguimiento",   limit: 65535
    t.decimal  "precio",                      precision: 15, scale: 2, default: "0.0"
    t.integer  "orden"
    t.integer  "cliente_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "doctor"
    t.string   "dist_intra"
    t.date     "entrega"
    t.string   "factura"
    t.boolean  "retirado",                                             default: false
    t.string   "altura"
    t.string   "formapago"
  end

  create_table "recetes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.boolean  "ojo"
    t.decimal  "esferico",     precision: 15, scale: 2
    t.decimal  "cilindrico",   precision: 15, scale: 2
    t.decimal  "eje",          precision: 15, scale: 2
    t.decimal  "diametro",     precision: 15, scale: 2
    t.decimal  "adicion",      precision: 15, scale: 2
    t.string   "av"
    t.string   "distancia"
    t.boolean  "receta"
    t.integer  "historial_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cb"
    t.string   "quera"
  end

  create_table "user_sessions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "login"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.boolean  "admin"
    t.index ["login"], name: "index_users_on_login", unique: true, using: :btree
  end

  create_table "venta", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "mes"
    t.integer  "anio"
    t.decimal  "vendido",        precision: 15, scale: 2, default: "0.0"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cantvendida",                             default: 0
    t.integer  "cant_contacto",                           default: 0
    t.integer  "cant_flotante",                           default: 0
    t.decimal  "venta_contacto", precision: 15, scale: 2, default: "0.0"
    t.decimal  "venta_flotante", precision: 15, scale: 2, default: "0.0"
  end

end
