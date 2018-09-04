# frozen_string_literal: true

module Spid
  class Configuration # :nodoc:
    attr_accessor :idp_metadata_dir_path
    attr_accessor :hostname
    attr_accessor :metadata_path
    attr_accessor :start_sso_path
    attr_accessor :start_slo_path
    attr_accessor :acs_path
    attr_accessor :slo_path
    attr_accessor :digest_method
    attr_accessor :signature_method
    attr_accessor :default_relay_state_path
    attr_accessor :acs_binding
    attr_accessor :slo_binding
    attr_accessor :attribute_services
    attr_accessor :private_key_path
    attr_accessor :certificate_path

    def initialize
      @idp_metadata_dir_path    = "idp_metadata"
      @attribute_services       = []
      init_endpoint
      init_bindings
      init_dig_sig_methods
      init_openssl_keys
    end

    def init_endpoint
      @hostname                 = nil
      @metadata_path            = "/spid/metadata"
      @start_sso_path           = "/spid/login"
      @start_slo_path           = "/spid/logout"
      @acs_path                 = "/spid/sso"
      @slo_path                 = "/spid/slo"
      @default_relay_state_path = "/"
    end

    def init_bindings
      @acs_binding              = Spid::BINDINGS_HTTP_POST
      @slo_binding              = Spid::BINDINGS_HTTP_REDIRECT
    end

    def init_dig_sig_methods
      @digest_method            = Spid::SHA256
      @signature_method         = Spid::RSA_SHA256
    end

    def init_openssl_keys
      @private_key              = nil
      @certificate              = nil
    end

    def certificate_pem
      return nil if certificate_path.nil? || !File.exist?(certificate_path)
      @certificate_pem ||= File.read(certificate_path)
    end

    def private_key_pem
      return nil if private_key_path.nil? || !File.exist?(private_key_path)
      @private_key_pem ||= File.read(private_key_path)
    end

    def certificate
      return nil if certificate_pem.nil?
      @certificate ||= OpenSSL::X509::Certificate.new(certificate_pem)
    end

    def private_key
      return nil if private_key_pem.nil?
      @private_key ||= OpenSSL::PKey::RSA.new(private_key_pem)
    end

    def service_provider
      @service_provider ||=
        begin
          Spid::Saml2::ServiceProvider.new(
            acs_binding: acs_binding, acs_path: acs_path, slo_path: slo_path,
            slo_binding: slo_binding, metadata_path: metadata_path,
            private_key: private_key, certificate: certificate,
            digest_method: digest_method, signature_method: signature_method,
            attribute_services: attribute_services, host: hostname
          )
        end
    end
  end
end
