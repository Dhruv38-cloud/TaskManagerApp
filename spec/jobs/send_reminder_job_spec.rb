require 'rails_helper'

RSpec.describe SendReminderJob, type: :job do
  let(:task) { create(:task, deadline: 1.day.from_now) }

  describe '#perform' do
    context 'when the task deadline is in the future' do
      it 'sends a reminder email' do
        expect(TaskMailer).to receive_message_chain(:with, :reminder_email, :deliver_now)

        described_class.new.perform(task.id)
      end
    end

    context 'when the task deadline is in the past' do
      it 'does not send a reminder email' do
        task.update(deadline: 1.day.ago)

        expect(TaskMailer).not_to receive(:with)

        described_class.new.perform(task.id)
      end
    end

    context 'when the task does not exist' do
      it 'raises an ActiveRecord::RecordNotFound error' do
        expect {
          described_class.new.perform(-1)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
