class TodosController < UITableView
  attr_accessor :items
  def viewDidLoad
  end

  def initWithFrame(frame)
    super(frame)
    populate_table
  end

end
