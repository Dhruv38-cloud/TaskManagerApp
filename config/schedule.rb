every 1.day, at: '9:00 am' do
  runner "Task.send_daily_reminders"
end

every 1.hour do
  runner "Task.send_hourly_reminders"
end
  