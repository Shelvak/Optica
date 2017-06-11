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

ActiveRecord::Schema.define(version: 20170611173008) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bill_items", force: :cascade do |t|
    t.integer  "bill_id",     null: false
    t.string   "description", null: false
    t.decimal  "amount",      null: false
    t.datetime "created_at"
    t.index ["bill_id"], name: "index_bill_items_on_bill_id", using: :btree
  end

  create_table "bills", force: :cascade do |t|
    t.integer  "client_id",                              null: false
    t.integer  "historial_id"
    t.integer  "number",                                 null: false
    t.string   "cae",                                    null: false
    t.string   "sale_point"
    t.date     "billed_date"
    t.date     "cae_due_date"
    t.json     "afip_response"
    t.decimal  "amount",        precision: 15, scale: 2
    t.decimal  "vat_amount",    precision: 15, scale: 2
    t.decimal  "vat",           precision: 5,  scale: 2
    t.string   "bill_type"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.index ["client_id"], name: "index_bills_on_client_id", using: :btree
    t.index ["historial_id"], name: "index_bills_on_historial_id", using: :btree
  end

  create_table "clientes", id: :bigserial, force: :cascade do |t|
    t.string   "nombre",        limit: 255
    t.string   "apellido",      limit: 255
    t.string   "documento",     limit: 255
    t.string   "direccion",     limit: 255
    t.bigint   "telefono"
    t.string   "celular",       limit: 255
    t.string   "email",         limit: 255
    t.date     "nacimiento"
    t.string   "ocupacion",     limit: 255
    t.text     "actividad"
    t.string   "recomendado",   limit: 255
    t.text     "salud"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.bigint   "cantidadrecom",                                      default: 0
    t.decimal  "gastado",                   precision: 15, scale: 2, default: "0.0"
    t.string   "lente",         limit: 255
    t.index ["documento"], name: "idx_17585_index_clientes_on_documento", unique: true, using: :btree
  end

  create_table "historials", id: :bigserial, force: :cascade do |t|
    t.boolean  "tipolente",                                          default: false
    t.string   "lente",         limit: 255
    t.string   "colorlente",    limit: 255
    t.string   "armazon",       limit: 255
    t.string   "cristales",     limit: 255
    t.text     "observaciones"
    t.text     "uso"
    t.text     "seguimiento"
    t.decimal  "precio",                    precision: 15, scale: 2, default: "0.0"
    t.bigint   "orden"
    t.bigint   "cliente_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "doctor",        limit: 255
    t.string   "dist_intra",    limit: 255
    t.date     "entrega"
    t.string   "factura",       limit: 255
    t.boolean  "retirado",                                           default: false
    t.string   "altura",        limit: 255
    t.string   "formapago",     limit: 255
  end

  create_table "recetes", id: :bigserial, force: :cascade do |t|
    t.boolean  "ojo"
    t.decimal  "esferico",                 precision: 15, scale: 2
    t.decimal  "cilindrico",               precision: 15, scale: 2
    t.decimal  "eje",                      precision: 15, scale: 2
    t.decimal  "diametro",                 precision: 15, scale: 2
    t.decimal  "adicion",                  precision: 15, scale: 2
    t.string   "av",           limit: 255
    t.string   "distancia",    limit: 255
    t.boolean  "receta"
    t.bigint   "historial_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cb",           limit: 255
    t.string   "quera",        limit: 255
  end

  create_table "user_sessions", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", id: :bigserial, force: :cascade do |t|
    t.string   "login",             limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "crypted_password",  limit: 255
    t.string   "password_salt",     limit: 255
    t.string   "persistence_token", limit: 255
    t.boolean  "admin"
    t.index ["login"], name: "idx_17620_index_users_on_login", unique: true, using: :btree
  end

  create_table "venta", id: :bigserial, force: :cascade do |t|
    t.bigint   "mes"
    t.bigint   "anio"
    t.decimal  "vendido",        precision: 15, scale: 2, default: "0.0"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.bigint   "cantvendida",                             default: 0
    t.bigint   "cant_contacto",                           default: 0
    t.bigint   "cant_flotante",                           default: 0
    t.decimal  "venta_contacto", precision: 15, scale: 2, default: "0.0"
    t.decimal  "venta_flotante", precision: 15, scale: 2, default: "0.0"
  end

end
