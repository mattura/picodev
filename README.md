# picodev
A Docker environment for PicoSystem and 32Blit development

## Installation
1) Make sure you have Docker installed
2) Clone this repo to a location of your choice:
```bash
git clone https://github.com/mattura/picodev
```
3) Build, run and execute the container as follows:

```bash
docker build . --tag picodev
docker run -d -it --name picodev --mount type=bind,source=${PWD},target=/home/dev picodev
docker exec -it picodev /bin/bash
```

## Development (in container)
1) Copy/install any projects to the directory
2) Navigate in the container:
```bash
cd /home/dev
```

### Build a PicoSystem Project
Environment variables are set for ```PICO_SDK_PATH``` and ```PICO_BOARD```, change if needed using (for example) ```-DPICO_BOARD=pico_w``` after cmake
```bash
cd (your_project)
rm -rf build.pico && mkdir build.pico && cd build.pico
cmake ..
make -j32
```

### Build a 32Blit project
```bash
cd (your_project)
rm -rf build.pico && mkdir build.pico && cd build.pico
cmake .. -DCMAKE_TOOLCHAIN_FILE=$BLIT_PATH/32blit-sdk/pico.toolchain
make -j32
```

### Finally
Come out of the container
```bash
exit
```
Check out the build folder for the .uf2 etc.


## Other Docker Commands
### Fresh start
You messed up the container? Kill it:
```bash
docker stop picodev && docker rm picodev
```
Then rebuild from the top

### No cache build (can eliminate some errors with rebuilding):
```bash
docker build --no-cache . --tag picodev
```

### Run out of docker space?
```bash
docker image prune
```
OR
```bash
docker system prune
```
