set :branch, :production

server "13.54.246.15",
  user: "deploy",
  roles: %w(app db web)
