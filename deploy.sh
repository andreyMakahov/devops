# Update the version in the package.json file and start a new git tag. The version variable contains the new version.
git_tag=`npm version prerelease`

echo ${git_tag}
echo '--------'

#remove the 'v' prefix from the version string
version=${git_tag:1}

echo ${version}
echo '--------'

# Prepare the image prodution image name, with the new version.
export TAG_BASE=makakhov/nodejs
export TAG=$TAG_BASE:${version}


# add a label with the version. We're using a new file, because we are going to push the changes to git,
# and we don't want to modify the original Dockerfile.
cp Dockerfile.production Dockerfile

# Building the image (we don't nee the -f, because Dockerfile is the default):
docker build -t $TAG --no-cache --build-arg VERSION=$version .

echo $TAG
echo '--------'

# Adding a local tag to the new image, for the test image's FROM:
# docker tag $TAG calcolator

# Building the test image:
docker build -t nodejs-test -f Dockerfile.test --no-cache .

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
docker tag $TAG $BASE_TAG:latest
docker push $BASE_TAG:latest
