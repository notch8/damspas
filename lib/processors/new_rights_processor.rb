# frozen_string_literal: true

module Processors
  class NewRightsProcessor
    def self.process_new
      queue = Aeon::Queue.find(Aeon::Queue::NEW_STATUS)
      queue.requests.each do |request|
        request.set_to_processing
        Processors::NewRightsProcessor.new(request).authorize
        request.set_to_active
      end
    end

    def self.revoke_old
      WorkAuthorization.where('updated_at < ?', 1.month.ago).each do |auth|
        params = { work_pid: auth.work_pid, email: auth.user.email, aeon_id: auth.aeon_id }
        request = Processors::NewRightsProcessor.new(params)
        request.revoke
      end
    end

    def initialize(request_attributes)
      @request_attributes = request_attributes
      @work_title = @request_attributes[:itemTitle]
      @work_pid = if ['development'].include? Rails.env
                    DamsObject.last.pid
                  else
                    @request_attributes[:subLocation]
                  end
      @email = @request_attributes[:email].presence || @request_attributes[:username]
    end

    def authorize
      return unless @email.present? && user.valid? && @work_pid.present? && work_obj
      process_request(@request_attributes.id)
      create_work_authorization
      activate_request(@request_attributes.id)
      send_email
    rescue => e # rescue all errors to handle them manually
      work_authorization.update_error 'Unable to Authorize Request'
      raise e
    end

    def revoke
      return unless user && work_obj
      delete_work_authorization
      expire_request(@request_attributes.id)
    rescue => e # rescue all errors to handle them manually
      work_authorization.update_error 'Unable to Revoke Request'
      raise e
    end

    private

      def user
        return @user if @user
        @user = User.where(email: @email).first_or_initialize do |user| # only hits the do on initialize
          user.provider = 'auth_link'
          user.uid = SecureRandom.uuid
          user.ensure_authentication_token
          puts 'new user created'
        end
        @user.save
        @user
      end

      def work_obj
        return @work_obj if @work_obj
        @work_obj = DamsObject.where(pid: @work_pid).first if @work_pid
      end

      def work_authorization
        @work_authorization ||= user.work_authorizations.where(work_pid: @work_pid).first_or_create do |authorization|
          authorization.aeon_id = @request_attributes.id
          authorization.work_title = @work_title
        end
      end

      def create_work_authorization
        return unless work_authorization.valid?
        # touch to get the updated authorizations
        # disable rubocop because we run validations before calling .touch
        work_authorization.touch # rubocop:disable SkipsModelValidations
        work_obj.set_read_users([user.user_key], [user.user_key])
        work_obj.save
      end

      def delete_work_authorization
        work_authorization.destroy
        work_obj.set_read_users([], [user.user_key])
        work_obj.save
      end

      def send_email
        AuthMailer.send_link(user).deliver_later
      end

      def process_request(request_id)
        Aeon::Request.find(request_id).set_to_processing
      end

      def expire_request(request_id)
        Aeon::Request.find(request_id).set_to_expired
      end

      def activate_request(request_id)
        Aeon::Request.find(request_id).set_to_active
      end
  end
end
