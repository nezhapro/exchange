require "kemal"
require "sqlite3"
Kemal.config.port=80
get "/" do
  render "src/views/home.ecr"
end

get "/profile/:name" do |env|
  name=env.params.url["name"]
  render "src/views/profile.ecr"
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
  render "src/views/users.ecr"
end

error 404 do
  render "src/views/404.ecr"
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
  render "src/views/upload.ecr"
end

Kemal.run
