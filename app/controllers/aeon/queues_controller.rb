# frozen_string_literal: true
<<<<<<< HEAD
module Aeon
  class QueuesController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_user
    before_action :set_aeon_queue, only: :show

=======

module Aeon
  class QueuesController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_user

>>>>>>> general cleanup, documentation, & rubocop disables
    # GET /aeon/queues
    def index
      @aeon_queues = Aeon::Queue.all
    end

    # GET /aeon/queues/1
    def show; end

    def errors
      @errors = WorkAuthorization.in_error
    end

<<<<<<< HEAD
=======
    # rubocop:disable Layout/IndentationWidth
>>>>>>> general cleanup, documentation, & rubocop disables
    private

      # Use callbacks to share common setup or constraints between actions.
      def set_aeon_queue
        @aeon_queue = Aeon::Queue.find(params[:id])
      end

      def authorize_user
        raise CanCan::AccessDenied unless can? :create, WorkAuthorization
      end
<<<<<<< HEAD
=======
    # rubocop:enable Layout/IndentationWidth
>>>>>>> general cleanup, documentation, & rubocop disables
  end
end
