# Robot Framework - Selenium - Chrome

Docker image for Robotframework and Selenium
with a sample test case

## Build docker image

```docker build -t robot-test .```

## Run test
```
docker run -it \
    -v $(pwd)/tests:/tests/:ro \
    -v $(pwd)/out:/out:rw \
    robot-test \
      --outputdir /out /tests
```
