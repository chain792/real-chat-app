class SearchMessagesForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :body, :string

  validate :user_validate
  validate :address_validate

  def search
    TextMessage.search(body)
    body.present? ? TextMessage.search(body) : TextMessage.search('*')
  end
end
