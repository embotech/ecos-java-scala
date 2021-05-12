package io.citrine.ecos

import ch.jodersky.jni.nativeLoader

@nativeLoader("ecos0")
class NativeECOS {
  @native def EcosSolve(n: Int, m: Int, p: Int, l: Int, ncones: Int,
                        q: Array[Int],
                        Gpr: Array[Double], Gjc: Array[Int], Gir: Array[Int],
                        Apr: Array[Double], Ajc: Array[Int], Air: Array[Int],
                        c: Array[Double], h: Array[Double], b: Array[Double],
                        x: Array[Double]): Int

  @native def EcosVer(): String

  /*
   * ECOS solves Self-dual homogeneous embedding interior point implementation
   * for optimization over linear or second-order cones. ECOS does not support
   * semi-definite cones.
   *
   * [x,y,info,s,z] = ECOS(c,G,h,dims) Solves a pair of primal and dual cone
   * programs
   *
   * minimize c'*x subject to G*x + s = h s >= 0
   *
   * maximize -h'*z subject to G'*z + c = 0 z >= 0.
   *
   * The inequalities are with respect to a cone C defined as the Cartesian
   * product of N + 1 cones:
   *
   * C = C_0 x C_1 x .... x C_N x C_{N+1}.
   *
   * The first cone C_0 is the nonnegative orthant of dimension dims.l. The
   * next N cones are second order cones of dimension dims.q(1), ...,
   * dims.q(N), where a second order cone of dimension m is defined as
   *
   * { (u0, u1) in R x R^{m-1} | u0 >= ||u1||_2 }.
   *
   * Input arguments:
   *
   * c is a dense matrix of size (n,1) (column vector)
   *
   * dims is a struct with the dimensions of the components of C. It has two
   * fields. - dims.l, the dimension of the nonnegative orthant C_0, with
   * l>=0. - dims.q, a row vector of N integers with the dimensions of the
   * second order cones C_1, ..., C_N. (N >= 0 and q(1) >= 1.)
   *
   * G is a sparse matrix of size (K,n), where
   *
   * K = dims.l + dims.q(1) + ... + dims.q(N). = dims.l + sum(dims.q)
   *
   * Each column of G describes a vector
   *
   * v = ( v_0, v_1, ..., v_N+1 )
   *
   * in V = R^dims.l x R^dims.q(1) x ... x R^dims.q(N) stored as a column
   * vector
   *
   * [ v_0; v_1; ...; v_N+1 ].
   *
   * h is a dense matrix of size (K,1), representing a vector in V, in the
   * same format as the columns of G.
   *
   *
   * [x,y,info,s,z] = ECOS(c,G,h,dims,A,b) Solves a pair of primal and dual
   * cone programs
   *
   * minimize c'*x subject to G*x + s = h A*x = b s >= 0
   *
   * maximize -h'*z - b'*y subject to G'*z + A'*y + c = 0 z >= 0.
   *
   * where c,G,h,dims are defined as above, and A is a sparse matrix of size
   * (p,n), and b is a dense matrix of size (p,1).
   *
   * It is assumed that rank(A) = p and rank([A; G]) = n.
   *
   * Derived from jecos/matlab/ecos.m, explore the script for more details
   */

  /*
   * Primal-dual SOCP solver with equality constraints min c'*x subject to G*x
   * + s = h A*x = b s >= 0
   */
  def solveSocp(c: Array[Double], Grows: Int, Gcols: Int,
                Gdata: Array[Double], GcolPtrs: Array[Int], GrowIndices: Array[Int], h: Array[Double],
                Arows: Int, Acols: Int, Adata: Array[Double], AcolPtrs: Array[Int],
                ArowIndices: Array[Int], b: Array[Double], linear: Int, cones: Array[Int],
                x: Array[Double]): Int = {
    var m = 0 /* number of conic variables */
    var p = 0 /* number of equality constraints */
    var n1 = 0 /* number of variables */
    var n2 = 0 /* number of variables for error checking */

    if (Gdata == null) {
      if (GcolPtrs != null || GrowIndices != null || h != null) {
        throw new IllegalArgumentException("solveSocpEquality should have null Socp constraint")
      }
      m = 0
      n1 = c.length
    }
    else {
      m = Grows
      n1 = Gcols
    }

    if (Adata == null) {
      if (AcolPtrs != null || ArowIndices != null || b != null) {
        throw new IllegalArgumentException("solveSocpEquality should have null equality constraint")
      }
      p = 0
      n2 = n1
    }
    else {
      p = Arows
      n2 = Acols
    }

    if (n1 != n2) {
      throw new IllegalArgumentException("solveSocpEquality columns of A and G don't match")
    }

    /* Conic constraints */
    var numConicVariables = 0

    /* get dims['l'] */
    if (linear > 0) {
      numConicVariables += linear
    }

    if (cones.length > 0) {
      for (i <- cones.indices) {
        if (cones(i) > 0) numConicVariables += cones(i)
        else throw new IllegalArgumentException("solveSocpEquality cones should be a list of positive integers")
      }
    }

    /* check if sum(q) + l = m */
    if (numConicVariables != m) {
      throw new IllegalArgumentException("solveSocpEquality number of rows of G does not match linear + cones")
    }

    //TO DO : Add more exception handling
    EcosSolve(n1, m, p, linear, cones.length, cones, Gdata, GcolPtrs, GrowIndices, Adata, AcolPtrs, ArowIndices, c, h, b, x)
  }
}
