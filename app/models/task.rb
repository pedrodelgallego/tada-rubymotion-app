class Task
  attr_accessor :text
  attr_accessor :completed

  @@tasks = []

  class << self
    def create(text)
      task = self.alloc
      task.text = text
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

end
