## The Milky Way Project

Part of the [Zooniverse](https://www.zooniverse.org/) collection of projects, The Milky Way Project aims to measure and map our galaxy (the Milky Way), by encouraging people to look through thousands of images from the Spitzer Space Telescope. By identifying simple astronomic traits within these infrared images, we can better understand how stars form.

http://www.milkywayproject.org/


### Development

To set up a development environment for this project, first clone this repo:
```
git clone git@github.com:zooniverse/Milky-Way-Project.git
```

Then, let `npm` do the rest of the work:
````
cd Milky-Way-Project
npm install
```

Start a local server to see your work:
```
npm start
```

### Deployment

The following command will build a staging-ready version of the project, ready to deploy. It will attempt to push to an S3 bucket using `publisssh`.
```
npm run stage
```
