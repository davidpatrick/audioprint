class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids, :as => :admin
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :avatar, :profile_type_id, :account_request
  has_many :albums
  has_many :songs, :through => :albums
  has_many :orders
  has_many :addresses
  has_attached_file :avatar, PAPERCLIP_AVATAR_OPTS
  after_create :send_account_request

  def album_ids
    self.albums.collect(&:id)
  end

  def send_account_request
    return unless self.account_request
    account_type = case self.account_request
      when 3
        'Contributor'
      when 2
        'Vendor'
      when 1
        'Basic'
    end
    UserMailer.request_account(self, account_type).deliver
  end

end
