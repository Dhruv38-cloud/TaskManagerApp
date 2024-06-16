class SendReminderJob < ApplicationJob
  queue_as :default

  def perform(task_id)
    task = Task.find(task_id)

    TaskMailer.with(task: task).reminder_email.deliver_now if task.deadline > Time.now
  end
end
  