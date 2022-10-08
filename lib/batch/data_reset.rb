class Batch::DataReset
  def self.data_reset
    # お題の投稿を全て削除
#    now = Time.current
#    Thema.where(limit: now.since(thema.limit)).delete_all
    Thema.where(limit: Time.current.beginning_of_day..Time.current.end_of_day).delete_all
    p "お題の投稿を全て削除しました"
  end
end
