# ecos-java-scala

Scala drivers to Second Order Cone Programming (ECOS) Solver.

## LICENSE

This library is licensed under Apache. See  LICENSE for more details. ecos-java-scala project uses ecos as a submodule
which is licensed  under GNU GPL V3. See https://github.com/embotech/ecos/blob/master/COPYING for more details on
ECOS licensing. amd and ldl JNI libraries are licensed under LGPL honoring original Tim Davis's license.

## What's available in the project

 * io.citrine.ecos.NativeECOS - interface to native ecos library with `solveSocp()`
 * io.citrine.ecos.QpSolver - solves quadratic programming problem
 * io.citrine.ecos.RunECOS - example usage of NativeECOS

## Build instructions

### Prerequisites

 * Java SDK 11
 * sbt
 * cmake

### Clone submodules

After cloning this repository, remember to clone submodules:
```
git submodule update --init --recursive
```

### Generate header file

To generate `src/native/include/io_citrine_ecos_NativeECOS.h` use `javah` task from `sbt-jni`:
```
sbt javah
```

The file is committed into the repository, so you need to invoke above only after some changes in the code.

### Publish artefacts to local repository

To publish Scala 2.12 and Scala 2.13 versions to local repository invoke:
```
sbt +publishLocal
```

The above will compile native ecos library and put that into jar. Platform is added as classifier to the published jar.
For Mac OS below files will be generated:
```
${HOME}/.ivy2/local/io.citrine/ecos_2.12/0.0.1-SNAPSHOT/jars/ecos_2.12-Mac_OS_X.jar
${HOME}/.ivy2/local/io.citrine/ecos_2.13/0.0.1-SNAPSHOT/jars/ecos_2.13-Mac_OS_X.jar
```

## Supported features

+ Unconstrained quadratic minimization
+ Quadratic program with bound constraints
+ Quadratic program with L1 constraints
+ Quadratic program with equality constraints

## Usage in Scala project

Add library dependency including classifier, e.g.:
```
private val osNameClassifier = System.getProperty("os.name").replace(' ', '_')
[...]
  libraryDependencies += "io.citrine" %% "ecos" % "0.0.1-SNAPSHOT" classifier osNameClassifier
```

Native library will be loaded when instance of `NativeECOS` is created.

`io.citrine.ecos.RunECOS` contains runnable example.

## Credits

The following people have been, and are, involved in the development of ecos-java-scala:

+ Debasish Das
+ Stephen Boyd
+ Alexander Domahidi

The main technical idea behind ECOS is described in a short [paper](http://www.stanford.edu/~boyd/papers/ecos.html). 
More details are given in Alexander Domahidi's [PhD Thesis](http://e-collection.library.ethz.ch/view/eth:7611?q=domahidi)
in Chapter 9.
