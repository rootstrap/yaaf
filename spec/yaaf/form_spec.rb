RSpec.describe YAAF::Form do
  describe '#transaction' do
    it 'is delegated to ActiveRecord::Base' do
      form = YAAF::Form.new

      expect(ActiveRecord::Base).to receive(:transaction).and_call_original

      form.transaction { User.count }
    end

    it 'can be overridden by a subclass' do
      custom_form = CustomTransactionForm.new

      expect(User).to receive(:transaction).and_call_original
      expect(ActiveRecord::Base).not_to receive(:transaction).and_call_original

      custom_form.transaction { User.count }
    end
  end
end
