class TextMessage < Message
  validates :body, presence: true
end
