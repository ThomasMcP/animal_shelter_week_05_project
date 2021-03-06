require_relative('../db/sql_runner.rb')

class Animal

  attr_accessor :name, :adoption_status, :day_admitted, :age, :type, :breed, :owner_id
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @type = options['type']
    @breed = options['breed']
    @adoption_status = options['adoption_status']
    @day_admitted = options['day_admitted']
    @age = options['age']
    @owner_id = options['owner_id']
  end

  def self.all()
    sql = "SELECT * FROM animals"
    values = []
    result = SqlRunner.run(sql, values)
    return result.map { |animal| Animal.new(animal)}
  end

  def save()
    sql = "INSERT INTO animals (name, type, breed, adoption_status, day_admitted, age, owner_id) VALUES ( $1, $2, $3, $4, $5, $6, $7) RETURNING id;"
    values = [@name, @type, @breed, @adoption_status, @day_admitted, @age, @owner_id]
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
      sql = "UPDATE animals SET(name, type, breed, adoption_status, day_admitted, age, owner_id) = ($1, $2, $3, $4, $5, $6, $7)
      WHERE id = $8"
      values = [@name, @type, @breed, @adoption_status, @day_admitted, @age, @owner_id, @id]
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
