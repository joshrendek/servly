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

ActiveRecord::Schema.define(:version => 20110916223144) do

  create_table "alerts", :force => true do |t|
    t.integer  "domain_id"
    t.string   "threshold_stat"
    t.float    "threshold_value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "active"
    t.integer  "threshold_time"
    t.integer  "alertable_id"
    t.string   "alertable_type"
    t.time     "start_time"
    t.time     "end_time"
    t.string   "operator"
    t.integer  "targetable_id"
    t.string   "targetable_type"
  end

  create_table "automated_tasks", :force => true do |t|
    t.integer  "domain_id"
    t.integer  "server_id"
    t.string   "command"
    t.text     "output"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "collective_stats", :force => true do |t|
    t.integer  "domain_id"
    t.integer  "net_in"
    t.integer  "net_out"
    t.integer  "net_total"
    t.float    "cpu_usage"
    t.integer  "number_of_cpus"
    t.float    "memory_free"
    t.float    "memory_used"
    t.integer  "net_connections"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "disk_used"
    t.float    "disk_size"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "diagnostic_logs", :force => true do |t|
    t.integer  "diagnostic_worker_id"
    t.string   "command"
    t.text     "output"
    t.integer  "server_id"
    t.integer  "domain_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tag"
  end

  create_table "diagnostic_workers", :force => true do |t|
    t.string   "ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

  create_table "domain_user_group_permissions", :force => true do |t|
    t.integer  "domain_user_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "domain_id"
  end

  create_table "domain_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "domain_id"
    t.integer  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "alerts",             :default => true
    t.integer  "triggered_alert_id"
  end

  create_table "domains", :force => true do |t|
    t.string   "subdomain"
    t.string   "domain"
    t.integer  "user_id"
    t.string   "api_key"
    t.integer  "server_limit"
    t.integer  "alert_limit"
    t.integer  "url_monitor_limit"
    t.integer  "user_limit"
    t.integer  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "terminated",        :default => 0
  end

  create_table "group_servers", :force => true do |t|
    t.integer  "server_id"
    t.integer  "domain_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.integer  "domain_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "notes"
  end

  create_table "logs", :force => true do |t|
    t.integer  "domain_id"
    t.integer  "server_id"
    t.integer  "message_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.string   "message"
    t.string   "message_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "monitored_service_logs", :force => true do |t|
    t.integer  "domain_id"
    t.integer  "server_id"
    t.integer  "service_id"
    t.integer  "service_status"
    t.string   "service_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "monitored_services", :force => true do |t|
    t.integer  "domain_id"
    t.integer  "server_id"
    t.integer  "service_id"
    t.integer  "service_status"
    t.string   "service_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "server_downtimes", :force => true do |t|
    t.integer  "domain_id"
    t.integer  "server_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "server_logs", :force => true do |t|
    t.integer  "group_id"
    t.integer  "domain_id"
    t.string   "hostname"
    t.string   "ip"
    t.string   "location"
    t.float    "cpu_usage"
    t.float    "disk_size"
    t.float    "disk_used"
    t.float    "load_one"
    t.float    "load_five"
    t.float    "load_fifteen"
    t.float    "mem_free"
    t.float    "mem_used"
    t.float    "swap_free"
    t.float    "swap_used"
    t.integer  "net_in"
    t.integer  "net_out"
    t.integer  "running_procs"
    t.integer  "number_of_cpus"
    t.string   "kernel"
    t.string   "release"
    t.integer  "pending_updates"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "connections"
    t.string   "os"
    t.integer  "server_id"
    t.float    "blk_reads"
    t.float    "blk_writes"
  end

  create_table "server_services", :force => true do |t|
    t.integer  "server_id"
    t.integer  "domain_id"
    t.integer  "service_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "servers", :force => true do |t|
    t.integer  "group_id"
    t.integer  "domain_id"
    t.string   "hostname"
    t.string   "ip"
    t.string   "location"
    t.float    "cpu_usage"
    t.float    "disk_size"
    t.float    "disk_used"
    t.float    "load_one"
    t.float    "load_five"
    t.float    "load_fifteen"
    t.float    "mem_free"
    t.float    "mem_used"
    t.float    "swap_free"
    t.float    "swap_used"
    t.integer  "net_in"
    t.integer  "net_out"
    t.integer  "running_procs"
    t.integer  "number_of_cpus"
    t.string   "kernel"
    t.string   "release"
    t.text     "running_process"
    t.integer  "pending_updates"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "os"
    t.text     "ps"
    t.integer  "connections"
    t.float    "estimated_bandwidth"
    t.float    "blk_reads"
    t.float    "blk_writes"
    t.string   "uptime"
    t.integer  "down_alert_count",    :default => 0
  end

  create_table "services", :force => true do |t|
    t.string   "service_name"
    t.integer  "domain_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "service_variable"
    t.string   "service_type"
  end

  create_table "settings", :force => true do |t|
    t.integer  "domain_id"
    t.integer  "user_id"
    t.string   "setting_key"
    t.string   "setting_val"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "setting_ord"
  end

  create_table "sms_gateways", :force => true do |t|
    t.string   "carrier"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "team_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "domain_id"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.integer  "domain_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "triggered_alerts", :force => true do |t|
    t.integer  "domain_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "alert_id"
    t.string   "triggerable_type"
    t.integer  "triggerable_id"
  end

  create_table "url_monitor_logs", :force => true do |t|
    t.integer  "domain_id"
    t.float    "response_time"
    t.integer  "current_status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "url_monitor_id"
  end

  create_table "url_monitors", :force => true do |t|
    t.string   "url"
    t.float    "response_time"
    t.integer  "status_code"
    t.string   "keyword"
    t.integer  "domain_id"
    t.text     "current_run"
    t.integer  "current_status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "",                           :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "",                           :null => false
    t.string   "password_salt",                       :default => "",                           :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone"
    t.integer  "sms_gateway_id"
    t.string   "timezone",                            :default => "Eastern Time (US & Canada)"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
