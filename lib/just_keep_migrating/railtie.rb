require "active_record/railtie"

module GoodMigrations
  class Railtie < Rails::Railtie
    initializer "good_migrations.configure_rails_initialization" do
      check_for_pending_migrations!
    end

    def check_for_pending_migrations!
      pending_migrations = ActiveRecord::Migrator.open(ActiveRecord::Tasks::DatabaseTasks.migrations_paths).pending_migrations

      if pending_migrations.any?
        puts caller
        puts "You have #{pending_migrations.size} pending #{pending_migrations.size > 1 ? 'migrations:' : 'migration:'}"
        pending_migrations.each do |pending_migration|
          puts "  %4d %s" % [pending_migration.version, pending_migration.name]
        end
        puts %{Run `rails db:migrate` to update your database then try again.}
        exit(false)
      end
    end
  end
end

