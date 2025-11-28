class Account::Export < ApplicationRecord
  belongs_to :account
  has_one_attached :archive
  has_many_attached :parts

  enum :status, %w[ pending in_progress done failed ], default: :pending

  def generate_later
    GenerationJob.perform_later(self)
  end

  def generate
    in_progress!

    Generator.new(self).generate

    done!
  rescue => e
    failed!
    raise e
  end
end
