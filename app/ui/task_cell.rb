# -*- coding: utf-8 -*-
class TaskCell < UITableViewCell
  CellID = 'CellIdentifier'

  class << self
    def cellForTask(item, inTableView:tableView)
      cell = tableView.dequeueReusableCellWithIdentifier(TaskCell::CellID) || TaskCell.alloc

      # Events
      cell.addGestures

      # Styling the cell
      cell.addGradient(UITableViewCellStyleDefault, reuseIdentifier:CellID)
      cell.textLabel.backgroundColor = UIColor.clearColor
      cell.textLabel.text = item.text

      cell
    end
  end

  def addGestures
    # panGesture for managing panning on a cell
    @panGesture = UIPanGestureRecognizer.alloc.initWithTarget(self, action:"handle_pan")
    @panGesture.delegate = self
    self.addGestureRecognizer @panGesture
  end

  #-----------------------------------------------
  #  Styling
  #-----------------------------------------------
  def addGradient(style, reuseIdentifier)
    self.initWithStyle(style, reuseIdentifier:reuseIdentifier)
    if self
      @gradient = CAGradientLayer.layer
      @gradient.frame = self.bounds
      @gradient.colors = [
        UIColor.colorWithWhite(1.0, alpha:0.2).CGColor,
        UIColor.colorWithWhite(1.0, alpha:0.1).CGColor,
        UIColor.clearColor.CGColor,
        UIColor.colorWithWhite(0.0, alpha:0.1).CGColor
      ]

      @gradient.locations = [0.0, 0.01, 0.95, 1]

      self.layer.addSublayer(@gradient)
    end
    self
  end

  def layoutSubviews
    super
    @gradient.frame = self.bounds
  end

  #-----------------------------------------------
  #  Adding gestures
  #-----------------------------------------------
  def gestureRecognizerShouldBegin(recognizer)
    if recognizer.class != UIPanGestureRecognizer then
      return false
    end
    translation = recognizer.translationInView(self.superview)

    if (translation.x.abs > translation.y.abs) then
      return true
    end
    false
  end

  def handle_pan
    if (@panGesture.state == UIGestureRecognizerStateBegan) then
      @originalCenter = self.center;
    end

    if (@panGesture.state == UIGestureRecognizerStateChanged) then
      translation = @panGesture.translationInView(self)
      self.center = CGPointMake(@originalCenter.x + translation.x, @originalCenter.y)
    end

    if (@panGesture.state == UIGestureRecognizerStateEnded) then
      # the frame this cell would have had before being dragged
      originalFrame = CGRectMake(0, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
      if (!@deleteOnDragRelease) then
        #if the item is not being deleted, snap back to the original location
        UIView.animateWithDuration(0.2, animations: lambda {self.frame = originalFrame})
      end
    end
  end
end
