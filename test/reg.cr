require "sqlite3"
DB.open "sqlite3://../db" do |db|
  username="tom"
  password="123456"
  sql="select id,username,password from users where username='#{username}'"
  #puts sql
  int=0
  db.query sql do |rs|
    #puts "#{rs.column_name(0)} #{rs.column_name(1)} #{rs.column_name(2)}"
    rs.each do
      int+=1
      #puts "#{rs.read(Int32)} #{rs.read(String)} #{rs.read(String)}"
    end
  end
  if int==0
    puts "can reg"
  else
    puts "can not reg"
  end

  puts "int:#{int}"
end
