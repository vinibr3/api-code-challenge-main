module Api
  module V1
    class DnsRecordsController < ApplicationController
      # GET /dns_records
      def index
        head :unprocessable_entity and return if params[:page].blank?

        dns_records = filtered_dns_records
        hostnames = dns_records.map{|h| h.hostnames.map(&:hostname) }.flatten!

        related_hostnames =
          hostnames.uniq.map {|h| { count: hostnames.count(h), hostname: h } }
        related_hostnames =
          related_hostnames.delete_if{|r| r[:hostname].in?(included) } if included.any?

        render json: { total_records: dns_records.length,
                       records: dns_records.map(&:serialize),
                       related_hostnames: related_hostnames }
      end

      # POST /dns_records
      def create
        dns_record = DnsRecord.new(valid_params)

        if dns_record.save
          render json: dns_record
        else
          hostname_errors =
            dns_record.hostnames.map {|h| {hostname: h.hostname, errors: h.errors } }

          render json: { errors: { record: dns_record.errors,
                                   hostnames: hostname_errors} }, status: :unprocessable_entity
        end
      end

      private

      def valid_params
        params.require(:dns_records)
              .permit(:ip, hostnames_attributes: [:hostname])
      end

      def filtered_dns_records
        dns_records = DnsRecord.includes(:hostnames)

        if included.any?
          records = dns_records.where(hostnames: { hostname: [included] })
          records = records.select do |r|
            record_hostnames = r.hostnames.map(&:hostname)

            included.all?{|h| h.in?(record_hostnames) }
          end

          dns_records.merge!(DnsRecord.where(id: records.map(&:id)))
        end

        excluded = params[:excluded].to_s.split(',')
        dns_records = dns_records.merge!(DnsRecord.where.not(hostnames: Hostname.where(hostname: excluded))) if excluded.any?

        dns_records.paginate(page: params[:page])
      end

      def included
        params[:included].to_s.split(',')
      end
    end
  end
end
