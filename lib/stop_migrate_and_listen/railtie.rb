require "active_record/railtie"

module GoodMigrations
  class Railtie < Rails::Railtie
    initializer "good_migrations.configure_rails_initialization" do
      check_for_pending_migrations!
    end

    def check_for_pending_migrations!
      return unless migrations.any?

      report_pending_migrations!
    end

    def report_pending_migrations!
      puts "*" * 60
      puts "You have #{migrations.size} pending #{'migration'.pluralize(migrations.size)}."
      puts
      migrations.each do |pending_migration|
        puts "* %s" % [pending_migration.filename]
      end
      puts
      puts "Run `rails db:migrate` to update your database and try again."
      puts "*" * 60

      exit(false)
    end

    def migrations
      ActiveRecord::Migrator.open(ActiveRecord::Tasks::DatabaseTasks.migrations_paths).pending_migrations
    end
  end
end

