require "spec_helper"
require 'open3'

RSpec.describe JustKeepMigrating do
  before(:all) do
    @script_setup = <<-BASH
      cd example
      bundle
    BASH
  end

  it "has a version number" do
    expect(JustKeepMigrating::VERSION).not_to be nil
  end

  context "with pending migrations" do
    describe "starting a rails server" do
      it "blocks and prints an error" do
        stdout, stderr = shell("bundle exec rails server")
        expect(stdout).to include "You have 1 pending migration"
      end
    end
  end

private

  def shell(command)
    script = <<-SCRIPT
      export BUNDLE_GEMFILE="Gemfile"
      export RAILS_ENV="development"
      rm -f Gemfile.lock db/*.sqlite3
      bundle install
      #{command}
    SCRIPT
    Bundler.with_clean_env do
      Open3.capture3(script, :chdir => "example")
    end
  end
end
