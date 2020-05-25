
group "default" {
  targets = ["caddy", "builder"]
}

target "caddy" {
  context = "./"
  dockerfile = "Dockerfile"
  output = ["type=registry"]
  driver = "docker-container"
  tags = ["docker.io/paullj1/caddy:latest",
          "docker.io/paullj1/caddy:2.0.0" ]
  platforms = ["linux/amd64", "linux/arm64", "linux/arm/v7"]
}

target "builder" {
  context = "./builder/"
  dockerfile = "Dockerfile"
  output = ["type=registry"]
  driver = "docker-container"
  tags = ["docker.io/paullj1/caddy:builder"]
  platforms = ["linux/amd64", "linux/arm64", "linux/arm/v7"]
}

