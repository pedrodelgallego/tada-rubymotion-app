class Task
  attr_accessor :text
  attr_accessor :completed

  @@tasks = []

  class << self
    def create(text)
      task = self.alloc
      task.text = text
      task.completed = false
      @@tasks.push task
      task
    end

    def add(task)
      @@tasks.push task
      true
    end

    def all
      @@tasks
    end

    def count
      @@tasks.size
    end
  end

  def destroy
    @@tasks = @@tasks.select{ |task| task.text != self.text }
  end
end
