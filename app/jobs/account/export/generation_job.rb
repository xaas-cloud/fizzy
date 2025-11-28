class Account::Export::GenerationJob < ApplicationJob
  include ActiveJob::Continuable

  def perform(export)
    export.in_progress!

    step :create_blob { export.create_blob }
    step :create_database { export.create_database }

    export.done!
  rescue => e
    export.failed!
    raise e
  end

  private
    def create_database
    end
end
