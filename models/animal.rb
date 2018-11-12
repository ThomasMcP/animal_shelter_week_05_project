require_relative('../db/sql_runner.rb')

class Animal

  attr_accessor :name, :adoption_status, :day_admitted
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @adoption_status = options['adoption_status']
    @day_admitted = options['day_admitted']
    @age = options['age']
  end

  def self.all()
    sql = "SELECT * FROM animals"
    values = []
    result = SqlRunner.run(sql, values)
    return result.map { |animal| Animal.new(animal)}
  end

  def save()
    sql = "INSERT INTO animals (name, adoption_status, day_admitted, age) VALUES ( $1, $2, $3, $4) RETURNING id;"
    values = [@name, @adoption_status, @day_admitted, @age]
    result = SqlRunner.run(sql, values)
    id = result.first['id']
    @id = id.to_i
  end

  def self.find(id)
    sql = "SELECT * FROM animals WHERE id = $1;"
    values = [id]
    result = SqlRunner.run(sql, values)
    return Animal.new(result.first)
  end

  def update()
      sql = "UPDATE animals SET(name, adoption_status, day_admitted, age) = ($1, $2, $3, $4)
      WHERE id = $5"
      values = [@name, @adoption_status, @day_admitted, @age, @id]
      SqlRunner.run(sql, values)
    end

  def self.destroy(id)
    sql = "DELETE FROM animals WHERE id = $1"
    values = [id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all()
    sql = "DELETE FROM animals;"
    SqlRunner.run(sql)
  end

end
