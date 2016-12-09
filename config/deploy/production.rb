set :branch, :production

server "13.54.130.131",
  user: "deploy",
  roles: %w(app db web)
