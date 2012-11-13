class StrikeLabel < UITextField
  attr_accessor :strikethrough
  attr_accessor :strike_layer
  STRIKE_THICKNESS = 2.0

  def initWithFrame(frame)
    super(frame)
    @strike_layer = CALayer.layer
    @strike_layer.backgroundColor = UIColor.whiteColor.CGColor
    @strike_layer.hidden = true;
    self.layer.addSublayer @strike_layer
    self
  end

  def layoutSubviews
    super
    self.resizeStrikeThrough
  end

  def setText(text)
    super(text)
    self.resizeStrikeThrough
  end

  def resizeStrikeThrough
    # textSize = self.text.sizeWithFont(self.font)
    # @strike_layer.frame =
    #   CGRectMake(0, self.bounds.size.height/2, textSize.width, STRIKEOUT_THICKNESS)
  end

  def setStrikethrough(strikethrough)
    @strike_layer = strikethrough
    @strike_layer .hidden = !strikethrough;
  end
end
