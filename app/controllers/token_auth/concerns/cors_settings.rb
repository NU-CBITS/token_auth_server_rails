module TokenAuth
  module Concerns
    # Allow cross-domain requests.
    module CorsSettings
      def cors_set_access_control_headers(allow_methods:, allow_headers: "")
        headers["Access-Control-Allow-Origin"] = "*"
        headers["Access-Control-Allow-Methods"] = allow_methods
        headers["Access-Control-Allow-Headers"] = [
          "Content-Type",
          allow_headers
        ].join(", ")
      end
    end
  end
end
