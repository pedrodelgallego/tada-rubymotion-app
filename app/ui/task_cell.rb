# -*- coding: utf-8 -*-
class TaskCell < UITableViewCell
  CellID = 'CellIdentifier'
  @gradient
  @originalCenter
  @deleteOnDragRelease

  class << self
    def cellForTask(item, inTableView:tableView)
      cell = tableView.dequeueReusableCellWithIdentifier(TaskCell::CellID) ||
        TaskCell.alloc

      # Events
      # recognizer = UIPanGestureRecognizer.alloc.initWithTarget(self, action:'handlePan')
      # recognizer.delegate = self;
      # cell.addGestureRecognizer(recognizer)

      cell.when_panned do |recognizer|
        cell.handle_swipe(recognizer)
      end

      # Styling the cell
      cell.addGradient(UITableViewCellStyleDefault, reuseIdentifier:CellID)
      cell.textLabel.backgroundColor = UIColor.clearColor
      cell.textLabel.text = item.text

      cell
    end
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
  # def gestureRecognizerShouldBegin(gestureRecognizer)
  #   translation = gestureRecognizer.translationInView(self.superview)
  #   puts "yaaay"

  #   # Check for horizontal gesture
  #   if (fabsf(translation.x) > fabsf(translation.y)) then
  #     return true
  #   end
  #   false
  # end

  def handle_swipe(recognizer)
    if (recognizer.state == UIGestureRecognizerStateBegan) then
      @originalCenter = self.center;
    end

    if (recognizer.state == UIGestureRecognizerStateChanged) then
      # translate the center
      translation = recognizer.translationInView(self)
      self.center = CGPointMake(@originalCenter.x + translation.x, @originalCenter.y)
    end

    if (recognizer.state == UIGestureRecognizerStateEnded) then
    end
  end
end
