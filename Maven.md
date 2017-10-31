# 私有Artifact/Nexus仓库配置

###Aritfact仓配配置
1. 在工程build.gradle文件中dependecies配置

        classpath "org.jfrog.buildinfo:build-info-extractor-gradle:4+"
        
        
2. 在项目（module）build.gradle文件中配置(默认已配置)

        //解决javadoc中文问题
        tasks.withType(Javadoc) {
        options.addStringOption('Xdoclint:none', '-quiet')
        options.addStringOption('encoding', 'UTF-8')
        options.addStringOption('charSet', 'UTF-8')
        }
3. 在项目（module）build.gradle文件中配置
        
        apply from:'artifactBintry.gradle'
        或则 apply from:'https://coding.net/u/zdl_411437734/p/gradle/git/raw/master/artifactBintry.gradle'
        
4. artifactBintry.gradle内容为

```
apply plugin: "com.jfrog.artifactory"
apply plugin: "maven-publish"

Properties properties = new Properties();
properties.load(project.rootProject.file('config.properties').newDataInputStream());
def ARTFACTORY_CONTEXTURL =properties.getProperty("artifactory_contextUrl")
def ARTFACTORY_REPOKEY =properties.getProperty("artifactory_repoKey")
def USER =properties.getProperty("artifactory_user")
def PWD =properties.getProperty("artifactory_password")
def ARTIFACT_ID = properties.getProperty("artifact_id")
def VERSION_NAME = properties.getProperty("version_name")
def GROUP_ID = properties.getProperty("group_id")

def packageName = GROUP_ID
def libraryVersion = VERSION_NAME


publishing {
    publications {
        aar(MavenPublication) {
            groupId packageName
            version = libraryVersion
            artifactId ARTIFACT_ID
            // Tell maven to prepare the generated “*.aar” file for publishing
            artifact("$buildDir/outputs/aar/${project.getName()}-release.aar")
            artifact androidJavadocsJar
            artifact androidSourcesJar
        }

    }
}

artifactory {
    contextUrl = ARTFACTORY_CONTEXTURL
    publish {
        repository {
            repoKey = ARTFACTORY_REPOKEY
            username = USER
            password = PWD
            maven = true
        }
        defaults {
            publications('aar')
            publishArtifacts = true

            properties = ['qa.level': 'basic', 'q.os': 'android', 'dev.team': 'core']
            publishPom = true
            maven = true
        }
    }
}


task androidJavadocs(type: Javadoc) {
    source = android.sourceSets.main.java.srcDirs
    classpath +=    project.files(android.getBootClasspath().join(File.pathSeparator))
}

task androidJavadocsJar(type: Jar, dependsOn: androidJavadocs) {
    classifier = 'javadoc'
    from androidJavadocs.destinationDir
}

task androidSourcesJar(type: Jar) {
    classifier = 'sources'
    from android.sourceSets.main.java.srcDirs
}

artifacts {
    archives androidSourcesJar
    archives androidJavadocsJar
}




```
5 . 在android studio的Terminal中输入 
  
```  
 gradle assembleRelease artifactoryPublish
```
执行成功就可以看到项目arr在你的私有仓库中。

### Nexus仓库配置

1. 在项目（module）build.gradle文件中配置

        //解决javadoc中文问题
        tasks.withType(Javadoc) {
        options.addStringOption('Xdoclint:none', '-quiet')
        options.addStringOption('encoding', 'UTF-8')
        options.addStringOption('charSet', 'UTF-8')
        }
2. 在项目（module）build.gradle文件中配置
        
        apply from:'nexusBintry.gradle'
        或则 apply from:'https://coding.net/u/zdl_411437734/p/gradle/git/raw/master/nexusBintry.gradle'

3. nexusBintry.gradle内容为

```
apply plugin: 'maven-publish'
apply plugin: 'maven'


Properties properties = new Properties();
properties.load(project.rootProject.file('config.properties').newDataInputStream());
def MAVEN_LOCAL_PATH =properties.getProperty("nexus_contextUrl")
def USER =properties.getProperty("nexus_user")
def PWD =properties.getProperty("nexus_password")
def ARTIFACT_ID = properties.getProperty("artifact_id")
def VERSION_NAME = properties.getProperty("version_name")
def GROUP_ID = properties.getProperty("group_id")



task androidJavadocs(type: Javadoc) {
    source = android.sourceSets.main.java.srcDirs
    classpath += project.files(android.getBootClasspath().join(File.pathSeparator))
}

task androidJavadocsJar(type: Jar, dependsOn: androidJavadocs) {
    classifier = 'javadoc'
    from androidJavadocs.destinationDir
}

task androidSourcesJar(type: Jar) {
    classifier = 'sources'
    from android.sourceSets.main.java.srcDirs
}

artifacts {
    archives androidSourcesJar
    archives androidJavadocsJar
}

uploadArchives {
    repositories {
        mavenDeployer {
            repository(url:MAVEN_LOCAL_PATH ){
                authentication(userName: USER, password:PWD)
            }
            pom.project {
                groupId GROUP_ID
                artifactId ARTIFACT_ID
                version VERSION_NAME
                packaging 'aar'
            }
        }
    }
}
```
4 . 在android studio的Terminal中输入 
  
```  
gradle uploadArchives
```
执行成功就可以看到项目arr在你的私有仓库中。

### config.properties文件说明
config.properties文件存放到工程跟目录和gradle.propterties同目录下
内容如下(如果放到Module目录下 请试用xxxM.gradle文件,M的意见是Module)

```
## Project-wide Gradle settings.
#
# For more details on how to configure your build environment visit
# http://www.gradle.org/docs/current/userguide/build_environment.html
#
# Specifies the JVM arguments used for the daemon process.
# The setting is particularly useful for tweaking memory settings.
# Default value: -Xmx1024m -XX:MaxPermSize=256m
# org.gradle.jvmargs=-Xmx2048m -XX:MaxPermSize=512m -XX:+HeapDumpOnOutOfMemoryError -Dfile.encoding=UTF-8
#
# When configured, Gradle will run in incubating parallel mode.
# This option should only be used with decoupled projects. More details, visit
# http://www.gradle.org/docs/current/userguide/multi_project_builds.html#sec:decoupled_projects
# org.gradle.parallel=true
#Wed Mar 29 15:10:41 CST 2017
#systemProp.http.proxyHost=127.0.0.1
org.gradle.jvmargs=-Xmx2048m -XX\:MaxPermSize\=512m -XX\:+HeapDumpOnOutOfMemoryError -Dfile.encoding\=UTF-8
#systemProp.http.proxyPort=1080
#公共参数
version_name="1.0.0"
group_id="包名"
artifact_id=项目名称
#例如
#version_name="1.0.0"
#group_id="com.etongwl.common"
#artifact_id="Common_lib"

#artifactory仓库配置
artifactory_user=用户名
artifactory_password=密码
artifactory_repoKey=仓库名称
artifactory_contextUrl=请求地址
#例如
#artifactory_user=admin
#artifactory_password=admin
#artifactory_repoKey=android-dev-local
#artifactory_contextUrl=http://xxxxxxx/artifactory

# nexus 仓库配置
nexus_user=用户名
nexus_password=密码
nexus_contextUrl=请求地址/仓库名
#例如
#nexus_user=admin
#nexus_password=admin
#nexus_contextUrl=http://xxxxx:8081/nexus/content/repositories/releases/




#sonar配置
systemProp.sonar.host.url=http://192.168.0.251:9000
sonar_projectBaseDir=
sonar_user=用户名
sonar_password=密码
sonar_host_url=地址
sonar_sources=源码路径
sonar_projectKey=项目key
sonar_projectName=项目名称
sonar_projectVersion=项目版本
#例如
#sonarqube {
#     properties {
#         property "sonar.projectBaseDir", "${project.rootDir}/${project.name}/"
#         property "sonar.host.url", "http://192.168.0.251:9000"
#         property "sonar.login", "admin"
#         property "sonar.password", "admin"
#         property "sonar.exclusions", "**/exclude/**"
#         property "sonar.sources", "${project.rootDir}/${project.name}/src/main/java"
#         property "sonar.binaries", "$project.buildDir/intermediates/classes/"
#         property "sonar.projectKey", "sdk:${project.name}"
#         property "sonar.projectName", project.name
#         property "sonar.projectVersion", "1.0.0"
#         property "sonar.projectDescription", project.name
#         property "sonar.scm.disabled",true
#     }
# }
```
### 仓库引用
1. 在工程buid.gradle文件中配置如下内容

```
allprojects {
    repositories {
        jcenter()
        maven { url "http://xxxxxx"}
        maven { url 'http://xxxx:8081/nexus/content/repositories/releases/'}
        //maven { url 'http://api.oue-app.com/artifactory/libs-release-local/'}
    }
}
```
项目中就可以正常使用了



个人博客：[使用Artifactory搭建本地maven仓库](http://www.zdltech.com/blogphp/archives/1266.html)

