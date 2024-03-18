crumb :root do
  link "Home", root_path
end

crumb :new_user_session do
  link "ログイン", new_user_session_path
  parent :root
end

crumb :new_user_registration do
  link "新規登録", new_user_registration_path
  parent :root
end

crumb :profile_index do
  link "ユーザー", profiles_path
  parent :root
end

crumb :profile_search do
  link "検索結果"
  parent :profile_index
end

crumb :profile_show do |user|
  link user.name, profile_path(user)
  parent :profile_index
end

crumb :edit_profile do |user|
  link "プロフィール編集", edit_profile_path
  parent :profile_show, user
end

crumb :edit_user_registration do |user|
  link "登録情報の編集"
  parent :profile_show, user
end

crumb :walking_route_index do
  link "散歩ルート", walking_routes_path
  parent :root
end

crumb :walking_route_search do
  link "検索結果"
  parent :walking_route_index
end

crumb :walking_route_show do |walking_route|
  link walking_route.name
  parent :walking_route_index
end

crumb :new_walking_route do
  link "散歩ルート作成", new_walking_route_path
  parent :root
end

# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).
