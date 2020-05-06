class News::Post < ApplicationRecord
  acts_as_paranoid
  searchkick match: :word, searchable: [:title, :slug, :content]

  validates_presence_of :title

  has_one :gallery, class_name: "General::Gallery", foreign_key: :post_id

  has_many :comments, class_name: "News::Comment"
  has_many :post_term_relationships, -> { where(object_type: "News::Post") },
           class_name: "General::TermRelationship", foreign_key: :object_id, inverse_of: :post
  has_many :terms, through: :post_term_relationships
  has_many :menus, class_name: "General::Menu"
  has_many :attachments, as: :attachable
  has_many :files, class_name: "General::File"

  belongs_to :profile, class_name: "General::Profile", optional: true
  belongs_to :post_parent, class_name: "News::Post", optional: true
  belongs_to :user, class_name: "General::User", optional: true, touch: true
  belongs_to :main_image, class_name: "General::Attachment", optional: true
  belongs_to :file_video, class_name: "General::Attachment", optional: true

  accepts_nested_attributes_for :terms
  accepts_nested_attributes_for :main_image
  accepts_nested_attributes_for :file_video
  accepts_nested_attributes_for :gallery
  after_initialize :set_status

  before_save :unique_slug, :manage_time

  scope :important, -> { where(important: true).where.not(published_at: nil).where.not(post_type: "Video").order(published_at: :desc).first(5) }
  scope :published_posts, -> { where("published_at <= ?", Time.now).where(status: ["Publicado", "Programado"]).order(published_at: :desc) }

  scope :informative_posts, -> { where(post_type: "Página Informativa") }
  scope :normal_posts, -> { where.not(post_type: "Página Informativa").where.not(post_type: "Video") }
  scope :video_gallery_posts, -> { where.not(post_type: "Página Informativa") }

  STATUS = ["Publicado", "Borrador", "Programado"]
  VISIBILITY = ["Público", "Privada"]
  FORMAT = { 0 => "Estilo normal", 1 => "Estilo rosado", 2 => "Estilo naranja" }
  TYPE = ["Corporativas", "Miscelaneos", "Conociéndonos", "Página Informativa", "Video"]
  PERMISSION = [
    "Incluyente",
    "Excluyente",
  ]

  def set_status
    self.status ||= "Publicado"
  end

  def self.posts_cached
    Rails.cache.fetch("General::Post.includes(:main_image)") { all.to_a }
  end

  def cached_users_names
    Rails.cache.fetch :user_name, :expires_in => 1.days do
      General::User.find(self.user_id).name
    end
  end

  def self.check_image(post)
    if post.main_image_id.present?
      # post.main_image.attachment
      post.main_image.attachment.variant(resize: "300x300>")
    else
      ("/assets/post_news_mini.png")
      # (root_url '/assets/post_news_mini.png')
    end
  end

  def get_relationed_posts(user)
    posts = News::Post.where(post_type: post_type).order(published_at: :desc)
    if post_type == "Página Informativa"
      relationed_posts = user.has_role?(:admin) ? posts.first(5) - [self] : posts.filter_posts(user).informative_posts.first(5) - [self]
    else
      relationed_posts = user.has_role?(:admin) ? posts.first(5) - [self] : posts.filter_posts(user).normal_posts.first(5) - [self]
    end
  end

  def get_moments_relationed_posts(user)
    News::Post.get_by_category().where.not(id: self.id).last(5)
  end

  # TODO: optimizar
  def self.filter_posts(user, important = nil)
    news = News::Post.where(profile_id: user.profile_ids).published_posts
    news = news.where(important: important) if important.present?
    news
  end

  def self.get_by_category(category = nil)
    if category == "Videos"
      self.where(post_type: "Video")
    elsif category == "Fotos"
      self.joins(:gallery)
    else
      videos = self.where(post_type: "Video").pluck(:id)
      galleries = self.joins(:gallery).pluck(:id)
      self.where(id: videos + galleries)
    end
  end

  private

  def manage_time
    if published_at.nil?
      update_attributes(published_at: Time.now)
    end
  end

  def unique_slug
    self.slug = if self.slug.blank?
                  set_slug(self.title.parameterize)
                else
                  set_slug(self.slug.parameterize)
                end
  end

  def set_slug(val)
    post_by_slug = News::Post.find_by(slug: val)
    if post_by_slug.present? && post_by_slug != self
      random_number = rand(1000..9999)
      slug_split = val.split("-")
      if slug_split[-1].match? /^[0-9]+$/
        if slug_split.count > 1
          temp = slug_split[0..-2].join("-")
        else
          temp = slug_split[0]
        end
        set_slug(temp + "-" + random_number.to_s)
      else
        set_slug(val + "-" + random_number.to_s)
      end
    else
      val
    end
  end
end
