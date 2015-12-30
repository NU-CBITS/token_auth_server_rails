module TokenAuth
  module Concerns
    # Allow cross-domain requests.
    module CorsSettings
      def cors_set_access_control_headers(allow:)
        headers["Access-Control-Allow-Origin"] = "*"
        headers["Access-Control-Allow-Methods"] = allow
        headers["Access-Control-Allow-Headers"] = "Content-Type"
      end
    end
  end
end
