module Processors
  class NewRightsProcessor
    def initialize(request_attributes)
      @request_attributes = request_attributes
    end

    def process
      puts 'begin task'
      email = @request_attributes[:email]
      work_pid = @request_attributes[:work_pid]
      work_title = DamsObject.where(pid: work_pid).first.titleValue
      if email.present? # User.email defaults to blank string; won't create a user with a blank email
        @user = User.where(email: email).first_or_initialize do |user| # only hits the do on initialize
          user.provider = 'auth_link'
          user.uid = SecureRandom::uuid
          user.ensure_authentication_token
          puts 'new user created'
        end
        if @user.valid?
          @user.save!
          if @user.work_authorizations.create(work_pid: work_pid, work_title: work_title) && @user.valid?
            puts 'work authorized'
          else
            puts 'work authorization failed'
          end
        end
      elsif email == ''
        puts 'email cannot be blank'
      else
        puts 'invalid email'
      end
      if @user && @user.valid?
        AuthMailer.send_link(@user).deliver_later
        puts 'email sent!'
        puts '>>>>>> Task succeeded!'
      else
        puts '>>>>>> TASK FAILED'
      end
    end
  end
end
