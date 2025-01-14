# Continuous delivery project

This project is used to store a docker container to upload new package updates
to [Open Build Service](https://openbuildservice.org/).

It uses a predefined oscrc file which has to be hacked by environment variables
to update the user and password to give upload right to osc (OBS command line
tool).

## Disclaimer

In order to use this delivery process some conditions are required:

1. OBS project and package must already exist. The process won't create a package.
2. _.spec_ and _.changes_ file should be added to the git project or a
   [OBS _service file](https://en.opensuse.org/openSUSE:Build_Service_Concept_SourceService) should be used. Otherwise current
   _.spec_ and _.changes_ from the OBS package will be used, but this is not recommended if you want a real CD pipeline.
3. In case the git repository owns a _.spec_ and the OBS package uses a __service_ file integration, the _.spec_ file will be copied
   before the service update, applying the changes. The RPM version will still be calculated by the OBS service.
4. Build process is not currently executed, so make sure the project builds
locally (this feature might be added in the future).
5. Package version will be obtained from "Version: " in the _.spec_ file or calculated in case of the __service_ file is in use.

## How to use

These steps must be followed to run the delivery operation:

1. Pull the docker image. The image is currently stored in: <https://github.com/trento-project/continuous-delivery/pkgs/container/continuous-delivery>

```bash
docker pull ghcr.io/trento-project/continuous-delivery:main
```

2. Most scripts provided assume the presence of the following environment variables:

```bash
export OBS_USER=my-user # my obs user name
export OBS_PASS=my-pass # my obs user password
export OBS_PROJECT=my-project # obs project
export PACKAGE_NAME=my-package # package name in obs project
```

Here other optional ones:

```bash
export FOLDER=/package # used folder inside the docker container where our code is located
export TARGET_PROJECT=target-project # target project to create a submit request. If not set submission will b skipped
export TAR_NAME=my-tar # Custom tar name. Otherwise package name will be used
export CHANGESAUTHOR=myemail@company.com # email of the changes author.
```

3. Run the docker container

```bash
docker run -t -v "$(pwd):/package" -e OBS_USER=$OBS_USER -e OBS_PASS=$OBS_PASS -e OBS_PROJECT=$OBS_PROJECT -e PACKAGE_NAME=$PACKAGE_NAME ghcr.io/trento-project/continuous-delivery:main /bin/bash -c "cd /package;/scripts/upload.sh"
docker run -t -v "$(pwd):/package" -e OBS_USER=$OBS_USER -e OBS_PASS=$OBS_PASS -e OBS_PROJECT=$OBS_PROJECT -e PACKAGE_NAME=$PACKAGE_NAME ghcr.io/trento-project/continuous-delivery:main /bin/bash -c "cd /package;/scripts/submit.sh"
```

_FOLDER_ variable must match with the path used in the volume creation and last
command execution

## How to contribute

To contribute the project just update the project code and create a pull request.
After merging the code the new docker image will be created automatically.

## License

See the [LICENSE](LICENSE) notice.
