require "pry-byebug"
require "sinatra"
require "sinatra/contrib/all" if development?
require "pg"

get "/tasks" do
  # Get all tasks from DB
  sql = "SELECT * FROM tasks ORDER BY modified DESC"
  @tasks = run_sql(sql)

  erb :index
end

get "/tasks/new" do
  # Render a form
  erb :new
end

post "/tasks" do
  # Persist new task to DB
  name = sql_string(params[:name])
  details = sql_string(params[:details])

  sql = "INSERT INTO tasks (name, details) VALUES (#{name}, #{details})"
  run_sql(sql)

  redirect to("/tasks")
end

get "/tasks/:id" do
  # Grab task from DB where id = :id
  @id = params[:id]

  sql = "SELECT * FROM tasks WHERE id = #{@id}"
  task = run_sql(sql)[0]

  @name = task["name"]
  @details = task["details"]

  erb :show
end

get "/tasks/:id/edit" do
  # Grab task from DB and render a form
  @id = params[:id]

  sql = "SELECT * FROM tasks WHERE id = #{@id}"
  task = run_sql(sql).first

  @name = task["name"]
  @details = task["details"]

  erb :edit

end

post "/tasks/:id" do
  # Grab params and update in DB
  id = params[:id]
  name = sql_string(params[:name])
  details = sql_string(params[:details])

  sql = "UPDATE tasks SET name = #{name}, details = #{details} WHERE id = #{id}"
  run_sql(sql)

  redirect to("/tasks")
end

post "/tasks/:id/delete" do
  # Destroy in DB
  id = params[:id]
  sql = "DELETE FROM tasks WHERE id = #{id}"
  run_sql(sql)

  redirect to("/tasks")
end



def sql_string(value)
  "'#{value.to_s.gsub("'", "''")}'"
end

def run_sql(sql)
  db = PG.connect(dbname: 'todo', host: 'localhost')
  result = db.exec(sql)
  db.close
  return result
end






# UPDATE tasks SET name = 'Test', details = 'testytest' WHERE id = 2;














