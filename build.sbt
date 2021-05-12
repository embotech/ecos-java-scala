import Dependencies._

ThisBuild / scalaVersion       := "2.12.10"
ThisBuild / crossScalaVersions := List("2.12.10", "2.13.5")
ThisBuild / version            := "0.0.1-SNAPSHOT"
ThisBuild / organization       := "io.citrine"
ThisBuild / organizationName   := "Citrine Informatics"
ThisBuild / artifactClassifier := Some(System.getProperty("os.name").replace(' ', '_'))

lazy val commonSettings = Seq(
  javah / target := sourceDirectory.value / "native" / "include",
  crossPaths := true,
  packageDoc / publishArtifact := false
)

lazy val root = (project in file("."))
  .settings(commonSettings:_*)
  .settings(
    name := "ecos",
    libraryDependencies ++= Seq(breeze, jblas, log4j)
  )
  .enablePlugins(JniNative)
