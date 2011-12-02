    namespace :backup do
    require "yaml"
    
    desc "Copia de seguridad de la base de datos en la carpeta public/backup"
    task :base_datos => :crea_dir do
      task :crea_dir do
        unless File.exist?("#{RAILS_PATH}/public/backup")
        puts "Creando directorio public/backup"
        sh "mkdir #{RAILS_PATH}/public/backup/"
        end
      end
      task :base_datos => :crea_dir do
        @conf = YAML::load(File.open("#{RAILS_PATH}/config/database.yml"))
        @db = @conf["production"]
        # Hacemos una copia de la base de datos en el directorio
        puts "Creando copia de seguridad de #{@db['database']}"
        sh "mysqldump –opt –user=#{@db['username']} –password=#{@db['password']} #{@db['database']} -h #{@db['host']} > public/backup/#{@db['database']}.sql"
      end
        
        
    end
     
      


      
      
    end

    