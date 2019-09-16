
group "default" {
  targets = ["caddy", "builder"]
}

target "caddy" {
  context = "./"
  dockerfile = "Dockerfile"
  output = ["type=registry"]
  driver = "docker-container"
  tags = ["docker.io/abiosoft/caddy:latest",
          "docker.io/abiosoft/caddy:1.0.3" ]
  platforms = ["linux/amd64", "linux/arm64", "linux/arm/v6", "linux/arm/v7"]
}

target "builder" {
  context = "./builder/"
  dockerfile = "Dockerfile"
  output = ["type=registry"]
  driver = "docker-container"
  tags = ["docker.io/abiosoft/caddy:builder"]
  platforms = ["linux/amd64", "linux/arm64", "linux/arm/v6", "linux/arm/v7"]
}

