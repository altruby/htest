class Htest < Picotest::Test
  def setup
    setup_jail(jail)
  end

  def teardown
    jail.remove
  end

  private

  ##
  # Isolate our tests in a separate jail.
  # @return [Jail]
  def jail
    @jail ||= Jail.create(**jail_settings)
  end

  ##
  # @param [Jail] jail
  # @return [void]
  def setup_jail(jail)
    raise NotImplementedError
  end

  ##
  # @return [Hash]
  def jail_settings
    raise NotImplementedError
  end
end
