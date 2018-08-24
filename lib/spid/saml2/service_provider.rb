# frozen_string_literal: true

require "uri"

module Spid
  module Saml2
    class ServiceProvider # :nodoc:
      attr_reader :host
      attr_reader :acs_path
      attr_reader :acs_binding
      attr_reader :slo_path
      attr_reader :slo_binding
      attr_reader :metadata_path
      attr_reader :private_key
      attr_reader :certificate
      attr_reader :digest_method
      attr_reader :signature_method
      attr_reader :attribute_services

      # rubocop:disable Metrics/ParameterLists
      # rubocop:disable Metrics/MethodLength
      def initialize(
            host:,
            acs_path:,
            acs_binding:,
            slo_path:,
            slo_binding:,
            metadata_path:,
            private_key:,
            certificate:,
            digest_method:,
            signature_method:,
            attribute_services:
          )
        @host = host
        @acs_path               = acs_path
        @acs_binding            = acs_binding
        @slo_path               = slo_path
        @slo_binding            = slo_binding
        @metadata_path          = metadata_path
        @private_key            = private_key
        @certificate            = certificate
        @digest_method          = digest_method
        @signature_method       = signature_method
        @attribute_services     = attribute_services
        validate_digest_methods
        validate_attributes
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/ParameterLists

      def acs_url
        @acs_url ||= URI.join(host, acs_path).to_s
      end

      def slo_url
        @slo_url ||= URI.join(host, slo_path).to_s
      end

      def metadata_url
        @metadata_url ||= URI.join(host, metadata_path).to_s
      end

      private

      def validate_attributes
        if attribute_services.all? { |as| validate_attribute_service(as) }
          return
        end
        raise UnknownAttributeFieldError,
              "Provided attribute in services are not valid:" \
              " use only fields in #{ATTRIBUTES.join(', ')}"
      end

      def validate_attribute_service(attribute_service)
        return false unless attribute_service.key?(:name)
        return false unless attribute_service.key?(:fields)
        not_valid_fields = attribute_service[:fields] - ATTRIBUTES
        not_valid_fields.empty?
      end

      def validate_digest_methods
        if !DIGEST_METHODS.include?(digest_method)
          raise UnknownDigestMethodError,
                "Provided digest method is not valid:" \
                " use one of #{DIGEST_METHODS.join(', ')}"
        elsif !SIGNATURE_METHODS.include?(signature_method)
          raise UnknownSignatureMethodError,
                "Provided digest method is not valid:" \
                " use one of #{SIGNATURE_METHODS.join(', ')}"
        end
      end
    end
  end
end
