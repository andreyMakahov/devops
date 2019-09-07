# Update the version in the package.json file and start a new git tag. The version variable contains the new version.
git_tag=`npm version prerelease`

#remove the 'v' prefix from the version string
version=${git_tag:1}

# Prepare the image prodution image name, with the new version.
export TAG_BASE=makakhov/nodejs
export TAG=$TAG_BASE:${version}

# Building the image (we don't nee the -f, because Dockerfile is the default):
docker build -t $TAG -f Dockerfile.production --no-cache --build-arg VERSION=$version ../

docker tag $TAG

# Adding a local tag to the new image, for the test image's FROM:
# docker tag $TAG calcolator

# Building the test image:
docker build -t nodejs-test -f Dockerfile.test --no-cache ../

# Running the test:
docker run --rm nodejs-test

# Remove the test image (cleanup)
docker rmi nodejs-test

# Push the new version back to git
git checkout master
git merge ${git_tag}
git push --follow-tags

# Push the new tested production image to a docker repository:
docker push $TAG

# [optional, based on the deployment policies] push the latest tag for this image:
# docker tag $TAG $TAG_BASE:latest
# docker push $TAG_BASE:latest
