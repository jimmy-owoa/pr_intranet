class ChangeCommentsToUtf8mb4 < ActiveRecord::Migration[5.2]
    def up      
      execute "ALTER DATABASE #{ActiveRecord::Base.connection.current_database} CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin"
      execute "ALTER TABLE news_comments CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
      execute "ALTER TABLE news_comments MODIFY name VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin" 
      execute "ALTER TABLE news_comments MODIFY content TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    end
    def down
      execute "ALTER DATABASE #{ActiveRecord::Base.connection.current_database} CHARACTER SET = utf8 COLLATE = utf8_bin"
      execute "ALTER TABLE news_comments CONVERT TO CHARACTER SET utf8 COLLATE utf8_bin"
      execute "ALTER TABLE news_comments MODIFY name VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin"
      execute "ALTER TABLE news_comments MODIFY content TEXT CHARACTER SET utf8 COLLATE utf8_bin"
    end
end
