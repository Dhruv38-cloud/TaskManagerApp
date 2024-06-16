class Task < ApplicationRecord
  belongs_to :user
  
  validates :title, :state, :deadline, presence: true

  STATES = ['Backlog', 'In-progress', 'Done'].freeze
  
  before_validation :set_default_state, on: :create

  after_create :schedule_reminders

  private

  def schedule_reminders
    SendReminderJob.set(wait_until: deadline - 1.day).perform_later(id)
    SendReminderJob.set(wait_until: deadline - 1.hour).perform_later(id)
  end

  def set_default_state
    self.state ||= 'Backlog'
  end

  def self.send_daily_reminders
    tasks = Task.where("deadline = ?", 1.day.from_now)
    tasks.each do |task|
      TaskMailer.reminder_email(task).deliver_now
    end
  end

  def self.send_hourly_reminders
    tasks = Task.where("deadline = ?", 1.hour.from_now)
    tasks.each do |task|
      TaskMailer.reminder_email(task).deliver_now
    end
  end
end
