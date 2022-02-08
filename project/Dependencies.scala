import sbt._

object Dependencies {
  lazy val breeze = "org.scalanlp"             %% "breeze"           % "2.0"
  lazy val jblas  = "org.jblas"                %  "jblas"            % "1.2.5"
  lazy val log4j  = "org.apache.logging.log4j" %  "log4j-slf4j-impl" % "2.17.0"
}
