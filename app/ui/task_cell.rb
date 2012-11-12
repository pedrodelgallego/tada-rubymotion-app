class TaskCell < UITableViewCell
  CellID            = 'CellIdentifier'
  LABEL_LEFT_MARGIN = 15.0
  UI_CUES_MARGIN    = 10.0
  UI_CUES_WIDTH     = 50.0

  attr_accessor :delegate
  attr_accessor :task
  attr_accessor :label
  attr_accessor :completeLayer
  attr_accessor :tickLabel
  attr_accessor :crossLabel

  class << self
    def cellForTask(task, inTableView:tableView)
      cell = tableView.dequeueReusableCellWithIdentifier(TaskCell::CellID)

      # this should be actually in an override initWithStyle method in
      # the instance level, but whatever
      unless cell
        cell = TaskCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CellID)

        # Events
        cell.addGestures

        # Styling the cell
        cell.styleCell
        cell.addGradient
        cell.textLabel.backgroundColor = UIColor.clearColor
        cell.addVisualCues
      end
      cell.setTask task
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
  #  Styling And Cues
  #-----------------------------------------------
  def styleCell
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    @label = StrikeLabel.alloc.initWithFrame(CGRectNull)
    @label.textColor = UIColor.whiteColor
    @label.font = UIFont.boldSystemFontOfSize(16)
    @label.backgroundColor = UIColor.clearColor
    self.addSubview(@label)

    # add a layer that renders a green background when an item is complete
    @completeLayer = CALayer.layer
    @completeLayer.backgroundColor = UIColor.alloc.initWithRed(0.0, green:0.6, blue:0.0, alpha:1.0).CGColor
    @completeLayer.hidden = true;

    self.layer.insertSublayer(@completeLayer, atIndex:0)
  end

  def addVisualCues
    @tickLabel = self.createCueLabel
    @tickLabel.text = "\u2713"
    @tickLabel.textAlignment = NSTextAlignmentRight
    self.addSubview(@tickLabel)

    @crossLabel = self.createCueLabel
    @crossLabel.text = "\u2717"
    @crossLabel.textAlignment = NSTextAlignmentLeft
    self.addSubview(@crossLabel)

    self
  end

  def addGradient
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

    self
  end

  def createCueLabel
    label = UILabel.alloc.initWithFrame(CGRectNull)
    label.textColor = UIColor.whiteColor
    label.font = UIFont.boldSystemFontOfSize(32.0)
    label.backgroundColor = UIColor.clearColor
    label
  end

  def layoutSubviews
    super
    @gradient.frame = self.bounds;
    @completeLayer.frame = self.bounds;

    @label.frame = CGRectMake(LABEL_LEFT_MARGIN, 0,
      self.bounds.size.width - LABEL_LEFT_MARGIN,self.bounds.size.height)

    @tickLabel.frame = CGRectMake(-UI_CUES_WIDTH - UI_CUES_MARGIN, 0,
      UI_CUES_WIDTH, self.bounds.size.height);

    @crossLabel.frame = CGRectMake(self.bounds.size.width + UI_CUES_MARGIN, 0,
      UI_CUES_WIDTH, self.bounds.size.height);
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
      @deleteOnDragRelease = self.frame.origin.x < -self.frame.size.width / 2;

      @completedOnDragRelease = self.frame.origin.x > self.frame.size.width / 2;


      cueAlpha = frame.origin.x.abs / (frame.size.width / 2);
      @tickLabel.alpha = cueAlpha;
      @crossLabel.alpha = cueAlpha;

      @tickLabel.textColor  = @completedOnDragRelease ? UIColor.greenColor : UIColor.whiteColor;
      @crossLabel.textColor = @deleteOnDragRelease    ? UIColor.redColor : UIColor.whiteColor;
    end

    if (@panGesture.state == UIGestureRecognizerStateEnded) then
      originalFrame = CGRectMake(0, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height);

      if !@deleteOnDragRelease then
        UIView.animateWithDuration(0.2, animations: lambda {self.frame = originalFrame})
      elsif @deleteOnDragRelease then
        delegate.taskDeleted @task
      end

      if !@completedOnDragRelease then
        UIView.animateWithDuration(0.2, animations: lambda {self.frame = originalFrame})
      elsif @completedOnDragRelease then
        @task.completed = true
        @completeLayer.hidden = false;
        @label.strikethrough = true;
      end
    end
  end

  def setTask(task)
    @task = task;

    # we must update all the visual state associated with the model item
    @label.text = task.text
    @label.strikethrough = task.completed
    @completeLayer.hidden = !task.completed
  end

  def prepareForReuse
    @label.text = ""
    @completeLayer.hidden = true
  end

end
