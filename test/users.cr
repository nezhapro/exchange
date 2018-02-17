require "sqlite3"
DB.open "sqlite3://../db" do |db|
  db.query "select id,username,password from users" do |rs|
    puts "#{rs.column_name(0)} #{rs.column_name(1)} #{rs.column_name(2)}"
    rs.each do
      puts "#{rs.read(Int32)} #{rs.read(String)} #{rs.read(String)}"
    end
  end
end
