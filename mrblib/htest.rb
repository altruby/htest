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
    @jail ||= Jail.create(**jail_settingssettings)
  end

  ##
  # @return [Hash]
  def jail_settings
    raise NotImplementedError
  end
end

