ecos-java-scala
----

Java/Scala drivers to Second Order Cone Programming (ECOS) Solver and integration with Spark
Distributed Matrix Factorization

----
LICENSE

All contributions by Debasish Das copyright © 2017 Verizon, and are licensed under Apache. See 
LICENSE for more details. ecos-java-scala project uses ecos as a submodule which is licensed
under GNU GPL V3. See https://github.com/embotech/ecos/blob/master/COPYING for more details on
ECOS licensing.

----
What's available in the project

1. MacOSX and Linux JNI libraries for ECOS.
2. amd and ldl JNI libraries are licensed under LGPL honoring original Tim Davis's license
3. Java/Scala packages are licensed under Apache
   + Java driver for ECOS SocpSolver is com.github.ecos.RunECOS
   + Scala driver for Quadratic Programming Solver is com.github.ecos.optim.QpSolver

----
Build instructions: 

The published jar provides jnilib for MacOSX and Linux. For other OS change the
Makefile to generate jnilib for respective OS. make generates the OS specific
jnilib. ant javah uses build.xml to generate the JNI header. Based on the JNI header 
the native binding needs to be implemented. ant flow is useful for exposing additional
functionalities from amd, ldl and in general csparse.

----
Examples:

mvn install generates the code jar.

mvn assembly:single generates the dependency jar.

SOCP Example (Java):

The data for SOCP program is available from ecos/include/data.h

java -cp ./target/ecos-0.0.1-SNAPSHOT.jar:./target/ecos-0.0.1-SNAPSHOT-job.jar com.github.ecos.RunECOS

ECOS version2.0.2

ECOS 2.0.2 - (C) embotech GmbH, Zurich Switzerland, 2012-15. Web: www.embotech.com/ECOS

    It     pcost       dcost      gap   pres   dres    k/t    mu     step   sigma     IR    |   BT
    0  +5.230e-01  +5.230e-01  +4e+02  9e-01  4e-01  1e+00  2e+00    ---    ---    1  1  - |  -  -
    1  +1.527e+00  +2.220e+00  +1e+02  1e-01  8e-02  9e-01  6e-01  0.8028  1e-01   1  1  2 |  0  0
    2  +5.637e-01  +8.452e-01  +6e+01  4e-02  4e-02  4e-01  3e-01  0.7541  3e-01   2  2  2 |  0  0
    3  +5.296e-01  +7.411e-01  +5e+01  4e-02  4e-02  3e-01  2e-01  0.3012  4e-01   2  2  2 |  0  0
    4  +1.551e-01  +1.644e-01  +4e+00  3e-03  3e-03  2e-02  2e-02  0.9490  4e-02   2  2  2 |  0  0
    5  +1.458e-01  +1.490e-01  +2e+00  2e-03  1e-03  6e-03  1e-02  0.6057  3e-01   2  2  1 |  0  0
    6  +1.707e-01  +1.714e-01  +8e-01  5e-04  4e-04  2e-03  4e-03  0.7514  1e-01   2  1  1 |  0  0
    7  +1.894e-01  +1.894e-01  +2e-01  1e-04  1e-04  3e-04  9e-04  0.9859  2e-01   2  1  2 |  0  0
    8  +1.926e-01  +1.926e-01  +4e-03  2e-06  2e-06  5e-06  2e-05  0.9827  1e-03   2  1  1 |  0  0
    9  +1.927e-01  +1.927e-01  +6e-05  4e-08  3e-08  8e-08  3e-07  0.9835  1e-04   2  1  1 |  0  0
    10  +1.927e-01  +1.927e-01  +4e-06  2e-09  2e-09  5e-09  2e-08  0.9392  1e-03   2  1  1 |  0  0
    11  +1.927e-01  +1.927e-01  +6e-08  4e-11  3e-11  8e-11  3e-10  0.9890  6e-03   2  1  1 |  0  0
    12  +1.927e-01  +1.927e-01  +1e-09  7e-13  6e-13  1e-12  6e-12  0.9815  1e-04   2  1  1 |  0  0

OPTIMAL (within feastol=7.3e-13, reltol=5.9e-09, abstol=1.1e-09).
Runtime: 0.001540 seconds.

Quadratic Programming Examples (Scala):

java -cp ./target/ecos-0.0.1-SNAPSHOT.jar:./target/ecos-0.0.1-SNAPSHOT-job.jar com.github.ecos.optim.QpSolver 100

Generate Qp with L1 constraint (Breeze OWLQN testcase)

ECOS 2.0.2 - (C) embotech GmbH, Zurich Switzerland, 2012-15. Web: www.embotech.com/ECOS

    It     pcost       dcost      gap   pres   dres    k/t    mu     step   sigma     IR    |   BT
    0  +7.000e-08  -2.301e-01  +9e+01  8e-01  7e-01  1e+00  4e+00    ---    ---    1  1  - |  -  -
    1  -1.165e+02  -2.409e+01  +1e+01  5e+00  3e+01  1e+02  5e-01  0.9176  4e-02   2  2  2 |  0  0
    2  -1.000e+02  -3.544e+01  +2e+00  1e+00  6e+00  7e+01  8e-02  0.8371  3e-03   2  2  2 |  0  0
    3  -6.998e+01  -7.022e+01  +2e+00  2e-01  1e-01  8e-02  8e-02  0.2736  7e-01   2  2  2 |  0  0
    4  -7.046e+01  -7.026e+01  +2e-01  2e-02  5e-03  2e-01  1e-02  0.8819  3e-02   3  2  2 |  0  0
    5  -6.251e+01  -6.248e+01  +9e-03  6e-04  2e-04  3e-02  4e-04  0.9890  3e-02   3  2  2 |  0  0
    6  -6.250e+01  -6.250e+01  +1e-04  7e-06  2e-06  3e-04  5e-06  0.9890  1e-04   3  1  1 |  0  0
    7  -6.250e+01  -6.250e+01  +1e-06  8e-08  2e-08  3e-06  5e-08  0.9890  1e-04   1  1  1 |  0  0
    8  -6.250e+01  -6.250e+01  +1e-08  9e-10  2e-10  4e-08  6e-10  0.9885  1e-04   1  1  1 |  0  0

OPTIMAL (within feastol=9.0e-10, reltol=2.1e-10, abstol=1.3e-08).
Runtime: 0.000610 seconds.

Solution

    2.5000097269585586
    2.50000972695855
    2.500009726958559
    2.5000097269585475
    2.5000097269585537
    2.5000097269585533
    2.5000097269585475
    2.500009726958548
    2.500009726958555
    2.5000097269585444

Supported features

+ Unconstrained quadratic minimization
+ Quadratic program with bound constraints
+ Quadratic program with L1 constraints
+ Quadratic program with equality constraints

Spark Integration
----

Distributed Matrix Factorization is reformulated as a bi-convex optimization using alternating minimization and the
least square formulation is solved using a quadratic program powered by ECOS through com.github.ecos.QpSolver

mvn test -DwildcardSuites=com.github.ecos.factorization.ALSSuite runs the ALS tests. 

Unit tests are added for non-negativity constraints to support intepretable dimensionality reduction and topic
modeling use-cases.

ALS.setQpProblem(problem: Int) sets up specific constraints on least square objective
+ problem=1 Least square solution
+ problem=2 Least square solution with positive factors
+ problem=3 Least square solution with bounds
+ problem=4 Least square solution with probability simplex
+ problem=5 Least square solution with L1 constraint

Credits
----

The following people have been, and are, involved in the development of ecos-java-scala:

+ Debasish Das
+ Stephen Boyd
+ Alexander Domahidi

The main technical idea behind ECOS is described in a short [paper](http://www.stanford.edu/~boyd/papers/ecos.html). 
More details are given in Alexander Domahidi's [PhD Thesis](http://e-collection.library.ethz.ch/view/eth:7611?q=domahidi) in Chapter 9.

Integration of ecos-java-scala with Spark was demonstrated at [Spark Summit 2014](https://spark-summit.org/2014/quadratic-programing-solver-for-non-negative-matrix-factorization)

