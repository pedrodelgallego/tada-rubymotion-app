class Task
  attr_accessor :text
  attr_accessor :completed

  class << self
    def create(text, completed=false)
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

    def loadTasks
      @@tasks = []
      error_ptr = Pointer.new(:object)

      path = NSBundle.mainBundle.pathForResource("tasks", ofType:"json")

      data = NSData.dataWithContentsOfFile(path, options:NSDataReadingUncached, error:error_ptr)

      json = NSJSONSerialization.JSONObjectWithData(data, options:NSDataReadingUncached, error:error_ptr)

      unless json
        puts error_ptr[0].localizedDescription
        return
      end

      json.each { |a, b| Task.create a["text"], a["completed"] }
    end
  end

  def destroy
    @@tasks = @@tasks.select{ |task| task.text != self.text }
  end

end
