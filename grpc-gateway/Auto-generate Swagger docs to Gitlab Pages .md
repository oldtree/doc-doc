After you created your OpenAPI specs, you can automatically generate and publish your API documentation to Gitlab Pages using Gitlab shared runners.
Image for post
Photo by Artem Sapegin on Unsplash
Add your documentation
For the purposes of this demo, we’ll add documentation under the aptly named /documentation folder within your repo. Just add /documentation/openapi.yml from the yml spec you (hopefully) already created.
Setting up Gitlab CI
Now we need to generate and publish the documentation. To create a CI pipeline in Gitlab, simply create .gitlab-ci.yml file in the root of your repository and add the following code:

```yaml
image: node:latest

pages:
  stage: deploy
  script:
  - npm install -g redoc-cli
  - redoc-cli bundle -o public/index.html documentation/openapi.yaml
  artifacts:
    paths:
    - public
  only:
  - master
```

Let’s review the code line by line:
- Line 1: uses a Docker image with the latest Node.js installed (on shared runners you can use any images from Docker Hub)
- Line 3–4: defines the pipeline
- Line 5–7: a script to install redoc-cli (the tool to generate some nice-looking docs) and then bundle it all into a single index.html file
- Line 8–10: the path from which to publish files to Gitlab Pages
- Line 11–12: restrict running this pipeline to certain branch(es), in this case master
Now if you push your code to the master branch the pipeline will run and your documentation will be published to https://namespace.gitlab.com/group/project/. (It may take a few minutes to appear after the first deploy.)
By default anyone who has access to your project will have access to the docs, but you can also make it public if you wish to.
If you aren’t sure exactly where to find your Pages or if you want to unpublish them you can go to Settings / Pages in your project.

ref :https://medium.com/hoursofoperation/auto-generate-swagger-docs-to-gitlab-pages-ca040230df3a