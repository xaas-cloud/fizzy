class DropSubscriptions < ActiveRecord::Migration[8.1]
  def change
    execute "
      update accesses set involvement = 'access_only'
    "
    execute "
      update accesses set involvement = 'watching'
      from (select user_id, subscribable_id as bucket_id from subscriptions) as subscriptions
      where subscriptions.user_id = accesses.user_id and subscriptions.bucket_id = accesses.bucket_id
    "

    drop_table :subscriptions
  end
end
