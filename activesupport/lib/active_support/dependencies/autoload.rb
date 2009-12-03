require "active_support/inflector/methods"

module ActiveSupport
  module Autoload

    @@autoloads = {}
    @@under_path = nil
    @@at_path = nil

    def autoload(const_name, path = @@at_path)
      full = [self.name, @@under_path, const_name.to_s, path].compact.join("::")
      location = path || Inflector.underscore(full)

      @@autoloads[const_name] = location
      super const_name, location
    end

    def autoload_under(path)
      @@under_path, old_path = path, @@under_path
      yield
    ensure
      @@under_path = old_path
    end

    def autoload_at(path)
      @@at_path, old_path = path, @@at_path
      yield
    ensure
      @@at_path = old_path
    end

    def self.eager_autoload!
      @@autoloads.values.each {|file| require file }
    end

  end
end