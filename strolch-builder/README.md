# strolch-docker
The strolch-builder container contains everything you need to build Strolch projects.

Pull the image:

    docker pull strolchli/strolch-builder:latest

Or you can build this image:

    git clone git@github.com:strolch-li/strolch-docker.git
    cd strolch-docker
    docker build -t strolchli/strolch-builder:latest 

Then build your project:

    cd /my/project/
    docker run --user "$(id -u):$(id -g)" --rm -it -v $HOME/.m2/repository:/m2/repository -v $(pwd):/src strolch-builder mvn clean package -DskipTests

