class MorphController < UIViewController
  def viewDidLoad
    super

    self.title = "Alphabet"

    @table = UITableView.alloc.initWithFrame(self.view.bounds)
    @table.dataSource = self
    @table.delegate   = self

    @table.separatorStyle = UITableViewCellSeparatorStyleNone
    @table.backgroundColor = UIColor.blackColor

    self.view.addSubview @table
  end

  def viewDidUnload
    Task.tasks = nil
  end

  def tableView(tableView, numberOfRowsInSection:section)
    Task.count
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    TaskCell.cellForTask(Task.all[indexPath.row], inTableView:tableView)
  end

  def colorForIndex(index)
    total = Task.count - 1
    val = (index.to_f / total.to_f) * 0.8;
    UIColor.colorWithRed(1, green: val, blue: 0, alpha: 1.0)
  end

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    return 50.0;
  end

  def tableView(tableView, willDisplayCell:cell, forRowAtIndexPath:indexPath)
    cell.backgroundColor = colorForIndex(indexPath.row)
    cell.delegate = self
  end

  def taskDeleted(task)
    index = Task.all.find_index { |t| t.text == task.text}
    index_path = NSIndexPath.indexPathForRow(index, inSection:0)
    @table.beginUpdates
    task.destroy
    @table.deleteRowsAtIndexPaths([index_path], withRowAnimation:UITableViewRowAnimationFade)
    @table.endUpdates
  end

end
