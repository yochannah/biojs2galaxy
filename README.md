biojs2galaxy
============

[![NPM version](http://img.shields.io/npm/v/biojs2galaxy.svg)](https://www.npmjs.org/package/biojs2galaxy)

A fast tool to convert BioJS components into Galaxy visualization plugins.

__Warning__: This tool is in a __ALPHA__ stage. Use at your own risk.

It was tested so far with the

* [msa](https://github.com/greenify/biojs-vis-msa) component.
* [sequence](https://github.com/ljgarcia/biojs-vis-sequence)

How to add a (BioJS) Plugin
--------------------


1) Define your data types in the package.json

```
  "galaxy": {
    "datatypes": ["sequence.Fasta", "sequences", "msa.clustal"]
  }
```

2) Add the `galaxy-vis` keyword to your package.json


So your keyword list could look like this.
```
keywords = ["biojs", "galaxy-vis"]
```

3) Define a custom `galaxy.mako` (package root)

```
galaxy.getData(response){
	galaxy.el.textContent = response;
	console.log("datatype", galaxy.dataType);
});
```

4) Check whether you have defined correct [sniper](https://github.com/biojs/biojs-sniper) settings.

There are some predefined variables in the `galaxy` namespace.

* `url` raw URL to your data file
* `dataType` dataType of your file
* `config` galaxy config parameters (e.g. id)
* `meta` galaxy meta information (e.g. timestamps)
* `el` an existing div for your component
* `relativeURL` URL to your galaxy vis plugin
* `jsonURL` URL to your data file (wrapped in a JSON object - only use this if the API throws an error for the raw file

TODO: read more settings like a data provider from the package.json 

How does it work
---------------

1) Query npm: "give me all package with the "galaxy-vis tag"  
2) For every package (async)  
a) Download the package and install its dependencies  
b) Browserify the package and copy the output to /static/{{name}}  
c) Copy the js and css resources defined in the biojs sniper settings to static (http links are downloaded)  
d) Copy the `galaxy.mako` into a [mako template](https://github.com/biojs/biojs-galaxy/blob/master/template/galaxy.mako)  
e) Generate a config file based on the specified data types  

How to run
-------------

You can find a step for step example guide [here](http://www.benjamenwhite.com/2015/07/biojs2galaxy-a-step-by-step-guide/).

Install:

```
npm install -g biojs2galaxy
```

Run:

```
biojs2galaxy
```

Specify a specific output folder (default: `$(pwd)/build`

```
biojs2galaxy <folder>
```

(You need npm & node, of course)

How to use
----------

```
  Usage: biojs2galaxy [packages]

  Automated import of biojs components into galaxy

  Options:

    -h, --help             output usage information
    -V, --version          output the version number
    -v, --verbose          Increase verbosity
    -a, --all              Download all packages from npm
    -o, --output [folder]  Output folder
    -p, --path [path]      Path to local package
    -r, --remove           Clear output folder
```

#### Download packages:

```
biojs2galaxy msa,biojs-vis-sequence
```

#### Download all packages:

```
biojs2galaxy --all
```

#### Local mode (for development):

```
biojs2galaxy -p ../msa
```

How to develop
-----------

```
git clone https://github.com/biojs/biojs2galaxy
cd biojs2galaxy
npm install
node biojs2galaxy.js
```
