# -*- coding: undecided -*-
class MorphController < UIViewController
  def viewDidAppear(animated)
    super
    if PFUser.currentUser
      showTaskTable
    else
      login = PFLogInViewController.alloc.init
      login.delegate = self
      login.signUpController.delegate = self
      self.presentModalViewController(login, animated:true)
    end
  end

  def logInViewController(logInController, didLogInUser:user)
    self.dismissModalViewControllerAnimated(true)
  end

  def logInViewControllerDidCancelLogIn(logInController)
    self.dismissModalViewControllerAnimated(true)
  end

  def signUpViewController(signUpController, didSignUpUser:user)
    self.dismissModalViewControllerAnimated(true)
  end

  def signUpViewControllerDidCancelLogIn(signUpController, didLogInUser:user)
    self.dismissModalViewControllerAnimated(true)
  end

  def showTaskTable
    @table = UITableView.alloc.initWithFrame(self.view.bounds)
    @table.dataSource = self
    @table.delegate   = self

    @table.separatorStyle = UITableViewCellSeparatorStyleNone
    @table.backgroundColor = UIColor.blackColor

    label = UILabel.alloc.initWithFrame(CGRectMake(0, 0, 320, 380))
    label.text = "It was a very long book with many lines..."
    label.backgroundColor = UIColor.blackColor
    label.textColor = UIColor.whiteColor
    label.font = UIFont.systemFontOfSize(13)
    label.lineBreakMode = UILineBreakModeWordWrap
    label.textAlignment = UITextAlignmentCenter
    label.numberOfLines = 0
    @table.tableFooterView = label

    view.addSubview @table
  end

  def logoutTapped
    PFUser.logOut
    appDelegate = UIApplication.sharedApplication.delegate
    appDelegate.presentMainViewController
  end

  def actionTapped
    if @timer
      @timer.invalidate
      @timer = nil
    else
      @duration = 0
      @timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target:self, selector:'timerFired', userInfo:nil, repeats:true)
    end
    @action.selected = !@action.selected?
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

  # == SHCTableViewCellDelegate ==
  # Indicates that the edit process has begun for the given cell
  def cellDidBeginEditing(editingCell)
    index = Task.all.find_index { |t| t.text == editingCell.task.text}
    index_path = NSIndexPath.indexPathForRow(index, inSection:0)

    @table.scrollToRowAtIndexPath(index_path,
      atScrollPosition: UITableViewScrollPositionTop, animated:true)

    change_alpha_of_visible_cells do |cell|
      cell.alpha = 0.3 unless cell == editingCell
    end
  end

  # Indicates that the edit process has committed for the given cell
  def cellDidEndEditing(editingCell)
    change_alpha_of_visible_cells do |cell|
      cell.alpha = 1
    end
  end

  # == Helpers ==
  def change_alpha_of_visible_cells
    @table.visibleCells.each do |cell|
      UIView.animateWithDuration(0.3, animations: lambda { yield cell })
    end
  end
end
