require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:user) { create(:user) }
  let(:task) { create(:task, user: user) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'assigns all tasks to @tasks' do
      task
      get :index
      expect(assigns(:tasks)).to eq([task])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested task to @task' do
      get :show, params: { id: task.id }
      expect(assigns(:task)).to eq(task)
    end
  end

  describe 'GET #new' do
    it 'assigns a new task to @task' do
      get :new
      expect(assigns(:task)).to be_a_new(Task)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested task to @task' do
      get :edit, params: { id: task.id }
      expect(assigns(:task)).to eq(task)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new task' do
        expect {
          post :create, params: { task: attributes_for(:task) }
        }.to change(Task, :count).by(1)
      end

      it 'redirects to the new task' do
        post :create, params: { task: attributes_for(:task) }
        expect(response).to redirect_to(Task.last)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new task' do
        expect {
          post :create, params: { task: attributes_for(:task, title: nil) }
        }.to_not change(Task, :count)
      end

      it 're-renders the new template' do
        post :create, params: { task: attributes_for(:task, title: nil) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the task' do
        patch :update, params: { id: task.id, task: { title: 'Updated Task' } }
        task.reload
        expect(task.title).to eq('Updated Task')
      end

      it 'redirects to the updated task' do
        patch :update, params: { id: task.id, task: { title: 'Updated Task' } }
        expect(response).to redirect_to(task)
      end
    end

    context 'with invalid attributes' do
      it 'does not update the task' do
        patch :update, params: { id: task.id, task: { title: nil } }
        task.reload
        expect(task.title).to_not eq(nil)
      end

      it 're-renders the edit template' do
        patch :update, params: { id: task.id, task: { title: nil } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the task' do
      task
      expect {
        delete :destroy, params: { id: task.id }
      }.to change(Task, :count).by(-1)
    end

    it 'redirects to tasks#index' do
      delete :destroy, params: { id: task.id }
      expect(response).to redirect_to(tasks_url)
    end
  end

  describe 'PATCH #change_state' do
    it 'updates the state of the task' do
      patch :change_state, params: { id: task.id, state: 'Completed' }
      task.reload
      expect(task.state).to eq('Completed')
    end

    it 'redirects to the task with a success notice' do
      patch :change_state, params: { id: task.id, state: 'Completed' }
      expect(response).to redirect_to(task)
      expect(flash[:notice]).to eq('Task state was successfully updated.')
    end

    it 'redirects to the task with an alert on failure' do
      allow_any_instance_of(Task).to receive(:update).and_return(false)
      patch :change_state, params: { id: task.id, state: 'Completed' }
      expect(response).to redirect_to(task)
      expect(flash[:alert]).to eq('Failed to update task state.')
    end
  end

  private

  def sign_in(user)
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end
end
