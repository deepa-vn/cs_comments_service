class Commentable
  include Mongoid::Document

  field :commentable_type, type: String
  field :commentable_id, type: String

  has_many :comment_threads, dependent: :destroy
  has_many :subscriptions, as: :source

  attr_accessible :commentable_type, :commentable_id

  validates_presence_of :commentable_type
  validates_presence_of :commentable_id
  validates_uniqueness_of :commentable_id, scope: :commentable_type

  index [[:commentable_type, Mongo::ASCENDING], [:commentable_id, Mongo::ASCENDING]]

  def subscriptions
    Subscription.where(source_id: self.id, source_type: self.class)
  end

  def subscribers
    subscriptions.map(&:subscriber)
  end

  def to_hash(params={})
    as_document.slice(*%w[_id commentable_type commentable_id])
  end

end
