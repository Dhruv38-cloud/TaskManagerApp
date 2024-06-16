class TaskMailer < ApplicationMailer
  default from: 'notifications@yopmail.com'

  def reminder_email
    @task = params[:task]
    @user = @task.user
    mail(to: @user.email, subject: 'Task Reminder')
  end
end
