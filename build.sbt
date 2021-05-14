import Dependencies._

ThisBuild / scalaVersion       := "2.12.10"
ThisBuild / crossScalaVersions := List("2.12.10", "2.13.5")
ThisBuild / version            := "0.0.2"
ThisBuild / organization       := "io.citrine"
ThisBuild / organizationName   := "Citrine Informatics"
ThisBuild / artifactClassifier := Some(System.getProperty("os.name").replace(' ', '_'))

lazy val commonSettings = Seq(
  javah / target := sourceDirectory.value / "native" / "include",
  crossPaths := true,
  packageDoc / publishArtifact := false,
  publishTo := {
    if (isSnapshot.value) {
      None
    } else {
      Some("Citrine Nexus" at "https://nexus.corp.citrine.io/repository/citrine/")
    }
  },
  publishConfiguration := publishConfiguration.value.withOverwrite(true)
)

lazy val root = (project in file("."))
  .settings(commonSettings:_*)
  .settings(
    name := "ecos",
    libraryDependencies ++= Seq(breeze, jblas, log4j)
  )
  .enablePlugins(JniNative)
