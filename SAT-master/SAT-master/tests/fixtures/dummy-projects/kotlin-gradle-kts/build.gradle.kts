plugins {
    kotlin("jvm") version "2.0.21"
    jacoco
    id("org.jlleitschuh.gradle.ktlint") version "12.1.1"
}

repositories { mavenCentral() }

dependencies {
    testImplementation(kotlin("test"))
}

kotlin { jvmToolchain(17) }

tasks.test {
    useJUnitPlatform()
    finalizedBy(tasks.jacocoTestReport)
}

tasks.jacocoTestReport { reports { xml.required.set(true) } }
