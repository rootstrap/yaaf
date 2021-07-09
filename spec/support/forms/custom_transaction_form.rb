class CustomTransactionForm < YAAF::Form
  delegate :transaction, to: User
end
