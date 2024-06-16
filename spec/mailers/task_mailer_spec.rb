require 'rails_helper'

RSpec.describe TaskMailer, type: :mailer do
  describe '#reminder_email' do
    let(:user) { create(:user, email: 'user@example.com') }
    let(:task) { create(:task, user: user, title: 'Test Task') }
    let(:mail) { TaskMailer.with(task: task).reminder_email }

    it 'renders the headers' do
      expect(mail.subject).to eq('Task Reminder')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['notifications@yopmail.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Test Task')
    end
  end
end
