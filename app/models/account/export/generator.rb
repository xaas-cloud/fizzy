class Account::Export::Generator
  MODELS = [
    Access,
    ActionText::RichText,
    ActiveStorage::Attachment,
    ActiveStorage::Blob,
    ActiveStorage::VariantRecord,
    Assignment,
    Board,
    Board::Publication,
    Card,
    Card::ActivitySpike,
    Card::Engagement,
    Card::Goldness,
    Card::NotNow,
    Closure,
    Column,
    Comment,
    Entropy,
    Event,
    Filter,
    Mention,
    Notification,
    Notification::Bundle,
    Pin,
    Reaction,
    Step,
    Tag,
    Tagging,
    User,
    User::Settings,
    Watch,
    Webhook,
    Webhook::Delivery,
    Webhook::DelinquencyTracker
  ].freeze

  attr_reader :export

  def initialize(export)
    @export = export
  end

  def generate
    Current.with_account(account) do
      create_working_directory
      export_data
      export_attachments
      compress_archive
      delete_parts
    end
  ensure
    delete_working_directory
  end

  private
    attr_reader :working_directory

    delegate :account, to: :export

    def create_working_directory
      @working_directory = Dir.mktmpdir([ "account-#{account.id}-", "-export-#{export.id}" ])
    end

    def delete_working_directory
      FileUtils.remove_entry_secure(working_directory) if working_directory.present?
    end

    def export_data
      database_path = File.join(working_directory, "data.sqlite3")
      database = Account::Export::Database.new(database_path).create

      database.copy_record account
      database.copy_record account.join_code
      database.copy_records Identity.where(id: account.users.select(:identity_id))

      MODELS.each do |model|
        database.copy_records model.where(account_id: account.id)
      end

      tar_path = File.join(working_directory, "data.tar")
      Minitar::Output.tar(tar_path) do |tar|
        stat = File.stat(database_path)
        tar.add_file_simple("storage/#{Rails.env}.sqlite3", mode: stat.mode, size: stat.size, mtime: stat.mtime) do |output|
          IO.copy_stream(File.open(database_path, "rb"), output)
        end
      end

      export.parts.attach(io: File.open(tar_path, "rb"), filename: "data.part.tar", content_type: "application/x-tar")
    end


    # TODO: Iterate over every ActiveStorage::Blob where account_id = export.account.id
    # download each file and add it to a TAR file. When the TAR file exceeds 100MB in size
    # start a new TAR file and attach the previous one to export.parts. At the end attach 
    # the last TAR file.
    # Name each part like this: attachments.part.%{i}.tar
    # Each file in the tar should be stored under storage/#{Rails.env}/#{blob.key}
    def export_attachments
    end

    # TODO: Gzip the archive.tar file and re-attach it to export.archive
    def compress_archive
    end

    # TODO: Delete all parts attached to export.parts
    def delete_parts
    end
end
