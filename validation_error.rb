class ValidationError < StandardError
  def initialize
    super("Имя не должно быть пустым!")
  end
end