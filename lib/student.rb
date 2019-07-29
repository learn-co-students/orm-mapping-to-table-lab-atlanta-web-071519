class Student

  def initialize(id=nil, name, grade)
    @name = name
    @grade = grade
    @id = id  
  end

  attr_accessor :name, :grade
  attr_reader :id 
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  

  def self.create_table
    sql = <<-SQL
      CREATE TABLE students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      );
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students;
    SQL
    DB[:conn].execute(sql)
  end

  def self.create(props={})
    new_student = Student.new(props[:name], props[:grade])
    new_student.save 
    new_student 
  end

  def save
    sql = <<-SQL 
      INSERT INTO students
      (name, grade)
      VALUES (?, ?);
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute (
      <<-SQL
      SELECT id 
        FROM students
        ORDER BY id DESC
        LIMIT 1;
      SQL
    )
  
    @id = @id[0][0]
  end
  
end
