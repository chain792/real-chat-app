class TextMessage < Message
  searchkick

  validates :body, presence: true
end
