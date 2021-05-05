### On Unix, build the current Jenkins image and push it to public docker registry
docker buildx build --platform linux/arm64,linux/arm/v7 --push -t sebpiller/jenkins-agent .
