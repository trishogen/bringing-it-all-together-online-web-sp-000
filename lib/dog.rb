class Dog

  attr_accessor :id, :name, :breed

  def initialize(name: nil, breed: nil, id: nil)
    @id = id
    @name = name
    @breed = breed
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dogs(
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT);
      SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE dogs")
  end

  def save
    sql = <<-SQL
      INSERT INTO dogs (name, breed)
      VALUES (?, ?)
      SQL

    DB[:conn].execute(sql, self.name, self.breed)

    row = DB[:conn].execute("select last_insert_rowid() from dogs")[0]
    Dog.new(id: row[0], name: row[1], breed: row[2])
  end

  def self.create(dog_attributes)
    dog = nil
    dog_attributes.each {|key, value| dog = Dog.new.send(("#{key}="), value)}
    dog.save
    dog
  end

  def self.new_from_db(row)

  end

end
