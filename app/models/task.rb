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

      # if you want to use a json object
      # error_ptr = Pointer.new(:object)
      # path = NSBundle.mainBundle.pathForResource("tasks", ofType:"json")
      # data = NSData.dataWithContentsOfFile(path, options:NSDataReadingUncached, error:error_ptr)
      # json = NSJSONSerialization.JSONObjectWithData(data, options:NSDataReadingUncached, error:error_ptr)
      # unless json
      #   puts error_ptr[0].localizedDescription
      #   return
      # end

      # if you want to use an async parse call
      # objects = PFQuery.queryWithClassName("TestObject").
      #   findObjectsInBackgroundWithBlock lambda{ |objects, errors|
      #     objects.each { |task| Task.create task.objectForKey("text"), task.objectForKey("completed") }
      # }

      # A sync parse call
      objects = PFQuery.queryWithClassName("TestObject").findObjects()
      objects.each { |task| Task.create task.objectForKey("text"), task.objectForKey("completed") }
    end
  end

  def destroy
    @@tasks = @@tasks.select{ |task| task.text != self.text }
  end

end
