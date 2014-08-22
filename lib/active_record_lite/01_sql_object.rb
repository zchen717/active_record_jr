require_relative 'db_connection'
require 'active_support/inflector'
#NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
#    of this project. It was only a warm up.

class SQLObject
  def self.columns
    return @columns unless @columns.nil?
    col = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        "#{self.table_name}"
    SQL
    col = col.first
    @columns = col.map! { |el| el.to_sym }
  end

  def self.finalize!
    self.columns.each do |column_name|
      define_method(column_name) do
        attributes[column_name]
      end

      define_method("#{column_name}=") do |value|
        attributes[column_name] = value
      end
    end
  end

  def self.table_name=(table_name)
    # ...
    @table_name = table_name
  end

  def self.table_name
    # ...
    @table_name || self.name.tableize
  end

  def self.all
    # ...
  end

  def self.parse_all(results)
    # ...
  end

  def self.find(id)
    # ...
  end

  def attributes
    @attributes ||= {}
    # ...
  end

  def insert
    # ...
  end

  def initialize()
    # params.each do |attr_name, value|
    #   attr_name = attr_name.to_sym
    #   if attribues.include?(attr_name)
    #     raise "unknown attribute '#{value}'"
    #   end
    # end
  end

  def save
    # ...
  end

  def update
    # ...
  end

  def attribute_values
    # ...
  end
end
