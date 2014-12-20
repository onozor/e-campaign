class User < ActiveRecord::Base
     before_save :strip_down_email
     before_create { generate_token(:auth_token) }

    #validations
    validates_presence_of :password, :length => { :in => 6..20 }, :on => :create
    EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i

    validates :first_name, :presence => true
    #validates :phone_number, :presence => true, :uniqueness => true
    validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX
    validates_presence_of :password, :on => :create

  scope :find_referers, -> { select('first_name, id, :last_name, phone_number, email, refer_id ') }
  scope :get_all, -> { select('id, first_name, :last_name, phone_number, email, refer_id') }

  has_many :refers, class_name: 'User', foreign_key: 'refer_id'
  belongs_to :referred_by, class_name: 'User', foreign_key: 'refer_id'

  attr_accessor :refer_by, :refering_list



    has_secure_password


  def prepare_user
    self.refer_by = self.referred_by.full_name.capitalize
    self.refering_list = self.refers.collect {|r| r.full_name.capitalize  }.join("<br/>").html_safe
  end

  def strip_down_email
    if self.email.present?
      self.email.strip!
      self.email.downcase!
    end
  end



     def send_password_reset
       generate_token(:password_reset_token)
       self.password_reset_sent_at = Time.zone.now
       save!
       UserMailer.password_reset(self).deliver
     end

     def send_confirmation_link
       generate_token(:confirmation_token)
       self.confirmation_token_send_at = Time.zone.now
       save!
       UserMailer.registration_confirmation(self).deliver
     end

     def generate_token(column)
       begin
         self[column] = SecureRandom.urlsafe_base64
       end while User.exists?(column => self[column])
     end

  def increment_login
   increment! :sign_in_count
  end


     def verify!
       self.registration_complete = true
       self.save
     end


     def full_name
    self.first_name + " " + self.last_name
  end

end
