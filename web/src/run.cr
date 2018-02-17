require "kemal"
require "sqlite3"
Kemal.config.port=80
get "/" do
  title="哪吒"
  render "src/views/home.ecr","src/views/layouts/base.ecr"
end

get "/profile/:name" do |env|
  name=env.params.url["name"]
  title="用户档案"
  render "src/views/profile.ecr","src/views/layouts/base.ecr"
end

get "/users" do
  name="ok"
  users=""
  DB.open "sqlite3://../db" do |db|
    db.query "select id,username from users" do |rs|
      name=rs.column_name(1)
      users=rs
    end
  end
  title="用户列表"
  render "src/views/users.ecr","src/views/layouts/base.ecr"
end

error 404 do
  title="404"
  render "src/views/404.ecr","src/views/layouts/base.ecr"
end

post "/upload" do |env|
  file = env.params.files["upload"]
  filename = file.filename
  # Be sure to check if file.filename is not empty otherwise it'll raise a compile time error
  if !filename.is_a?(String)
    p "No filename included in upload"
  else
    file_path = ::File.join [Kemal.config.public_folder, "uploads/", filename]
    File.open(file_path, "w") do |f|
      IO.copy(file.tmpfile, f)
    end
    "http://nezha.pro/uploads/#{filename}"
  end
end

get "/upload" do
  title="上传图片"
  render "src/views/upload.ecr","src/views/layouts/base.ecr"
end

get "/login" do
  title="登录"
  render "src/views/login.ecr","src/views/layouts/base.ecr"
end

post "/api/login" do |env|
  username = env.params.body["username"].as(String)
  password = env.params.body["password"].as(String)

  msg=""
  err=false

  DB.open "sqlite3://../db" do |db|
    sql="select id,password from users where username='#{username}'"

    int=0
    msg=""
    user_password=""
    db.query sql do |rs|
      #puts "#{rs.column_name(0)} #{rs.column_name(1)} #{rs.column_name(2)}"
      rs.each do
        int+=1
        user_id=rs.read(Int32)
        user_password=rs.read(String)
      end
    end
    if int==1
      err=false
      if user_password==password
        msg="登录成功"
      else
        err=true
        msg="密码错误"
      end
    else
      err=true
      msg="用户不存在！"
    end

  end
  env.response.content_type = "application/json"
  {err: err,msg: msg}.to_json
end


get "/register" do
  title="注册"
  render "src/views/register.ecr","src/views/layouts/base.ecr"
end

post "/api/register" do |env|
  username = env.params.body["username"].as(String)
  password = env.params.body["password"].as(String)

  msg=""
  err=false

  DB.open "sqlite3://../db" do |db|
    sql="select id,username,password from users where username='#{username}'"

    int=0
    db.query sql do |rs|
      #puts "#{rs.column_name(0)} #{rs.column_name(1)} #{rs.column_name(2)}"
      rs.each do
        int+=1
        #puts "#{rs.read(Int32)} #{rs.read(String)} #{rs.read(String)}"
      end
    end
    if int==0

      sql="INSERT INTO users(username, password, avatar, `role`, location, bio, money)VALUES('#{username}', '#{password}', '', '', '', '', 1000);"
      db.exec sql
      puts sql
      msg="注册成功请登录"
    else
      err=true
      msg="此帐号已经被注册"
    end
  end
  env.response.content_type = "application/json"
  {err: err,msg: msg}.to_json
end

get "/about" do
  title="关于"
  render "src/views/about.ecr","src/views/layouts/base.ecr"
end

get "/list" do
  title="列表"
  render "src/views/list.ecr","src/views/layouts/base.ecr"
end

get "/news" do
  title="新鲜事"
  render "src/views/news.ecr","src/views/layouts/base.ecr"
end

get "/detail/:id" do |env|
  id=env.params.url["id"]
  title="详情"
  render "src/views/detail.ecr","src/views/layouts/base.ecr"
end

Kemal.run
