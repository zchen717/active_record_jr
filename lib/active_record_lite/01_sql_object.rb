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
    results = DBConnection.execute(<<-SQL)
      SELECT
        #{self.table_name}.*
      FROM
        #{self.table_name}
    SQL
    self.parse_all(results)
  end

  def self.parse_all(results)
    results.map { |data| self.new(data) }
  end

  def self.find(id)
    results = DBConnection.execute(<<-SQL, id)
      SELECT
      #{self.table_name}.*
      FROM
      #{self.table_name}
      WHERE
      #{self.table_name}.id = ?
    SQL
    parse_all(results).first
  end

  def attributes
    @attributes ||= {}
  end

  def insert

  end

  def initialize(params = {})
    params.each do |attr_name, value|
      attr_name = attr_name.to_sym
      if self.class.columns.include?(attr_name)
        self.send("#{attr_name}=", value)
      else
        raise "unknown attribute '#{attr_name}'"
      end
    end
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
