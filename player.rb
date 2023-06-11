class Player < User
  def initialize(name)
    super(name)
    validate!
  end

  private

  def validate!
    return unless name.to_s.empty?

    raise ValidationError
  end
end