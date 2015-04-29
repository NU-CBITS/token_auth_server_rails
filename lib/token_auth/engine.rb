module TokenAuth
  # Engine application superclass.
  class Engine < ::Rails::Engine
    isolate_namespace TokenAuth
  end
end
