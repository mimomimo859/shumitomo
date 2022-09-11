class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "EndUser"
  belongs_to :followed, class_name: "EndUser"
  # belongs_to :followerでfollowerテーブルのfollower_idを探しにいく。
  # ただ、今回はfollowerテーブルは作成していないのと、
  # 参照してもらいたいのはfollower_idに格納されている値と同じend_user_idなので
  # class_name: "EndUser"でEndUserテーブルを参照するように定義します。


end
