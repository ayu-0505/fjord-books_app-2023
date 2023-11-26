class ChangeAttributesToCommentsAndReports < ActiveRecord::Migration[7.0]
  def change
    # 既存のFKを削除
    remove_foreign_key :comments, :users
    remove_reference :comments, :user, index: true
    remove_foreign_key :reports, :users
    remove_reference :reports, :user, index: true

    # FKを追加
    add_reference :comments, :user, foreign_key: {on_delete: :nullify}
    add_reference :reports, :user, foreign_key: {on_delete: :nullify}
  end
end
