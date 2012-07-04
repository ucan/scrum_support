module ActionController::TestCase::Behavior

  def patch(action, parameters = nil, session = nil, flash = nil)
    process action, parameters, session, flash, "PATCH"
  end
end
