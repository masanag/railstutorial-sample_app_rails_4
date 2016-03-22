require 'spec_helper'

describe 'Micropost pages' do
  subject { page }

  let(:user) { create(:user) }
  before { sign_in user }

  describe 'micropost creation' do
    before { visit root_path }

    describe 'with invalid information' do
      it 'should not create a micropost' do
        expect { click_button 'Post' }.not_to change(Micropost, :count)
      end

      describe 'error messages' do
        before { click_button 'Post' }
        it { should have_content('error') }
        it { should have_content('0 microposts') }
      end
    end

    describe 'with valid information' do
      before { fill_in 'micropost_content', with: 'Lorem ipsum' }
      it 'should create a micropost' do
        expect { click_button 'Post' }.to change(Micropost, :count).by(1)
      end

      context 'when a micropost posted' do
        before { click_button 'Post' }

        it { should have_content('1 micropost') }
        it { should_not have_content('1 microposts') }

        context 'and another done' do
          before do
            fill_in 'micropost_content', with: 'Lorem ipusum'
            click_button 'Post'
          end
          it { should have_content('2 microposts') }
        end
      end
    end
  end

  describe 'micropost destruction' do
    before { create(:micropost, user: user) }

    describe 'as correct user' do
      before { visit root_path }

      it 'should delete a micropost' do
        expect { click_link 'delete' }.to change(Micropost, :count).by(-1)
      end
    end
  end

  describe 'micropost posted another user' do
    let(:another_user) { create(:user) }
    before do
      Micropost.delete_all
      create(:micropost, user: another_user)
      visit root_path
    end
    it { should_not have_content 'delete' }
  end
end
